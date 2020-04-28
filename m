Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0ED1BCB12
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgD1Sx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730064AbgD1See (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:34:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6673821707;
        Tue, 28 Apr 2020 18:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098873;
        bh=2ljyNe12FS2y0Tkn2bvU7tbSgoTZOjBeAZoiWEP65sY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y1uGqttDn81bna15sFbJYKQksHitx6PhE1azjPctOWywTMjpx7OwQ6liMaDsT5g4x
         XaUV0VnEtZkwySdAuqiFJZwgaUITCJW5Bb1PCO8EtFhDFvrq1m9H2L+28u1+TFu08q
         mivJ3IjikCnmhs2euvQ1XJpKJdIUZWbpgSnk1KUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 011/168] scsi: lpfc: Fix crash after handling a pci error
Date:   Tue, 28 Apr 2020 20:23:05 +0200
Message-Id: <20200428182233.120645460@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1692ce913b7f0..a951e1c8165ed 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4013,6 +4013,11 @@ lpfc_sli_flush_io_rings(struct lpfc_hba *phba)
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



