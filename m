Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448385FD0E1
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbiJMAaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbiJMA3U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:29:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7495D129752;
        Wed, 12 Oct 2022 17:26:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E60F7B81CC3;
        Thu, 13 Oct 2022 00:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAAFC433C1;
        Thu, 13 Oct 2022 00:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620347;
        bh=ZFoYiT9y2/iVY1FbCrXKpOhrfl3lZzZKHp9H5oPiBIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BnGTpvdt7Hzg3DfIs/O1BxcFTcE6VEsNzmUwyti0XgoJVpmpvp/jx7Ms+r1RxlEME
         pvrDZ2G0yGiPaNoMq7rHBwhotogxKnBjAJDAB9SF5C9WYgnmLXQ8TAj1XpCF2BK5PA
         oYANTpS5EXNJaJDlJrX/PgGT6TjdZm8WylCy1Eiq+UXMQfS4OEmJeSo0V4ATlpDGoW
         gEBTAsZMMVPjU+aCLADyfPKkmQGBHzvMl92pYSo7pezIZE3X+0D3fbSE+LByCyX5B3
         SpJqOQ7qqa+69P2Rh2Ru2wgdchnwostYshkplHLEyI/AjQdiI1O26YP+R1o3HqMrQM
         Js2VQzpXbO3PQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 09/63] scsi: lpfc: Fix null ndlp ptr dereference in abnormal exit path for GFT_ID
Date:   Wed, 12 Oct 2022 20:17:43 -0400
Message-Id: <20221013001842.1893243-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001842.1893243-1-sashal@kernel.org>
References: <20221013001842.1893243-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 59b7e210a522b836a01516c71ee85d1d92c1f075 ]

An error case exit from lpfc_cmpl_ct_cmd_gft_id() results in a call to
lpfc_nlp_put() with a null pointer to a nodelist structure.

Changed lpfc_cmpl_ct_cmd_gft_id() to initialize nodelist pointer upon
entry.

Link: https://lore.kernel.org/r/20220819011736.14141-3-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_ct.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 13dfe285493d..b555ccb5ae34 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1509,7 +1509,7 @@ lpfc_cmpl_ct_cmd_gft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_sli_ct_request *CTrsp;
 	int did;
 	struct lpfc_nodelist *ndlp = NULL;
-	struct lpfc_nodelist *ns_ndlp = NULL;
+	struct lpfc_nodelist *ns_ndlp = cmdiocb->ndlp;
 	uint32_t fc4_data_0, fc4_data_1;
 	u32 ulp_status = get_job_ulpstatus(phba, rspiocb);
 	u32 ulp_word4 = get_job_word4(phba, rspiocb);
@@ -1522,15 +1522,12 @@ lpfc_cmpl_ct_cmd_gft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			      ulp_status, ulp_word4, did);
 
 	/* Ignore response if link flipped after this request was made */
-	if ((uint32_t) cmdiocb->event_tag != phba->fc_eventTag) {
+	if ((uint32_t)cmdiocb->event_tag != phba->fc_eventTag) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 				 "9046 Event tag mismatch. Ignoring NS rsp\n");
 		goto out;
 	}
 
-	/* Preserve the nameserver node to release the reference. */
-	ns_ndlp = cmdiocb->ndlp;
-
 	if (ulp_status == IOSTAT_SUCCESS) {
 		/* Good status, continue checking */
 		CTrsp = (struct lpfc_sli_ct_request *)outp->virt;
-- 
2.35.1

