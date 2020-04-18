Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F321AEDE7
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgDROJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:09:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbgDROJX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:09:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ECE221BE5;
        Sat, 18 Apr 2020 14:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587218962;
        bh=ph0iQQL/AbdQ9iyH2X+nCR5kmfMMJ5dzpVPItmfr5Ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=edo3TLT8KEc3e6C7tue/mZiTpVHl7yJJT7KjDVDnGOdE2KyQ4uWLu1JQphQDn3jHS
         fXu8SYXB4J2bQhYYIsnKhAAm5QQfISy1LwLuR9D1ARyXwC2NzN18w3XK12nnFZTqhe
         BfosbJqMyhXac7he3IGf+OztvC1CEpATm2HhC4hI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 10/75] scsi: lpfc: Fix crash after handling a pci error
Date:   Sat, 18 Apr 2020 10:08:05 -0400
Message-Id: <20200418140910.8280-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418140910.8280-1-sashal@kernel.org>
References: <20200418140910.8280-1-sashal@kernel.org>
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
index 993b1056beb83..909554c7c1273 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4046,6 +4046,11 @@ lpfc_sli_flush_io_rings(struct lpfc_hba *phba)
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

