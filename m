Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC8986584B8
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbiL1RBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235438AbiL1RAT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:00:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A7121256
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:55:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 775FEB8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA4CC433EF;
        Wed, 28 Dec 2022 16:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246538;
        bh=/y+Vk7v087Ni+nwJ0BauzIaL2SzeYzkZfsMrXZsqV5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e7/uiOSUL2qT1iIkRWhDbI2tbAXXBIk7SEVP2tl5i7vsAR+Gijcey6/7hIszCAvgN
         HmH0NdhJnupfEy+LsOBuv2CmrEwarpHRsRCAxvRxaLz+ykMwmcYvnVVv9+BlE6drPg
         AxpAUa0xUmbHOvIMOCLXi55hM8I0LNqpElNORlwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1074/1146] ALSA: hda/hdmi: fix stream-id config keep-alive for rt suspend
Date:   Wed, 28 Dec 2022 15:43:33 +0100
Message-Id: <20221228144359.407547773@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit ee0b089d660021792e4ab4dda191b097ce1e964f ]

When the new style KAE keep-alive implementation is used on compatible
Intel hardware, the clocks are maintained when codec is in D3. The
generic code in hda_cleanup_all_streams() can however interfere with
generation of audio samples in this mode, by setting the stream and
channel ids to zero.

To get full benefit of the keepalive, set the new
no_stream_clean_at_suspend quirk bit on affected Intel hardware. When
this bit is set, stream cleanup is skipped in hda_call_codec_suspend().

Special handling is needed for the case when system goes to suspend. The
stream id programming can be lost in this case. This will also cause
codec->cvt_setups to be out of sync. Handle this by implementing custom
suspend/resume handlers. If keep-alive is active for any converter, set
the quirk flags no_stream_clean_at_suspend and forced_resume. Upon
resume, keepalive programming is restored if needed.

Fixes: 15175a4f2bbb ("ALSA: hda/hdmi: add keep-alive support for ADL-P and DG2")
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20221209101822.3893675-4-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hda_codec.h  |  1 +
 sound/pci/hda/hda_codec.c  |  3 +-
 sound/pci/hda/patch_hdmi.c | 90 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 92 insertions(+), 2 deletions(-)

diff --git a/include/sound/hda_codec.h b/include/sound/hda_codec.h
index 25ec8c181688..eba23daf2c29 100644
--- a/include/sound/hda_codec.h
+++ b/include/sound/hda_codec.h
@@ -258,6 +258,7 @@ struct hda_codec {
 	unsigned int link_down_at_suspend:1; /* link down at runtime suspend */
 	unsigned int relaxed_resume:1;	/* don't resume forcibly for jack */
 	unsigned int forced_resume:1; /* forced resume for jack */
+	unsigned int no_stream_clean_at_suspend:1; /* do not clean streams at suspend */
 
 #ifdef CONFIG_PM
 	unsigned long power_on_acct;
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index b4d1e658c556..edd653ece70d 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2886,7 +2886,8 @@ static unsigned int hda_call_codec_suspend(struct hda_codec *codec)
 	snd_hdac_enter_pm(&codec->core);
 	if (codec->patch_ops.suspend)
 		codec->patch_ops.suspend(codec);
-	hda_cleanup_all_streams(codec);
+	if (!codec->no_stream_clean_at_suspend)
+		hda_cleanup_all_streams(codec);
 	state = hda_set_power_state(codec, AC_PWRST_D3);
 	update_power_acct(codec, true);
 	snd_hdac_leave_pm(&codec->core);
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 3ebe8260485b..4f2e26e67b07 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2925,6 +2925,88 @@ static void i915_pin_cvt_fixup(struct hda_codec *codec,
 	}
 }
 
+#ifdef CONFIG_PM
+static int i915_adlp_hdmi_suspend(struct hda_codec *codec)
+{
+	struct hdmi_spec *spec = codec->spec;
+	bool silent_streams = false;
+	int pin_idx, res;
+
+	res = generic_hdmi_suspend(codec);
+
+	for (pin_idx = 0; pin_idx < spec->num_pins; pin_idx++) {
+		struct hdmi_spec_per_pin *per_pin = get_pin(spec, pin_idx);
+
+		if (per_pin->silent_stream) {
+			silent_streams = true;
+			break;
+		}
+	}
+
+	if (silent_streams && spec->silent_stream_type == SILENT_STREAM_KAE) {
+		/*
+		 * stream-id should remain programmed when codec goes
+		 * to runtime suspend
+		 */
+		codec->no_stream_clean_at_suspend = 1;
+
+		/*
+		 * the system might go to S3, in which case keep-alive
+		 * must be reprogrammed upon resume
+		 */
+		codec->forced_resume = 1;
+
+		codec_dbg(codec, "HDMI: KAE active at suspend\n");
+	} else {
+		codec->no_stream_clean_at_suspend = 0;
+		codec->forced_resume = 0;
+	}
+
+	return res;
+}
+
+static int i915_adlp_hdmi_resume(struct hda_codec *codec)
+{
+	struct hdmi_spec *spec = codec->spec;
+	int pin_idx, res;
+
+	res = generic_hdmi_resume(codec);
+
+	/* KAE not programmed at suspend, nothing to do here */
+	if (!codec->no_stream_clean_at_suspend)
+		return res;
+
+	for (pin_idx = 0; pin_idx < spec->num_pins; pin_idx++) {
+		struct hdmi_spec_per_pin *per_pin = get_pin(spec, pin_idx);
+
+		/*
+		 * If system was in suspend with monitor connected,
+		 * the codec setting may have been lost. Re-enable
+		 * keep-alive.
+		 */
+		if (per_pin->silent_stream) {
+			unsigned int param;
+
+			param = snd_hda_codec_read(codec, per_pin->cvt_nid, 0,
+						   AC_VERB_GET_CONV, 0);
+			if (!param) {
+				codec_dbg(codec, "HDMI: KAE: restore stream id\n");
+				silent_stream_enable_i915(codec, per_pin);
+			}
+
+			param = snd_hda_codec_read(codec, per_pin->cvt_nid, 0,
+						   AC_VERB_GET_DIGI_CONVERT_1, 0);
+			if (!(param & (AC_DIG3_KAE << 16))) {
+				codec_dbg(codec, "HDMI: KAE: restore DIG3_KAE\n");
+				silent_stream_set_kae(codec, per_pin, true);
+			}
+		}
+	}
+
+	return res;
+}
+#endif
+
 /* precondition and allocation for Intel codecs */
 static int alloc_intel_hdmi(struct hda_codec *codec)
 {
@@ -3055,8 +3137,14 @@ static int patch_i915_adlp_hdmi(struct hda_codec *codec)
 	if (!res) {
 		spec = codec->spec;
 
-		if (spec->silent_stream_type)
+		if (spec->silent_stream_type) {
 			spec->silent_stream_type = SILENT_STREAM_KAE;
+
+#ifdef CONFIG_PM
+			codec->patch_ops.resume = i915_adlp_hdmi_resume;
+			codec->patch_ops.suspend = i915_adlp_hdmi_suspend;
+#endif
+		}
 	}
 
 	return res;
-- 
2.35.1



