Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A56B690648
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjBILPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:15:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjBILP2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:15:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E97855E64;
        Thu,  9 Feb 2023 03:15:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02721B820FC;
        Thu,  9 Feb 2023 11:15:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B88C433D2;
        Thu,  9 Feb 2023 11:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941316;
        bh=e5xKhM6EHuypLaXFIb6K7TSOUUobBXtWAZExTQ7ruVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=prCjN49MtYINqZnzcQX+2Wsbyq3EwqvI4xYEV7sVce6cafUgFiYJZWy/aQX2LrPxZ
         AM7jl3WflQ7WXNJIKcs4UQxoXXdJzLFgIk30BnWBW5N78kAbNqwmcKBDRHh2UlvTUx
         QnD03ycKtdRtR9owsay9eTGNf4PuWAdGdd9h+mFSKwfu+mkPZQzNTGMQM6WfwIDKVw
         X/mDGvOssObi8LtQDoVx9i+SB486ebLaNMvmBuQx47gpxO0UnefELsN21Z+lfvb5Bb
         4L8GQnA3gQWP7IZFs6XB8rIxArpkdYk89Mw7q1sYQ7ktwlh5atp5jtXVinwDw0JCBo
         RIRbxKfAGFs0A==
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
Subject: [PATCH AUTOSEL 6.1 05/38] ASoC: Intel: sof_cs42l42: always set dpcm_capture for amplifiers
Date:   Thu,  9 Feb 2023 06:14:24 -0500
Message-Id: <20230209111459.1891941-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111459.1891941-1-sashal@kernel.org>
References: <20230209111459.1891941-1-sashal@kernel.org>
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

[ Upstream commit e0a52220344ab7defe25b9cdd58fe1dc1122e67c ]

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
Link: https://lore.kernel.org/r/20230119163459.2235843-3-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_cs42l42.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/intel/boards/sof_cs42l42.c b/sound/soc/intel/boards/sof_cs42l42.c
index e38bd2831e6ac..e9d190cb13b0a 100644
--- a/sound/soc/intel/boards/sof_cs42l42.c
+++ b/sound/soc/intel/boards/sof_cs42l42.c
@@ -336,6 +336,9 @@ static int create_spk_amp_dai_links(struct device *dev,
 	links[*id].platforms = platform_component;
 	links[*id].num_platforms = ARRAY_SIZE(platform_component);
 	links[*id].dpcm_playback = 1;
+	/* firmware-generated echo reference */
+	links[*id].dpcm_capture = 1;
+
 	links[*id].no_pcm = 1;
 	links[*id].cpus = &cpus[*id];
 	links[*id].num_cpus = 1;
-- 
2.39.0

