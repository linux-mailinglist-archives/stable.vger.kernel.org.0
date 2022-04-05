Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB77B4F3910
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377550AbiDEL3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351455AbiDEKCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:02:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3155F73063;
        Tue,  5 Apr 2022 02:52:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB76661743;
        Tue,  5 Apr 2022 09:52:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FE9C385A2;
        Tue,  5 Apr 2022 09:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152326;
        bh=Yw9KpInkgsNYhh+OCNup/aC8fKxzxvvo6UbYxOjbCnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FAujfifh5yOVQqwUC1X9dwRkS3eNvF0/JqLRGPL7xYVczqfWLNs0hBAr8WA6rifyl
         Oru0E4ySXsV3+gl65kkPD4oqiB7+FdEJs32WGWKgx0Rb9PImyl0r98d1y7vJaXK0Df
         X5U2ebg07sj4zDwLrf0QrX3TzlvSrS53+q1m+qE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yong Wu <yong.wu@mediatek.com>,
        Joerg Roedel <jroedel@suse.de>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 735/913] media: iommu/mediatek: Return ENODEV if the device is NULL
Date:   Tue,  5 Apr 2022 09:29:57 +0200
Message-Id: <20220405070401.864562970@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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



