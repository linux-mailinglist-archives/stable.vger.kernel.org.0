Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9063A5B8404
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbiINJGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbiINJFv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:05:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DBE0786F8;
        Wed, 14 Sep 2022 02:03:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82940619BD;
        Wed, 14 Sep 2022 09:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608C9C433D6;
        Wed, 14 Sep 2022 09:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146169;
        bh=ApP5aHfwt00flHGkbd48EuZBwfzU0RjCtFfNvrtur/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L8dvdWpST4s/1cBSmf4zRcZq1znaUTHTu0wUdcRkEWTuukydb3PlFJIyb9v8U3htd
         AixTWrAC7zD7lNYiclMHFlYTOdNdNitBw42iqntxDlL+S3st/i/U8a1iBIyYpGyzTT
         x8nCNOv01aeO3i+9ZRMPcCN2rvWzziLYwblCh+olI71MPB4SZrvslK5P8u+XMHE3mV
         NIyfbfo6CHG+UGwsYPJ27KPJrbcRZJ333XN4QPwXCy3JfY0JakjiiVcmq6GsQ0PcqY
         O/81qZuiXgvH3gZUpBRqFeIm4Xbftn8wvk2ZI2lL3cBtavToYMdXWP6uVDrJ6Ofgxw
         XO42VnsKXbJDQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 08/16] ALSA: hda/sigmatel: Keep power up while beep is enabled
Date:   Wed, 14 Sep 2022 05:02:16 -0400
Message-Id: <20220914090224.470913-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090224.470913-1-sashal@kernel.org>
References: <20220914090224.470913-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 414d38ba871092aeac4ed097ac4ced89486646f7 ]

It seems that the beep playback doesn't work well on IDT codec devices
when the codec auto-pm is enabled.  Keep the power on while the beep
switch is enabled.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1200544
Link: https://lore.kernel.org/r/20220904072750.26164-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_sigmatel.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 61df4d33c48ff..066bfccd25877 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -209,6 +209,7 @@ struct sigmatel_spec {
 
 	/* beep widgets */
 	hda_nid_t anabeep_nid;
+	bool beep_power_on;
 
 	/* SPDIF-out mux */
 	const char * const *spdif_labels;
@@ -4443,6 +4444,26 @@ static int stac_suspend(struct hda_codec *codec)
 
 	return 0;
 }
+
+static int stac_check_power_status(struct hda_codec *codec, hda_nid_t nid)
+{
+	struct sigmatel_spec *spec = codec->spec;
+	int ret = snd_hda_gen_check_power_status(codec, nid);
+
+#ifdef CONFIG_SND_HDA_INPUT_BEEP
+	if (nid == spec->gen.beep_nid && codec->beep) {
+		if (codec->beep->enabled != spec->beep_power_on) {
+			spec->beep_power_on = codec->beep->enabled;
+			if (spec->beep_power_on)
+				snd_hda_power_up_pm(codec);
+			else
+				snd_hda_power_down_pm(codec);
+		}
+		ret |= spec->beep_power_on;
+	}
+#endif
+	return ret;
+}
 #else
 #define stac_suspend		NULL
 #endif /* CONFIG_PM */
@@ -4455,6 +4476,7 @@ static const struct hda_codec_ops stac_patch_ops = {
 	.unsol_event = snd_hda_jack_unsol_event,
 #ifdef CONFIG_PM
 	.suspend = stac_suspend,
+	.check_power_status = stac_check_power_status,
 #endif
 };
 
-- 
2.35.1

