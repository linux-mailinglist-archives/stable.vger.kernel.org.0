Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3C044017
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732909AbfFMQCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:02:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731399AbfFMIrp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:47:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FEFA206BA;
        Thu, 13 Jun 2019 08:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415663;
        bh=AXb6EU2GB5BRD6fGsLpTHyi2PsV9MWzq0YfS1oREoqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JbljTN3rCClHhh3OYuU+IpjZ8F3e7d2I/4QRScNChrstsmgfzNo+JcnWD7SOgfAlt
         1Bi3SQqiYYyvszbtxNsOEK1jh003gOCZIRpg8RC61FFdNiRCCi7kddm1M0MvSF+Eb/
         OxKJlrSf/2Oj3F7kvl42NvUtNurBWIs+tg5LN0is=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ashok Raj <ashok.raj@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 082/155] iommu/vt-d: Dont request page request irq under dmar_global_lock
Date:   Thu, 13 Jun 2019 10:33:14 +0200
Message-Id: <20190613075657.638162064@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a7755c3cfa5df755e39447b08c28203e011fb98c ]

Requesting page reqest irq under dmar_global_lock could cause
potential lock race condition (caught by lockdep).

[    4.100055] ======================================================
[    4.100063] WARNING: possible circular locking dependency detected
[    4.100072] 5.1.0-rc4+ #2169 Not tainted
[    4.100078] ------------------------------------------------------
[    4.100086] swapper/0/1 is trying to acquire lock:
[    4.100094] 000000007dcbe3c3 (dmar_lock){+.+.}, at: dmar_alloc_hwirq+0x35/0x140
[    4.100112] but task is already holding lock:
[    4.100120] 0000000060bbe946 (dmar_global_lock){++++}, at: intel_iommu_init+0x191/0x1438
[    4.100136] which lock already depends on the new lock.
[    4.100146] the existing dependency chain (in reverse order) is:
[    4.100155]
               -> #2 (dmar_global_lock){++++}:
[    4.100169]        down_read+0x44/0xa0
[    4.100178]        intel_irq_remapping_alloc+0xb2/0x7b0
[    4.100186]        mp_irqdomain_alloc+0x9e/0x2e0
[    4.100195]        __irq_domain_alloc_irqs+0x131/0x330
[    4.100203]        alloc_isa_irq_from_domain.isra.4+0x9a/0xd0
[    4.100212]        mp_map_pin_to_irq+0x244/0x310
[    4.100221]        setup_IO_APIC+0x757/0x7ed
[    4.100229]        x86_late_time_init+0x17/0x1c
[    4.100238]        start_kernel+0x425/0x4e3
[    4.100247]        secondary_startup_64+0xa4/0xb0
[    4.100254]
               -> #1 (irq_domain_mutex){+.+.}:
[    4.100265]        __mutex_lock+0x7f/0x9d0
[    4.100273]        __irq_domain_add+0x195/0x2b0
[    4.100280]        irq_domain_create_hierarchy+0x3d/0x40
[    4.100289]        msi_create_irq_domain+0x32/0x110
[    4.100297]        dmar_alloc_hwirq+0x111/0x140
[    4.100305]        dmar_set_interrupt.part.14+0x1a/0x70
[    4.100314]        enable_drhd_fault_handling+0x2c/0x6c
[    4.100323]        apic_bsp_setup+0x75/0x7a
[    4.100330]        x86_late_time_init+0x17/0x1c
[    4.100338]        start_kernel+0x425/0x4e3
[    4.100346]        secondary_startup_64+0xa4/0xb0
[    4.100352]
               -> #0 (dmar_lock){+.+.}:
[    4.100364]        lock_acquire+0xb4/0x1c0
[    4.100372]        __mutex_lock+0x7f/0x9d0
[    4.100379]        dmar_alloc_hwirq+0x35/0x140
[    4.100389]        intel_svm_enable_prq+0x61/0x180
[    4.100397]        intel_iommu_init+0x1128/0x1438
[    4.100406]        pci_iommu_init+0x16/0x3f
[    4.100414]        do_one_initcall+0x5d/0x2be
[    4.100422]        kernel_init_freeable+0x1f0/0x27c
[    4.100431]        kernel_init+0xa/0x110
[    4.100438]        ret_from_fork+0x3a/0x50
[    4.100444]
               other info that might help us debug this:

[    4.100454] Chain exists of:
                 dmar_lock --> irq_domain_mutex --> dmar_global_lock
[    4.100469]  Possible unsafe locking scenario:

[    4.100476]        CPU0                    CPU1
[    4.100483]        ----                    ----
[    4.100488]   lock(dmar_global_lock);
[    4.100495]                                lock(irq_domain_mutex);
[    4.100503]                                lock(dmar_global_lock);
[    4.100512]   lock(dmar_lock);
[    4.100518]
                *** DEADLOCK ***

Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Reported-by: Dave Jiang <dave.jiang@intel.com>
Fixes: a222a7f0bb6c9 ("iommu/vt-d: Implement page request handling")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel-iommu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 10a45092d062..cb656f503604 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3496,7 +3496,13 @@ domains_done:
 
 #ifdef CONFIG_INTEL_IOMMU_SVM
 		if (pasid_supported(iommu) && ecap_prs(iommu->ecap)) {
+			/*
+			 * Call dmar_alloc_hwirq() with dmar_global_lock held,
+			 * could cause possible lock race condition.
+			 */
+			up_write(&dmar_global_lock);
 			ret = intel_svm_enable_prq(iommu);
+			down_write(&dmar_global_lock);
 			if (ret)
 				goto free_iommu;
 		}
-- 
2.20.1



