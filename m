Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F326608A37
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbiJVIsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234886AbiJVIrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:47:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A34E1B1F1;
        Sat, 22 Oct 2022 01:09:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1A3EB82E0D;
        Sat, 22 Oct 2022 08:06:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72F3C433D6;
        Sat, 22 Oct 2022 08:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666426003;
        bh=ZFoYiT9y2/iVY1FbCrXKpOhrfl3lZzZKHp9H5oPiBIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kHcI2kDFfhNbaZN/54J/hgEec2hb0d0fpSCfKCFs/mChB67bIiZyiZsMApG8kvWzd
         3tD42fS1wGCtE030KqAeAnnBNT312MQc3Ym3eIhv/CFT/86jvwCnc8b83N14rfQM9C
         VWmIrB7vHT78OELjsz2qxKnGiLX9Dthgy6YUyOi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 657/717] scsi: lpfc: Fix null ndlp ptr dereference in abnormal exit path for GFT_ID
Date:   Sat, 22 Oct 2022 09:28:56 +0200
Message-Id: <20221022072527.464672525@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



