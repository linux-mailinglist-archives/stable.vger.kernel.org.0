Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABEC42B621C
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731322AbgKQNZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:25:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:60818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730802AbgKQNZb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:25:31 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E31312464E;
        Tue, 17 Nov 2020 13:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619529;
        bh=s630rPJpfJFLHqRNgQjNroUDIE3HyVQs2IOZYkqHzvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eds+TWY1Cv5XOt+eAnNNYJdNPg68Z9/B0z/rnpBCIUx3Ps7foRsYuh00pN17IQVA/
         TBoSr+Xzx+uuaHWBxD7DChiymhGjZnjohr83/fSRvMvO/zVWezpw2LvdRSlC70PSaE
         rXx+H97CBiDmy3HNfgDz4TlLg3+i0gi/qEcyOD8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/151] scsi: mpt3sas: Fix timeouts observed while reenabling IRQ
Date:   Tue, 17 Nov 2020 14:04:58 +0100
Message-Id: <20201117122124.733178204@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



