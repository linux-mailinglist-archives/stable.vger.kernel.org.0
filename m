Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C932E4197
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438533AbgL1OHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:07:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:42274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438530AbgL1OHr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:07:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99B67206D4;
        Mon, 28 Dec 2020 14:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164427;
        bh=ILd5HK2o1fyL/VtjzVg7wVZsVWz5aoSSOlNatR8ogV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DJlwwE/jJElcJp9tqrGsR5D31Ny/2xR7E1/Bb0KdFTIyrI0EOQuVQ7HkB8cdN50x0
         eOAc0+Uwauesx1iA9/hbCiBMvhtbT9Nytluyf8GaAEej6gO3gvKTfS38eOw+c52q/M
         nnVu6vCvI/LU56wndlSPu8H7kGRebzihnprmw87Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 146/717] iommu/vt-d: include conditionally on CONFIG_INTEL_IOMMU_SVM
Date:   Mon, 28 Dec 2020 13:42:24 +0100
Message-Id: <20201228125027.957807088@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

[ Upstream commit 68dd9d89eaf56dfab8d46bf25610aa4650247617 ]

Commit 6ee1b77ba3ac ("iommu/vt-d: Add svm/sva invalidate function")
introduced intel_iommu_sva_invalidate() when CONFIG_INTEL_IOMMU_SVM.
This function uses the dedicated static variable inv_type_granu_table
and functions to_vtd_granularity() and to_vtd_size().

These parts are unused when !CONFIG_INTEL_IOMMU_SVM, and hence,
make CC=clang W=1 warns with an -Wunused-function warning.

Include these parts conditionally on CONFIG_INTEL_IOMMU_SVM.

Fixes: 6ee1b77ba3ac ("iommu/vt-d: Add svm/sva invalidate function")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20201115205951.20698-1-lukas.bulwahn@gmail.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index a49afa11673cc..c9da9e93f545c 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -5387,6 +5387,7 @@ static void intel_iommu_aux_detach_device(struct iommu_domain *domain,
 	aux_domain_remove_dev(to_dmar_domain(domain), dev);
 }
 
+#ifdef CONFIG_INTEL_IOMMU_SVM
 /*
  * 2D array for converting and sanitizing IOMMU generic TLB granularity to
  * VT-d granularity. Invalidation is typically included in the unmap operation
@@ -5433,7 +5434,6 @@ static inline u64 to_vtd_size(u64 granu_size, u64 nr_granules)
 	return order_base_2(nr_pages);
 }
 
-#ifdef CONFIG_INTEL_IOMMU_SVM
 static int
 intel_iommu_sva_invalidate(struct iommu_domain *domain, struct device *dev,
 			   struct iommu_cache_invalidate_info *inv_info)
-- 
2.27.0



