Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2114C99CAB
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391951AbfHVRgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:36:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391641AbfHVRY4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:24:56 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D54EB2341D;
        Thu, 22 Aug 2019 17:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494696;
        bh=3uS9lQyoU6Yp6osc9u588/LNYZs4TbYDnoCO7A9+3t4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDvR5QcFvmlkdOHg5V/U2i3mk+1keRIV/ZnsonA7s1IK99ML6AKYKnbgJK9lgurOe
         no56DoOp/WMOCqxg2oXbQINftiOQqRuGCtz9eelZzAgGU2kiUsvaMPx2s3DOeA5F8M
         LJMQTrtZSMLRwxUevsojqEv5he8J7WHixCW3RzxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 12/71] ALSA: hda - Add a generic reboot_notify
Date:   Thu, 22 Aug 2019 10:18:47 -0700
Message-Id: <20190822171727.589914608@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171726.131957995@linuxfoundation.org>
References: <20190822171726.131957995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit 871b9066027702e6e6589da0e1edd3b7dede7205 upstream.

Make codec enter D3 before rebooting or poweroff can fix the noise
issue on some laptops. And in theory it is harmless for all codecs
to enter D3 before rebooting or poweroff, let us add a generic
reboot_notify, then realtek and conexant drivers can call this
function.

Cc: stable@vger.kernel.org
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_generic.c    |   19 +++++++++++++++++++
 sound/pci/hda/hda_generic.h    |    1 +
 sound/pci/hda/patch_conexant.c |    6 +-----
 sound/pci/hda/patch_realtek.c  |   11 +----------
 4 files changed, 22 insertions(+), 15 deletions(-)

--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -5896,6 +5896,24 @@ void snd_hda_gen_free(struct hda_codec *
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
@@ -5923,6 +5941,7 @@ static const struct hda_codec_ops generi
 	.init = snd_hda_gen_init,
 	.free = snd_hda_gen_free,
 	.unsol_event = snd_hda_jack_unsol_event,
+	.reboot_notify = snd_hda_gen_reboot_notify,
 #ifdef CONFIG_PM
 	.check_power_status = snd_hda_gen_check_power_status,
 #endif
--- a/sound/pci/hda/hda_generic.h
+++ b/sound/pci/hda/hda_generic.h
@@ -323,6 +323,7 @@ int snd_hda_gen_parse_auto_config(struct
 				  struct auto_pin_cfg *cfg);
 int snd_hda_gen_build_controls(struct hda_codec *codec);
 int snd_hda_gen_build_pcms(struct hda_codec *codec);
+void snd_hda_gen_reboot_notify(struct hda_codec *codec);
 
 /* standard jack event callbacks */
 void snd_hda_gen_hp_automute(struct hda_codec *codec,
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -222,11 +222,7 @@ static void cx_auto_reboot_notify(struct
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
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -810,15 +810,6 @@ static void alc_reboot_notify(struct hda
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
@@ -4937,7 +4928,7 @@ static void alc_fixup_tpt440_dock(struct
 	struct alc_spec *spec = codec->spec;
 
 	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
-		spec->reboot_notify = alc_d3_at_reboot; /* reduce noise */
+		spec->reboot_notify = snd_hda_gen_reboot_notify; /* reduce noise */
 		spec->parse_flags = HDA_PINCFG_NO_HP_FIXUP;
 		codec->power_save_node = 0; /* avoid click noises */
 		snd_hda_apply_pincfgs(codec, pincfgs);


