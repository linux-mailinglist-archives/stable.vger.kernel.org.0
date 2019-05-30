Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 840662F4A1
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729105AbfE3DMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:12:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729095AbfE3DMe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:34 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5DDC23DE3;
        Thu, 30 May 2019 03:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185952;
        bh=G0WwxCGxWt8M2yPclyrVs6do+B1idp9xfogDxJogi1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8TLKDQrTv0jTBy0zDTk+eZoLeQTYb0L+DqVsgSuyHw/2RAZGZEusz292Fi5NrYFi
         YR6g9Bj2oOgo4zBq1atVAHwsAVVG+55M4LPHVlfh0Smif2HyRV5fp+WuUEQgcF8LyY
         /+vernLuXWFeVmYP5S8472e7w/bEadyaMLY3ePzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 367/405] scsi: lpfc: Fix mailbox hang on adapter init
Date:   Wed, 29 May 2019 20:06:05 -0700
Message-Id: <20190530030559.267293822@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e8869f5b0a7273fcf20ef99066fd8129e58ba5b7 ]

The adapter initialization sequence enables interrupts, initializes the
adapter link_state to LINK_DOWN, then issues commands to initialize the
adapter. The interrupt handler on the adapter validates the link_state (has
to be at least LINK_DOWN) and if invalid, will discard the interrupting
event.

In most cases, there is not a command completion, thus an interrupt until
the initialization commands have been sent which is post the setting of
state to LINK_DOWN.  However, in cases of firmware reset, the reset will
modify the link_state to an invalid value (indicating a reset of the
adapter) and there occasionally are cases where the adapter will generate
an asynchronous event which shares the eq/cq used for mailbox commands. In
the failure case, an interrupt is generated immediately after enabling them
due to the async event.  As link_state is invalid, the eq is list and the
CQ not serviced.  At this point link_state is initialized and the mailbox
command sent.  As the CQ has not been serviced, it is not armed, so no
interrupt event is generated when the mailbox command completes.

Modify the initialization sequence so that interrupts are enabled after
link_state is properly initialized, which avoids the race condition with
the async event.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 57b4a463b5892..7d2abb70cf093 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7652,12 +7652,6 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 		phba->cfg_xri_rebalancing = 0;
 	}
 
-	/* Arm the CQs and then EQs on device */
-	lpfc_sli4_arm_cqeq_intr(phba);
-
-	/* Indicate device interrupt mode */
-	phba->sli4_hba.intr_enable = 1;
-
 	/* Allow asynchronous mailbox command to go through */
 	spin_lock_irq(&phba->hbalock);
 	phba->sli.sli_flag &= ~LPFC_SLI_ASYNC_MBX_BLK;
@@ -7726,6 +7720,12 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 		phba->trunk_link.link3.state = LPFC_LINK_DOWN;
 	spin_unlock_irq(&phba->hbalock);
 
+	/* Arm the CQs and then EQs on device */
+	lpfc_sli4_arm_cqeq_intr(phba);
+
+	/* Indicate device interrupt mode */
+	phba->sli4_hba.intr_enable = 1;
+
 	if (!(phba->hba_flag & HBA_FCOE_MODE) &&
 	    (phba->hba_flag & LINK_DISABLED)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT | LOG_SLI,
-- 
2.20.1



