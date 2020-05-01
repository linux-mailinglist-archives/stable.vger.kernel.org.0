Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C671C1614
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730861AbgEANjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:39:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729861AbgEANjT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:39:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 850F5205C9;
        Fri,  1 May 2020 13:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340359;
        bh=paTia634a73T7GFWMtcfe5TtLx6sLr/2SPBtIisZod0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kbtZwfUbleA/ti0RssfJ7YqJAQQHrGmcgJdGDnW2ua5RRw4cvzOMiuboVJxPFdiPb
         KqEnFjaTt6QyTYA0ijKackNbEbpVG7nPdIyFb9IB5lCzNNMD20DQcSE2ihIlENBeN3
         uG183cjomy95UtisrHXnKUCmnHYRt7W5SrJl8Z14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5.4 33/83] PCI: Unify ACS quirk desired vs provided checking
Date:   Fri,  1 May 2020 15:23:12 +0200
Message-Id: <20200501131532.212669424@linuxfoundation.org>
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

commit 7cf2cba43f15c74bac46dc5f0326805d25ef514d upstream.

Most of the ACS quirks have a similar pattern of:

  acs_flags &= ~( <controls provided by this device> );
  return acs_flags ? 0 : 1;

Pull this out into a helper function to simplify the quirks slightly.  The
helper function is also a convenient place for comments about what the list
of ACS controls means.  No functional change intended.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/quirks.c |   67 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 22 deletions(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4353,6 +4353,24 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_C
 			 quirk_chelsio_T5_disable_root_port_attributes);
 
 /*
+ * pci_acs_ctrl_enabled - compare desired ACS controls with those provided
+ *			  by a device
+ * @acs_ctrl_req: Bitmask of desired ACS controls
+ * @acs_ctrl_ena: Bitmask of ACS controls enabled or provided implicitly by
+ *		  the hardware design
+ *
+ * Return 1 if all ACS controls in the @acs_ctrl_req bitmask are included
+ * in @acs_ctrl_ena, i.e., the device provides all the access controls the
+ * caller desires.  Return 0 otherwise.
+ */
+static int pci_acs_ctrl_enabled(u16 acs_ctrl_req, u16 acs_ctrl_ena)
+{
+	if ((acs_ctrl_req & acs_ctrl_ena) == acs_ctrl_req)
+		return 1;
+	return 0;
+}
+
+/*
  * AMD has indicated that the devices below do not support peer-to-peer
  * in any system where they are found in the southbridge with an AMD
  * IOMMU in the system.  Multifunction devices that do not support
@@ -4395,7 +4413,7 @@ static int pci_quirk_amd_sb_acs(struct p
 	/* Filter out flags not applicable to multifunction */
 	acs_flags &= (PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_EC | PCI_ACS_DT);
 
-	return acs_flags & ~(PCI_ACS_RR | PCI_ACS_CR) ? 0 : 1;
+	return pci_acs_ctrl_enabled(acs_flags, PCI_ACS_RR | PCI_ACS_CR);
 #else
 	return -ENODEV;
 #endif
@@ -4433,9 +4451,8 @@ static int pci_quirk_cavium_acs(struct p
 	 * hardware implements and enables equivalent ACS functionality for
 	 * these flags.
 	 */
-	acs_flags &= ~(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
-
-	return acs_flags ? 0 : 1;
+	return pci_acs_ctrl_enabled(acs_flags,
+		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
 }
 
 static int pci_quirk_xgene_acs(struct pci_dev *dev, u16 acs_flags)
@@ -4445,9 +4462,8 @@ static int pci_quirk_xgene_acs(struct pc
 	 * transactions with others, allowing masking out these bits as if they
 	 * were unimplemented in the ACS capability.
 	 */
-	acs_flags &= ~(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
-
-	return acs_flags ? 0 : 1;
+	return pci_acs_ctrl_enabled(acs_flags,
+		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
 }
 
 /*
@@ -4499,17 +4515,16 @@ static bool pci_quirk_intel_pch_acs_matc
 	return false;
 }
 
-#define INTEL_PCH_ACS_FLAGS (PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
-
 static int pci_quirk_intel_pch_acs(struct pci_dev *dev, u16 acs_flags)
 {
 	if (!pci_quirk_intel_pch_acs_match(dev))
 		return -ENOTTY;
 
 	if (dev->dev_flags & PCI_DEV_FLAGS_ACS_ENABLED_QUIRK)
-		acs_flags &= ~(INTEL_PCH_ACS_FLAGS);
+		return pci_acs_ctrl_enabled(acs_flags,
+			PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
 
-	return acs_flags ? 0 : 1;
+	return pci_acs_ctrl_enabled(acs_flags, 0);
 }
 
 /*
@@ -4524,9 +4539,8 @@ static int pci_quirk_intel_pch_acs(struc
  */
 static int pci_quirk_qcom_rp_acs(struct pci_dev *dev, u16 acs_flags)
 {
-	acs_flags &= ~(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
-
-	return acs_flags ? 0 : 1;
+	return pci_acs_ctrl_enabled(acs_flags,
+		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
 }
 
 static int pci_quirk_al_acs(struct pci_dev *dev, u16 acs_flags)
@@ -4627,7 +4641,7 @@ static int pci_quirk_intel_spt_pch_acs(s
 
 	pci_read_config_dword(dev, pos + INTEL_SPT_ACS_CTRL, &ctrl);
 
-	return acs_flags & ~ctrl ? 0 : 1;
+	return pci_acs_ctrl_enabled(acs_flags, ctrl);
 }
 
 static int pci_quirk_mf_endpoint_acs(struct pci_dev *dev, u16 acs_flags)
@@ -4641,10 +4655,9 @@ static int pci_quirk_mf_endpoint_acs(str
 	 * perform peer-to-peer with other functions, allowing us to mask out
 	 * these bits as if they were unimplemented in the ACS capability.
 	 */
-	acs_flags &= ~(PCI_ACS_SV | PCI_ACS_TB | PCI_ACS_RR |
-		       PCI_ACS_CR | PCI_ACS_UF | PCI_ACS_DT);
-
-	return acs_flags ? 0 : 1;
+	return pci_acs_ctrl_enabled(acs_flags,
+		PCI_ACS_SV | PCI_ACS_TB | PCI_ACS_RR |
+		PCI_ACS_CR | PCI_ACS_UF | PCI_ACS_DT);
 }
 
 static int pci_quirk_brcm_acs(struct pci_dev *dev, u16 acs_flags)
@@ -4655,9 +4668,8 @@ static int pci_quirk_brcm_acs(struct pci
 	 * Allow each Root Port to be in a separate IOMMU group by masking
 	 * SV/RR/CR/UF bits.
 	 */
-	acs_flags &= ~(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
-
-	return acs_flags ? 0 : 1;
+	return pci_acs_ctrl_enabled(acs_flags,
+		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
 }
 
 static const struct pci_dev_acs_enabled {
@@ -4763,6 +4775,17 @@ static const struct pci_dev_acs_enabled
 	{ 0 }
 };
 
+/*
+ * pci_dev_specific_acs_enabled - check whether device provides ACS controls
+ * @dev:	PCI device
+ * @acs_flags:	Bitmask of desired ACS controls
+ *
+ * Returns:
+ *   -ENOTTY:	No quirk applies to this device; we can't tell whether the
+ *		device provides the desired controls
+ *   0:		Device does not provide all the desired controls
+ *   >0:	Device provides all the controls in @acs_flags
+ */
 int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags)
 {
 	const struct pci_dev_acs_enabled *i;


