Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DACE9592383
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240897AbiHNQWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240819AbiHNQVi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:21:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD567140F2;
        Sun, 14 Aug 2022 09:20:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96C85B80AEE;
        Sun, 14 Aug 2022 16:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F88C433C1;
        Sun, 14 Aug 2022 16:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494007;
        bh=KbyObKk7cSByvvXNFKtPxO7zqzi0cCyZ20ssVNoXFdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fElOJ2s75zrPaFl7JONGQKtvBK1oqlr4q8F0YwsFB2B0zyHnDCoV0wBFO5VaH19X8
         p5TmUhBXEQ7KvK7WJVTKhU08PuaDnog9Pa7XdeZrCjubMuUBWw8cFUSRbp/TFC5OBC
         tv+Iw3ibqF/b06JA4ypwMOBLBKR5CcMeV6UQN/Bhp8jlW5dIqkcviuqoISXQeilI8X
         C7ogCB7xXJ8OldQiqB6F2G3AjSdvwm9Vp007bbkrk+P7m1lF5IobamYgX0czmqM0sp
         mkBFJHIIyx6hbRmm+JlAVXzhd+wFcBe/eVeg9GcRWZSamU3kT9GPkw/h95sElv7wlI
         B5x+hZE+eY1Zw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        pierre-louis.bossart@linux.intel.com,
        liam.r.girdwood@linux.intel.com, peter.ujfalusi@linux.intel.com,
        yung-chuan.liao@linux.intel.com, ranjani.sridharan@linux.intel.com,
        kai.vehmanen@linux.intel.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.19 09/48] ASoC: Intel: avs: Set max DMA segment size
Date:   Sun, 14 Aug 2022 12:19:02 -0400
Message-Id: <20220814161943.2394452-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814161943.2394452-1-sashal@kernel.org>
References: <20220814161943.2394452-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 8544eebc78c96f1834a46b26ade3e7ebe785d10c ]

Apparently it is possible for code to allocate large buffers which may
cause warnings as reported in [1]. This was fixed for HDA, SOF and
skylake in patchset [2], fix it also for avs driver.

[1] https://github.com/thesofproject/linux/issues/3430
[2] https://lore.kernel.org/all/20220215132756.31236-1-tiwai@suse.de/

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20220707124153.1858249-8-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/avs/core.c b/sound/soc/intel/avs/core.c
index 3a0997c3af2b..cf373969bb69 100644
--- a/sound/soc/intel/avs/core.c
+++ b/sound/soc/intel/avs/core.c
@@ -445,6 +445,7 @@ static int avs_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 		dma_set_mask(dev, DMA_BIT_MASK(32));
 		dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
 	}
+	dma_set_max_seg_size(dev, UINT_MAX);
 
 	ret = avs_hdac_bus_init_streams(bus);
 	if (ret < 0) {
-- 
2.35.1

