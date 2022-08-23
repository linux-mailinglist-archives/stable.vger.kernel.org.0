Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5442559D84D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348913AbiHWJW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350315AbiHWJVl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:21:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFF88D3C5;
        Tue, 23 Aug 2022 01:34:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3B0F614C5;
        Tue, 23 Aug 2022 08:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E395FC433C1;
        Tue, 23 Aug 2022 08:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243592;
        bh=KbyObKk7cSByvvXNFKtPxO7zqzi0cCyZ20ssVNoXFdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVZo5BgAgalAZtFPUOhQMX8cUA1j4p7qbmgukDNareRa7mZ0AiNHL19NxQerqT06S
         zbs8K3VquBzYmSogO+RT/Gfp+uunHiVvCeliEpkjaoY6yuEGzIvaSm55SK3FFFUgFC
         yq7VKRb5p1EAibvdSiVBRduYEgK6V6lzBPBfKQi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 325/365] ASoC: Intel: avs: Set max DMA segment size
Date:   Tue, 23 Aug 2022 10:03:46 +0200
Message-Id: <20220823080131.771177793@linuxfoundation.org>
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



