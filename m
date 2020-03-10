Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D55F17FB77
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730959AbgCJNOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:14:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730035AbgCJNOK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:14:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64C9D20409;
        Tue, 10 Mar 2020 13:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583846049;
        bh=PhYDrx0/IShn5QwB9WjE4y4g4bAryYzDvYlLCmOTrEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jpBiiJ2Ipda8Qo7TyNxwxE8xy4UjLIySo+aywylNgaWb6YE8et1JeQZ2nk9gsutZc
         CqOyrX8tJwl8isa6NIeKu0hDc+ZsKHo4afz+rwKXpcZ17tLcEVohj47WsuwGFS+1cX
         yyku1yptKwdSVQDnQxNa5pMMFZ3SeAp/vDPdse7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>,
        Steffen Maier <maier@linux.ibm.com>
Subject: [PATCH 4.19 27/86] s390/qdio: fill SL with absolute addresses
Date:   Tue, 10 Mar 2020 13:44:51 +0100
Message-Id: <20200310124532.248367642@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124530.808338541@linuxfoundation.org>
References: <20200310124530.808338541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



