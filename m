Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2938914E25D
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgA3Svn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:51:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:53942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730865AbgA3Son (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:44:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFEC9205F4;
        Thu, 30 Jan 2020 18:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409882;
        bh=wjHrwicYqiKxKhnPcqpsN8uJBxdY4FcFbXHeQmDRYC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZkhov2qu2BuUw2pJFVMk6RHPsQjv6vnEXrsfF5kgGj9snq7HbNRhvHhBz+oqfRwa
         QUtb0rox9GYQtINTnP7CXF4atxEEQFE9EKECr1fh3yQTFcBUOCjYgtg/GdMIZldYcu
         y+ZR93C7pBMGP1c3XpKuNPknAHC3yEqq+WP1P7zk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 070/110] iommu/dma: fix variable cookie set but not used
Date:   Thu, 30 Jan 2020 19:38:46 +0100
Message-Id: <20200130183622.809411748@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 55817b340a31951d23d1692db45522560b1d20f9 ]

The commit c18647900ec8 ("iommu/dma: Relax locking in
iommu_dma_prepare_msi()") introduced a compliation warning,

drivers/iommu/dma-iommu.c: In function 'iommu_dma_prepare_msi':
drivers/iommu/dma-iommu.c:1206:27: warning: variable 'cookie' set but
not used [-Wunused-but-set-variable]
  struct iommu_dma_cookie *cookie;
                           ^~~~~~

Fixes: c18647900ec8 ("iommu/dma: Relax locking in iommu_dma_prepare_msi()")
Signed-off-by: Qian Cai <cai@lca.pw>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/dma-iommu.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 51456e7f264f9..c68a1f072c314 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1177,7 +1177,6 @@ int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_addr)
 {
 	struct device *dev = msi_desc_to_dev(desc);
 	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
-	struct iommu_dma_cookie *cookie;
 	struct iommu_dma_msi_page *msi_page;
 	static DEFINE_MUTEX(msi_prepare_lock); /* see below */
 
@@ -1186,8 +1185,6 @@ int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_addr)
 		return 0;
 	}
 
-	cookie = domain->iova_cookie;
-
 	/*
 	 * In fact the whole prepare operation should already be serialised by
 	 * irq_domain_mutex further up the callchain, but that's pretty subtle
-- 
2.20.1



