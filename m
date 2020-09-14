Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C32268D7E
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 16:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgINOZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 10:25:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:32912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726676AbgINNGP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 09:06:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57E6822206;
        Mon, 14 Sep 2020 13:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088732;
        bh=PLDnCob4qOnx8MoDAzF8jK/Lj2hpnJ6NEWBajDcMRJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z0xENW+oJ/c7gFDvZuHugGPnMC4ilRHCNsJ8avDXb2XTcF3d6074+ywkcKhlfbjK1
         jbr6nKUbRat8PHoae852RpAtWKp64WdMeCLMeIN3MQbZBDfxop01SSsXY8gSaGDB+L
         ZEF1lT3Tw/5QRuIIMHg6g30Mkp1zaD4VdrcKCEGQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 04/15] scsi: lpfc: Fix FLOGI/PLOGI receive race condition in pt2pt discovery
Date:   Mon, 14 Sep 2020 09:05:15 -0400
Message-Id: <20200914130526.1804913-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130526.1804913-1-sashal@kernel.org>
References: <20200914130526.1804913-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
index db1111f7e85ae..566e8d07cb058 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4104,7 +4104,9 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
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

