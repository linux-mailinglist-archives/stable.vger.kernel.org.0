Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE7C406064
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhIJARR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:17:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229698AbhIJARQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:17:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 895386023D;
        Fri, 10 Sep 2021 00:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631232966;
        bh=vsoXdWXo2+FQ7z/eNUr1ymDIYbf3jrLPla7HAzELjvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pdmDQ1KUpEG3UCTX4/gTBTbyOzi9oRLMPz9PAtykzzNtW5W2WUoJLyJnFbvzT9DD2
         jn2Xa2BS5asBM3pSKzqmiCAwxxiMO4wlV1Z9BM/VrgT13joDH4OmgPWqKLmRiPKbDm
         3czsGWt1sU0vFYgr6RbgQeZkZXiC9eGq+6XLKtCPBQfZeYO4vtV+MkcAsUhtdRlgGa
         ceCRyfGCRIsQVwaviDiLJ+ECgjRxCI0MoS/vMPUBYmrA/oCApsnEpVVkU9stM+cw7n
         wQKPuqdvM0TlffJr5gUKx2Zp5xCHPaCJBxZR10bHkhcJT0f8gW86lttkgRyHlJIK0T
         WeFhJ4NChk2LA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 05/99] scsi: be2iscsi: Fix use-after-free during IP updates
Date:   Thu,  9 Sep 2021 20:14:24 -0400
Message-Id: <20210910001558.173296-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 7b0ddc1346089b62b45e688e350c9e1c3f7a3ab2 ]

This fixes a bug found by Lv Yunlong where, because beiscsi_exec_nemb_cmd()
frees memory for the be_dma_mem cmd(), we can access freed memory when
beiscsi_if_clr_ip()/beiscsi_if_set_ip()'s call to beiscsi_exec_nemb_cmd()
fails and we access the freed req. This fixes the issue by having the
caller free the cmd's memory.

Link: https://lore.kernel.org/r/20210701190840.175120-1-michael.christie@oracle.com
Reported-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/be2iscsi/be_mgmt.c | 84 ++++++++++++++++++---------------
 1 file changed, 45 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 462717bbb5b7..4e899ec1477d 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -235,8 +235,7 @@ static int beiscsi_exec_nemb_cmd(struct beiscsi_hba *phba,
 	wrb = alloc_mcc_wrb(phba, &tag);
 	if (!wrb) {
 		mutex_unlock(&ctrl->mbox_lock);
-		rc = -ENOMEM;
-		goto free_cmd;
+		return -ENOMEM;
 	}
 
 	sge = nonembedded_sgl(wrb);
@@ -269,24 +268,6 @@ static int beiscsi_exec_nemb_cmd(struct beiscsi_hba *phba,
 	/* copy the response, if any */
 	if (resp_buf)
 		memcpy(resp_buf, nonemb_cmd->va, resp_buf_len);
-	/**
-	 * This is special case of NTWK_GET_IF_INFO where the size of
-	 * response is not known. beiscsi_if_get_info checks the return
-	 * value to free DMA buffer.
-	 */
-	if (rc == -EAGAIN)
-		return rc;
-
-	/**
-	 * If FW is busy that is driver timed out, DMA buffer is saved with
-	 * the tag, only when the cmd completes this buffer is freed.
-	 */
-	if (rc == -EBUSY)
-		return rc;
-
-free_cmd:
-	dma_free_coherent(&ctrl->pdev->dev, nonemb_cmd->size,
-			    nonemb_cmd->va, nonemb_cmd->dma);
 	return rc;
 }
 
@@ -309,6 +290,19 @@ static int beiscsi_prep_nemb_cmd(struct beiscsi_hba *phba,
 	return 0;
 }
 
+static void beiscsi_free_nemb_cmd(struct beiscsi_hba *phba,
+				  struct be_dma_mem *cmd, int rc)
+{
+	/*
+	 * If FW is busy the DMA buffer is saved with the tag. When the cmd
+	 * completes this buffer is freed.
+	 */
+	if (rc == -EBUSY)
+		return;
+
+	dma_free_coherent(&phba->ctrl.pdev->dev, cmd->size, cmd->va, cmd->dma);
+}
+
 static void __beiscsi_eq_delay_compl(struct beiscsi_hba *phba, unsigned int tag)
 {
 	struct be_dma_mem *tag_mem;
@@ -344,8 +338,16 @@ int beiscsi_modify_eq_delay(struct beiscsi_hba *phba,
 				cpu_to_le32(set_eqd[i].delay_multiplier);
 	}
 
-	return beiscsi_exec_nemb_cmd(phba, &nonemb_cmd,
-				     __beiscsi_eq_delay_compl, NULL, 0);
+	rc = beiscsi_exec_nemb_cmd(phba, &nonemb_cmd, __beiscsi_eq_delay_compl,
+				   NULL, 0);
+	if (rc) {
+		/*
+		 * Only free on failure. Async cmds are handled like -EBUSY
+		 * where it's handled for us.
+		 */
+		beiscsi_free_nemb_cmd(phba, &nonemb_cmd, rc);
+	}
+	return rc;
 }
 
 /**
@@ -372,6 +374,7 @@ int beiscsi_get_initiator_name(struct beiscsi_hba *phba, char *name, bool cfg)
 		req->hdr.version = 1;
 	rc = beiscsi_exec_nemb_cmd(phba, &nonemb_cmd, NULL,
 				   &resp, sizeof(resp));
+	beiscsi_free_nemb_cmd(phba, &nonemb_cmd, rc);
 	if (rc) {
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
@@ -449,7 +452,9 @@ static int beiscsi_if_mod_gw(struct beiscsi_hba *phba,
 	req->ip_addr.ip_type = ip_type;
 	memcpy(req->ip_addr.addr, gw,
 	       (ip_type < BEISCSI_IP_TYPE_V6) ? IP_V4_LEN : IP_V6_LEN);
-	return beiscsi_exec_nemb_cmd(phba, &nonemb_cmd, NULL, NULL, 0);
+	rt_val = beiscsi_exec_nemb_cmd(phba, &nonemb_cmd, NULL, NULL, 0);
+	beiscsi_free_nemb_cmd(phba, &nonemb_cmd, rt_val);
+	return rt_val;
 }
 
 int beiscsi_if_set_gw(struct beiscsi_hba *phba, u32 ip_type, u8 *gw)
@@ -499,8 +504,10 @@ int beiscsi_if_get_gw(struct beiscsi_hba *phba, u32 ip_type,
 	req = nonemb_cmd.va;
 	req->ip_type = ip_type;
 
-	return beiscsi_exec_nemb_cmd(phba, &nonemb_cmd, NULL,
-				     resp, sizeof(*resp));
+	rc = beiscsi_exec_nemb_cmd(phba, &nonemb_cmd, NULL, resp,
+				   sizeof(*resp));
+	beiscsi_free_nemb_cmd(phba, &nonemb_cmd, rc);
+	return rc;
 }
 
 static int
@@ -537,6 +544,7 @@ beiscsi_if_clr_ip(struct beiscsi_hba *phba,
 			    "BG_%d : failed to clear IP: rc %d status %d\n",
 			    rc, req->ip_params.ip_record.status);
 	}
+	beiscsi_free_nemb_cmd(phba, &nonemb_cmd, rc);
 	return rc;
 }
 
@@ -581,6 +589,7 @@ beiscsi_if_set_ip(struct beiscsi_hba *phba, u8 *ip,
 		if (req->ip_params.ip_record.status)
 			rc = -EINVAL;
 	}
+	beiscsi_free_nemb_cmd(phba, &nonemb_cmd, rc);
 	return rc;
 }
 
@@ -608,6 +617,7 @@ int beiscsi_if_en_static(struct beiscsi_hba *phba, u32 ip_type,
 		reldhcp->interface_hndl = phba->interface_handle;
 		reldhcp->ip_type = ip_type;
 		rc = beiscsi_exec_nemb_cmd(phba, &nonemb_cmd, NULL, NULL, 0);
+		beiscsi_free_nemb_cmd(phba, &nonemb_cmd, rc);
 		if (rc < 0) {
 			beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
 				    "BG_%d : failed to release existing DHCP: %d\n",
@@ -689,7 +699,7 @@ int beiscsi_if_en_dhcp(struct beiscsi_hba *phba, u32 ip_type)
 	dhcpreq->interface_hndl = phba->interface_handle;
 	dhcpreq->ip_type = ip_type;
 	rc = beiscsi_exec_nemb_cmd(phba, &nonemb_cmd, NULL, NULL, 0);
-
+	beiscsi_free_nemb_cmd(phba, &nonemb_cmd, rc);
 exit:
 	kfree(if_info);
 	return rc;
@@ -762,11 +772,8 @@ int beiscsi_if_get_info(struct beiscsi_hba *phba, int ip_type,
 				    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
 				    "BG_%d : Memory Allocation Failure\n");
 
-				/* Free the DMA memory for the IOCTL issuing */
-				dma_free_coherent(&phba->ctrl.pdev->dev,
-						    nonemb_cmd.size,
-						    nonemb_cmd.va,
-						    nonemb_cmd.dma);
+				beiscsi_free_nemb_cmd(phba, &nonemb_cmd,
+						      -ENOMEM);
 				return -ENOMEM;
 		}
 
@@ -781,15 +788,13 @@ int beiscsi_if_get_info(struct beiscsi_hba *phba, int ip_type,
 				      nonemb_cmd.va)->actual_resp_len;
 			ioctl_size += sizeof(struct be_cmd_req_hdr);
 
-			/* Free the previous allocated DMA memory */
-			dma_free_coherent(&phba->ctrl.pdev->dev, nonemb_cmd.size,
-					    nonemb_cmd.va,
-					    nonemb_cmd.dma);
-
+			beiscsi_free_nemb_cmd(phba, &nonemb_cmd, rc);
 			/* Free the virtual memory */
 			kfree(*if_info);
-		} else
+		} else {
+			beiscsi_free_nemb_cmd(phba, &nonemb_cmd, rc);
 			break;
+		}
 	} while (true);
 	return rc;
 }
@@ -806,8 +811,9 @@ int mgmt_get_nic_conf(struct beiscsi_hba *phba,
 	if (rc)
 		return rc;
 
-	return beiscsi_exec_nemb_cmd(phba, &nonemb_cmd, NULL,
-				     nic, sizeof(*nic));
+	rc = beiscsi_exec_nemb_cmd(phba, &nonemb_cmd, NULL, nic, sizeof(*nic));
+	beiscsi_free_nemb_cmd(phba, &nonemb_cmd, rc);
+	return rc;
 }
 
 static void beiscsi_boot_process_compl(struct beiscsi_hba *phba,
-- 
2.30.2

