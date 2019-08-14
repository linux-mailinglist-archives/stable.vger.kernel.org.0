Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC1EF8CA19
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 06:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfHNEJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 00:09:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48888 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfHNEJe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 00:09:34 -0400
Received: from [114.254.46.119] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <hui.wang@canonical.com>)
        id 1hxkbL-0000CA-Bm; Wed, 14 Aug 2019 04:09:32 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de
Cc:     stable@vger.kernel.org
Subject: [PATCH 2/2] ALSA: hda - Add a generic reboot_notify
Date:   Wed, 14 Aug 2019 12:09:08 +0800
Message-Id: <20190814040908.9758-2-hui.wang@canonical.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190814040908.9758-1-hui.wang@canonical.com>
References: <20190814040908.9758-1-hui.wang@canonical.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make codec enter D3 before rebooting or poweroff can fix the noise
issue on some laptops. And in theory it is harmless for all codecs
to enter D3 before rebooting or poweroff, let us add a generic
reboot_notify, then realtek and conexant drivers can call this
function.

Cc: stable@vger.kernel.org
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/hda_generic.c    | 19 +++++++++++++++++++
 sound/pci/hda/hda_generic.h    |  1 +
 sound/pci/hda/patch_conexant.c |  6 +-----
 sound/pci/hda/patch_realtek.c  | 11 +----------
 4 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index 8f2beb1f3ae4..5bf24fb819d2 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -6051,6 +6051,24 @@ void snd_hda_gen_free(struct hda_codec *codec)
 }
 EXPORT_SYMBOL_GPL(snd_hda_gen_free);
 
+/**
+ * snd_hda_gen_reboot_notify - Make codec enter D3 before rebooting
+ * @codec: the HDA codec
+ *
+ * This can be put as patch_ops reboot_notify function.
+ */
+void snd_hda_gen_reboot_notify(struct hda_codec *codec)
+{
+	/* Make the codec enter D3 to avoid spurious noises from the internal
+	 * speaker during (and after) reboot
+	 */
+	snd_hda_codec_set_power_to_all(codec, codec->core.afg, AC_PWRST_D3);
+	snd_hda_codec_write(codec, codec->core.afg, 0,
+			    AC_VERB_SET_POWER_STATE, AC_PWRST_D3);
+	msleep(10);
+}
+EXPORT_SYMBOL_GPL(snd_hda_gen_reboot_notify);
+
 #ifdef CONFIG_PM
 /**
  * snd_hda_gen_check_power_status - check the loopback power save state
@@ -6078,6 +6096,7 @@ static const struct hda_codec_ops generic_patch_ops = {
 	.init = snd_hda_gen_init,
 	.free = snd_hda_gen_free,
 	.unsol_event = snd_hda_jack_unsol_event,
+	.reboot_notify = snd_hda_gen_reboot_notify,
 #ifdef CONFIG_PM
 	.check_power_status = snd_hda_gen_check_power_status,
 #endif
diff --git a/sound/pci/hda/hda_generic.h b/sound/pci/hda/hda_generic.h
index 35a670a71c42..5f199dcb0d18 100644
--- a/sound/pci/hda/hda_generic.h
+++ b/sound/pci/hda/hda_generic.h
@@ -332,6 +332,7 @@ int snd_hda_gen_parse_auto_config(struct hda_codec *codec,
 				  struct auto_pin_cfg *cfg);
 int snd_hda_gen_build_controls(struct hda_codec *codec);
 int snd_hda_gen_build_pcms(struct hda_codec *codec);
+void snd_hda_gen_reboot_notify(struct hda_codec *codec);
 
 /* standard jack event callbacks */
 void snd_hda_gen_hp_automute(struct hda_codec *codec,
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 93a303676aea..14298ef45b21 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -166,11 +166,7 @@ static void cx_auto_reboot_notify(struct hda_codec *codec)
 	/* Turn the problematic codec into D3 to avoid spurious noises
 	   from the internal speaker during (and after) reboot */
 	cx_auto_turn_eapd(codec, spec->num_eapds, spec->eapds, false);
-
-	snd_hda_codec_set_power_to_all(codec, codec->core.afg, AC_PWRST_D3);
-	snd_hda_codec_write(codec, codec->core.afg, 0,
-			    AC_VERB_SET_POWER_STATE, AC_PWRST_D3);
-	msleep(10);
+	snd_hda_gen_reboot_notify(codec);
 }
 
 static void cx_auto_free(struct hda_codec *codec)
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index cb7baa65b298..a1439c9a635a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -869,15 +869,6 @@ static void alc_reboot_notify(struct hda_codec *codec)
 		alc_shutup(codec);
 }
 
-/* power down codec to D3 at reboot/shutdown; set as reboot_notify ops */
-static void alc_d3_at_reboot(struct hda_codec *codec)
-{
-	snd_hda_codec_set_power_to_all(codec, codec->core.afg, AC_PWRST_D3);
-	snd_hda_codec_write(codec, codec->core.afg, 0,
-			    AC_VERB_SET_POWER_STATE, AC_PWRST_D3);
-	msleep(10);
-}
-
 #define alc_free	snd_hda_gen_free
 
 #ifdef CONFIG_PM
@@ -5218,7 +5209,7 @@ static void alc_fixup_tpt440_dock(struct hda_codec *codec,
 	struct alc_spec *spec = codec->spec;
 
 	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
-		spec->reboot_notify = alc_d3_at_reboot; /* reduce noise */
+		spec->reboot_notify = snd_hda_gen_reboot_notify; /* reduce noise */
 		spec->parse_flags = HDA_PINCFG_NO_HP_FIXUP;
 		codec->power_save_node = 0; /* avoid click noises */
 		snd_hda_apply_pincfgs(codec, pincfgs);
-- 
2.17.1

