Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1E5A9086
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390055AbfIDSKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:10:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389303AbfIDSKN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:10:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EE7B208E4;
        Wed,  4 Sep 2019 18:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620612;
        bh=dQ1SFDjgCSInOxteCI1SVB9kLKMUxh7ABJ8IJAwqUNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vJ/FR/23SKSSFbrn/bI4MbZ8nEVE0hyLjO5D2vlvupIqOfzrSNiq/PjvrhwQvBNA0
         4gmFvsHvSlx9PdIF2aVCddh+16CxXEQzqaNEQaxDsrWfRRBLIBv6m6AalXjrq8MDrE
         yCnloL50R/t14yeg6xR3qCzBmFFz+eb5dIJqAo5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Segal <bpsegal20@gmail.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 030/143] habanalabs: fix completion queue handling when host is BE
Date:   Wed,  4 Sep 2019 19:52:53 +0200
Message-Id: <20190904175315.236361927@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4e87334a0ef43663019dbaf3638ad10fd8c3320c ]

This patch fix the CQ irq handler to work in hosts with BE architecture.
It adds the correct endian-swapping macros around the relevant memory
accesses.

Signed-off-by: Ben Segal <bpsegal20@gmail.com>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/irq.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/misc/habanalabs/irq.c b/drivers/misc/habanalabs/irq.c
index ea9f72ff456cf..199791b57caf2 100644
--- a/drivers/misc/habanalabs/irq.c
+++ b/drivers/misc/habanalabs/irq.c
@@ -80,8 +80,7 @@ irqreturn_t hl_irq_handler_cq(int irq, void *arg)
 	struct hl_cs_job *job;
 	bool shadow_index_valid;
 	u16 shadow_index;
-	u32 *cq_entry;
-	u32 *cq_base;
+	struct hl_cq_entry *cq_entry, *cq_base;
 
 	if (hdev->disabled) {
 		dev_dbg(hdev->dev,
@@ -90,29 +89,29 @@ irqreturn_t hl_irq_handler_cq(int irq, void *arg)
 		return IRQ_HANDLED;
 	}
 
-	cq_base = (u32 *) (uintptr_t) cq->kernel_address;
+	cq_base = (struct hl_cq_entry *) (uintptr_t) cq->kernel_address;
 
 	while (1) {
-		bool entry_ready = ((cq_base[cq->ci] & CQ_ENTRY_READY_MASK)
+		bool entry_ready = ((le32_to_cpu(cq_base[cq->ci].data) &
+					CQ_ENTRY_READY_MASK)
 						>> CQ_ENTRY_READY_SHIFT);
 
 		if (!entry_ready)
 			break;
 
-		cq_entry = (u32 *) &cq_base[cq->ci];
+		cq_entry = (struct hl_cq_entry *) &cq_base[cq->ci];
 
-		/*
-		 * Make sure we read CQ entry contents after we've
+		/* Make sure we read CQ entry contents after we've
 		 * checked the ownership bit.
 		 */
 		dma_rmb();
 
-		shadow_index_valid =
-			((*cq_entry & CQ_ENTRY_SHADOW_INDEX_VALID_MASK)
+		shadow_index_valid = ((le32_to_cpu(cq_entry->data) &
+					CQ_ENTRY_SHADOW_INDEX_VALID_MASK)
 					>> CQ_ENTRY_SHADOW_INDEX_VALID_SHIFT);
 
-		shadow_index = (u16)
-			((*cq_entry & CQ_ENTRY_SHADOW_INDEX_MASK)
+		shadow_index = (u16) ((le32_to_cpu(cq_entry->data) &
+					CQ_ENTRY_SHADOW_INDEX_MASK)
 					>> CQ_ENTRY_SHADOW_INDEX_SHIFT);
 
 		queue = &hdev->kernel_queues[cq->hw_queue_id];
@@ -122,8 +121,7 @@ irqreturn_t hl_irq_handler_cq(int irq, void *arg)
 			queue_work(hdev->cq_wq, &job->finish_work);
 		}
 
-		/*
-		 * Update ci of the context's queue. There is no
+		/* Update ci of the context's queue. There is no
 		 * need to protect it with spinlock because this update is
 		 * done only inside IRQ and there is a different IRQ per
 		 * queue
@@ -131,7 +129,8 @@ irqreturn_t hl_irq_handler_cq(int irq, void *arg)
 		queue->ci = hl_queue_inc_ptr(queue->ci);
 
 		/* Clear CQ entry ready bit */
-		cq_base[cq->ci] &= ~CQ_ENTRY_READY_MASK;
+		cq_entry->data = cpu_to_le32(le32_to_cpu(cq_entry->data) &
+						~CQ_ENTRY_READY_MASK);
 
 		cq->ci = hl_cq_inc_ptr(cq->ci);
 
-- 
2.20.1



