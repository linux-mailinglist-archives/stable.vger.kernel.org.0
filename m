Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F1A1C169D
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730663AbgEANu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731174AbgEANjR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:39:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FAD6208DB;
        Fri,  1 May 2020 13:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340356;
        bh=uNz9X7jFv1095SN1iz30H01MoEYgyreaxlkOKw/rAGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a19R4WbkA4Q13BtQIg6XdBEpB0+JIbQh/B9QVhylidrlLeUeQCYGBgUBXtkbOFjp/
         YYjAygzZVO+WEJiK2UQX/h5cMPaLPwCcQeOKzgBGYmgJ1FA0DHJJ1OEsnXpDPZClnG
         NPAqVTOGJIdWPJCY+5n7Cm+46/LBEVb4hMoL/8o8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5.4 32/83] PCI: Make ACS quirk implementations more uniform
Date:   Fri,  1 May 2020 15:23:11 +0200
Message-Id: <20200501131531.779800051@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131524.004332640@linuxfoundation.org>
References: <20200501131524.004332640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

commit c8de8ed2dcaac82e5d76d467dc0b02e0ee79809b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/quirks.c |   41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4422,18 +4422,18 @@ static bool pci_quirk_cavium_acs_match(s
 
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
@@ -4451,7 +4451,7 @@ static int pci_quirk_xgene_acs(struct pc
 }
 
 /*
- * Many Intel PCH root ports do provide ACS-like features to disable peer
+ * Many Intel PCH Root Ports do provide ACS-like features to disable peer
  * transactions and validate bus numbers in requests, but do not provide an
  * actual PCIe ACS capability.  This is the list of device IDs known to fall
  * into that category as provided by Intel in Red Hat bugzilla 1037684.
@@ -4499,37 +4499,34 @@ static bool pci_quirk_intel_pch_acs_matc
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
 
 static int pci_quirk_al_acs(struct pci_dev *dev, u16 acs_flags)


