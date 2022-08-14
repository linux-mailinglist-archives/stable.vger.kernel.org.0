Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 522E3592476
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242424AbiHNQcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242495AbiHNQa0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:30:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2254015804;
        Sun, 14 Aug 2022 09:25:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86D6CB80B79;
        Sun, 14 Aug 2022 16:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7785EC433C1;
        Sun, 14 Aug 2022 16:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494299;
        bh=d8mo+pUCA+EwvmdxNIIz0GM6OrtFvpdgmGfI6+Xn3cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ocm0ZYBjEtzpYwQjcjl0O9BxHuuy9337KbgNPJBz3T+RGeulVmPbMO0s0pMEU9080
         40TRo1i0gkrMuR+9F2WvC9zq13+BgMXaxhAWrBIMlPJvalAagn/1F2jALgXQcVWGCb
         4RsrGLJ60fZpJwrFYouMw77VxAL0CskD/5QxdGhT1OS8bozz+U4/mfxQg77AHz4tR7
         SV2LaqEeD43UQQHQg666GxPkWm6e4UloHqTowhbrSJ/3ESvYZwhAUOC/sJPM8QXJmj
         Hx0jE7hsaG5f+rSOPWwsEsMn7p64KuMYYkg3IUGW6A8jNEQUfEVhApZ4XhuI/crV3Z
         acNk/LUVAEU1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yong Zhi <yong.zhi@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, cezary.rojewski@intel.com,
        liam.r.girdwood@linux.intel.com, peter.ujfalusi@linux.intel.com,
        yung-chuan.liao@linux.intel.com, kai.vehmanen@linux.intel.com,
        perex@perex.cz, tiwai@suse.com, mac.chiang@intel.com,
        CTLIN0@nuvoton.com, akihiko.odaki@gmail.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 20/39] ASoC: Intel: sof_nau8825: Move quirk check to the front in late probe
Date:   Sun, 14 Aug 2022 12:23:09 -0400
Message-Id: <20220814162332.2396012-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814162332.2396012-1-sashal@kernel.org>
References: <20220814162332.2396012-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 33de043b66c6..b6826d6572b8 100644
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

