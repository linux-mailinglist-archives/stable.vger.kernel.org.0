Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C90673F9D
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 18:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjASRKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 12:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjASRKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 12:10:51 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83EFA5CB;
        Thu, 19 Jan 2023 09:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674148248; x=1705684248;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a1Xl5AI0jRujcTSH5TR69MwUM/ZMR3gvrCrzmKfX45M=;
  b=imGN8q9gbYCE0bDV8Q8VgIm/UqwL/J2OUkx9ZBaWKy/iUlVANbR+Wj/l
   CWDDPZ3niEk15VBBx/zP8+TDoy3nFyTLimIWj9u+ro8lOvRE2OOjEzj1L
   YEnYMUUCBV4atn6J7h/evUNa6Mo1HUwz5LBn6eL4BJzIDSr6UGPb+Kzn6
   LPF/IMVuFgv9Wj7pc8u+bNeZbAPjn6sbMZggtL7RZK7gks+9A1pwKa+29
   cwVHYhWPOuUv6b4dKy9Wvuj/dnk/Dj3mMHf1YqwVoqpqME4Kg6q8IK4oC
   1RLhnUoZbmYFYNA6dpV4MJXLrbtriumNegsCBGnffZQaSip5Tc/3PTxZc
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="305714699"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="305714699"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 09:06:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="784124777"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="784124777"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by orsmga004.jf.intel.com with ESMTP; 19 Jan 2023 09:06:20 -0800
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-pci@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        darwi@linutronix.de, elena.reshetova@intel.com,
        kirill.shutemov@linux.intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] PCI/MSI: Validate device supplied MSI table offset and size
Date:   Thu, 19 Jan 2023 19:06:33 +0200
Message-Id: <20230119170633.40944-3-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230119170633.40944-1-alexander.shishkin@linux.intel.com>
References: <20230119170633.40944-1-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, the MSI table offset supplied by device's config space is
passed directly into ioremap() without validation, allowing, for
example, a malicious VMM to trick the OS into exposing its private
memory.

Correct this by making sure the table with the given number of vectors
fits into its BIR starting at the provided table offset.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reported-by: Elena Reshetova <elena.reshetova@intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: stable@vger.kernel.org
---
 drivers/pci/msi/msi.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/msi/msi.c b/drivers/pci/msi/msi.c
index d50cd45119f1..e93e633cb6a3 100644
--- a/drivers/pci/msi/msi.c
+++ b/drivers/pci/msi/msi.c
@@ -552,7 +552,8 @@ static void __iomem *msix_map_region(struct pci_dev *dev,
 				     unsigned int nr_entries)
 {
 	resource_size_t phys_addr;
-	u32 table_offset;
+	u32 table_offset, table_size;
+	resource_size_t bir_size;
 	unsigned long flags;
 	u8 bir;
 
@@ -563,10 +564,15 @@ static void __iomem *msix_map_region(struct pci_dev *dev,
 	if (!flags || (flags & IORESOURCE_UNSET))
 		return NULL;
 
+	bir_size = pci_resource_len(dev, bir);
+	table_size = nr_entries * PCI_MSIX_ENTRY_SIZE;
 	table_offset &= PCI_MSIX_TABLE_OFFSET;
+	if (bir_size < table_size || table_offset > bir_size - table_size)
+		return NULL;
+
 	phys_addr = pci_resource_start(dev, bir) + table_offset;
 
-	return ioremap(phys_addr, nr_entries * PCI_MSIX_ENTRY_SIZE);
+	return ioremap(phys_addr, table_size);
 }
 
 /**
-- 
2.39.0

