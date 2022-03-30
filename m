Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851314EC1AE
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244985AbiC3Lzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344416AbiC3LxI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:53:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97310261DDC;
        Wed, 30 Mar 2022 04:48:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B88F16162F;
        Wed, 30 Mar 2022 11:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBF7C36AE3;
        Wed, 30 Mar 2022 11:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640932;
        bh=Yw9KpInkgsNYhh+OCNup/aC8fKxzxvvo6UbYxOjbCnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ukJPwQxo66ZQ8HYDWDJCCeoPDTtzB4grXjeDGQUYLE2TMQng7jShzU86DrWGMTBQo
         6hqb9iuf5Fth1gacOxOdT4wUuhEz2bng7dzYhpOsyvpmsHdBfJn81dT4AszgFNbqWc
         ilV5myNX8phBu9YmQhdHJ6mYj11QhhZOiEjKvPICmvKRR6XHDwdesHLw/AxRCSHDaK
         OG7Q9Ip4vSIoMVsVFZFcFdWUXq/DQ4nGLo7kRPGb2GFmv/dZGT7X5KYUo8OwAIDlix
         2aPsGRKbO57zJPUVYYFoxYN9h9mvrXib+krXpO5eWgH1vv67kN1wYa4+kDbponjjbm
         psm8u8608l4cA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yong Wu <yong.wu@mediatek.com>, Joerg Roedel <jroedel@suse.de>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, joro@8bytes.org,
        matthias.bgg@gmail.com, iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 12/59] media: iommu/mediatek: Return ENODEV if the device is NULL
Date:   Wed, 30 Mar 2022 07:47:44 -0400
Message-Id: <20220330114831.1670235-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114831.1670235-1-sashal@kernel.org>
References: <20220330114831.1670235-1-sashal@kernel.org>
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

From: Yong Wu <yong.wu@mediatek.com>

[ Upstream commit 2fb0feed51085db77606de9b9477c96894328809 ]

The platform device is created at:
of_platform_default_populate_init:  arch_initcall_sync
  ->of_platform_populate
        ->of_platform_device_create_pdata

When entering our probe, all the devices should be already created.
if it is null, means NODEV. Currently we don't get the fail case.
It's a minor fix, no need add fixes tags.

Signed-off-by: Yong Wu <yong.wu@mediatek.com>
Acked-by: Joerg Roedel <jroedel@suse.de>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/mtk_iommu.c    | 2 +-
 drivers/iommu/mtk_iommu_v1.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index 25b834104790..77ae20ff9b35 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -848,7 +848,7 @@ static int mtk_iommu_probe(struct platform_device *pdev)
 		plarbdev = of_find_device_by_node(larbnode);
 		if (!plarbdev) {
 			of_node_put(larbnode);
-			return -EPROBE_DEFER;
+			return -ENODEV;
 		}
 		data->larb_imu[id].dev = &plarbdev->dev;
 
diff --git a/drivers/iommu/mtk_iommu_v1.c b/drivers/iommu/mtk_iommu_v1.c
index 1467ba1e4417..68bf02f87cfd 100644
--- a/drivers/iommu/mtk_iommu_v1.c
+++ b/drivers/iommu/mtk_iommu_v1.c
@@ -604,7 +604,7 @@ static int mtk_iommu_probe(struct platform_device *pdev)
 		plarbdev = of_find_device_by_node(larbnode);
 		if (!plarbdev) {
 			of_node_put(larbnode);
-			return -EPROBE_DEFER;
+			return -ENODEV;
 		}
 		data->larb_imu[i].dev = &plarbdev->dev;
 
-- 
2.34.1

