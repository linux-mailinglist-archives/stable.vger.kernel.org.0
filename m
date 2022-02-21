Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A161D4BE789
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348458AbiBUJUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:20:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348574AbiBUJTj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:19:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D3B33E3E;
        Mon, 21 Feb 2022 01:07:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D31A16112F;
        Mon, 21 Feb 2022 09:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA16C340E9;
        Mon, 21 Feb 2022 09:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434449;
        bh=ewdxi9hgGmr5HP1M9SuoF72mT/b/4gFiUqS6P8tN7Ec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tsVwSZKo5qp4jvpBvFF4ywFBulifvhWA5R3lUcZdVWqyrZULQYB+Gr+q43qNvvIi7
         +bRp1m81zKzzl7CPkWjhCv9EiBKeptbc6dKzYLYnm7d9GY3PlyKRs5gMQTqJGWiQtr
         vkCcNYjCVTvZYkOLnsb6ar85TV45EkcpbSw1C0KM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nigel Kirkland <nkirkland2304@gmail.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 004/196] scsi: lpfc: Fix mailbox command failure during driver initialization
Date:   Mon, 21 Feb 2022 09:47:16 +0100
Message-Id: <20220221084931.025316397@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
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
@@ -8147,6 +8147,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 	struct lpfc_vport *vport = phba->pport;
 	struct lpfc_dmabuf *mp;
 	struct lpfc_rqb *rqbp;
+	u32 flg;
 
 	/* Perform a PCI function reset to start from clean */
 	rc = lpfc_pci_function_reset(phba);
@@ -8160,7 +8161,17 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
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
@@ -9744,7 +9755,7 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *
 					"(%d):2541 Mailbox command x%x "
 					"(x%x/x%x) failure: "
 					"mqe_sta: x%x mcqe_sta: x%x/x%x "
-					"Data: x%x x%x\n,",
+					"Data: x%x x%x\n",
 					mboxq->vport ? mboxq->vport->vpi : 0,
 					mboxq->u.mb.mbxCommand,
 					lpfc_sli_config_mbox_subsys_get(phba,
@@ -9778,7 +9789,7 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *
 					"(%d):2597 Sync Mailbox command "
 					"x%x (x%x/x%x) failure: "
 					"mqe_sta: x%x mcqe_sta: x%x/x%x "
-					"Data: x%x x%x\n,",
+					"Data: x%x x%x\n",
 					mboxq->vport ? mboxq->vport->vpi : 0,
 					mboxq->u.mb.mbxCommand,
 					lpfc_sli_config_mbox_subsys_get(phba,


