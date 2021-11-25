Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFB345D214
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 01:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244591AbhKYAeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 19:34:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:46914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245407AbhKYAbm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 19:31:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBC18610FB;
        Thu, 25 Nov 2021 00:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637800005;
        bh=rBYFJYHlRMtJNVYym2+jbouayhUKgWwrCG8TZhnOs+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QVx5OuWnEZPBO90AnocCFUVDrv21OWYqdWIhB+w2DfEyeOPqf5Sg6RDqnVbKbNiwX
         Oq8ZRlHpaMlAB/aMF6YVqVV+d3C7pCTS4YQspQ0dAujGWUCA/5o7bTo2rQM80pBFd0
         SwCmgzY665Z9AqEXOpx08pVuvfffS8C1lrpaQ8xPPBrUMWfgMlvzFNeKpGrvkhwhq/
         +UvUWpAZS3ZiNHAEe6C8MNrFCIqwzPrzSCg/9KjIVWC/97QL57/Qwwa9x5V4EAhGaW
         qJUGxIZRSbm6YqFPw/VQPMTjOghxiEFKAuNmWFYzT78xfjg2GcvoTgIjCvnnNDKQSf
         9QExfbhyo6fcg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.4 14/22] PCI: aardvark: Deduplicate code in advk_pcie_rd_conf()
Date:   Thu, 25 Nov 2021 01:26:08 +0100
Message-Id: <20211125002616.31363-15-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211125002616.31363-1-kabel@kernel.org>
References: <20211125002616.31363-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 67cb2a4c93499c2c22704998fd1fd2bc35194d8e upstream

Avoid code repetition in advk_pcie_rd_conf() by handling errors with
goto jump, as is customary in kernel.

Link: https://lore.kernel.org/r/20211005180952.6812-9-kabel@kernel.org
Fixes: 43f5c77bcbd2 ("PCI: aardvark: Fix reporting CRS value")
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 48 +++++++++++----------------
 1 file changed, 20 insertions(+), 28 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index ef4555a28b95..47becbaf2103 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -996,18 +996,8 @@ static int advk_pcie_rd_conf(struct pci_bus *bus, u32 devfn,
 		    (le16_to_cpu(pcie->bridge.pcie_conf.rootctl) &
 		     PCI_EXP_RTCTL_CRSSVE);
 
-	if (advk_pcie_pio_is_running(pcie)) {
-		/*
-		 * If it is possible return Completion Retry Status so caller
-		 * tries to issue the request again instead of failing.
-		 */
-		if (allow_crs) {
-			*val = CFG_RD_CRS_VAL;
-			return PCIBIOS_SUCCESSFUL;
-		}
-		*val = 0xffffffff;
-		return PCIBIOS_SET_FAILED;
-	}
+	if (advk_pcie_pio_is_running(pcie))
+		goto try_crs;
 
 	/* Program the control register */
 	reg = advk_readl(pcie, PIO_CTRL);
@@ -1031,25 +1021,13 @@ static int advk_pcie_rd_conf(struct pci_bus *bus, u32 devfn,
 	advk_writel(pcie, 1, PIO_START);
 
 	ret = advk_pcie_wait_pio(pcie);
-	if (ret < 0) {
-		/*
-		 * If it is possible return Completion Retry Status so caller
-		 * tries to issue the request again instead of failing.
-		 */
-		if (allow_crs) {
-			*val = CFG_RD_CRS_VAL;
-			return PCIBIOS_SUCCESSFUL;
-		}
-		*val = 0xffffffff;
-		return PCIBIOS_SET_FAILED;
-	}
+	if (ret < 0)
+		goto try_crs;
 
 	/* Check PIO status and get the read result */
 	ret = advk_pcie_check_pio_status(pcie, allow_crs, val);
-	if (ret < 0) {
-		*val = 0xffffffff;
-		return PCIBIOS_SET_FAILED;
-	}
+	if (ret < 0)
+		goto fail;
 
 	if (size == 1)
 		*val = (*val >> (8 * (where & 3))) & 0xff;
@@ -1057,6 +1035,20 @@ static int advk_pcie_rd_conf(struct pci_bus *bus, u32 devfn,
 		*val = (*val >> (8 * (where & 3))) & 0xffff;
 
 	return PCIBIOS_SUCCESSFUL;
+
+try_crs:
+	/*
+	 * If it is possible, return Completion Retry Status so that caller
+	 * tries to issue the request again instead of failing.
+	 */
+	if (allow_crs) {
+		*val = CFG_RD_CRS_VAL;
+		return PCIBIOS_SUCCESSFUL;
+	}
+
+fail:
+	*val = 0xffffffff;
+	return PCIBIOS_SET_FAILED;
 }
 
 static int advk_pcie_wr_conf(struct pci_bus *bus, u32 devfn,
-- 
2.32.0

