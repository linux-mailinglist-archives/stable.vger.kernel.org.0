Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A20A283863
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 16:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgJEOqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 10:46:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726655AbgJEOp1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 10:45:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6F94208A9;
        Mon,  5 Oct 2020 14:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601909116;
        bh=vOWJK81gI4SZUmr6nCexPxODyzmE8BKlV1U476drK1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vfmvDe97DRa5d01lkJddtGMy1ThYi0NJ1vOSWiT/ZriRpurd37wzYdmL/3P5ithdA
         QtCDzBIIgwj4yacwtnKrrd83T4fsND4hryjyU4E+BHEQ4RxK6V0JGf4C/1Zb5e/u+D
         NIK1idHAZ8YPjJnfn/ssB52eiCl+7fmd7REZf0as=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.8 12/12] iommu/vt-d: Fix lockdep splat in iommu_flush_dev_iotlb()
Date:   Mon,  5 Oct 2020 10:45:00 -0400
Message-Id: <20201005144501.2527477-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201005144501.2527477-1-sashal@kernel.org>
References: <20201005144501.2527477-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 1a3f2fd7fc4e8f24510830e265de2ffb8e3300d2 ]

Lock(&iommu->lock) without disabling irq causes lockdep warnings.

[   12.703950] ========================================================
[   12.703962] WARNING: possible irq lock inversion dependency detected
[   12.703975] 5.9.0-rc6+ #659 Not tainted
[   12.703983] --------------------------------------------------------
[   12.703995] systemd-udevd/284 just changed the state of lock:
[   12.704007] ffffffffbd6ff4d8 (device_domain_lock){..-.}-{2:2}, at:
               iommu_flush_dev_iotlb.part.57+0x2e/0x90
[   12.704031] but this lock took another, SOFTIRQ-unsafe lock in the past:
[   12.704043]  (&iommu->lock){+.+.}-{2:2}
[   12.704045]

               and interrupts could create inverse lock ordering between
               them.

[   12.704073]
               other info that might help us debug this:
[   12.704085]  Possible interrupt unsafe locking scenario:

[   12.704097]        CPU0                    CPU1
[   12.704106]        ----                    ----
[   12.704115]   lock(&iommu->lock);
[   12.704123]                                local_irq_disable();
[   12.704134]                                lock(device_domain_lock);
[   12.704146]                                lock(&iommu->lock);
[   12.704158]   <Interrupt>
[   12.704164]     lock(device_domain_lock);
[   12.704174]
                *** DEADLOCK ***

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20200927062428.13713-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index fbe0b0cc56edf..24a84d294fd01 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2617,7 +2617,7 @@ static struct dmar_domain *dmar_insert_one_dev_info(struct intel_iommu *iommu,
 		}
 
 		/* Setup the PASID entry for requests without PASID: */
-		spin_lock(&iommu->lock);
+		spin_lock_irqsave(&iommu->lock, flags);
 		if (hw_pass_through && domain_type_is_si(domain))
 			ret = intel_pasid_setup_pass_through(iommu, domain,
 					dev, PASID_RID2PASID);
@@ -2627,7 +2627,7 @@ static struct dmar_domain *dmar_insert_one_dev_info(struct intel_iommu *iommu,
 		else
 			ret = intel_pasid_setup_second_level(iommu, domain,
 					dev, PASID_RID2PASID);
-		spin_unlock(&iommu->lock);
+		spin_unlock_irqrestore(&iommu->lock, flags);
 		if (ret) {
 			dev_err(dev, "Setup RID2PASID failed\n");
 			dmar_remove_one_dev_info(dev);
-- 
2.25.1

