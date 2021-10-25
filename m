Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA6ED43A1AD
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237324AbhJYTk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:40:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237095AbhJYTis (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:38:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7C6860187;
        Mon, 25 Oct 2021 19:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190492;
        bh=ddYzOgwFIFrejnNtXBrnxbPj5xiOc9ksrfh5azSPWhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRpFVB8Bn+b0I1plHaAWP2uakioKuEj9BRlWrnr3sB5QaG7rISXS7hfTqozcusTiw
         zpPHXx8OkI9fzQzNU0G6oPHQQR8yHhJR+Evy8mOT6xR/NoqvOpkSwg+woy1J16iET4
         DZmI438qmB30yYrT4e1VD7Kreb7v7tn/fu5fTG/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 71/95] ALSA: hda: intel: Allow repeatedly probing on codec configuration errors
Date:   Mon, 25 Oct 2021 21:15:08 +0200
Message-Id: <20211025191007.193392424@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit c0f1886de7e173865f1a0fa7680a1c07954a987f ]

It seems that a few recent AMD systems show the codec configuration
errors at the early boot, while loading the driver at a later stage
works magically.  Although the root cause of the error isn't clear,
it's certainly not bad to allow retrying the codec probe in such a
case if that helps.

This patch adds the capability for retrying the probe upon codec probe
errors on the certain AMD platforms.  The probe_work is changed to a
delayed work, and at the secondary call, it'll jump to the codec
probing.

Note that, not only adding the re-probing, this includes the behavior
changes in the codec configuration function.  Namely,
snd_hda_codec_configure() won't unregister the codec at errors any
longer.  Instead, its caller, azx_codec_configure() unregisters the
codecs with the probe failures *if* any codec has been successfully
configured.  If all codec probe failed, it doesn't unregister but let
it re-probed -- which is the most case we're seeing and this patch
tries to improve.

Even if the driver doesn't re-probe or give up, it will go to the
"free-all" error path, hence the leftover codecs shall be disabled /
deleted in anyway.

BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1190801
Link: https://lore.kernel.org/r/20211006141940.2897-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hda_codec.h      |  1 +
 sound/pci/hda/hda_bind.c       | 20 +++++++++++---------
 sound/pci/hda/hda_codec.c      |  1 +
 sound/pci/hda/hda_controller.c | 24 ++++++++++++++++--------
 sound/pci/hda/hda_controller.h |  2 +-
 sound/pci/hda/hda_intel.c      | 29 +++++++++++++++++++++++------
 sound/pci/hda/hda_intel.h      |  4 +++-
 7 files changed, 56 insertions(+), 25 deletions(-)

diff --git a/include/sound/hda_codec.h b/include/sound/hda_codec.h
index 73827b7d17e0..cf530e9fb5f5 100644
--- a/include/sound/hda_codec.h
+++ b/include/sound/hda_codec.h
@@ -225,6 +225,7 @@ struct hda_codec {
 #endif
 
 	/* misc flags */
+	unsigned int configured:1; /* codec was configured */
 	unsigned int in_freeing:1; /* being released */
 	unsigned int registered:1; /* codec was registered */
 	unsigned int display_power_control:1; /* needs display power */
diff --git a/sound/pci/hda/hda_bind.c b/sound/pci/hda/hda_bind.c
index 17a25e453f60..4efbcc41fdfb 100644
--- a/sound/pci/hda/hda_bind.c
+++ b/sound/pci/hda/hda_bind.c
@@ -301,29 +301,31 @@ int snd_hda_codec_configure(struct hda_codec *codec)
 {
 	int err;
 
+	if (codec->configured)
+		return 0;
+
 	if (is_generic_config(codec))
 		codec->probe_id = HDA_CODEC_ID_GENERIC;
 	else
 		codec->probe_id = 0;
 
-	err = snd_hdac_device_register(&codec->core);
-	if (err < 0)
-		return err;
+	if (!device_is_registered(&codec->core.dev)) {
+		err = snd_hdac_device_register(&codec->core);
+		if (err < 0)
+			return err;
+	}
 
 	if (!codec->preset)
 		codec_bind_module(codec);
 	if (!codec->preset) {
 		err = codec_bind_generic(codec);
 		if (err < 0) {
-			codec_err(codec, "Unable to bind the codec\n");
-			goto error;
+			codec_dbg(codec, "Unable to bind the codec\n");
+			return err;
 		}
 	}
 
+	codec->configured = 1;
 	return 0;
-
- error:
-	snd_hdac_device_unregister(&codec->core);
-	return err;
 }
 EXPORT_SYMBOL_GPL(snd_hda_codec_configure);
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 4cec1bd77e6f..6dece719be66 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -791,6 +791,7 @@ void snd_hda_codec_cleanup_for_unbind(struct hda_codec *codec)
 	snd_array_free(&codec->nids);
 	remove_conn_list(codec);
 	snd_hdac_regmap_exit(&codec->core);
+	codec->configured = 0;
 }
 EXPORT_SYMBOL_GPL(snd_hda_codec_cleanup_for_unbind);
 
diff --git a/sound/pci/hda/hda_controller.c b/sound/pci/hda/hda_controller.c
index b972d59eb1ec..3de7dc34def2 100644
--- a/sound/pci/hda/hda_controller.c
+++ b/sound/pci/hda/hda_controller.c
@@ -25,6 +25,7 @@
 #include <sound/core.h>
 #include <sound/initval.h>
 #include "hda_controller.h"
+#include "hda_local.h"
 
 #define CREATE_TRACE_POINTS
 #include "hda_controller_trace.h"
@@ -1259,17 +1260,24 @@ EXPORT_SYMBOL_GPL(azx_probe_codecs);
 int azx_codec_configure(struct azx *chip)
 {
 	struct hda_codec *codec, *next;
+	int success = 0;
 
-	/* use _safe version here since snd_hda_codec_configure() deregisters
-	 * the device upon error and deletes itself from the bus list.
-	 */
-	list_for_each_codec_safe(codec, next, &chip->bus) {
-		snd_hda_codec_configure(codec);
+	list_for_each_codec(codec, &chip->bus) {
+		if (!snd_hda_codec_configure(codec))
+			success++;
 	}
 
-	if (!azx_bus(chip)->num_codecs)
-		return -ENODEV;
-	return 0;
+	if (success) {
+		/* unregister failed codecs if any codec has been probed */
+		list_for_each_codec_safe(codec, next, &chip->bus) {
+			if (!codec->configured) {
+				codec_err(codec, "Unable to configure, disabling\n");
+				snd_hdac_device_unregister(&codec->core);
+			}
+		}
+	}
+
+	return success ? 0 : -ENODEV;
 }
 EXPORT_SYMBOL_GPL(azx_codec_configure);
 
diff --git a/sound/pci/hda/hda_controller.h b/sound/pci/hda/hda_controller.h
index 68f9668788ea..324cba13c7ba 100644
--- a/sound/pci/hda/hda_controller.h
+++ b/sound/pci/hda/hda_controller.h
@@ -41,7 +41,7 @@
 /* 24 unused */
 #define AZX_DCAPS_COUNT_LPIB_DELAY  (1 << 25)	/* Take LPIB as delay */
 #define AZX_DCAPS_PM_RUNTIME	(1 << 26)	/* runtime PM support */
-/* 27 unused */
+#define AZX_DCAPS_RETRY_PROBE	(1 << 27)	/* retry probe if no codec is configured */
 #define AZX_DCAPS_CORBRP_SELF_CLEAR (1 << 28)	/* CORBRP clears itself after reset */
 #define AZX_DCAPS_NO_MSI64      (1 << 29)	/* Stick to 32-bit MSIs */
 #define AZX_DCAPS_SEPARATE_STREAM_TAG	(1 << 30) /* capture and playback use separate stream tag */
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 4c8b281c3992..8bc27e7c0590 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -341,7 +341,8 @@ enum {
 /* quirks for AMD SB */
 #define AZX_DCAPS_PRESET_AMD_SB \
 	(AZX_DCAPS_NO_TCSEL | AZX_DCAPS_AMD_WORKAROUND |\
-	 AZX_DCAPS_SNOOP_TYPE(ATI) | AZX_DCAPS_PM_RUNTIME)
+	 AZX_DCAPS_SNOOP_TYPE(ATI) | AZX_DCAPS_PM_RUNTIME |\
+	 AZX_DCAPS_RETRY_PROBE)
 
 /* quirks for Nvidia */
 #define AZX_DCAPS_PRESET_NVIDIA \
@@ -1758,7 +1759,7 @@ static void azx_check_snoop_available(struct azx *chip)
 
 static void azx_probe_work(struct work_struct *work)
 {
-	struct hda_intel *hda = container_of(work, struct hda_intel, probe_work);
+	struct hda_intel *hda = container_of(work, struct hda_intel, probe_work.work);
 	azx_probe_continue(&hda->chip);
 }
 
@@ -1867,7 +1868,7 @@ static int azx_create(struct snd_card *card, struct pci_dev *pci,
 	}
 
 	/* continue probing in work context as may trigger request module */
-	INIT_WORK(&hda->probe_work, azx_probe_work);
+	INIT_DELAYED_WORK(&hda->probe_work, azx_probe_work);
 
 	*rchip = chip;
 
@@ -2202,7 +2203,7 @@ static int azx_probe(struct pci_dev *pci,
 #endif
 
 	if (schedule_probe)
-		schedule_work(&hda->probe_work);
+		schedule_delayed_work(&hda->probe_work, 0);
 
 	dev++;
 	if (chip->disabled)
@@ -2290,6 +2291,11 @@ static int azx_probe_continue(struct azx *chip)
 	int dev = chip->dev_index;
 	int err;
 
+	if (chip->disabled || hda->init_failed)
+		return -EIO;
+	if (hda->probe_retry)
+		goto probe_retry;
+
 	to_hda_bus(bus)->bus_probing = 1;
 	hda->probe_continued = 1;
 
@@ -2351,10 +2357,20 @@ static int azx_probe_continue(struct azx *chip)
 #endif
 	}
 #endif
+
+ probe_retry:
 	if (bus->codec_mask && !(probe_only[dev] & 1)) {
 		err = azx_codec_configure(chip);
-		if (err < 0)
+		if (err) {
+			if ((chip->driver_caps & AZX_DCAPS_RETRY_PROBE) &&
+			    ++hda->probe_retry < 60) {
+				schedule_delayed_work(&hda->probe_work,
+						      msecs_to_jiffies(1000));
+				return 0; /* keep things up */
+			}
+			dev_err(chip->card->dev, "Cannot probe codecs, giving up\n");
 			goto out_free;
+		}
 	}
 
 	err = snd_card_register(chip->card);
@@ -2384,6 +2400,7 @@ out_free:
 		display_power(chip, false);
 	complete_all(&hda->probe_wait);
 	to_hda_bus(bus)->bus_probing = 0;
+	hda->probe_retry = 0;
 	return 0;
 }
 
@@ -2409,7 +2426,7 @@ static void azx_remove(struct pci_dev *pci)
 		 * device during cancel_work_sync() call.
 		 */
 		device_unlock(&pci->dev);
-		cancel_work_sync(&hda->probe_work);
+		cancel_delayed_work_sync(&hda->probe_work);
 		device_lock(&pci->dev);
 
 		snd_card_free(card);
diff --git a/sound/pci/hda/hda_intel.h b/sound/pci/hda/hda_intel.h
index 3fb119f09040..0f39418f9328 100644
--- a/sound/pci/hda/hda_intel.h
+++ b/sound/pci/hda/hda_intel.h
@@ -14,7 +14,7 @@ struct hda_intel {
 
 	/* sync probing */
 	struct completion probe_wait;
-	struct work_struct probe_work;
+	struct delayed_work probe_work;
 
 	/* card list (for power_save trigger) */
 	struct list_head list;
@@ -30,6 +30,8 @@ struct hda_intel {
 	unsigned int freed:1; /* resources already released */
 
 	bool need_i915_power:1; /* the hda controller needs i915 power */
+
+	int probe_retry;	/* being probe-retry */
 };
 
 #endif
-- 
2.33.0



