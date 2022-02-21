Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D309A4BE02E
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347895AbiBUJKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:10:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347915AbiBUJJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:09:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E61A1D0F2;
        Mon, 21 Feb 2022 01:02:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E695B80EAC;
        Mon, 21 Feb 2022 09:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D34DC340E9;
        Mon, 21 Feb 2022 09:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434137;
        bh=fY2l95feaFzhw++5GbsdRjIvm2NcSG/lDajlKI9Tnns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AC9QHYk4lyhnethz1likCIGCpsg1VNjUcEmpYztTD7xKYNBdxX/QtaTiuklhlMPX3
         MSK0bIUDgWMbn0aOz/Lp6YcNl0JyQg5Dw+kc/3Vy8kMzCzuetGrWTm5RN32q55RZpj
         IgaZJbOsOfbqCiACrfh8qzV37Ih5xQl7XV5Tb1Ck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nigel Kirkland <nkirkland2304@gmail.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 008/121] scsi: lpfc: Fix mailbox command failure during driver initialization
Date:   Mon, 21 Feb 2022 09:48:20 +0100
Message-Id: <20220221084921.432277744@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

commit efe1dc571a5b808baa26682eef16561be2e356fd upstream.

Contention for the mailbox interface may occur during driver initialization
(immediately after a function reset), between mailbox commands initiated
via ioctl (bsg) and those driver requested by the driver.

After setting SLI_ACTIVE flag for a port, there is a window in which the
driver will allow an ioctl to be initiated while the adapter is
initializing and issuing mailbox commands via polling. The polling logic
then gets confused.

Correct by having thread setting SLI_ACTIVE spot an active mailbox command
and allow it complete before proceeding.

Link: https://lore.kernel.org/r/20210921143008.64212-1-jsmart2021@gmail.com
Co-developed-by: Nigel Kirkland <nkirkland2304@gmail.com>
Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_sli.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7372,6 +7372,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 	struct lpfc_vport *vport = phba->pport;
 	struct lpfc_dmabuf *mp;
 	struct lpfc_rqb *rqbp;
+	u32 flg;
 
 	/* Perform a PCI function reset to start from clean */
 	rc = lpfc_pci_function_reset(phba);
@@ -7385,7 +7386,17 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 	else {
 		spin_lock_irq(&phba->hbalock);
 		phba->sli.sli_flag |= LPFC_SLI_ACTIVE;
+		flg = phba->sli.sli_flag;
 		spin_unlock_irq(&phba->hbalock);
+		/* Allow a little time after setting SLI_ACTIVE for any polled
+		 * MBX commands to complete via BSG.
+		 */
+		for (i = 0; i < 50 && (flg & LPFC_SLI_MBOX_ACTIVE); i++) {
+			msleep(20);
+			spin_lock_irq(&phba->hbalock);
+			flg = phba->sli.sli_flag;
+			spin_unlock_irq(&phba->hbalock);
+		}
 	}
 
 	lpfc_sli4_dip(phba);
@@ -8922,7 +8933,7 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *
 					"(%d):2541 Mailbox command x%x "
 					"(x%x/x%x) failure: "
 					"mqe_sta: x%x mcqe_sta: x%x/x%x "
-					"Data: x%x x%x\n,",
+					"Data: x%x x%x\n",
 					mboxq->vport ? mboxq->vport->vpi : 0,
 					mboxq->u.mb.mbxCommand,
 					lpfc_sli_config_mbox_subsys_get(phba,
@@ -8956,7 +8967,7 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *
 					"(%d):2597 Sync Mailbox command "
 					"x%x (x%x/x%x) failure: "
 					"mqe_sta: x%x mcqe_sta: x%x/x%x "
-					"Data: x%x x%x\n,",
+					"Data: x%x x%x\n",
 					mboxq->vport ? mboxq->vport->vpi : 0,
 					mboxq->u.mb.mbxCommand,
 					lpfc_sli_config_mbox_subsys_get(phba,


