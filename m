Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B12B13FEAD
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391454AbgAPXbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:31:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391446AbgAPXa5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:30:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03A642072E;
        Thu, 16 Jan 2020 23:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217456;
        bh=lBs3M/eBQtkKAyTVaibiBB5vy5u2wHu0dqS51LQrUZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c57CERprLlbjFvFPEpJiQ+kASWSVkVPC+TJuyumNZc0jQ9MD4kq671T3nq9knM10V
         YY5xNO+TEKCyahSdYeCsKMmG9O2UabasVTGcI2ZIEpFMVak+BbbO4wCEtL/ayljZEe
         Wzzt2IEAQoU4KYNFKABX4hXRu7sdfWP5b7Cyzeec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yong Wu <yong.wu@mediatek.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4.19 65/84] iommu/mediatek: Correct the flush_iotlb_all callback
Date:   Fri, 17 Jan 2020 00:18:39 +0100
Message-Id: <20200116231721.261515162@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yong Wu <yong.wu@mediatek.com>

commit 2009122f1d83dd8375572661961eab1e7e86bffe upstream.

Use the correct tlb_flush_all instead of the original one.

Fixes: 4d689b619445 ("iommu/io-pgtable-arm-v7s: Convert to IOMMU API TLB sync")
Signed-off-by: Yong Wu <yong.wu@mediatek.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/mtk_iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -394,7 +394,7 @@ static size_t mtk_iommu_unmap(struct iom
 
 static void mtk_iommu_iotlb_sync(struct iommu_domain *domain)
 {
-	mtk_iommu_tlb_sync(mtk_iommu_get_m4u_data());
+	mtk_iommu_tlb_flush_all(mtk_iommu_get_m4u_data());
 }
 
 static phys_addr_t mtk_iommu_iova_to_phys(struct iommu_domain *domain,


