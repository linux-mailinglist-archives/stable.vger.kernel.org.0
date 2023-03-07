Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175596AEF5D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbjCGSXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232675AbjCGSW5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:22:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2793BA64AB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:17:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8CF66150F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98F9C433D2;
        Tue,  7 Mar 2023 18:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213028;
        bh=AAigMB9buv2eyxP2EUZfwadZVDse2eF7u65PURA+p+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fYLZM6xhMzwcr8JaJjRMsEH067uTIog3WzCLnTJYxaw5/gf2TJoYXaH2Qiua8e1e7
         572cJ8y4z2diuCOMh05OXUvL+6+bLpCYotT0aQ8fnxCLkR/orGfqjFeNIi/YAH1udS
         /EKAuLVZbDuEd2/D+JWMHlSWDrT0CLaHTufUbIfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 345/885] ALSA: hda: Fix the control element identification for multiple codecs
Date:   Tue,  7 Mar 2023 17:54:39 +0100
Message-Id: <20230307170017.233558716@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaroslav Kysela <perex@perex.cz>

[ Upstream commit d045bceff5a904bd79d71dede9f927c00ce4906f ]

Some motherboards have multiple HDA codecs connected to the serial bus.
The current code may create multiple mixer controls with the almost
identical identification.

The current code use id.device field from the control element structure
to store the codec address to avoid such clashes for multiple codecs.
Unfortunately, the user space do not handle this correctly. For mixer
controls, only name and index are used for the identifiers.

This patch fixes this problem to compose the index using the codec
address as an offset in case, when the control already exists. It is
really unlikely that one codec will create 10 similar controls.

This patch adds new kernel module parameter 'ctl_dev_id' to allow
select the old behaviour, too. The CONFIG_SND_HDA_CTL_DEV_ID Kconfig
option sets the default value.

BugLink: https://github.com/alsa-project/alsa-lib/issues/294
BugLink: https://github.com/alsa-project/alsa-lib/issues/205
Fixes: 54d174031576 ("[ALSA] hda-codec - Fix connection list parsing")
Fixes: 1afe206ab699 ("ALSA: hda - Try to find an empty control index when it's occupied")
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20230202092013.4066998-1-perex@perex.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hda_codec.h      |  1 +
 sound/pci/hda/Kconfig          | 14 ++++++++++++++
 sound/pci/hda/hda_codec.c      | 13 ++++++++++---
 sound/pci/hda/hda_controller.c |  1 +
 sound/pci/hda/hda_controller.h |  1 +
 sound/pci/hda/hda_intel.c      |  5 +++++
 6 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/include/sound/hda_codec.h b/include/sound/hda_codec.h
index eba23daf2c290..bbb7805e85d8e 100644
--- a/include/sound/hda_codec.h
+++ b/include/sound/hda_codec.h
@@ -259,6 +259,7 @@ struct hda_codec {
 	unsigned int relaxed_resume:1;	/* don't resume forcibly for jack */
 	unsigned int forced_resume:1; /* forced resume for jack */
 	unsigned int no_stream_clean_at_suspend:1; /* do not clean streams at suspend */
+	unsigned int ctl_dev_id:1; /* old control element id build behaviour */
 
 #ifdef CONFIG_PM
 	unsigned long power_on_acct;
diff --git a/sound/pci/hda/Kconfig b/sound/pci/hda/Kconfig
index a8e8cf98befa1..d29d8372a3c04 100644
--- a/sound/pci/hda/Kconfig
+++ b/sound/pci/hda/Kconfig
@@ -302,6 +302,20 @@ config SND_HDA_INTEL_HDMI_SILENT_STREAM
 	  This feature can impact power consumption as resources
 	  are kept reserved both at transmitter and receiver.
 
+config SND_HDA_CTL_DEV_ID
+	bool "Use the device identifier field for controls"
+	depends on SND_HDA_INTEL
+	help
+	  Say Y to use the device identifier field for (mixer)
+	  controls (old behaviour until this option is available).
+
+	  When enabled, the multiple HDA codecs may set the device
+	  field in control (mixer) element identifiers. The use
+	  of this field is not recommended and defined for mixer controls.
+
+	  The old behaviour (Y) is obsolete and will be removed. Consider
+	  to not enable this option.
+
 endif
 
 endmenu
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 2e728aad67713..9f79c0ac2bda7 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -3389,7 +3389,12 @@ int snd_hda_add_new_ctls(struct hda_codec *codec,
 			kctl = snd_ctl_new1(knew, codec);
 			if (!kctl)
 				return -ENOMEM;
-			if (addr > 0)
+			/* Do not use the id.device field for MIXER elements.
+			 * This field is for real device numbers (like PCM) but codecs
+			 * are hidden components from the user space view (unrelated
+			 * to the mixer element identification).
+			 */
+			if (addr > 0 && codec->ctl_dev_id)
 				kctl->id.device = addr;
 			if (idx > 0)
 				kctl->id.index = idx;
@@ -3400,9 +3405,11 @@ int snd_hda_add_new_ctls(struct hda_codec *codec,
 			 * the codec addr; if it still fails (or it's the
 			 * primary codec), then try another control index
 			 */
-			if (!addr && codec->core.addr)
+			if (!addr && codec->core.addr) {
 				addr = codec->core.addr;
-			else if (!idx && !knew->index) {
+				if (!codec->ctl_dev_id)
+					idx += 10 * addr;
+			} else if (!idx && !knew->index) {
 				idx = find_empty_mixer_ctl_idx(codec,
 							       knew->name, 0);
 				if (idx <= 0)
diff --git a/sound/pci/hda/hda_controller.c b/sound/pci/hda/hda_controller.c
index 0ff286b7b66be..083df287c1a48 100644
--- a/sound/pci/hda/hda_controller.c
+++ b/sound/pci/hda/hda_controller.c
@@ -1231,6 +1231,7 @@ int azx_probe_codecs(struct azx *chip, unsigned int max_slots)
 				continue;
 			codec->jackpoll_interval = chip->jackpoll_interval;
 			codec->beep_mode = chip->beep_mode;
+			codec->ctl_dev_id = chip->ctl_dev_id;
 			codecs++;
 		}
 	}
diff --git a/sound/pci/hda/hda_controller.h b/sound/pci/hda/hda_controller.h
index f5bf295eb8307..8556031bcd68e 100644
--- a/sound/pci/hda/hda_controller.h
+++ b/sound/pci/hda/hda_controller.h
@@ -124,6 +124,7 @@ struct azx {
 	/* HD codec */
 	int  codec_probe_mask; /* copied from probe_mask option */
 	unsigned int beep_mode;
+	bool ctl_dev_id;
 
 #ifdef CONFIG_SND_HDA_PATCH_LOADER
 	const struct firmware *fw;
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 87002670c0c92..2dbc082076f69 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -119,6 +119,7 @@ static bool beep_mode[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS-1)] =
 					CONFIG_SND_HDA_INPUT_BEEP_MODE};
 #endif
 static bool dmic_detect = 1;
+static bool ctl_dev_id = IS_ENABLED(CONFIG_SND_HDA_CTL_DEV_ID) ? 1 : 0;
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for Intel HD audio interface.");
@@ -157,6 +158,8 @@ module_param(dmic_detect, bool, 0444);
 MODULE_PARM_DESC(dmic_detect, "Allow DSP driver selection (bypass this driver) "
 			     "(0=off, 1=on) (default=1); "
 		 "deprecated, use snd-intel-dspcfg.dsp_driver option instead");
+module_param(ctl_dev_id, bool, 0444);
+MODULE_PARM_DESC(ctl_dev_id, "Use control device identifier (based on codec address).");
 
 #ifdef CONFIG_PM
 static int param_set_xint(const char *val, const struct kernel_param *kp);
@@ -2278,6 +2281,8 @@ static int azx_probe_continue(struct azx *chip)
 	chip->beep_mode = beep_mode[dev];
 #endif
 
+	chip->ctl_dev_id = ctl_dev_id;
+
 	/* create codec instances */
 	if (bus->codec_mask) {
 		err = azx_probe_codecs(chip, azx_max_codecs[chip->driver_type]);
-- 
2.39.2



