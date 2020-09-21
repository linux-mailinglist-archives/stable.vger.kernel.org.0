Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805C0272DCA
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729568AbgIUQnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729562AbgIUQnP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:43:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 782DE235F9;
        Mon, 21 Sep 2020 16:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706595;
        bh=3oTBHsTFSaSjiAFuk1w5MRsRzcO9Ats6ervYAEvAuDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wRcyUtRXALsW7+bkVdy8MuUCcgMVOZRLlG150YlZeNwvsSNFVKCSVkCa/BEmmtymh
         BnvPHCRFjaj3XPyEeVzGM8tK/yArMf08x+JLdLT69KL3PeClxGwCuYkWkACAvtf0Rl
         489xCUbINsCWt75+YySBgPJloCiWvBp53ZwdcL08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 016/118] scsi: lpfc: Fix FLOGI/PLOGI receive race condition in pt2pt discovery
Date:   Mon, 21 Sep 2020 18:27:08 +0200
Message-Id: <20200921162037.086175129@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <james.smart@broadcom.com>

[ Upstream commit 7b08e89f98cee9907895fabb64cf437bc505ce9a ]

The driver is unable to successfully login with remote device. During pt2pt
login, the driver completes its FLOGI request with the remote device having
WWN precedence.  The remote device issues its own (delayed) FLOGI after
accepting the driver's and, upon transmitting the FLOGI, immediately
recognizes it has already processed the driver's FLOGI thus it transitions
to sending a PLOGI before waiting for an ACC to its FLOGI.

In the driver, the FLOGI is received and an ACC sent, followed by the PLOGI
being received and an ACC sent. The issue is that the PLOGI reception
occurs before the response from the adapter from the FLOGI ACC is
received. Processing of the PLOGI sets state flags to perform the REG_RPI
mailbox command and proceed with the rest of discovery on the port. The
same completion routine used by both FLOGI and PLOGI is generic in
nature. One of the things it does is clear flags, and those flags happen to
drive the rest of discovery.  So what happened was the PLOGI processing set
the flags, the FLOGI ACC completion cleared them, thus when the PLOGI ACC
completes it doesn't see the flags and stops.

Fix by modifying the generic completion routine to not clear the rest of
discovery flag (NLP_ACC_REGLOGIN) unless the completion is also associated
with performing a mailbox command as part of its handling.  For things such
as FLOGI ACC, there isn't a subsequent action to perform with the adapter,
thus there is no mailbox cmd ptr. PLOGI ACC though will perform REG_RPI
upon completion, thus there is a mailbox cmd ptr.

Link: https://lore.kernel.org/r/20200828175332.130300-3-james.smart@broadcom.com
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 3d670568a2760..7b6a210825677 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4644,7 +4644,9 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 out:
 	if (ndlp && NLP_CHK_NODE_ACT(ndlp) && shost) {
 		spin_lock_irq(shost->host_lock);
-		ndlp->nlp_flag &= ~(NLP_ACC_REGLOGIN | NLP_RM_DFLT_RPI);
+		if (mbox)
+			ndlp->nlp_flag &= ~NLP_ACC_REGLOGIN;
+		ndlp->nlp_flag &= ~NLP_RM_DFLT_RPI;
 		spin_unlock_irq(shost->host_lock);
 
 		/* If the node is not being used by another discovery thread,
-- 
2.25.1



