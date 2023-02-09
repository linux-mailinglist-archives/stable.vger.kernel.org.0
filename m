Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4F169064F
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjBILQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjBILPq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:15:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7505356EE8;
        Thu,  9 Feb 2023 03:15:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E756EB820F2;
        Thu,  9 Feb 2023 11:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1221CC433EF;
        Thu,  9 Feb 2023 11:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941328;
        bh=Wwlb/I8iWbAt/dqNVJVL9xlCcsw0/STdjDDLmn7ZQwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FsMumW4qNxSkuIz9Gn91SntGisNTJFoyWctWbo150BZiUeNAG6n+UeVfcYhDw+xbd
         UbW6aDhiOhCYmR14YJXa4C58foUJxzofyjKey2XWJPcHzlLl9pgRn5zLXIZd8tl/XU
         2ONriXBXW3Y9qzovTUh/yNmw3n0DFRaP8HbOQd3+/Gt7MpokbkWnMi9nqX9WFaB9+i
         8CmzBZtAOibrK1HAlTR9NW4myZHTWT1sp0tFtLti9P9l6P/4S4GyTyzo30mhJizgKg
         JPXz+mVOEkB9+7qDRAa9D5Bd+feMXF7/UBkqpYBB5VTGxY01quketYKKZnns3+fbdy
         ApkmV07XppedQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, cezary.rojewski@intel.com,
        liam.r.girdwood@linux.intel.com, perex@perex.cz, tiwai@suse.com,
        brent.lu@intel.com, akihiko.odaki@gmail.com,
        ye.xingchen@zte.com.cn, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.1 07/38] ASoC: Intel: sof_ssp_amp: always set dpcm_capture for amplifiers
Date:   Thu,  9 Feb 2023 06:14:26 -0500
Message-Id: <20230209111459.1891941-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111459.1891941-1-sashal@kernel.org>
References: <20230209111459.1891941-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit b3c00316a2f847791bae395ea6dd91aa7a221471 ]

The amplifier may provide hardware support for I/V feedback, or
alternatively the firmware may generate an echo reference attached to
the SSP and dailink used for the amplifier.

To avoid any issues with invalid/NULL substreams in the latter case,
always unconditionally set dpcm_capture.

Link: https://github.com/thesofproject/linux/issues/4083
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20230119163459.2235843-5-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_ssp_amp.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/soc/intel/boards/sof_ssp_amp.c b/sound/soc/intel/boards/sof_ssp_amp.c
index 94d25aeb6e7ce..7b74f122e3400 100644
--- a/sound/soc/intel/boards/sof_ssp_amp.c
+++ b/sound/soc/intel/boards/sof_ssp_amp.c
@@ -258,13 +258,12 @@ static struct snd_soc_dai_link *sof_card_dai_links_create(struct device *dev,
 		sof_rt1308_dai_link(&links[id]);
 	} else if (sof_ssp_amp_quirk & SOF_CS35L41_SPEAKER_AMP_PRESENT) {
 		cs35l41_set_dai_link(&links[id]);
-
-		/* feedback from amplifier */
-		links[id].dpcm_capture = 1;
 	}
 	links[id].platforms = platform_component;
 	links[id].num_platforms = ARRAY_SIZE(platform_component);
 	links[id].dpcm_playback = 1;
+	/* feedback from amplifier or firmware-generated echo reference */
+	links[id].dpcm_capture = 1;
 	links[id].no_pcm = 1;
 	links[id].cpus = &cpus[id];
 	links[id].num_cpus = 1;
-- 
2.39.0

