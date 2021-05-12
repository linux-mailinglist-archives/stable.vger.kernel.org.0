Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B8D37B772
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhELIHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:07:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:32313 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230240AbhELIHr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 04:07:47 -0400
IronPort-SDR: vJF2nCqjUEGHi+NFgQAVDxNzkrvVMT2Z2FHYJgXEtCrkwszqNC/Eeroez0VdBM3vFPt8miAvl8
 Vm9Ih7G3x8Rw==
X-IronPort-AV: E=McAfee;i="6200,9189,9981"; a="220616896"
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="220616896"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2021 01:06:39 -0700
IronPort-SDR: TNj6FgEAuHuLS04OzfPt8jnkwPnnLWYL+tvifhmcQcm1uS7rP4DRQ9SKqw88kKoPauF7R/BDPH
 CDlwjkFvaY7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="625208267"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by fmsmga005.fm.intel.com with ESMTP; 12 May 2021 01:06:37 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>, Sandeep Singh <sandeep.singh@amd.com>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5/5] xhci: Add reset resume quirk for AMD xhci controller.
Date:   Wed, 12 May 2021 11:08:16 +0300
Message-Id: <20210512080816.866037-6-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210512080816.866037-1-mathias.nyman@linux.intel.com>
References: <20210512080816.866037-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandeep Singh <sandeep.singh@amd.com>

One of AMD xhci controller require reset on resume.
Occasionally AMD xhci controller does not respond to
Stop endpoint command.
Once the issue happens controller goes into bad state
and in that case controller needs to be reset.

Cc: <stable@vger.kernel.org>
Signed-off-by: Sandeep Singh <sandeep.singh@amd.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index a858add8436c..7bc18cf8042c 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -167,8 +167,10 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	    (pdev->device == 0x15e0 || pdev->device == 0x15e1))
 		xhci->quirks |= XHCI_SNPS_BROKEN_SUSPEND;
 
-	if (pdev->vendor == PCI_VENDOR_ID_AMD && pdev->device == 0x15e5)
+	if (pdev->vendor == PCI_VENDOR_ID_AMD && pdev->device == 0x15e5) {
 		xhci->quirks |= XHCI_DISABLE_SPARSE;
+		xhci->quirks |= XHCI_RESET_ON_RESUME;
+	}
 
 	if (pdev->vendor == PCI_VENDOR_ID_AMD)
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
-- 
2.25.1

