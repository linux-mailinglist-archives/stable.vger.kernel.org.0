Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774F9311471
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbhBEWGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:06:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:44678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232774AbhBEOwN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:52:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D71864FD7;
        Fri,  5 Feb 2021 14:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534176;
        bh=+kMVAiqh5RcRrY3CkWPq2kPCMaTRR9tH/SpIOwVqDWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aknQe9eZ1priDbqduopmwrJkaANON8C/WNytgTidchVENj0GjVoXOWQyO+s83qBjM
         XVCEwJ/Cv06jgGOV3Yd2b/veVQs4wE61peBEFPmBw0Y6EGKZLhqugIAAkdArRB4yu0
         RT6QSQ4wuhVV5T29vxdm0RuSUa/1Ro8iOlzxyDD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.10 17/57] iommu/vt-d: Do not use flush-queue when caching-mode is on
Date:   Fri,  5 Feb 2021 15:06:43 +0100
Message-Id: <20210205140656.717830135@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

commit 29b32839725f8c89a41cb6ee054c85f3116ea8b5 upstream.

When an Intel IOMMU is virtualized, and a physical device is
passed-through to the VM, changes of the virtual IOMMU need to be
propagated to the physical IOMMU. The hypervisor therefore needs to
monitor PTE mappings in the IOMMU page-tables. Intel specifications
provide "caching-mode" capability that a virtual IOMMU uses to report
that the IOMMU is virtualized and a TLB flush is needed after mapping to
allow the hypervisor to propagate virtual IOMMU mappings to the physical
IOMMU. To the best of my knowledge no real physical IOMMU reports
"caching-mode" as turned on.

Synchronizing the virtual and the physical IOMMU tables is expensive if
the hypervisor is unaware which PTEs have changed, as the hypervisor is
required to walk all the virtualized tables and look for changes.
Consequently, domain flushes are much more expensive than page-specific
flushes on virtualized IOMMUs with passthrough devices. The kernel
therefore exploited the "caching-mode" indication to avoid domain
flushing and use page-specific flushing in virtualized environments. See
commit 78d5f0f500e6 ("intel-iommu: Avoid global flushes with caching
mode.")

This behavior changed after commit 13cf01744608 ("iommu/vt-d: Make use
of iova deferred flushing"). Now, when batched TLB flushing is used (the
default), full TLB domain flushes are performed frequently, requiring
the hypervisor to perform expensive synchronization between the virtual
TLB and the physical one.

Getting batched TLB flushes to use page-specific invalidations again in
such circumstances is not easy, since the TLB invalidation scheme
assumes that "full" domain TLB flushes are performed for scalability.

Disable batched TLB flushes when caching-mode is on, as the performance
benefit from using batched TLB invalidations is likely to be much
smaller than the overhead of the virtual-to-physical IOMMU page-tables
synchronization.

Fixes: 13cf01744608 ("iommu/vt-d: Make use of iova deferred flushing")
Signed-off-by: Nadav Amit <namit@vmware.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Will Deacon <will@kernel.org>
Cc: stable@vger.kernel.org
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20210127175317.1600473-1-namit@vmware.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel/iommu.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3350,6 +3350,11 @@ static int __init init_dmars(void)
 
 		if (!ecap_pass_through(iommu->ecap))
 			hw_pass_through = 0;
+
+		if (!intel_iommu_strict && cap_caching_mode(iommu->cap)) {
+			pr_warn("Disable batched IOTLB flush due to virtualization");
+			intel_iommu_strict = 1;
+		}
 		intel_svm_check(iommu);
 	}
 


