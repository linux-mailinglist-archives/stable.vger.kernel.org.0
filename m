Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B073C908E
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbhGNTzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241218AbhGNTu1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25EE861370;
        Wed, 14 Jul 2021 19:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292038;
        bh=P11Lj65Z41xryNPGwrmEifGBPFUMsSV+Nvec+L3/hCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ei48fAWh7PMxfbPpFo3k03dU4CMhIFrE2sPHSL5R0UPcTrz90crnzaKMSg7Q40rl/
         jItg/xJ6otYDfWWQykLhMJH7VsaP1DoMQ2eqQGISn5J4RcDXc3wPke4bDcNDKNy/BB
         hzN2rPxXuFYcdSuFfv4LrM8MkWOiYTH5RpR1/77ZVPSlPWEQb8O3cEOJ7kNd+DpM85
         WZ67KyW4YV9h2q9POlxk4ir+1ImKO4kmpBcOlZk1q/8Rnbo1J0vNISrBND+8xEuOzP
         K2Z6Rgbh/cy8Ym2RRnz/w0upW4b1+QzQheYwUU1P0pRTOQdAHswiUGGEBE3nNZ0o/L
         4fCBCp9rdLExA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 37/39] scsi: be2iscsi: Fix some missing space in some messages
Date:   Wed, 14 Jul 2021 15:46:22 -0400
Message-Id: <20210714194625.55303-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194625.55303-1-sashal@kernel.org>
References: <20210714194625.55303-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit c7fa2c855e892721bafafdf6393342c000e0ef77 ]

Fix a few style issues reported by checkpatch.pl:

 - Avoid duplicated word in comment.

 - Add missing space in messages.

 - Unneeded continuation line character.

 - Unneeded extra spaces.

 - Unneeded log message after memory allocation failure.

Link: https://lore.kernel.org/r/8cb62f0eb96ec7ce7a73fe97cb4490dd5121ecff.1623482155.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/be2iscsi/be_main.c | 102 ++++++++++++--------------------
 1 file changed, 38 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 3660059784f7..a04d3bcf9c88 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -143,8 +143,7 @@ DEVICE_ATTR(beiscsi_##_name, S_IRUGO | S_IWUSR,\
 	      beiscsi_##_name##_disp, beiscsi_##_name##_store)
 
 /*
- * When new log level added update the
- * the MAX allowed value for log_enable
+ * When new log level added update MAX allowed value for log_enable
  */
 BEISCSI_RW_ATTR(log_enable, 0x00,
 		0xFF, 0x00, "Enable logging Bit Mask\n"
@@ -842,9 +841,8 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 					  &phwi_context->be_eq[i]);
 			if (ret) {
 				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-					    "BM_%d : beiscsi_init_irqs-Failed to"
-					    "register msix for i = %d\n",
-					    i);
+					    "BM_%d : %s-Failed to register msix for i = %d\n",
+					    __func__, i);
 				kfree(phba->msi_name[i]);
 				goto free_msix_irqs;
 			}
@@ -858,9 +856,9 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 		ret = request_irq(pci_irq_vector(pcidev, i), be_isr_mcc, 0,
 				  phba->msi_name[i], &phwi_context->be_eq[i]);
 		if (ret) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT ,
-				    "BM_%d : beiscsi_init_irqs-"
-				    "Failed to register beiscsi_msix_mcc\n");
+			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
+				    "BM_%d : %s-Failed to register beiscsi_msix_mcc\n",
+				    __func__);
 			kfree(phba->msi_name[i]);
 			goto free_msix_irqs;
 		}
@@ -870,8 +868,8 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 				  "beiscsi", phba);
 		if (ret) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM_%d : beiscsi_init_irqs-"
-				    "Failed to register irq\\n");
+				    "BM_%d : %s-Failed to register irq\n",
+				    __func__);
 			return ret;
 		}
 	}
@@ -1047,7 +1045,7 @@ free_wrb_handle(struct beiscsi_hba *phba, struct hwi_wrb_context *pwrb_context,
 			       phba->params.wrbs_per_cxn);
 	beiscsi_log(phba, KERN_INFO,
 		    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-		    "BM_%d : FREE WRB: pwrb_handle=%p free_index=0x%x"
+		    "BM_%d : FREE WRB: pwrb_handle=%p free_index=0x%x "
 		    "wrb_handles_available=%d\n",
 		    pwrb_handle, pwrb_context->free_index,
 		    pwrb_context->wrb_handles_available);
@@ -1391,7 +1389,7 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
 			    "BM_%d :\t\t No HWH_TYPE_LOGIN Expected in"
-			    " hwi_complete_cmd- Solicited path\n");
+			    " %s- Solicited path\n", __func__);
 		break;
 
 	case HWH_TYPE_NOP:
@@ -1401,8 +1399,8 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 	default:
 		beiscsi_log(phba, KERN_WARNING,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
-			    "BM_%d : In hwi_complete_cmd, unknown type = %d"
-			    "wrb_index 0x%x CID 0x%x\n", type,
+			    "BM_%d : In %s, unknown type = %d "
+			    "wrb_index 0x%x CID 0x%x\n", __func__, type,
 			    csol_cqe.wrb_index,
 			    csol_cqe.cid);
 		break;
@@ -1900,9 +1898,9 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget)
 				cid = AMAP_GET_BITS(
 						    struct amap_i_t_dpdu_cqe_v2,
 						    cid, sol);
-			 else
-				 cid = AMAP_GET_BITS(struct amap_sol_cqe_v2,
-						     cid, sol);
+			else
+				cid = AMAP_GET_BITS(struct amap_sol_cqe_v2,
+						    cid, sol);
 		}
 
 		cri_index = BE_GET_CRI_FROM_CID(cid);
@@ -2028,8 +2026,7 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget)
 		default:
 			beiscsi_log(phba, KERN_ERR,
 				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-				    "BM_%d : Invalid CQE Event Received Code : %d"
-				    "CID 0x%x...\n",
+				    "BM_%d : Invalid CQE Event Received Code : %d CID 0x%x...\n",
 				    code, cid);
 			break;
 		}
@@ -3020,7 +3017,7 @@ static int beiscsi_create_eqs(struct beiscsi_hba *phba,
 	void *eq_vaddress;
 	dma_addr_t paddr;
 
-	num_eq_pages = PAGES_REQUIRED(phba->params.num_eq_entries * \
+	num_eq_pages = PAGES_REQUIRED(phba->params.num_eq_entries *
 				      sizeof(struct be_eq_entry));
 
 	if (phba->pcidev->msix_enabled)
@@ -3053,8 +3050,7 @@ static int beiscsi_create_eqs(struct beiscsi_hba *phba,
 					    BEISCSI_EQ_DELAY_DEF);
 		if (ret) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM_%d : beiscsi_cmd_eq_create"
-				    "Failed for EQ\n");
+				    "BM_%d : beiscsi_cmd_eq_create Failed for EQ\n");
 			goto create_eq_error;
 		}
 
@@ -3087,7 +3083,7 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
 	int ret = -ENOMEM;
 	dma_addr_t paddr;
 
-	num_cq_pages = PAGES_REQUIRED(phba->params.num_cq_entries * \
+	num_cq_pages = PAGES_REQUIRED(phba->params.num_cq_entries *
 				      sizeof(struct sol_cqe));
 
 	for (i = 0; i < phba->num_cpus; i++) {
@@ -3109,8 +3105,7 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
 				    sizeof(struct sol_cqe), cq_vaddress);
 		if (ret) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM_%d : be_fill_queue Failed "
-				    "for ISCSI CQ\n");
+				    "BM_%d : be_fill_queue Failed for ISCSI CQ\n");
 			goto create_cq_error;
 		}
 
@@ -3119,8 +3114,7 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
 					    false, 0);
 		if (ret) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM_%d : beiscsi_cmd_eq_create"
-				    "Failed for ISCSI CQ\n");
+				    "BM_%d : beiscsi_cmd_eq_create Failed for ISCSI CQ\n");
 			goto create_cq_error;
 		}
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
@@ -3245,8 +3239,8 @@ beiscsi_create_def_data(struct beiscsi_hba *phba,
 		    phwi_context->be_def_dataq[ulp_num].id);
 
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM_%d : DEFAULT PDU DATA RING CREATED"
-		    "on ULP : %d\n", ulp_num);
+		    "BM_%d : DEFAULT PDU DATA RING CREATED on ULP : %d\n",
+		    ulp_num);
 	return 0;
 }
 
@@ -3272,13 +3266,13 @@ beiscsi_post_template_hdr(struct beiscsi_hba *phba)
 
 			if (status != 0) {
 				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-					    "BM_%d : Post Template HDR Failed for"
+					    "BM_%d : Post Template HDR Failed for "
 					    "ULP_%d\n", ulp_num);
 				return status;
 			}
 
 			beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-				    "BM_%d : Template HDR Pages Posted for"
+				    "BM_%d : Template HDR Pages Posted for "
 				    "ULP_%d\n", ulp_num);
 		}
 	}
@@ -3392,18 +3386,17 @@ beiscsi_create_wrb_rings(struct beiscsi_hba *phba,
 		} else {
 			idx++;
 			wrb_vaddr = mem_descr->mem_array[idx].virtual_address;
-			pa_addr_lo = mem_descr->mem_array[idx].\
+			pa_addr_lo = mem_descr->mem_array[idx].
 					bus_address.u.a64.address;
 			num_wrb_rings = mem_descr->mem_array[idx].size /
 					(phba->params.wrbs_per_cxn *
 					sizeof(struct iscsi_wrb));
 			pwrb_arr[num].virtual_address = wrb_vaddr;
-			pwrb_arr[num].bus_address.u.a64.address\
-						= pa_addr_lo;
+			pwrb_arr[num].bus_address.u.a64.address = pa_addr_lo;
 			pwrb_arr[num].size = phba->params.wrbs_per_cxn *
 						 sizeof(struct iscsi_wrb);
 			wrb_vaddr += pwrb_arr[num].size;
-			pa_addr_lo   += pwrb_arr[num].size;
+			pa_addr_lo += pwrb_arr[num].size;
 			num_wrb_rings--;
 		}
 	}
@@ -3957,7 +3950,7 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
 		idx++;
 	}
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM_%d : phba->io_sgl_hndl_avbl=%d"
+		    "BM_%d : phba->io_sgl_hndl_avbl=%d "
 		    "phba->eh_sgl_hndl_avbl=%d\n",
 		    phba->io_sgl_hndl_avbl,
 		    phba->eh_sgl_hndl_avbl);
@@ -4015,13 +4008,8 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 					       GFP_KERNEL);
 
 			if (!ptr_cid_info) {
-				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-					    "BM_%d : Failed to allocate memory"
-					    "for ULP_CID_INFO for ULP : %d\n",
-					    ulp_num);
 				ret = -ENOMEM;
 				goto free_memory;
-
 			}
 
 			/* Allocate memory for CID array */
@@ -4030,10 +4018,6 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 					sizeof(*ptr_cid_info->cid_array),
 					GFP_KERNEL);
 			if (!ptr_cid_info->cid_array) {
-				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-					    "BM_%d : Failed to allocate memory"
-					    "for CID_ARRAY for ULP : %d\n",
-					    ulp_num);
 				kfree(ptr_cid_info);
 				ptr_cid_info = NULL;
 				ret = -ENOMEM;
@@ -4051,9 +4035,6 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 				 sizeof(struct iscsi_endpoint *),
 				 GFP_KERNEL);
 	if (!phba->ep_array) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : Failed to allocate memory in "
-			    "hba_setup_cid_tbls\n");
 		ret = -ENOMEM;
 
 		goto free_memory;
@@ -4063,10 +4044,6 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 				   sizeof(struct beiscsi_conn *),
 				   GFP_KERNEL);
 	if (!phba->conn_table) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : Failed to allocate memory in"
-			    "hba_setup_cid_tbls\n");
-
 		kfree(phba->ep_array);
 		phba->ep_array = NULL;
 		ret = -ENOMEM;
@@ -4419,7 +4396,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 		if (!io_task->psgl_handle) {
 			beiscsi_log(phba, KERN_ERR,
 				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-				    "BM_%d : Alloc of IO_SGL_ICD Failed"
+				    "BM_%d : Alloc of IO_SGL_ICD Failed "
 				    "for the CID : %d\n",
 				    beiscsi_conn->beiscsi_conn_cid);
 			goto free_hndls;
@@ -4430,7 +4407,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 		if (!io_task->pwrb_handle) {
 			beiscsi_log(phba, KERN_ERR,
 				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-				    "BM_%d : Alloc of WRB_HANDLE Failed"
+				    "BM_%d : Alloc of WRB_HANDLE Failed "
 				    "for the CID : %d\n",
 				    beiscsi_conn->beiscsi_conn_cid);
 			goto free_io_hndls;
@@ -4446,10 +4423,9 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 					beiscsi_log(phba, KERN_ERR,
 						    BEISCSI_LOG_IO |
 						    BEISCSI_LOG_CONFIG,
-						    "BM_%d : Alloc of MGMT_SGL_ICD Failed"
+						    "BM_%d : Alloc of MGMT_SGL_ICD Failed "
 						    "for the CID : %d\n",
-						    beiscsi_conn->
-						    beiscsi_conn_cid);
+						    beiscsi_conn->beiscsi_conn_cid);
 					goto free_hndls;
 				}
 
@@ -4464,10 +4440,9 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 					beiscsi_log(phba, KERN_ERR,
 						    BEISCSI_LOG_IO |
 						    BEISCSI_LOG_CONFIG,
-						    "BM_%d : Alloc of WRB_HANDLE Failed"
+						    "BM_%d : Alloc of WRB_HANDLE Failed "
 						    "for the CID : %d\n",
-						    beiscsi_conn->
-						    beiscsi_conn_cid);
+						    beiscsi_conn->beiscsi_conn_cid);
 					goto free_mgmt_hndls;
 				}
 				beiscsi_conn->plogin_wrb_handle =
@@ -4485,10 +4460,9 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 				beiscsi_log(phba, KERN_ERR,
 					    BEISCSI_LOG_IO |
 					    BEISCSI_LOG_CONFIG,
-					    "BM_%d : Alloc of MGMT_SGL_ICD Failed"
+					    "BM_%d : Alloc of MGMT_SGL_ICD Failed "
 					    "for the CID : %d\n",
-					    beiscsi_conn->
-					    beiscsi_conn_cid);
+					    beiscsi_conn->beiscsi_conn_cid);
 				goto free_hndls;
 			}
 			io_task->pwrb_handle =
@@ -4498,7 +4472,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 			if (!io_task->pwrb_handle) {
 				beiscsi_log(phba, KERN_ERR,
 					    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-					    "BM_%d : Alloc of WRB_HANDLE Failed"
+					    "BM_%d : Alloc of WRB_HANDLE Failed "
 					    "for the CID : %d\n",
 					    beiscsi_conn->beiscsi_conn_cid);
 				goto free_mgmt_hndls;
-- 
2.30.2

