Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2E35417E3
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378494AbiFGVGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379546AbiFGVGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:06:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E8B1CA5EA;
        Tue,  7 Jun 2022 11:49:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23C58616B6;
        Tue,  7 Jun 2022 18:49:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D30C385A5;
        Tue,  7 Jun 2022 18:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627782;
        bh=GfWpQ2f0XwiJpFMuX9ehdEugJEOsWkQR8NGeRHa91uU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A2JOD7Wkxp7ce+bT/xFdzMJFgj4XFKMoQyQGhoz2geWa0bxofXjrSY3Ow/TbHfFkk
         0QIsh1EudL+SNrZ+sLGlj9vjkjE8kgmN7rWLMIfP3Ubj+990yj9L0awWiRWUtjDDVI
         TGM9LShDvtnOTTD23d9JaKTKq8CwVO5xv0qxCnlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 091/879] scsi: lpfc: Protect memory leak for NPIV ports sending PLOGI_RJT
Date:   Tue,  7 Jun 2022 18:53:29 +0200
Message-Id: <20220607165005.334825025@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 672d1cb40551ea9c95efad43ab6d45e4ab4e015f ]

There is a potential memory leak in lpfc_ignore_els_cmpl() and
lpfc_els_rsp_reject() that was allocated from NPIV PLOGI_RJT
(lpfc_rcv_plogi()'s login_mbox).

Check if cmdiocb->context_un.mbox was allocated in lpfc_ignore_els_cmpl(),
and then free it back to phba->mbox_mem_pool along with mbox->ctx_buf for
service parameters.

For lpfc_els_rsp_reject() failure, free both the ctx_buf for service
parameters and the login_mbox.

Link: https://lore.kernel.org/r/20220412222008.126521-10-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 10 ++++++++--
 drivers/scsi/lpfc/lpfc_sli.c       | 17 +++++++++++++++++
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index c4e1a07066a2..4b065c51ee1b 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -614,9 +614,15 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		stat.un.b.lsRjtRsnCode = LSRJT_INVALID_CMD;
 		stat.un.b.lsRjtRsnCodeExp = LSEXP_NOTHING_MORE;
 		rc = lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb,
-			ndlp, login_mbox);
-		if (rc)
+					 ndlp, login_mbox);
+		if (rc) {
+			mp = (struct lpfc_dmabuf *)login_mbox->ctx_buf;
+			if (mp) {
+				lpfc_mbuf_free(phba, mp->virt, mp->phys);
+				kfree(mp);
+			}
 			mempool_free(login_mbox, phba->mbox_mem_pool);
+		}
 		return 1;
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 6adaf79e67cc..09a45f8ecf3f 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12066,6 +12066,8 @@ lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 {
 	struct lpfc_nodelist *ndlp = NULL;
 	IOCB_t *irsp;
+	LPFC_MBOXQ_t *mbox;
+	struct lpfc_dmabuf *mp;
 	u32 ulp_command, ulp_status, ulp_word4, iotag;
 
 	ulp_command = get_job_cmnd(phba, cmdiocb);
@@ -12077,6 +12079,21 @@ lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	} else {
 		irsp = &rspiocb->iocb;
 		iotag = irsp->ulpIoTag;
+
+		/* It is possible a PLOGI_RJT for NPIV ports to get aborted.
+		 * The MBX_REG_LOGIN64 mbox command is freed back to the
+		 * mbox_mem_pool here.
+		 */
+		if (cmdiocb->context_un.mbox) {
+			mbox = cmdiocb->context_un.mbox;
+			mp = (struct lpfc_dmabuf *)mbox->ctx_buf;
+			if (mp) {
+				lpfc_mbuf_free(phba, mp->virt, mp->phys);
+				kfree(mp);
+			}
+			mempool_free(mbox, phba->mbox_mem_pool);
+			cmdiocb->context_un.mbox = NULL;
+		}
 	}
 
 	/* ELS cmd tag <ulpIoTag> completes */
-- 
2.35.1



