Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40AA6420CA2
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234095AbhJDNHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:07:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235218AbhJDNFv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:05:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D87F61B45;
        Mon,  4 Oct 2021 13:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352463;
        bh=aUtq6nC8x9VuakQlgtD4rxRyH90Km3Qxi4Ec0VxDTLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KqhKn9QL3FRz33n5wm3HAXxRPmmtcFxCW26AnrJZFqmBoy6sD9ryD2pE+kBFCEGJn
         6pTqobQ+18gk99em+KQqhJPq+T7wNFYmi2F9qgNuprNM5dDZuN5IVNIb+3r+DpJ4R9
         BvyJNVRqwUXcmwozCY4Q+AefNlX9bTSzyhmEyUTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Victor Gu <xigu@marvell.com>,
        Evan Wang <xswang@marvell.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.14 39/75] PCI: aardvark: Fix checking for PIO status
Date:   Mon,  4 Oct 2021 14:52:14 +0200
Message-Id: <20211004125032.825119385@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125031.530773667@linuxfoundation.org>
References: <20211004125031.530773667@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Wang <xswang@marvell.com>

commit fcb461e2bc8b83b7eaca20cb2221e8b940f2189c upstream.

There is an issue that when PCIe switch is connected to an Armada 3700
board, there will be lots of warnings about PIO errors when reading the
config space. According to Aardvark PIO read and write sequence in HW
specification, the current way to check PIO status has the following
issues:

1) For PIO read operation, it reports the error message, which should be
   avoided according to HW specification.

2) For PIO read and write operations, it only checks PIO operation complete
   status, which is not enough, and error status should also be checked.

This patch aligns the code with Aardvark PIO read and write sequence in HW
specification on PIO status check and fix the warnings when reading config
space.

[pali: Fix CRS handling when CRSSVE is not enabled]

Link: https://lore.kernel.org/r/20210722144041.12661-2-pali@kernel.org
Tested-by: Victor Gu <xigu@marvell.com>
Signed-off-by: Evan Wang <xswang@marvell.com>
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Victor Gu <xigu@marvell.com>
Reviewed-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org # b1bd5714472c ("PCI: aardvark: Indicate error in 'val' when config read fails")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/host/pci-aardvark.c |   62 ++++++++++++++++++++++++++++++++++------
 1 file changed, 54 insertions(+), 8 deletions(-)

--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -56,6 +56,7 @@
 #define   PIO_COMPLETION_STATUS_CRS		2
 #define   PIO_COMPLETION_STATUS_CA		4
 #define   PIO_NON_POSTED_REQ			BIT(10)
+#define   PIO_ERR_STATUS			BIT(11)
 #define PIO_ADDR_LS				(PIO_BASE_ADDR + 0x8)
 #define PIO_ADDR_MS				(PIO_BASE_ADDR + 0xc)
 #define PIO_WR_DATA				(PIO_BASE_ADDR + 0x10)
@@ -374,7 +375,7 @@ static void advk_pcie_setup_hw(struct ad
 	advk_writel(pcie, reg, PCIE_CORE_CMD_STATUS_REG);
 }
 
-static void advk_pcie_check_pio_status(struct advk_pcie *pcie)
+static int advk_pcie_check_pio_status(struct advk_pcie *pcie, u32 *val)
 {
 	struct device *dev = &pcie->pdev->dev;
 	u32 reg;
@@ -385,14 +386,49 @@ static void advk_pcie_check_pio_status(s
 	status = (reg & PIO_COMPLETION_STATUS_MASK) >>
 		PIO_COMPLETION_STATUS_SHIFT;
 
-	if (!status)
-		return;
-
+	/*
+	 * According to HW spec, the PIO status check sequence as below:
+	 * 1) even if COMPLETION_STATUS(bit9:7) indicates successful,
+	 *    it still needs to check Error Status(bit11), only when this bit
+	 *    indicates no error happen, the operation is successful.
+	 * 2) value Unsupported Request(1) of COMPLETION_STATUS(bit9:7) only
+	 *    means a PIO write error, and for PIO read it is successful with
+	 *    a read value of 0xFFFFFFFF.
+	 * 3) value Completion Retry Status(CRS) of COMPLETION_STATUS(bit9:7)
+	 *    only means a PIO write error, and for PIO read it is successful
+	 *    with a read value of 0xFFFF0001.
+	 * 4) value Completer Abort (CA) of COMPLETION_STATUS(bit9:7) means
+	 *    error for both PIO read and PIO write operation.
+	 * 5) other errors are indicated as 'unknown'.
+	 */
 	switch (status) {
+	case PIO_COMPLETION_STATUS_OK:
+		if (reg & PIO_ERR_STATUS) {
+			strcomp_status = "COMP_ERR";
+			break;
+		}
+		/* Get the read result */
+		if (val)
+			*val = advk_readl(pcie, PIO_RD_DATA);
+		/* No error */
+		strcomp_status = NULL;
+		break;
 	case PIO_COMPLETION_STATUS_UR:
 		strcomp_status = "UR";
 		break;
 	case PIO_COMPLETION_STATUS_CRS:
+		/* PCIe r4.0, sec 2.3.2, says:
+		 * If CRS Software Visibility is not enabled, the Root Complex
+		 * must re-issue the Configuration Request as a new Request.
+		 * A Root Complex implementation may choose to limit the number
+		 * of Configuration Request/CRS Completion Status loops before
+		 * determining that something is wrong with the target of the
+		 * Request and taking appropriate action, e.g., complete the
+		 * Request to the host as a failed transaction.
+		 *
+		 * To simplify implementation do not re-issue the Configuration
+		 * Request and complete the Request as a failed transaction.
+		 */
 		strcomp_status = "CRS";
 		break;
 	case PIO_COMPLETION_STATUS_CA:
@@ -403,6 +439,9 @@ static void advk_pcie_check_pio_status(s
 		break;
 	}
 
+	if (!strcomp_status)
+		return 0;
+
 	if (reg & PIO_NON_POSTED_REQ)
 		str_posted = "Non-posted";
 	else
@@ -410,6 +449,8 @@ static void advk_pcie_check_pio_status(s
 
 	dev_err(dev, "%s PIO Response Status: %s, %#x @ %#x\n",
 		str_posted, strcomp_status, reg, advk_readl(pcie, PIO_ADDR_LS));
+
+	return -EFAULT;
 }
 
 static int advk_pcie_wait_pio(struct advk_pcie *pcie)
@@ -502,10 +543,13 @@ static int advk_pcie_rd_conf(struct pci_
 	if (ret < 0)
 		return PCIBIOS_SET_FAILED;
 
-	advk_pcie_check_pio_status(pcie);
+	/* Check PIO status and get the read result */
+	ret = advk_pcie_check_pio_status(pcie, val);
+	if (ret < 0) {
+		*val = 0xffffffff;
+		return PCIBIOS_SET_FAILED;
+	}
 
-	/* Get the read result */
-	*val = advk_readl(pcie, PIO_RD_DATA);
 	if (size == 1)
 		*val = (*val >> (8 * (where & 3))) & 0xff;
 	else if (size == 2)
@@ -565,7 +609,9 @@ static int advk_pcie_wr_conf(struct pci_
 	if (ret < 0)
 		return PCIBIOS_SET_FAILED;
 
-	advk_pcie_check_pio_status(pcie);
+	ret = advk_pcie_check_pio_status(pcie, NULL);
+	if (ret < 0)
+		return PCIBIOS_SET_FAILED;
 
 	return PCIBIOS_SUCCESSFUL;
 }


