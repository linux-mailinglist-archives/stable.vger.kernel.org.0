Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCDD1AF14D
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgDROzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:55:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726829AbgDROk7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:40:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E3CB22260;
        Sat, 18 Apr 2020 14:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587220859;
        bh=Mdw7Him3EymDcdIY7gAAk8w+vDf/GjKNRMZsatnbAuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2bui66LWaOOdDNSxb1B78BTRiN08hljw/sQI/BU6T7cJn/wrhQSDA2zp3+baXbZcY
         CZMGfBHkpOmhd2p0x/FY9wNz7Vp7jgCBimzSTnyOuXDaH6QbHVfQTDLm0LNNd7yhVt
         CgWLgDwa9AA9WkPsWewFtboQwuJ2hYB0FH6PO8rc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/78] scsi: lpfc: Fix crash after handling a pci error
Date:   Sat, 18 Apr 2020 10:39:38 -0400
Message-Id: <20200418144047.9013-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418144047.9013-1-sashal@kernel.org>
References: <20200418144047.9013-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 4cd70891308dfb875ef31060c4a4aa8872630a2e ]

Injecting EEH on a 32GB card is causing kernel oops

The pci error handler is doing an IO flush and the offline code is also
doing an IO flush. When the 1st flush is complete the hdwq is destroyed
(freed), yet the second flush accesses the hdwq and crashes.

Added a check in lpfc_sli4_fush_io_rings to check both the HBA_IOQ_FLUSH
flag and the hdwq pointer to see if it is already set and not already
freed.

Link: https://lore.kernel.org/r/20200322181304.37655-6-jsmart2021@gmail.com
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 8836c5682c8d5..4e04270cc5c4f 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4012,6 +4012,11 @@ lpfc_sli_flush_io_rings(struct lpfc_hba *phba)
 	struct lpfc_iocbq *piocb, *next_iocb;
 
 	spin_lock_irq(&phba->hbalock);
+	if (phba->hba_flag & HBA_IOQ_FLUSH ||
+	    !phba->sli4_hba.hdwq) {
+		spin_unlock_irq(&phba->hbalock);
+		return;
+	}
 	/* Indicate the I/O queues are flushed */
 	phba->hba_flag |= HBA_IOQ_FLUSH;
 	spin_unlock_irq(&phba->hbalock);
-- 
2.20.1

