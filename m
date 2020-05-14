Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA0A1D3CBB
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgENTJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 15:09:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728432AbgENSwn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:52:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0EA4207C3;
        Thu, 14 May 2020 18:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482363;
        bh=Vl6X23xBoHqMoNR2/6ScvTgq2jadKK1uO7HHSis+OX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bzh/9U/bFWZ/XuSTihY7yN6xp5hQzC/t+Ghbd1xLBXHNEdnO2HSA1k9AO3Dm59Jv3
         3TitTuNB4dZ5wnIA4VqwiMkxH+iBXUWFRyrf6fbIB4hP63fyhw+46tqSOyYjsmXS2h
         fDsVDD6CQR/itRpuS3Cb7hG92qrDhz22paknGx9E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joerg Roedel <jroedel@suse.de>, Qian Cai <cai@lca.pw>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.6 43/62] iommu/amd: Update Device Table in increase_address_space()
Date:   Thu, 14 May 2020 14:51:28 -0400
Message-Id: <20200514185147.19716-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185147.19716-1-sashal@kernel.org>
References: <20200514185147.19716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

[ Upstream commit 19c6978fba68a2cdedee7d55fb8c3063d47982d9 ]

The Device Table needs to be updated before the new page-table root
can be published in domain->pt_root. Otherwise a concurrent call to
fetch_pte might fetch a PTE which is not reachable through the Device
Table Entry.

Fixes: 92d420ec028d ("iommu/amd: Relax locking in dma_ops path")
Reported-by: Qian Cai <cai@lca.pw>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Qian Cai <cai@lca.pw>
Link: https://lore.kernel.org/r/20200504125413.16798-5-joro@8bytes.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu.c | 49 ++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index d2499c86d395c..2ae1daac888a0 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -101,6 +101,8 @@ struct kmem_cache *amd_iommu_irq_cache;
 static void update_domain(struct protection_domain *domain);
 static int protection_domain_init(struct protection_domain *domain);
 static void detach_device(struct device *dev);
+static void update_and_flush_device_table(struct protection_domain *domain,
+					  struct domain_pgtable *pgtable);
 
 /****************************************************************************
  *
@@ -1461,8 +1463,16 @@ static bool increase_address_space(struct protection_domain *domain,
 
 	*pte = PM_LEVEL_PDE(pgtable.mode, iommu_virt_to_phys(pgtable.root));
 
-	root = amd_iommu_domain_encode_pgtable(pte, pgtable.mode + 1);
+	pgtable.root  = pte;
+	pgtable.mode += 1;
+	update_and_flush_device_table(domain, &pgtable);
+	domain_flush_complete(domain);
 
+	/*
+	 * Device Table needs to be updated and flushed before the new root can
+	 * be published.
+	 */
+	root = amd_iommu_domain_encode_pgtable(pte, pgtable.mode);
 	atomic64_set(&domain->pt_root, root);
 
 	ret = true;
@@ -1893,19 +1903,17 @@ static bool dma_ops_domain(struct protection_domain *domain)
 }
 
 static void set_dte_entry(u16 devid, struct protection_domain *domain,
+			  struct domain_pgtable *pgtable,
 			  bool ats, bool ppr)
 {
-	struct domain_pgtable pgtable;
 	u64 pte_root = 0;
 	u64 flags = 0;
 	u32 old_domid;
 
-	amd_iommu_domain_get_pgtable(domain, &pgtable);
+	if (pgtable->mode != PAGE_MODE_NONE)
+		pte_root = iommu_virt_to_phys(pgtable->root);
 
-	if (pgtable.mode != PAGE_MODE_NONE)
-		pte_root = iommu_virt_to_phys(pgtable.root);
-
-	pte_root |= (pgtable.mode & DEV_ENTRY_MODE_MASK)
+	pte_root |= (pgtable->mode & DEV_ENTRY_MODE_MASK)
 		    << DEV_ENTRY_MODE_SHIFT;
 	pte_root |= DTE_FLAG_IR | DTE_FLAG_IW | DTE_FLAG_V | DTE_FLAG_TV;
 
@@ -1978,6 +1986,7 @@ static void clear_dte_entry(u16 devid)
 static void do_attach(struct iommu_dev_data *dev_data,
 		      struct protection_domain *domain)
 {
+	struct domain_pgtable pgtable;
 	struct amd_iommu *iommu;
 	bool ats;
 
@@ -1993,7 +2002,9 @@ static void do_attach(struct iommu_dev_data *dev_data,
 	domain->dev_cnt                 += 1;
 
 	/* Update device table */
-	set_dte_entry(dev_data->devid, domain, ats, dev_data->iommu_v2);
+	amd_iommu_domain_get_pgtable(domain, &pgtable);
+	set_dte_entry(dev_data->devid, domain, &pgtable,
+		      ats, dev_data->iommu_v2);
 	clone_aliases(dev_data->pdev);
 
 	device_flush_dte(dev_data);
@@ -2304,22 +2315,34 @@ static int amd_iommu_domain_get_attr(struct iommu_domain *domain,
  *
  *****************************************************************************/
 
-static void update_device_table(struct protection_domain *domain)
+static void update_device_table(struct protection_domain *domain,
+				struct domain_pgtable *pgtable)
 {
 	struct iommu_dev_data *dev_data;
 
 	list_for_each_entry(dev_data, &domain->dev_list, list) {
-		set_dte_entry(dev_data->devid, domain, dev_data->ats.enabled,
-			      dev_data->iommu_v2);
+		set_dte_entry(dev_data->devid, domain, pgtable,
+			      dev_data->ats.enabled, dev_data->iommu_v2);
 		clone_aliases(dev_data->pdev);
 	}
 }
 
+static void update_and_flush_device_table(struct protection_domain *domain,
+					  struct domain_pgtable *pgtable)
+{
+	update_device_table(domain, pgtable);
+	domain_flush_devices(domain);
+}
+
 static void update_domain(struct protection_domain *domain)
 {
-	update_device_table(domain);
+	struct domain_pgtable pgtable;
 
-	domain_flush_devices(domain);
+	/* Update device table */
+	amd_iommu_domain_get_pgtable(domain, &pgtable);
+	update_and_flush_device_table(domain, &pgtable);
+
+	/* Flush domain TLB(s) and wait for completion */
 	domain_flush_tlb_pde(domain);
 	domain_flush_complete(domain);
 }
-- 
2.20.1

