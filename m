Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DCF45D937
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 12:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235252AbhKYLa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 06:30:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:49752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233934AbhKYL3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 06:29:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EEBF610F9;
        Thu, 25 Nov 2021 11:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637839584;
        bh=FY5auwmpWmSpSn2Fk/p/vsI0Jpm08r4vENmgFuLBNKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGguq2Gnk4beI97WWqQJM9aWXhJjq28RtSYuOEB/uhKEMawWZtLDUSuTTLr54BvPW
         15ZOHSLMHTfPqvIaAvU0gJTNUaEvsMzzA9sQl47yzjwTfodJhVaffX2EgdxYmSHND6
         5+DZU5Xi+S7gCnll6k4u8QvAXaWJpCekN6lz6zKVSbM8yWVoMY201jCPKkkOOz83y5
         ei/WwZ1xfhPRJQR6foj4+XmkIrebjXxyepWz+bizHt37KW1gfAZu5qbr6HBSoLRPHM
         TIuejdTnt6nomIO7y3UTCeTfZCNsSfiFodjdnmLT4CR97DNijr8rUV6wPXMFuTtb6X
         9DFp80ROZUSkg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.10 2/5] PCI: aardvark: Deduplicate code in advk_pcie_rd_conf()
Date:   Thu, 25 Nov 2021 12:26:09 +0100
Message-Id: <20211125112612.11501-3-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211125112612.11501-1-kabel@kernel.org>
References: <20211125112612.11501-1-kabel@kernel.org>
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
index 10c2c3877fcc..a19562de6186 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1097,18 +1097,8 @@ static int advk_pcie_rd_conf(struct pci_bus *bus, u32 devfn,
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
@@ -1132,25 +1122,13 @@ static int advk_pcie_rd_conf(struct pci_bus *bus, u32 devfn,
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
@@ -1158,6 +1136,20 @@ static int advk_pcie_rd_conf(struct pci_bus *bus, u32 devfn,
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

