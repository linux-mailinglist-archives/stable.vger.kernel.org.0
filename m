Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B1F2FA2EA
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392672AbhAROY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:24:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:39894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390445AbhARLot (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:44:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3CAD22D70;
        Mon, 18 Jan 2021 11:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970234;
        bh=H9JKmMYijxvSsSklizL3sPLuNJiOhnIzQykoxgYRYHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7Mz4jXZ51es0jQS477lts+DZ3+nUS+Of+hRRZ3MabST5BuZrZjbVa/JHrSx3FxjI
         IhtzNeSksmnzvwBqYIAn/cZhbXItrJUXUG4s5pgVswP6EXTlM3RRZUTvdhohto7e76
         F7f18Ubo50eEHmceP1Af6pkIu/Dlrltzo3KBY8nQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 093/152] iommu/vt-d: Fix lockdep splat in sva bind()/unbind()
Date:   Mon, 18 Jan 2021 12:34:28 +0100
Message-Id: <20210118113357.204966301@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 4a10c9ff368c5..e17cd94d1fd1f 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -281,6 +281,7 @@ int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
 	struct dmar_domain *dmar_domain;
 	struct device_domain_info *info;
 	struct intel_svm *svm = NULL;
+	unsigned long iflags;
 	int ret = 0;
 
 	if (WARN_ON(!iommu) || !data)
@@ -382,12 +383,12 @@ int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
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
@@ -487,6 +488,7 @@ intel_svm_bind_mm(struct device *dev, unsigned int flags,
 	struct device_domain_info *info;
 	struct intel_svm_dev *sdev;
 	struct intel_svm *svm = NULL;
+	unsigned long iflags;
 	int pasid_max;
 	int ret;
 
@@ -606,14 +608,14 @@ intel_svm_bind_mm(struct device *dev, unsigned int flags,
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
@@ -633,14 +635,14 @@ intel_svm_bind_mm(struct device *dev, unsigned int flags,
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



