Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 689C22ACD68
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733044AbgKJDzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:55:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:56464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730684AbgKJDzO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:55:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8BB6221FF;
        Tue, 10 Nov 2020 03:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980513;
        bh=s630rPJpfJFLHqRNgQjNroUDIE3HyVQs2IOZYkqHzvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C9bFcOcAGx8p9n0W9IkHe3KN3cWU8UQwFQr78WfnOlHZn467+phmZLUo29WYm1hBG
         lpd47m5EqDAMawpyChh3V+McoQNcDAqKiDsB+IOhlwhzI0eJMx4NjOmmyx4CvcvkBa
         m9tosrbdIXoj9oYcc+P1bgqua+6YB1aKmlMHPApM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Tomas Henzl <thenzl@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 23/42] scsi: mpt3sas: Fix timeouts observed while reenabling IRQ
Date:   Mon,  9 Nov 2020 22:54:21 -0500
Message-Id: <20201110035440.424258-23-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035440.424258-1-sashal@kernel.org>
References: <20201110035440.424258-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 5feed64f9199ff90c4239971733f23f30aeb2484 ]

While reenabling the IRQ after irq poll there may be small time window
where HBA firmware has posted some replies and raise the interrupts but
driver has not received the interrupts. So we may observe I/O timeouts as
the driver has not processed the replies as interrupts got missed while
reenabling the IRQ.

To fix this issue the driver has to go for one more round of processing the
reply descriptors from reply descriptor post queue after enabling the IRQ.

Link: https://lore.kernel.org/r/20201102072746.27410-1-sreekanth.reddy@broadcom.com
Reported-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 3d58d24de6b61..8be8c510fdf79 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1641,6 +1641,13 @@ _base_irqpoll(struct irq_poll *irqpoll, int budget)
 		reply_q->irq_poll_scheduled = false;
 		reply_q->irq_line_enable = true;
 		enable_irq(reply_q->os_irq);
+		/*
+		 * Go for one more round of processing the
+		 * reply descriptor post queue incase if HBA
+		 * Firmware has posted some reply descriptors
+		 * while reenabling the IRQ.
+		 */
+		_base_process_reply_queue(reply_q);
 	}
 
 	return num_entries;
-- 
2.27.0

