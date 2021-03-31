Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F19E34424B
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbhCVMkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231840AbhCVMiu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:38:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A3C2619C1;
        Mon, 22 Mar 2021 12:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416674;
        bh=keqJFYGr5TvFydFeDPdC0e5xvn55gudL6Qswm4bk4OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xa3JaqTWtF23TSQN0Ff9aUgVjteRaqowXZyZA8unlkUgfs02vJQgK55EVUgf2LdML
         ObuAPq6LT80TN2BjR5bThO+rYvNBpl/QQewM1jnyMfJduV4pPj9v+M3Cc1IOHx9EYn
         aWLD2tM82sqe65xwgcdv5mAnrlvdrqo9bN1Qx83Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Joe Perches <joe@perches.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/157] scsi: pm8001: Neaten debug logging macros and uses
Date:   Mon, 22 Mar 2021 13:27:15 +0100
Message-Id: <20210322121936.248586201@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Perches <joe@perches.com>

[ Upstream commit 1b5d2793283dcb97b401b3b2c02b8a94eee29af1 ]

Every PM8001_<FOO>_DBG macro uses an internal call to pm8001_printk.

Convert all uses of:

	PM8001_<FOO>_DBG(hba, pm8001_printk(fmt, ...))
to
	pm8001_dbg(hba, <FOO>, fmt, ...)

so the visual complexity of each macro is reduced.

The repetitive macro definitions are converted to a single pm8001_dbg and
the level is concatenated using PM8001_##level##_LOGGING for the specific
level test.

Done with coccinelle, checkpatch and a little typing of the new macro
definition.

Miscellanea:

 - Coalesce formats

 - Realign arguments

 - Add missing terminating newlines to formats

 - Remove trailing spaces from formats

 - Change defective loop with printk(KERN_INFO... to emit a 16 byte hex
   block to %p16h

Link: https://lore.kernel.org/r/49f36a93af7752b613d03c89a87078243567fd9a.1605914030.git.joe@perches.com
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_ctl.c  |    7 +-
 drivers/scsi/pm8001/pm8001_hwi.c  | 1370 ++++++++++---------------
 drivers/scsi/pm8001/pm8001_init.c |   91 +-
 drivers/scsi/pm8001/pm8001_sas.c  |  132 +--
 drivers/scsi/pm8001/pm8001_sas.h  |   45 +-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 1596 ++++++++++++-----------------
 6 files changed, 1354 insertions(+), 1887 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 3587f7c8a428..12035baf0997 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -841,10 +841,9 @@ static ssize_t pm8001_store_update_fw(struct device *cdev,
 			       pm8001_ha->dev);
 
 	if (ret) {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk(
-			"Failed to load firmware image file %s,	error %d\n",
-			filename_ptr, ret));
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "Failed to load firmware image file %s, error %d\n",
+			   filename_ptr, ret);
 		pm8001_ha->fw_status = FAIL_OPEN_BIOS_FILE;
 		goto out;
 	}
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 2054c2b03d92..b72c0074b0e9 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -400,9 +400,9 @@ int pm8001_bar4_shift(struct pm8001_hba_info *pm8001_ha, u32 shiftValue)
 	} while ((regVal != shiftValue) && time_before(jiffies, start));
 
 	if (regVal != shiftValue) {
-		PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("TIMEOUT:SPC_IBW_AXI_TRANSLATION_LOW"
-			" = 0x%x\n", regVal));
+		pm8001_dbg(pm8001_ha, INIT,
+			   "TIMEOUT:SPC_IBW_AXI_TRANSLATION_LOW = 0x%x\n",
+			   regVal);
 		return -1;
 	}
 	return 0;
@@ -623,12 +623,10 @@ static void init_pci_device_addresses(struct pm8001_hba_info *pm8001_ha)
 
 	value = pm8001_cr32(pm8001_ha, 0, 0x44);
 	offset = value & 0x03FFFFFF;
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("Scratchpad 0 Offset: %x\n", offset));
+	pm8001_dbg(pm8001_ha, INIT, "Scratchpad 0 Offset: %x\n", offset);
 	pcilogic = (value & 0xFC000000) >> 26;
 	pcibar = get_pci_bar_index(pcilogic);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("Scratchpad 0 PCI BAR: %d\n", pcibar));
+	pm8001_dbg(pm8001_ha, INIT, "Scratchpad 0 PCI BAR: %d\n", pcibar);
 	pm8001_ha->main_cfg_tbl_addr = base_addr =
 		pm8001_ha->io_mem[pcibar].memvirtaddr + offset;
 	pm8001_ha->general_stat_tbl_addr =
@@ -652,16 +650,15 @@ static int pm8001_chip_init(struct pm8001_hba_info *pm8001_ha)
 	* as this is shared with BIOS data */
 	if (deviceid == 0x8081 || deviceid == 0x0042) {
 		if (-1 == pm8001_bar4_shift(pm8001_ha, GSM_SM_BASE)) {
-			PM8001_FAIL_DBG(pm8001_ha,
-				pm8001_printk("Shift Bar4 to 0x%x failed\n",
-					GSM_SM_BASE));
+			pm8001_dbg(pm8001_ha, FAIL,
+				   "Shift Bar4 to 0x%x failed\n",
+				   GSM_SM_BASE);
 			return -1;
 		}
 	}
 	/* check the firmware status */
 	if (-1 == check_fw_ready(pm8001_ha)) {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("Firmware is not ready!\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "Firmware is not ready!\n");
 		return -EBUSY;
 	}
 
@@ -686,8 +683,7 @@ static int pm8001_chip_init(struct pm8001_hba_info *pm8001_ha)
 	}
 	/* notify firmware update finished and check initialization status */
 	if (0 == mpi_init_check(pm8001_ha)) {
-		PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("MPI initialize successful!\n"));
+		pm8001_dbg(pm8001_ha, INIT, "MPI initialize successful!\n");
 	} else
 		return -EBUSY;
 	/*This register is a 16-bit timer with a resolution of 1us. This is the
@@ -709,9 +705,9 @@ static int mpi_uninit_check(struct pm8001_hba_info *pm8001_ha)
 	pci_read_config_word(pm8001_ha->pdev, PCI_DEVICE_ID, &deviceid);
 	if (deviceid == 0x8081 || deviceid == 0x0042) {
 		if (-1 == pm8001_bar4_shift(pm8001_ha, GSM_SM_BASE)) {
-			PM8001_FAIL_DBG(pm8001_ha,
-				pm8001_printk("Shift Bar4 to 0x%x failed\n",
-					GSM_SM_BASE));
+			pm8001_dbg(pm8001_ha, FAIL,
+				   "Shift Bar4 to 0x%x failed\n",
+				   GSM_SM_BASE);
 			return -1;
 		}
 	}
@@ -729,8 +725,8 @@ static int mpi_uninit_check(struct pm8001_hba_info *pm8001_ha)
 	} while ((value != 0) && (--max_wait_count));
 
 	if (!max_wait_count) {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("TIMEOUT:IBDB value/=0x%x\n", value));
+		pm8001_dbg(pm8001_ha, FAIL, "TIMEOUT:IBDB value/=0x%x\n",
+			   value);
 		return -1;
 	}
 
@@ -747,9 +743,8 @@ static int mpi_uninit_check(struct pm8001_hba_info *pm8001_ha)
 			break;
 	} while (--max_wait_count);
 	if (!max_wait_count) {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk(" TIME OUT MPI State = 0x%x\n",
-				gst_len_mpistate & GST_MPI_STATE_MASK));
+		pm8001_dbg(pm8001_ha, FAIL, " TIME OUT MPI State = 0x%x\n",
+			   gst_len_mpistate & GST_MPI_STATE_MASK);
 		return -1;
 	}
 	return 0;
@@ -763,25 +758,23 @@ static u32 soft_reset_ready_check(struct pm8001_hba_info *pm8001_ha)
 {
 	u32 regVal, regVal1, regVal2;
 	if (mpi_uninit_check(pm8001_ha) != 0) {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("MPI state is not ready\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "MPI state is not ready\n");
 		return -1;
 	}
 	/* read the scratch pad 2 register bit 2 */
 	regVal = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2)
 		& SCRATCH_PAD2_FWRDY_RST;
 	if (regVal == SCRATCH_PAD2_FWRDY_RST) {
-		PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("Firmware is ready for reset .\n"));
+		pm8001_dbg(pm8001_ha, INIT, "Firmware is ready for reset.\n");
 	} else {
 		unsigned long flags;
 		/* Trigger NMI twice via RB6 */
 		spin_lock_irqsave(&pm8001_ha->lock, flags);
 		if (-1 == pm8001_bar4_shift(pm8001_ha, RB6_ACCESS_REG)) {
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
-			PM8001_FAIL_DBG(pm8001_ha,
-				pm8001_printk("Shift Bar4 to 0x%x failed\n",
-					RB6_ACCESS_REG));
+			pm8001_dbg(pm8001_ha, FAIL,
+				   "Shift Bar4 to 0x%x failed\n",
+				   RB6_ACCESS_REG);
 			return -1;
 		}
 		pm8001_cw32(pm8001_ha, 2, SPC_RB6_OFFSET,
@@ -794,16 +787,14 @@ static u32 soft_reset_ready_check(struct pm8001_hba_info *pm8001_ha)
 		if (regVal != SCRATCH_PAD2_FWRDY_RST) {
 			regVal1 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
 			regVal2 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2);
-			PM8001_FAIL_DBG(pm8001_ha,
-				pm8001_printk("TIMEOUT:MSGU_SCRATCH_PAD1"
-				"=0x%x, MSGU_SCRATCH_PAD2=0x%x\n",
-				regVal1, regVal2));
-			PM8001_FAIL_DBG(pm8001_ha,
-				pm8001_printk("SCRATCH_PAD0 value = 0x%x\n",
-				pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_0)));
-			PM8001_FAIL_DBG(pm8001_ha,
-				pm8001_printk("SCRATCH_PAD3 value = 0x%x\n",
-				pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_3)));
+			pm8001_dbg(pm8001_ha, FAIL, "TIMEOUT:MSGU_SCRATCH_PAD1=0x%x, MSGU_SCRATCH_PAD2=0x%x\n",
+				   regVal1, regVal2);
+			pm8001_dbg(pm8001_ha, FAIL,
+				   "SCRATCH_PAD0 value = 0x%x\n",
+				   pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_0));
+			pm8001_dbg(pm8001_ha, FAIL,
+				   "SCRATCH_PAD3 value = 0x%x\n",
+				   pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_3));
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 			return -1;
 		}
@@ -828,7 +819,7 @@ pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 
 	/* step1: Check FW is ready for soft reset */
 	if (soft_reset_ready_check(pm8001_ha) != 0) {
-		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("FW is not ready\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "FW is not ready\n");
 		return -1;
 	}
 
@@ -838,46 +829,43 @@ pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 	spin_lock_irqsave(&pm8001_ha->lock, flags);
 	if (-1 == pm8001_bar4_shift(pm8001_ha, MBIC_AAP1_ADDR_BASE)) {
 		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("Shift Bar4 to 0x%x failed\n",
-			MBIC_AAP1_ADDR_BASE));
+		pm8001_dbg(pm8001_ha, FAIL, "Shift Bar4 to 0x%x failed\n",
+			   MBIC_AAP1_ADDR_BASE);
 		return -1;
 	}
 	regVal = pm8001_cr32(pm8001_ha, 2, MBIC_NMI_ENABLE_VPE0_IOP);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("MBIC - NMI Enable VPE0 (IOP)= 0x%x\n", regVal));
+	pm8001_dbg(pm8001_ha, INIT, "MBIC - NMI Enable VPE0 (IOP)= 0x%x\n",
+		   regVal);
 	pm8001_cw32(pm8001_ha, 2, MBIC_NMI_ENABLE_VPE0_IOP, 0x0);
 	/* map 0x70000 to BAR4(0x20), BAR2(win) */
 	if (-1 == pm8001_bar4_shift(pm8001_ha, MBIC_IOP_ADDR_BASE)) {
 		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("Shift Bar4 to 0x%x failed\n",
-			MBIC_IOP_ADDR_BASE));
+		pm8001_dbg(pm8001_ha, FAIL, "Shift Bar4 to 0x%x failed\n",
+			   MBIC_IOP_ADDR_BASE);
 		return -1;
 	}
 	regVal = pm8001_cr32(pm8001_ha, 2, MBIC_NMI_ENABLE_VPE0_AAP1);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("MBIC - NMI Enable VPE0 (AAP1)= 0x%x\n", regVal));
+	pm8001_dbg(pm8001_ha, INIT, "MBIC - NMI Enable VPE0 (AAP1)= 0x%x\n",
+		   regVal);
 	pm8001_cw32(pm8001_ha, 2, MBIC_NMI_ENABLE_VPE0_AAP1, 0x0);
 
 	regVal = pm8001_cr32(pm8001_ha, 1, PCIE_EVENT_INTERRUPT_ENABLE);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("PCIE -Event Interrupt Enable = 0x%x\n", regVal));
+	pm8001_dbg(pm8001_ha, INIT, "PCIE -Event Interrupt Enable = 0x%x\n",
+		   regVal);
 	pm8001_cw32(pm8001_ha, 1, PCIE_EVENT_INTERRUPT_ENABLE, 0x0);
 
 	regVal = pm8001_cr32(pm8001_ha, 1, PCIE_EVENT_INTERRUPT);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("PCIE - Event Interrupt  = 0x%x\n", regVal));
+	pm8001_dbg(pm8001_ha, INIT, "PCIE - Event Interrupt  = 0x%x\n",
+		   regVal);
 	pm8001_cw32(pm8001_ha, 1, PCIE_EVENT_INTERRUPT, regVal);
 
 	regVal = pm8001_cr32(pm8001_ha, 1, PCIE_ERROR_INTERRUPT_ENABLE);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("PCIE -Error Interrupt Enable = 0x%x\n", regVal));
+	pm8001_dbg(pm8001_ha, INIT, "PCIE -Error Interrupt Enable = 0x%x\n",
+		   regVal);
 	pm8001_cw32(pm8001_ha, 1, PCIE_ERROR_INTERRUPT_ENABLE, 0x0);
 
 	regVal = pm8001_cr32(pm8001_ha, 1, PCIE_ERROR_INTERRUPT);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("PCIE - Error Interrupt = 0x%x\n", regVal));
+	pm8001_dbg(pm8001_ha, INIT, "PCIE - Error Interrupt = 0x%x\n", regVal);
 	pm8001_cw32(pm8001_ha, 1, PCIE_ERROR_INTERRUPT, regVal);
 
 	/* read the scratch pad 1 register bit 2 */
@@ -893,15 +881,13 @@ pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 	/* map 0x0700000 to BAR4(0x20), BAR2(win) */
 	if (-1 == pm8001_bar4_shift(pm8001_ha, GSM_ADDR_BASE)) {
 		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("Shift Bar4 to 0x%x failed\n",
-			GSM_ADDR_BASE));
+		pm8001_dbg(pm8001_ha, FAIL, "Shift Bar4 to 0x%x failed\n",
+			   GSM_ADDR_BASE);
 		return -1;
 	}
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("GSM 0x0(0x00007b88)-GSM Configuration and"
-		" Reset = 0x%x\n",
-		pm8001_cr32(pm8001_ha, 2, GSM_CONFIG_RESET)));
+	pm8001_dbg(pm8001_ha, INIT,
+		   "GSM 0x0(0x00007b88)-GSM Configuration and Reset = 0x%x\n",
+		   pm8001_cr32(pm8001_ha, 2, GSM_CONFIG_RESET));
 
 	/* step 3: host read GSM Configuration and Reset register */
 	regVal = pm8001_cr32(pm8001_ha, 2, GSM_CONFIG_RESET);
@@ -916,59 +902,52 @@ pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 	regVal &= ~(0x00003b00);
 	/* host write GSM Configuration and Reset register */
 	pm8001_cw32(pm8001_ha, 2, GSM_CONFIG_RESET, regVal);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("GSM 0x0 (0x00007b88 ==> 0x00004088) - GSM "
-		"Configuration and Reset is set to = 0x%x\n",
-		pm8001_cr32(pm8001_ha, 2, GSM_CONFIG_RESET)));
+	pm8001_dbg(pm8001_ha, INIT,
+		   "GSM 0x0 (0x00007b88 ==> 0x00004088) - GSM Configuration and Reset is set to = 0x%x\n",
+		   pm8001_cr32(pm8001_ha, 2, GSM_CONFIG_RESET));
 
 	/* step 4: */
 	/* disable GSM - Read Address Parity Check */
 	regVal1 = pm8001_cr32(pm8001_ha, 2, GSM_READ_ADDR_PARITY_CHECK);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("GSM 0x700038 - Read Address Parity Check "
-		"Enable = 0x%x\n", regVal1));
+	pm8001_dbg(pm8001_ha, INIT,
+		   "GSM 0x700038 - Read Address Parity Check Enable = 0x%x\n",
+		   regVal1);
 	pm8001_cw32(pm8001_ha, 2, GSM_READ_ADDR_PARITY_CHECK, 0x0);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("GSM 0x700038 - Read Address Parity Check Enable"
-		"is set to = 0x%x\n",
-		pm8001_cr32(pm8001_ha, 2, GSM_READ_ADDR_PARITY_CHECK)));
+	pm8001_dbg(pm8001_ha, INIT,
+		   "GSM 0x700038 - Read Address Parity Check Enable is set to = 0x%x\n",
+		   pm8001_cr32(pm8001_ha, 2, GSM_READ_ADDR_PARITY_CHECK));
 
 	/* disable GSM - Write Address Parity Check */
 	regVal2 = pm8001_cr32(pm8001_ha, 2, GSM_WRITE_ADDR_PARITY_CHECK);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("GSM 0x700040 - Write Address Parity Check"
-		" Enable = 0x%x\n", regVal2));
+	pm8001_dbg(pm8001_ha, INIT,
+		   "GSM 0x700040 - Write Address Parity Check Enable = 0x%x\n",
+		   regVal2);
 	pm8001_cw32(pm8001_ha, 2, GSM_WRITE_ADDR_PARITY_CHECK, 0x0);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("GSM 0x700040 - Write Address Parity Check "
-		"Enable is set to = 0x%x\n",
-		pm8001_cr32(pm8001_ha, 2, GSM_WRITE_ADDR_PARITY_CHECK)));
+	pm8001_dbg(pm8001_ha, INIT,
+		   "GSM 0x700040 - Write Address Parity Check Enable is set to = 0x%x\n",
+		   pm8001_cr32(pm8001_ha, 2, GSM_WRITE_ADDR_PARITY_CHECK));
 
 	/* disable GSM - Write Data Parity Check */
 	regVal3 = pm8001_cr32(pm8001_ha, 2, GSM_WRITE_DATA_PARITY_CHECK);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("GSM 0x300048 - Write Data Parity Check"
-		" Enable = 0x%x\n", regVal3));
+	pm8001_dbg(pm8001_ha, INIT, "GSM 0x300048 - Write Data Parity Check Enable = 0x%x\n",
+		   regVal3);
 	pm8001_cw32(pm8001_ha, 2, GSM_WRITE_DATA_PARITY_CHECK, 0x0);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("GSM 0x300048 - Write Data Parity Check Enable"
-		"is set to = 0x%x\n",
-	pm8001_cr32(pm8001_ha, 2, GSM_WRITE_DATA_PARITY_CHECK)));
+	pm8001_dbg(pm8001_ha, INIT,
+		   "GSM 0x300048 - Write Data Parity Check Enable is set to = 0x%x\n",
+		   pm8001_cr32(pm8001_ha, 2, GSM_WRITE_DATA_PARITY_CHECK));
 
 	/* step 5: delay 10 usec */
 	udelay(10);
 	/* step 5-b: set GPIO-0 output control to tristate anyway */
 	if (-1 == pm8001_bar4_shift(pm8001_ha, GPIO_ADDR_BASE)) {
 		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
-		PM8001_INIT_DBG(pm8001_ha,
-				pm8001_printk("Shift Bar4 to 0x%x failed\n",
-				GPIO_ADDR_BASE));
+		pm8001_dbg(pm8001_ha, INIT, "Shift Bar4 to 0x%x failed\n",
+			   GPIO_ADDR_BASE);
 		return -1;
 	}
 	regVal = pm8001_cr32(pm8001_ha, 2, GPIO_GPIO_0_0UTPUT_CTL_OFFSET);
-	PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("GPIO Output Control Register:"
-			" = 0x%x\n", regVal));
+	pm8001_dbg(pm8001_ha, INIT, "GPIO Output Control Register: = 0x%x\n",
+		   regVal);
 	/* set GPIO-0 output control to tri-state */
 	regVal &= 0xFFFFFFFC;
 	pm8001_cw32(pm8001_ha, 2, GPIO_GPIO_0_0UTPUT_CTL_OFFSET, regVal);
@@ -977,23 +956,20 @@ pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 	/* map 0x00000 to BAR4(0x20), BAR2(win) */
 	if (-1 == pm8001_bar4_shift(pm8001_ha, SPC_TOP_LEVEL_ADDR_BASE)) {
 		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("SPC Shift Bar4 to 0x%x failed\n",
-			SPC_TOP_LEVEL_ADDR_BASE));
+		pm8001_dbg(pm8001_ha, FAIL, "SPC Shift Bar4 to 0x%x failed\n",
+			   SPC_TOP_LEVEL_ADDR_BASE);
 		return -1;
 	}
 	regVal = pm8001_cr32(pm8001_ha, 2, SPC_REG_RESET);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("Top Register before resetting IOP/AAP1"
-		":= 0x%x\n", regVal));
+	pm8001_dbg(pm8001_ha, INIT, "Top Register before resetting IOP/AAP1:= 0x%x\n",
+		   regVal);
 	regVal &= ~(SPC_REG_RESET_PCS_IOP_SS | SPC_REG_RESET_PCS_AAP1_SS);
 	pm8001_cw32(pm8001_ha, 2, SPC_REG_RESET, regVal);
 
 	/* step 7: Reset the BDMA/OSSP */
 	regVal = pm8001_cr32(pm8001_ha, 2, SPC_REG_RESET);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("Top Register before resetting BDMA/OSSP"
-		": = 0x%x\n", regVal));
+	pm8001_dbg(pm8001_ha, INIT, "Top Register before resetting BDMA/OSSP: = 0x%x\n",
+		   regVal);
 	regVal &= ~(SPC_REG_RESET_BDMA_CORE | SPC_REG_RESET_OSSP);
 	pm8001_cw32(pm8001_ha, 2, SPC_REG_RESET, regVal);
 
@@ -1002,9 +978,9 @@ pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 
 	/* step 9: bring the BDMA and OSSP out of reset */
 	regVal = pm8001_cr32(pm8001_ha, 2, SPC_REG_RESET);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("Top Register before bringing up BDMA/OSSP"
-		":= 0x%x\n", regVal));
+	pm8001_dbg(pm8001_ha, INIT,
+		   "Top Register before bringing up BDMA/OSSP:= 0x%x\n",
+		   regVal);
 	regVal |= (SPC_REG_RESET_BDMA_CORE | SPC_REG_RESET_OSSP);
 	pm8001_cw32(pm8001_ha, 2, SPC_REG_RESET, regVal);
 
@@ -1015,14 +991,13 @@ pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 	/* map 0x0700000 to BAR4(0x20), BAR2(win) */
 	if (-1 == pm8001_bar4_shift(pm8001_ha, GSM_ADDR_BASE)) {
 		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("SPC Shift Bar4 to 0x%x failed\n",
-			GSM_ADDR_BASE));
+		pm8001_dbg(pm8001_ha, FAIL, "SPC Shift Bar4 to 0x%x failed\n",
+			   GSM_ADDR_BASE);
 		return -1;
 	}
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("GSM 0x0 (0x00007b88)-GSM Configuration and "
-		"Reset = 0x%x\n", pm8001_cr32(pm8001_ha, 2, GSM_CONFIG_RESET)));
+	pm8001_dbg(pm8001_ha, INIT,
+		   "GSM 0x0 (0x00007b88)-GSM Configuration and Reset = 0x%x\n",
+		   pm8001_cr32(pm8001_ha, 2, GSM_CONFIG_RESET));
 	regVal = pm8001_cr32(pm8001_ha, 2, GSM_CONFIG_RESET);
 	/* Put those bits to high */
 	/* GSM XCBI offset = 0x70 0000
@@ -1034,44 +1009,37 @@ pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 	*/
 	regVal |= (GSM_CONFIG_RESET_VALUE);
 	pm8001_cw32(pm8001_ha, 2, GSM_CONFIG_RESET, regVal);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("GSM (0x00004088 ==> 0x00007b88) - GSM"
-		" Configuration and Reset is set to = 0x%x\n",
-		pm8001_cr32(pm8001_ha, 2, GSM_CONFIG_RESET)));
+	pm8001_dbg(pm8001_ha, INIT, "GSM (0x00004088 ==> 0x00007b88) - GSM Configuration and Reset is set to = 0x%x\n",
+		   pm8001_cr32(pm8001_ha, 2, GSM_CONFIG_RESET));
 
 	/* step 12: Restore GSM - Read Address Parity Check */
 	regVal = pm8001_cr32(pm8001_ha, 2, GSM_READ_ADDR_PARITY_CHECK);
 	/* just for debugging */
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("GSM 0x700038 - Read Address Parity Check Enable"
-		" = 0x%x\n", regVal));
+	pm8001_dbg(pm8001_ha, INIT,
+		   "GSM 0x700038 - Read Address Parity Check Enable = 0x%x\n",
+		   regVal);
 	pm8001_cw32(pm8001_ha, 2, GSM_READ_ADDR_PARITY_CHECK, regVal1);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("GSM 0x700038 - Read Address Parity"
-		" Check Enable is set to = 0x%x\n",
-		pm8001_cr32(pm8001_ha, 2, GSM_READ_ADDR_PARITY_CHECK)));
+	pm8001_dbg(pm8001_ha, INIT, "GSM 0x700038 - Read Address Parity Check Enable is set to = 0x%x\n",
+		   pm8001_cr32(pm8001_ha, 2, GSM_READ_ADDR_PARITY_CHECK));
 	/* Restore GSM - Write Address Parity Check */
 	regVal = pm8001_cr32(pm8001_ha, 2, GSM_WRITE_ADDR_PARITY_CHECK);
 	pm8001_cw32(pm8001_ha, 2, GSM_WRITE_ADDR_PARITY_CHECK, regVal2);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("GSM 0x700040 - Write Address Parity Check"
-		" Enable is set to = 0x%x\n",
-		pm8001_cr32(pm8001_ha, 2, GSM_WRITE_ADDR_PARITY_CHECK)));
+	pm8001_dbg(pm8001_ha, INIT,
+		   "GSM 0x700040 - Write Address Parity Check Enable is set to = 0x%x\n",
+		   pm8001_cr32(pm8001_ha, 2, GSM_WRITE_ADDR_PARITY_CHECK));
 	/* Restore GSM - Write Data Parity Check */
 	regVal = pm8001_cr32(pm8001_ha, 2, GSM_WRITE_DATA_PARITY_CHECK);
 	pm8001_cw32(pm8001_ha, 2, GSM_WRITE_DATA_PARITY_CHECK, regVal3);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("GSM 0x700048 - Write Data Parity Check Enable"
-		"is set to = 0x%x\n",
-		pm8001_cr32(pm8001_ha, 2, GSM_WRITE_DATA_PARITY_CHECK)));
+	pm8001_dbg(pm8001_ha, INIT,
+		   "GSM 0x700048 - Write Data Parity Check Enableis set to = 0x%x\n",
+		   pm8001_cr32(pm8001_ha, 2, GSM_WRITE_DATA_PARITY_CHECK));
 
 	/* step 13: bring the IOP and AAP1 out of reset */
 	/* map 0x00000 to BAR4(0x20), BAR2(win) */
 	if (-1 == pm8001_bar4_shift(pm8001_ha, SPC_TOP_LEVEL_ADDR_BASE)) {
 		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("Shift Bar4 to 0x%x failed\n",
-			SPC_TOP_LEVEL_ADDR_BASE));
+		pm8001_dbg(pm8001_ha, FAIL, "Shift Bar4 to 0x%x failed\n",
+			   SPC_TOP_LEVEL_ADDR_BASE);
 		return -1;
 	}
 	regVal = pm8001_cr32(pm8001_ha, 2, SPC_REG_RESET);
@@ -1094,22 +1062,20 @@ pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 		if (!max_wait_count) {
 			regVal = pm8001_cr32(pm8001_ha, 0,
 				MSGU_SCRATCH_PAD_1);
-			PM8001_FAIL_DBG(pm8001_ha,
-				pm8001_printk("TIMEOUT : ToggleVal 0x%x,"
-				"MSGU_SCRATCH_PAD1 = 0x%x\n",
-				toggleVal, regVal));
-			PM8001_FAIL_DBG(pm8001_ha,
-				pm8001_printk("SCRATCH_PAD0 value = 0x%x\n",
-				pm8001_cr32(pm8001_ha, 0,
-				MSGU_SCRATCH_PAD_0)));
-			PM8001_FAIL_DBG(pm8001_ha,
-				pm8001_printk("SCRATCH_PAD2 value = 0x%x\n",
-				pm8001_cr32(pm8001_ha, 0,
-				MSGU_SCRATCH_PAD_2)));
-			PM8001_FAIL_DBG(pm8001_ha,
-				pm8001_printk("SCRATCH_PAD3 value = 0x%x\n",
-				pm8001_cr32(pm8001_ha, 0,
-				MSGU_SCRATCH_PAD_3)));
+			pm8001_dbg(pm8001_ha, FAIL, "TIMEOUT : ToggleVal 0x%x,MSGU_SCRATCH_PAD1 = 0x%x\n",
+				   toggleVal, regVal);
+			pm8001_dbg(pm8001_ha, FAIL,
+				   "SCRATCH_PAD0 value = 0x%x\n",
+				   pm8001_cr32(pm8001_ha, 0,
+					       MSGU_SCRATCH_PAD_0));
+			pm8001_dbg(pm8001_ha, FAIL,
+				   "SCRATCH_PAD2 value = 0x%x\n",
+				   pm8001_cr32(pm8001_ha, 0,
+					       MSGU_SCRATCH_PAD_2));
+			pm8001_dbg(pm8001_ha, FAIL,
+				   "SCRATCH_PAD3 value = 0x%x\n",
+				   pm8001_cr32(pm8001_ha, 0,
+					       MSGU_SCRATCH_PAD_3));
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 			return -1;
 		}
@@ -1124,22 +1090,22 @@ pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 		if (check_fw_ready(pm8001_ha) == -1) {
 			regVal = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
 			/* return error if MPI Configuration Table not ready */
-			PM8001_INIT_DBG(pm8001_ha,
-				pm8001_printk("FW not ready SCRATCH_PAD1"
-				" = 0x%x\n", regVal));
+			pm8001_dbg(pm8001_ha, INIT,
+				   "FW not ready SCRATCH_PAD1 = 0x%x\n",
+				   regVal);
 			regVal = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2);
 			/* return error if MPI Configuration Table not ready */
-			PM8001_INIT_DBG(pm8001_ha,
-				pm8001_printk("FW not ready SCRATCH_PAD2"
-				" = 0x%x\n", regVal));
-			PM8001_INIT_DBG(pm8001_ha,
-				pm8001_printk("SCRATCH_PAD0 value = 0x%x\n",
-				pm8001_cr32(pm8001_ha, 0,
-				MSGU_SCRATCH_PAD_0)));
-			PM8001_INIT_DBG(pm8001_ha,
-				pm8001_printk("SCRATCH_PAD3 value = 0x%x\n",
-				pm8001_cr32(pm8001_ha, 0,
-				MSGU_SCRATCH_PAD_3)));
+			pm8001_dbg(pm8001_ha, INIT,
+				   "FW not ready SCRATCH_PAD2 = 0x%x\n",
+				   regVal);
+			pm8001_dbg(pm8001_ha, INIT,
+				   "SCRATCH_PAD0 value = 0x%x\n",
+				   pm8001_cr32(pm8001_ha, 0,
+					       MSGU_SCRATCH_PAD_0));
+			pm8001_dbg(pm8001_ha, INIT,
+				   "SCRATCH_PAD3 value = 0x%x\n",
+				   pm8001_cr32(pm8001_ha, 0,
+					       MSGU_SCRATCH_PAD_3));
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 			return -1;
 		}
@@ -1147,8 +1113,7 @@ pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 	pm8001_bar4_shift(pm8001_ha, 0);
 	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("SPC soft reset Complete\n"));
+	pm8001_dbg(pm8001_ha, INIT, "SPC soft reset Complete\n");
 	return 0;
 }
 
@@ -1156,8 +1121,7 @@ static void pm8001_hw_chip_rst(struct pm8001_hba_info *pm8001_ha)
 {
 	u32 i;
 	u32 regVal;
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("chip reset start\n"));
+	pm8001_dbg(pm8001_ha, INIT, "chip reset start\n");
 
 	/* do SPC chip reset. */
 	regVal = pm8001_cr32(pm8001_ha, 1, SPC_REG_RESET);
@@ -1181,8 +1145,7 @@ static void pm8001_hw_chip_rst(struct pm8001_hba_info *pm8001_ha)
 		mdelay(1);
 	} while ((--i) != 0);
 
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("chip reset finished\n"));
+	pm8001_dbg(pm8001_ha, INIT, "chip reset finished\n");
 }
 
 /**
@@ -1365,8 +1328,7 @@ int pm8001_mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
 	rv = pm8001_mpi_msg_free_get(circularQ, pm8001_ha->iomb_size,
 			&pMessage);
 	if (rv < 0) {
-		PM8001_IO_DBG(pm8001_ha,
-			      pm8001_printk("No free mpi buffer\n"));
+		pm8001_dbg(pm8001_ha, IO, "No free mpi buffer\n");
 		rv = -ENOMEM;
 		goto done;
 	}
@@ -1387,10 +1349,10 @@ int pm8001_mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
 	/*Update the PI to the firmware*/
 	pm8001_cw32(pm8001_ha, circularQ->pi_pci_bar,
 		circularQ->pi_offset, circularQ->producer_idx);
-	PM8001_DEVIO_DBG(pm8001_ha,
-		pm8001_printk("INB Q %x OPCODE:%x , UPDATED PI=%d CI=%d\n",
-			responseQueue, opCode, circularQ->producer_idx,
-			circularQ->consumer_index));
+	pm8001_dbg(pm8001_ha, DEVIO,
+		   "INB Q %x OPCODE:%x , UPDATED PI=%d CI=%d\n",
+		   responseQueue, opCode, circularQ->producer_idx,
+		   circularQ->consumer_index);
 done:
 	spin_unlock_irqrestore(&circularQ->iq_lock, flags);
 	return rv;
@@ -1407,17 +1369,17 @@ u32 pm8001_mpi_msg_free_set(struct pm8001_hba_info *pm8001_ha, void *pMsg,
 	pOutBoundMsgHeader = (struct mpi_msg_hdr *)(circularQ->base_virt +
 				circularQ->consumer_idx * pm8001_ha->iomb_size);
 	if (pOutBoundMsgHeader != msgHeader) {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("consumer_idx = %d msgHeader = %p\n",
-			circularQ->consumer_idx, msgHeader));
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "consumer_idx = %d msgHeader = %p\n",
+			   circularQ->consumer_idx, msgHeader);
 
 		/* Update the producer index from SPC */
 		producer_index = pm8001_read_32(circularQ->pi_virt);
 		circularQ->producer_index = cpu_to_le32(producer_index);
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("consumer_idx = %d producer_index = %d"
-			"msgHeader = %p\n", circularQ->consumer_idx,
-			circularQ->producer_index, msgHeader));
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "consumer_idx = %d producer_index = %dmsgHeader = %p\n",
+			   circularQ->consumer_idx,
+			   circularQ->producer_index, msgHeader);
 		return 0;
 	}
 	/* free the circular queue buffer elements associated with the message*/
@@ -1429,9 +1391,8 @@ u32 pm8001_mpi_msg_free_set(struct pm8001_hba_info *pm8001_ha, void *pMsg,
 	/* Update the producer index from SPC*/
 	producer_index = pm8001_read_32(circularQ->pi_virt);
 	circularQ->producer_index = cpu_to_le32(producer_index);
-	PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk(" CI=%d PI=%d\n", circularQ->consumer_idx,
-		circularQ->producer_index));
+	pm8001_dbg(pm8001_ha, IO, " CI=%d PI=%d\n",
+		   circularQ->consumer_idx, circularQ->producer_index);
 	return 0;
 }
 
@@ -1461,10 +1422,10 @@ u32 pm8001_mpi_msg_consume(struct pm8001_hba_info *pm8001_ha,
 			/* read header */
 			header_tmp = pm8001_read_32(msgHeader);
 			msgHeader_tmp = cpu_to_le32(header_tmp);
-			PM8001_DEVIO_DBG(pm8001_ha, pm8001_printk(
-				"outbound opcode msgheader:%x ci=%d pi=%d\n",
-				msgHeader_tmp, circularQ->consumer_idx,
-				circularQ->producer_index));
+			pm8001_dbg(pm8001_ha, DEVIO,
+				   "outbound opcode msgheader:%x ci=%d pi=%d\n",
+				   msgHeader_tmp, circularQ->consumer_idx,
+				   circularQ->producer_index);
 			if (0 != (le32_to_cpu(msgHeader_tmp) & 0x80000000)) {
 				if (OPC_OUB_SKIP_ENTRY !=
 					(le32_to_cpu(msgHeader_tmp) & 0xfff)) {
@@ -1473,12 +1434,11 @@ u32 pm8001_mpi_msg_consume(struct pm8001_hba_info *pm8001_ha,
 						sizeof(struct mpi_msg_hdr);
 					*pBC = (u8)((le32_to_cpu(msgHeader_tmp)
 						>> 24) & 0x1f);
-					PM8001_IO_DBG(pm8001_ha,
-						pm8001_printk(": CI=%d PI=%d "
-						"msgHeader=%x\n",
-						circularQ->consumer_idx,
-						circularQ->producer_index,
-						msgHeader_tmp));
+					pm8001_dbg(pm8001_ha, IO,
+						   ": CI=%d PI=%d msgHeader=%x\n",
+						   circularQ->consumer_idx,
+						   circularQ->producer_index,
+						   msgHeader_tmp);
 					return MPI_IO_STATUS_SUCCESS;
 				} else {
 					circularQ->consumer_idx =
@@ -1594,10 +1554,8 @@ void pm8001_work_fn(struct work_struct *work)
 		t->task_state_flags |= SAS_TASK_STATE_DONE;
 		if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
 			spin_unlock_irqrestore(&t->task_state_lock, flags1);
-			PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("task 0x%p"
-				" done with event 0x%x resp 0x%x stat 0x%x but"
-				" aborted by upper layer!\n",
-				t, pw->handler, ts->resp, ts->stat));
+			pm8001_dbg(pm8001_ha, FAIL, "task 0x%p done with event 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
+				   t, pw->handler, ts->resp, ts->stat);
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 		} else {
@@ -1617,26 +1575,16 @@ void pm8001_work_fn(struct work_struct *work)
 		unsigned long flags, flags1;
 		int i, ret = 0;
 
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_OPEN_RETRY_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_OPEN_RETRY_TIMEOUT\n");
 
 		ret = pm8001_query_task(t);
 
-		PM8001_IO_DBG(pm8001_ha,
-			switch (ret) {
-			case TMF_RESP_FUNC_SUCC:
-				pm8001_printk("...Task on lu\n");
-				break;
-
-			case TMF_RESP_FUNC_COMPLETE:
-				pm8001_printk("...Task NOT on lu\n");
-				break;
-
-			default:
-				PM8001_DEVIO_DBG(pm8001_ha, pm8001_printk(
-					"...query task failed!!!\n"));
-				break;
-			});
+		if (ret == TMF_RESP_FUNC_SUCC)
+			pm8001_dbg(pm8001_ha, IO, "...Task on lu\n");
+		else if (ret == TMF_RESP_FUNC_COMPLETE)
+			pm8001_dbg(pm8001_ha, IO, "...Task NOT on lu\n");
+		else
+			pm8001_dbg(pm8001_ha, DEVIO, "...query task failed!!!\n");
 
 		spin_lock_irqsave(&pm8001_ha->lock, flags);
 
@@ -1681,8 +1629,7 @@ void pm8001_work_fn(struct work_struct *work)
 				break;
 			default: /* device misbehavior */
 				ret = TMF_RESP_FUNC_FAILED;
-				PM8001_IO_DBG(pm8001_ha,
-					pm8001_printk("...Reset phy\n"));
+				pm8001_dbg(pm8001_ha, IO, "...Reset phy\n");
 				pm8001_I_T_nexus_reset(dev);
 				break;
 			}
@@ -1696,15 +1643,14 @@ void pm8001_work_fn(struct work_struct *work)
 		default: /* device misbehavior */
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 			ret = TMF_RESP_FUNC_FAILED;
-			PM8001_IO_DBG(pm8001_ha,
-				pm8001_printk("...Reset phy\n"));
+			pm8001_dbg(pm8001_ha, IO, "...Reset phy\n");
 			pm8001_I_T_nexus_reset(dev);
 		}
 
 		if (ret == TMF_RESP_FUNC_FAILED)
 			t = NULL;
 		pm8001_open_reject_retry(pm8001_ha, t, pm8001_dev);
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk("...Complete\n"));
+		pm8001_dbg(pm8001_ha, IO, "...Complete\n");
 	}	break;
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS:
 		dev = pm8001_dev->sas_device;
@@ -1758,15 +1704,14 @@ static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 	int ret;
 
 	if (!pm8001_ha_dev) {
-		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("dev is null\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "dev is null\n");
 		return;
 	}
 
 	task = sas_alloc_slow_task(GFP_ATOMIC);
 
 	if (!task) {
-		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("cannot "
-						"allocate task\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate task\n");
 		return;
 	}
 
@@ -1811,8 +1756,7 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	task = sas_alloc_slow_task(GFP_ATOMIC);
 
 	if (!task) {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("cannot allocate task !!!\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate task !!!\n");
 		return;
 	}
 	task->task_done = pm8001_task_done;
@@ -1820,8 +1764,7 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
 	if (res) {
 		sas_free_task(task);
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("cannot allocate tag !!!\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate tag !!!\n");
 		return;
 	}
 
@@ -1832,8 +1775,8 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	if (!dev) {
 		sas_free_task(task);
 		pm8001_tag_free(pm8001_ha, ccb_tag);
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("Domain device cannot be allocated\n"));
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "Domain device cannot be allocated\n");
 		return;
 	}
 	task->dev = dev;
@@ -1910,27 +1853,25 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 	t = ccb->task;
 
 	if (status && status != IO_UNDERFLOW)
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("sas IO status 0x%x\n", status));
+		pm8001_dbg(pm8001_ha, FAIL, "sas IO status 0x%x\n", status);
 	if (unlikely(!t || !t->lldd_task || !t->dev))
 		return;
 	ts = &t->task_status;
 	/* Print sas address of IO failed device */
 	if ((status != IO_SUCCESS) && (status != IO_OVERFLOW) &&
 		(status != IO_UNDERFLOW))
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("SAS Address of IO Failure Drive:"
-			"%016llx", SAS_ADDR(t->dev->sas_addr)));
+		pm8001_dbg(pm8001_ha, FAIL, "SAS Address of IO Failure Drive:%016llx\n",
+			   SAS_ADDR(t->dev->sas_addr));
 
 	if (status)
-		PM8001_IOERR_DBG(pm8001_ha, pm8001_printk(
-			"status:0x%x, tag:0x%x, task:0x%p\n",
-			status, tag, t));
+		pm8001_dbg(pm8001_ha, IOERR,
+			   "status:0x%x, tag:0x%x, task:0x%p\n",
+			   status, tag, t);
 
 	switch (status) {
 	case IO_SUCCESS:
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS"
-			",param = %d\n", param));
+		pm8001_dbg(pm8001_ha, IO, "IO_SUCCESS,param = %d\n",
+			   param);
 		if (param == 0) {
 			ts->resp = SAS_TASK_COMPLETE;
 			ts->stat = SAM_STAT_GOOD;
@@ -1945,15 +1886,14 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_ABORTED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_ABORTED IOMB Tag\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_ABORTED IOMB Tag\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_ABORTED_TASK;
 		break;
 	case IO_UNDERFLOW:
 		/* SSP Completion with error */
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_UNDERFLOW"
-			",param = %d\n", param));
+		pm8001_dbg(pm8001_ha, IO, "IO_UNDERFLOW,param = %d\n",
+			   param);
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_UNDERRUN;
 		ts->residual = param;
@@ -1961,50 +1901,45 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_NO_DEVICE:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_NO_DEVICE\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_NO_DEVICE\n");
 		ts->resp = SAS_TASK_UNDELIVERED;
 		ts->stat = SAS_PHY_DOWN;
 		break;
 	case IO_XFER_ERROR_BREAK:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_BREAK\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_BREAK\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		/* Force the midlayer to retry */
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
 		break;
 	case IO_XFER_ERROR_PHY_NOT_READY:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_PHY_NOT_READY\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_PHY_NOT_READY\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
 		break;
 	case IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED:
-		PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk("IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_EPROTO;
 		break;
 	case IO_OPEN_CNX_ERROR_ZONE_VIOLATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_ZONE_VIOLATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_ZONE_VIOLATION\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_UNKNOWN;
 		break;
 	case IO_OPEN_CNX_ERROR_BREAK:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_BREAK\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_BREAK\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
 		break;
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_UNKNOWN;
@@ -2014,68 +1949,59 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 		break;
 	case IO_OPEN_CNX_ERROR_BAD_DESTINATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_BAD_DESTINATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_BAD_DESTINATION\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_BAD_DEST;
 		break;
 	case IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_CONNECTION_RATE_"
-			"NOT_SUPPORTED\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_CONN_RATE;
 		break;
 	case IO_OPEN_CNX_ERROR_WRONG_DESTINATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_WRONG_DESTINATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_WRONG_DESTINATION\n");
 		ts->resp = SAS_TASK_UNDELIVERED;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_WRONG_DEST;
 		break;
 	case IO_XFER_ERROR_NAK_RECEIVED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_NAK_RECEIVED\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_NAK_RECEIVED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
 		break;
 	case IO_XFER_ERROR_ACK_NAK_TIMEOUT:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_ACK_NAK_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_ACK_NAK_TIMEOUT\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_NAK_R_ERR;
 		break;
 	case IO_XFER_ERROR_DMA:
-		PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk("IO_XFER_ERROR_DMA\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_DMA\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		break;
 	case IO_XFER_OPEN_RETRY_TIMEOUT:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_OPEN_RETRY_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_OPEN_RETRY_TIMEOUT\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
 		break;
 	case IO_XFER_ERROR_OFFSET_MISMATCH:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_OFFSET_MISMATCH\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_OFFSET_MISMATCH\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		break;
 	case IO_PORT_IN_RESET:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_PORT_IN_RESET\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_PORT_IN_RESET\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		break;
 	case IO_DS_NON_OPERATIONAL:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_DS_NON_OPERATIONAL\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_DS_NON_OPERATIONAL\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		if (!t->uldd_task)
@@ -2084,51 +2010,44 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 				IO_DS_NON_OPERATIONAL);
 		break;
 	case IO_DS_IN_RECOVERY:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_DS_IN_RECOVERY\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_DS_IN_RECOVERY\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		break;
 	case IO_TM_TAG_NOT_FOUND:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_TM_TAG_NOT_FOUND\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_TM_TAG_NOT_FOUND\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		break;
 	case IO_SSP_EXT_IU_ZERO_LEN_ERROR:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_SSP_EXT_IU_ZERO_LEN_ERROR\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_SSP_EXT_IU_ZERO_LEN_ERROR\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		break;
 	case IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
 		break;
 	default:
-		PM8001_DEVIO_DBG(pm8001_ha,
-			pm8001_printk("Unknown status 0x%x\n", status));
+		pm8001_dbg(pm8001_ha, DEVIO, "Unknown status 0x%x\n", status);
 		/* not allowed case. Therefore, return failed status */
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		break;
 	}
-	PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk("scsi_status = %x\n ",
-		psspPayload->ssp_resp_iu.status));
+	pm8001_dbg(pm8001_ha, IO, "scsi_status = %x\n",
+		   psspPayload->ssp_resp_iu.status);
 	spin_lock_irqsave(&t->task_state_lock, flags);
 	t->task_state_flags &= ~SAS_TASK_STATE_PENDING;
 	t->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
 	t->task_state_flags |= SAS_TASK_STATE_DONE;
 	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("task 0x%p done with"
-			" io_status 0x%x resp 0x%x "
-			"stat 0x%x but aborted by upper layer!\n",
-			t, status, ts->resp, ts->stat));
+		pm8001_dbg(pm8001_ha, FAIL, "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
+			   t, status, ts->resp, ts->stat);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
@@ -2157,17 +2076,15 @@ static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 	t = ccb->task;
 	pm8001_dev = ccb->device;
 	if (event)
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("sas IO status 0x%x\n", event));
+		pm8001_dbg(pm8001_ha, FAIL, "sas IO status 0x%x\n", event);
 	if (unlikely(!t || !t->lldd_task || !t->dev))
 		return;
 	ts = &t->task_status;
-	PM8001_DEVIO_DBG(pm8001_ha,
-		pm8001_printk("port_id = %x,device_id = %x\n",
-		port_id, dev_id));
+	pm8001_dbg(pm8001_ha, DEVIO, "port_id = %x,device_id = %x\n",
+		   port_id, dev_id);
 	switch (event) {
 	case IO_OVERFLOW:
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_UNDERFLOW\n");)
+		pm8001_dbg(pm8001_ha, IO, "IO_UNDERFLOW\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
 		ts->residual = 0;
@@ -2175,42 +2092,36 @@ static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_BREAK:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_BREAK\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_BREAK\n");
 		pm8001_handle_event(pm8001_ha, t, IO_XFER_ERROR_BREAK);
 		return;
 	case IO_XFER_ERROR_PHY_NOT_READY:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_PHY_NOT_READY\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_PHY_NOT_READY\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
 		break;
 	case IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_PROTOCOL_NOT"
-			"_SUPPORTED\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_EPROTO;
 		break;
 	case IO_OPEN_CNX_ERROR_ZONE_VIOLATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_ZONE_VIOLATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_ZONE_VIOLATION\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_UNKNOWN;
 		break;
 	case IO_OPEN_CNX_ERROR_BREAK:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_BREAK\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_BREAK\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
 		break;
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_UNKNOWN;
@@ -2220,88 +2131,78 @@ static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 		break;
 	case IO_OPEN_CNX_ERROR_BAD_DESTINATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_BAD_DESTINATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_BAD_DESTINATION\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_BAD_DEST;
 		break;
 	case IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_CONNECTION_RATE_"
-			"NOT_SUPPORTED\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_CONN_RATE;
 		break;
 	case IO_OPEN_CNX_ERROR_WRONG_DESTINATION:
-		PM8001_IO_DBG(pm8001_ha,
-		       pm8001_printk("IO_OPEN_CNX_ERROR_WRONG_DESTINATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_WRONG_DESTINATION\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_WRONG_DEST;
 		break;
 	case IO_XFER_ERROR_NAK_RECEIVED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_NAK_RECEIVED\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_NAK_RECEIVED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
 		break;
 	case IO_XFER_ERROR_ACK_NAK_TIMEOUT:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_ACK_NAK_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_ACK_NAK_TIMEOUT\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_NAK_R_ERR;
 		break;
 	case IO_XFER_OPEN_RETRY_TIMEOUT:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_OPEN_RETRY_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_OPEN_RETRY_TIMEOUT\n");
 		pm8001_handle_event(pm8001_ha, t, IO_XFER_OPEN_RETRY_TIMEOUT);
 		return;
 	case IO_XFER_ERROR_UNEXPECTED_PHASE:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_UNEXPECTED_PHASE\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_UNEXPECTED_PHASE\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
 		break;
 	case IO_XFER_ERROR_XFER_RDY_OVERRUN:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_XFER_RDY_OVERRUN\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_XFER_RDY_OVERRUN\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
 		break;
 	case IO_XFER_ERROR_XFER_RDY_NOT_EXPECTED:
-		PM8001_IO_DBG(pm8001_ha,
-		       pm8001_printk("IO_XFER_ERROR_XFER_RDY_NOT_EXPECTED\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_XFER_ERROR_XFER_RDY_NOT_EXPECTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
 		break;
 	case IO_XFER_ERROR_CMD_ISSUE_ACK_NAK_TIMEOUT:
-		PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk("IO_XFER_ERROR_CMD_ISSUE_ACK_NAK_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_XFER_ERROR_CMD_ISSUE_ACK_NAK_TIMEOUT\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
 		break;
 	case IO_XFER_ERROR_OFFSET_MISMATCH:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_OFFSET_MISMATCH\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_OFFSET_MISMATCH\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
 		break;
 	case IO_XFER_ERROR_XFER_ZERO_DATA_LEN:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_XFER_ZERO_DATA_LEN\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_XFER_ERROR_XFER_ZERO_DATA_LEN\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
 		break;
 	case IO_XFER_CMD_FRAME_ISSUED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("  IO_XFER_CMD_FRAME_ISSUED\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_CMD_FRAME_ISSUED\n");
 		return;
 	default:
-		PM8001_DEVIO_DBG(pm8001_ha,
-			pm8001_printk("Unknown status 0x%x\n", event));
+		pm8001_dbg(pm8001_ha, DEVIO, "Unknown status 0x%x\n", event);
 		/* not allowed case. Therefore, return failed status */
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
@@ -2313,10 +2214,8 @@ static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 	t->task_state_flags |= SAS_TASK_STATE_DONE;
 	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("task 0x%p done with"
-			" event 0x%x resp 0x%x "
-			"stat 0x%x but aborted by upper layer!\n",
-			t, event, ts->resp, ts->stat));
+		pm8001_dbg(pm8001_ha, FAIL, "task 0x%p done with event 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
+			   t, event, ts->resp, ts->stat);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
@@ -2352,8 +2251,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	tag = le32_to_cpu(psataPayload->tag);
 
 	if (!tag) {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("tag null\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "tag null\n");
 		return;
 	}
 	ccb = &pm8001_ha->ccb_info[tag];
@@ -2362,8 +2260,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		t = ccb->task;
 		pm8001_dev = ccb->device;
 	} else {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("ccb null\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "ccb null\n");
 		return;
 	}
 
@@ -2371,29 +2268,26 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		if (t->dev && (t->dev->lldd_dev))
 			pm8001_dev = t->dev->lldd_dev;
 	} else {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("task null\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "task null\n");
 		return;
 	}
 
 	if ((pm8001_dev && !(pm8001_dev->id & NCQ_READ_LOG_FLAG))
 		&& unlikely(!t || !t->lldd_task || !t->dev)) {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("task or dev null\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "task or dev null\n");
 		return;
 	}
 
 	ts = &t->task_status;
 	if (!ts) {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("ts null\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "ts null\n");
 		return;
 	}
 
 	if (status)
-		PM8001_IOERR_DBG(pm8001_ha, pm8001_printk(
-			"status:0x%x, tag:0x%x, task::0x%p\n",
-			status, tag, t));
+		pm8001_dbg(pm8001_ha, IOERR,
+			   "status:0x%x, tag:0x%x, task::0x%p\n",
+			   status, tag, t);
 
 	/* Print sas address of IO failed device */
 	if ((status != IO_SUCCESS) && (status != IO_OVERFLOW) &&
@@ -2425,19 +2319,19 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 						& 0xff000000)) +
 						pm8001_dev->attached_phy +
 						0x10);
-			PM8001_FAIL_DBG(pm8001_ha,
-				pm8001_printk("SAS Address of IO Failure Drive:"
-				"%08x%08x", temp_sata_addr_hi,
-					temp_sata_addr_low));
+			pm8001_dbg(pm8001_ha, FAIL,
+				   "SAS Address of IO Failure Drive:%08x%08x\n",
+				   temp_sata_addr_hi,
+				   temp_sata_addr_low);
 		} else {
-			PM8001_FAIL_DBG(pm8001_ha,
-				pm8001_printk("SAS Address of IO Failure Drive:"
-				"%016llx", SAS_ADDR(t->dev->sas_addr)));
+			pm8001_dbg(pm8001_ha, FAIL,
+				   "SAS Address of IO Failure Drive:%016llx\n",
+				   SAS_ADDR(t->dev->sas_addr));
 		}
 	}
 	switch (status) {
 	case IO_SUCCESS:
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_SUCCESS\n");
 		if (param == 0) {
 			ts->resp = SAS_TASK_COMPLETE;
 			ts->stat = SAM_STAT_GOOD;
@@ -2459,39 +2353,38 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			ts->resp = SAS_TASK_COMPLETE;
 			ts->stat = SAS_PROTO_RESPONSE;
 			ts->residual = param;
-			PM8001_IO_DBG(pm8001_ha,
-				pm8001_printk("SAS_PROTO_RESPONSE len = %d\n",
-				param));
+			pm8001_dbg(pm8001_ha, IO,
+				   "SAS_PROTO_RESPONSE len = %d\n",
+				   param);
 			sata_resp = &psataPayload->sata_resp[0];
 			resp = (struct ata_task_resp *)ts->buf;
 			if (t->ata_task.dma_xfer == 0 &&
 			    t->data_dir == DMA_FROM_DEVICE) {
 				len = sizeof(struct pio_setup_fis);
-				PM8001_IO_DBG(pm8001_ha,
-				pm8001_printk("PIO read len = %d\n", len));
+				pm8001_dbg(pm8001_ha, IO,
+					   "PIO read len = %d\n", len);
 			} else if (t->ata_task.use_ncq) {
 				len = sizeof(struct set_dev_bits_fis);
-				PM8001_IO_DBG(pm8001_ha,
-					pm8001_printk("FPDMA len = %d\n", len));
+				pm8001_dbg(pm8001_ha, IO, "FPDMA len = %d\n",
+					   len);
 			} else {
 				len = sizeof(struct dev_to_host_fis);
-				PM8001_IO_DBG(pm8001_ha,
-				pm8001_printk("other len = %d\n", len));
+				pm8001_dbg(pm8001_ha, IO, "other len = %d\n",
+					   len);
 			}
 			if (SAS_STATUS_BUF_SIZE >= sizeof(*resp)) {
 				resp->frame_len = len;
 				memcpy(&resp->ending_fis[0], sata_resp, len);
 				ts->buf_valid_size = sizeof(*resp);
 			} else
-				PM8001_IO_DBG(pm8001_ha,
-					pm8001_printk("response to large\n"));
+				pm8001_dbg(pm8001_ha, IO,
+					   "response too large\n");
 		}
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_ABORTED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_ABORTED IOMB Tag\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_ABORTED IOMB Tag\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_ABORTED_TASK;
 		if (pm8001_dev)
@@ -2500,8 +2393,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		/* following cases are to do cases */
 	case IO_UNDERFLOW:
 		/* SATA Completion with error */
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_UNDERFLOW param = %d\n", param));
+		pm8001_dbg(pm8001_ha, IO, "IO_UNDERFLOW param = %d\n", param);
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_UNDERRUN;
 		ts->residual =  param;
@@ -2509,24 +2401,21 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_NO_DEVICE:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_NO_DEVICE\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_NO_DEVICE\n");
 		ts->resp = SAS_TASK_UNDELIVERED;
 		ts->stat = SAS_PHY_DOWN;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_BREAK:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_BREAK\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_BREAK\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_INTERRUPTED;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_PHY_NOT_READY:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_PHY_NOT_READY\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_PHY_NOT_READY\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
@@ -2534,9 +2423,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_PROTOCOL_NOT"
-			"_SUPPORTED\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_EPROTO;
@@ -2544,8 +2431,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_ZONE_VIOLATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_ZONE_VIOLATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_ZONE_VIOLATION\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_UNKNOWN;
@@ -2553,8 +2440,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_BREAK:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_BREAK\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_BREAK\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_CONT0;
@@ -2562,8 +2448,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
 		if (!t->uldd_task) {
@@ -2577,8 +2462,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		}
 		break;
 	case IO_OPEN_CNX_ERROR_BAD_DESTINATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_BAD_DESTINATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_BAD_DESTINATION\n");
 		ts->resp = SAS_TASK_UNDELIVERED;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_BAD_DEST;
@@ -2593,9 +2478,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		}
 		break;
 	case IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_CONNECTION_RATE_"
-			"NOT_SUPPORTED\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_CONN_RATE;
@@ -2603,9 +2486,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_STP_RESOURCES_BUSY:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_STP_RESOURCES"
-			"_BUSY\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_STP_RESOURCES_BUSY\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
 		if (!t->uldd_task) {
@@ -2619,8 +2500,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		}
 		break;
 	case IO_OPEN_CNX_ERROR_WRONG_DESTINATION:
-		PM8001_IO_DBG(pm8001_ha,
-		       pm8001_printk("IO_OPEN_CNX_ERROR_WRONG_DESTINATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_WRONG_DESTINATION\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_WRONG_DEST;
@@ -2628,64 +2509,56 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_NAK_RECEIVED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_NAK_RECEIVED\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_NAK_RECEIVED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_NAK_R_ERR;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_ACK_NAK_TIMEOUT:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_ACK_NAK_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_ACK_NAK_TIMEOUT\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_NAK_R_ERR;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_DMA:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_DMA\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_DMA\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_ABORTED_TASK;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_SATA_LINK_TIMEOUT:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_SATA_LINK_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_SATA_LINK_TIMEOUT\n");
 		ts->resp = SAS_TASK_UNDELIVERED;
 		ts->stat = SAS_DEV_NO_RESPONSE;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_REJECTED_NCQ_MODE:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_REJECTED_NCQ_MODE\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_REJECTED_NCQ_MODE\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_UNDERRUN;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_OPEN_RETRY_TIMEOUT:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_OPEN_RETRY_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_OPEN_RETRY_TIMEOUT\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_TO;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_PORT_IN_RESET:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_PORT_IN_RESET\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_PORT_IN_RESET\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_DS_NON_OPERATIONAL:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_DS_NON_OPERATIONAL\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_DS_NON_OPERATIONAL\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
 		if (!t->uldd_task) {
@@ -2698,16 +2571,14 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		}
 		break;
 	case IO_DS_IN_RECOVERY:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("  IO_DS_IN_RECOVERY\n"));
+		pm8001_dbg(pm8001_ha, IO, "  IO_DS_IN_RECOVERY\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_DS_IN_ERROR:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_DS_IN_ERROR\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_DS_IN_ERROR\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
 		if (!t->uldd_task) {
@@ -2720,8 +2591,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		}
 		break;
 	case IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
@@ -2729,8 +2600,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	default:
-		PM8001_DEVIO_DBG(pm8001_ha,
-			pm8001_printk("Unknown status 0x%x\n", status));
+		pm8001_dbg(pm8001_ha, DEVIO, "Unknown status 0x%x\n", status);
 		/* not allowed case. Therefore, return failed status */
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
@@ -2744,10 +2614,9 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	t->task_state_flags |= SAS_TASK_STATE_DONE;
 	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("task 0x%p done with io_status 0x%x"
-			" resp 0x%x stat 0x%x but aborted by upper layer!\n",
-			t, status, ts->resp, ts->stat));
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
+			   t, status, ts->resp, ts->stat);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
@@ -2776,12 +2645,10 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		t = ccb->task;
 		pm8001_dev = ccb->device;
 	} else {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("No CCB !!!. returning\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "No CCB !!!. returning\n");
 	}
 	if (event)
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("SATA EVENT 0x%x\n", event));
+		pm8001_dbg(pm8001_ha, FAIL, "SATA EVENT 0x%x\n", event);
 
 	/* Check if this is NCQ error */
 	if (event == IO_XFER_ERROR_ABORTED_NCQ_MODE) {
@@ -2797,17 +2664,16 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 	t = ccb->task;
 	pm8001_dev = ccb->device;
 	if (event)
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("sata IO status 0x%x\n", event));
+		pm8001_dbg(pm8001_ha, FAIL, "sata IO status 0x%x\n", event);
 	if (unlikely(!t || !t->lldd_task || !t->dev))
 		return;
 	ts = &t->task_status;
-	PM8001_DEVIO_DBG(pm8001_ha, pm8001_printk(
-		"port_id:0x%x, device_id:0x%x, tag:0x%x, event:0x%x\n",
-		port_id, dev_id, tag, event));
+	pm8001_dbg(pm8001_ha, DEVIO,
+		   "port_id:0x%x, device_id:0x%x, tag:0x%x, event:0x%x\n",
+		   port_id, dev_id, tag, event);
 	switch (event) {
 	case IO_OVERFLOW:
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_UNDERFLOW\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_UNDERFLOW\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
 		ts->residual = 0;
@@ -2815,43 +2681,37 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_BREAK:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_BREAK\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_BREAK\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_INTERRUPTED;
 		break;
 	case IO_XFER_ERROR_PHY_NOT_READY:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_PHY_NOT_READY\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_PHY_NOT_READY\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
 		break;
 	case IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_PROTOCOL_NOT"
-			"_SUPPORTED\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_EPROTO;
 		break;
 	case IO_OPEN_CNX_ERROR_ZONE_VIOLATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_ZONE_VIOLATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_ZONE_VIOLATION\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_UNKNOWN;
 		break;
 	case IO_OPEN_CNX_ERROR_BREAK:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_BREAK\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_BREAK\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_CONT0;
 		break;
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n");
 		ts->resp = SAS_TASK_UNDELIVERED;
 		ts->stat = SAS_DEV_NO_RESPONSE;
 		if (!t->uldd_task) {
@@ -2865,94 +2725,82 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		}
 		break;
 	case IO_OPEN_CNX_ERROR_BAD_DESTINATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_BAD_DESTINATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_BAD_DESTINATION\n");
 		ts->resp = SAS_TASK_UNDELIVERED;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_BAD_DEST;
 		break;
 	case IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_CONNECTION_RATE_"
-			"NOT_SUPPORTED\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_CONN_RATE;
 		break;
 	case IO_OPEN_CNX_ERROR_WRONG_DESTINATION:
-		PM8001_IO_DBG(pm8001_ha,
-		       pm8001_printk("IO_OPEN_CNX_ERROR_WRONG_DESTINATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_WRONG_DESTINATION\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_WRONG_DEST;
 		break;
 	case IO_XFER_ERROR_NAK_RECEIVED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_NAK_RECEIVED\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_NAK_RECEIVED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_NAK_R_ERR;
 		break;
 	case IO_XFER_ERROR_PEER_ABORTED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_PEER_ABORTED\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_PEER_ABORTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_NAK_R_ERR;
 		break;
 	case IO_XFER_ERROR_REJECTED_NCQ_MODE:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_REJECTED_NCQ_MODE\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_REJECTED_NCQ_MODE\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_UNDERRUN;
 		break;
 	case IO_XFER_OPEN_RETRY_TIMEOUT:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_OPEN_RETRY_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_OPEN_RETRY_TIMEOUT\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_TO;
 		break;
 	case IO_XFER_ERROR_UNEXPECTED_PHASE:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_UNEXPECTED_PHASE\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_UNEXPECTED_PHASE\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_TO;
 		break;
 	case IO_XFER_ERROR_XFER_RDY_OVERRUN:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_XFER_RDY_OVERRUN\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_XFER_RDY_OVERRUN\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_TO;
 		break;
 	case IO_XFER_ERROR_XFER_RDY_NOT_EXPECTED:
-		PM8001_IO_DBG(pm8001_ha,
-		       pm8001_printk("IO_XFER_ERROR_XFER_RDY_NOT_EXPECTED\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_XFER_ERROR_XFER_RDY_NOT_EXPECTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_TO;
 		break;
 	case IO_XFER_ERROR_OFFSET_MISMATCH:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_OFFSET_MISMATCH\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_OFFSET_MISMATCH\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_TO;
 		break;
 	case IO_XFER_ERROR_XFER_ZERO_DATA_LEN:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_XFER_ZERO_DATA_LEN\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_XFER_ERROR_XFER_ZERO_DATA_LEN\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_TO;
 		break;
 	case IO_XFER_CMD_FRAME_ISSUED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_CMD_FRAME_ISSUED\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_CMD_FRAME_ISSUED\n");
 		break;
 	case IO_XFER_PIO_SETUP_ERROR:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_PIO_SETUP_ERROR\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_PIO_SETUP_ERROR\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_TO;
 		break;
 	default:
-		PM8001_DEVIO_DBG(pm8001_ha,
-			pm8001_printk("Unknown status 0x%x\n", event));
+		pm8001_dbg(pm8001_ha, DEVIO, "Unknown status 0x%x\n", event);
 		/* not allowed case. Therefore, return failed status */
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_TO;
@@ -2964,10 +2812,9 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 	t->task_state_flags |= SAS_TASK_STATE_DONE;
 	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("task 0x%p done with io_status 0x%x"
-			" resp 0x%x stat 0x%x but aborted by upper layer!\n",
-			t, event, ts->resp, ts->stat));
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
+			   t, event, ts->resp, ts->stat);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
@@ -2997,33 +2844,31 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	ts = &t->task_status;
 	pm8001_dev = ccb->device;
 	if (status) {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("smp IO status 0x%x\n", status));
-		PM8001_IOERR_DBG(pm8001_ha,
-			pm8001_printk("status:0x%x, tag:0x%x, task:0x%p\n",
-			status, tag, t));
+		pm8001_dbg(pm8001_ha, FAIL, "smp IO status 0x%x\n", status);
+		pm8001_dbg(pm8001_ha, IOERR,
+			   "status:0x%x, tag:0x%x, task:0x%p\n",
+			   status, tag, t);
 	}
 	if (unlikely(!t || !t->lldd_task || !t->dev))
 		return;
 
 	switch (status) {
 	case IO_SUCCESS:
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_SUCCESS\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAM_STAT_GOOD;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_ABORTED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_ABORTED IOMB\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_ABORTED IOMB\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_ABORTED_TASK;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OVERFLOW:
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_UNDERFLOW\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_UNDERFLOW\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
 		ts->residual = 0;
@@ -3031,52 +2876,47 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_NO_DEVICE:
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_NO_DEVICE\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_NO_DEVICE\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_PHY_DOWN;
 		break;
 	case IO_ERROR_HW_TIMEOUT:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_ERROR_HW_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_ERROR_HW_TIMEOUT\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAM_STAT_BUSY;
 		break;
 	case IO_XFER_ERROR_BREAK:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_BREAK\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_BREAK\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAM_STAT_BUSY;
 		break;
 	case IO_XFER_ERROR_PHY_NOT_READY:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_PHY_NOT_READY\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_PHY_NOT_READY\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAM_STAT_BUSY;
 		break;
 	case IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED:
-		PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk("IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_UNKNOWN;
 		break;
 	case IO_OPEN_CNX_ERROR_ZONE_VIOLATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_ZONE_VIOLATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_ZONE_VIOLATION\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_UNKNOWN;
 		break;
 	case IO_OPEN_CNX_ERROR_BREAK:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_BREAK\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_BREAK\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_CONT0;
 		break;
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_UNKNOWN;
@@ -3085,76 +2925,67 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 		break;
 	case IO_OPEN_CNX_ERROR_BAD_DESTINATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_BAD_DESTINATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_BAD_DESTINATION\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_BAD_DEST;
 		break;
 	case IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_CONNECTION_RATE_"
-			"NOT_SUPPORTED\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_CONN_RATE;
 		break;
 	case IO_OPEN_CNX_ERROR_WRONG_DESTINATION:
-		PM8001_IO_DBG(pm8001_ha,
-		       pm8001_printk("IO_OPEN_CNX_ERROR_WRONG_DESTINATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_WRONG_DESTINATION\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_WRONG_DEST;
 		break;
 	case IO_XFER_ERROR_RX_FRAME:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_RX_FRAME\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_RX_FRAME\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
 		break;
 	case IO_XFER_OPEN_RETRY_TIMEOUT:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_OPEN_RETRY_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_OPEN_RETRY_TIMEOUT\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
 		break;
 	case IO_ERROR_INTERNAL_SMP_RESOURCE:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_ERROR_INTERNAL_SMP_RESOURCE\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_ERROR_INTERNAL_SMP_RESOURCE\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_QUEUE_FULL;
 		break;
 	case IO_PORT_IN_RESET:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_PORT_IN_RESET\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_PORT_IN_RESET\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
 		break;
 	case IO_DS_NON_OPERATIONAL:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_DS_NON_OPERATIONAL\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_DS_NON_OPERATIONAL\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
 		break;
 	case IO_DS_IN_RECOVERY:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_DS_IN_RECOVERY\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_DS_IN_RECOVERY\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
 		break;
 	case IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
 		break;
 	default:
-		PM8001_DEVIO_DBG(pm8001_ha,
-			pm8001_printk("Unknown status 0x%x\n", status));
+		pm8001_dbg(pm8001_ha, DEVIO, "Unknown status 0x%x\n", status);
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
 		/* not allowed case. Therefore, return failed status */
@@ -3166,10 +2997,8 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	t->task_state_flags |= SAS_TASK_STATE_DONE;
 	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("task 0x%p done with"
-			" io_status 0x%x resp 0x%x "
-			"stat 0x%x but aborted by upper layer!\n",
-			t, status, ts->resp, ts->stat));
+		pm8001_dbg(pm8001_ha, FAIL, "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
+			   t, status, ts->resp, ts->stat);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
@@ -3191,9 +3020,8 @@ void pm8001_mpi_set_dev_state_resp(struct pm8001_hba_info *pm8001_ha,
 	u32 device_id = le32_to_cpu(pPayload->device_id);
 	u8 pds = le32_to_cpu(pPayload->pds_nds) & PDS_BITS;
 	u8 nds = le32_to_cpu(pPayload->pds_nds) & NDS_BITS;
-	PM8001_MSG_DBG(pm8001_ha, pm8001_printk("Set device id = 0x%x state "
-		"from 0x%x to 0x%x status = 0x%x!\n",
-		device_id, pds, nds, status));
+	pm8001_dbg(pm8001_ha, MSG, "Set device id = 0x%x state from 0x%x to 0x%x status = 0x%x!\n",
+		   device_id, pds, nds, status);
 	complete(pm8001_dev->setds_completion);
 	ccb->task = NULL;
 	ccb->ccb_tag = 0xFFFFFFFF;
@@ -3208,10 +3036,9 @@ void pm8001_mpi_set_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	struct pm8001_ccb_info *ccb = &pm8001_ha->ccb_info[tag];
 	u32 dlen_status = le32_to_cpu(pPayload->dlen_status);
 	complete(pm8001_ha->nvmd_completion);
-	PM8001_MSG_DBG(pm8001_ha, pm8001_printk("Set nvm data complete!\n"));
+	pm8001_dbg(pm8001_ha, MSG, "Set nvm data complete!\n");
 	if ((dlen_status & NVMD_STAT) != 0) {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("Set nvm data error!\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "Set nvm data error!\n");
 		return;
 	}
 	ccb->task = NULL;
@@ -3233,26 +3060,22 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	void *virt_addr = pm8001_ha->memoryMap.region[NVMD].virt_ptr;
 	fw_control_context = ccb->fw_control_context;
 
-	PM8001_MSG_DBG(pm8001_ha, pm8001_printk("Get nvm data complete!\n"));
+	pm8001_dbg(pm8001_ha, MSG, "Get nvm data complete!\n");
 	if ((dlen_status & NVMD_STAT) != 0) {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("Get nvm data error!\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "Get nvm data error!\n");
 		complete(pm8001_ha->nvmd_completion);
 		return;
 	}
 
 	if (ir_tds_bn_dps_das_nvm & IPMode) {
 		/* indirect mode - IR bit set */
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("Get NVMD success, IR=1\n"));
+		pm8001_dbg(pm8001_ha, MSG, "Get NVMD success, IR=1\n");
 		if ((ir_tds_bn_dps_das_nvm & NVMD_TYPE) == TWI_DEVICE) {
 			if (ir_tds_bn_dps_das_nvm == 0x80a80200) {
 				memcpy(pm8001_ha->sas_addr,
 				      ((u8 *)virt_addr + 4),
 				       SAS_ADDR_SIZE);
-				PM8001_MSG_DBG(pm8001_ha,
-					pm8001_printk("Get SAS address"
-					" from VPD successfully!\n"));
+				pm8001_dbg(pm8001_ha, MSG, "Get SAS address from VPD successfully!\n");
 			}
 		} else if (((ir_tds_bn_dps_das_nvm & NVMD_TYPE) == C_SEEPROM)
 			|| ((ir_tds_bn_dps_das_nvm & NVMD_TYPE) == VPD_FLASH) ||
@@ -3263,14 +3086,14 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			;
 		} else {
 			/* Should not be happened*/
-			PM8001_MSG_DBG(pm8001_ha,
-				pm8001_printk("(IR=1)Wrong Device type 0x%x\n",
-				ir_tds_bn_dps_das_nvm));
+			pm8001_dbg(pm8001_ha, MSG,
+				   "(IR=1)Wrong Device type 0x%x\n",
+				   ir_tds_bn_dps_das_nvm);
 		}
 	} else /* direct mode */{
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("Get NVMD success, IR=0, dataLen=%d\n",
-			(dlen_status & NVMD_LEN) >> 24));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "Get NVMD success, IR=0, dataLen=%d\n",
+			   (dlen_status & NVMD_LEN) >> 24);
 	}
 	/* Though fw_control_context is freed below, usrAddr still needs
 	 * to be updated as this holds the response to the request function
@@ -3284,7 +3107,7 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	 * fw_control_context->usrAddr
 	 */
 	complete(pm8001_ha->nvmd_completion);
-	PM8001_MSG_DBG(pm8001_ha, pm8001_printk("Set nvm data complete!\n"));
+	pm8001_dbg(pm8001_ha, MSG, "Set nvm data complete!\n");
 	ccb->task = NULL;
 	ccb->ccb_tag = 0xFFFFFFFF;
 	pm8001_tag_free(pm8001_ha, tag);
@@ -3300,13 +3123,13 @@ int pm8001_mpi_local_phy_ctl(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	u32 phy_op = le32_to_cpu(pPayload->phyop_phyid) & OP_BITS;
 	tag = le32_to_cpu(pPayload->tag);
 	if (status != 0) {
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("%x phy execute %x phy op failed!\n",
-			phy_id, phy_op));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "%x phy execute %x phy op failed!\n",
+			   phy_id, phy_op);
 	} else {
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("%x phy execute %x phy op success!\n",
-			phy_id, phy_op));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "%x phy execute %x phy op success!\n",
+			   phy_id, phy_op);
 		pm8001_ha->phy[phy_id].reset_success = true;
 	}
 	if (pm8001_ha->phy[phy_id].enable_completion) {
@@ -3353,7 +3176,7 @@ void pm8001_bytes_dmaed(struct pm8001_hba_info *pm8001_ha, int i)
 	} else if (phy->phy_type & PORT_TYPE_SATA) {
 		/*Nothing*/
 	}
-	PM8001_MSG_DBG(pm8001_ha, pm8001_printk("phy %d byte dmaded.\n", i));
+	pm8001_dbg(pm8001_ha, MSG, "phy %d byte dmaded.\n", i);
 
 	sas_phy->frame_rcvd_size = phy->frame_rcvd_size;
 	pm8001_ha->sas->notify_port_event(sas_phy, PORTE_BYTES_DMAED);
@@ -3476,37 +3299,34 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	u8 deviceType = pPayload->sas_identify.dev_type;
 	port->port_state =  portstate;
 	phy->phy_state = PHY_STATE_LINK_UP_SPC;
-	PM8001_MSG_DBG(pm8001_ha,
-		pm8001_printk("HW_EVENT_SAS_PHY_UP port id = %d, phy id = %d\n",
-		port_id, phy_id));
+	pm8001_dbg(pm8001_ha, MSG,
+		   "HW_EVENT_SAS_PHY_UP port id = %d, phy id = %d\n",
+		   port_id, phy_id);
 
 	switch (deviceType) {
 	case SAS_PHY_UNUSED:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("device type no device.\n"));
+		pm8001_dbg(pm8001_ha, MSG, "device type no device.\n");
 		break;
 	case SAS_END_DEVICE:
-		PM8001_MSG_DBG(pm8001_ha, pm8001_printk("end device.\n"));
+		pm8001_dbg(pm8001_ha, MSG, "end device.\n");
 		pm8001_chip_phy_ctl_req(pm8001_ha, phy_id,
 			PHY_NOTIFY_ENABLE_SPINUP);
 		port->port_attached = 1;
 		pm8001_get_lrate_mode(phy, link_rate);
 		break;
 	case SAS_EDGE_EXPANDER_DEVICE:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("expander device.\n"));
+		pm8001_dbg(pm8001_ha, MSG, "expander device.\n");
 		port->port_attached = 1;
 		pm8001_get_lrate_mode(phy, link_rate);
 		break;
 	case SAS_FANOUT_EXPANDER_DEVICE:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("fanout expander device.\n"));
+		pm8001_dbg(pm8001_ha, MSG, "fanout expander device.\n");
 		port->port_attached = 1;
 		pm8001_get_lrate_mode(phy, link_rate);
 		break;
 	default:
-		PM8001_DEVIO_DBG(pm8001_ha,
-			pm8001_printk("unknown device type(%x)\n", deviceType));
+		pm8001_dbg(pm8001_ha, DEVIO, "unknown device type(%x)\n",
+			   deviceType);
 		break;
 	}
 	phy->phy_type |= PORT_TYPE_SAS;
@@ -3552,9 +3372,8 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	struct sas_ha_struct *sas_ha = pm8001_ha->sas;
 	struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
 	unsigned long flags;
-	PM8001_DEVIO_DBG(pm8001_ha,
-		pm8001_printk("HW_EVENT_SATA_PHY_UP port id = %d,"
-		" phy id = %d\n", port_id, phy_id));
+	pm8001_dbg(pm8001_ha, DEVIO, "HW_EVENT_SATA_PHY_UP port id = %d, phy id = %d\n",
+		   port_id, phy_id);
 	port->port_state =  portstate;
 	phy->phy_state = PHY_STATE_LINK_UP_SPC;
 	port->port_attached = 1;
@@ -3602,37 +3421,35 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	case PORT_VALID:
 		break;
 	case PORT_INVALID:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" PortInvalid portID %d\n", port_id));
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" Last phy Down and port invalid\n"));
+		pm8001_dbg(pm8001_ha, MSG, " PortInvalid portID %d\n",
+			   port_id);
+		pm8001_dbg(pm8001_ha, MSG,
+			   " Last phy Down and port invalid\n");
 		port->port_attached = 0;
 		pm8001_hw_event_ack_req(pm8001_ha, 0, HW_EVENT_PHY_DOWN,
 			port_id, phy_id, 0, 0);
 		break;
 	case PORT_IN_RESET:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" Port In Reset portID %d\n", port_id));
+		pm8001_dbg(pm8001_ha, MSG, " Port In Reset portID %d\n",
+			   port_id);
 		break;
 	case PORT_NOT_ESTABLISHED:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" phy Down and PORT_NOT_ESTABLISHED\n"));
+		pm8001_dbg(pm8001_ha, MSG,
+			   " phy Down and PORT_NOT_ESTABLISHED\n");
 		port->port_attached = 0;
 		break;
 	case PORT_LOSTCOMM:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" phy Down and PORT_LOSTCOMM\n"));
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" Last phy Down and port invalid\n"));
+		pm8001_dbg(pm8001_ha, MSG, " phy Down and PORT_LOSTCOMM\n");
+		pm8001_dbg(pm8001_ha, MSG,
+			   " Last phy Down and port invalid\n");
 		port->port_attached = 0;
 		pm8001_hw_event_ack_req(pm8001_ha, 0, HW_EVENT_PHY_DOWN,
 			port_id, phy_id, 0, 0);
 		break;
 	default:
 		port->port_attached = 0;
-		PM8001_DEVIO_DBG(pm8001_ha,
-			pm8001_printk(" phy Down and(default) = %x\n",
-			portstate));
+		pm8001_dbg(pm8001_ha, DEVIO, " phy Down and(default) = %x\n",
+			   portstate);
 		break;
 
 	}
@@ -3663,44 +3480,42 @@ int pm8001_mpi_reg_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	pm8001_dev = ccb->device;
 	status = le32_to_cpu(registerRespPayload->status);
 	device_id = le32_to_cpu(registerRespPayload->device_id);
-	PM8001_MSG_DBG(pm8001_ha,
-		pm8001_printk(" register device is status = %d\n", status));
+	pm8001_dbg(pm8001_ha, MSG, " register device is status = %d\n",
+		   status);
 	switch (status) {
 	case DEVREG_SUCCESS:
-		PM8001_MSG_DBG(pm8001_ha, pm8001_printk("DEVREG_SUCCESS\n"));
+		pm8001_dbg(pm8001_ha, MSG, "DEVREG_SUCCESS\n");
 		pm8001_dev->device_id = device_id;
 		break;
 	case DEVREG_FAILURE_OUT_OF_RESOURCE:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("DEVREG_FAILURE_OUT_OF_RESOURCE\n"));
+		pm8001_dbg(pm8001_ha, MSG, "DEVREG_FAILURE_OUT_OF_RESOURCE\n");
 		break;
 	case DEVREG_FAILURE_DEVICE_ALREADY_REGISTERED:
-		PM8001_MSG_DBG(pm8001_ha,
-		   pm8001_printk("DEVREG_FAILURE_DEVICE_ALREADY_REGISTERED\n"));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "DEVREG_FAILURE_DEVICE_ALREADY_REGISTERED\n");
 		break;
 	case DEVREG_FAILURE_INVALID_PHY_ID:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("DEVREG_FAILURE_INVALID_PHY_ID\n"));
+		pm8001_dbg(pm8001_ha, MSG, "DEVREG_FAILURE_INVALID_PHY_ID\n");
 		break;
 	case DEVREG_FAILURE_PHY_ID_ALREADY_REGISTERED:
-		PM8001_MSG_DBG(pm8001_ha,
-		   pm8001_printk("DEVREG_FAILURE_PHY_ID_ALREADY_REGISTERED\n"));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "DEVREG_FAILURE_PHY_ID_ALREADY_REGISTERED\n");
 		break;
 	case DEVREG_FAILURE_PORT_ID_OUT_OF_RANGE:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("DEVREG_FAILURE_PORT_ID_OUT_OF_RANGE\n"));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "DEVREG_FAILURE_PORT_ID_OUT_OF_RANGE\n");
 		break;
 	case DEVREG_FAILURE_PORT_NOT_VALID_STATE:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("DEVREG_FAILURE_PORT_NOT_VALID_STATE\n"));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "DEVREG_FAILURE_PORT_NOT_VALID_STATE\n");
 		break;
 	case DEVREG_FAILURE_DEVICE_TYPE_NOT_VALID:
-		PM8001_MSG_DBG(pm8001_ha,
-		       pm8001_printk("DEVREG_FAILURE_DEVICE_TYPE_NOT_VALID\n"));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "DEVREG_FAILURE_DEVICE_TYPE_NOT_VALID\n");
 		break;
 	default:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("DEVREG_FAILURE_DEVICE_TYPE_NOT_SUPPORTED\n"));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "DEVREG_FAILURE_DEVICE_TYPE_NOT_SUPPORTED\n");
 		break;
 	}
 	complete(pm8001_dev->dcompletion);
@@ -3720,9 +3535,9 @@ int pm8001_mpi_dereg_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	status = le32_to_cpu(registerRespPayload->status);
 	device_id = le32_to_cpu(registerRespPayload->device_id);
 	if (status != 0)
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" deregister device failed ,status = %x"
-			", device_id = %x\n", status, device_id));
+		pm8001_dbg(pm8001_ha, MSG,
+			   " deregister device failed ,status = %x, device_id = %x\n",
+			   status, device_id);
 	return 0;
 }
 
@@ -3742,44 +3557,37 @@ int pm8001_mpi_fw_flash_update_resp(struct pm8001_hba_info *pm8001_ha,
 	status = le32_to_cpu(ppayload->status);
 	switch (status) {
 	case FLASH_UPDATE_COMPLETE_PENDING_REBOOT:
-		PM8001_MSG_DBG(pm8001_ha,
-		pm8001_printk(": FLASH_UPDATE_COMPLETE_PENDING_REBOOT\n"));
+		pm8001_dbg(pm8001_ha, MSG,
+			   ": FLASH_UPDATE_COMPLETE_PENDING_REBOOT\n");
 		break;
 	case FLASH_UPDATE_IN_PROGRESS:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(": FLASH_UPDATE_IN_PROGRESS\n"));
+		pm8001_dbg(pm8001_ha, MSG, ": FLASH_UPDATE_IN_PROGRESS\n");
 		break;
 	case FLASH_UPDATE_HDR_ERR:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(": FLASH_UPDATE_HDR_ERR\n"));
+		pm8001_dbg(pm8001_ha, MSG, ": FLASH_UPDATE_HDR_ERR\n");
 		break;
 	case FLASH_UPDATE_OFFSET_ERR:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(": FLASH_UPDATE_OFFSET_ERR\n"));
+		pm8001_dbg(pm8001_ha, MSG, ": FLASH_UPDATE_OFFSET_ERR\n");
 		break;
 	case FLASH_UPDATE_CRC_ERR:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(": FLASH_UPDATE_CRC_ERR\n"));
+		pm8001_dbg(pm8001_ha, MSG, ": FLASH_UPDATE_CRC_ERR\n");
 		break;
 	case FLASH_UPDATE_LENGTH_ERR:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(": FLASH_UPDATE_LENGTH_ERR\n"));
+		pm8001_dbg(pm8001_ha, MSG, ": FLASH_UPDATE_LENGTH_ERR\n");
 		break;
 	case FLASH_UPDATE_HW_ERR:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(": FLASH_UPDATE_HW_ERR\n"));
+		pm8001_dbg(pm8001_ha, MSG, ": FLASH_UPDATE_HW_ERR\n");
 		break;
 	case FLASH_UPDATE_DNLD_NOT_SUPPORTED:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(": FLASH_UPDATE_DNLD_NOT_SUPPORTED\n"));
+		pm8001_dbg(pm8001_ha, MSG,
+			   ": FLASH_UPDATE_DNLD_NOT_SUPPORTED\n");
 		break;
 	case FLASH_UPDATE_DISABLED:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(": FLASH_UPDATE_DISABLED\n"));
+		pm8001_dbg(pm8001_ha, MSG, ": FLASH_UPDATE_DISABLED\n");
 		break;
 	default:
-		PM8001_DEVIO_DBG(pm8001_ha,
-			pm8001_printk("No matched status = %d\n", status));
+		pm8001_dbg(pm8001_ha, DEVIO, "No matched status = %d\n",
+			   status);
 		break;
 	}
 	kfree(ccb->fw_control_context);
@@ -3797,12 +3605,11 @@ int pm8001_mpi_general_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 	struct general_event_resp *pPayload =
 		(struct general_event_resp *)(piomb + 4);
 	status = le32_to_cpu(pPayload->status);
-	PM8001_MSG_DBG(pm8001_ha,
-		pm8001_printk(" status = 0x%x\n", status));
+	pm8001_dbg(pm8001_ha, MSG, " status = 0x%x\n", status);
 	for (i = 0; i < GENERAL_EVENT_PAYLOAD; i++)
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("inb_IOMB_payload[0x%x] 0x%x,\n", i,
-			pPayload->inb_IOMB_payload[i]));
+		pm8001_dbg(pm8001_ha, MSG, "inb_IOMB_payload[0x%x] 0x%x,\n",
+			   i,
+			   pPayload->inb_IOMB_payload[i]);
 	return 0;
 }
 
@@ -3822,8 +3629,7 @@ int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	status = le32_to_cpu(pPayload->status);
 	tag = le32_to_cpu(pPayload->tag);
 	if (!tag) {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk(" TAG NULL. RETURNING !!!"));
+		pm8001_dbg(pm8001_ha, FAIL, " TAG NULL. RETURNING !!!\n");
 		return -1;
 	}
 
@@ -3833,23 +3639,21 @@ int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	pm8001_dev = ccb->device; /* retrieve device */
 
 	if (!t)	{
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk(" TASK NULL. RETURNING !!!"));
+		pm8001_dbg(pm8001_ha, FAIL, " TASK NULL. RETURNING !!!\n");
 		return -1;
 	}
 	ts = &t->task_status;
 	if (status != 0)
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("task abort failed status 0x%x ,"
-			"tag = 0x%x, scp= 0x%x\n", status, tag, scp));
+		pm8001_dbg(pm8001_ha, FAIL, "task abort failed status 0x%x ,tag = 0x%x, scp= 0x%x\n",
+			   status, tag, scp);
 	switch (status) {
 	case IO_SUCCESS:
-		PM8001_EH_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS\n"));
+		pm8001_dbg(pm8001_ha, EH, "IO_SUCCESS\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAM_STAT_GOOD;
 		break;
 	case IO_NOT_VALID:
-		PM8001_EH_DBG(pm8001_ha, pm8001_printk("IO_NOT_VALID\n"));
+		pm8001_dbg(pm8001_ha, EH, "IO_NOT_VALID\n");
 		ts->resp = TMF_RESP_FUNC_FAILED;
 		break;
 	}
@@ -3894,14 +3698,13 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 	struct sas_ha_struct *sas_ha = pm8001_ha->sas;
 	struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
 	struct asd_sas_phy *sas_phy = sas_ha->sas_phy[phy_id];
-	PM8001_DEVIO_DBG(pm8001_ha, pm8001_printk(
-		"SPC HW event for portid:%d, phyid:%d, event:%x, status:%x\n",
-		port_id, phy_id, eventType, status));
+	pm8001_dbg(pm8001_ha, DEVIO,
+		   "SPC HW event for portid:%d, phyid:%d, event:%x, status:%x\n",
+		   port_id, phy_id, eventType, status);
 	switch (eventType) {
 	case HW_EVENT_PHY_START_STATUS:
-		PM8001_MSG_DBG(pm8001_ha,
-		pm8001_printk("HW_EVENT_PHY_START_STATUS"
-			" status = %x\n", status));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_START_STATUS status = %x\n",
+			   status);
 		if (status == 0) {
 			phy->phy_state = 1;
 			if (pm8001_ha->flags == PM8001F_RUN_TIME &&
@@ -3910,38 +3713,32 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		}
 		break;
 	case HW_EVENT_SAS_PHY_UP:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_PHY_START_STATUS\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_START_STATUS\n");
 		hw_event_sas_phy_up(pm8001_ha, piomb);
 		break;
 	case HW_EVENT_SATA_PHY_UP:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_SATA_PHY_UP\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_SATA_PHY_UP\n");
 		hw_event_sata_phy_up(pm8001_ha, piomb);
 		break;
 	case HW_EVENT_PHY_STOP_STATUS:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_PHY_STOP_STATUS "
-			"status = %x\n", status));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_STOP_STATUS status = %x\n",
+			   status);
 		if (status == 0)
 			phy->phy_state = 0;
 		break;
 	case HW_EVENT_SATA_SPINUP_HOLD:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_SATA_SPINUP_HOLD\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_SATA_SPINUP_HOLD\n");
 		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_SPINUP_HOLD);
 		break;
 	case HW_EVENT_PHY_DOWN:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_PHY_DOWN\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_DOWN\n");
 		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL);
 		phy->phy_attached = 0;
 		phy->phy_state = 0;
 		hw_event_phy_down(pm8001_ha, piomb);
 		break;
 	case HW_EVENT_PORT_INVALID:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_PORT_INVALID\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_INVALID\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
 		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
@@ -3949,8 +3746,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 	/* the broadcast change primitive received, tell the LIBSAS this event
 	to revalidate the sas domain*/
 	case HW_EVENT_BROADCAST_CHANGE:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_BROADCAST_CHANGE\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_BROADCAST_CHANGE\n");
 		pm8001_hw_event_ack_req(pm8001_ha, 0, HW_EVENT_BROADCAST_CHANGE,
 			port_id, phy_id, 1, 0);
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
@@ -3959,23 +3755,21 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
 		break;
 	case HW_EVENT_PHY_ERROR:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_PHY_ERROR\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_ERROR\n");
 		sas_phy_disconnected(&phy->sas_phy);
 		phy->phy_attached = 0;
 		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_OOB_ERROR);
 		break;
 	case HW_EVENT_BROADCAST_EXP:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_BROADCAST_EXP\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_BROADCAST_EXP\n");
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_EXP;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
 		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
 		break;
 	case HW_EVENT_LINK_ERR_INVALID_DWORD:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_LINK_ERR_INVALID_DWORD\n"));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "HW_EVENT_LINK_ERR_INVALID_DWORD\n");
 		pm8001_hw_event_ack_req(pm8001_ha, 0,
 			HW_EVENT_LINK_ERR_INVALID_DWORD, port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
@@ -3983,8 +3777,8 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_LINK_ERR_DISPARITY_ERROR:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_LINK_ERR_DISPARITY_ERROR\n"));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "HW_EVENT_LINK_ERR_DISPARITY_ERROR\n");
 		pm8001_hw_event_ack_req(pm8001_ha, 0,
 			HW_EVENT_LINK_ERR_DISPARITY_ERROR,
 			port_id, phy_id, 0, 0);
@@ -3993,8 +3787,8 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_LINK_ERR_CODE_VIOLATION:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_LINK_ERR_CODE_VIOLATION\n"));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "HW_EVENT_LINK_ERR_CODE_VIOLATION\n");
 		pm8001_hw_event_ack_req(pm8001_ha, 0,
 			HW_EVENT_LINK_ERR_CODE_VIOLATION,
 			port_id, phy_id, 0, 0);
@@ -4003,8 +3797,8 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_LINK_ERR_LOSS_OF_DWORD_SYNCH:
-		PM8001_MSG_DBG(pm8001_ha,
-		      pm8001_printk("HW_EVENT_LINK_ERR_LOSS_OF_DWORD_SYNCH\n"));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "HW_EVENT_LINK_ERR_LOSS_OF_DWORD_SYNCH\n");
 		pm8001_hw_event_ack_req(pm8001_ha, 0,
 			HW_EVENT_LINK_ERR_LOSS_OF_DWORD_SYNCH,
 			port_id, phy_id, 0, 0);
@@ -4013,39 +3807,34 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_MALFUNCTION:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_MALFUNCTION\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_MALFUNCTION\n");
 		break;
 	case HW_EVENT_BROADCAST_SES:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_BROADCAST_SES\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_BROADCAST_SES\n");
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_SES;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
 		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
 		break;
 	case HW_EVENT_INBOUND_CRC_ERROR:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_INBOUND_CRC_ERROR\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_INBOUND_CRC_ERROR\n");
 		pm8001_hw_event_ack_req(pm8001_ha, 0,
 			HW_EVENT_INBOUND_CRC_ERROR,
 			port_id, phy_id, 0, 0);
 		break;
 	case HW_EVENT_HARD_RESET_RECEIVED:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_HARD_RESET_RECEIVED\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_HARD_RESET_RECEIVED\n");
 		sas_ha->notify_port_event(sas_phy, PORTE_HARD_RESET);
 		break;
 	case HW_EVENT_ID_FRAME_TIMEOUT:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_ID_FRAME_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_ID_FRAME_TIMEOUT\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
 		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_LINK_ERR_PHY_RESET_FAILED:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_LINK_ERR_PHY_RESET_FAILED\n"));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "HW_EVENT_LINK_ERR_PHY_RESET_FAILED\n");
 		pm8001_hw_event_ack_req(pm8001_ha, 0,
 			HW_EVENT_LINK_ERR_PHY_RESET_FAILED,
 			port_id, phy_id, 0, 0);
@@ -4054,34 +3843,30 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_PORT_RESET_TIMER_TMO:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_PORT_RESET_TIMER_TMO\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_RESET_TIMER_TMO\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
 		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_PORT_RECOVERY_TIMER_TMO:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_PORT_RECOVERY_TIMER_TMO\n"));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "HW_EVENT_PORT_RECOVERY_TIMER_TMO\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
 		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_PORT_RECOVER:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_PORT_RECOVER\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_RECOVER\n");
 		break;
 	case HW_EVENT_PORT_RESET_COMPLETE:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_PORT_RESET_COMPLETE\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_RESET_COMPLETE\n");
 		break;
 	case EVENT_BROADCAST_ASYNCH_EVENT:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("EVENT_BROADCAST_ASYNCH_EVENT\n"));
+		pm8001_dbg(pm8001_ha, MSG, "EVENT_BROADCAST_ASYNCH_EVENT\n");
 		break;
 	default:
-		PM8001_DEVIO_DBG(pm8001_ha,
-			pm8001_printk("Unknown event type = %x\n", eventType));
+		pm8001_dbg(pm8001_ha, DEVIO, "Unknown event type = %x\n",
+			   eventType);
 		break;
 	}
 	return 0;
@@ -4097,163 +3882,132 @@ static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	__le32 pHeader = *(__le32 *)piomb;
 	u8 opc = (u8)((le32_to_cpu(pHeader)) & 0xFFF);
 
-	PM8001_MSG_DBG(pm8001_ha, pm8001_printk("process_one_iomb:"));
+	pm8001_dbg(pm8001_ha, MSG, "process_one_iomb:\n");
 
 	switch (opc) {
 	case OPC_OUB_ECHO:
-		PM8001_MSG_DBG(pm8001_ha, pm8001_printk("OPC_OUB_ECHO\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_ECHO\n");
 		break;
 	case OPC_OUB_HW_EVENT:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_HW_EVENT\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_HW_EVENT\n");
 		mpi_hw_event(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SSP_COMP:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SSP_COMP\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SSP_COMP\n");
 		mpi_ssp_completion(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SMP_COMP:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SMP_COMP\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SMP_COMP\n");
 		mpi_smp_completion(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_LOCAL_PHY_CNTRL:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_LOCAL_PHY_CNTRL\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_LOCAL_PHY_CNTRL\n");
 		pm8001_mpi_local_phy_ctl(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_DEV_REGIST:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_DEV_REGIST\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_DEV_REGIST\n");
 		pm8001_mpi_reg_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_DEREG_DEV:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("unregister the device\n"));
+		pm8001_dbg(pm8001_ha, MSG, "unregister the device\n");
 		pm8001_mpi_dereg_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_GET_DEV_HANDLE:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_GET_DEV_HANDLE\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_GET_DEV_HANDLE\n");
 		break;
 	case OPC_OUB_SATA_COMP:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SATA_COMP\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SATA_COMP\n");
 		mpi_sata_completion(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SATA_EVENT:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SATA_EVENT\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SATA_EVENT\n");
 		mpi_sata_event(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SSP_EVENT:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SSP_EVENT\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SSP_EVENT\n");
 		mpi_ssp_event(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_DEV_HANDLE_ARRIV:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_DEV_HANDLE_ARRIV\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_DEV_HANDLE_ARRIV\n");
 		/*This is for target*/
 		break;
 	case OPC_OUB_SSP_RECV_EVENT:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SSP_RECV_EVENT\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SSP_RECV_EVENT\n");
 		/*This is for target*/
 		break;
 	case OPC_OUB_DEV_INFO:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_DEV_INFO\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_DEV_INFO\n");
 		break;
 	case OPC_OUB_FW_FLASH_UPDATE:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_FW_FLASH_UPDATE\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_FW_FLASH_UPDATE\n");
 		pm8001_mpi_fw_flash_update_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_GPIO_RESPONSE:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_GPIO_RESPONSE\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_GPIO_RESPONSE\n");
 		break;
 	case OPC_OUB_GPIO_EVENT:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_GPIO_EVENT\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_GPIO_EVENT\n");
 		break;
 	case OPC_OUB_GENERAL_EVENT:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_GENERAL_EVENT\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_GENERAL_EVENT\n");
 		pm8001_mpi_general_event(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SSP_ABORT_RSP:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SSP_ABORT_RSP\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SSP_ABORT_RSP\n");
 		pm8001_mpi_task_abort_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SATA_ABORT_RSP:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SATA_ABORT_RSP\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SATA_ABORT_RSP\n");
 		pm8001_mpi_task_abort_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SAS_DIAG_MODE_START_END:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SAS_DIAG_MODE_START_END\n"));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "OPC_OUB_SAS_DIAG_MODE_START_END\n");
 		break;
 	case OPC_OUB_SAS_DIAG_EXECUTE:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SAS_DIAG_EXECUTE\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SAS_DIAG_EXECUTE\n");
 		break;
 	case OPC_OUB_GET_TIME_STAMP:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_GET_TIME_STAMP\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_GET_TIME_STAMP\n");
 		break;
 	case OPC_OUB_SAS_HW_EVENT_ACK:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SAS_HW_EVENT_ACK\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SAS_HW_EVENT_ACK\n");
 		break;
 	case OPC_OUB_PORT_CONTROL:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_PORT_CONTROL\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_PORT_CONTROL\n");
 		break;
 	case OPC_OUB_SMP_ABORT_RSP:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SMP_ABORT_RSP\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SMP_ABORT_RSP\n");
 		pm8001_mpi_task_abort_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_GET_NVMD_DATA:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_GET_NVMD_DATA\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_GET_NVMD_DATA\n");
 		pm8001_mpi_get_nvmd_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SET_NVMD_DATA:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SET_NVMD_DATA\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SET_NVMD_DATA\n");
 		pm8001_mpi_set_nvmd_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_DEVICE_HANDLE_REMOVAL:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_DEVICE_HANDLE_REMOVAL\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_DEVICE_HANDLE_REMOVAL\n");
 		break;
 	case OPC_OUB_SET_DEVICE_STATE:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SET_DEVICE_STATE\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SET_DEVICE_STATE\n");
 		pm8001_mpi_set_dev_state_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_GET_DEVICE_STATE:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_GET_DEVICE_STATE\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_GET_DEVICE_STATE\n");
 		break;
 	case OPC_OUB_SET_DEV_INFO:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SET_DEV_INFO\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SET_DEV_INFO\n");
 		break;
 	case OPC_OUB_SAS_RE_INITIALIZE:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SAS_RE_INITIALIZE\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SAS_RE_INITIALIZE\n");
 		break;
 	default:
-		PM8001_DEVIO_DBG(pm8001_ha,
-			pm8001_printk("Unknown outbound Queue IOMB OPC = %x\n",
-			opc));
+		pm8001_dbg(pm8001_ha, DEVIO,
+			   "Unknown outbound Queue IOMB OPC = %x\n",
+			   opc);
 		break;
 	}
 }
@@ -4466,19 +4220,19 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 	if (task->data_dir == DMA_NONE) {
 		ATAP = 0x04;  /* no data*/
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk("no data\n"));
+		pm8001_dbg(pm8001_ha, IO, "no data\n");
 	} else if (likely(!task->ata_task.device_control_reg_update)) {
 		if (task->ata_task.dma_xfer) {
 			ATAP = 0x06; /* DMA */
-			PM8001_IO_DBG(pm8001_ha, pm8001_printk("DMA\n"));
+			pm8001_dbg(pm8001_ha, IO, "DMA\n");
 		} else {
 			ATAP = 0x05; /* PIO*/
-			PM8001_IO_DBG(pm8001_ha, pm8001_printk("PIO\n"));
+			pm8001_dbg(pm8001_ha, IO, "PIO\n");
 		}
 		if (task->ata_task.use_ncq &&
 			dev->sata_dev.class != ATA_DEV_ATAPI) {
 			ATAP = 0x07; /* FPDMA */
-			PM8001_IO_DBG(pm8001_ha, pm8001_printk("FPDMA\n"));
+			pm8001_dbg(pm8001_ha, IO, "FPDMA\n");
 		}
 	}
 	if (task->ata_task.use_ncq && pm8001_get_ncq_tag(task, &hdr_tag)) {
@@ -4535,10 +4289,10 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 					SAS_TASK_STATE_ABORTED))) {
 				spin_unlock_irqrestore(&task->task_state_lock,
 							flags);
-				PM8001_FAIL_DBG(pm8001_ha,
-					pm8001_printk("task 0x%p resp 0x%x "
-					" stat 0x%x but aborted by upper layer "
-					"\n", task, ts->resp, ts->stat));
+				pm8001_dbg(pm8001_ha, FAIL,
+					   "task 0x%p resp 0x%x  stat 0x%x but aborted by upper layer\n",
+					   task, ts->resp,
+					   ts->stat);
 				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
 			} else {
 				spin_unlock_irqrestore(&task->task_state_lock,
@@ -4687,8 +4441,8 @@ int pm8001_chip_dereg_dev_req(struct pm8001_hba_info *pm8001_ha,
 	memset(&payload, 0, sizeof(payload));
 	payload.tag = cpu_to_le32(1);
 	payload.device_id = cpu_to_le32(device_id);
-	PM8001_MSG_DBG(pm8001_ha,
-		pm8001_printk("unregister device device_id = %d\n", device_id));
+	pm8001_dbg(pm8001_ha, MSG, "unregister device device_id = %d\n",
+		   device_id);
 	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
 			sizeof(payload), 0);
 	return ret;
@@ -4740,9 +4494,9 @@ static irqreturn_t
 pm8001_chip_isr(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
 	pm8001_chip_interrupt_disable(pm8001_ha, vec);
-	PM8001_DEVIO_DBG(pm8001_ha, pm8001_printk(
-		"irq vec %d, ODMR:0x%x\n",
-		vec, pm8001_cr32(pm8001_ha, 0, 0x30)));
+	pm8001_dbg(pm8001_ha, DEVIO,
+		   "irq vec %d, ODMR:0x%x\n",
+		   vec, pm8001_cr32(pm8001_ha, 0, 0x30));
 	process_oq(pm8001_ha, vec);
 	pm8001_chip_interrupt_enable(pm8001_ha, vec);
 	return IRQ_HANDLED;
@@ -4779,9 +4533,8 @@ int pm8001_chip_abort_task(struct pm8001_hba_info *pm8001_ha,
 {
 	u32 opc, device_id;
 	int rc = TMF_RESP_FUNC_FAILED;
-	PM8001_EH_DBG(pm8001_ha,
-		pm8001_printk("cmd_tag = %x, abort task tag = 0x%x",
-			cmd_tag, task_tag));
+	pm8001_dbg(pm8001_ha, EH, "cmd_tag = %x, abort task tag = 0x%x\n",
+		   cmd_tag, task_tag);
 	if (pm8001_dev->dev_type == SAS_END_DEVICE)
 		opc = OPC_INB_SSP_ABORT;
 	else if (pm8001_dev->dev_type == SAS_SATA_DEV)
@@ -4792,7 +4545,7 @@ int pm8001_chip_abort_task(struct pm8001_hba_info *pm8001_ha,
 	rc = send_task_abort(pm8001_ha, opc, device_id, flag,
 		task_tag, cmd_tag);
 	if (rc != TMF_RESP_FUNC_COMPLETE)
-		PM8001_EH_DBG(pm8001_ha, pm8001_printk("rc= %d\n", rc));
+		pm8001_dbg(pm8001_ha, EH, "rc= %d\n", rc);
 	return rc;
 }
 
@@ -5058,8 +4811,9 @@ pm8001_chip_fw_flash_update_req(struct pm8001_hba_info *pm8001_ha,
 	if (!fw_control_context)
 		return -ENOMEM;
 	fw_control = (struct fw_control_info *)&ioctl_payload->func_specific;
-	PM8001_DEVIO_DBG(pm8001_ha, pm8001_printk(
-		"dma fw_control context input length :%x\n", fw_control->len));
+	pm8001_dbg(pm8001_ha, DEVIO,
+		   "dma fw_control context input length :%x\n",
+		   fw_control->len);
 	memcpy(buffer, fw_control->buffer, fw_control->len);
 	flash_update_info.sgl.addr = cpu_to_le64(phys_addr);
 	flash_update_info.sgl.im_len.len = cpu_to_le32(fw_control->len);
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 89397e5351ff..7657d68e12d5 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -271,15 +271,14 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 
 	spin_lock_init(&pm8001_ha->lock);
 	spin_lock_init(&pm8001_ha->bitmap_lock);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("pm8001_alloc: PHY:%x\n",
-				pm8001_ha->chip->n_phy));
+	pm8001_dbg(pm8001_ha, INIT, "pm8001_alloc: PHY:%x\n",
+		   pm8001_ha->chip->n_phy);
 
 	/* Setup Interrupt */
 	rc = pm8001_setup_irq(pm8001_ha);
 	if (rc) {
-		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
-				"pm8001_setup_irq failed [ret: %d]\n", rc));
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "pm8001_setup_irq failed [ret: %d]\n", rc);
 		goto err_out_shost;
 	}
 	/* Request Interrupt */
@@ -394,9 +393,9 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 			&pm8001_ha->memoryMap.region[i].phys_addr_lo,
 			pm8001_ha->memoryMap.region[i].total_len,
 			pm8001_ha->memoryMap.region[i].alignment) != 0) {
-				PM8001_FAIL_DBG(pm8001_ha,
-					pm8001_printk("Mem%d alloc failed\n",
-					i));
+			pm8001_dbg(pm8001_ha, FAIL,
+				   "Mem%d alloc failed\n",
+				   i);
 				goto err_out;
 		}
 	}
@@ -467,15 +466,15 @@ static int pm8001_ioremap(struct pm8001_hba_info *pm8001_ha)
 			pm8001_ha->io_mem[logicalBar].memvirtaddr =
 				ioremap(pm8001_ha->io_mem[logicalBar].membase,
 				pm8001_ha->io_mem[logicalBar].memsize);
-			PM8001_INIT_DBG(pm8001_ha,
-				pm8001_printk("PCI: bar %d, logicalBar %d ",
-				bar, logicalBar));
-			PM8001_INIT_DBG(pm8001_ha, pm8001_printk(
-				"base addr %llx virt_addr=%llx len=%d\n",
-				(u64)pm8001_ha->io_mem[logicalBar].membase,
-				(u64)(unsigned long)
-				pm8001_ha->io_mem[logicalBar].memvirtaddr,
-				pm8001_ha->io_mem[logicalBar].memsize));
+			pm8001_dbg(pm8001_ha, INIT,
+				   "PCI: bar %d, logicalBar %d\n",
+				   bar, logicalBar);
+			pm8001_dbg(pm8001_ha, INIT,
+				   "base addr %llx virt_addr=%llx len=%d\n",
+				   (u64)pm8001_ha->io_mem[logicalBar].membase,
+				   (u64)(unsigned long)
+				   pm8001_ha->io_mem[logicalBar].memvirtaddr,
+				   pm8001_ha->io_mem[logicalBar].memsize);
 		} else {
 			pm8001_ha->io_mem[logicalBar].membase	= 0;
 			pm8001_ha->io_mem[logicalBar].memsize	= 0;
@@ -520,8 +519,8 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
 	else {
 		pm8001_ha->link_rate = LINKRATE_15 | LINKRATE_30 |
 			LINKRATE_60 | LINKRATE_120;
-		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
-			"Setting link rate to default value\n"));
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "Setting link rate to default value\n");
 	}
 	sprintf(pm8001_ha->name, "%s%d", DRV_NAME, pm8001_ha->id);
 	/* IOMB size is 128 for 8088/89 controllers */
@@ -684,13 +683,13 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
 	payload.offset = 0;
 	payload.func_specific = kzalloc(payload.rd_length, GFP_KERNEL);
 	if (!payload.func_specific) {
-		PM8001_INIT_DBG(pm8001_ha, pm8001_printk("mem alloc fail\n"));
+		pm8001_dbg(pm8001_ha, INIT, "mem alloc fail\n");
 		return;
 	}
 	rc = PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha, &payload);
 	if (rc) {
 		kfree(payload.func_specific);
-		PM8001_INIT_DBG(pm8001_ha, pm8001_printk("nvmd failed\n"));
+		pm8001_dbg(pm8001_ha, INIT, "nvmd failed\n");
 		return;
 	}
 	wait_for_completion(&completion);
@@ -718,9 +717,8 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
 			sas_add[7] = sas_add[7] + 4;
 		memcpy(&pm8001_ha->phy[i].dev_sas_addr,
 			sas_add, SAS_ADDR_SIZE);
-		PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("phy %d sas_addr = %016llx\n", i,
-			pm8001_ha->phy[i].dev_sas_addr));
+		pm8001_dbg(pm8001_ha, INIT, "phy %d sas_addr = %016llx\n", i,
+			   pm8001_ha->phy[i].dev_sas_addr);
 	}
 	kfree(payload.func_specific);
 #else
@@ -760,7 +758,7 @@ static int pm8001_get_phy_settings_info(struct pm8001_hba_info *pm8001_ha)
 	rc = PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha, &payload);
 	if (rc) {
 		kfree(payload.func_specific);
-		PM8001_INIT_DBG(pm8001_ha, pm8001_printk("nvmd failed\n"));
+		pm8001_dbg(pm8001_ha, INIT, "nvmd failed\n");
 		return -ENOMEM;
 	}
 	wait_for_completion(&completion);
@@ -854,9 +852,9 @@ void pm8001_get_phy_mask(struct pm8001_hba_info *pm8001_ha, int *phymask)
 		break;
 
 	default:
-		PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("Unknown subsystem device=0x%.04x",
-				pm8001_ha->pdev->subsystem_device));
+		pm8001_dbg(pm8001_ha, INIT,
+			   "Unknown subsystem device=0x%.04x\n",
+			   pm8001_ha->pdev->subsystem_device);
 	}
 }
 
@@ -950,9 +948,9 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
 	/* Maximum queue number updating in HBA structure */
 	pm8001_ha->max_q_num = number_of_intr;
 
-	PM8001_INIT_DBG(pm8001_ha, pm8001_printk(
-		"pci_alloc_irq_vectors request ret:%d no of intr %d\n",
-				rc, pm8001_ha->number_of_intr));
+	pm8001_dbg(pm8001_ha, INIT,
+		   "pci_alloc_irq_vectors request ret:%d no of intr %d\n",
+		   rc, pm8001_ha->number_of_intr);
 	return 0;
 }
 
@@ -964,9 +962,9 @@ static u32 pm8001_request_msix(struct pm8001_hba_info *pm8001_ha)
 	if (pm8001_ha->chip_id != chip_8001)
 		flag &= ~IRQF_SHARED;
 
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("pci_enable_msix request number of intr %d\n",
-		pm8001_ha->number_of_intr));
+	pm8001_dbg(pm8001_ha, INIT,
+		   "pci_enable_msix request number of intr %d\n",
+		   pm8001_ha->number_of_intr);
 
 	for (i = 0; i < pm8001_ha->number_of_intr; i++) {
 		snprintf(pm8001_ha->intr_drvname[i],
@@ -1002,8 +1000,7 @@ static u32 pm8001_setup_irq(struct pm8001_hba_info *pm8001_ha)
 #ifdef PM8001_USE_MSIX
 	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX))
 		return pm8001_setup_msix(pm8001_ha);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("MSIX not supported!!!\n"));
+	pm8001_dbg(pm8001_ha, INIT, "MSIX not supported!!!\n");
 #endif
 	return 0;
 }
@@ -1023,8 +1020,7 @@ static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha)
 	if (pdev->msix_cap && pci_msi_enabled())
 		return pm8001_request_msix(pm8001_ha);
 	else {
-		PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("MSIX not supported!!!\n"));
+		pm8001_dbg(pm8001_ha, INIT, "MSIX not supported!!!\n");
 		goto intx;
 	}
 #endif
@@ -1108,8 +1104,8 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
 	rc = PM8001_CHIP_DISP->chip_init(pm8001_ha);
 	if (rc) {
-		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
-			"chip_init failed [ret: %d]\n", rc));
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "chip_init failed [ret: %d]\n", rc);
 		goto err_out_ha_free;
 	}
 
@@ -1138,8 +1134,8 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 	pm8001_post_sas_ha_init(shost, chip);
 	rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
 	if (rc) {
-		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
-			"sas_register_ha failed [ret: %d]\n", rc));
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "sas_register_ha failed [ret: %d]\n", rc);
 		goto err_out_shost;
 	}
 	list_add_tail(&pm8001_ha->list, &hba_list);
@@ -1191,8 +1187,8 @@ pm8001_init_ccb_tag(struct pm8001_hba_info *pm8001_ha, struct Scsi_Host *shost,
 	pm8001_ha->ccb_info = (struct pm8001_ccb_info *)
 		kcalloc(ccb_count, sizeof(struct pm8001_ccb_info), GFP_KERNEL);
 	if (!pm8001_ha->ccb_info) {
-		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk
-			("Unable to allocate memory for ccb\n"));
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "Unable to allocate memory for ccb\n");
 		goto err_out_noccb;
 	}
 	for (i = 0; i < ccb_count; i++) {
@@ -1200,8 +1196,8 @@ pm8001_init_ccb_tag(struct pm8001_hba_info *pm8001_ha, struct Scsi_Host *shost,
 				sizeof(struct pm8001_prd) * PM8001_MAX_DMA_SG,
 				&pm8001_ha->ccb_info[i].ccb_dma_handle);
 		if (!pm8001_ha->ccb_info[i].buf_prd) {
-			PM8001_FAIL_DBG(pm8001_ha, pm8001_printk
-					("pm80xx: ccb prd memory allocation error\n"));
+			pm8001_dbg(pm8001_ha, FAIL,
+				   "pm80xx: ccb prd memory allocation error\n");
 			goto err_out;
 		}
 		pm8001_ha->ccb_info[i].task = NULL;
@@ -1345,8 +1341,7 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 	/* chip soft rst only for spc */
 	if (pm8001_ha->chip_id == chip_8001) {
 		PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
-		PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("chip soft reset successful\n"));
+		pm8001_dbg(pm8001_ha, INIT, "chip soft reset successful\n");
 	}
 	rc = PM8001_CHIP_DISP->chip_init(pm8001_ha);
 	if (rc)
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index d6e0bc588698..7a6d34267585 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -250,8 +250,7 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 		return 0;
 	default:
-		PM8001_DEVIO_DBG(pm8001_ha,
-			pm8001_printk("func 0x%x\n", func));
+		pm8001_dbg(pm8001_ha, DEVIO, "func 0x%x\n", func);
 		rc = -EOPNOTSUPP;
 	}
 	msleep(300);
@@ -405,7 +404,7 @@ static int pm8001_task_exec(struct sas_task *task,
 		t->task_done(t);
 		return 0;
 	}
-	PM8001_IO_DBG(pm8001_ha, pm8001_printk("pm8001_task_exec device \n "));
+	pm8001_dbg(pm8001_ha, IO, "pm8001_task_exec device\n");
 	spin_lock_irqsave(&pm8001_ha->lock, flags);
 	do {
 		dev = t->dev;
@@ -480,8 +479,7 @@ static int pm8001_task_exec(struct sas_task *task,
 		}
 
 		if (rc) {
-			PM8001_IO_DBG(pm8001_ha,
-				pm8001_printk("rc is %x\n", rc));
+			pm8001_dbg(pm8001_ha, IO, "rc is %x\n", rc);
 			atomic_dec(&pm8001_dev->running_req);
 			goto err_out_tag;
 		}
@@ -570,9 +568,9 @@ static struct pm8001_device *pm8001_alloc_dev(struct pm8001_hba_info *pm8001_ha)
 		}
 	}
 	if (dev == PM8001_MAX_DEVICES) {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("max support %d devices, ignore ..\n",
-			PM8001_MAX_DEVICES));
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "max support %d devices, ignore ..\n",
+			   PM8001_MAX_DEVICES);
 	}
 	return NULL;
 }
@@ -590,8 +588,7 @@ struct pm8001_device *pm8001_find_dev(struct pm8001_hba_info *pm8001_ha,
 			return &pm8001_ha->devices[dev];
 	}
 	if (dev == PM8001_MAX_DEVICES) {
-		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("NO MATCHING "
-				"DEVICE FOUND !!!\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "NO MATCHING DEVICE FOUND !!!\n");
 	}
 	return NULL;
 }
@@ -652,10 +649,10 @@ static int pm8001_dev_found_notify(struct domain_device *dev)
 			}
 		}
 		if (phy_id == parent_dev->ex_dev.num_phys) {
-			PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("Error: no attached dev:%016llx"
-			" at ex:%016llx.\n", SAS_ADDR(dev->sas_addr),
-				SAS_ADDR(parent_dev->sas_addr)));
+			pm8001_dbg(pm8001_ha, FAIL,
+				   "Error: no attached dev:%016llx at ex:%016llx.\n",
+				   SAS_ADDR(dev->sas_addr),
+				   SAS_ADDR(parent_dev->sas_addr));
 			res = -1;
 		}
 	} else {
@@ -665,7 +662,7 @@ static int pm8001_dev_found_notify(struct domain_device *dev)
 			flag = 1; /* directly sata */
 		}
 	} /*register this device to HBA*/
-	PM8001_DISC_DBG(pm8001_ha, pm8001_printk("Found device\n"));
+	pm8001_dbg(pm8001_ha, DISC, "Found device\n");
 	PM8001_CHIP_DISP->reg_dev_req(pm8001_ha, pm8001_device, flag);
 	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 	wait_for_completion(&completion);
@@ -737,9 +734,7 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
 
 		if (res) {
 			del_timer(&task->slow_task->timer);
-			PM8001_FAIL_DBG(pm8001_ha,
-				pm8001_printk("Executing internal task "
-				"failed\n"));
+			pm8001_dbg(pm8001_ha, FAIL, "Executing internal task failed\n");
 			goto ex_err;
 		}
 		wait_for_completion(&task->slow_task->completion);
@@ -753,9 +748,9 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
 		/* Even TMF timed out, return direct. */
 		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
 			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
-				PM8001_FAIL_DBG(pm8001_ha,
-					pm8001_printk("TMF task[%x]timeout.\n",
-					tmf->tmf));
+				pm8001_dbg(pm8001_ha, FAIL,
+					   "TMF task[%x]timeout.\n",
+					   tmf->tmf);
 				goto ex_err;
 			}
 		}
@@ -776,17 +771,15 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
 
 		if (task->task_status.resp == SAS_TASK_COMPLETE &&
 			task->task_status.stat == SAS_DATA_OVERRUN) {
-			PM8001_FAIL_DBG(pm8001_ha,
-				pm8001_printk("Blocked task error.\n"));
+			pm8001_dbg(pm8001_ha, FAIL, "Blocked task error.\n");
 			res = -EMSGSIZE;
 			break;
 		} else {
-			PM8001_EH_DBG(pm8001_ha,
-				pm8001_printk(" Task to dev %016llx response:"
-				"0x%x status 0x%x\n",
-				SAS_ADDR(dev->sas_addr),
-				task->task_status.resp,
-				task->task_status.stat));
+			pm8001_dbg(pm8001_ha, EH,
+				   " Task to dev %016llx response:0x%x status 0x%x\n",
+				   SAS_ADDR(dev->sas_addr),
+				   task->task_status.resp,
+				   task->task_status.stat);
 			sas_free_task(task);
 			task = NULL;
 		}
@@ -833,9 +826,7 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 
 		if (res) {
 			del_timer(&task->slow_task->timer);
-			PM8001_FAIL_DBG(pm8001_ha,
-				pm8001_printk("Executing internal task "
-				"failed\n"));
+			pm8001_dbg(pm8001_ha, FAIL, "Executing internal task failed\n");
 			goto ex_err;
 		}
 		wait_for_completion(&task->slow_task->completion);
@@ -843,8 +834,8 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 		/* Even TMF timed out, return direct. */
 		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
 			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
-				PM8001_FAIL_DBG(pm8001_ha,
-					pm8001_printk("TMF task timeout.\n"));
+				pm8001_dbg(pm8001_ha, FAIL,
+					   "TMF task timeout.\n");
 				goto ex_err;
 			}
 		}
@@ -855,12 +846,11 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 			break;
 
 		} else {
-			PM8001_EH_DBG(pm8001_ha,
-				pm8001_printk(" Task to dev %016llx response: "
-					"0x%x status 0x%x\n",
-				SAS_ADDR(dev->sas_addr),
-				task->task_status.resp,
-				task->task_status.stat));
+			pm8001_dbg(pm8001_ha, EH,
+				   " Task to dev %016llx response: 0x%x status 0x%x\n",
+				   SAS_ADDR(dev->sas_addr),
+				   task->task_status.resp,
+				   task->task_status.stat);
 			sas_free_task(task);
 			task = NULL;
 		}
@@ -886,9 +876,8 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 	if (pm8001_dev) {
 		u32 device_id = pm8001_dev->device_id;
 
-		PM8001_DISC_DBG(pm8001_ha,
-			pm8001_printk("found dev[%d:%x] is gone.\n",
-			pm8001_dev->device_id, pm8001_dev->dev_type));
+		pm8001_dbg(pm8001_ha, DISC, "found dev[%d:%x] is gone.\n",
+			   pm8001_dev->device_id, pm8001_dev->dev_type);
 		if (atomic_read(&pm8001_dev->running_req)) {
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 			pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
@@ -900,8 +889,7 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 		PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);
 		pm8001_free_dev(pm8001_dev);
 	} else {
-		PM8001_DISC_DBG(pm8001_ha,
-			pm8001_printk("Found dev has gone.\n"));
+		pm8001_dbg(pm8001_ha, DISC, "Found dev has gone.\n");
 	}
 	dev->lldd_dev = NULL;
 	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
@@ -1021,9 +1009,9 @@ int pm8001_I_T_nexus_reset(struct domain_device *dev)
 		}
 		rc = sas_phy_reset(phy, 1);
 		if (rc) {
-			PM8001_EH_DBG(pm8001_ha,
-			pm8001_printk("phy reset failed for device %x\n"
-			"with rc %d\n", pm8001_dev->device_id, rc));
+			pm8001_dbg(pm8001_ha, EH,
+				   "phy reset failed for device %x\n"
+				   "with rc %d\n", pm8001_dev->device_id, rc);
 			rc = TMF_RESP_FUNC_FAILED;
 			goto out;
 		}
@@ -1031,17 +1019,16 @@ int pm8001_I_T_nexus_reset(struct domain_device *dev)
 		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
 			dev, 1, 0);
 		if (rc) {
-			PM8001_EH_DBG(pm8001_ha,
-			pm8001_printk("task abort failed %x\n"
-			"with rc %d\n", pm8001_dev->device_id, rc));
+			pm8001_dbg(pm8001_ha, EH, "task abort failed %x\n"
+				   "with rc %d\n", pm8001_dev->device_id, rc);
 			rc = TMF_RESP_FUNC_FAILED;
 		}
 	} else {
 		rc = sas_phy_reset(phy, 1);
 		msleep(2000);
 	}
-	PM8001_EH_DBG(pm8001_ha, pm8001_printk(" for device[%x]:rc=%d\n",
-		pm8001_dev->device_id, rc));
+	pm8001_dbg(pm8001_ha, EH, " for device[%x]:rc=%d\n",
+		   pm8001_dev->device_id, rc);
  out:
 	sas_put_local_phy(phy);
 	return rc;
@@ -1064,8 +1051,7 @@ int pm8001_I_T_nexus_event_handler(struct domain_device *dev)
 	pm8001_dev = dev->lldd_dev;
 	pm8001_ha = pm8001_find_ha_by_dev(dev);
 
-	PM8001_EH_DBG(pm8001_ha,
-			pm8001_printk("I_T_Nexus handler invoked !!"));
+	pm8001_dbg(pm8001_ha, EH, "I_T_Nexus handler invoked !!\n");
 
 	phy = sas_get_local_phy(dev);
 
@@ -1104,8 +1090,8 @@ int pm8001_I_T_nexus_event_handler(struct domain_device *dev)
 		rc = sas_phy_reset(phy, 1);
 		msleep(2000);
 	}
-	PM8001_EH_DBG(pm8001_ha, pm8001_printk(" for device[%x]:rc=%d\n",
-		pm8001_dev->device_id, rc));
+	pm8001_dbg(pm8001_ha, EH, " for device[%x]:rc=%d\n",
+		   pm8001_dev->device_id, rc);
 out:
 	sas_put_local_phy(phy);
 
@@ -1134,8 +1120,8 @@ int pm8001_lu_reset(struct domain_device *dev, u8 *lun)
 		rc = pm8001_issue_ssp_tmf(dev, lun, &tmf_task);
 	}
 	/* If failed, fall-through I_T_Nexus reset */
-	PM8001_EH_DBG(pm8001_ha, pm8001_printk("for device[%x]:rc=%d\n",
-		pm8001_dev->device_id, rc));
+	pm8001_dbg(pm8001_ha, EH, "for device[%x]:rc=%d\n",
+		   pm8001_dev->device_id, rc);
 	return rc;
 }
 
@@ -1143,7 +1129,6 @@ int pm8001_lu_reset(struct domain_device *dev, u8 *lun)
 int pm8001_query_task(struct sas_task *task)
 {
 	u32 tag = 0xdeadbeef;
-	int i = 0;
 	struct scsi_lun lun;
 	struct pm8001_tmf_task tmf_task;
 	int rc = TMF_RESP_FUNC_FAILED;
@@ -1162,10 +1147,7 @@ int pm8001_query_task(struct sas_task *task)
 			rc = TMF_RESP_FUNC_FAILED;
 			return rc;
 		}
-		PM8001_EH_DBG(pm8001_ha, pm8001_printk("Query:["));
-		for (i = 0; i < 16; i++)
-			printk(KERN_INFO "%02x ", cmnd->cmnd[i]);
-		printk(KERN_INFO "]\n");
+		pm8001_dbg(pm8001_ha, EH, "Query:[%16ph]\n", cmnd->cmnd);
 		tmf_task.tmf = 	TMF_QUERY_TASK;
 		tmf_task.tag_of_task_to_be_managed = tag;
 
@@ -1173,15 +1155,14 @@ int pm8001_query_task(struct sas_task *task)
 		switch (rc) {
 		/* The task is still in Lun, release it then */
 		case TMF_RESP_FUNC_SUCC:
-			PM8001_EH_DBG(pm8001_ha,
-				pm8001_printk("The task is still in Lun\n"));
+			pm8001_dbg(pm8001_ha, EH,
+				   "The task is still in Lun\n");
 			break;
 		/* The task is not in Lun or failed, reset the phy */
 		case TMF_RESP_FUNC_FAILED:
 		case TMF_RESP_FUNC_COMPLETE:
-			PM8001_EH_DBG(pm8001_ha,
-			pm8001_printk("The task is not in Lun or failed,"
-			" reset the phy\n"));
+			pm8001_dbg(pm8001_ha, EH,
+				   "The task is not in Lun or failed, reset the phy\n");
 			break;
 		}
 	}
@@ -1267,8 +1248,8 @@ int pm8001_abort_task(struct sas_task *task)
 			 * leaking the task in libsas or losing the race and
 			 * getting a double free.
 			 */
-			PM8001_MSG_DBG(pm8001_ha,
-				pm8001_printk("Waiting for local phy ctl\n"));
+			pm8001_dbg(pm8001_ha, MSG,
+				   "Waiting for local phy ctl\n");
 			ret = wait_for_completion_timeout(&completion,
 					PM8001_TASK_TIMEOUT * HZ);
 			if (!ret || !phy->reset_success) {
@@ -1278,8 +1259,8 @@ int pm8001_abort_task(struct sas_task *task)
 				/* 3. Wait for Port Reset complete or
 				 * Port reset TMO
 				 */
-				PM8001_MSG_DBG(pm8001_ha,
-				pm8001_printk("Waiting for Port reset\n"));
+				pm8001_dbg(pm8001_ha, MSG,
+					   "Waiting for Port reset\n");
 				ret = wait_for_completion_timeout(
 					&completion_reset,
 					PM8001_TASK_TIMEOUT * HZ);
@@ -1358,9 +1339,8 @@ int pm8001_clear_task_set(struct domain_device *dev, u8 *lun)
 	struct pm8001_device *pm8001_dev = dev->lldd_dev;
 	struct pm8001_hba_info *pm8001_ha = pm8001_find_ha_by_dev(dev);
 
-	PM8001_EH_DBG(pm8001_ha,
-		pm8001_printk("I_T_L_Q clear task set[%x]\n",
-		pm8001_dev->device_id));
+	pm8001_dbg(pm8001_ha, EH, "I_T_L_Q clear task set[%x]\n",
+		   pm8001_dev->device_id);
 	tmf_task.tmf = TMF_CLEAR_TASK_SET;
 	return pm8001_issue_ssp_tmf(dev, lun, &tmf_task);
 }
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 091574721ea1..5cd6fe6a7d2d 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -69,45 +69,16 @@
 #define PM8001_DEV_LOGGING	0x80 /* development message logging */
 #define PM8001_DEVIO_LOGGING	0x100 /* development io message logging */
 #define PM8001_IOERR_LOGGING	0x200 /* development io err message logging */
-#define pm8001_printk(format, arg...)	pr_info("%s:: %s  %d:" \
-			format, pm8001_ha->name, __func__, __LINE__, ## arg)
-#define PM8001_CHECK_LOGGING(HBA, LEVEL, CMD)	\
-do {						\
-	if (unlikely(HBA->logging_level & LEVEL))	\
-		do {					\
-			CMD;				\
-		} while (0);				\
-} while (0);
 
-#define PM8001_EH_DBG(HBA, CMD)			\
-	PM8001_CHECK_LOGGING(HBA, PM8001_EH_LOGGING, CMD)
+#define pm8001_printk(fmt, ...)						\
+	pr_info("%s:: %s  %d:" fmt,					\
+		pm8001_ha->name, __func__, __LINE__, ##__VA_ARGS__)
 
-#define PM8001_INIT_DBG(HBA, CMD)		\
-	PM8001_CHECK_LOGGING(HBA, PM8001_INIT_LOGGING, CMD)
-
-#define PM8001_DISC_DBG(HBA, CMD)		\
-	PM8001_CHECK_LOGGING(HBA, PM8001_DISC_LOGGING, CMD)
-
-#define PM8001_IO_DBG(HBA, CMD)		\
-	PM8001_CHECK_LOGGING(HBA, PM8001_IO_LOGGING, CMD)
-
-#define PM8001_FAIL_DBG(HBA, CMD)		\
-	PM8001_CHECK_LOGGING(HBA, PM8001_FAIL_LOGGING, CMD)
-
-#define PM8001_IOCTL_DBG(HBA, CMD)		\
-	PM8001_CHECK_LOGGING(HBA, PM8001_IOCTL_LOGGING, CMD)
-
-#define PM8001_MSG_DBG(HBA, CMD)		\
-	PM8001_CHECK_LOGGING(HBA, PM8001_MSG_LOGGING, CMD)
-
-#define PM8001_DEV_DBG(HBA, CMD)		\
-	PM8001_CHECK_LOGGING(HBA, PM8001_DEV_LOGGING, CMD)
-
-#define PM8001_DEVIO_DBG(HBA, CMD)		\
-	PM8001_CHECK_LOGGING(HBA, PM8001_DEVIO_LOGGING, CMD)
-
-#define PM8001_IOERR_DBG(HBA, CMD)		\
-	PM8001_CHECK_LOGGING(HBA, PM8001_IOERR_LOGGING, CMD)
+#define pm8001_dbg(HBA, level, fmt, ...)				\
+do {									\
+	if (unlikely((HBA)->logging_level & PM8001_##level##_LOGGING))	\
+		pm8001_printk(fmt, ##__VA_ARGS__);			\
+} while (0)
 
 #define PM8001_USE_TASKLET
 #define PM8001_USE_MSIX
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 59053c61908e..990501be47e7 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -58,9 +58,8 @@ int pm80xx_bar4_shift(struct pm8001_hba_info *pm8001_ha, u32 shift_value)
 		reg_val = pm8001_cr32(pm8001_ha, 0, MEMBASE_II_SHIFT_REGISTER);
 	} while ((reg_val != shift_value) && time_before(jiffies, start));
 	if (reg_val != shift_value) {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("TIMEOUT:MEMBASE_II_SHIFT_REGISTER"
-			" = 0x%x\n", reg_val));
+		pm8001_dbg(pm8001_ha, FAIL, "TIMEOUT:MEMBASE_II_SHIFT_REGISTER = 0x%x\n",
+			   reg_val);
 		return -1;
 	}
 	return 0;
@@ -109,8 +108,8 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
 	}
 	/* initialize variables for very first call from host application */
 	if (pm8001_ha->forensic_info.data_buf.direct_offset == 0) {
-		PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk("forensic_info TYPE_NON_FATAL..............\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "forensic_info TYPE_NON_FATAL..............\n");
 		direct_data = (u8 *)fatal_error_data;
 		pm8001_ha->forensic_info.data_type = TYPE_NON_FATAL;
 		pm8001_ha->forensic_info.data_buf.direct_len = SYSFS_OFFSET;
@@ -123,17 +122,13 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
 				MPI_FATAL_EDUMP_TABLE_SIGNATURE, 0x1234abcd);
 
 		pm8001_ha->forensic_info.data_buf.direct_data = direct_data;
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("ossaHwCB: status1 %d\n", status));
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("ossaHwCB: read_len 0x%x\n",
-			pm8001_ha->forensic_info.data_buf.read_len));
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("ossaHwCB: direct_len 0x%x\n",
-			pm8001_ha->forensic_info.data_buf.direct_len));
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("ossaHwCB: direct_offset 0x%x\n",
-			pm8001_ha->forensic_info.data_buf.direct_offset));
+		pm8001_dbg(pm8001_ha, IO, "ossaHwCB: status1 %d\n", status);
+		pm8001_dbg(pm8001_ha, IO, "ossaHwCB: read_len 0x%x\n",
+			   pm8001_ha->forensic_info.data_buf.read_len);
+		pm8001_dbg(pm8001_ha, IO, "ossaHwCB: direct_len 0x%x\n",
+			   pm8001_ha->forensic_info.data_buf.direct_len);
+		pm8001_dbg(pm8001_ha, IO, "ossaHwCB: direct_offset 0x%x\n",
+			   pm8001_ha->forensic_info.data_buf.direct_offset);
 	}
 	if (pm8001_ha->forensic_info.data_buf.direct_offset == 0) {
 		/* start to get data */
@@ -153,29 +148,24 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
 	 */
 	length_to_read =
 		accum_len - pm8001_ha->forensic_preserved_accumulated_transfer;
-	PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk("get_fatal_spcv: accum_len 0x%x\n", accum_len));
-	PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk("get_fatal_spcv: length_to_read 0x%x\n",
-		length_to_read));
-	PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk("get_fatal_spcv: last_offset 0x%x\n",
-		pm8001_ha->forensic_last_offset));
-	PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk("get_fatal_spcv: read_len 0x%x\n",
-		pm8001_ha->forensic_info.data_buf.read_len));
-	PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk("get_fatal_spcv:: direct_len 0x%x\n",
-		pm8001_ha->forensic_info.data_buf.direct_len));
-	PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk("get_fatal_spcv:: direct_offset 0x%x\n",
-		pm8001_ha->forensic_info.data_buf.direct_offset));
+	pm8001_dbg(pm8001_ha, IO, "get_fatal_spcv: accum_len 0x%x\n",
+		   accum_len);
+	pm8001_dbg(pm8001_ha, IO, "get_fatal_spcv: length_to_read 0x%x\n",
+		   length_to_read);
+	pm8001_dbg(pm8001_ha, IO, "get_fatal_spcv: last_offset 0x%x\n",
+		   pm8001_ha->forensic_last_offset);
+	pm8001_dbg(pm8001_ha, IO, "get_fatal_spcv: read_len 0x%x\n",
+		   pm8001_ha->forensic_info.data_buf.read_len);
+	pm8001_dbg(pm8001_ha, IO, "get_fatal_spcv:: direct_len 0x%x\n",
+		   pm8001_ha->forensic_info.data_buf.direct_len);
+	pm8001_dbg(pm8001_ha, IO, "get_fatal_spcv:: direct_offset 0x%x\n",
+		   pm8001_ha->forensic_info.data_buf.direct_offset);
 
 	/* If accumulated length failed to read correctly fail the attempt.*/
 	if (accum_len == 0xFFFFFFFF) {
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("Possible PCI issue 0x%x not expected\n",
-			accum_len));
+		pm8001_dbg(pm8001_ha, IO,
+			   "Possible PCI issue 0x%x not expected\n",
+			   accum_len);
 		return status;
 	}
 	/* If accumulated length is zero fail the attempt */
@@ -239,8 +229,8 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
 			offset = (int)
 			((char *)pm8001_ha->forensic_info.data_buf.direct_data
 			- (char *)buf);
-			PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("get_fatal_spcv:return1 0x%x\n", offset));
+			pm8001_dbg(pm8001_ha, IO,
+				   "get_fatal_spcv:return1 0x%x\n", offset);
 			return (char *)pm8001_ha->
 				forensic_info.data_buf.direct_data -
 				(char *)buf;
@@ -262,8 +252,8 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
 			offset = (int)
 			((char *)pm8001_ha->forensic_info.data_buf.direct_data
 			- (char *)buf);
-			PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("get_fatal_spcv:return2 0x%x\n", offset));
+			pm8001_dbg(pm8001_ha, IO,
+				   "get_fatal_spcv:return2 0x%x\n", offset);
 			return (char *)pm8001_ha->
 				forensic_info.data_buf.direct_data -
 				(char *)buf;
@@ -289,8 +279,8 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
 		offset = (int)
 			((char *)pm8001_ha->forensic_info.data_buf.direct_data
 			- (char *)buf);
-		PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk("get_fatal_spcv: return3 0x%x\n", offset));
+		pm8001_dbg(pm8001_ha, IO, "get_fatal_spcv: return3 0x%x\n",
+			   offset);
 		return (char *)pm8001_ha->forensic_info.data_buf.direct_data -
 			(char *)buf;
 	}
@@ -327,9 +317,9 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
 			} while ((reg_val) && time_before(jiffies, start));
 
 			if (reg_val != 0) {
-				PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
-				"TIMEOUT:MPI_FATAL_EDUMP_TABLE_HDSHAKE 0x%x\n",
-				reg_val));
+				pm8001_dbg(pm8001_ha, FAIL,
+					   "TIMEOUT:MPI_FATAL_EDUMP_TABLE_HDSHAKE 0x%x\n",
+					   reg_val);
 			       /* Fail the dump if a timeout occurs */
 				pm8001_ha->forensic_info.data_buf.direct_data +=
 				sprintf(
@@ -351,9 +341,9 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
 					time_before(jiffies, start));
 
 			if (reg_val < 2) {
-				PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
-				"TIMEOUT:MPI_FATAL_EDUMP_TABLE_STATUS = 0x%x\n",
-				reg_val));
+				pm8001_dbg(pm8001_ha, FAIL,
+					   "TIMEOUT:MPI_FATAL_EDUMP_TABLE_STATUS = 0x%x\n",
+					   reg_val);
 				/* Fail the dump if a timeout occurs */
 				pm8001_ha->forensic_info.data_buf.direct_data +=
 				sprintf(
@@ -387,8 +377,7 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
 	}
 	offset = (int)((char *)pm8001_ha->forensic_info.data_buf.direct_data
 			- (char *)buf);
-	PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk("get_fatal_spcv: return4 0x%x\n", offset));
+	pm8001_dbg(pm8001_ha, IO, "get_fatal_spcv: return4 0x%x\n", offset);
 	return (char *)pm8001_ha->forensic_info.data_buf.direct_data -
 		(char *)buf;
 }
@@ -419,8 +408,7 @@ ssize_t pm80xx_get_non_fatal_dump(struct device *cdev,
 				PAGE_SIZE, "Not supported for SPC controller");
 			return 0;
 		}
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("forensic_info TYPE_NON_FATAL...\n"));
+		pm8001_dbg(pm8001_ha, IO, "forensic_info TYPE_NON_FATAL...\n");
 		/*
 		 * Step 1: Write the host buffer parameters in the MPI Fatal and
 		 * Non-Fatal Error Dump Capture Table.This is the buffer
@@ -581,24 +569,24 @@ static void read_main_config_table(struct pm8001_hba_info *pm8001_ha)
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.inc_fw_version =
 		pm8001_mr32(address, MAIN_MPI_INACTIVE_FW_VERSION);
 
-	PM8001_DEV_DBG(pm8001_ha, pm8001_printk(
-		"Main cfg table: sign:%x interface rev:%x fw_rev:%x\n",
-		pm8001_ha->main_cfg_tbl.pm80xx_tbl.signature,
-		pm8001_ha->main_cfg_tbl.pm80xx_tbl.interface_rev,
-		pm8001_ha->main_cfg_tbl.pm80xx_tbl.firmware_rev));
-
-	PM8001_DEV_DBG(pm8001_ha, pm8001_printk(
-		"table offset: gst:%x iq:%x oq:%x int vec:%x phy attr:%x\n",
-		pm8001_ha->main_cfg_tbl.pm80xx_tbl.gst_offset,
-		pm8001_ha->main_cfg_tbl.pm80xx_tbl.inbound_queue_offset,
-		pm8001_ha->main_cfg_tbl.pm80xx_tbl.outbound_queue_offset,
-		pm8001_ha->main_cfg_tbl.pm80xx_tbl.int_vec_table_offset,
-		pm8001_ha->main_cfg_tbl.pm80xx_tbl.phy_attr_table_offset));
-
-	PM8001_DEV_DBG(pm8001_ha, pm8001_printk(
-		"Main cfg table; ila rev:%x Inactive fw rev:%x\n",
-		pm8001_ha->main_cfg_tbl.pm80xx_tbl.ila_version,
-		pm8001_ha->main_cfg_tbl.pm80xx_tbl.inc_fw_version));
+	pm8001_dbg(pm8001_ha, DEV,
+		   "Main cfg table: sign:%x interface rev:%x fw_rev:%x\n",
+		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.signature,
+		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.interface_rev,
+		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.firmware_rev);
+
+	pm8001_dbg(pm8001_ha, DEV,
+		   "table offset: gst:%x iq:%x oq:%x int vec:%x phy attr:%x\n",
+		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.gst_offset,
+		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.inbound_queue_offset,
+		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.outbound_queue_offset,
+		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.int_vec_table_offset,
+		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.phy_attr_table_offset);
+
+	pm8001_dbg(pm8001_ha, DEV,
+		   "Main cfg table; ila rev:%x Inactive fw rev:%x\n",
+		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.ila_version,
+		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.inc_fw_version);
 }
 
 /**
@@ -808,10 +796,10 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 		pm8001_ha->inbnd_q_tbl[i].producer_idx		= 0;
 		pm8001_ha->inbnd_q_tbl[i].consumer_index	= 0;
 
-		PM8001_DEV_DBG(pm8001_ha, pm8001_printk(
-			"IQ %d pi_bar 0x%x pi_offset 0x%x\n", i,
-			pm8001_ha->inbnd_q_tbl[i].pi_pci_bar,
-			pm8001_ha->inbnd_q_tbl[i].pi_offset));
+		pm8001_dbg(pm8001_ha, DEV,
+			   "IQ %d pi_bar 0x%x pi_offset 0x%x\n", i,
+			   pm8001_ha->inbnd_q_tbl[i].pi_pci_bar,
+			   pm8001_ha->inbnd_q_tbl[i].pi_offset);
 	}
 	for (i = 0; i < pm8001_ha->max_q_num; i++) {
 		pm8001_ha->outbnd_q_tbl[i].element_size_cnt	=
@@ -841,10 +829,10 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 		pm8001_ha->outbnd_q_tbl[i].consumer_idx		= 0;
 		pm8001_ha->outbnd_q_tbl[i].producer_index	= 0;
 
-		PM8001_DEV_DBG(pm8001_ha, pm8001_printk(
-			"OQ %d ci_bar 0x%x ci_offset 0x%x\n", i,
-			pm8001_ha->outbnd_q_tbl[i].ci_pci_bar,
-			pm8001_ha->outbnd_q_tbl[i].ci_offset));
+		pm8001_dbg(pm8001_ha, DEV,
+			   "OQ %d ci_bar 0x%x ci_offset 0x%x\n", i,
+			   pm8001_ha->outbnd_q_tbl[i].ci_pci_bar,
+			   pm8001_ha->outbnd_q_tbl[i].ci_offset);
 	}
 }
 
@@ -878,9 +866,9 @@ static void update_main_config_table(struct pm8001_hba_info *pm8001_ha)
 					((pm8001_ha->max_q_num - 1) << 8);
 	pm8001_mw32(address, MAIN_FATAL_ERROR_INTERRUPT,
 		pm8001_ha->main_cfg_tbl.pm80xx_tbl.fatal_err_interrupt);
-	PM8001_DEV_DBG(pm8001_ha, pm8001_printk(
-		"Updated Fatal error interrupt vector 0x%x\n",
-		pm8001_mr32(address, MAIN_FATAL_ERROR_INTERRUPT)));
+	pm8001_dbg(pm8001_ha, DEV,
+		   "Updated Fatal error interrupt vector 0x%x\n",
+		   pm8001_mr32(address, MAIN_FATAL_ERROR_INTERRUPT));
 
 	pm8001_mw32(address, MAIN_EVENT_CRC_CHECK,
 		pm8001_ha->main_cfg_tbl.pm80xx_tbl.crc_core_dump);
@@ -891,9 +879,9 @@ static void update_main_config_table(struct pm8001_hba_info *pm8001_ha)
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.gpio_led_mapping |= 0x20000000;
 	pm8001_mw32(address, MAIN_GPIO_LED_FLAGS_OFFSET,
 		pm8001_ha->main_cfg_tbl.pm80xx_tbl.gpio_led_mapping);
-	PM8001_DEV_DBG(pm8001_ha, pm8001_printk(
-		"Programming DW 0x21 in main cfg table with 0x%x\n",
-		pm8001_mr32(address, MAIN_GPIO_LED_FLAGS_OFFSET)));
+	pm8001_dbg(pm8001_ha, DEV,
+		   "Programming DW 0x21 in main cfg table with 0x%x\n",
+		   pm8001_mr32(address, MAIN_GPIO_LED_FLAGS_OFFSET));
 
 	pm8001_mw32(address, MAIN_PORT_RECOVERY_TIMER,
 		pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer);
@@ -934,20 +922,20 @@ static void update_inbnd_queue_table(struct pm8001_hba_info *pm8001_ha,
 	pm8001_mw32(address, offset + IB_CI_BASE_ADDR_LO_OFFSET,
 		pm8001_ha->inbnd_q_tbl[number].ci_lower_base_addr);
 
-	PM8001_DEV_DBG(pm8001_ha, pm8001_printk(
-		"IQ %d: Element pri size 0x%x\n",
-		number,
-		pm8001_ha->inbnd_q_tbl[number].element_pri_size_cnt));
+	pm8001_dbg(pm8001_ha, DEV,
+		   "IQ %d: Element pri size 0x%x\n",
+		   number,
+		   pm8001_ha->inbnd_q_tbl[number].element_pri_size_cnt);
 
-	PM8001_DEV_DBG(pm8001_ha, pm8001_printk(
-		"IQ upr base addr 0x%x IQ lwr base addr 0x%x\n",
-		pm8001_ha->inbnd_q_tbl[number].upper_base_addr,
-		pm8001_ha->inbnd_q_tbl[number].lower_base_addr));
+	pm8001_dbg(pm8001_ha, DEV,
+		   "IQ upr base addr 0x%x IQ lwr base addr 0x%x\n",
+		   pm8001_ha->inbnd_q_tbl[number].upper_base_addr,
+		   pm8001_ha->inbnd_q_tbl[number].lower_base_addr);
 
-	PM8001_DEV_DBG(pm8001_ha, pm8001_printk(
-		"CI upper base addr 0x%x CI lower base addr 0x%x\n",
-		pm8001_ha->inbnd_q_tbl[number].ci_upper_base_addr,
-		pm8001_ha->inbnd_q_tbl[number].ci_lower_base_addr));
+	pm8001_dbg(pm8001_ha, DEV,
+		   "CI upper base addr 0x%x CI lower base addr 0x%x\n",
+		   pm8001_ha->inbnd_q_tbl[number].ci_upper_base_addr,
+		   pm8001_ha->inbnd_q_tbl[number].ci_lower_base_addr);
 }
 
 /**
@@ -973,20 +961,20 @@ static void update_outbnd_queue_table(struct pm8001_hba_info *pm8001_ha,
 	pm8001_mw32(address, offset + OB_INTERRUPT_COALES_OFFSET,
 		pm8001_ha->outbnd_q_tbl[number].interrup_vec_cnt_delay);
 
-	PM8001_DEV_DBG(pm8001_ha, pm8001_printk(
-		"OQ %d: Element pri size 0x%x\n",
-		number,
-		pm8001_ha->outbnd_q_tbl[number].element_size_cnt));
+	pm8001_dbg(pm8001_ha, DEV,
+		   "OQ %d: Element pri size 0x%x\n",
+		   number,
+		   pm8001_ha->outbnd_q_tbl[number].element_size_cnt);
 
-	PM8001_DEV_DBG(pm8001_ha, pm8001_printk(
-		"OQ upr base addr 0x%x OQ lwr base addr 0x%x\n",
-		pm8001_ha->outbnd_q_tbl[number].upper_base_addr,
-		pm8001_ha->outbnd_q_tbl[number].lower_base_addr));
+	pm8001_dbg(pm8001_ha, DEV,
+		   "OQ upr base addr 0x%x OQ lwr base addr 0x%x\n",
+		   pm8001_ha->outbnd_q_tbl[number].upper_base_addr,
+		   pm8001_ha->outbnd_q_tbl[number].lower_base_addr);
 
-	PM8001_DEV_DBG(pm8001_ha, pm8001_printk(
-		"PI upper base addr 0x%x PI lower base addr 0x%x\n",
-		pm8001_ha->outbnd_q_tbl[number].pi_upper_base_addr,
-		pm8001_ha->outbnd_q_tbl[number].pi_lower_base_addr));
+	pm8001_dbg(pm8001_ha, DEV,
+		   "PI upper base addr 0x%x PI lower base addr 0x%x\n",
+		   pm8001_ha->outbnd_q_tbl[number].pi_upper_base_addr,
+		   pm8001_ha->outbnd_q_tbl[number].pi_lower_base_addr);
 }
 
 /**
@@ -1016,8 +1004,9 @@ static int mpi_init_check(struct pm8001_hba_info *pm8001_ha)
 
 	if (!max_wait_count) {
 		/* additional check */
-		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
-			"Inb doorbell clear not toggled[value:%x]\n", value));
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "Inb doorbell clear not toggled[value:%x]\n",
+			   value);
 		return -EBUSY;
 	}
 	/* check the MPI-State for initialization upto 100ms*/
@@ -1068,9 +1057,9 @@ static int check_fw_ready(struct pm8001_hba_info *pm8001_ha)
 	if (!max_wait_count)
 		ret = -1;
 	else {
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" ila ready status in %d millisec\n",
-				(max_wait_time - max_wait_count)));
+		pm8001_dbg(pm8001_ha, MSG,
+			   " ila ready status in %d millisec\n",
+			   (max_wait_time - max_wait_count));
 	}
 
 	/* check RAAE status */
@@ -1083,9 +1072,9 @@ static int check_fw_ready(struct pm8001_hba_info *pm8001_ha)
 	if (!max_wait_count)
 		ret = -1;
 	else {
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" raae ready status in %d millisec\n",
-					(max_wait_time - max_wait_count)));
+		pm8001_dbg(pm8001_ha, MSG,
+			   " raae ready status in %d millisec\n",
+			   (max_wait_time - max_wait_count));
 	}
 
 	/* check iop0 status */
@@ -1098,9 +1087,9 @@ static int check_fw_ready(struct pm8001_hba_info *pm8001_ha)
 	if (!max_wait_count)
 		ret = -1;
 	else {
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" iop0 ready status in %d millisec\n",
-				(max_wait_time - max_wait_count)));
+		pm8001_dbg(pm8001_ha, MSG,
+			   " iop0 ready status in %d millisec\n",
+			   (max_wait_time - max_wait_count));
 	}
 
 	/* check iop1 status only for 16 port controllers */
@@ -1116,9 +1105,9 @@ static int check_fw_ready(struct pm8001_hba_info *pm8001_ha)
 		if (!max_wait_count)
 			ret = -1;
 		else {
-			PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
-				"iop1 ready status in %d millisec\n",
-				(max_wait_time - max_wait_count)));
+			pm8001_dbg(pm8001_ha, MSG,
+				   "iop1 ready status in %d millisec\n",
+				   (max_wait_time - max_wait_count));
 		}
 	}
 
@@ -1136,13 +1125,11 @@ static void init_pci_device_addresses(struct pm8001_hba_info *pm8001_ha)
 	value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_0);
 	offset = value & 0x03FFFFFF; /* scratch pad 0 TBL address */
 
-	PM8001_DEV_DBG(pm8001_ha,
-		pm8001_printk("Scratchpad 0 Offset: 0x%x value 0x%x\n",
-				offset, value));
+	pm8001_dbg(pm8001_ha, DEV, "Scratchpad 0 Offset: 0x%x value 0x%x\n",
+		   offset, value);
 	pcilogic = (value & 0xFC000000) >> 26;
 	pcibar = get_pci_bar_index(pcilogic);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("Scratchpad 0 PCI BAR: %d\n", pcibar));
+	pm8001_dbg(pm8001_ha, INIT, "Scratchpad 0 PCI BAR: %d\n", pcibar);
 	pm8001_ha->main_cfg_tbl_addr = base_addr =
 		pm8001_ha->io_mem[pcibar].memvirtaddr + offset;
 	pm8001_ha->general_stat_tbl_addr =
@@ -1164,33 +1151,25 @@ static void init_pci_device_addresses(struct pm8001_hba_info *pm8001_ha)
 		base_addr + (pm8001_cr32(pm8001_ha, pcibar, offset + 0xA0) &
 					0xFFFFFF);
 
-	PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("GST OFFSET 0x%x\n",
-			pm8001_cr32(pm8001_ha, pcibar, offset + 0x18)));
-	PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("INBND OFFSET 0x%x\n",
-			pm8001_cr32(pm8001_ha, pcibar, offset + 0x1C)));
-	PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("OBND OFFSET 0x%x\n",
-			pm8001_cr32(pm8001_ha, pcibar, offset + 0x20)));
-	PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("IVT OFFSET 0x%x\n",
-			pm8001_cr32(pm8001_ha, pcibar, offset + 0x8C)));
-	PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("PSPA OFFSET 0x%x\n",
-			pm8001_cr32(pm8001_ha, pcibar, offset + 0x90)));
-	PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("addr - main cfg %p general status %p\n",
-			pm8001_ha->main_cfg_tbl_addr,
-			pm8001_ha->general_stat_tbl_addr));
-	PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("addr - inbnd %p obnd %p\n",
-			pm8001_ha->inbnd_q_tbl_addr,
-			pm8001_ha->outbnd_q_tbl_addr));
-	PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("addr - pspa %p ivt %p\n",
-			pm8001_ha->pspa_q_tbl_addr,
-			pm8001_ha->ivt_tbl_addr));
+	pm8001_dbg(pm8001_ha, INIT, "GST OFFSET 0x%x\n",
+		   pm8001_cr32(pm8001_ha, pcibar, offset + 0x18));
+	pm8001_dbg(pm8001_ha, INIT, "INBND OFFSET 0x%x\n",
+		   pm8001_cr32(pm8001_ha, pcibar, offset + 0x1C));
+	pm8001_dbg(pm8001_ha, INIT, "OBND OFFSET 0x%x\n",
+		   pm8001_cr32(pm8001_ha, pcibar, offset + 0x20));
+	pm8001_dbg(pm8001_ha, INIT, "IVT OFFSET 0x%x\n",
+		   pm8001_cr32(pm8001_ha, pcibar, offset + 0x8C));
+	pm8001_dbg(pm8001_ha, INIT, "PSPA OFFSET 0x%x\n",
+		   pm8001_cr32(pm8001_ha, pcibar, offset + 0x90));
+	pm8001_dbg(pm8001_ha, INIT, "addr - main cfg %p general status %p\n",
+		   pm8001_ha->main_cfg_tbl_addr,
+		   pm8001_ha->general_stat_tbl_addr);
+	pm8001_dbg(pm8001_ha, INIT, "addr - inbnd %p obnd %p\n",
+		   pm8001_ha->inbnd_q_tbl_addr,
+		   pm8001_ha->outbnd_q_tbl_addr);
+	pm8001_dbg(pm8001_ha, INIT, "addr - pspa %p ivt %p\n",
+		   pm8001_ha->pspa_q_tbl_addr,
+		   pm8001_ha->ivt_tbl_addr);
 }
 
 /**
@@ -1224,9 +1203,9 @@ pm80xx_set_thermal_config(struct pm8001_hba_info *pm8001_ha)
 				(THERMAL_ENABLE << 8) | page_code;
 	payload.cfg_pg[1] = (LTEMPHIL << 24) | (RTEMPHIL << 8);
 
-	PM8001_DEV_DBG(pm8001_ha, pm8001_printk(
-		"Setting up thermal config. cfg_pg 0 0x%x cfg_pg 1 0x%x\n",
-		payload.cfg_pg[0], payload.cfg_pg[1]));
+	pm8001_dbg(pm8001_ha, DEV,
+		   "Setting up thermal config. cfg_pg 0 0x%x cfg_pg 1 0x%x\n",
+		   payload.cfg_pg[0], payload.cfg_pg[1]);
 
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
 			sizeof(payload), 0);
@@ -1281,32 +1260,24 @@ pm80xx_set_sas_protocol_timer_config(struct pm8001_hba_info *pm8001_ha)
 						| SAS_COPNRJT_RTRY_THR;
 	SASConfigPage.MAX_AIP =  SAS_MAX_AIP;
 
-	PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("SASConfigPage.pageCode "
-			"0x%08x\n", SASConfigPage.pageCode));
-	PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("SASConfigPage.MST_MSI "
-			" 0x%08x\n", SASConfigPage.MST_MSI));
-	PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("SASConfigPage.STP_SSP_MCT_TMO "
-			" 0x%08x\n", SASConfigPage.STP_SSP_MCT_TMO));
-	PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("SASConfigPage.STP_FRM_TMO "
-			" 0x%08x\n", SASConfigPage.STP_FRM_TMO));
-	PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("SASConfigPage.STP_IDLE_TMO "
-			" 0x%08x\n", SASConfigPage.STP_IDLE_TMO));
-	PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("SASConfigPage.OPNRJT_RTRY_INTVL "
-			" 0x%08x\n", SASConfigPage.OPNRJT_RTRY_INTVL));
-	PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("SASConfigPage.Data_Cmd_OPNRJT_RTRY_TMO "
-			" 0x%08x\n", SASConfigPage.Data_Cmd_OPNRJT_RTRY_TMO));
-	PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("SASConfigPage.Data_Cmd_OPNRJT_RTRY_THR "
-			" 0x%08x\n", SASConfigPage.Data_Cmd_OPNRJT_RTRY_THR));
-	PM8001_INIT_DBG(pm8001_ha, pm8001_printk("SASConfigPage.MAX_AIP "
-			" 0x%08x\n", SASConfigPage.MAX_AIP));
+	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.pageCode 0x%08x\n",
+		   SASConfigPage.pageCode);
+	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.MST_MSI  0x%08x\n",
+		   SASConfigPage.MST_MSI);
+	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.STP_SSP_MCT_TMO  0x%08x\n",
+		   SASConfigPage.STP_SSP_MCT_TMO);
+	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.STP_FRM_TMO  0x%08x\n",
+		   SASConfigPage.STP_FRM_TMO);
+	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.STP_IDLE_TMO  0x%08x\n",
+		   SASConfigPage.STP_IDLE_TMO);
+	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.OPNRJT_RTRY_INTVL  0x%08x\n",
+		   SASConfigPage.OPNRJT_RTRY_INTVL);
+	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.Data_Cmd_OPNRJT_RTRY_TMO  0x%08x\n",
+		   SASConfigPage.Data_Cmd_OPNRJT_RTRY_TMO);
+	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.Data_Cmd_OPNRJT_RTRY_THR  0x%08x\n",
+		   SASConfigPage.Data_Cmd_OPNRJT_RTRY_THR);
+	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.MAX_AIP  0x%08x\n",
+		   SASConfigPage.MAX_AIP);
 
 	memcpy(&payload.cfg_pg, &SASConfigPage,
 			 sizeof(SASProtocolTimerConfig_t));
@@ -1346,18 +1317,18 @@ pm80xx_get_encrypt_info(struct pm8001_hba_info *pm8001_ha)
 						SCRATCH_PAD3_SMB_ENABLED)
 			pm8001_ha->encrypt_info.sec_mode = SEC_MODE_SMB;
 		pm8001_ha->encrypt_info.status = 0;
-		PM8001_INIT_DBG(pm8001_ha, pm8001_printk(
-			"Encryption: SCRATCH_PAD3_ENC_READY 0x%08X."
-			"Cipher mode 0x%x Sec mode 0x%x status 0x%x\n",
-			scratch3_value, pm8001_ha->encrypt_info.cipher_mode,
-			pm8001_ha->encrypt_info.sec_mode,
-			pm8001_ha->encrypt_info.status));
+		pm8001_dbg(pm8001_ha, INIT,
+			   "Encryption: SCRATCH_PAD3_ENC_READY 0x%08X.Cipher mode 0x%x Sec mode 0x%x status 0x%x\n",
+			   scratch3_value,
+			   pm8001_ha->encrypt_info.cipher_mode,
+			   pm8001_ha->encrypt_info.sec_mode,
+			   pm8001_ha->encrypt_info.status);
 		ret = 0;
 	} else if ((scratch3_value & SCRATCH_PAD3_ENC_READY) ==
 					SCRATCH_PAD3_ENC_DISABLED) {
-		PM8001_INIT_DBG(pm8001_ha, pm8001_printk(
-			"Encryption: SCRATCH_PAD3_ENC_DISABLED 0x%08X\n",
-			scratch3_value));
+		pm8001_dbg(pm8001_ha, INIT,
+			   "Encryption: SCRATCH_PAD3_ENC_DISABLED 0x%08X\n",
+			   scratch3_value);
 		pm8001_ha->encrypt_info.status = 0xFFFFFFFF;
 		pm8001_ha->encrypt_info.cipher_mode = 0;
 		pm8001_ha->encrypt_info.sec_mode = 0;
@@ -1377,12 +1348,12 @@ pm80xx_get_encrypt_info(struct pm8001_hba_info *pm8001_ha)
 		if ((scratch3_value & SCRATCH_PAD3_SM_MASK) ==
 					SCRATCH_PAD3_SMB_ENABLED)
 			pm8001_ha->encrypt_info.sec_mode = SEC_MODE_SMB;
-		PM8001_INIT_DBG(pm8001_ha, pm8001_printk(
-			"Encryption: SCRATCH_PAD3_DIS_ERR 0x%08X."
-			"Cipher mode 0x%x sec mode 0x%x status 0x%x\n",
-			scratch3_value, pm8001_ha->encrypt_info.cipher_mode,
-			pm8001_ha->encrypt_info.sec_mode,
-			pm8001_ha->encrypt_info.status));
+		pm8001_dbg(pm8001_ha, INIT,
+			   "Encryption: SCRATCH_PAD3_DIS_ERR 0x%08X.Cipher mode 0x%x sec mode 0x%x status 0x%x\n",
+			   scratch3_value,
+			   pm8001_ha->encrypt_info.cipher_mode,
+			   pm8001_ha->encrypt_info.sec_mode,
+			   pm8001_ha->encrypt_info.status);
 	} else if ((scratch3_value & SCRATCH_PAD3_ENC_MASK) ==
 				 SCRATCH_PAD3_ENC_ENA_ERR) {
 
@@ -1400,12 +1371,12 @@ pm80xx_get_encrypt_info(struct pm8001_hba_info *pm8001_ha)
 					SCRATCH_PAD3_SMB_ENABLED)
 			pm8001_ha->encrypt_info.sec_mode = SEC_MODE_SMB;
 
-		PM8001_INIT_DBG(pm8001_ha, pm8001_printk(
-			"Encryption: SCRATCH_PAD3_ENA_ERR 0x%08X."
-			"Cipher mode 0x%x sec mode 0x%x status 0x%x\n",
-			scratch3_value, pm8001_ha->encrypt_info.cipher_mode,
-			pm8001_ha->encrypt_info.sec_mode,
-			pm8001_ha->encrypt_info.status));
+		pm8001_dbg(pm8001_ha, INIT,
+			   "Encryption: SCRATCH_PAD3_ENA_ERR 0x%08X.Cipher mode 0x%x sec mode 0x%x status 0x%x\n",
+			   scratch3_value,
+			   pm8001_ha->encrypt_info.cipher_mode,
+			   pm8001_ha->encrypt_info.sec_mode,
+			   pm8001_ha->encrypt_info.status);
 	}
 	return ret;
 }
@@ -1435,9 +1406,9 @@ static int pm80xx_encrypt_update(struct pm8001_hba_info *pm8001_ha)
 	payload.new_curidx_ksop = ((1 << 24) | (1 << 16) | (1 << 8) |
 					KEK_MGMT_SUBOP_KEYCARDUPDATE);
 
-	PM8001_DEV_DBG(pm8001_ha, pm8001_printk(
-		"Saving Encryption info to flash. payload 0x%x\n",
-		payload.new_curidx_ksop));
+	pm8001_dbg(pm8001_ha, DEV,
+		   "Saving Encryption info to flash. payload 0x%x\n",
+		   payload.new_curidx_ksop);
 
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
 			sizeof(payload), 0);
@@ -1458,8 +1429,7 @@ static int pm80xx_chip_init(struct pm8001_hba_info *pm8001_ha)
 
 	/* check the firmware status */
 	if (-1 == check_fw_ready(pm8001_ha)) {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("Firmware is not ready!\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "Firmware is not ready!\n");
 		return -EBUSY;
 	}
 
@@ -1483,8 +1453,7 @@ static int pm80xx_chip_init(struct pm8001_hba_info *pm8001_ha)
 	}
 	/* notify firmware update finished and check initialization status */
 	if (0 == mpi_init_check(pm8001_ha)) {
-		PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("MPI initialize successful!\n"));
+		pm8001_dbg(pm8001_ha, INIT, "MPI initialize successful!\n");
 	} else
 		return -EBUSY;
 
@@ -1493,16 +1462,13 @@ static int pm80xx_chip_init(struct pm8001_hba_info *pm8001_ha)
 
 	/* Check for encryption */
 	if (pm8001_ha->chip->encrypt) {
-		PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("Checking for encryption\n"));
+		pm8001_dbg(pm8001_ha, INIT, "Checking for encryption\n");
 		ret = pm80xx_get_encrypt_info(pm8001_ha);
 		if (ret == -1) {
-			PM8001_INIT_DBG(pm8001_ha,
-				pm8001_printk("Encryption error !!\n"));
+			pm8001_dbg(pm8001_ha, INIT, "Encryption error !!\n");
 			if (pm8001_ha->encrypt_info.status == 0x81) {
-				PM8001_INIT_DBG(pm8001_ha, pm8001_printk(
-					"Encryption enabled with error."
-					"Saving encryption key to flash\n"));
+				pm8001_dbg(pm8001_ha, INIT,
+					   "Encryption enabled with error.Saving encryption key to flash\n");
 				pm80xx_encrypt_update(pm8001_ha);
 			}
 		}
@@ -1533,8 +1499,7 @@ static int mpi_uninit_check(struct pm8001_hba_info *pm8001_ha)
 	} while ((value != 0) && (--max_wait_count));
 
 	if (!max_wait_count) {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("TIMEOUT:IBDB value/=%x\n", value));
+		pm8001_dbg(pm8001_ha, FAIL, "TIMEOUT:IBDB value/=%x\n", value);
 		return -1;
 	}
 
@@ -1551,9 +1516,8 @@ static int mpi_uninit_check(struct pm8001_hba_info *pm8001_ha)
 			break;
 	} while (--max_wait_count);
 	if (!max_wait_count) {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk(" TIME OUT MPI State = 0x%x\n",
-				gst_len_mpistate & GST_MPI_STATE_MASK));
+		pm8001_dbg(pm8001_ha, FAIL, " TIME OUT MPI State = 0x%x\n",
+			   gst_len_mpistate & GST_MPI_STATE_MASK);
 		return -1;
 	}
 
@@ -1581,9 +1545,9 @@ pm80xx_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 			u32 r1 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
 			u32 r2 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2);
 			u32 r3 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_3);
-			PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
-				"MPI state is not ready scratch: %x:%x:%x:%x\n",
-				r0, r1, r2, r3));
+			pm8001_dbg(pm8001_ha, FAIL,
+				   "MPI state is not ready scratch: %x:%x:%x:%x\n",
+				   r0, r1, r2, r3);
 			/* if things aren't ready but the bootloader is ok then
 			 * try the reset anyway.
 			 */
@@ -1593,25 +1557,25 @@ pm80xx_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 	}
 	/* checked for reset register normal state; 0x0 */
 	regval = pm8001_cr32(pm8001_ha, 0, SPC_REG_SOFT_RESET);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("reset register before write : 0x%x\n", regval));
+	pm8001_dbg(pm8001_ha, INIT, "reset register before write : 0x%x\n",
+		   regval);
 
 	pm8001_cw32(pm8001_ha, 0, SPC_REG_SOFT_RESET, SPCv_NORMAL_RESET_VALUE);
 	msleep(500);
 
 	regval = pm8001_cr32(pm8001_ha, 0, SPC_REG_SOFT_RESET);
-	PM8001_INIT_DBG(pm8001_ha,
-	pm8001_printk("reset register after write 0x%x\n", regval));
+	pm8001_dbg(pm8001_ha, INIT, "reset register after write 0x%x\n",
+		   regval);
 
 	if ((regval & SPCv_SOFT_RESET_READ_MASK) ==
 			SPCv_SOFT_RESET_NORMAL_RESET_OCCURED) {
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" soft reset successful [regval: 0x%x]\n",
-					regval));
+		pm8001_dbg(pm8001_ha, MSG,
+			   " soft reset successful [regval: 0x%x]\n",
+			   regval);
 	} else {
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" soft reset failed [regval: 0x%x]\n",
-					regval));
+		pm8001_dbg(pm8001_ha, MSG,
+			   " soft reset failed [regval: 0x%x]\n",
+			   regval);
 
 		/* check bootloader is successfully executed or in HDA mode */
 		bootloader_state =
@@ -1619,28 +1583,27 @@ pm80xx_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 			SCRATCH_PAD1_BOOTSTATE_MASK;
 
 		if (bootloader_state == SCRATCH_PAD1_BOOTSTATE_HDA_SEEPROM) {
-			PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
-				"Bootloader state - HDA mode SEEPROM\n"));
+			pm8001_dbg(pm8001_ha, MSG,
+				   "Bootloader state - HDA mode SEEPROM\n");
 		} else if (bootloader_state ==
 				SCRATCH_PAD1_BOOTSTATE_HDA_BOOTSTRAP) {
-			PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
-				"Bootloader state - HDA mode Bootstrap Pin\n"));
+			pm8001_dbg(pm8001_ha, MSG,
+				   "Bootloader state - HDA mode Bootstrap Pin\n");
 		} else if (bootloader_state ==
 				SCRATCH_PAD1_BOOTSTATE_HDA_SOFTRESET) {
-			PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
-				"Bootloader state - HDA mode soft reset\n"));
+			pm8001_dbg(pm8001_ha, MSG,
+				   "Bootloader state - HDA mode soft reset\n");
 		} else if (bootloader_state ==
 					SCRATCH_PAD1_BOOTSTATE_CRIT_ERROR) {
-			PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
-				"Bootloader state-HDA mode critical error\n"));
+			pm8001_dbg(pm8001_ha, MSG,
+				   "Bootloader state-HDA mode critical error\n");
 		}
 		return -EBUSY;
 	}
 
 	/* check the firmware status after reset */
 	if (-1 == check_fw_ready(pm8001_ha)) {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("Firmware is not ready!\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "Firmware is not ready!\n");
 		/* check iButton feature support for motherboard controller */
 		if (pm8001_ha->pdev->subsystem_vendor !=
 			PCI_VENDOR_ID_ADAPTEC2 &&
@@ -1652,21 +1615,18 @@ pm80xx_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 			ibutton1 = pm8001_cr32(pm8001_ha, 0,
 					MSGU_HOST_SCRATCH_PAD_7);
 			if (!ibutton0 && !ibutton1) {
-				PM8001_FAIL_DBG(pm8001_ha,
-					pm8001_printk("iButton Feature is"
-					" not Available!!!\n"));
+				pm8001_dbg(pm8001_ha, FAIL,
+					   "iButton Feature is not Available!!!\n");
 				return -EBUSY;
 			}
 			if (ibutton0 == 0xdeadbeef && ibutton1 == 0xdeadbeef) {
-				PM8001_FAIL_DBG(pm8001_ha,
-					pm8001_printk("CRC Check for iButton"
-					" Feature Failed!!!\n"));
+				pm8001_dbg(pm8001_ha, FAIL,
+					   "CRC Check for iButton Feature Failed!!!\n");
 				return -EBUSY;
 			}
 		}
 	}
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("SPCv soft reset Complete\n"));
+	pm8001_dbg(pm8001_ha, INIT, "SPCv soft reset Complete\n");
 	return 0;
 }
 
@@ -1674,13 +1634,11 @@ static void pm80xx_hw_chip_rst(struct pm8001_hba_info *pm8001_ha)
 {
 	u32 i;
 
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("chip reset start\n"));
+	pm8001_dbg(pm8001_ha, INIT, "chip reset start\n");
 
 	/* do SPCv chip reset. */
 	pm8001_cw32(pm8001_ha, 0, SPC_REG_SOFT_RESET, 0x11);
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("SPC soft reset Complete\n"));
+	pm8001_dbg(pm8001_ha, INIT, "SPC soft reset Complete\n");
 
 	/* Check this ..whether delay is required or no */
 	/* delay 10 usec */
@@ -1692,8 +1650,7 @@ static void pm80xx_hw_chip_rst(struct pm8001_hba_info *pm8001_ha)
 		mdelay(1);
 	} while ((--i) != 0);
 
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("chip reset finished\n"));
+	pm8001_dbg(pm8001_ha, INIT, "chip reset finished\n");
 }
 
 /**
@@ -1769,15 +1726,14 @@ static void pm80xx_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 	int ret;
 
 	if (!pm8001_ha_dev) {
-		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("dev is null\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "dev is null\n");
 		return;
 	}
 
 	task = sas_alloc_slow_task(GFP_ATOMIC);
 
 	if (!task) {
-		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("cannot "
-						"allocate task\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate task\n");
 		return;
 	}
 
@@ -1803,8 +1759,7 @@ static void pm80xx_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 
 	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort,
 			sizeof(task_abort), 0);
-	PM8001_FAIL_DBG(pm8001_ha,
-		pm8001_printk("Executing abort task end\n"));
+	pm8001_dbg(pm8001_ha, FAIL, "Executing abort task end\n");
 	if (ret) {
 		sas_free_task(task);
 		pm8001_tag_free(pm8001_ha, ccb_tag);
@@ -1827,8 +1782,7 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	task = sas_alloc_slow_task(GFP_ATOMIC);
 
 	if (!task) {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("cannot allocate task !!!\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate task !!!\n");
 		return;
 	}
 	task->task_done = pm8001_task_done;
@@ -1836,8 +1790,7 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
 	if (res) {
 		sas_free_task(task);
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("cannot allocate tag !!!\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate tag !!!\n");
 		return;
 	}
 
@@ -1848,8 +1801,8 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	if (!dev) {
 		sas_free_task(task);
 		pm8001_tag_free(pm8001_ha, ccb_tag);
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("Domain device cannot be allocated\n"));
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "Domain device cannot be allocated\n");
 		return;
 	}
 
@@ -1882,7 +1835,7 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
 
 	res = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd,
 			sizeof(sata_cmd), 0);
-	PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("Executing read log end\n"));
+	pm8001_dbg(pm8001_ha, FAIL, "Executing read log end\n");
 	if (res) {
 		sas_free_task(task);
 		pm8001_tag_free(pm8001_ha, ccb_tag);
@@ -1928,27 +1881,24 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 	t = ccb->task;
 
 	if (status && status != IO_UNDERFLOW)
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("sas IO status 0x%x\n", status));
+		pm8001_dbg(pm8001_ha, FAIL, "sas IO status 0x%x\n", status);
 	if (unlikely(!t || !t->lldd_task || !t->dev))
 		return;
 	ts = &t->task_status;
 
-	PM8001_DEV_DBG(pm8001_ha, pm8001_printk(
-		"tag::0x%x, status::0x%x task::0x%p\n", tag, status, t));
+	pm8001_dbg(pm8001_ha, DEV,
+		   "tag::0x%x, status::0x%x task::0x%p\n", tag, status, t);
 
 	/* Print sas address of IO failed device */
 	if ((status != IO_SUCCESS) && (status != IO_OVERFLOW) &&
 		(status != IO_UNDERFLOW))
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("SAS Address of IO Failure Drive"
-			":%016llx", SAS_ADDR(t->dev->sas_addr)));
+		pm8001_dbg(pm8001_ha, FAIL, "SAS Address of IO Failure Drive:%016llx\n",
+			   SAS_ADDR(t->dev->sas_addr));
 
 	switch (status) {
 	case IO_SUCCESS:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_SUCCESS ,param = 0x%x\n",
-				param));
+		pm8001_dbg(pm8001_ha, IO, "IO_SUCCESS ,param = 0x%x\n",
+			   param);
 		if (param == 0) {
 			ts->resp = SAS_TASK_COMPLETE;
 			ts->stat = SAM_STAT_GOOD;
@@ -1963,8 +1913,7 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_ABORTED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_ABORTED IOMB Tag\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_ABORTED IOMB Tag\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_ABORTED_TASK;
 		if (pm8001_dev)
@@ -1972,9 +1921,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		break;
 	case IO_UNDERFLOW:
 		/* SSP Completion with error */
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_UNDERFLOW ,param = 0x%x\n",
-				param));
+		pm8001_dbg(pm8001_ha, IO, "IO_UNDERFLOW ,param = 0x%x\n",
+			   param);
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_UNDERRUN;
 		ts->residual = param;
@@ -1982,16 +1930,14 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_NO_DEVICE:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_NO_DEVICE\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_NO_DEVICE\n");
 		ts->resp = SAS_TASK_UNDELIVERED;
 		ts->stat = SAS_PHY_DOWN;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_BREAK:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_BREAK\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_BREAK\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		/* Force the midlayer to retry */
@@ -2000,8 +1946,7 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_PHY_NOT_READY:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_PHY_NOT_READY\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_PHY_NOT_READY\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
@@ -2009,8 +1954,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_INVALID_SSP_RSP_FRAME:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_INVALID_SSP_RSP_FRAME\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_XFER_ERROR_INVALID_SSP_RSP_FRAME\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
@@ -2018,8 +1963,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED:
-		PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk("IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_EPROTO;
@@ -2027,8 +1972,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_ZONE_VIOLATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_ZONE_VIOLATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_ZONE_VIOLATION\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_UNKNOWN;
@@ -2036,8 +1981,7 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_BREAK:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_BREAK\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_BREAK\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
@@ -2050,8 +1994,7 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS_NO_DEST:
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS_OPEN_COLLIDE:
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS_PATHWAY_BLOCKED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_UNKNOWN;
@@ -2061,8 +2004,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 		break;
 	case IO_OPEN_CNX_ERROR_BAD_DESTINATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_BAD_DESTINATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_BAD_DESTINATION\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_BAD_DEST;
@@ -2070,8 +2013,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED:
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
-			"IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_CONN_RATE;
@@ -2079,8 +2022,8 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_WRONG_DESTINATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_WRONG_DESTINATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_WRONG_DESTINATION\n");
 		ts->resp = SAS_TASK_UNDELIVERED;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_WRONG_DEST;
@@ -2088,8 +2031,7 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_NAK_RECEIVED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_NAK_RECEIVED\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_NAK_RECEIVED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
@@ -2097,24 +2039,21 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_ACK_NAK_TIMEOUT:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_ACK_NAK_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_ACK_NAK_TIMEOUT\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_NAK_R_ERR;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_DMA:
-		PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk("IO_XFER_ERROR_DMA\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_DMA\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_OPEN_RETRY_TIMEOUT:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_OPEN_RETRY_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_OPEN_RETRY_TIMEOUT\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
@@ -2122,24 +2061,21 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_OFFSET_MISMATCH:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_OFFSET_MISMATCH\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_OFFSET_MISMATCH\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_PORT_IN_RESET:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_PORT_IN_RESET\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_PORT_IN_RESET\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_DS_NON_OPERATIONAL:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_DS_NON_OPERATIONAL\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_DS_NON_OPERATIONAL\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		if (!t->uldd_task)
@@ -2148,32 +2084,29 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 				IO_DS_NON_OPERATIONAL);
 		break;
 	case IO_DS_IN_RECOVERY:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_DS_IN_RECOVERY\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_DS_IN_RECOVERY\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_TM_TAG_NOT_FOUND:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_TM_TAG_NOT_FOUND\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_TM_TAG_NOT_FOUND\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_SSP_EXT_IU_ZERO_LEN_ERROR:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_SSP_EXT_IU_ZERO_LEN_ERROR\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_SSP_EXT_IU_ZERO_LEN_ERROR\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
@@ -2181,8 +2114,7 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	default:
-		PM8001_DEVIO_DBG(pm8001_ha,
-			pm8001_printk("Unknown status 0x%x\n", status));
+		pm8001_dbg(pm8001_ha, DEVIO, "Unknown status 0x%x\n", status);
 		/* not allowed case. Therefore, return failed status */
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
@@ -2190,19 +2122,17 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	}
-	PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk("scsi_status = 0x%x\n ",
-		psspPayload->ssp_resp_iu.status));
+	pm8001_dbg(pm8001_ha, IO, "scsi_status = 0x%x\n ",
+		   psspPayload->ssp_resp_iu.status);
 	spin_lock_irqsave(&t->task_state_lock, flags);
 	t->task_state_flags &= ~SAS_TASK_STATE_PENDING;
 	t->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
 	t->task_state_flags |= SAS_TASK_STATE_DONE;
 	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
-			"task 0x%p done with io_status 0x%x resp 0x%x "
-			"stat 0x%x but aborted by upper layer!\n",
-			t, status, ts->resp, ts->stat));
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
+			   t, status, ts->resp, ts->stat);
 		if (t->slow_task)
 			complete(&t->slow_task->completion);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
@@ -2232,17 +2162,15 @@ static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 	t = ccb->task;
 	pm8001_dev = ccb->device;
 	if (event)
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("sas IO status 0x%x\n", event));
+		pm8001_dbg(pm8001_ha, FAIL, "sas IO status 0x%x\n", event);
 	if (unlikely(!t || !t->lldd_task || !t->dev))
 		return;
 	ts = &t->task_status;
-	PM8001_IOERR_DBG(pm8001_ha,
-		pm8001_printk("port_id:0x%x, tag:0x%x, event:0x%x\n",
-				port_id, tag, event));
+	pm8001_dbg(pm8001_ha, IOERR, "port_id:0x%x, tag:0x%x, event:0x%x\n",
+		   port_id, tag, event);
 	switch (event) {
 	case IO_OVERFLOW:
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_UNDERFLOW\n");)
+		pm8001_dbg(pm8001_ha, IO, "IO_UNDERFLOW\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
 		ts->residual = 0;
@@ -2250,34 +2178,31 @@ static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_BREAK:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_BREAK\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_BREAK\n");
 		pm8001_handle_event(pm8001_ha, t, IO_XFER_ERROR_BREAK);
 		return;
 	case IO_XFER_ERROR_PHY_NOT_READY:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_PHY_NOT_READY\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_PHY_NOT_READY\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
 		break;
 	case IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED:
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
-			"IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_EPROTO;
 		break;
 	case IO_OPEN_CNX_ERROR_ZONE_VIOLATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_ZONE_VIOLATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_ZONE_VIOLATION\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_UNKNOWN;
 		break;
 	case IO_OPEN_CNX_ERROR_BREAK:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_BREAK\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_BREAK\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
@@ -2288,8 +2213,7 @@ static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS_NO_DEST:
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS_OPEN_COLLIDE:
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS_PATHWAY_BLOCKED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_UNKNOWN;
@@ -2299,94 +2223,86 @@ static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 		break;
 	case IO_OPEN_CNX_ERROR_BAD_DESTINATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_BAD_DESTINATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_BAD_DESTINATION\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_BAD_DEST;
 		break;
 	case IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED:
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
-			"IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_CONN_RATE;
 		break;
 	case IO_OPEN_CNX_ERROR_WRONG_DESTINATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_WRONG_DESTINATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_WRONG_DESTINATION\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_WRONG_DEST;
 		break;
 	case IO_XFER_ERROR_NAK_RECEIVED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_NAK_RECEIVED\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_NAK_RECEIVED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
 		break;
 	case IO_XFER_ERROR_ACK_NAK_TIMEOUT:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_ACK_NAK_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_ACK_NAK_TIMEOUT\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_NAK_R_ERR;
 		break;
 	case IO_XFER_OPEN_RETRY_TIMEOUT:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_OPEN_RETRY_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_OPEN_RETRY_TIMEOUT\n");
 		pm8001_handle_event(pm8001_ha, t, IO_XFER_OPEN_RETRY_TIMEOUT);
 		return;
 	case IO_XFER_ERROR_UNEXPECTED_PHASE:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_UNEXPECTED_PHASE\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_UNEXPECTED_PHASE\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
 		break;
 	case IO_XFER_ERROR_XFER_RDY_OVERRUN:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_XFER_RDY_OVERRUN\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_XFER_RDY_OVERRUN\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
 		break;
 	case IO_XFER_ERROR_XFER_RDY_NOT_EXPECTED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_XFER_RDY_NOT_EXPECTED\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_XFER_ERROR_XFER_RDY_NOT_EXPECTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
 		break;
 	case IO_XFER_ERROR_CMD_ISSUE_ACK_NAK_TIMEOUT:
-		PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk("IO_XFER_ERROR_CMD_ISSUE_ACK_NAK_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_XFER_ERROR_CMD_ISSUE_ACK_NAK_TIMEOUT\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
 		break;
 	case IO_XFER_ERROR_OFFSET_MISMATCH:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_OFFSET_MISMATCH\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_OFFSET_MISMATCH\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
 		break;
 	case IO_XFER_ERROR_XFER_ZERO_DATA_LEN:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_XFER_ZERO_DATA_LEN\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_XFER_ERROR_XFER_ZERO_DATA_LEN\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
 		break;
 	case IO_XFER_ERROR_INTERNAL_CRC_ERROR:
-		PM8001_IOERR_DBG(pm8001_ha,
-			pm8001_printk("IO_XFR_ERROR_INTERNAL_CRC_ERROR\n"));
+		pm8001_dbg(pm8001_ha, IOERR,
+			   "IO_XFR_ERROR_INTERNAL_CRC_ERROR\n");
 		/* TBC: used default set values */
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
 		break;
 	case IO_XFER_CMD_FRAME_ISSUED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_CMD_FRAME_ISSUED\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_CMD_FRAME_ISSUED\n");
 		return;
 	default:
-		PM8001_DEVIO_DBG(pm8001_ha,
-			pm8001_printk("Unknown status 0x%x\n", event));
+		pm8001_dbg(pm8001_ha, DEVIO, "Unknown status 0x%x\n", event);
 		/* not allowed case. Therefore, return failed status */
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
@@ -2398,10 +2314,9 @@ static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 	t->task_state_flags |= SAS_TASK_STATE_DONE;
 	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
-			"task 0x%p done with event 0x%x resp 0x%x "
-			"stat 0x%x but aborted by upper layer!\n",
-			t, event, ts->resp, ts->stat));
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "task 0x%p done with event 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
+			   t, event, ts->resp, ts->stat);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
@@ -2436,8 +2351,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	tag = le32_to_cpu(psataPayload->tag);
 
 	if (!tag) {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("tag null\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "tag null\n");
 		return;
 	}
 	ccb = &pm8001_ha->ccb_info[tag];
@@ -2446,8 +2360,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		t = ccb->task;
 		pm8001_dev = ccb->device;
 	} else {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("ccb null\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "ccb null\n");
 		return;
 	}
 
@@ -2455,29 +2368,26 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		if (t->dev && (t->dev->lldd_dev))
 			pm8001_dev = t->dev->lldd_dev;
 	} else {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("task null\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "task null\n");
 		return;
 	}
 
 	if ((pm8001_dev && !(pm8001_dev->id & NCQ_READ_LOG_FLAG))
 		&& unlikely(!t || !t->lldd_task || !t->dev)) {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("task or dev null\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "task or dev null\n");
 		return;
 	}
 
 	ts = &t->task_status;
 	if (!ts) {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("ts null\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "ts null\n");
 		return;
 	}
 
 	if (unlikely(status))
-		PM8001_IOERR_DBG(pm8001_ha, pm8001_printk(
-			"status:0x%x, tag:0x%x, task::0x%p\n",
-			status, tag, t));
+		pm8001_dbg(pm8001_ha, IOERR,
+			   "status:0x%x, tag:0x%x, task::0x%p\n",
+			   status, tag, t);
 
 	/* Print sas address of IO failed device */
 	if ((status != IO_SUCCESS) && (status != IO_OVERFLOW) &&
@@ -2509,20 +2419,20 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 						& 0xff000000)) +
 						pm8001_dev->attached_phy +
 						0x10);
-			PM8001_FAIL_DBG(pm8001_ha,
-				pm8001_printk("SAS Address of IO Failure Drive:"
-				"%08x%08x", temp_sata_addr_hi,
-					temp_sata_addr_low));
+			pm8001_dbg(pm8001_ha, FAIL,
+				   "SAS Address of IO Failure Drive:%08x%08x\n",
+				   temp_sata_addr_hi,
+				   temp_sata_addr_low);
 
 		} else {
-			PM8001_FAIL_DBG(pm8001_ha,
-				pm8001_printk("SAS Address of IO Failure Drive:"
-				"%016llx", SAS_ADDR(t->dev->sas_addr)));
+			pm8001_dbg(pm8001_ha, FAIL,
+				   "SAS Address of IO Failure Drive:%016llx\n",
+				   SAS_ADDR(t->dev->sas_addr));
 		}
 	}
 	switch (status) {
 	case IO_SUCCESS:
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_SUCCESS\n");
 		if (param == 0) {
 			ts->resp = SAS_TASK_COMPLETE;
 			ts->stat = SAM_STAT_GOOD;
@@ -2544,39 +2454,38 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			ts->resp = SAS_TASK_COMPLETE;
 			ts->stat = SAS_PROTO_RESPONSE;
 			ts->residual = param;
-			PM8001_IO_DBG(pm8001_ha,
-				pm8001_printk("SAS_PROTO_RESPONSE len = %d\n",
-				param));
+			pm8001_dbg(pm8001_ha, IO,
+				   "SAS_PROTO_RESPONSE len = %d\n",
+				   param);
 			sata_resp = &psataPayload->sata_resp[0];
 			resp = (struct ata_task_resp *)ts->buf;
 			if (t->ata_task.dma_xfer == 0 &&
 			    t->data_dir == DMA_FROM_DEVICE) {
 				len = sizeof(struct pio_setup_fis);
-				PM8001_IO_DBG(pm8001_ha,
-				pm8001_printk("PIO read len = %d\n", len));
+				pm8001_dbg(pm8001_ha, IO,
+					   "PIO read len = %d\n", len);
 			} else if (t->ata_task.use_ncq) {
 				len = sizeof(struct set_dev_bits_fis);
-				PM8001_IO_DBG(pm8001_ha,
-					pm8001_printk("FPDMA len = %d\n", len));
+				pm8001_dbg(pm8001_ha, IO, "FPDMA len = %d\n",
+					   len);
 			} else {
 				len = sizeof(struct dev_to_host_fis);
-				PM8001_IO_DBG(pm8001_ha,
-				pm8001_printk("other len = %d\n", len));
+				pm8001_dbg(pm8001_ha, IO, "other len = %d\n",
+					   len);
 			}
 			if (SAS_STATUS_BUF_SIZE >= sizeof(*resp)) {
 				resp->frame_len = len;
 				memcpy(&resp->ending_fis[0], sata_resp, len);
 				ts->buf_valid_size = sizeof(*resp);
 			} else
-				PM8001_IO_DBG(pm8001_ha,
-					pm8001_printk("response too large\n"));
+				pm8001_dbg(pm8001_ha, IO,
+					   "response too large\n");
 		}
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_ABORTED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_ABORTED IOMB Tag\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_ABORTED IOMB Tag\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_ABORTED_TASK;
 		if (pm8001_dev)
@@ -2585,8 +2494,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		/* following cases are to do cases */
 	case IO_UNDERFLOW:
 		/* SATA Completion with error */
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_UNDERFLOW param = %d\n", param));
+		pm8001_dbg(pm8001_ha, IO, "IO_UNDERFLOW param = %d\n", param);
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_UNDERRUN;
 		ts->residual = param;
@@ -2594,24 +2502,21 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_NO_DEVICE:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_NO_DEVICE\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_NO_DEVICE\n");
 		ts->resp = SAS_TASK_UNDELIVERED;
 		ts->stat = SAS_PHY_DOWN;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_BREAK:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_BREAK\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_BREAK\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_INTERRUPTED;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_PHY_NOT_READY:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_PHY_NOT_READY\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_PHY_NOT_READY\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
@@ -2619,8 +2524,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED:
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
-			"IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_EPROTO;
@@ -2628,8 +2533,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_ZONE_VIOLATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_ZONE_VIOLATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_ZONE_VIOLATION\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_UNKNOWN;
@@ -2637,8 +2542,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_BREAK:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_BREAK\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_BREAK\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_CONT0;
@@ -2651,8 +2555,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS_NO_DEST:
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS_OPEN_COLLIDE:
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS_PATHWAY_BLOCKED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
 		if (!t->uldd_task) {
@@ -2666,8 +2569,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		}
 		break;
 	case IO_OPEN_CNX_ERROR_BAD_DESTINATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_BAD_DESTINATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_BAD_DESTINATION\n");
 		ts->resp = SAS_TASK_UNDELIVERED;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_BAD_DEST;
@@ -2682,8 +2585,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		}
 		break;
 	case IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED:
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
-			"IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_CONN_RATE;
@@ -2691,8 +2594,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OPEN_CNX_ERROR_STP_RESOURCES_BUSY:
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
-			"IO_OPEN_CNX_ERROR_STP_RESOURCES_BUSY\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_STP_RESOURCES_BUSY\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
 		if (!t->uldd_task) {
@@ -2706,8 +2609,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		}
 		break;
 	case IO_OPEN_CNX_ERROR_WRONG_DESTINATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_WRONG_DESTINATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_WRONG_DESTINATION\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_WRONG_DEST;
@@ -2715,64 +2618,56 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_NAK_RECEIVED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_NAK_RECEIVED\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_NAK_RECEIVED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_NAK_R_ERR;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_ACK_NAK_TIMEOUT:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_ACK_NAK_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_ACK_NAK_TIMEOUT\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_NAK_R_ERR;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_DMA:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_DMA\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_DMA\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_ABORTED_TASK;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_SATA_LINK_TIMEOUT:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_SATA_LINK_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_SATA_LINK_TIMEOUT\n");
 		ts->resp = SAS_TASK_UNDELIVERED;
 		ts->stat = SAS_DEV_NO_RESPONSE;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_REJECTED_NCQ_MODE:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_REJECTED_NCQ_MODE\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_REJECTED_NCQ_MODE\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_UNDERRUN;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_OPEN_RETRY_TIMEOUT:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_OPEN_RETRY_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_OPEN_RETRY_TIMEOUT\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_TO;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_PORT_IN_RESET:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_PORT_IN_RESET\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_PORT_IN_RESET\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_DS_NON_OPERATIONAL:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_DS_NON_OPERATIONAL\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_DS_NON_OPERATIONAL\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
 		if (!t->uldd_task) {
@@ -2785,16 +2680,14 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		}
 		break;
 	case IO_DS_IN_RECOVERY:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_DS_IN_RECOVERY\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_DS_IN_RECOVERY\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_DS_IN_ERROR:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_DS_IN_ERROR\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_DS_IN_ERROR\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
 		if (!t->uldd_task) {
@@ -2807,8 +2700,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		}
 		break;
 	case IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
@@ -2816,8 +2709,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	default:
-		PM8001_DEVIO_DBG(pm8001_ha,
-			pm8001_printk("Unknown status 0x%x\n", status));
+		pm8001_dbg(pm8001_ha, DEVIO, "Unknown status 0x%x\n", status);
 		/* not allowed case. Therefore, return failed status */
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
@@ -2831,10 +2723,9 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	t->task_state_flags |= SAS_TASK_STATE_DONE;
 	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("task 0x%p done with io_status 0x%x"
-			" resp 0x%x stat 0x%x but aborted by upper layer!\n",
-			t, status, ts->resp, ts->stat));
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
+			   t, status, ts->resp, ts->stat);
 		if (t->slow_task)
 			complete(&t->slow_task->completion);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
@@ -2865,13 +2756,11 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		t = ccb->task;
 		pm8001_dev = ccb->device;
 	} else {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("No CCB !!!. returning\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "No CCB !!!. returning\n");
 		return;
 	}
 	if (event)
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("SATA EVENT 0x%x\n", event));
+		pm8001_dbg(pm8001_ha, FAIL, "SATA EVENT 0x%x\n", event);
 
 	/* Check if this is NCQ error */
 	if (event == IO_XFER_ERROR_ABORTED_NCQ_MODE) {
@@ -2884,18 +2773,16 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 	}
 
 	if (unlikely(!t || !t->lldd_task || !t->dev)) {
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("task or dev null\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "task or dev null\n");
 		return;
 	}
 
 	ts = &t->task_status;
-	PM8001_IOERR_DBG(pm8001_ha,
-		pm8001_printk("port_id:0x%x, tag:0x%x, event:0x%x\n",
-				port_id, tag, event));
+	pm8001_dbg(pm8001_ha, IOERR, "port_id:0x%x, tag:0x%x, event:0x%x\n",
+		   port_id, tag, event);
 	switch (event) {
 	case IO_OVERFLOW:
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_UNDERFLOW\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_UNDERFLOW\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
 		ts->residual = 0;
@@ -2903,35 +2790,32 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_BREAK:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_BREAK\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_BREAK\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_INTERRUPTED;
 		break;
 	case IO_XFER_ERROR_PHY_NOT_READY:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_PHY_NOT_READY\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_PHY_NOT_READY\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
 		break;
 	case IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED:
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
-			"IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_EPROTO;
 		break;
 	case IO_OPEN_CNX_ERROR_ZONE_VIOLATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_ZONE_VIOLATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_ZONE_VIOLATION\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_UNKNOWN;
 		break;
 	case IO_OPEN_CNX_ERROR_BREAK:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_BREAK\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_BREAK\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_CONT0;
@@ -2942,8 +2826,8 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS_NO_DEST:
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS_OPEN_COLLIDE:
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS_PATHWAY_BLOCKED:
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n"));
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n");
 		ts->resp = SAS_TASK_UNDELIVERED;
 		ts->stat = SAS_DEV_NO_RESPONSE;
 		if (!t->uldd_task) {
@@ -2957,107 +2841,96 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		}
 		break;
 	case IO_OPEN_CNX_ERROR_BAD_DESTINATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_BAD_DESTINATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_BAD_DESTINATION\n");
 		ts->resp = SAS_TASK_UNDELIVERED;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_BAD_DEST;
 		break;
 	case IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED:
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
-			"IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_CONN_RATE;
 		break;
 	case IO_OPEN_CNX_ERROR_WRONG_DESTINATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_WRONG_DESTINATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_WRONG_DESTINATION\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_WRONG_DEST;
 		break;
 	case IO_XFER_ERROR_NAK_RECEIVED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_NAK_RECEIVED\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_NAK_RECEIVED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_NAK_R_ERR;
 		break;
 	case IO_XFER_ERROR_PEER_ABORTED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_PEER_ABORTED\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_PEER_ABORTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_NAK_R_ERR;
 		break;
 	case IO_XFER_ERROR_REJECTED_NCQ_MODE:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_REJECTED_NCQ_MODE\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_REJECTED_NCQ_MODE\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_UNDERRUN;
 		break;
 	case IO_XFER_OPEN_RETRY_TIMEOUT:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_OPEN_RETRY_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_OPEN_RETRY_TIMEOUT\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_TO;
 		break;
 	case IO_XFER_ERROR_UNEXPECTED_PHASE:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_UNEXPECTED_PHASE\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_UNEXPECTED_PHASE\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_TO;
 		break;
 	case IO_XFER_ERROR_XFER_RDY_OVERRUN:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_XFER_RDY_OVERRUN\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_XFER_RDY_OVERRUN\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_TO;
 		break;
 	case IO_XFER_ERROR_XFER_RDY_NOT_EXPECTED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_XFER_RDY_NOT_EXPECTED\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_XFER_ERROR_XFER_RDY_NOT_EXPECTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_TO;
 		break;
 	case IO_XFER_ERROR_OFFSET_MISMATCH:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_OFFSET_MISMATCH\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_OFFSET_MISMATCH\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_TO;
 		break;
 	case IO_XFER_ERROR_XFER_ZERO_DATA_LEN:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_XFER_ZERO_DATA_LEN\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_XFER_ERROR_XFER_ZERO_DATA_LEN\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_TO;
 		break;
 	case IO_XFER_CMD_FRAME_ISSUED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_CMD_FRAME_ISSUED\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_CMD_FRAME_ISSUED\n");
 		break;
 	case IO_XFER_PIO_SETUP_ERROR:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_PIO_SETUP_ERROR\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_PIO_SETUP_ERROR\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_TO;
 		break;
 	case IO_XFER_ERROR_INTERNAL_CRC_ERROR:
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("IO_XFR_ERROR_INTERNAL_CRC_ERROR\n"));
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "IO_XFR_ERROR_INTERNAL_CRC_ERROR\n");
 		/* TBC: used default set values */
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_TO;
 		break;
 	case IO_XFER_DMA_ACTIVATE_TIMEOUT:
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("IO_XFR_DMA_ACTIVATE_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "IO_XFR_DMA_ACTIVATE_TIMEOUT\n");
 		/* TBC: used default set values */
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_TO;
 		break;
 	default:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("Unknown status 0x%x\n", event));
+		pm8001_dbg(pm8001_ha, IO, "Unknown status 0x%x\n", event);
 		/* not allowed case. Therefore, return failed status */
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_TO;
@@ -3069,10 +2942,9 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 	t->task_state_flags |= SAS_TASK_STATE_DONE;
 	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("task 0x%p done with io_status 0x%x"
-			" resp 0x%x stat 0x%x but aborted by upper layer!\n",
-			t, event, ts->resp, ts->stat));
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
+			   t, event, ts->resp, ts->stat);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
@@ -3105,48 +2977,45 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	ts = &t->task_status;
 	pm8001_dev = ccb->device;
 	if (status)
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("smp IO status 0x%x\n", status));
+		pm8001_dbg(pm8001_ha, FAIL, "smp IO status 0x%x\n", status);
 	if (unlikely(!t || !t->lldd_task || !t->dev))
 		return;
 
-	PM8001_DEV_DBG(pm8001_ha,
-		pm8001_printk("tag::0x%x status::0x%x\n", tag, status));
+	pm8001_dbg(pm8001_ha, DEV, "tag::0x%x status::0x%x\n", tag, status);
 
 	switch (status) {
 
 	case IO_SUCCESS:
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_SUCCESS\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAM_STAT_GOOD;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		if (pm8001_ha->smp_exp_mode == SMP_DIRECT) {
-			PM8001_IO_DBG(pm8001_ha,
-				pm8001_printk("DIRECT RESPONSE Length:%d\n",
-						param));
+			pm8001_dbg(pm8001_ha, IO,
+				   "DIRECT RESPONSE Length:%d\n",
+				   param);
 			pdma_respaddr = (char *)(phys_to_virt(cpu_to_le64
 						((u64)sg_dma_address
 						(&t->smp_task.smp_resp))));
 			for (i = 0; i < param; i++) {
 				*(pdma_respaddr+i) = psmpPayload->_r_a[i];
-				PM8001_IO_DBG(pm8001_ha, pm8001_printk(
-					"SMP Byte%d DMA data 0x%x psmp 0x%x\n",
-					i, *(pdma_respaddr+i),
-					psmpPayload->_r_a[i]));
+				pm8001_dbg(pm8001_ha, IO,
+					   "SMP Byte%d DMA data 0x%x psmp 0x%x\n",
+					   i, *(pdma_respaddr + i),
+					   psmpPayload->_r_a[i]);
 			}
 		}
 		break;
 	case IO_ABORTED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_ABORTED IOMB\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_ABORTED IOMB\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_ABORTED_TASK;
 		if (pm8001_dev)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_OVERFLOW:
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_UNDERFLOW\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_UNDERFLOW\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
 		ts->residual = 0;
@@ -3154,45 +3023,41 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_NO_DEVICE:
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_NO_DEVICE\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_NO_DEVICE\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_PHY_DOWN;
 		break;
 	case IO_ERROR_HW_TIMEOUT:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_ERROR_HW_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_ERROR_HW_TIMEOUT\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAM_STAT_BUSY;
 		break;
 	case IO_XFER_ERROR_BREAK:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_BREAK\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_BREAK\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAM_STAT_BUSY;
 		break;
 	case IO_XFER_ERROR_PHY_NOT_READY:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_PHY_NOT_READY\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_PHY_NOT_READY\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAM_STAT_BUSY;
 		break;
 	case IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED:
-		PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk("IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_UNKNOWN;
 		break;
 	case IO_OPEN_CNX_ERROR_ZONE_VIOLATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_ZONE_VIOLATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_ZONE_VIOLATION\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_UNKNOWN;
 		break;
 	case IO_OPEN_CNX_ERROR_BREAK:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_BREAK\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_BREAK\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_CONT0;
@@ -3203,8 +3068,7 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS_NO_DEST:
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS_OPEN_COLLIDE:
 	case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS_PATHWAY_BLOCKED:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_UNKNOWN;
@@ -3213,75 +3077,68 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 		break;
 	case IO_OPEN_CNX_ERROR_BAD_DESTINATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_BAD_DESTINATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_BAD_DESTINATION\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_BAD_DEST;
 		break;
 	case IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED:
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk(\
-			"IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_CONNECTION_RATE_NOT_SUPPORTED\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_CONN_RATE;
 		break;
 	case IO_OPEN_CNX_ERROR_WRONG_DESTINATION:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_WRONG_DESTINATION\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_WRONG_DESTINATION\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_WRONG_DEST;
 		break;
 	case IO_XFER_ERROR_RX_FRAME:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_ERROR_RX_FRAME\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_RX_FRAME\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
 		break;
 	case IO_XFER_OPEN_RETRY_TIMEOUT:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_XFER_OPEN_RETRY_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_XFER_OPEN_RETRY_TIMEOUT\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
 		break;
 	case IO_ERROR_INTERNAL_SMP_RESOURCE:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_ERROR_INTERNAL_SMP_RESOURCE\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_ERROR_INTERNAL_SMP_RESOURCE\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_QUEUE_FULL;
 		break;
 	case IO_PORT_IN_RESET:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_PORT_IN_RESET\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_PORT_IN_RESET\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
 		break;
 	case IO_DS_NON_OPERATIONAL:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_DS_NON_OPERATIONAL\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_DS_NON_OPERATIONAL\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
 		break;
 	case IO_DS_IN_RECOVERY:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_DS_IN_RECOVERY\n"));
+		pm8001_dbg(pm8001_ha, IO, "IO_DS_IN_RECOVERY\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
 		break;
 	case IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY:
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY\n"));
+		pm8001_dbg(pm8001_ha, IO,
+			   "IO_OPEN_CNX_ERROR_HW_RESOURCE_BUSY\n");
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
 		break;
 	default:
-		PM8001_DEVIO_DBG(pm8001_ha,
-			pm8001_printk("Unknown status 0x%x\n", status));
+		pm8001_dbg(pm8001_ha, DEVIO, "Unknown status 0x%x\n", status);
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
 		/* not allowed case. Therefore, return failed status */
@@ -3293,10 +3150,9 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	t->task_state_flags |= SAS_TASK_STATE_DONE;
 	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
-			"task 0x%p done with io_status 0x%x resp 0x%x"
-			"stat 0x%x but aborted by upper layer!\n",
-			t, status, ts->resp, ts->stat));
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "task 0x%p done with io_status 0x%x resp 0x%xstat 0x%x but aborted by upper layer!\n",
+			   t, status, ts->resp, ts->stat);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
@@ -3393,38 +3249,34 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	port->port_state = portstate;
 	port->wide_port_phymap |= (1U << phy_id);
 	phy->phy_state = PHY_STATE_LINK_UP_SPCV;
-	PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
-		"portid:%d; phyid:%d; linkrate:%d; "
-		"portstate:%x; devicetype:%x\n",
-		port_id, phy_id, link_rate, portstate, deviceType));
+	pm8001_dbg(pm8001_ha, MSG,
+		   "portid:%d; phyid:%d; linkrate:%d; portstate:%x; devicetype:%x\n",
+		   port_id, phy_id, link_rate, portstate, deviceType);
 
 	switch (deviceType) {
 	case SAS_PHY_UNUSED:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("device type no device.\n"));
+		pm8001_dbg(pm8001_ha, MSG, "device type no device.\n");
 		break;
 	case SAS_END_DEVICE:
-		PM8001_MSG_DBG(pm8001_ha, pm8001_printk("end device.\n"));
+		pm8001_dbg(pm8001_ha, MSG, "end device.\n");
 		pm80xx_chip_phy_ctl_req(pm8001_ha, phy_id,
 			PHY_NOTIFY_ENABLE_SPINUP);
 		port->port_attached = 1;
 		pm8001_get_lrate_mode(phy, link_rate);
 		break;
 	case SAS_EDGE_EXPANDER_DEVICE:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("expander device.\n"));
+		pm8001_dbg(pm8001_ha, MSG, "expander device.\n");
 		port->port_attached = 1;
 		pm8001_get_lrate_mode(phy, link_rate);
 		break;
 	case SAS_FANOUT_EXPANDER_DEVICE:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("fanout expander device.\n"));
+		pm8001_dbg(pm8001_ha, MSG, "fanout expander device.\n");
 		port->port_attached = 1;
 		pm8001_get_lrate_mode(phy, link_rate);
 		break;
 	default:
-		PM8001_DEVIO_DBG(pm8001_ha,
-			pm8001_printk("unknown device type(%x)\n", deviceType));
+		pm8001_dbg(pm8001_ha, DEVIO, "unknown device type(%x)\n",
+			   deviceType);
 		break;
 	}
 	phy->phy_type |= PORT_TYPE_SAS;
@@ -3472,9 +3324,9 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	struct sas_ha_struct *sas_ha = pm8001_ha->sas;
 	struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
 	unsigned long flags;
-	PM8001_DEVIO_DBG(pm8001_ha, pm8001_printk(
-		"port id %d, phy id %d link_rate %d portstate 0x%x\n",
-				port_id, phy_id, link_rate, portstate));
+	pm8001_dbg(pm8001_ha, DEVIO,
+		   "port id %d, phy id %d link_rate %d portstate 0x%x\n",
+		   port_id, phy_id, link_rate, portstate);
 
 	port->port_state = portstate;
 	phy->phy_state = PHY_STATE_LINK_UP_SPCV;
@@ -3524,10 +3376,10 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	case PORT_VALID:
 		break;
 	case PORT_INVALID:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" PortInvalid portID %d\n", port_id));
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" Last phy Down and port invalid\n"));
+		pm8001_dbg(pm8001_ha, MSG, " PortInvalid portID %d\n",
+			   port_id);
+		pm8001_dbg(pm8001_ha, MSG,
+			   " Last phy Down and port invalid\n");
 		if (port_sata) {
 			phy->phy_type = 0;
 			port->port_attached = 0;
@@ -3537,19 +3389,18 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		sas_phy_disconnected(&phy->sas_phy);
 		break;
 	case PORT_IN_RESET:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" Port In Reset portID %d\n", port_id));
+		pm8001_dbg(pm8001_ha, MSG, " Port In Reset portID %d\n",
+			   port_id);
 		break;
 	case PORT_NOT_ESTABLISHED:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" Phy Down and PORT_NOT_ESTABLISHED\n"));
+		pm8001_dbg(pm8001_ha, MSG,
+			   " Phy Down and PORT_NOT_ESTABLISHED\n");
 		port->port_attached = 0;
 		break;
 	case PORT_LOSTCOMM:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" Phy Down and PORT_LOSTCOMM\n"));
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" Last phy Down and port invalid\n"));
+		pm8001_dbg(pm8001_ha, MSG, " Phy Down and PORT_LOSTCOMM\n");
+		pm8001_dbg(pm8001_ha, MSG,
+			   " Last phy Down and port invalid\n");
 		if (port_sata) {
 			port->port_attached = 0;
 			phy->phy_type = 0;
@@ -3560,9 +3411,9 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		break;
 	default:
 		port->port_attached = 0;
-		PM8001_DEVIO_DBG(pm8001_ha,
-			pm8001_printk(" Phy Down and(default) = 0x%x\n",
-			portstate));
+		pm8001_dbg(pm8001_ha, DEVIO,
+			   " Phy Down and(default) = 0x%x\n",
+			   portstate);
 		break;
 
 	}
@@ -3583,9 +3434,9 @@ static int mpi_phy_start_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		le32_to_cpu(pPayload->phyid);
 	struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
 
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("phy start resp status:0x%x, phyid:0x%x\n",
-				status, phy_id));
+	pm8001_dbg(pm8001_ha, INIT,
+		   "phy start resp status:0x%x, phyid:0x%x\n",
+		   status, phy_id);
 	if (status == 0) {
 		phy->phy_state = PHY_LINK_DOWN;
 		if (pm8001_ha->flags == PM8001F_RUN_TIME &&
@@ -3612,18 +3463,18 @@ static int mpi_thermal_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	u32 rht_lht = le32_to_cpu(pPayload->rht_lht);
 
 	if (thermal_event & 0x40) {
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
-			"Thermal Event: Local high temperature violated!\n"));
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
-			"Thermal Event: Measured local high temperature %d\n",
-				((rht_lht & 0xFF00) >> 8)));
+		pm8001_dbg(pm8001_ha, IO,
+			   "Thermal Event: Local high temperature violated!\n");
+		pm8001_dbg(pm8001_ha, IO,
+			   "Thermal Event: Measured local high temperature %d\n",
+			   ((rht_lht & 0xFF00) >> 8));
 	}
 	if (thermal_event & 0x10) {
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
-			"Thermal Event: Remote high temperature violated!\n"));
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
-			"Thermal Event: Measured remote high temperature %d\n",
-				((rht_lht & 0xFF000000) >> 24)));
+		pm8001_dbg(pm8001_ha, IO,
+			   "Thermal Event: Remote high temperature violated!\n");
+		pm8001_dbg(pm8001_ha, IO,
+			   "Thermal Event: Measured remote high temperature %d\n",
+			   ((rht_lht & 0xFF000000) >> 24));
 	}
 	return 0;
 }
@@ -3652,42 +3503,36 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
 	struct pm8001_port *port = &pm8001_ha->port[port_id];
 	struct asd_sas_phy *sas_phy = sas_ha->sas_phy[phy_id];
-	PM8001_DEV_DBG(pm8001_ha,
-		pm8001_printk("portid:%d phyid:%d event:0x%x status:0x%x\n",
-				port_id, phy_id, eventType, status));
+	pm8001_dbg(pm8001_ha, DEV,
+		   "portid:%d phyid:%d event:0x%x status:0x%x\n",
+		   port_id, phy_id, eventType, status);
 
 	switch (eventType) {
 
 	case HW_EVENT_SAS_PHY_UP:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_PHY_START_STATUS\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_START_STATUS\n");
 		hw_event_sas_phy_up(pm8001_ha, piomb);
 		break;
 	case HW_EVENT_SATA_PHY_UP:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_SATA_PHY_UP\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_SATA_PHY_UP\n");
 		hw_event_sata_phy_up(pm8001_ha, piomb);
 		break;
 	case HW_EVENT_SATA_SPINUP_HOLD:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_SATA_SPINUP_HOLD\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_SATA_SPINUP_HOLD\n");
 		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_SPINUP_HOLD);
 		break;
 	case HW_EVENT_PHY_DOWN:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_PHY_DOWN\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_DOWN\n");
 		hw_event_phy_down(pm8001_ha, piomb);
 		if (pm8001_ha->reset_in_progress) {
-			PM8001_MSG_DBG(pm8001_ha,
-				pm8001_printk("Reset in progress\n"));
+			pm8001_dbg(pm8001_ha, MSG, "Reset in progress\n");
 			return 0;
 		}
 		phy->phy_attached = 0;
 		phy->phy_state = PHY_LINK_DISABLE;
 		break;
 	case HW_EVENT_PORT_INVALID:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_PORT_INVALID\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_INVALID\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
 		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
@@ -3695,8 +3540,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	/* the broadcast change primitive received, tell the LIBSAS this event
 	to revalidate the sas domain*/
 	case HW_EVENT_BROADCAST_CHANGE:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_BROADCAST_CHANGE\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_BROADCAST_CHANGE\n");
 		pm80xx_hw_event_ack_req(pm8001_ha, 0, HW_EVENT_BROADCAST_CHANGE,
 			port_id, phy_id, 1, 0);
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
@@ -3705,81 +3549,74 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
 		break;
 	case HW_EVENT_PHY_ERROR:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_PHY_ERROR\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_ERROR\n");
 		sas_phy_disconnected(&phy->sas_phy);
 		phy->phy_attached = 0;
 		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_OOB_ERROR);
 		break;
 	case HW_EVENT_BROADCAST_EXP:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_BROADCAST_EXP\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_BROADCAST_EXP\n");
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_EXP;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
 		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
 		break;
 	case HW_EVENT_LINK_ERR_INVALID_DWORD:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_LINK_ERR_INVALID_DWORD\n"));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "HW_EVENT_LINK_ERR_INVALID_DWORD\n");
 		pm80xx_hw_event_ack_req(pm8001_ha, 0,
 			HW_EVENT_LINK_ERR_INVALID_DWORD, port_id, phy_id, 0, 0);
 		break;
 	case HW_EVENT_LINK_ERR_DISPARITY_ERROR:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_LINK_ERR_DISPARITY_ERROR\n"));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "HW_EVENT_LINK_ERR_DISPARITY_ERROR\n");
 		pm80xx_hw_event_ack_req(pm8001_ha, 0,
 			HW_EVENT_LINK_ERR_DISPARITY_ERROR,
 			port_id, phy_id, 0, 0);
 		break;
 	case HW_EVENT_LINK_ERR_CODE_VIOLATION:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_LINK_ERR_CODE_VIOLATION\n"));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "HW_EVENT_LINK_ERR_CODE_VIOLATION\n");
 		pm80xx_hw_event_ack_req(pm8001_ha, 0,
 			HW_EVENT_LINK_ERR_CODE_VIOLATION,
 			port_id, phy_id, 0, 0);
 		break;
 	case HW_EVENT_LINK_ERR_LOSS_OF_DWORD_SYNCH:
-		PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
-				"HW_EVENT_LINK_ERR_LOSS_OF_DWORD_SYNCH\n"));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "HW_EVENT_LINK_ERR_LOSS_OF_DWORD_SYNCH\n");
 		pm80xx_hw_event_ack_req(pm8001_ha, 0,
 			HW_EVENT_LINK_ERR_LOSS_OF_DWORD_SYNCH,
 			port_id, phy_id, 0, 0);
 		break;
 	case HW_EVENT_MALFUNCTION:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_MALFUNCTION\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_MALFUNCTION\n");
 		break;
 	case HW_EVENT_BROADCAST_SES:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_BROADCAST_SES\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_BROADCAST_SES\n");
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_SES;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
 		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
 		break;
 	case HW_EVENT_INBOUND_CRC_ERROR:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_INBOUND_CRC_ERROR\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_INBOUND_CRC_ERROR\n");
 		pm80xx_hw_event_ack_req(pm8001_ha, 0,
 			HW_EVENT_INBOUND_CRC_ERROR,
 			port_id, phy_id, 0, 0);
 		break;
 	case HW_EVENT_HARD_RESET_RECEIVED:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_HARD_RESET_RECEIVED\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_HARD_RESET_RECEIVED\n");
 		sas_ha->notify_port_event(sas_phy, PORTE_HARD_RESET);
 		break;
 	case HW_EVENT_ID_FRAME_TIMEOUT:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_ID_FRAME_TIMEOUT\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_ID_FRAME_TIMEOUT\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
 		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_LINK_ERR_PHY_RESET_FAILED:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_LINK_ERR_PHY_RESET_FAILED\n"));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "HW_EVENT_LINK_ERR_PHY_RESET_FAILED\n");
 		pm80xx_hw_event_ack_req(pm8001_ha, 0,
 			HW_EVENT_LINK_ERR_PHY_RESET_FAILED,
 			port_id, phy_id, 0, 0);
@@ -3788,8 +3625,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_PORT_RESET_TIMER_TMO:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_PORT_RESET_TIMER_TMO\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_RESET_TIMER_TMO\n");
 		pm80xx_hw_event_ack_req(pm8001_ha, 0, HW_EVENT_PHY_DOWN,
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
@@ -3803,8 +3639,8 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		}
 		break;
 	case HW_EVENT_PORT_RECOVERY_TIMER_TMO:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_PORT_RECOVERY_TIMER_TMO\n"));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "HW_EVENT_PORT_RECOVERY_TIMER_TMO\n");
 		pm80xx_hw_event_ack_req(pm8001_ha, 0,
 			HW_EVENT_PORT_RECOVERY_TIMER_TMO,
 			port_id, phy_id, 0, 0);
@@ -3818,13 +3654,11 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		}
 		break;
 	case HW_EVENT_PORT_RECOVER:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_PORT_RECOVER\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_RECOVER\n");
 		hw_event_port_recover(pm8001_ha, piomb);
 		break;
 	case HW_EVENT_PORT_RESET_COMPLETE:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("HW_EVENT_PORT_RESET_COMPLETE\n"));
+		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_RESET_COMPLETE\n");
 		if (pm8001_ha->phy[phy_id].reset_completion) {
 			pm8001_ha->phy[phy_id].port_reset_status =
 					PORT_RESET_SUCCESS;
@@ -3833,12 +3667,11 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		}
 		break;
 	case EVENT_BROADCAST_ASYNCH_EVENT:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("EVENT_BROADCAST_ASYNCH_EVENT\n"));
+		pm8001_dbg(pm8001_ha, MSG, "EVENT_BROADCAST_ASYNCH_EVENT\n");
 		break;
 	default:
-		PM8001_DEVIO_DBG(pm8001_ha,
-			pm8001_printk("Unknown event type 0x%x\n", eventType));
+		pm8001_dbg(pm8001_ha, DEVIO, "Unknown event type 0x%x\n",
+			   eventType);
 		break;
 	}
 	return 0;
@@ -3858,9 +3691,8 @@ static int mpi_phy_stop_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	u32 phyid =
 		le32_to_cpu(pPayload->phyid) & 0xFF;
 	struct pm8001_phy *phy = &pm8001_ha->phy[phyid];
-	PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("phy:0x%x status:0x%x\n",
-					phyid, status));
+	pm8001_dbg(pm8001_ha, MSG, "phy:0x%x status:0x%x\n",
+		   phyid, status);
 	if (status == PHY_STOP_SUCCESS ||
 		status == PHY_STOP_ERR_DEVICE_ATTACHED)
 		phy->phy_state = PHY_LINK_DISABLE;
@@ -3880,9 +3712,9 @@ static int mpi_set_controller_config_resp(struct pm8001_hba_info *pm8001_ha,
 	u32 status = le32_to_cpu(pPayload->status);
 	u32 err_qlfr_pgcd = le32_to_cpu(pPayload->err_qlfr_pgcd);
 
-	PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
-			"SET CONTROLLER RESP: status 0x%x qlfr_pgcd 0x%x\n",
-			status, err_qlfr_pgcd));
+	pm8001_dbg(pm8001_ha, MSG,
+		   "SET CONTROLLER RESP: status 0x%x qlfr_pgcd 0x%x\n",
+		   status, err_qlfr_pgcd);
 
 	return 0;
 }
@@ -3895,8 +3727,7 @@ static int mpi_set_controller_config_resp(struct pm8001_hba_info *pm8001_ha,
 static int mpi_get_controller_config_resp(struct pm8001_hba_info *pm8001_ha,
 			void *piomb)
 {
-	PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" pm80xx_addition_functionality\n"));
+	pm8001_dbg(pm8001_ha, MSG, " pm80xx_addition_functionality\n");
 
 	return 0;
 }
@@ -3909,8 +3740,7 @@ static int mpi_get_controller_config_resp(struct pm8001_hba_info *pm8001_ha,
 static int mpi_get_phy_profile_resp(struct pm8001_hba_info *pm8001_ha,
 			void *piomb)
 {
-	PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" pm80xx_addition_functionality\n"));
+	pm8001_dbg(pm8001_ha, MSG, " pm80xx_addition_functionality\n");
 
 	return 0;
 }
@@ -3922,8 +3752,7 @@ static int mpi_get_phy_profile_resp(struct pm8001_hba_info *pm8001_ha,
  */
 static int mpi_flash_op_ext_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 {
-	PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" pm80xx_addition_functionality\n"));
+	pm8001_dbg(pm8001_ha, MSG, " pm80xx_addition_functionality\n");
 
 	return 0;
 }
@@ -3948,15 +3777,14 @@ static int mpi_set_phy_profile_resp(struct pm8001_hba_info *pm8001_ha,
 	page_code = (u8)((ppc_phyid & 0xFF00) >> 8);
 	if (status) {
 		/* status is FAILED */
-		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("PhyProfile command failed  with status "
-			"0x%08X \n", status));
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "PhyProfile command failed  with status 0x%08X\n",
+			   status);
 		rc = -1;
 	} else {
 		if (page_code != SAS_PHY_ANALOG_SETTINGS_PAGE) {
-			PM8001_FAIL_DBG(pm8001_ha,
-				pm8001_printk("Invalid page code 0x%X\n",
-					page_code));
+			pm8001_dbg(pm8001_ha, FAIL, "Invalid page code 0x%X\n",
+				   page_code);
 			rc = -1;
 		}
 	}
@@ -3978,9 +3806,9 @@ static int mpi_kek_management_resp(struct pm8001_hba_info *pm8001_ha,
 	u32 kidx_new_curr_ksop = le32_to_cpu(pPayload->kidx_new_curr_ksop);
 	u32 err_qlfr = le32_to_cpu(pPayload->err_qlfr);
 
-	PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
-		"KEK MGMT RESP. Status 0x%x idx_ksop 0x%x err_qlfr 0x%x\n",
-		status, kidx_new_curr_ksop, err_qlfr));
+	pm8001_dbg(pm8001_ha, MSG,
+		   "KEK MGMT RESP. Status 0x%x idx_ksop 0x%x err_qlfr 0x%x\n",
+		   status, kidx_new_curr_ksop, err_qlfr);
 
 	return 0;
 }
@@ -3993,8 +3821,7 @@ static int mpi_kek_management_resp(struct pm8001_hba_info *pm8001_ha,
 static int mpi_dek_management_resp(struct pm8001_hba_info *pm8001_ha,
 			void *piomb)
 {
-	PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" pm80xx_addition_functionality\n"));
+	pm8001_dbg(pm8001_ha, MSG, " pm80xx_addition_functionality\n");
 
 	return 0;
 }
@@ -4007,8 +3834,7 @@ static int mpi_dek_management_resp(struct pm8001_hba_info *pm8001_ha,
 static int ssp_coalesced_comp_resp(struct pm8001_hba_info *pm8001_ha,
 			void *piomb)
 {
-	PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" pm80xx_addition_functionality\n"));
+	pm8001_dbg(pm8001_ha, MSG, " pm80xx_addition_functionality\n");
 
 	return 0;
 }
@@ -4025,248 +3851,206 @@ static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void *piomb)
 
 	switch (opc) {
 	case OPC_OUB_ECHO:
-		PM8001_MSG_DBG(pm8001_ha, pm8001_printk("OPC_OUB_ECHO\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_ECHO\n");
 		break;
 	case OPC_OUB_HW_EVENT:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_HW_EVENT\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_HW_EVENT\n");
 		mpi_hw_event(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_THERM_HW_EVENT:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_THERMAL_EVENT\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_THERMAL_EVENT\n");
 		mpi_thermal_hw_event(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SSP_COMP:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SSP_COMP\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SSP_COMP\n");
 		mpi_ssp_completion(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SMP_COMP:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SMP_COMP\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SMP_COMP\n");
 		mpi_smp_completion(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_LOCAL_PHY_CNTRL:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_LOCAL_PHY_CNTRL\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_LOCAL_PHY_CNTRL\n");
 		pm8001_mpi_local_phy_ctl(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_DEV_REGIST:
-		PM8001_MSG_DBG(pm8001_ha,
-		pm8001_printk("OPC_OUB_DEV_REGIST\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_DEV_REGIST\n");
 		pm8001_mpi_reg_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_DEREG_DEV:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("unregister the device\n"));
+		pm8001_dbg(pm8001_ha, MSG, "unregister the device\n");
 		pm8001_mpi_dereg_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_GET_DEV_HANDLE:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_GET_DEV_HANDLE\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_GET_DEV_HANDLE\n");
 		break;
 	case OPC_OUB_SATA_COMP:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SATA_COMP\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SATA_COMP\n");
 		mpi_sata_completion(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SATA_EVENT:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SATA_EVENT\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SATA_EVENT\n");
 		mpi_sata_event(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SSP_EVENT:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SSP_EVENT\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SSP_EVENT\n");
 		mpi_ssp_event(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_DEV_HANDLE_ARRIV:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_DEV_HANDLE_ARRIV\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_DEV_HANDLE_ARRIV\n");
 		/*This is for target*/
 		break;
 	case OPC_OUB_SSP_RECV_EVENT:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SSP_RECV_EVENT\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SSP_RECV_EVENT\n");
 		/*This is for target*/
 		break;
 	case OPC_OUB_FW_FLASH_UPDATE:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_FW_FLASH_UPDATE\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_FW_FLASH_UPDATE\n");
 		pm8001_mpi_fw_flash_update_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_GPIO_RESPONSE:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_GPIO_RESPONSE\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_GPIO_RESPONSE\n");
 		break;
 	case OPC_OUB_GPIO_EVENT:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_GPIO_EVENT\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_GPIO_EVENT\n");
 		break;
 	case OPC_OUB_GENERAL_EVENT:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_GENERAL_EVENT\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_GENERAL_EVENT\n");
 		pm8001_mpi_general_event(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SSP_ABORT_RSP:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SSP_ABORT_RSP\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SSP_ABORT_RSP\n");
 		pm8001_mpi_task_abort_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SATA_ABORT_RSP:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SATA_ABORT_RSP\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SATA_ABORT_RSP\n");
 		pm8001_mpi_task_abort_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SAS_DIAG_MODE_START_END:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SAS_DIAG_MODE_START_END\n"));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "OPC_OUB_SAS_DIAG_MODE_START_END\n");
 		break;
 	case OPC_OUB_SAS_DIAG_EXECUTE:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SAS_DIAG_EXECUTE\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SAS_DIAG_EXECUTE\n");
 		break;
 	case OPC_OUB_GET_TIME_STAMP:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_GET_TIME_STAMP\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_GET_TIME_STAMP\n");
 		break;
 	case OPC_OUB_SAS_HW_EVENT_ACK:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SAS_HW_EVENT_ACK\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SAS_HW_EVENT_ACK\n");
 		break;
 	case OPC_OUB_PORT_CONTROL:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_PORT_CONTROL\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_PORT_CONTROL\n");
 		break;
 	case OPC_OUB_SMP_ABORT_RSP:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SMP_ABORT_RSP\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SMP_ABORT_RSP\n");
 		pm8001_mpi_task_abort_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_GET_NVMD_DATA:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_GET_NVMD_DATA\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_GET_NVMD_DATA\n");
 		pm8001_mpi_get_nvmd_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SET_NVMD_DATA:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SET_NVMD_DATA\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SET_NVMD_DATA\n");
 		pm8001_mpi_set_nvmd_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_DEVICE_HANDLE_REMOVAL:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_DEVICE_HANDLE_REMOVAL\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_DEVICE_HANDLE_REMOVAL\n");
 		break;
 	case OPC_OUB_SET_DEVICE_STATE:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SET_DEVICE_STATE\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SET_DEVICE_STATE\n");
 		pm8001_mpi_set_dev_state_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_GET_DEVICE_STATE:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_GET_DEVICE_STATE\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_GET_DEVICE_STATE\n");
 		break;
 	case OPC_OUB_SET_DEV_INFO:
-		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("OPC_OUB_SET_DEV_INFO\n"));
+		pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SET_DEV_INFO\n");
 		break;
 	/* spcv specifc commands */
 	case OPC_OUB_PHY_START_RESP:
-		PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
-			"OPC_OUB_PHY_START_RESP opcode:%x\n", opc));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "OPC_OUB_PHY_START_RESP opcode:%x\n", opc);
 		mpi_phy_start_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_PHY_STOP_RESP:
-		PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
-			"OPC_OUB_PHY_STOP_RESP opcode:%x\n", opc));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "OPC_OUB_PHY_STOP_RESP opcode:%x\n", opc);
 		mpi_phy_stop_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SET_CONTROLLER_CONFIG:
-		PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
-			"OPC_OUB_SET_CONTROLLER_CONFIG opcode:%x\n", opc));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "OPC_OUB_SET_CONTROLLER_CONFIG opcode:%x\n", opc);
 		mpi_set_controller_config_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_GET_CONTROLLER_CONFIG:
-		PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
-			"OPC_OUB_GET_CONTROLLER_CONFIG opcode:%x\n", opc));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "OPC_OUB_GET_CONTROLLER_CONFIG opcode:%x\n", opc);
 		mpi_get_controller_config_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_GET_PHY_PROFILE:
-		PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
-			"OPC_OUB_GET_PHY_PROFILE opcode:%x\n", opc));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "OPC_OUB_GET_PHY_PROFILE opcode:%x\n", opc);
 		mpi_get_phy_profile_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_FLASH_OP_EXT:
-		PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
-			"OPC_OUB_FLASH_OP_EXT opcode:%x\n", opc));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "OPC_OUB_FLASH_OP_EXT opcode:%x\n", opc);
 		mpi_flash_op_ext_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SET_PHY_PROFILE:
-		PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
-			"OPC_OUB_SET_PHY_PROFILE opcode:%x\n", opc));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "OPC_OUB_SET_PHY_PROFILE opcode:%x\n", opc);
 		mpi_set_phy_profile_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_KEK_MANAGEMENT_RESP:
-		PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
-			"OPC_OUB_KEK_MANAGEMENT_RESP opcode:%x\n", opc));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "OPC_OUB_KEK_MANAGEMENT_RESP opcode:%x\n", opc);
 		mpi_kek_management_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_DEK_MANAGEMENT_RESP:
-		PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
-			"OPC_OUB_DEK_MANAGEMENT_RESP opcode:%x\n", opc));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "OPC_OUB_DEK_MANAGEMENT_RESP opcode:%x\n", opc);
 		mpi_dek_management_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_SSP_COALESCED_COMP_RESP:
-		PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
-			"OPC_OUB_SSP_COALESCED_COMP_RESP opcode:%x\n", opc));
+		pm8001_dbg(pm8001_ha, MSG,
+			   "OPC_OUB_SSP_COALESCED_COMP_RESP opcode:%x\n", opc);
 		ssp_coalesced_comp_resp(pm8001_ha, piomb);
 		break;
 	default:
-		PM8001_DEVIO_DBG(pm8001_ha, pm8001_printk(
-			"Unknown outbound Queue IOMB OPC = 0x%x\n", opc));
+		pm8001_dbg(pm8001_ha, DEVIO,
+			   "Unknown outbound Queue IOMB OPC = 0x%x\n", opc);
 		break;
 	}
 }
 
 static void print_scratchpad_registers(struct pm8001_hba_info *pm8001_ha)
 {
-	PM8001_FAIL_DBG(pm8001_ha,
-		pm8001_printk("MSGU_SCRATCH_PAD_0: 0x%x\n",
-			pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_0)));
-	PM8001_FAIL_DBG(pm8001_ha,
-		pm8001_printk("MSGU_SCRATCH_PAD_1:0x%x\n",
-			pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1)));
-	PM8001_FAIL_DBG(pm8001_ha,
-		pm8001_printk("MSGU_SCRATCH_PAD_2: 0x%x\n",
-			pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2)));
-	PM8001_FAIL_DBG(pm8001_ha,
-		pm8001_printk("MSGU_SCRATCH_PAD_3: 0x%x\n",
-			pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_3)));
-	PM8001_FAIL_DBG(pm8001_ha,
-		pm8001_printk("MSGU_HOST_SCRATCH_PAD_0: 0x%x\n",
-			pm8001_cr32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_0)));
-	PM8001_FAIL_DBG(pm8001_ha,
-		pm8001_printk("MSGU_HOST_SCRATCH_PAD_1: 0x%x\n",
-			pm8001_cr32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_1)));
-	PM8001_FAIL_DBG(pm8001_ha,
-		pm8001_printk("MSGU_HOST_SCRATCH_PAD_2: 0x%x\n",
-			pm8001_cr32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_2)));
-	PM8001_FAIL_DBG(pm8001_ha,
-		pm8001_printk("MSGU_HOST_SCRATCH_PAD_3: 0x%x\n",
-			pm8001_cr32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_3)));
-	PM8001_FAIL_DBG(pm8001_ha,
-		pm8001_printk("MSGU_HOST_SCRATCH_PAD_4: 0x%x\n",
-			pm8001_cr32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_4)));
-	PM8001_FAIL_DBG(pm8001_ha,
-		pm8001_printk("MSGU_HOST_SCRATCH_PAD_5: 0x%x\n",
-			pm8001_cr32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_5)));
-	PM8001_FAIL_DBG(pm8001_ha,
-		pm8001_printk("MSGU_RSVD_SCRATCH_PAD_0: 0x%x\n",
-			pm8001_cr32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_6)));
-	PM8001_FAIL_DBG(pm8001_ha,
-		pm8001_printk("MSGU_RSVD_SCRATCH_PAD_1: 0x%x\n",
-			pm8001_cr32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_7)));
+	pm8001_dbg(pm8001_ha, FAIL, "MSGU_SCRATCH_PAD_0: 0x%x\n",
+		   pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_0));
+	pm8001_dbg(pm8001_ha, FAIL, "MSGU_SCRATCH_PAD_1:0x%x\n",
+		   pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1));
+	pm8001_dbg(pm8001_ha, FAIL, "MSGU_SCRATCH_PAD_2: 0x%x\n",
+		   pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2));
+	pm8001_dbg(pm8001_ha, FAIL, "MSGU_SCRATCH_PAD_3: 0x%x\n",
+		   pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_3));
+	pm8001_dbg(pm8001_ha, FAIL, "MSGU_HOST_SCRATCH_PAD_0: 0x%x\n",
+		   pm8001_cr32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_0));
+	pm8001_dbg(pm8001_ha, FAIL, "MSGU_HOST_SCRATCH_PAD_1: 0x%x\n",
+		   pm8001_cr32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_1));
+	pm8001_dbg(pm8001_ha, FAIL, "MSGU_HOST_SCRATCH_PAD_2: 0x%x\n",
+		   pm8001_cr32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_2));
+	pm8001_dbg(pm8001_ha, FAIL, "MSGU_HOST_SCRATCH_PAD_3: 0x%x\n",
+		   pm8001_cr32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_3));
+	pm8001_dbg(pm8001_ha, FAIL, "MSGU_HOST_SCRATCH_PAD_4: 0x%x\n",
+		   pm8001_cr32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_4));
+	pm8001_dbg(pm8001_ha, FAIL, "MSGU_HOST_SCRATCH_PAD_5: 0x%x\n",
+		   pm8001_cr32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_5));
+	pm8001_dbg(pm8001_ha, FAIL, "MSGU_RSVD_SCRATCH_PAD_0: 0x%x\n",
+		   pm8001_cr32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_6));
+	pm8001_dbg(pm8001_ha, FAIL, "MSGU_RSVD_SCRATCH_PAD_1: 0x%x\n",
+		   pm8001_cr32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_7));
 }
 
 static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
@@ -4283,8 +4067,9 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
 		if ((regval & SCRATCH_PAD_MIPSALL_READY) !=
 					SCRATCH_PAD_MIPSALL_READY) {
 			pm8001_ha->controller_fatal_error = true;
-			PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
-				"Firmware Fatal error! Regval:0x%x\n", regval));
+			pm8001_dbg(pm8001_ha, FAIL,
+				   "Firmware Fatal error! Regval:0x%x\n",
+				   regval);
 			print_scratchpad_registers(pm8001_ha);
 			return ret;
 		}
@@ -4390,8 +4175,7 @@ static int pm80xx_chip_smp_req(struct pm8001_hba_info *pm8001_ha,
 	smp_cmd.tag = cpu_to_le32(ccb->ccb_tag);
 
 	length = sg_req->length;
-	PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk("SMP Frame Length %d\n", sg_req->length));
+	pm8001_dbg(pm8001_ha, IO, "SMP Frame Length %d\n", sg_req->length);
 	if (!(length - 8))
 		pm8001_ha->smp_exp_mode = SMP_DIRECT;
 	else
@@ -4403,8 +4187,7 @@ static int pm80xx_chip_smp_req(struct pm8001_hba_info *pm8001_ha,
 
 	/* INDIRECT MODE command settings. Use DMA */
 	if (pm8001_ha->smp_exp_mode == SMP_INDIRECT) {
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("SMP REQUEST INDIRECT MODE\n"));
+		pm8001_dbg(pm8001_ha, IO, "SMP REQUEST INDIRECT MODE\n");
 		/* for SPCv indirect mode. Place the top 4 bytes of
 		 * SMP Request header here. */
 		for (i = 0; i < 4; i++)
@@ -4436,21 +4219,20 @@ static int pm80xx_chip_smp_req(struct pm8001_hba_info *pm8001_ha,
 			((u32)sg_dma_len(&task->smp_task.smp_resp)-4);
 	}
 	if (pm8001_ha->smp_exp_mode == SMP_DIRECT) {
-		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("SMP REQUEST DIRECT MODE\n"));
+		pm8001_dbg(pm8001_ha, IO, "SMP REQUEST DIRECT MODE\n");
 		for (i = 0; i < length; i++)
 			if (i < 16) {
 				smp_cmd.smp_req16[i] = *(preq_dma_addr+i);
-				PM8001_IO_DBG(pm8001_ha, pm8001_printk(
-					"Byte[%d]:%x (DMA data:%x)\n",
-					i, smp_cmd.smp_req16[i],
-					*(preq_dma_addr)));
+				pm8001_dbg(pm8001_ha, IO,
+					   "Byte[%d]:%x (DMA data:%x)\n",
+					   i, smp_cmd.smp_req16[i],
+					   *(preq_dma_addr));
 			} else {
 				smp_cmd.smp_req[i] = *(preq_dma_addr+i);
-				PM8001_IO_DBG(pm8001_ha, pm8001_printk(
-					"Byte[%d]:%x (DMA data:%x)\n",
-					i, smp_cmd.smp_req[i],
-					*(preq_dma_addr)));
+				pm8001_dbg(pm8001_ha, IO,
+					   "Byte[%d]:%x (DMA data:%x)\n",
+					   i, smp_cmd.smp_req[i],
+					   *(preq_dma_addr));
 			}
 	}
 
@@ -4547,9 +4329,9 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 	/* Check if encryption is set */
 	if (pm8001_ha->chip->encrypt &&
 		!(pm8001_ha->encrypt_info.status) && check_enc_sas_cmd(task)) {
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
-			"Encryption enabled.Sending Encrypt SAS command 0x%x\n",
-			task->ssp_task.cmd->cmnd[0]));
+		pm8001_dbg(pm8001_ha, IO,
+			   "Encryption enabled.Sending Encrypt SAS command 0x%x\n",
+			   task->ssp_task.cmd->cmnd[0]);
 		opc = OPC_INB_SSP_INI_DIF_ENC_IO;
 		/* enable encryption. 0 for SAS 1.1 and SAS 2.0 compatible TLR*/
 		ssp_cmd.dad_dir_m_tlr =	cpu_to_le32
@@ -4579,13 +4361,10 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 			end_addr_low = cpu_to_le32(lower_32_bits(end_addr));
 			end_addr_high = cpu_to_le32(upper_32_bits(end_addr));
 			if (end_addr_high != ssp_cmd.enc_addr_high) {
-				PM8001_FAIL_DBG(pm8001_ha,
-					pm8001_printk("The sg list address "
-					"start_addr=0x%016llx data_len=0x%x "
-					"end_addr_high=0x%08x end_addr_low="
-					"0x%08x has crossed 4G boundary\n",
-						start_addr, ssp_cmd.enc_len,
-						end_addr_high, end_addr_low));
+				pm8001_dbg(pm8001_ha, FAIL,
+					   "The sg list address start_addr=0x%016llx data_len=0x%x end_addr_high=0x%08x end_addr_low=0x%08x has crossed 4G boundary\n",
+					   start_addr, ssp_cmd.enc_len,
+					   end_addr_high, end_addr_low);
 				pm8001_chip_make_sg(task->scatter, 1,
 					ccb->buf_prd);
 				phys_addr = ccb->ccb_dma_handle;
@@ -4609,9 +4388,9 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 						(task->ssp_task.cmd->cmnd[4] << 8) |
 						(task->ssp_task.cmd->cmnd[5]));
 	} else {
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
-			"Sending Normal SAS command 0x%x inb q %x\n",
-			task->ssp_task.cmd->cmnd[0], q_index));
+		pm8001_dbg(pm8001_ha, IO,
+			   "Sending Normal SAS command 0x%x inb q %x\n",
+			   task->ssp_task.cmd->cmnd[0], q_index);
 		/* fill in PRD (scatter/gather) table, if any */
 		if (task->num_scatter > 1) {
 			pm8001_chip_make_sg(task->scatter, ccb->n_elem,
@@ -4635,13 +4414,10 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 			end_addr_low = cpu_to_le32(lower_32_bits(end_addr));
 			end_addr_high = cpu_to_le32(upper_32_bits(end_addr));
 			if (end_addr_high != ssp_cmd.addr_high) {
-				PM8001_FAIL_DBG(pm8001_ha,
-					pm8001_printk("The sg list address "
-					"start_addr=0x%016llx data_len=0x%x "
-					"end_addr_high=0x%08x end_addr_low="
-					"0x%08x has crossed 4G boundary\n",
-						 start_addr, ssp_cmd.len,
-						 end_addr_high, end_addr_low));
+				pm8001_dbg(pm8001_ha, FAIL,
+					   "The sg list address start_addr=0x%016llx data_len=0x%x end_addr_high=0x%08x end_addr_low=0x%08x has crossed 4G boundary\n",
+					   start_addr, ssp_cmd.len,
+					   end_addr_high, end_addr_low);
 				pm8001_chip_make_sg(task->scatter, 1,
 					ccb->buf_prd);
 				phys_addr = ccb->ccb_dma_handle;
@@ -4688,19 +4464,19 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 
 	if (task->data_dir == DMA_NONE) {
 		ATAP = 0x04; /* no data*/
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk("no data\n"));
+		pm8001_dbg(pm8001_ha, IO, "no data\n");
 	} else if (likely(!task->ata_task.device_control_reg_update)) {
 		if (task->ata_task.dma_xfer) {
 			ATAP = 0x06; /* DMA */
-			PM8001_IO_DBG(pm8001_ha, pm8001_printk("DMA\n"));
+			pm8001_dbg(pm8001_ha, IO, "DMA\n");
 		} else {
 			ATAP = 0x05; /* PIO*/
-			PM8001_IO_DBG(pm8001_ha, pm8001_printk("PIO\n"));
+			pm8001_dbg(pm8001_ha, IO, "PIO\n");
 		}
 		if (task->ata_task.use_ncq &&
 		    dev->sata_dev.class != ATA_DEV_ATAPI) {
 			ATAP = 0x07; /* FPDMA */
-			PM8001_IO_DBG(pm8001_ha, pm8001_printk("FPDMA\n"));
+			pm8001_dbg(pm8001_ha, IO, "FPDMA\n");
 		}
 	}
 	if (task->ata_task.use_ncq && pm8001_get_ncq_tag(task, &hdr_tag)) {
@@ -4720,9 +4496,9 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	/* Check if encryption is set */
 	if (pm8001_ha->chip->encrypt &&
 		!(pm8001_ha->encrypt_info.status) && check_enc_sat_cmd(task)) {
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
-			"Encryption enabled.Sending Encrypt SATA cmd 0x%x\n",
-			sata_cmd.sata_fis.command));
+		pm8001_dbg(pm8001_ha, IO,
+			   "Encryption enabled.Sending Encrypt SATA cmd 0x%x\n",
+			   sata_cmd.sata_fis.command);
 		opc = OPC_INB_SATA_DIF_ENC_IO;
 
 		/* set encryption bit */
@@ -4750,13 +4526,10 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 			end_addr_low = cpu_to_le32(lower_32_bits(end_addr));
 			end_addr_high = cpu_to_le32(upper_32_bits(end_addr));
 			if (end_addr_high != sata_cmd.enc_addr_high) {
-				PM8001_FAIL_DBG(pm8001_ha,
-					pm8001_printk("The sg list address "
-					"start_addr=0x%016llx data_len=0x%x "
-					"end_addr_high=0x%08x end_addr_low"
-					"=0x%08x has crossed 4G boundary\n",
-						start_addr, sata_cmd.enc_len,
-						end_addr_high, end_addr_low));
+				pm8001_dbg(pm8001_ha, FAIL,
+					   "The sg list address start_addr=0x%016llx data_len=0x%x end_addr_high=0x%08x end_addr_low=0x%08x has crossed 4G boundary\n",
+					   start_addr, sata_cmd.enc_len,
+					   end_addr_high, end_addr_low);
 				pm8001_chip_make_sg(task->scatter, 1,
 					ccb->buf_prd);
 				phys_addr = ccb->ccb_dma_handle;
@@ -4785,9 +4558,9 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 			cpu_to_le32((sata_cmd.sata_fis.lbah_exp << 8) |
 					 (sata_cmd.sata_fis.lbam_exp));
 	} else {
-		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
-			"Sending Normal SATA command 0x%x inb %x\n",
-			sata_cmd.sata_fis.command, q_index));
+		pm8001_dbg(pm8001_ha, IO,
+			   "Sending Normal SATA command 0x%x inb %x\n",
+			   sata_cmd.sata_fis.command, q_index);
 		/* dad (bit 0-1) is 0 */
 		sata_cmd.ncqtag_atap_dir_m_dad =
 			cpu_to_le32(((ncg_tag & 0xff)<<16) |
@@ -4813,13 +4586,10 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 			end_addr_low = cpu_to_le32(lower_32_bits(end_addr));
 			end_addr_high = cpu_to_le32(upper_32_bits(end_addr));
 			if (end_addr_high != sata_cmd.addr_high) {
-				PM8001_FAIL_DBG(pm8001_ha,
-					pm8001_printk("The sg list address "
-					"start_addr=0x%016llx data_len=0x%x"
-					"end_addr_high=0x%08x end_addr_low="
-					"0x%08x has crossed 4G boundary\n",
-						start_addr, sata_cmd.len,
-						end_addr_high, end_addr_low));
+				pm8001_dbg(pm8001_ha, FAIL,
+					   "The sg list address start_addr=0x%016llx data_len=0x%xend_addr_high=0x%08x end_addr_low=0x%08x has crossed 4G boundary\n",
+					   start_addr, sata_cmd.len,
+					   end_addr_high, end_addr_low);
 				pm8001_chip_make_sg(task->scatter, 1,
 					ccb->buf_prd);
 				phys_addr = ccb->ccb_dma_handle;
@@ -4878,10 +4648,10 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 					SAS_TASK_STATE_ABORTED))) {
 				spin_unlock_irqrestore(&task->task_state_lock,
 							flags);
-				PM8001_FAIL_DBG(pm8001_ha,
-					pm8001_printk("task 0x%p resp 0x%x "
-					" stat 0x%x but aborted by upper layer "
-					"\n", task, ts->resp, ts->stat));
+				pm8001_dbg(pm8001_ha, FAIL,
+					   "task 0x%p resp 0x%x  stat 0x%x but aborted by upper layer\n",
+					   task, ts->resp,
+					   ts->stat);
 				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
 				return 0;
 			} else {
@@ -4916,8 +4686,7 @@ pm80xx_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)
 	memset(&payload, 0, sizeof(payload));
 	payload.tag = cpu_to_le32(tag);
 
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("PHY START REQ for phy_id %d\n", phy_id));
+	pm8001_dbg(pm8001_ha, INIT, "PHY START REQ for phy_id %d\n", phy_id);
 
 	payload.ase_sh_lm_slr_phyid = cpu_to_le32(SPINHOLD_DISABLE |
 			LINKMODE_AUTO | pm8001_ha->link_rate | phy_id);
@@ -5081,9 +4850,9 @@ static irqreturn_t
 pm80xx_chip_isr(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
 	pm80xx_chip_interrupt_disable(pm8001_ha, vec);
-	PM8001_DEVIO_DBG(pm8001_ha, pm8001_printk(
-		"irq vec %d, ODMR:0x%x\n",
-		vec, pm8001_cr32(pm8001_ha, 0, 0x30)));
+	pm8001_dbg(pm8001_ha, DEVIO,
+		   "irq vec %d, ODMR:0x%x\n",
+		   vec, pm8001_cr32(pm8001_ha, 0, 0x30));
 	process_oq(pm8001_ha, vec);
 	pm80xx_chip_interrupt_enable(pm8001_ha, vec);
 	return IRQ_HANDLED;
@@ -5102,13 +4871,13 @@ static void mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
 	memset(&payload, 0, sizeof(payload));
 	rc = pm8001_tag_alloc(pm8001_ha, &tag);
 	if (rc)
-		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("Invalid tag\n"));
+		pm8001_dbg(pm8001_ha, FAIL, "Invalid tag\n");
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 	payload.tag = cpu_to_le32(tag);
 	payload.ppc_phyid = (((operation & 0xF) << 8) | (phyid  & 0xFF));
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk(" phy profile command for phy %x ,length is %d\n",
-			payload.ppc_phyid, length));
+	pm8001_dbg(pm8001_ha, INIT,
+		   " phy profile command for phy %x ,length is %d\n",
+		   payload.ppc_phyid, length);
 	for (i = length; i < (length + PHY_DWORD_LENGTH - 1); i++) {
 		payload.reserved[j] =  cpu_to_le32(*((u32 *)buf + i));
 		j++;
@@ -5129,7 +4898,7 @@ void pm8001_set_phy_profile(struct pm8001_hba_info *pm8001_ha,
 			SAS_PHY_ANALOG_SETTINGS_PAGE, i, length, (u32 *)buf);
 		length = length + PHY_DWORD_LENGTH;
 	}
-	PM8001_INIT_DBG(pm8001_ha, pm8001_printk("phy settings completed\n"));
+	pm8001_dbg(pm8001_ha, INIT, "phy settings completed\n");
 }
 
 void pm8001_set_phy_profile_single(struct pm8001_hba_info *pm8001_ha,
@@ -5144,7 +4913,7 @@ void pm8001_set_phy_profile_single(struct pm8001_hba_info *pm8001_ha,
 
 	rc = pm8001_tag_alloc(pm8001_ha, &tag);
 	if (rc)
-		PM8001_INIT_DBG(pm8001_ha, pm8001_printk("Invalid tag"));
+		pm8001_dbg(pm8001_ha, INIT, "Invalid tag\n");
 
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 	opc = OPC_INB_SET_PHY_PROFILE;
@@ -5161,8 +4930,7 @@ void pm8001_set_phy_profile_single(struct pm8001_hba_info *pm8001_ha,
 	if (rc)
 		pm8001_tag_free(pm8001_ha, tag);
 
-	PM8001_INIT_DBG(pm8001_ha,
-		pm8001_printk("PHY %d settings applied", phy));
+	pm8001_dbg(pm8001_ha, INIT, "PHY %d settings applied\n", phy);
 }
 const struct pm8001_dispatch pm8001_80xx_dispatch = {
 	.name			= "pmc80xx",
-- 
2.30.1



