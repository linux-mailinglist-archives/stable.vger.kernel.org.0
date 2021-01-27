Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3BB33062D4
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 18:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344070AbhA0R6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 12:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344040AbhA0R56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 12:57:58 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D43EC061573;
        Wed, 27 Jan 2021 09:57:33 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id md11so1714469pjb.0;
        Wed, 27 Jan 2021 09:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w8SFAtyBkooH+e96dnqciY4gOq/JX4viGnrG/3WGzYo=;
        b=LAHNQHpZ6UmzWWVBWdEE5fxytgPY5Od87tSgeIyxpFKsWDVeMbRJgDGQkbH6ritZ9Y
         I/sgYyzDxTcGdS3I5jPPqSlNEdaGPRfOBhf6bHaUZrs8Oc1HCazoKuYaoMW03/Db4jGB
         QH14vi+m7RBtkrTSytEq+NGsvWJ4ty1H5uBagYvt7NuJAxrQHQm4NtTnhK7MFPS9yt3t
         H86ZHSgGNODG8gRjhKN2eF2cLtG4h69pSqdGej6izLxe3LyHpO3h7Y/iZT257he/3erp
         SdkHDkb2R3IZuMki9YooLVeYWjSSG1CJ02S8fEISBZqQ5lzFScT4abrEo0jN+TWdg3wr
         Isjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w8SFAtyBkooH+e96dnqciY4gOq/JX4viGnrG/3WGzYo=;
        b=eBg/Gh04XZV2yZAEh0fRusHOFn+ThqSPxoaqT0Q8r2SHt446j9Hw3v1Hg4h1L4SjcX
         pQUzy23v2LtnZFuuTnUBxwp2c7FUDgC78AWrgC0A6irPeAhISjCynVAwKio1ryV9vxoj
         AUyYwWvsPEd+Sh9t99UppkrbubPk7Au7IiDnrBhQwMsJ6AN1tDCFq70fBgfVBqpt8IQ9
         N+aEw5onNIK+qRHuYg0GKhn55sszORbkxL+poPgdXZTjDzPJrtkiqAdxPztNPsRcv0hc
         oiXIFI1W+3Rq2ZecdmQM2drliFNOXi8cNCMqOgHcVA+co41CCp8+whWBYsTPIgoPULs8
         Kp3g==
X-Gm-Message-State: AOAM5310sbYZ173pnluJNWi71siCNONDrOZs6IRVcg8vXQKjaW09tXyR
        vSvB4r6pVRCyR20kfToqrwo3z+VuXYY=
X-Google-Smtp-Source: ABdhPJwPS7qnQNOT/tJ6C6hdtkLzOaMgcUU8xUCcQZ4gBUemrjKIagehaxsO3yX5pfzovDlnGXZCSg==
X-Received: by 2002:a17:90a:1082:: with SMTP id c2mr6866835pja.183.1611770252518;
        Wed, 27 Jan 2021 09:57:32 -0800 (PST)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id e191sm3372889pfh.149.2021.01.27.09.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 09:57:31 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     iommu@lists.linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH v3] iommu/vt-d: do not use flush-queue when caching-mode is on
Date:   Wed, 27 Jan 2021 09:53:17 -0800
Message-Id: <20210127175317.1600473-1-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

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

---
v2->v3:

* Fix the fixes tag in the commit-log (Lu).
* Minor English rephrasing of the commit-log.

v1->v2:

* disable flush queue for all domains if caching-mode is on for any
  IOMMU (Lu).
---
 drivers/iommu/intel/iommu.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 788119c5b021..de3dd617cf60 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -5373,6 +5373,36 @@ intel_iommu_domain_set_attr(struct iommu_domain *domain,
 	return ret;
 }
 
+static bool domain_use_flush_queue(void)
+{
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
+	bool r = true;
+
+	if (intel_iommu_strict)
+		return false;
+
+	/*
+	 * The flush queue implementation does not perform page-selective
+	 * invalidations that are required for efficient TLB flushes in virtual
+	 * environments. The benefit of batching is likely to be much lower than
+	 * the overhead of synchronizing the virtual and physical IOMMU
+	 * page-tables.
+	 */
+	rcu_read_lock();
+	for_each_active_iommu(iommu, drhd) {
+		if (!cap_caching_mode(iommu->cap))
+			continue;
+
+		pr_warn_once("IOMMU batching is disabled due to virtualization");
+		r = false;
+		break;
+	}
+	rcu_read_unlock();
+
+	return r;
+}
+
 static int
 intel_iommu_domain_get_attr(struct iommu_domain *domain,
 			    enum iommu_attr attr, void *data)
@@ -5383,7 +5413,7 @@ intel_iommu_domain_get_attr(struct iommu_domain *domain,
 	case IOMMU_DOMAIN_DMA:
 		switch (attr) {
 		case DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE:
-			*(int *)data = !intel_iommu_strict;
+			*(int *)data = domain_use_flush_queue();
 			return 0;
 		default:
 			return -ENODEV;
-- 
2.25.1

