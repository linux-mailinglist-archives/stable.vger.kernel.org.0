Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94DAB176C0C
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 03:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbgCCCyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 21:54:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728855AbgCCCt0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 21:49:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BF0524699;
        Tue,  3 Mar 2020 02:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203765;
        bh=PhYDrx0/IShn5QwB9WjE4y4g4bAryYzDvYlLCmOTrEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JqLKR6IlWyMrTky+AyI41o7atyslezdNr9wES3FamXWJHkxH1E1UyHqHt7PKrrkFf
         DgA/p32G2QjRQwBkg1A0oEV+v1mizd2aXQGjuzgrOS/W0OIhHot3j4FbPv+9YqrUYb
         lKBWO8/W4gPPWYDqQPzP33V7xC05MCefdYFg1KU4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 26/32] s390/qdio: fill SL with absolute addresses
Date:   Mon,  2 Mar 2020 21:48:45 -0500
Message-Id: <20200303024851.10054-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024851.10054-1-sashal@kernel.org>
References: <20200303024851.10054-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit e9091ffd6a0aaced111b5d6ead5eaab5cd7101bc ]

As the comment says, sl->sbal holds an absolute address. qeth currently
solves this through wild casting, while zfcp doesn't care.

Handle this properly in the code that actually builds the SL.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Steffen Maier <maier@linux.ibm.com> [for qdio]
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/qdio.h      |  2 +-
 drivers/s390/cio/qdio_setup.c     |  3 ++-
 drivers/s390/net/qeth_core_main.c | 23 +++++++++++------------
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/s390/include/asm/qdio.h b/arch/s390/include/asm/qdio.h
index 9c9970a5dfb10..1f2cd98dcb058 100644
--- a/arch/s390/include/asm/qdio.h
+++ b/arch/s390/include/asm/qdio.h
@@ -228,7 +228,7 @@ struct qdio_buffer {
  * @sbal: absolute SBAL address
  */
 struct sl_element {
-	unsigned long sbal;
+	u64 sbal;
 } __attribute__ ((packed));
 
 /**
diff --git a/drivers/s390/cio/qdio_setup.c b/drivers/s390/cio/qdio_setup.c
index 034528a5453ec..d040c4920ee78 100644
--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#include <linux/io.h>
 #include <asm/qdio.h>
 
 #include "cio.h"
@@ -208,7 +209,7 @@ static void setup_storage_lists(struct qdio_q *q, struct qdio_irq *irq_ptr,
 
 	/* fill in sl */
 	for (j = 0; j < QDIO_MAX_BUFFERS_PER_Q; j++)
-		q->sl->element[j].sbal = (unsigned long)q->sbal[j];
+		q->sl->element[j].sbal = virt_to_phys(q->sbal[j]);
 }
 
 static void setup_queues(struct qdio_irq *irq_ptr,
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 81e2c591acb0b..d99bfbfcafb76 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4929,10 +4929,10 @@ static void qeth_qdio_establish_cq(struct qeth_card *card,
 	if (card->options.cq == QETH_CQ_ENABLED) {
 		int offset = QDIO_MAX_BUFFERS_PER_Q *
 			     (card->qdio.no_in_queues - 1);
-		for (i = 0; i < QDIO_MAX_BUFFERS_PER_Q; ++i) {
-			in_sbal_ptrs[offset + i] = (struct qdio_buffer *)
-				virt_to_phys(card->qdio.c_q->bufs[i].buffer);
-		}
+
+		for (i = 0; i < QDIO_MAX_BUFFERS_PER_Q; i++)
+			in_sbal_ptrs[offset + i] =
+				card->qdio.c_q->bufs[i].buffer;
 
 		queue_start_poll[card->qdio.no_in_queues - 1] = NULL;
 	}
@@ -4967,10 +4967,9 @@ static int qeth_qdio_establish(struct qeth_card *card)
 		rc = -ENOMEM;
 		goto out_free_qib_param;
 	}
-	for (i = 0; i < QDIO_MAX_BUFFERS_PER_Q; ++i) {
-		in_sbal_ptrs[i] = (struct qdio_buffer *)
-			virt_to_phys(card->qdio.in_q->bufs[i].buffer);
-	}
+
+	for (i = 0; i < QDIO_MAX_BUFFERS_PER_Q; i++)
+		in_sbal_ptrs[i] = card->qdio.in_q->bufs[i].buffer;
 
 	queue_start_poll = kcalloc(card->qdio.no_in_queues, sizeof(void *),
 				   GFP_KERNEL);
@@ -4991,11 +4990,11 @@ static int qeth_qdio_establish(struct qeth_card *card)
 		rc = -ENOMEM;
 		goto out_free_queue_start_poll;
 	}
+
 	for (i = 0, k = 0; i < card->qdio.no_out_queues; ++i)
-		for (j = 0; j < QDIO_MAX_BUFFERS_PER_Q; ++j, ++k) {
-			out_sbal_ptrs[k] = (struct qdio_buffer *)virt_to_phys(
-				card->qdio.out_qs[i]->bufs[j]->buffer);
-		}
+		for (j = 0; j < QDIO_MAX_BUFFERS_PER_Q; j++, k++)
+			out_sbal_ptrs[k] =
+				card->qdio.out_qs[i]->bufs[j]->buffer;
 
 	memset(&init_data, 0, sizeof(struct qdio_initialize));
 	init_data.cdev                   = CARD_DDEV(card);
-- 
2.20.1

