Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487D245DBE9
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 15:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350648AbhKYOJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 09:09:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:37670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350724AbhKYOHg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 09:07:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 821CD610CA;
        Thu, 25 Nov 2021 14:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637849064;
        bh=bmSNd77ZHw3t6j+tHrz4+LbrfwPEACHZOiS/LVmGrss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sX0MNhuj1wsxYCzm1OYeSMXUmmMxEv+MK/dPQgMggrwWzrkvx0VTvgc32dHF5Mm+D
         Na+I1bOP7TMPyc2ljZ3hN1T5XCSrbdzAfMc7ASKnOSp7kfeBuOIc+5VPk6uuQEiXdT
         sOFNoabUxSCfSc31pyWfXLsGFhr27p9W+oVUszhqjOyhSZ6dcR6Ip1uuGHc0xj7dgI
         yk7gOXEc5HB8w2XlJl2ldYwMLp9Le1yLijiXemZiZRJFb4WK4NhpMnoXpI54iiPQgp
         0cPffkJRRSUj4WLSTFSvKJgpVkxsNdi/hRxXfaLxMjfIkG47tWtJu6AXB6xXz+HvDP
         pj5/l9yoVcRLA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.15 2/4] PCI: aardvark: Implement re-issuing config requests on CRS response
Date:   Thu, 25 Nov 2021 15:04:14 +0100
Message-Id: <20211125140416.15181-3-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211125140416.15181-1-kabel@kernel.org>
References: <20211125140416.15181-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 223dec14a05337a4155f1deed46d2becce4d00fd upstream.

Commit 43f5c77bcbd2 ("PCI: aardvark: Fix reporting CRS value") fixed
handling of CRS response and when CRSSVE flag was not enabled it marked CRS
response as failed transaction (due to simplicity).

But pci-aardvark.c driver is already waiting up to the PIO_RETRY_CNT count
for PIO config response and so we can with a small change implement
re-issuing of config requests as described in PCIe base specification.

This change implements re-issuing of config requests when response is CRS.
Set upper bound of wait cycles to around PIO_RETRY_CNT, afterwards the
transaction is marked as failed and an all-ones value is returned as
before.

We do this by returning appropriate error codes from function
advk_pcie_check_pio_status(). On CRS we return -EAGAIN and caller then
reissues transaction.

Link: https://lore.kernel.org/r/20211005180952.6812-10-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 67 +++++++++++++++++----------
 1 file changed, 43 insertions(+), 24 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 6eea7d5aac26..ff243be8410c 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -692,6 +692,7 @@ static int advk_pcie_check_pio_status(struct advk_pcie *pcie, bool allow_crs, u3
 	u32 reg;
 	unsigned int status;
 	char *strcomp_status, *str_posted;
+	int ret;
 
 	reg = advk_readl(pcie, PIO_STAT);
 	status = (reg & PIO_COMPLETION_STATUS_MASK) >>
@@ -716,6 +717,7 @@ static int advk_pcie_check_pio_status(struct advk_pcie *pcie, bool allow_crs, u3
 	case PIO_COMPLETION_STATUS_OK:
 		if (reg & PIO_ERR_STATUS) {
 			strcomp_status = "COMP_ERR";
+			ret = -EFAULT;
 			break;
 		}
 		/* Get the read result */
@@ -723,9 +725,11 @@ static int advk_pcie_check_pio_status(struct advk_pcie *pcie, bool allow_crs, u3
 			*val = advk_readl(pcie, PIO_RD_DATA);
 		/* No error */
 		strcomp_status = NULL;
+		ret = 0;
 		break;
 	case PIO_COMPLETION_STATUS_UR:
 		strcomp_status = "UR";
+		ret = -EOPNOTSUPP;
 		break;
 	case PIO_COMPLETION_STATUS_CRS:
 		if (allow_crs && val) {
@@ -743,6 +747,7 @@ static int advk_pcie_check_pio_status(struct advk_pcie *pcie, bool allow_crs, u3
 			 */
 			*val = CFG_RD_CRS_VAL;
 			strcomp_status = NULL;
+			ret = 0;
 			break;
 		}
 		/* PCIe r4.0, sec 2.3.2, says:
@@ -758,21 +763,24 @@ static int advk_pcie_check_pio_status(struct advk_pcie *pcie, bool allow_crs, u3
 		 * Request and taking appropriate action, e.g., complete the
 		 * Request to the host as a failed transaction.
 		 *
-		 * To simplify implementation do not re-issue the Configuration
-		 * Request and complete the Request as a failed transaction.
+		 * So return -EAGAIN and caller (pci-aardvark.c driver) will
+		 * re-issue request again up to the PIO_RETRY_CNT retries.
 		 */
 		strcomp_status = "CRS";
+		ret = -EAGAIN;
 		break;
 	case PIO_COMPLETION_STATUS_CA:
 		strcomp_status = "CA";
+		ret = -ECANCELED;
 		break;
 	default:
 		strcomp_status = "Unknown";
+		ret = -EINVAL;
 		break;
 	}
 
 	if (!strcomp_status)
-		return 0;
+		return ret;
 
 	if (reg & PIO_NON_POSTED_REQ)
 		str_posted = "Non-posted";
@@ -782,7 +790,7 @@ static int advk_pcie_check_pio_status(struct advk_pcie *pcie, bool allow_crs, u3
 	dev_dbg(dev, "%s PIO Response Status: %s, %#x @ %#x\n",
 		str_posted, strcomp_status, reg, advk_readl(pcie, PIO_ADDR_LS));
 
-	return -EFAULT;
+	return ret;
 }
 
 static int advk_pcie_wait_pio(struct advk_pcie *pcie)
@@ -790,13 +798,13 @@ static int advk_pcie_wait_pio(struct advk_pcie *pcie)
 	struct device *dev = &pcie->pdev->dev;
 	int i;
 
-	for (i = 0; i < PIO_RETRY_CNT; i++) {
+	for (i = 1; i <= PIO_RETRY_CNT; i++) {
 		u32 start, isr;
 
 		start = advk_readl(pcie, PIO_START);
 		isr = advk_readl(pcie, PIO_ISR);
 		if (!start && isr)
-			return 0;
+			return i;
 		udelay(PIO_RETRY_DELAY);
 	}
 
@@ -1068,6 +1076,7 @@ static int advk_pcie_rd_conf(struct pci_bus *bus, u32 devfn,
 			     int where, int size, u32 *val)
 {
 	struct advk_pcie *pcie = bus->sysdata;
+	int retry_count;
 	bool allow_crs;
 	u32 reg;
 	int ret;
@@ -1110,16 +1119,22 @@ static int advk_pcie_rd_conf(struct pci_bus *bus, u32 devfn,
 	/* Program the data strobe */
 	advk_writel(pcie, 0xf, PIO_WR_DATA_STRB);
 
-	/* Clear PIO DONE ISR and start the transfer */
-	advk_writel(pcie, 1, PIO_ISR);
-	advk_writel(pcie, 1, PIO_START);
+	retry_count = 0;
+	do {
+		/* Clear PIO DONE ISR and start the transfer */
+		advk_writel(pcie, 1, PIO_ISR);
+		advk_writel(pcie, 1, PIO_START);
 
-	ret = advk_pcie_wait_pio(pcie);
-	if (ret < 0)
-		goto try_crs;
+		ret = advk_pcie_wait_pio(pcie);
+		if (ret < 0)
+			goto try_crs;
+
+		retry_count += ret;
+
+		/* Check PIO status and get the read result */
+		ret = advk_pcie_check_pio_status(pcie, allow_crs, val);
+	} while (ret == -EAGAIN && retry_count < PIO_RETRY_CNT);
 
-	/* Check PIO status and get the read result */
-	ret = advk_pcie_check_pio_status(pcie, allow_crs, val);
 	if (ret < 0)
 		goto fail;
 
@@ -1151,6 +1166,7 @@ static int advk_pcie_wr_conf(struct pci_bus *bus, u32 devfn,
 	struct advk_pcie *pcie = bus->sysdata;
 	u32 reg;
 	u32 data_strobe = 0x0;
+	int retry_count;
 	int offset;
 	int ret;
 
@@ -1192,19 +1208,22 @@ static int advk_pcie_wr_conf(struct pci_bus *bus, u32 devfn,
 	/* Program the data strobe */
 	advk_writel(pcie, data_strobe, PIO_WR_DATA_STRB);
 
-	/* Clear PIO DONE ISR and start the transfer */
-	advk_writel(pcie, 1, PIO_ISR);
-	advk_writel(pcie, 1, PIO_START);
+	retry_count = 0;
+	do {
+		/* Clear PIO DONE ISR and start the transfer */
+		advk_writel(pcie, 1, PIO_ISR);
+		advk_writel(pcie, 1, PIO_START);
 
-	ret = advk_pcie_wait_pio(pcie);
-	if (ret < 0)
-		return PCIBIOS_SET_FAILED;
+		ret = advk_pcie_wait_pio(pcie);
+		if (ret < 0)
+			return PCIBIOS_SET_FAILED;
 
-	ret = advk_pcie_check_pio_status(pcie, false, NULL);
-	if (ret < 0)
-		return PCIBIOS_SET_FAILED;
+		retry_count += ret;
 
-	return PCIBIOS_SUCCESSFUL;
+		ret = advk_pcie_check_pio_status(pcie, false, NULL);
+	} while (ret == -EAGAIN && retry_count < PIO_RETRY_CNT);
+
+	return ret < 0 ? PCIBIOS_SET_FAILED : PCIBIOS_SUCCESSFUL;
 }
 
 static struct pci_ops advk_pcie_ops = {
-- 
2.32.0

