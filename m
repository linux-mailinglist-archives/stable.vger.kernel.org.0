Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BFC201698
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389516AbgFSQce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:32:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389507AbgFSOvy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:51:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61DC2217D8;
        Fri, 19 Jun 2020 14:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578314;
        bh=d6fqHaRRMf3tGaHV6yly6LqbkKUS6wkDcL5VvOuKf0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YvU3Tg/wvXM/Mat9h1xFmEPnB49pRZD3VtWhb4/X6aEFVj1ZWbwUX65Mw6Le82ZVu
         JDkEWqZ0DI35s+6u06IStUWx4rySjojHB9ETdzbSVxoXjfyGZtsha3e1Fq4SbO5KbR
         90f9apWGeUVWVk6O901G9j3iYa1ILjNVHpkTFpos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 158/190] PCI: Unify ACS quirk desired vs provided checking
Date:   Fri, 19 Jun 2020 16:33:23 +0200
Message-Id: <20200619141641.637957150@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 7cf2cba43f15c74bac46dc5f0326805d25ef514d ]

Most of the ACS quirks have a similar pattern of:

  acs_flags &= ~( <controls provided by this device> );
  return acs_flags ? 0 : 1;

Pull this out into a helper function to simplify the quirks slightly.  The
helper function is also a convenient place for comments about what the list
of ACS controls means.  No functional change intended.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 67 +++++++++++++++++++++++++++++---------------
 1 file changed, 45 insertions(+), 22 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 0472e69833c8..5f26c170315c 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4236,6 +4236,24 @@ static void quirk_chelsio_T5_disable_root_port_attributes(struct pci_dev *pdev)
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_CHELSIO, PCI_ANY_ID,
 			 quirk_chelsio_T5_disable_root_port_attributes);
 
+/*
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
 /*
  * AMD has indicated that the devices below do not support peer-to-peer
  * in any system where they are found in the southbridge with an AMD
@@ -4279,7 +4297,7 @@ static int pci_quirk_amd_sb_acs(struct pci_dev *dev, u16 acs_flags)
 	/* Filter out flags not applicable to multifunction */
 	acs_flags &= (PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_EC | PCI_ACS_DT);
 
-	return acs_flags & ~(PCI_ACS_RR | PCI_ACS_CR) ? 0 : 1;
+	return pci_acs_ctrl_enabled(acs_flags, PCI_ACS_RR | PCI_ACS_CR);
 #else
 	return -ENODEV;
 #endif
@@ -4317,9 +4335,8 @@ static int pci_quirk_cavium_acs(struct pci_dev *dev, u16 acs_flags)
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
@@ -4329,9 +4346,8 @@ static int pci_quirk_xgene_acs(struct pci_dev *dev, u16 acs_flags)
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
@@ -4383,17 +4399,16 @@ static bool pci_quirk_intel_pch_acs_match(struct pci_dev *dev)
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
@@ -4408,9 +4423,8 @@ static int pci_quirk_intel_pch_acs(struct pci_dev *dev, u16 acs_flags)
  */
 static int pci_quirk_qcom_rp_acs(struct pci_dev *dev, u16 acs_flags)
 {
-	acs_flags &= ~(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
-
-	return acs_flags ? 0 : 1;
+	return pci_acs_ctrl_enabled(acs_flags,
+		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
 }
 
 /*
@@ -4493,7 +4507,7 @@ static int pci_quirk_intel_spt_pch_acs(struct pci_dev *dev, u16 acs_flags)
 
 	pci_read_config_dword(dev, pos + INTEL_SPT_ACS_CTRL, &ctrl);
 
-	return acs_flags & ~ctrl ? 0 : 1;
+	return pci_acs_ctrl_enabled(acs_flags, ctrl);
 }
 
 static int pci_quirk_mf_endpoint_acs(struct pci_dev *dev, u16 acs_flags)
@@ -4507,10 +4521,9 @@ static int pci_quirk_mf_endpoint_acs(struct pci_dev *dev, u16 acs_flags)
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
 
 static int pci_quirk_rciep_acs(struct pci_dev *dev, u16 acs_flags)
@@ -4535,9 +4548,8 @@ static int pci_quirk_brcm_acs(struct pci_dev *dev, u16 acs_flags)
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
@@ -4636,6 +4648,17 @@ static const struct pci_dev_acs_enabled {
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
-- 
2.25.1



