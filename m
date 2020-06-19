Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10CB200E07
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391095AbgFSPEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:04:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:60980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390621AbgFSPEI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:04:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4373121D7D;
        Fri, 19 Jun 2020 15:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579046;
        bh=seEWA6TD6thz/bf8AymmfY2DgRiKDddkUcwLl6ycTeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LIzintNEKSt0sq+v/WBbFM/+UTEJlXy9Cmz6oBsi8DvIzzfzTq8ZrFLb1yW2KpcHe
         i897lWHzZLD3NJScqU/eCK5QxaqSnqv7Osp+BFQ1+peelQyY6gcdxJLjAsC8NMsFXY
         0TI11hQ/nFh77b8cW/j1BlPO9BavOpLBFFgxqWKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 225/267] PCI: Make ACS quirk implementations more uniform
Date:   Fri, 19 Jun 2020 16:33:30 +0200
Message-Id: <20200619141659.498894885@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit c8de8ed2dcaac82e5d76d467dc0b02e0ee79809b ]

The ACS quirks differ in needless ways, which makes them look more
different than they really are.

Reorder the ACS flags in order of definitions in the spec:

  PCI_ACS_SV   Source Validation
  PCI_ACS_TB   Translation Blocking
  PCI_ACS_RR   P2P Request Redirect
  PCI_ACS_CR   P2P Completion Redirect
  PCI_ACS_UF   Upstream Forwarding
  PCI_ACS_EC   P2P Egress Control
  PCI_ACS_DT   Direct Translated P2P

(PCIe r5.0, sec 7.7.8.2) and use similar code structure in all.  No
functional change intended.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 502dca568d6c..ae62c0b058dd 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4333,18 +4333,18 @@ static bool pci_quirk_cavium_acs_match(struct pci_dev *dev)
 
 static int pci_quirk_cavium_acs(struct pci_dev *dev, u16 acs_flags)
 {
+	if (!pci_quirk_cavium_acs_match(dev))
+		return -ENOTTY;
+
 	/*
-	 * Cavium root ports don't advertise an ACS capability.  However,
+	 * Cavium Root Ports don't advertise an ACS capability.  However,
 	 * the RTL internally implements similar protection as if ACS had
-	 * Request Redirection, Completion Redirection, Source Validation,
+	 * Source Validation, Request Redirection, Completion Redirection,
 	 * and Upstream Forwarding features enabled.  Assert that the
 	 * hardware implements and enables equivalent ACS functionality for
 	 * these flags.
 	 */
-	acs_flags &= ~(PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_SV | PCI_ACS_UF);
-
-	if (!pci_quirk_cavium_acs_match(dev))
-		return -ENOTTY;
+	acs_flags &= ~(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
 
 	return acs_flags ? 0 : 1;
 }
@@ -4362,7 +4362,7 @@ static int pci_quirk_xgene_acs(struct pci_dev *dev, u16 acs_flags)
 }
 
 /*
- * Many Intel PCH root ports do provide ACS-like features to disable peer
+ * Many Intel PCH Root Ports do provide ACS-like features to disable peer
  * transactions and validate bus numbers in requests, but do not provide an
  * actual PCIe ACS capability.  This is the list of device IDs known to fall
  * into that category as provided by Intel in Red Hat bugzilla 1037684.
@@ -4410,37 +4410,34 @@ static bool pci_quirk_intel_pch_acs_match(struct pci_dev *dev)
 	return false;
 }
 
-#define INTEL_PCH_ACS_FLAGS (PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF | PCI_ACS_SV)
+#define INTEL_PCH_ACS_FLAGS (PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
 
 static int pci_quirk_intel_pch_acs(struct pci_dev *dev, u16 acs_flags)
 {
-	u16 flags = dev->dev_flags & PCI_DEV_FLAGS_ACS_ENABLED_QUIRK ?
-		    INTEL_PCH_ACS_FLAGS : 0;
-
 	if (!pci_quirk_intel_pch_acs_match(dev))
 		return -ENOTTY;
 
-	return acs_flags & ~flags ? 0 : 1;
+	if (dev->dev_flags & PCI_DEV_FLAGS_ACS_ENABLED_QUIRK)
+		acs_flags &= ~(INTEL_PCH_ACS_FLAGS);
+
+	return acs_flags ? 0 : 1;
 }
 
 /*
- * These QCOM root ports do provide ACS-like features to disable peer
+ * These QCOM Root Ports do provide ACS-like features to disable peer
  * transactions and validate bus numbers in requests, but do not provide an
  * actual PCIe ACS capability.  Hardware supports source validation but it
  * will report the issue as Completer Abort instead of ACS Violation.
- * Hardware doesn't support peer-to-peer and each root port is a root
- * complex with unique segment numbers.  It is not possible for one root
- * port to pass traffic to another root port.  All PCIe transactions are
- * terminated inside the root port.
+ * Hardware doesn't support peer-to-peer and each Root Port is a Root
+ * Complex with unique segment numbers.  It is not possible for one Root
+ * Port to pass traffic to another Root Port.  All PCIe transactions are
+ * terminated inside the Root Port.
  */
 static int pci_quirk_qcom_rp_acs(struct pci_dev *dev, u16 acs_flags)
 {
-	u16 flags = (PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF | PCI_ACS_SV);
-	int ret = acs_flags & ~flags ? 0 : 1;
-
-	pci_info(dev, "Using QCOM ACS Quirk (%d)\n", ret);
+	acs_flags &= ~(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
 
-	return ret;
+	return acs_flags ? 0 : 1;
 }
 
 /*
-- 
2.25.1



