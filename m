Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7683E5B8498
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiINJPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbiINJNg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:13:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59A27C1F4;
        Wed, 14 Sep 2022 02:05:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0B1461999;
        Wed, 14 Sep 2022 09:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD98DC433B5;
        Wed, 14 Sep 2022 09:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146324;
        bh=tb4tAp7Sj3S0VpVpWdMjr7EE4Pht/XijnA7UEQE7jsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dXmjhzuyOOOk53Sga+O8ISsp/ypxYRTSSC8AyqMNzm1EyoLYqBaQOGC3jR98y4Qa/
         ayYD2BdI5qfpD9PMUnI9j+bB3paoGCTD1ZCXPMWm/iMICfp46kOiCJWNNsyiqxyOEU
         yz325gNq3KGSix+EvQ27ki0LWs1E7nJnPiU9/ctpwRT7CEivg3RbitiiOESQSCOqUg
         cYjwIc6HP/jnHhwizy8H7CkACc+sEmrj7U4E6ZWCdL/eOGo3qCvv0z7Iteaki0/0jV
         s8+dg/pFgROyAsfZCHDV/PgVBTxtFJDYgLOJdKYOqbrVbHf15tQYhDlzJEtpDnE0pE
         9V8l95X053Edg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.14 3/8] ALSA: hda/sigmatel: Keep power up while beep is enabled
Date:   Wed, 14 Sep 2022 05:05:07 -0400
Message-Id: <20220914090514.471614-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090514.471614-1-sashal@kernel.org>
References: <20220914090514.471614-1-sashal@kernel.org>
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
index f7896a9ae3d65..73ce5c83e7e38 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -222,6 +222,7 @@ struct sigmatel_spec {
 
 	/* beep widgets */
 	hda_nid_t anabeep_nid;
+	bool beep_power_on;
 
 	/* SPDIF-out mux */
 	const char * const *spdif_labels;
@@ -4481,6 +4482,26 @@ static int stac_suspend(struct hda_codec *codec)
 	stac_shutup(codec);
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
@@ -4493,6 +4514,7 @@ static const struct hda_codec_ops stac_patch_ops = {
 	.unsol_event = snd_hda_jack_unsol_event,
 #ifdef CONFIG_PM
 	.suspend = stac_suspend,
+	.check_power_status = stac_check_power_status,
 #endif
 	.reboot_notify = stac_shutup,
 };
-- 
2.35.1

