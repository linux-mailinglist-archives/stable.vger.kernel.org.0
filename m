Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9010D2F30F6
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbhALNOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:14:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:53818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404121AbhALM5r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C719C2333D;
        Tue, 12 Jan 2021 12:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456197;
        bh=zLYawgbkxTGvzeINYqmnu2PERnl3cvpEaR0b/BUkCDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l66f19BeB76GRBoCMvC7bMI3PlTsCgW0V7KMc1JVg/uU1KR+jnlDacG5dcEUUPRDS
         ElC9MePLgd2a916CB0urItgjAFunmDFuzXu15aSn0u3rPDZ2gyNAhuJZqIfxEpJDDR
         JaJF7/IrkR0g3xpjXUtf8T7Qc0m9yqQO7eHkSqiTgd0d+sRz5J2rClwHaRRzdy6NJY
         JwPoDpgR70ScTNhzsK3p/eZLqx4Wu5I+mngjDPstAQ7Ca291qeuFai+JgltORzsz06
         ItT3ev9kJVQeV4zdOG+NrxZ9gKpbLmYLMaZXmRfwWIl+i95vQMjO8fwuJCqiVaOIz8
         bYsXjs3VUxicg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lu Baolu <baolu.lu@linux.intel.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.10 47/51] iommu/vt-d: Fix lockdep splat in sva bind()/unbind()
Date:   Tue, 12 Jan 2021 07:55:29 -0500
Message-Id: <20210112125534.70280-47-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 420d42f6f9db27d88bc4f83e3e668fcdacbf7e29 ]

Lock(&iommu->lock) without disabling irq causes lockdep warnings.

========================================================
WARNING: possible irq lock inversion dependency detected
5.11.0-rc1+ #828 Not tainted
--------------------------------------------------------
kworker/0:1H/120 just changed the state of lock:
ffffffffad9ea1b8 (device_domain_lock){..-.}-{2:2}, at:
iommu_flush_dev_iotlb.part.0+0x32/0x120
but this lock took another, SOFTIRQ-unsafe lock in the past:
 (&iommu->lock){+.+.}-{2:2}

and interrupts could create inverse lock ordering between them.

other info that might help us debug this:
 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&iommu->lock);
                               local_irq_disable();
                               lock(device_domain_lock);
                               lock(&iommu->lock);
  <Interrupt>
    lock(device_domain_lock);

 *** DEADLOCK ***

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20201231005323.2178523-5-baolu.lu@linux.intel.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/svm.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 3242ebd0bca36..267001e8076cd 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -281,6 +281,7 @@ int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
 	struct dmar_domain *dmar_domain;
 	struct device_domain_info *info;
 	struct intel_svm *svm = NULL;
+	unsigned long iflags;
 	int ret = 0;
 
 	if (WARN_ON(!iommu) || !data)
@@ -381,12 +382,12 @@ int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
 	 * each bind of a new device even with an existing PASID, we need to
 	 * call the nested mode setup function here.
 	 */
-	spin_lock(&iommu->lock);
+	spin_lock_irqsave(&iommu->lock, iflags);
 	ret = intel_pasid_setup_nested(iommu, dev,
 				       (pgd_t *)(uintptr_t)data->gpgd,
 				       data->hpasid, &data->vendor.vtd, dmar_domain,
 				       data->addr_width);
-	spin_unlock(&iommu->lock);
+	spin_unlock_irqrestore(&iommu->lock, iflags);
 	if (ret) {
 		dev_err_ratelimited(dev, "Failed to set up PASID %llu in nested mode, Err %d\n",
 				    data->hpasid, ret);
@@ -486,6 +487,7 @@ intel_svm_bind_mm(struct device *dev, unsigned int flags,
 	struct device_domain_info *info;
 	struct intel_svm_dev *sdev;
 	struct intel_svm *svm = NULL;
+	unsigned long iflags;
 	int pasid_max;
 	int ret;
 
@@ -605,14 +607,14 @@ intel_svm_bind_mm(struct device *dev, unsigned int flags,
 			}
 		}
 
-		spin_lock(&iommu->lock);
+		spin_lock_irqsave(&iommu->lock, iflags);
 		ret = intel_pasid_setup_first_level(iommu, dev,
 				mm ? mm->pgd : init_mm.pgd,
 				svm->pasid, FLPT_DEFAULT_DID,
 				(mm ? 0 : PASID_FLAG_SUPERVISOR_MODE) |
 				(cpu_feature_enabled(X86_FEATURE_LA57) ?
 				 PASID_FLAG_FL5LP : 0));
-		spin_unlock(&iommu->lock);
+		spin_unlock_irqrestore(&iommu->lock, iflags);
 		if (ret) {
 			if (mm)
 				mmu_notifier_unregister(&svm->notifier, mm);
@@ -632,14 +634,14 @@ intel_svm_bind_mm(struct device *dev, unsigned int flags,
 		 * Binding a new device with existing PASID, need to setup
 		 * the PASID entry.
 		 */
-		spin_lock(&iommu->lock);
+		spin_lock_irqsave(&iommu->lock, iflags);
 		ret = intel_pasid_setup_first_level(iommu, dev,
 						mm ? mm->pgd : init_mm.pgd,
 						svm->pasid, FLPT_DEFAULT_DID,
 						(mm ? 0 : PASID_FLAG_SUPERVISOR_MODE) |
 						(cpu_feature_enabled(X86_FEATURE_LA57) ?
 						PASID_FLAG_FL5LP : 0));
-		spin_unlock(&iommu->lock);
+		spin_unlock_irqrestore(&iommu->lock, iflags);
 		if (ret) {
 			kfree(sdev);
 			goto out;
-- 
2.27.0

