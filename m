Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D10418A627
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 22:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgCRUyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 16:54:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727900AbgCRUyl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 16:54:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5733208DB;
        Wed, 18 Mar 2020 20:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564880;
        bh=AqybkAQCXbqhHLf2TkeCxzL7ipFFyXCzQaXNsy22Bl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0YPELvgOqPxu1M4Im0bjao73Qmt42AWplPvMSuD12Lf4Fly1BCISfAfkYLhcbdUWi
         3FGqngmjenr1I0vGjnGCGv1DkqbEz37v6EBcpdGBS/Uj3j/M9MaI2GeDCbtqzbJrVm
         XDmfA0k1fRJ+cRC4p+Jh0H0VWyvrejOHLCH7eaZ4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.4 50/73] iommu/vt-d: Fix RCU-list bugs in intel_iommu_init()
Date:   Wed, 18 Mar 2020 16:53:14 -0400
Message-Id: <20200318205337.16279-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 2d48ea0efb8887ebba3e3720bb5b738aced4e574 ]

There are several places traverse RCU-list without holding any lock in
intel_iommu_init(). Fix them by acquiring dmar_global_lock.

 WARNING: suspicious RCU usage
 -----------------------------
 drivers/iommu/intel-iommu.c:5216 RCU-list traversed in non-reader section!!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 no locks held by swapper/0/1.

 Call Trace:
  dump_stack+0xa0/0xea
  lockdep_rcu_suspicious+0x102/0x10b
  intel_iommu_init+0x947/0xb13
  pci_iommu_init+0x26/0x62
  do_one_initcall+0xfe/0x500
  kernel_init_freeable+0x45a/0x4f8
  kernel_init+0x11/0x139
  ret_from_fork+0x3a/0x50
 DMAR: Intel(R) Virtualization Technology for Directed I/O

Fixes: d8190dc63886 ("iommu/vt-d: Enable DMA remapping after rmrr mapped")
Signed-off-by: Qian Cai <cai@lca.pw>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel-iommu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 760a242d0801d..9b3d169c6ff53 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -5023,6 +5023,7 @@ int __init intel_iommu_init(void)
 
 	init_iommu_pm_ops();
 
+	down_read(&dmar_global_lock);
 	for_each_active_iommu(iommu, drhd) {
 		iommu_device_sysfs_add(&iommu->iommu, NULL,
 				       intel_iommu_groups,
@@ -5030,6 +5031,7 @@ int __init intel_iommu_init(void)
 		iommu_device_set_ops(&iommu->iommu, &intel_iommu_ops);
 		iommu_device_register(&iommu->iommu);
 	}
+	up_read(&dmar_global_lock);
 
 	bus_set_iommu(&pci_bus_type, &intel_iommu_ops);
 	if (si_domain && !hw_pass_through)
@@ -5040,7 +5042,6 @@ int __init intel_iommu_init(void)
 	down_read(&dmar_global_lock);
 	if (probe_acpi_namespace_devices())
 		pr_warn("ACPI name space devices didn't probe correctly\n");
-	up_read(&dmar_global_lock);
 
 	/* Finally, we enable the DMA remapping hardware. */
 	for_each_iommu(iommu, drhd) {
@@ -5049,6 +5050,8 @@ int __init intel_iommu_init(void)
 
 		iommu_disable_protect_mem_regions(iommu);
 	}
+	up_read(&dmar_global_lock);
+
 	pr_info("Intel(R) Virtualization Technology for Directed I/O\n");
 
 	intel_iommu_enabled = 1;
-- 
2.20.1

