Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE39F305333
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 07:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhA0GaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 01:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232689AbhA0GW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 01:22:28 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8A6C061786;
        Tue, 26 Jan 2021 22:22:03 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id b21so884197pgk.7;
        Tue, 26 Jan 2021 22:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p0UOjkRmTMwD1AsLsBqqGq4W3t7p5uLwynxQNKotm9U=;
        b=hfsu/AxsByhoVi9/dovQmsf7FplmeW4giTtzyaYOrpxLYHjqxO49D/fwguVd14YLri
         wAN7yFKObjzOtITpDrKBlGcikkyUHEiYcPfiu5w/o7eKPsWGFaWTlLPIcVwGH33qBpP+
         nM0Yc7yYDYhTCw3pBZeyuuiWpFZtOUi69e9cTxTPUW3gxt9pOHPq+lSEbIDzHgMpto6X
         dZZ0sJOyAtGfv6huYuRmMl07J/7Dp3odNwQWjl6/4pW+YgGUIpCsT4fh4tqn3ECRlVlU
         VrOrBRF2uHvljWRzzhMsR9gYf0TAnoiasz49iYc4CXrN5rRZC16+A/cdQAb/ZRkBZ3WV
         mFcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p0UOjkRmTMwD1AsLsBqqGq4W3t7p5uLwynxQNKotm9U=;
        b=ulh27+LSZkOwejKnvUD7udPyP1WUttu08QxN99odLHnBrmR648Ksb3i2oVmhOexyif
         PxofOBUJdjKqchz2fI0eat4j90lhTcdoeYK8GVH31mYeqC3CWIAwsfxtTypusdGPFHpL
         KwKAJ8lESbT2+SrBjclrq+uYZnjVT6x606S/stH/xHnmsQetcu4m52VD5iF8OTYMYrdB
         qF7kl8YQYeezx6a8cP0r4vF9N+KWLavcd0YL9bbnRpAl3vDSzDJjehhy9K6+YUw3pWbD
         IdlAlk37dohRR5eZGBj1TgsdSC9CVNbggECiK4R8qiQfF6D+n69T1KmGanLVsnkKNP6L
         iU+g==
X-Gm-Message-State: AOAM5333tjnLREG2pTCe5b43GZQ1Ye8848DjRD42AuzT9xN10U9knB58
        GKJfEOp8c/BJ3ttAj7b1QlO94lqavy9acA==
X-Google-Smtp-Source: ABdhPJylntng4vIQz7EpDEhCRAK/XSZ+RAVN85oPYe0Cue23Sjqwoc7AjuY8T9U75OBd7KEGb71TeA==
X-Received: by 2002:a62:2e86:0:b029:1a6:5f94:2cb with SMTP id u128-20020a622e860000b02901a65f9402cbmr9127753pfu.19.1611728522419;
        Tue, 26 Jan 2021 22:22:02 -0800 (PST)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id d14sm992192pfo.156.2021.01.26.22.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 22:22:01 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     iommu@lists.linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH v2] iommu/vt-d: do not use flush-queue when caching-mode is on
Date:   Tue, 26 Jan 2021 22:17:29 -0800
Message-Id: <20210127061729.1596640-1-namit@vmware.com>
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

Getting batched TLB flushes to use in such circumstances page-specific
invalidations again is not easy, since the TLB invalidation scheme
assumes that "full" domain TLB flushes are performed for scalability.

Disable batched TLB flushes when caching-mode is on, as the performance
benefit from using batched TLB invalidations is likely to be much
smaller than the overhead of the virtual-to-physical IOMMU page-tables
synchronization.

Fixes: 78d5f0f500e6 ("intel-iommu: Avoid global flushes with caching mode.")
Signed-off-by: Nadav Amit <namit@vmware.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Will Deacon <will@kernel.org>
Cc: stable@vger.kernel.org

---
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

