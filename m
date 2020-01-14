Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A544613A52D
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730082AbgANKFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:05:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:33256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729398AbgANKFQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:05:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 922182467A;
        Tue, 14 Jan 2020 10:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996315;
        bh=VPYKbHK9cT8m+9JoWShICak7GUWHXzcF2k0ceTisMxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tswaZspW5Uop8iIimI1abhRunxTws2rnbuhrpTABSvPhOylo5MTpdP0VHeL4bQsJF
         51uux9jwWjEWL5UzRMxU/onee2wbF3q1agJEW3ulZPnIn+aleDJ91bEk6KtlH/FaRV
         V6cZQM6lX6wGJ+hefA/IwFazhHSVFW5Uz5RNjYlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrick Steinhardt <ps@pks.im>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.4 54/78] iommu/vt-d: Fix adding non-PCI devices to Intel IOMMU
Date:   Tue, 14 Jan 2020 11:01:28 +0100
Message-Id: <20200114094400.718566344@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrick Steinhardt <ps@pks.im>

commit 4a350a0ee5b0a14f826fcdf60dd1a3199cafbfd6 upstream.

Starting with commit fa212a97f3a3 ("iommu/vt-d: Probe DMA-capable ACPI
name space devices"), we now probe DMA-capable ACPI name
space devices. On Dell XPS 13 9343, which has an Intel LPSS platform
device INTL9C60 enumerated via ACPI, this change leads to the following
warning:

    ------------[ cut here ]------------
    WARNING: CPU: 1 PID: 1 at pci_device_group+0x11a/0x130
    CPU: 1 PID: 1 Comm: swapper/0 Tainted: G                T 5.5.0-rc3+ #22
    Hardware name: Dell Inc. XPS 13 9343/0310JH, BIOS A20 06/06/2019
    RIP: 0010:pci_device_group+0x11a/0x130
    Code: f0 ff ff 48 85 c0 49 89 c4 75 c4 48 8d 74 24 10 48 89 ef e8 48 ef ff ff 48 85 c0 49 89 c4 75 af e8 db f7 ff ff 49 89 c4 eb a5 <0f> 0b 49 c7 c4 ea ff ff ff eb 9a e8 96 1e c7 ff 66 0f 1f 44 00 00
    RSP: 0000:ffffc0d6c0043cb0 EFLAGS: 00010202
    RAX: 0000000000000000 RBX: ffffa3d1d43dd810 RCX: 0000000000000000
    RDX: ffffa3d1d4fecf80 RSI: ffffa3d12943dcc0 RDI: ffffa3d1d43dd810
    RBP: ffffa3d1d43dd810 R08: 0000000000000000 R09: ffffa3d1d4c04a80
    R10: ffffa3d1d4c00880 R11: ffffa3d1d44ba000 R12: 0000000000000000
    R13: ffffa3d1d4383b80 R14: ffffa3d1d4c090d0 R15: ffffa3d1d4324530
    FS:  0000000000000000(0000) GS:ffffa3d1d6700000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 0000000000000000 CR3: 000000000460a001 CR4: 00000000003606e0
    Call Trace:
     ? iommu_group_get_for_dev+0x81/0x1f0
     ? intel_iommu_add_device+0x61/0x170
     ? iommu_probe_device+0x43/0xd0
     ? intel_iommu_init+0x1fa2/0x2235
     ? pci_iommu_init+0x52/0xe7
     ? e820__memblock_setup+0x15c/0x15c
     ? do_one_initcall+0xcc/0x27e
     ? kernel_init_freeable+0x169/0x259
     ? rest_init+0x95/0x95
     ? kernel_init+0x5/0xeb
     ? ret_from_fork+0x35/0x40
    ---[ end trace 28473e7abc25b92c ]---
    DMAR: ACPI name space devices didn't probe correctly

The bug results from the fact that while we now enumerate ACPI devices,
we aren't able to handle any non-PCI device when generating the device
group. Fix the issue by implementing an Intel-specific callback that
returns `pci_device_group` only if the device is a PCI device.
Otherwise, it will return a generic device group.

Fixes: fa212a97f3a3 ("iommu/vt-d: Probe DMA-capable ACPI name space devices")
Signed-off-by: Patrick Steinhardt <ps@pks.im>
Cc: stable@vger.kernel.org # v5.3+
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -5786,6 +5786,13 @@ static void intel_iommu_apply_resv_regio
 	WARN_ON_ONCE(!reserve_iova(&dmar_domain->iovad, start, end));
 }
 
+static struct iommu_group *intel_iommu_device_group(struct device *dev)
+{
+	if (dev_is_pci(dev))
+		return pci_device_group(dev);
+	return generic_device_group(dev);
+}
+
 #ifdef CONFIG_INTEL_IOMMU_SVM
 struct intel_iommu *intel_svm_device_to_iommu(struct device *dev)
 {
@@ -5958,7 +5965,7 @@ const struct iommu_ops intel_iommu_ops =
 	.get_resv_regions	= intel_iommu_get_resv_regions,
 	.put_resv_regions	= intel_iommu_put_resv_regions,
 	.apply_resv_region	= intel_iommu_apply_resv_region,
-	.device_group		= pci_device_group,
+	.device_group		= intel_iommu_device_group,
 	.dev_has_feat		= intel_iommu_dev_has_feat,
 	.dev_feat_enabled	= intel_iommu_dev_feat_enabled,
 	.dev_enable_feat	= intel_iommu_dev_enable_feat,


