Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED72603E7F
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbiJSJQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233125AbiJSJOB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:14:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C839A9D0;
        Wed, 19 Oct 2022 02:03:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 427596183D;
        Wed, 19 Oct 2022 09:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CA6C433D6;
        Wed, 19 Oct 2022 09:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170201;
        bh=6g1bMV9wQxwTNLQeIPfdCg5TvIRt0sy9rejM01WnztY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K8lFrk0R7aUaQLpUs0DW+0AMoB0gjtfbHZyB8GwB8kjpAVoZ64eu1NiThl4wSewGC
         euVcp31WosQAXulcsh6mv6w7YKTmN/HD3V3gQvMzSnBw3/Jzyjpv1Iydp7Y9BfUbE2
         BTLKVf8NbljWwscgtVG38NWuEorMNQr3dQvqnTKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 519/862] scsi: lpfc: Fix various issues reported by tools
Date:   Wed, 19 Oct 2022 10:30:06 +0200
Message-Id: <20221019083312.915840651@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit a4de8356b68e54149ebdbe6e748e2726152b650c ]

This patch fixes below Smatch reported issues:

 1. lpfc_hbadisc.c:3020 lpfc_mbx_cmpl_fcf_rr_read_fcf_rec()
    error: uninitialized symbol 'vlan_id'.

 2. lpfc_hbadisc.c:3121 lpfc_mbx_cmpl_read_fcf_rec()
    error: uninitialized symbol 'vlan_id'.

 3. lpfc_init.c:335 lpfc_dump_wakeup_param_cmpl()
    warn: always true condition '(prg->dist < 4) => (0-3 < 4)'

 4. lpfc_init.c:2419 lpfc_parse_vpd()
    warn: inconsistent indenting.

 5. lpfc_init.c:13248 lpfc_sli4_enable_msi()
    warn: 'phba->pcidev->irq' 2147483648 can't fit into 65535
    'eqhdl->irq'

 6. lpfc_debugfs.c:5300 lpfc_idiag_extacc_avail_get()
    error: uninitialized symbol 'ext_cnt'

 7. lpfc_debugfs.c:5300 lpfc_idiag_extacc_avail_get()
    error: uninitialized symbol 'ext_size'

 8. lpfc_vmid.c:248 lpfc_vmid_get_appid()
    warn: sleeping in atomic context.

 9. lpfc_init.c:8342 lpfc_sli4_driver_resource_setup()
    warn: missing error code 'rc'.

10. lpfc_init.c:13573 lpfc_sli4_hba_unset()
    warn: variable dereferenced before check 'phba->pport' (see
    line 13546)

11. lpfc_auth.c:1923 lpfc_auth_handle_dhchap_reply()
    error: double free of 'hash_value'

Fixes:

 1. Initialize vlan_id to LPFC_FCOE_NULL_VID.

 2. Initialize vlan_id to LPFC_FCOE_NULL_VID.

 3. prg->dist is a 2 bit field. Its value can only be between 0-3.
    Remove redundent check 'if (prg->dist < 4)'.

 4. Fix inconsistent indenting.  Moved logic into helper function
    lpfc_fill_vpd().

 5. Define 'eqhdl->irq' as int value as pci_irq_vector() returns int.
    Also, check for return value of pci_irq_vector() and log message in
    case of failure.

 6. Initialize 'ext_cnt' to 0.

 7. Initialize 'ext_size' to 0.

 8. Use alloc_percpu_gfp() with GFP_ATOMIC flag.

 9. 'rc' was not updated when dma_pool_create() fails.  Update 'rc =
     -ENOMEM' when dma_pool_create() fails before calling goto statement.

10. Add check for 'phba->pport' in lpfc_cpuhp_remove().

11. Initialize 'hash_value' to NULL, same like 'aug_chal' variable.

Link: https://lore.kernel.org/r/20220911221505.117655-13-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_debugfs.c |   2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c |   4 +-
 drivers/scsi/lpfc/lpfc_init.c    | 249 +++++++++++++++++--------------
 drivers/scsi/lpfc/lpfc_sli.c     |   3 +
 drivers/scsi/lpfc/lpfc_sli4.h    |   4 +-
 drivers/scsi/lpfc/lpfc_vmid.c    |   4 +-
 6 files changed, 148 insertions(+), 118 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index e37b028eae5f..f5252e45a48a 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -5156,7 +5156,7 @@ lpfc_idiag_mbxacc_write(struct file *file, const char __user *buf,
 static int
 lpfc_idiag_extacc_avail_get(struct lpfc_hba *phba, char *pbuffer, int len)
 {
-	uint16_t ext_cnt, ext_size;
+	uint16_t ext_cnt = 0, ext_size = 0;
 
 	len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 			"\nAvailable Extents Information:\n");
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 2645def612e6..a488d00894ae 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -2964,7 +2964,7 @@ lpfc_mbx_cmpl_fcf_rr_read_fcf_rec(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	uint32_t boot_flag, addr_mode;
 	uint16_t next_fcf_index, fcf_index;
 	uint16_t current_fcf_index;
-	uint16_t vlan_id;
+	uint16_t vlan_id = LPFC_FCOE_NULL_VID;
 	int rc;
 
 	/* If link state is not up, stop the roundrobin failover process */
@@ -3069,7 +3069,7 @@ lpfc_mbx_cmpl_read_fcf_rec(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	struct fcf_record *new_fcf_record;
 	uint32_t boot_flag, addr_mode;
 	uint16_t fcf_index, next_fcf_index;
-	uint16_t vlan_id;
+	uint16_t vlan_id =  LPFC_FCOE_NULL_VID;
 	int rc;
 
 	/* If link state is not up, no need to proceed */
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index a76f2a120d9d..1a02134438fc 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -325,8 +325,7 @@ lpfc_dump_wakeup_param_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 	prog_id_word = pmboxq->u.mb.un.varWords[7];
 
 	/* Decode the Option rom version word to a readable string */
-	if (prg->dist < 4)
-		dist = dist_char[prg->dist];
+	dist = dist_char[prg->dist];
 
 	if ((prg->dist == 3) && (prg->num == 0))
 		snprintf(phba->OptionROMVersion, 32, "%d.%d%d",
@@ -2258,6 +2257,101 @@ lpfc_handle_latt(struct lpfc_hba *phba)
 	return;
 }
 
+static void
+lpfc_fill_vpd(struct lpfc_hba *phba, uint8_t *vpd, int length, int *pindex)
+{
+	int i, j;
+
+	while (length > 0) {
+		/* Look for Serial Number */
+		if ((vpd[*pindex] == 'S') && (vpd[*pindex + 1] == 'N')) {
+			*pindex += 2;
+			i = vpd[*pindex];
+			*pindex += 1;
+			j = 0;
+			length -= (3+i);
+			while (i--) {
+				phba->SerialNumber[j++] = vpd[(*pindex)++];
+				if (j == 31)
+					break;
+			}
+			phba->SerialNumber[j] = 0;
+			continue;
+		} else if ((vpd[*pindex] == 'V') && (vpd[*pindex + 1] == '1')) {
+			phba->vpd_flag |= VPD_MODEL_DESC;
+			*pindex += 2;
+			i = vpd[*pindex];
+			*pindex += 1;
+			j = 0;
+			length -= (3+i);
+			while (i--) {
+				phba->ModelDesc[j++] = vpd[(*pindex)++];
+				if (j == 255)
+					break;
+			}
+			phba->ModelDesc[j] = 0;
+			continue;
+		} else if ((vpd[*pindex] == 'V') && (vpd[*pindex + 1] == '2')) {
+			phba->vpd_flag |= VPD_MODEL_NAME;
+			*pindex += 2;
+			i = vpd[*pindex];
+			*pindex += 1;
+			j = 0;
+			length -= (3+i);
+			while (i--) {
+				phba->ModelName[j++] = vpd[(*pindex)++];
+				if (j == 79)
+					break;
+			}
+			phba->ModelName[j] = 0;
+			continue;
+		} else if ((vpd[*pindex] == 'V') && (vpd[*pindex + 1] == '3')) {
+			phba->vpd_flag |= VPD_PROGRAM_TYPE;
+			*pindex += 2;
+			i = vpd[*pindex];
+			*pindex += 1;
+			j = 0;
+			length -= (3+i);
+			while (i--) {
+				phba->ProgramType[j++] = vpd[(*pindex)++];
+				if (j == 255)
+					break;
+			}
+			phba->ProgramType[j] = 0;
+			continue;
+		} else if ((vpd[*pindex] == 'V') && (vpd[*pindex + 1] == '4')) {
+			phba->vpd_flag |= VPD_PORT;
+			*pindex += 2;
+			i = vpd[*pindex];
+			*pindex += 1;
+			j = 0;
+			length -= (3 + i);
+			while (i--) {
+				if ((phba->sli_rev == LPFC_SLI_REV4) &&
+				    (phba->sli4_hba.pport_name_sta ==
+				     LPFC_SLI4_PPNAME_GET)) {
+					j++;
+					(*pindex)++;
+				} else
+					phba->Port[j++] = vpd[(*pindex)++];
+				if (j == 19)
+					break;
+			}
+			if ((phba->sli_rev != LPFC_SLI_REV4) ||
+			    (phba->sli4_hba.pport_name_sta ==
+			     LPFC_SLI4_PPNAME_NON))
+				phba->Port[j] = 0;
+			continue;
+		} else {
+			*pindex += 2;
+			i = vpd[*pindex];
+			*pindex += 1;
+			*pindex += i;
+			length -= (3 + i);
+		}
+	}
+}
+
 /**
  * lpfc_parse_vpd - Parse VPD (Vital Product Data)
  * @phba: pointer to lpfc hba data structure.
@@ -2277,7 +2371,7 @@ lpfc_parse_vpd(struct lpfc_hba *phba, uint8_t *vpd, int len)
 {
 	uint8_t lenlo, lenhi;
 	int Length;
-	int i, j;
+	int i;
 	int finished = 0;
 	int index = 0;
 
@@ -2310,101 +2404,10 @@ lpfc_parse_vpd(struct lpfc_hba *phba, uint8_t *vpd, int len)
 			Length = ((((unsigned short)lenhi) << 8) + lenlo);
 			if (Length > len - index)
 				Length = len - index;
-			while (Length > 0) {
-			/* Look for Serial Number */
-			if ((vpd[index] == 'S') && (vpd[index+1] == 'N')) {
-				index += 2;
-				i = vpd[index];
-				index += 1;
-				j = 0;
-				Length -= (3+i);
-				while(i--) {
-					phba->SerialNumber[j++] = vpd[index++];
-					if (j == 31)
-						break;
-				}
-				phba->SerialNumber[j] = 0;
-				continue;
-			}
-			else if ((vpd[index] == 'V') && (vpd[index+1] == '1')) {
-				phba->vpd_flag |= VPD_MODEL_DESC;
-				index += 2;
-				i = vpd[index];
-				index += 1;
-				j = 0;
-				Length -= (3+i);
-				while(i--) {
-					phba->ModelDesc[j++] = vpd[index++];
-					if (j == 255)
-						break;
-				}
-				phba->ModelDesc[j] = 0;
-				continue;
-			}
-			else if ((vpd[index] == 'V') && (vpd[index+1] == '2')) {
-				phba->vpd_flag |= VPD_MODEL_NAME;
-				index += 2;
-				i = vpd[index];
-				index += 1;
-				j = 0;
-				Length -= (3+i);
-				while(i--) {
-					phba->ModelName[j++] = vpd[index++];
-					if (j == 79)
-						break;
-				}
-				phba->ModelName[j] = 0;
-				continue;
-			}
-			else if ((vpd[index] == 'V') && (vpd[index+1] == '3')) {
-				phba->vpd_flag |= VPD_PROGRAM_TYPE;
-				index += 2;
-				i = vpd[index];
-				index += 1;
-				j = 0;
-				Length -= (3+i);
-				while(i--) {
-					phba->ProgramType[j++] = vpd[index++];
-					if (j == 255)
-						break;
-				}
-				phba->ProgramType[j] = 0;
-				continue;
-			}
-			else if ((vpd[index] == 'V') && (vpd[index+1] == '4')) {
-				phba->vpd_flag |= VPD_PORT;
-				index += 2;
-				i = vpd[index];
-				index += 1;
-				j = 0;
-				Length -= (3+i);
-				while(i--) {
-					if ((phba->sli_rev == LPFC_SLI_REV4) &&
-					    (phba->sli4_hba.pport_name_sta ==
-					     LPFC_SLI4_PPNAME_GET)) {
-						j++;
-						index++;
-					} else
-						phba->Port[j++] = vpd[index++];
-					if (j == 19)
-						break;
-				}
-				if ((phba->sli_rev != LPFC_SLI_REV4) ||
-				    (phba->sli4_hba.pport_name_sta ==
-				     LPFC_SLI4_PPNAME_NON))
-					phba->Port[j] = 0;
-				continue;
-			}
-			else {
-				index += 2;
-				i = vpd[index];
-				index += 1;
-				index += i;
-				Length -= (3 + i);
-			}
-		}
-		finished = 0;
-		break;
+
+			lpfc_fill_vpd(phba, vpd, Length, &index);
+			finished = 0;
+			break;
 		case 0x78:
 			finished = 1;
 			break;
@@ -8278,8 +8281,10 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 					&phba->pcidev->dev,
 					phba->cfg_sg_dma_buf_size,
 					i, 0);
-	if (!phba->lpfc_sg_dma_buf_pool)
+	if (!phba->lpfc_sg_dma_buf_pool) {
+		rc = -ENOMEM;
 		goto out_free_bsmbx;
+	}
 
 	phba->lpfc_cmd_rsp_buf_pool =
 			dma_pool_create("lpfc_cmd_rsp_buf_pool",
@@ -8287,8 +8292,10 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 					sizeof(struct fcp_cmnd) +
 					sizeof(struct fcp_rsp),
 					i, 0);
-	if (!phba->lpfc_cmd_rsp_buf_pool)
+	if (!phba->lpfc_cmd_rsp_buf_pool) {
+		rc = -ENOMEM;
 		goto out_free_sg_dma_buf;
+	}
 
 	mempool_free(mboxq, phba->mbox_mem_pool);
 
@@ -12379,7 +12386,7 @@ lpfc_hba_eq_hdl_array_init(struct lpfc_hba *phba)
 
 	for (i = 0; i < phba->cfg_irq_chann; i++) {
 		eqhdl = lpfc_get_eq_hdl(i);
-		eqhdl->irq = LPFC_VECTOR_MAP_EMPTY;
+		eqhdl->irq = LPFC_IRQ_EMPTY;
 		eqhdl->phba = phba;
 	}
 }
@@ -12752,7 +12759,7 @@ static void __lpfc_cpuhp_remove(struct lpfc_hba *phba)
 
 static void lpfc_cpuhp_remove(struct lpfc_hba *phba)
 {
-	if (phba->pport->fc_flag & FC_OFFLINE_MODE)
+	if (phba->pport && (phba->pport->fc_flag & FC_OFFLINE_MODE))
 		return;
 
 	__lpfc_cpuhp_remove(phba);
@@ -13016,9 +13023,17 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 			 LPFC_DRIVER_HANDLER_NAME"%d", index);
 
 		eqhdl->idx = index;
-		rc = request_irq(pci_irq_vector(phba->pcidev, index),
-			 &lpfc_sli4_hba_intr_handler, 0,
-			 name, eqhdl);
+		rc = pci_irq_vector(phba->pcidev, index);
+		if (rc < 0) {
+			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+					"0489 MSI-X fast-path (%d) "
+					"pci_irq_vec failed (%d)\n", index, rc);
+			goto cfg_fail_out;
+		}
+		eqhdl->irq = rc;
+
+		rc = request_irq(eqhdl->irq, &lpfc_sli4_hba_intr_handler, 0,
+				 name, eqhdl);
 		if (rc) {
 			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 					"0486 MSI-X fast-path (%d) "
@@ -13026,8 +13041,6 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 			goto cfg_fail_out;
 		}
 
-		eqhdl->irq = pci_irq_vector(phba->pcidev, index);
-
 		if (aff_mask) {
 			/* If found a neighboring online cpu, set affinity */
 			if (cpu_select < nr_cpu_ids)
@@ -13144,7 +13157,14 @@ lpfc_sli4_enable_msi(struct lpfc_hba *phba)
 	}
 
 	eqhdl = lpfc_get_eq_hdl(0);
-	eqhdl->irq = pci_irq_vector(phba->pcidev, 0);
+	rc = pci_irq_vector(phba->pcidev, 0);
+	if (rc < 0) {
+		pci_free_irq_vectors(phba->pcidev);
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"0496 MSI pci_irq_vec failed (%d)\n", rc);
+		return rc;
+	}
+	eqhdl->irq = rc;
 
 	cpu = cpumask_first(cpu_present_mask);
 	lpfc_assign_eq_map_info(phba, 0, LPFC_CPU_FIRST_IRQ, cpu);
@@ -13171,8 +13191,8 @@ lpfc_sli4_enable_msi(struct lpfc_hba *phba)
  * MSI-X -> MSI -> IRQ.
  *
  * Return codes
- * 	0 - successful
- * 	other values - error
+ *	Interrupt mode (2, 1, 0) - successful
+ *	LPFC_INTR_ERROR - error
  **/
 static uint32_t
 lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
@@ -13217,7 +13237,14 @@ lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 			intr_mode = 0;
 
 			eqhdl = lpfc_get_eq_hdl(0);
-			eqhdl->irq = pci_irq_vector(phba->pcidev, 0);
+			retval = pci_irq_vector(phba->pcidev, 0);
+			if (retval < 0) {
+				lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+					"0502 INTR pci_irq_vec failed (%d)\n",
+					 retval);
+				return LPFC_INTR_ERROR;
+			}
+			eqhdl->irq = retval;
 
 			cpu = cpumask_first(cpu_present_mask);
 			lpfc_assign_eq_map_info(phba, 0, LPFC_CPU_FIRST_IRQ,
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 55c9eb39ea19..03c21167fc85 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -6202,6 +6202,9 @@ lpfc_sli4_get_avail_extnt_rsrc(struct lpfc_hba *phba, uint16_t type,
 	struct lpfc_mbx_get_rsrc_extent_info *rsrc_info;
 	LPFC_MBOXQ_t *mbox;
 
+	*extnt_count = 0;
+	*extnt_size = 0;
+
 	mbox = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
 		return -ENOMEM;
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 1ddad5b170a6..cbb1aa1cf025 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -489,7 +489,7 @@ struct lpfc_hba;
 #define LPFC_SLI4_HANDLER_NAME_SZ	16
 struct lpfc_hba_eq_hdl {
 	uint32_t idx;
-	uint16_t irq;
+	int irq;
 	char handler_name[LPFC_SLI4_HANDLER_NAME_SZ];
 	struct lpfc_hba *phba;
 	struct lpfc_queue *eq;
@@ -611,6 +611,8 @@ struct lpfc_vector_map_info {
 };
 #define LPFC_VECTOR_MAP_EMPTY	0xffff
 
+#define LPFC_IRQ_EMPTY 0xffffffff
+
 /* Multi-XRI pool */
 #define XRI_BATCH               8
 
diff --git a/drivers/scsi/lpfc/lpfc_vmid.c b/drivers/scsi/lpfc/lpfc_vmid.c
index f64ced04b912..ed1d7f7b88a3 100644
--- a/drivers/scsi/lpfc/lpfc_vmid.c
+++ b/drivers/scsi/lpfc/lpfc_vmid.c
@@ -245,9 +245,7 @@ int lpfc_vmid_get_appid(struct lpfc_vport *vport, char *uuid,
 		/* allocate the per cpu variable for holding */
 		/* the last access time stamp only if VMID is enabled */
 		if (!vmp->last_io_time)
-			vmp->last_io_time = __alloc_percpu(sizeof(u64),
-							   __alignof__(struct
-							   lpfc_vmid));
+			vmp->last_io_time = alloc_percpu_gfp(u64, GFP_ATOMIC);
 		if (!vmp->last_io_time) {
 			hash_del(&vmp->hnode);
 			vmp->flag = LPFC_VMID_SLOT_FREE;
-- 
2.35.1



