Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B95C337CDC9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbhELQ6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:58:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244205AbhELQmm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59AA361D25;
        Wed, 12 May 2021 16:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835902;
        bh=YudxFErCNGEG/IMcM55fzLDfeqLIl64lIT/PgvE9NZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bbdLmH1HFD/y8qolWmEvgJsHPz/WbQClEEshJ2zG3xlB1ZfJzyd4HVlZGnx70BCVt
         3UEarOs0qAznAv2nKWEe0pRl6778XabqaOzAH5S882UpxOoUv44CNCeaO5zcs38d97
         BfCxlqQYbD2dOIzliVygPQWGrmGYrmLHFXYUzgjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ashok Raj <ashok.raj@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 495/677] iommu/vt-d: Remove WO permissions on second-level paging entries
Date:   Wed, 12 May 2021 16:49:01 +0200
Message-Id: <20210512144853.828509274@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit eea53c5816889ee8b64544fa2e9311a81184ff9c ]

When the first level page table is used for IOVA translation, it only
supports Read-Only and Read-Write permissions. The Write-Only permission
is not supported as the PRESENT bit (implying Read permission) should
always set. When using second level, we still give separate permissions
that allows WriteOnly which seems inconsistent and awkward. We want to
have consistent behavior. After moving to 1st level, we don't want things
to work sometimes, and break if we use 2nd level for the same mappings.
Hence remove this configuration.

Suggested-by: Ashok Raj <ashok.raj@intel.com>
Fixes: b802d070a52a1 ("iommu/vt-d: Use iova over first level")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20210320025415.641201-3-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index b5d3301b2700..36d60536ae8d 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2346,8 +2346,9 @@ __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 		return -EINVAL;
 
 	attr = prot & (DMA_PTE_READ | DMA_PTE_WRITE | DMA_PTE_SNP);
+	attr |= DMA_FL_PTE_PRESENT;
 	if (domain_use_first_level(domain)) {
-		attr |= DMA_FL_PTE_PRESENT | DMA_FL_PTE_XD | DMA_FL_PTE_US;
+		attr |= DMA_FL_PTE_XD | DMA_FL_PTE_US;
 
 		if (domain->domain.type == IOMMU_DOMAIN_DMA) {
 			attr |= DMA_FL_PTE_ACCESS;
-- 
2.30.2



