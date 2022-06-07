Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05EEE5415A6
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376819AbiFGUhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377805AbiFGUeG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:34:06 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7560117F82A;
        Tue,  7 Jun 2022 11:36:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 496FACE2461;
        Tue,  7 Jun 2022 18:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D437C385A2;
        Tue,  7 Jun 2022 18:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626961;
        bh=HLX7pPoGn8AZ3p6Ae+pqSRxqIuL7yut+DcoPlzH7TiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S3wjzrUaq+C88n3ZbIbdyZFDtfxKXYkjTyAJZKZv1fPsUl8+miG/PkbiudiB9YX6y
         azSapi/Md201e5wjcBVTp+MoeYnrAgCqWIQ7yqpYX5R/4NGTzhwm1WY7n1RgaUMM5u
         FufEfXsSOGpWbmMKjrIeqnM60nX/YMpSbJm+dnlo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yong Wu <yong.wu@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 568/772] iommu/mediatek: Fix 2 HW sharing pgtable issue
Date:   Tue,  7 Jun 2022 19:02:40 +0200
Message-Id: <20220607165005.691533132@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yong Wu <yong.wu@mediatek.com>

[ Upstream commit 645b87c190c959e9bb4f216b8c4add4ee880451a ]

In the commit 4f956c97d26b ("iommu/mediatek: Move domain_finalise into
attach_device"), I overlooked the sharing pgtable case.
After that commit, the "data" in the mtk_iommu_domain_finalise always is
the data of the current IOMMU HW. Fix this for the sharing pgtable case.

Only affect mt2712 which is the only SoC that share pgtable currently.

Fixes: 4f956c97d26b ("iommu/mediatek: Move domain_finalise into attach_device")
Signed-off-by: Yong Wu <yong.wu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/r/20220503071427.2285-5-yong.wu@mediatek.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/mtk_iommu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index 5971a1168666..cf4e33db6a2d 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -451,7 +451,7 @@ static void mtk_iommu_domain_free(struct iommu_domain *domain)
 static int mtk_iommu_attach_device(struct iommu_domain *domain,
 				   struct device *dev)
 {
-	struct mtk_iommu_data *data = dev_iommu_priv_get(dev);
+	struct mtk_iommu_data *data = dev_iommu_priv_get(dev), *frstdata;
 	struct mtk_iommu_domain *dom = to_mtk_domain(domain);
 	struct device *m4udev = data->dev;
 	int ret, domid;
@@ -461,7 +461,10 @@ static int mtk_iommu_attach_device(struct iommu_domain *domain,
 		return domid;
 
 	if (!dom->data) {
-		if (mtk_iommu_domain_finalise(dom, data, domid))
+		/* Data is in the frstdata in sharing pgtable case. */
+		frstdata = mtk_iommu_get_m4u_data();
+
+		if (mtk_iommu_domain_finalise(dom, frstdata, domid))
 			return -ENODEV;
 		dom->data = data;
 	}
-- 
2.35.1



