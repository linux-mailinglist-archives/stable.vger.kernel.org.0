Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96D12F3117
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbhALNPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:15:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:54588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403945AbhALM5k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A5A52312B;
        Tue, 12 Jan 2021 12:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456161;
        bh=2LdQ232hbgeYUyVBsBiVvLkYLVQ0jEa/e7nrTDbQJNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mjhttrX/sLECpjtJvocMgUGI4v0HDS21C+julj477iMam0Mdq//SME86aY0J3MksF
         7DBDeNk6IwmsYZLklE5O3BmbHlIKUXgZRAxUsTUeKXmrtv+SS11Kts0ZNTdZBRDewa
         jQVeu2P/Q2GBAhq5HNQixlIQIPVo174/njmH7nDfX7cuoDRcWODDs7KJYaKOxJf8RC
         +kgLliyIrotO/RvVLD9DmjcRAI+zmTgNjgn6wn5TdBE1wUGhQpHoLo3vuQ6USqdKYm
         PeXDjqkM3Ea/5PYwbzS1Q5mwAZ0/fV6mTEq4+41d44+XIoW3C8R81sdnlzHgEtiSc1
         cIjSaPdtlkrhg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oded Gabbay <ogabbay@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 19/51] habanalabs: adjust pci controller init to new firmware
Date:   Tue, 12 Jan 2021 07:55:01 -0500
Message-Id: <20210112125534.70280-19-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oded Gabbay <ogabbay@kernel.org>

[ Upstream commit 377182a3cc5ae6cc17fb04d06864c975f9f71c18 ]

When the firmware security is enabled, the pcie_aux_dbi_reg_addr
register in the PCI controller is blocked. Therefore, ignore
the result of writing to this register and assume it worked. Also
remove the prints on errors in the internal ELBI write function.

If the security is enabled, the firmware is responsible for setting
this register correctly so we won't have any problem.

If the security is disabled, the write will work (unless something
is totally broken at the PCI level and then the whole sequence
will fail).

In addition, remove a write to register pcie_aux_dbi_reg_addr+4,
which was never actually needed.

Moreover, PCIE_DBI registers are blocked to access from host when
firmware security is enabled. Use a different register to flush the
writes.

Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/pci.c          | 28 +++++++++++--------
 drivers/misc/habanalabs/gaudi/gaudi.c         |  4 +--
 .../misc/habanalabs/gaudi/gaudi_coresight.c   |  3 +-
 3 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/misc/habanalabs/common/pci.c b/drivers/misc/habanalabs/common/pci.c
index 4327e5704ebb6..607f9a11fba1a 100644
--- a/drivers/misc/habanalabs/common/pci.c
+++ b/drivers/misc/habanalabs/common/pci.c
@@ -130,10 +130,8 @@ static int hl_pci_elbi_write(struct hl_device *hdev, u64 addr, u32 data)
 	if ((val & PCI_CONFIG_ELBI_STS_MASK) == PCI_CONFIG_ELBI_STS_DONE)
 		return 0;
 
-	if (val & PCI_CONFIG_ELBI_STS_ERR) {
-		dev_err(hdev->dev, "Error writing to ELBI\n");
+	if (val & PCI_CONFIG_ELBI_STS_ERR)
 		return -EIO;
-	}
 
 	if (!(val & PCI_CONFIG_ELBI_STS_MASK)) {
 		dev_err(hdev->dev, "ELBI write didn't finish in time\n");
@@ -160,8 +158,12 @@ int hl_pci_iatu_write(struct hl_device *hdev, u32 addr, u32 data)
 
 	dbi_offset = addr & 0xFFF;
 
-	rc = hl_pci_elbi_write(hdev, prop->pcie_aux_dbi_reg_addr, 0x00300000);
-	rc |= hl_pci_elbi_write(hdev, prop->pcie_dbi_base_address + dbi_offset,
+	/* Ignore result of writing to pcie_aux_dbi_reg_addr as it could fail
+	 * in case the firmware security is enabled
+	 */
+	hl_pci_elbi_write(hdev, prop->pcie_aux_dbi_reg_addr, 0x00300000);
+
+	rc = hl_pci_elbi_write(hdev, prop->pcie_dbi_base_address + dbi_offset,
 				data);
 
 	if (rc)
@@ -244,9 +246,11 @@ int hl_pci_set_inbound_region(struct hl_device *hdev, u8 region,
 
 	rc |= hl_pci_iatu_write(hdev, offset + 0x4, ctrl_reg_val);
 
-	/* Return the DBI window to the default location */
-	rc |= hl_pci_elbi_write(hdev, prop->pcie_aux_dbi_reg_addr, 0);
-	rc |= hl_pci_elbi_write(hdev, prop->pcie_aux_dbi_reg_addr + 4, 0);
+	/* Return the DBI window to the default location
+	 * Ignore result of writing to pcie_aux_dbi_reg_addr as it could fail
+	 * in case the firmware security is enabled
+	 */
+	hl_pci_elbi_write(hdev, prop->pcie_aux_dbi_reg_addr, 0);
 
 	if (rc)
 		dev_err(hdev->dev, "failed to map bar %u to 0x%08llx\n",
@@ -294,9 +298,11 @@ int hl_pci_set_outbound_region(struct hl_device *hdev,
 	/* Enable */
 	rc |= hl_pci_iatu_write(hdev, 0x004, 0x80000000);
 
-	/* Return the DBI window to the default location */
-	rc |= hl_pci_elbi_write(hdev, prop->pcie_aux_dbi_reg_addr, 0);
-	rc |= hl_pci_elbi_write(hdev, prop->pcie_aux_dbi_reg_addr + 4, 0);
+	/* Return the DBI window to the default location
+	 * Ignore result of writing to pcie_aux_dbi_reg_addr as it could fail
+	 * in case the firmware security is enabled
+	 */
+	hl_pci_elbi_write(hdev, prop->pcie_aux_dbi_reg_addr, 0);
 
 	return rc;
 }
diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 7ea6b4368a913..36f0bb7154ab9 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -2893,7 +2893,7 @@ static int gaudi_init_cpu_queues(struct hl_device *hdev, u32 cpu_timeout)
 static void gaudi_pre_hw_init(struct hl_device *hdev)
 {
 	/* Perform read from the device to make sure device is up */
-	RREG32(mmPCIE_DBI_DEVICE_ID_VENDOR_ID_REG);
+	RREG32(mmHW_STATE);
 
 	/* Set the access through PCI bars (Linux driver only) as
 	 * secured
@@ -2996,7 +2996,7 @@ static int gaudi_hw_init(struct hl_device *hdev)
 	}
 
 	/* Perform read from the device to flush all configuration */
-	RREG32(mmPCIE_DBI_DEVICE_ID_VENDOR_ID_REG);
+	RREG32(mmHW_STATE);
 
 	return 0;
 
diff --git a/drivers/misc/habanalabs/gaudi/gaudi_coresight.c b/drivers/misc/habanalabs/gaudi/gaudi_coresight.c
index 3d2b0f0f46507..283d37b76447e 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi_coresight.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi_coresight.c
@@ -9,6 +9,7 @@
 #include "../include/gaudi/gaudi_coresight.h"
 #include "../include/gaudi/asic_reg/gaudi_regs.h"
 #include "../include/gaudi/gaudi_masks.h"
+#include "../include/gaudi/gaudi_reg_map.h"
 
 #include <uapi/misc/habanalabs.h>
 #include <linux/coresight.h>
@@ -876,7 +877,7 @@ int gaudi_debug_coresight(struct hl_device *hdev, void *data)
 	}
 
 	/* Perform read from the device to flush all configuration */
-	RREG32(mmPCIE_DBI_DEVICE_ID_VENDOR_ID_REG);
+	RREG32(mmHW_STATE);
 
 	return rc;
 }
-- 
2.27.0

