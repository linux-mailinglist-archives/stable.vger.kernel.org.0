Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3DEB69072E
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjBILZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:25:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbjBILX5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:23:57 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853B993D1;
        Thu,  9 Feb 2023 03:19:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 11E8CCE2474;
        Thu,  9 Feb 2023 11:18:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1FFC4339B;
        Thu,  9 Feb 2023 11:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941516;
        bh=J08X2vmLDjJwWn1JAxUk9hEAOF6ohBaK+5k8gOt95zc=;
        h=From:To:Cc:Subject:Date:From;
        b=mzzj5AH8U0thFjzUzDK9oNrY0sBlD24d9vAqFLEFAHc17G0AbM5fiAFmeWagKWR42
         4MQ73eM1/bEAMvgop8o0noJYe2FDmBYFsTPrj6gYkpDWXLX13MW/+MpaYAstKBYDsV
         0zN2xXsH11cKezjYcyB+hYDrbdTYu/MPQbGc9qTC+FbqIlvZHl1gRUec0gfcbTXjYd
         coUcs1mc0NkMCEukL+IuLtsrXYVm+fBrLSe8MthgX+eILrxFjrCjzdks7ga90xigwd
         KHiL8IHwkfh4/k4/NIA5yB1dOQA0CNUqrd2bY2r7qtakghNIb//5mg/tDIbmVsPuDv
         mZ7nd+imM3JBw==
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
        brent.lu@intel.com, yong.zhi@intel.com,
        ajye_huang@compal.corp-partner.google.com, ye.xingchen@zte.com.cn,
        vamshi.krishna.gopal@intel.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 01/13] ASoC: Intel: sof_rt5682: always set dpcm_capture for amplifiers
Date:   Thu,  9 Feb 2023 06:18:19 -0500
Message-Id: <20230209111833.1892896-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 324f065cdbaba1b879a63bf07e61ca156b789537 ]

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
Link: https://lore.kernel.org/r/20230119163459.2235843-2-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_rt5682.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/intel/boards/sof_rt5682.c b/sound/soc/intel/boards/sof_rt5682.c
index 1f94fa5a15db6..5883d1fa3b7ed 100644
--- a/sound/soc/intel/boards/sof_rt5682.c
+++ b/sound/soc/intel/boards/sof_rt5682.c
@@ -704,6 +704,9 @@ static struct snd_soc_dai_link *sof_card_dai_links_create(struct device *dev,
 		links[id].num_platforms = ARRAY_SIZE(platform_component);
 		links[id].nonatomic = true;
 		links[id].dpcm_playback = 1;
+		/* feedback stream or firmware-generated echo reference */
+		links[id].dpcm_capture = 1;
+
 		links[id].no_pcm = 1;
 		links[id].cpus = &cpus[id];
 		links[id].num_cpus = 1;
-- 
2.39.0

