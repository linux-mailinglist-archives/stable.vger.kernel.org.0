Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7531E59D8A4
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237131AbiHWJWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbiHWJWI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:22:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9718E470;
        Tue, 23 Aug 2022 01:35:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CCA9B81C5A;
        Tue, 23 Aug 2022 08:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E279DC433C1;
        Tue, 23 Aug 2022 08:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243641;
        bh=R02L0ZCJjmtfN54L9LyXEzxy81yp/EaA6NDAEoEHBw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HKorO44LbLldt477PkakbJT2L6UeMncFZkaYivul+PDBQdS4b0IhQgFuGTdgrutf5
         QLNXcWDY4rasnMptv5qC+iDrraD4leI74KOcM8GBliDmEKtMt3xHqUBbDtoLDDOxIa
         NLLoYF5LglgY2WgxVjzmdCQpdy7uYpbnhC6Qtcqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Yong Zhi <yong.zhi@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 342/365] ASoC: Intel: sof_nau8825: Move quirk check to the front in late probe
Date:   Tue, 23 Aug 2022 10:04:03 +0200
Message-Id: <20220823080132.530191672@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Yong Zhi <yong.zhi@intel.com>

[ Upstream commit 5b56db90bbaf9d8581e5e6268727d8ad706555e4 ]

The sof_rt5682_quirk check was placed in the middle of
hdmi handling code, move it to the front to be consistent
with sof_rt5682.c/sof_card_late_probe().

Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Yong Zhi <yong.zhi@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220725194909.145418-11-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_nau8825.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/intel/boards/sof_nau8825.c b/sound/soc/intel/boards/sof_nau8825.c
index 97dcd204a246..9b3a2ff4d9cd 100644
--- a/sound/soc/intel/boards/sof_nau8825.c
+++ b/sound/soc/intel/boards/sof_nau8825.c
@@ -177,11 +177,6 @@ static int sof_card_late_probe(struct snd_soc_card *card)
 	struct sof_hdmi_pcm *pcm;
 	int err;
 
-	if (list_empty(&ctx->hdmi_pcm_list))
-		return -EINVAL;
-
-	pcm = list_first_entry(&ctx->hdmi_pcm_list, struct sof_hdmi_pcm, head);
-
 	if (sof_nau8825_quirk & SOF_MAX98373_SPEAKER_AMP_PRESENT) {
 		/* Disable Left and Right Spk pin after boot */
 		snd_soc_dapm_disable_pin(dapm, "Left Spk");
@@ -191,6 +186,11 @@ static int sof_card_late_probe(struct snd_soc_card *card)
 			return err;
 	}
 
+	if (list_empty(&ctx->hdmi_pcm_list))
+		return -EINVAL;
+
+	pcm = list_first_entry(&ctx->hdmi_pcm_list, struct sof_hdmi_pcm, head);
+
 	return hda_dsp_hdmi_build_controls(card, pcm->codec_dai->component);
 }
 
-- 
2.35.1



