Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A80F1673F9A
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 18:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjASRKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 12:10:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjASRKu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 12:10:50 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C736E5B91;
        Thu, 19 Jan 2023 09:10:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674148247; x=1705684247;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WZXENZe/rH7FLxenBxCcqTEtaplqgNUH7FpDX/thmSk=;
  b=cJuffKRZyiNr4wZK0xBT/+6tqIBnxjiVOF/2B7Tu105zHva4SDcq5Xqp
   I/1rkZ7+6StkYjcpQlkfKVUseuFpjGsdyTGXKfG1QLTnmIGKXIPTyoE25
   t2nAN0QrNPy09svIf0jbR43uMQ9eAcEJZ0GryjTvXctFYYbh+kuHQ+ilT
   dmR6MIb5vph8mkGAE/VebqNKiHmZe8rlesSMqUZhYVZZHZSzoupbTzwiq
   u5vnXRsnEAum6XwMLv99xAi2ZCuJn2lZ70D9h9mAoU1gBXBtCh2YNcQaz
   PFWV94qvUrCkTUlfgNUM73alvYUXqy3Cl/cmNnG+UjlqyH1EELT7eGh2w
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="305714674"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="305714674"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 09:06:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="784124771"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="784124771"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by orsmga004.jf.intel.com with ESMTP; 19 Jan 2023 09:06:16 -0800
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-pci@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        darwi@linutronix.de, elena.reshetova@intel.com,
        kirill.shutemov@linux.intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] PCI/MSI: Cache the MSIX table size
Date:   Thu, 19 Jan 2023 19:06:32 +0200
Message-Id: <20230119170633.40944-2-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230119170633.40944-1-alexander.shishkin@linux.intel.com>
References: <20230119170633.40944-1-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A malicious device can change its MSIX table size between the table
ioremap() and subsequent accesses, resulting in a kernel page fault in
pci_write_msg_msix().

To avoid this, cache the table size observed at the moment of table
ioremap() and use the cached value. This, however, does not help drivers
that peek at the PCIE_MSIX_FLAGS register directly.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: stable@vger.kernel.org
---
 drivers/pci/msi/api.c | 7 ++++++-
 drivers/pci/msi/msi.c | 2 +-
 include/linux/pci.h   | 1 +
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/msi/api.c b/drivers/pci/msi/api.c
index b8009aa11f3c..617ea1256487 100644
--- a/drivers/pci/msi/api.c
+++ b/drivers/pci/msi/api.c
@@ -75,8 +75,13 @@ int pci_msix_vec_count(struct pci_dev *dev)
 	if (!dev->msix_cap)
 		return -EINVAL;
 
+	if (dev->flags_qsize)
+		return dev->flags_qsize;
+
 	pci_read_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, &control);
-	return msix_table_size(control);
+	dev->flags_qsize = msix_table_size(control);
+
+	return dev->flags_qsize;
 }
 EXPORT_SYMBOL(pci_msix_vec_count);
 
diff --git a/drivers/pci/msi/msi.c b/drivers/pci/msi/msi.c
index 1f716624ca56..d50cd45119f1 100644
--- a/drivers/pci/msi/msi.c
+++ b/drivers/pci/msi/msi.c
@@ -715,7 +715,7 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 
 	pci_read_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, &control);
 	/* Request & Map MSI-X table region */
-	tsize = msix_table_size(control);
+	tsize = pci_msix_vec_count(dev);
 	dev->msix_base = msix_map_region(dev, tsize);
 	if (!dev->msix_base) {
 		ret = -ENOMEM;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index adffd65e84b4..2e1a72a2139d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -352,6 +352,7 @@ struct pci_dev {
 	u8		rom_base_reg;	/* Config register controlling ROM */
 	u8		pin;		/* Interrupt pin this device uses */
 	u16		pcie_flags_reg;	/* Cached PCIe Capabilities Register */
+	u16		flags_qsize;	/* Cached MSIX table size */
 	unsigned long	*dma_alias_mask;/* Mask of enabled devfn aliases */
 
 	struct pci_driver *driver;	/* Driver bound to this device */
-- 
2.39.0

