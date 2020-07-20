Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA463226B9E
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730619AbgGTQnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:43:09 -0400
Received: from mga06.intel.com ([134.134.136.31]:34808 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730116AbgGTQnI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:43:08 -0400
IronPort-SDR: HCY3rPSSn6I2fxQg2ybSKsMgc5r8YNSkR/gj3gjGAY7lbtttvYtqg1ttt3/1W7ZGfxz4I/bHg3
 R7IdzA+6Mycw==
X-IronPort-AV: E=McAfee;i="6000,8403,9688"; a="211497322"
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="211497322"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 09:43:06 -0700
IronPort-SDR: d4PLIuEwn7c0OTzx6bO7SLAnEHKLtwtFBvlrqqp3K9C7F/ygYHygZcewVV6IJYkG5wc3JVAbLT
 ovlOs0gRdsWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="318061857"
Received: from otc-nc-03.jf.intel.com ([10.54.39.25])
  by orsmga008.jf.intel.com with ESMTP; 20 Jul 2020 09:43:06 -0700
From:   Ashok Raj <ashok.raj@intel.com>
To:     linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Joerg Roedel <joro@8bytes.org>, Lu Baolu <baolu.lu@intel.com>
Cc:     Ashok Raj <ashok.raj@intel.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [PATCH] PCI/ATS: PASID and PRI are only enumerated in PF devices.
Date:   Mon, 20 Jul 2020 09:43:00 -0700
Message-Id: <1595263380-209956-1-git-send-email-ashok.raj@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PASID and PRI capabilities are only enumerated in PF devices. VF devices
do not enumerate these capabilites. IOMMU drivers also need to enumerate
them before enabling features in the IOMMU. Extending the same support as
PASID feature discovery (pci_pasid_features) for PRI.

Signed-off-by: Ashok Raj <ashok.raj@intel.com>

To: Bjorn Helgaas <bhelgaas@google.com>
To: Joerg Roedel <joro@8bytes.com>
To: Lu Baolu <baolu.lu@intel.com>
Cc: stable@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: iommu@lists.linux-foundation.org
---
 drivers/iommu/intel/iommu.c |  2 +-
 drivers/pci/ats.c           | 14 ++++++++++++++
 include/linux/pci-ats.h     |  1 +
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index d759e7234e98..276452f5e6a7 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2560,7 +2560,7 @@ static struct dmar_domain *dmar_insert_one_dev_info(struct intel_iommu *iommu,
 			}
 
 			if (info->ats_supported && ecap_prs(iommu->ecap) &&
-			    pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_PRI))
+			    pci_pri_supported(pdev))
 				info->pri_supported = 1;
 		}
 	}
diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
index b761c1f72f67..ffb4de8c5a77 100644
--- a/drivers/pci/ats.c
+++ b/drivers/pci/ats.c
@@ -461,6 +461,20 @@ int pci_pasid_features(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL_GPL(pci_pasid_features);
 
+/**
+ * pci_pri_supported - Check if PRI is supported.
+ * @pdev: PCI device structure
+ *
+ * Returns false when no PRI capability is present.
+ * Returns true if PRI feature is supported and enabled
+ */
+bool pci_pri_supported(struct pci_dev *pdev)
+{
+	/* VFs share the PF PRI configuration */
+	return !!(pci_physfn(pdev)->pri_cap);
+}
+EXPORT_SYMBOL_GPL(pci_pri_supported);
+
 #define PASID_NUMBER_SHIFT	8
 #define PASID_NUMBER_MASK	(0x1f << PASID_NUMBER_SHIFT)
 /**
diff --git a/include/linux/pci-ats.h b/include/linux/pci-ats.h
index f75c307f346d..073d57292445 100644
--- a/include/linux/pci-ats.h
+++ b/include/linux/pci-ats.h
@@ -28,6 +28,7 @@ int pci_enable_pri(struct pci_dev *pdev, u32 reqs);
 void pci_disable_pri(struct pci_dev *pdev);
 int pci_reset_pri(struct pci_dev *pdev);
 int pci_prg_resp_pasid_required(struct pci_dev *pdev);
+bool pci_pri_supported(struct pci_dev *pdev);
 #endif /* CONFIG_PCI_PRI */
 
 #ifdef CONFIG_PCI_PASID
-- 
2.7.4

