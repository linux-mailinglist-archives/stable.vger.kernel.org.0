Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5E2304C1F
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 23:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbhAZWBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 17:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393121AbhAZUnu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 15:43:50 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4ADC0613ED;
        Tue, 26 Jan 2021 12:43:25 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id e9so2978038pjj.0;
        Tue, 26 Jan 2021 12:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XA+jyv1loiGPphrOL8kn5H8su7PXADpnQ1gR33eeAE4=;
        b=PP38fahaKMJC62EY7XKecdBtPSaTl4VhZR05btl5dnOp7IdtmNqJYWmkAhL8DzS6Kj
         wNuNRosuSulIeXoWHgl4qFS5cvRnrSy2zHxZjbKpDvWqSakX7mZoVVaGSva5+1pZ+za9
         g5zGlasJdNCqAfmZGTXAzc4rLglraGQzOFRGK3aIKc5EFhsk2ABAzDZpU39JHQFPm2wi
         SmY7preEDlxU25nnXV7L9FGA4mQBFCtOamNsARduywSQ/sN6HKcy5BcopP7xZPdL5iUz
         lByVPaErGJmC/kDGLnesjhkIjQ3IaqNvqlv9I2sqJ1je5Uuu+w0s+ORZRF+kBsMfb3m8
         vtHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XA+jyv1loiGPphrOL8kn5H8su7PXADpnQ1gR33eeAE4=;
        b=X761MBi2zny4LF4cEpdBEv7FeXf7wEW28DkP80DUrtzSIiPuLMAelGIc+QhaKpXMWe
         aZrGga7SbgM3n6ewaYpBht8UU6guj5r/siUBm5D4yT7r8JbbVskacm6aam+I6RNlHGSm
         EwkucLzUOqBcWEkGdu2BWAr4DSBdwEVpKCDt1OORg7QGBqm+zes7N6GQryX8xJeljBsn
         pK3+EEyL45C7Kw+y6DotGbUn4JODqY8EGeRHRvg8GX3irCZH44qVOlwNFiyCwcrPq2cD
         HyAcpeYAFJAUuwzzCbTj5rTDcvT5W0/8YEBbZy9CvGx8jXoTxQqfvvDuWFpwBGHCK6IJ
         BHPw==
X-Gm-Message-State: AOAM5305X3IcRXlhP9LU728jP9itR6kitzF9PhGZ24PhpgZJXQkDqKd9
        cLiU/jon9Mf6ig6+DBnCMuI=
X-Google-Smtp-Source: ABdhPJwwmT30kogCuc3lhP7aqEqdxyYVgkl88E1BimVSr1avbycjpHPuhpnAYWxZo8EeOpApKsljAQ==
X-Received: by 2002:a17:90a:d58c:: with SMTP id v12mr1684421pju.37.1611693804887;
        Tue, 26 Jan 2021 12:43:24 -0800 (PST)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id hs21sm2990530pjb.6.2021.01.26.12.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 12:43:24 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     iommu@lists.linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] iommu/vt-d: do not use flush-queue when caching-mode is on
Date:   Tue, 26 Jan 2021 12:38:56 -0800
Message-Id: <20210126203856.1544088-1-namit@vmware.com>
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

Synchronizing the virtual and the physical TLBs is expensive if the
hypervisor is unaware which PTEs have changed, as the hypervisor is
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
 drivers/iommu/intel/iommu.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 788119c5b021..4e08f5e17175 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -5373,6 +5373,30 @@ intel_iommu_domain_set_attr(struct iommu_domain *domain,
 	return ret;
 }
 
+static int
+intel_iommu_domain_get_attr_use_flush_queue(struct iommu_domain *domain)
+{
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
+	struct intel_iommu *iommu = domain_get_iommu(dmar_domain);
+
+	if (intel_iommu_strict)
+		return 0;
+
+	/*
+	 * The flush queue implementation does not perform page-selective
+	 * invalidations that are required for efficient TLB flushes in virtual
+	 * environments. The benefit of batching is likely to be much lower than
+	 * the overhead of synchronizing the virtual and physical IOMMU
+	 * page-tables.
+	 */
+	if (iommu && cap_caching_mode(iommu->cap)) {
+		pr_warn_once("IOMMU batching is partially disabled due to virtualization");
+		return 0;
+	}
+
+	return 1;
+}
+
 static int
 intel_iommu_domain_get_attr(struct iommu_domain *domain,
 			    enum iommu_attr attr, void *data)
@@ -5383,7 +5407,7 @@ intel_iommu_domain_get_attr(struct iommu_domain *domain,
 	case IOMMU_DOMAIN_DMA:
 		switch (attr) {
 		case DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE:
-			*(int *)data = !intel_iommu_strict;
+			*(int *)data = !intel_iommu_domain_get_attr_use_flush_queue(domain);
 			return 0;
 		default:
 			return -ENODEV;
-- 
2.25.1

