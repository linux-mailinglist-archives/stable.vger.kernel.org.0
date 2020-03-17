Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2487187FE8
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbgCQLFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:05:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726947AbgCQLFd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:05:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D9D120714;
        Tue, 17 Mar 2020 11:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443132;
        bh=2Es2x8F4ndjoVOQ0H+k7WmfpKbG/6r8wz6oEvR92m5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=whxvImbOu7KUeZHeePnaqPzjwPLo+lgd+UqU3qiuL+J0dSVPW7oePyNvvtHkz/3G4
         le7IQrn9FvqaSY4dM0QGnmU2sUdTBYuvNz1wP3r008StyXcHyz6ZfveBiXXlvICJjG
         2jj7HyqPVBxkLBjblL36xfYFc+XxFI9fzURmmTsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.4 106/123] iommu/vt-d: Fix RCU-list bugs in intel_iommu_init()
Date:   Tue, 17 Mar 2020 11:55:33 +0100
Message-Id: <20200317103318.386788238@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

commit 2d48ea0efb8887ebba3e3720bb5b738aced4e574 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -5024,6 +5024,7 @@ int __init intel_iommu_init(void)
 
 	init_iommu_pm_ops();
 
+	down_read(&dmar_global_lock);
 	for_each_active_iommu(iommu, drhd) {
 		iommu_device_sysfs_add(&iommu->iommu, NULL,
 				       intel_iommu_groups,
@@ -5031,6 +5032,7 @@ int __init intel_iommu_init(void)
 		iommu_device_set_ops(&iommu->iommu, &intel_iommu_ops);
 		iommu_device_register(&iommu->iommu);
 	}
+	up_read(&dmar_global_lock);
 
 	bus_set_iommu(&pci_bus_type, &intel_iommu_ops);
 	if (si_domain && !hw_pass_through)
@@ -5041,7 +5043,6 @@ int __init intel_iommu_init(void)
 	down_read(&dmar_global_lock);
 	if (probe_acpi_namespace_devices())
 		pr_warn("ACPI name space devices didn't probe correctly\n");
-	up_read(&dmar_global_lock);
 
 	/* Finally, we enable the DMA remapping hardware. */
 	for_each_iommu(iommu, drhd) {
@@ -5050,6 +5051,8 @@ int __init intel_iommu_init(void)
 
 		iommu_disable_protect_mem_regions(iommu);
 	}
+	up_read(&dmar_global_lock);
+
 	pr_info("Intel(R) Virtualization Technology for Directed I/O\n");
 
 	intel_iommu_enabled = 1;


