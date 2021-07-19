Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8E93CE479
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348448AbhGSPny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:43:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245165AbhGSPkZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:40:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0314F611C1;
        Mon, 19 Jul 2021 16:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711618;
        bh=hucvAjf7n1mJVZnpAaKqNBDoznWdp1azf2UkJBhV4mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XKMhYQHq5TBD9l4cm70OchAZzhgFjB0npf6C0RQ6Cg3b0sxdQhFsmiUPcqaDiVv4V
         EepMexx3SDY/xtLUALljYovSM0n8k9BkhD/twVEv90HAXmrsSsihyYx0rUxDlwcKD9
         4/WE+8uRWCvOyAmpj123qy8L2bWRYbKQAZwTDT4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>,
        kernel test robot <lkp@intel.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 069/292] scsi: megaraid_sas: Handle missing interrupts while re-enabling IRQs
Date:   Mon, 19 Jul 2021 16:52:11 +0200
Message-Id: <20210719144944.786145362@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit 9bedd36e9146b34dda4d6994e3aa1d72bc6442c1 ]

While reenabling the IRQ after IRQ poll there may be a small window for the
firmware to post the replies with interrupts raised. In that case the
driver will not see the interrupts which leads to I/O timeout.

This issue only happens when there are many I/O completions on a single
reply queue. This forces the driver to switch between the interrupt and IRQ
context.

Make the driver process the reply queue one more time after enabling the
IRQ.

Link: https://lore.kernel.org/linux-scsi/20201102072746.27410-1-sreekanth.reddy@broadcom.com/
Link: https://lore.kernel.org/r/20210528131307.25683-5-chandrakanth.patil@broadcom.com
Cc: Tomas Henzl <thenzl@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 54f8a8073ca0..5abb84ebc0ed 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3676,6 +3676,7 @@ static void megasas_sync_irqs(unsigned long instance_addr)
 		if (irq_ctx->irq_poll_scheduled) {
 			irq_ctx->irq_poll_scheduled = false;
 			enable_irq(irq_ctx->os_irq);
+			complete_cmd_fusion(instance, irq_ctx->MSIxIndex, irq_ctx);
 		}
 	}
 }
@@ -3707,6 +3708,7 @@ int megasas_irqpoll(struct irq_poll *irqpoll, int budget)
 		irq_poll_complete(irqpoll);
 		irq_ctx->irq_poll_scheduled = false;
 		enable_irq(irq_ctx->os_irq);
+		complete_cmd_fusion(instance, irq_ctx->MSIxIndex, irq_ctx);
 	}
 
 	return num_entries;
@@ -3723,6 +3725,7 @@ megasas_complete_cmd_dpc_fusion(unsigned long instance_addr)
 {
 	struct megasas_instance *instance =
 		(struct megasas_instance *)instance_addr;
+	struct megasas_irq_context *irq_ctx = NULL;
 	u32 count, MSIxIndex;
 
 	count = instance->msix_vectors > 0 ? instance->msix_vectors : 1;
@@ -3731,8 +3734,10 @@ megasas_complete_cmd_dpc_fusion(unsigned long instance_addr)
 	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR)
 		return;
 
-	for (MSIxIndex = 0 ; MSIxIndex < count; MSIxIndex++)
-		complete_cmd_fusion(instance, MSIxIndex, NULL);
+	for (MSIxIndex = 0 ; MSIxIndex < count; MSIxIndex++) {
+		irq_ctx = &instance->irq_context[MSIxIndex];
+		complete_cmd_fusion(instance, MSIxIndex, irq_ctx);
+	}
 }
 
 /**
-- 
2.30.2



