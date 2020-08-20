Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0510624BEC6
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbgHTNbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:31:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728125AbgHTJc0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:32:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E17722BEB;
        Thu, 20 Aug 2020 09:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915945;
        bh=YoX+O+1UOgcVdZatpKv5LLn+ibV711RniuxfJZfW09Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VDFRm59mxnOyy/Qsqosw1zGlOkKWy2Nbf5NDQeko/U4NwH1VLOIyQNoxDZwiOk5pZ
         A73dW/C5RwyxAzLzbew/mYYhzaZOXYT+hNJ4PlQ/CuiuiFk8sUSlRE+W8RsQVAHWKd
         0mbwhKJMXrFAZ37ZUga7AL6RwMgZtAXhPAo4vAi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 160/232] iommu/vt-d: Warn on out-of-range invalidation address
Date:   Thu, 20 Aug 2020 11:20:11 +0200
Message-Id: <20200820091620.562216591@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

[ Upstream commit 1ff00279655d95ae9c285c39878aedf9ff008d25 ]

For guest requested IOTLB invalidation, address and mask are provided as
part of the invalidation data. VT-d HW silently ignores any address bits
below the mask. SW shall also allow such case but give warning if
address does not align with the mask. This patch relax the fault
handling from error to warning and proceed with invalidation request
with the given mask.

Fixes: 6ee1b77ba3ac0 ("iommu/vt-d: Add svm/sva invalidate function")
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20200724014925.15523-7-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index e7bce09a9f735..04e82f1756010 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -5452,13 +5452,12 @@ intel_iommu_sva_invalidate(struct iommu_domain *domain, struct device *dev,
 
 		switch (BIT(cache_type)) {
 		case IOMMU_CACHE_INV_TYPE_IOTLB:
+			/* HW will ignore LSB bits based on address mask */
 			if (inv_info->granularity == IOMMU_INV_GRANU_ADDR &&
 			    size &&
 			    (inv_info->addr_info.addr & ((BIT(VTD_PAGE_SHIFT + size)) - 1))) {
-				pr_err_ratelimited("Address out of range, 0x%llx, size order %llu\n",
+				pr_err_ratelimited("User address not aligned, 0x%llx, size order %llu\n",
 						   inv_info->addr_info.addr, size);
-				ret = -ERANGE;
-				goto out_unlock;
 			}
 
 			/*
-- 
2.25.1



