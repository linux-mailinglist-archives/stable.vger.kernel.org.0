Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D3138A2B1
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbhETJo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:44:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232921AbhETJmR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:42:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4B2F613E5;
        Thu, 20 May 2021 09:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503144;
        bh=PI9mUQ2JDOPJOE+WSB7o6xEHrBxprJdiHEriszpD6QU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q/YtJVBy3XbgnjL4Vx9CcwpJJlBYqCbJys7YI3az9XZRoTHPEY1HQEKnpHhVR5ujz
         rXwhcOg73aq29hFJDvfQRh7OJH9JoVwe63mTeCGGGSS/CJHOTtChI13KuRQuN5N6xi
         88jtPCjRp5nrYK3gnZeSlPOv/48gQSuBPZuAGB5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 071/425] scsi: lpfc: Remove unsupported mbox PORT_CAPABILITIES logic
Date:   Thu, 20 May 2021 11:17:20 +0200
Message-Id: <20210520092133.787020973@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit b62232ba8caccaf1954e197058104a6478fac1af ]

SLI-4 does not contain a PORT_CAPABILITIES mailbox command (only SLI-3
does, and SLI-3 doesn't use it), yet there are SLI-4 code paths that have
code to issue the command.  The command will always fail.

Remove the code for the mailbox command and leave only the resulting
"failure path" logic.

Link: https://lore.kernel.org/r/20210412013127.2387-12-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_crtn.h |   3 -
 drivers/scsi/lpfc/lpfc_hw4.h  | 174 +---------------------------------
 drivers/scsi/lpfc/lpfc_init.c | 103 +-------------------
 drivers/scsi/lpfc/lpfc_mbox.c |  36 -------
 4 files changed, 3 insertions(+), 313 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index bea24bc4410a..1a0b1cb9de78 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -56,9 +56,6 @@ void lpfc_register_new_vport(struct lpfc_hba *, struct lpfc_vport *,
 void lpfc_unreg_vpi(struct lpfc_hba *, uint16_t, LPFC_MBOXQ_t *);
 void lpfc_init_link(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t, uint32_t);
 void lpfc_request_features(struct lpfc_hba *, struct lpfcMboxq *);
-void lpfc_supported_pages(struct lpfcMboxq *);
-void lpfc_pc_sli4_params(struct lpfcMboxq *);
-int lpfc_pc_sli4_params_get(struct lpfc_hba *, LPFC_MBOXQ_t *);
 int lpfc_sli4_mbox_rsrc_extent(struct lpfc_hba *, struct lpfcMboxq *,
 			   uint16_t, uint16_t, bool);
 int lpfc_get_sli4_parameters(struct lpfc_hba *, LPFC_MBOXQ_t *);
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 083f8c8706e5..a9bd12bfc15e 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -122,6 +122,7 @@ struct lpfc_sli_intf {
 /* Define SLI4 Alignment requirements. */
 #define LPFC_ALIGN_16_BYTE	16
 #define LPFC_ALIGN_64_BYTE	64
+#define SLI4_PAGE_SIZE		4096
 
 /* Define SLI4 specific definitions. */
 #define LPFC_MQ_CQE_BYTE_OFFSET	256
@@ -2886,62 +2887,6 @@ struct lpfc_mbx_request_features {
 #define lpfc_mbx_rq_ftr_rsp_mrqp_WORD		word3
 };
 
-struct lpfc_mbx_supp_pages {
-	uint32_t word1;
-#define qs_SHIFT 				0
-#define qs_MASK					0x00000001
-#define qs_WORD					word1
-#define wr_SHIFT				1
-#define wr_MASK 				0x00000001
-#define wr_WORD					word1
-#define pf_SHIFT				8
-#define pf_MASK					0x000000ff
-#define pf_WORD					word1
-#define cpn_SHIFT				16
-#define cpn_MASK				0x000000ff
-#define cpn_WORD				word1
-	uint32_t word2;
-#define list_offset_SHIFT 			0
-#define list_offset_MASK			0x000000ff
-#define list_offset_WORD			word2
-#define next_offset_SHIFT			8
-#define next_offset_MASK			0x000000ff
-#define next_offset_WORD			word2
-#define elem_cnt_SHIFT				16
-#define elem_cnt_MASK				0x000000ff
-#define elem_cnt_WORD				word2
-	uint32_t word3;
-#define pn_0_SHIFT				24
-#define pn_0_MASK  				0x000000ff
-#define pn_0_WORD				word3
-#define pn_1_SHIFT				16
-#define pn_1_MASK				0x000000ff
-#define pn_1_WORD				word3
-#define pn_2_SHIFT				8
-#define pn_2_MASK				0x000000ff
-#define pn_2_WORD				word3
-#define pn_3_SHIFT				0
-#define pn_3_MASK				0x000000ff
-#define pn_3_WORD				word3
-	uint32_t word4;
-#define pn_4_SHIFT				24
-#define pn_4_MASK				0x000000ff
-#define pn_4_WORD				word4
-#define pn_5_SHIFT				16
-#define pn_5_MASK				0x000000ff
-#define pn_5_WORD				word4
-#define pn_6_SHIFT				8
-#define pn_6_MASK				0x000000ff
-#define pn_6_WORD				word4
-#define pn_7_SHIFT				0
-#define pn_7_MASK				0x000000ff
-#define pn_7_WORD				word4
-	uint32_t rsvd[27];
-#define LPFC_SUPP_PAGES			0
-#define LPFC_BLOCK_GUARD_PROFILES	1
-#define LPFC_SLI4_PARAMETERS		2
-};
-
 struct lpfc_mbx_memory_dump_type3 {
 	uint32_t word1;
 #define lpfc_mbx_memory_dump_type3_type_SHIFT    0
@@ -3158,121 +3103,6 @@ struct user_eeprom {
 	uint8_t reserved191[57];
 };
 
-struct lpfc_mbx_pc_sli4_params {
-	uint32_t word1;
-#define qs_SHIFT				0
-#define qs_MASK					0x00000001
-#define qs_WORD					word1
-#define wr_SHIFT				1
-#define wr_MASK					0x00000001
-#define wr_WORD					word1
-#define pf_SHIFT				8
-#define pf_MASK					0x000000ff
-#define pf_WORD					word1
-#define cpn_SHIFT				16
-#define cpn_MASK				0x000000ff
-#define cpn_WORD				word1
-	uint32_t word2;
-#define if_type_SHIFT				0
-#define if_type_MASK				0x00000007
-#define if_type_WORD				word2
-#define sli_rev_SHIFT				4
-#define sli_rev_MASK				0x0000000f
-#define sli_rev_WORD				word2
-#define sli_family_SHIFT			8
-#define sli_family_MASK				0x000000ff
-#define sli_family_WORD				word2
-#define featurelevel_1_SHIFT			16
-#define featurelevel_1_MASK			0x000000ff
-#define featurelevel_1_WORD			word2
-#define featurelevel_2_SHIFT			24
-#define featurelevel_2_MASK			0x0000001f
-#define featurelevel_2_WORD			word2
-	uint32_t word3;
-#define fcoe_SHIFT 				0
-#define fcoe_MASK				0x00000001
-#define fcoe_WORD				word3
-#define fc_SHIFT				1
-#define fc_MASK					0x00000001
-#define fc_WORD					word3
-#define nic_SHIFT				2
-#define nic_MASK				0x00000001
-#define nic_WORD				word3
-#define iscsi_SHIFT				3
-#define iscsi_MASK				0x00000001
-#define iscsi_WORD				word3
-#define rdma_SHIFT				4
-#define rdma_MASK				0x00000001
-#define rdma_WORD				word3
-	uint32_t sge_supp_len;
-#define SLI4_PAGE_SIZE 4096
-	uint32_t word5;
-#define if_page_sz_SHIFT			0
-#define if_page_sz_MASK				0x0000ffff
-#define if_page_sz_WORD				word5
-#define loopbk_scope_SHIFT			24
-#define loopbk_scope_MASK			0x0000000f
-#define loopbk_scope_WORD			word5
-#define rq_db_window_SHIFT			28
-#define rq_db_window_MASK			0x0000000f
-#define rq_db_window_WORD			word5
-	uint32_t word6;
-#define eq_pages_SHIFT				0
-#define eq_pages_MASK				0x0000000f
-#define eq_pages_WORD				word6
-#define eqe_size_SHIFT				8
-#define eqe_size_MASK				0x000000ff
-#define eqe_size_WORD				word6
-	uint32_t word7;
-#define cq_pages_SHIFT				0
-#define cq_pages_MASK				0x0000000f
-#define cq_pages_WORD				word7
-#define cqe_size_SHIFT				8
-#define cqe_size_MASK				0x000000ff
-#define cqe_size_WORD				word7
-	uint32_t word8;
-#define mq_pages_SHIFT				0
-#define mq_pages_MASK				0x0000000f
-#define mq_pages_WORD				word8
-#define mqe_size_SHIFT				8
-#define mqe_size_MASK				0x000000ff
-#define mqe_size_WORD				word8
-#define mq_elem_cnt_SHIFT			16
-#define mq_elem_cnt_MASK			0x000000ff
-#define mq_elem_cnt_WORD			word8
-	uint32_t word9;
-#define wq_pages_SHIFT				0
-#define wq_pages_MASK				0x0000ffff
-#define wq_pages_WORD				word9
-#define wqe_size_SHIFT				8
-#define wqe_size_MASK				0x000000ff
-#define wqe_size_WORD				word9
-	uint32_t word10;
-#define rq_pages_SHIFT				0
-#define rq_pages_MASK				0x0000ffff
-#define rq_pages_WORD				word10
-#define rqe_size_SHIFT				8
-#define rqe_size_MASK				0x000000ff
-#define rqe_size_WORD				word10
-	uint32_t word11;
-#define hdr_pages_SHIFT				0
-#define hdr_pages_MASK				0x0000000f
-#define hdr_pages_WORD				word11
-#define hdr_size_SHIFT				8
-#define hdr_size_MASK				0x0000000f
-#define hdr_size_WORD				word11
-#define hdr_pp_align_SHIFT			16
-#define hdr_pp_align_MASK			0x0000ffff
-#define hdr_pp_align_WORD			word11
-	uint32_t word12;
-#define sgl_pages_SHIFT				0
-#define sgl_pages_MASK				0x0000000f
-#define sgl_pages_WORD				word12
-#define sgl_pp_align_SHIFT			16
-#define sgl_pp_align_MASK			0x0000ffff
-#define sgl_pp_align_WORD			word12
-	uint32_t rsvd_13_63[51];
-};
 #define SLI4_PAGE_ALIGN(addr) (((addr)+((SLI4_PAGE_SIZE)-1)) \
 			       &(~((SLI4_PAGE_SIZE)-1)))
 
@@ -3854,8 +3684,6 @@ struct lpfc_mqe {
 		struct lpfc_mbx_post_hdr_tmpl hdr_tmpl;
 		struct lpfc_mbx_query_fw_config query_fw_cfg;
 		struct lpfc_mbx_set_beacon_config beacon_config;
-		struct lpfc_mbx_supp_pages supp_pages;
-		struct lpfc_mbx_pc_sli4_params sli4_params;
 		struct lpfc_mbx_get_sli4_parameters get_sli4_parameters;
 		struct lpfc_mbx_set_link_diag_state link_diag_state;
 		struct lpfc_mbx_set_link_diag_loopback link_diag_loopback;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 57510a831735..c6caacaa3e7a 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5854,8 +5854,6 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	LPFC_MBOXQ_t *mboxq;
 	MAILBOX_t *mb;
 	int rc, i, max_buf_size;
-	uint8_t pn_page[LPFC_MAX_SUPPORTED_PAGES] = {0};
-	struct lpfc_mqe *mqe;
 	int longs;
 	int fof_vectors = 0;
 	int extra;
@@ -6150,32 +6148,6 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 
 	lpfc_nvme_mod_param_dep(phba);
 
-	/* Get the Supported Pages if PORT_CAPABILITIES is supported by port. */
-	lpfc_supported_pages(mboxq);
-	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
-	if (!rc) {
-		mqe = &mboxq->u.mqe;
-		memcpy(&pn_page[0], ((uint8_t *)&mqe->un.supp_pages.word3),
-		       LPFC_MAX_SUPPORTED_PAGES);
-		for (i = 0; i < LPFC_MAX_SUPPORTED_PAGES; i++) {
-			switch (pn_page[i]) {
-			case LPFC_SLI4_PARAMETERS:
-				phba->sli4_hba.pc_sli4_params.supported = 1;
-				break;
-			default:
-				break;
-			}
-		}
-		/* Read the port's SLI4 Parameters capabilities if supported. */
-		if (phba->sli4_hba.pc_sli4_params.supported)
-			rc = lpfc_pc_sli4_params_get(phba, mboxq);
-		if (rc) {
-			mempool_free(mboxq, phba->mbox_mem_pool);
-			rc = -EIO;
-			goto out_free_bsmbx;
-		}
-	}
-
 	/*
 	 * Get sli4 parameters that override parameters from Port capabilities.
 	 * If this call fails, it isn't critical unless the SLI4 parameters come
@@ -10517,78 +10489,6 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phba)
 	phba->pport->work_port_events = 0;
 }
 
- /**
- * lpfc_pc_sli4_params_get - Get the SLI4_PARAMS port capabilities.
- * @phba: Pointer to HBA context object.
- * @mboxq: Pointer to the mailboxq memory for the mailbox command response.
- *
- * This function is called in the SLI4 code path to read the port's
- * sli4 capabilities.
- *
- * This function may be be called from any context that can block-wait
- * for the completion.  The expectation is that this routine is called
- * typically from probe_one or from the online routine.
- **/
-int
-lpfc_pc_sli4_params_get(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
-{
-	int rc;
-	struct lpfc_mqe *mqe;
-	struct lpfc_pc_sli4_params *sli4_params;
-	uint32_t mbox_tmo;
-
-	rc = 0;
-	mqe = &mboxq->u.mqe;
-
-	/* Read the port's SLI4 Parameters port capabilities */
-	lpfc_pc_sli4_params(mboxq);
-	if (!phba->sli4_hba.intr_enable)
-		rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
-	else {
-		mbox_tmo = lpfc_mbox_tmo_val(phba, mboxq);
-		rc = lpfc_sli_issue_mbox_wait(phba, mboxq, mbox_tmo);
-	}
-
-	if (unlikely(rc))
-		return 1;
-
-	sli4_params = &phba->sli4_hba.pc_sli4_params;
-	sli4_params->if_type = bf_get(if_type, &mqe->un.sli4_params);
-	sli4_params->sli_rev = bf_get(sli_rev, &mqe->un.sli4_params);
-	sli4_params->sli_family = bf_get(sli_family, &mqe->un.sli4_params);
-	sli4_params->featurelevel_1 = bf_get(featurelevel_1,
-					     &mqe->un.sli4_params);
-	sli4_params->featurelevel_2 = bf_get(featurelevel_2,
-					     &mqe->un.sli4_params);
-	sli4_params->proto_types = mqe->un.sli4_params.word3;
-	sli4_params->sge_supp_len = mqe->un.sli4_params.sge_supp_len;
-	sli4_params->if_page_sz = bf_get(if_page_sz, &mqe->un.sli4_params);
-	sli4_params->rq_db_window = bf_get(rq_db_window, &mqe->un.sli4_params);
-	sli4_params->loopbk_scope = bf_get(loopbk_scope, &mqe->un.sli4_params);
-	sli4_params->eq_pages_max = bf_get(eq_pages, &mqe->un.sli4_params);
-	sli4_params->eqe_size = bf_get(eqe_size, &mqe->un.sli4_params);
-	sli4_params->cq_pages_max = bf_get(cq_pages, &mqe->un.sli4_params);
-	sli4_params->cqe_size = bf_get(cqe_size, &mqe->un.sli4_params);
-	sli4_params->mq_pages_max = bf_get(mq_pages, &mqe->un.sli4_params);
-	sli4_params->mqe_size = bf_get(mqe_size, &mqe->un.sli4_params);
-	sli4_params->mq_elem_cnt = bf_get(mq_elem_cnt, &mqe->un.sli4_params);
-	sli4_params->wq_pages_max = bf_get(wq_pages, &mqe->un.sli4_params);
-	sli4_params->wqe_size = bf_get(wqe_size, &mqe->un.sli4_params);
-	sli4_params->rq_pages_max = bf_get(rq_pages, &mqe->un.sli4_params);
-	sli4_params->rqe_size = bf_get(rqe_size, &mqe->un.sli4_params);
-	sli4_params->hdr_pages_max = bf_get(hdr_pages, &mqe->un.sli4_params);
-	sli4_params->hdr_size = bf_get(hdr_size, &mqe->un.sli4_params);
-	sli4_params->hdr_pp_align = bf_get(hdr_pp_align, &mqe->un.sli4_params);
-	sli4_params->sgl_pages_max = bf_get(sgl_pages, &mqe->un.sli4_params);
-	sli4_params->sgl_pp_align = bf_get(sgl_pp_align, &mqe->un.sli4_params);
-
-	/* Make sure that sge_supp_len can be handled by the driver */
-	if (sli4_params->sge_supp_len > LPFC_MAX_SGE_SIZE)
-		sli4_params->sge_supp_len = LPFC_MAX_SGE_SIZE;
-
-	return rc;
-}
-
 /**
  * lpfc_get_sli4_parameters - Get the SLI4 Config PARAMETERS.
  * @phba: Pointer to HBA context object.
@@ -10647,7 +10547,8 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	else
 		phba->sli3_options &= ~LPFC_SLI4_PHWQ_ENABLED;
 	sli4_params->sge_supp_len = mbx_sli4_parameters->sge_supp_len;
-	sli4_params->loopbk_scope = bf_get(loopbk_scope, mbx_sli4_parameters);
+	sli4_params->loopbk_scope = bf_get(cfg_loopbk_scope,
+					   mbx_sli4_parameters);
 	sli4_params->oas_supported = bf_get(cfg_oas, mbx_sli4_parameters);
 	sli4_params->cqv = bf_get(cfg_cqv, mbx_sli4_parameters);
 	sli4_params->mqv = bf_get(cfg_mqv, mbx_sli4_parameters);
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index e6bf5e8bc767..a4c382d2ce79 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -2622,39 +2622,3 @@ lpfc_resume_rpi(struct lpfcMboxq *mbox, struct lpfc_nodelist *ndlp)
 	resume_rpi->event_tag = ndlp->phba->fc_eventTag;
 }
 
-/**
- * lpfc_supported_pages - Initialize the PORT_CAPABILITIES supported pages
- *                        mailbox command.
- * @mbox: pointer to lpfc mbox command to initialize.
- *
- * The PORT_CAPABILITIES supported pages mailbox command is issued to
- * retrieve the particular feature pages supported by the port.
- **/
-void
-lpfc_supported_pages(struct lpfcMboxq *mbox)
-{
-	struct lpfc_mbx_supp_pages *supp_pages;
-
-	memset(mbox, 0, sizeof(*mbox));
-	supp_pages = &mbox->u.mqe.un.supp_pages;
-	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_PORT_CAPABILITIES);
-	bf_set(cpn, supp_pages, LPFC_SUPP_PAGES);
-}
-
-/**
- * lpfc_pc_sli4_params - Initialize the PORT_CAPABILITIES SLI4 Params mbox cmd.
- * @mbox: pointer to lpfc mbox command to initialize.
- *
- * The PORT_CAPABILITIES SLI4 parameters mailbox command is issued to
- * retrieve the particular SLI4 features supported by the port.
- **/
-void
-lpfc_pc_sli4_params(struct lpfcMboxq *mbox)
-{
-	struct lpfc_mbx_pc_sli4_params *sli4_params;
-
-	memset(mbox, 0, sizeof(*mbox));
-	sli4_params = &mbox->u.mqe.un.sli4_params;
-	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_PORT_CAPABILITIES);
-	bf_set(cpn, sli4_params, LPFC_SLI4_PARAMETERS);
-}
-- 
2.30.2



