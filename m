Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367CB378833
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239050AbhEJLU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:20:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234779AbhEJLJL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:09:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6B44617C9;
        Mon, 10 May 2021 11:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644673;
        bh=neavVtA24X9Crt/JdDxlIEuHjnHTYafesaZ+ECBFnjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xsmMjBjQ6QVTTLikg2s4ZnxolSeHn41Ftf+qFaenCUo3qHHOW+UqHNBauUqGEsS3D
         57U4NmLrbcujQQwLSyZ2276uZVPljUaZne58bBmk2Ss1GYBsPvOzY8O9ky+n6/8V9s
         ywzxI1e+fEMTzVTY7JuSCky9qSSmEDXdKKPFRWJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 177/384] s390/qdio: let driver manage the QAOB
Date:   Mon, 10 May 2021 12:19:26 +0200
Message-Id: <20210510102020.722107029@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 396c100472dd63bb1a5389d9dfb25a94943c41c9 ]

We are spending way too much effort on qdio-internal bookkeeping for
QAOB management & caching, and it's still not robust. Once qdio's
TX path has detached the QAOB from a PENDING buffer, we lost all
track of it until it shows up in a CQ notification again. So if the
device is torn down before that notification arrives, we leak the QAOB.

Just have the driver take care of it, and simply pass down a QAOB if
they want a TX with async-completion capability. For a buffer in PENDING
state that requires the QAOB for final completion, qeth can now also try
to recycle the buffer's QAOB rather than unconditionally freeing it.

This also eliminates the qdio_outbuf_state array, which was only needed
to transfer the aob->user1 tag from the driver to the qdio layer.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Acked-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/qdio.h      |  22 ++-----
 drivers/s390/cio/qdio.h           |  10 ---
 drivers/s390/cio/qdio_main.c      |  63 +++---------------
 drivers/s390/cio/qdio_setup.c     |  49 +-------------
 drivers/s390/net/qeth_core.h      |   3 +-
 drivers/s390/net/qeth_core_main.c | 102 ++++++++++++++----------------
 drivers/s390/scsi/zfcp_qdio.c     |   7 +-
 7 files changed, 66 insertions(+), 190 deletions(-)

diff --git a/arch/s390/include/asm/qdio.h b/arch/s390/include/asm/qdio.h
index d9215c7106f0..8fc52679543d 100644
--- a/arch/s390/include/asm/qdio.h
+++ b/arch/s390/include/asm/qdio.h
@@ -246,21 +246,8 @@ struct slsb {
 	u8 val[QDIO_MAX_BUFFERS_PER_Q];
 } __attribute__ ((packed, aligned(256)));
 
-/**
- * struct qdio_outbuf_state - SBAL related asynchronous operation information
- *   (for communication with upper layer programs)
- *   (only required for use with completion queues)
- * @user: pointer to upper layer program's state information related to SBAL
- *        (stored in user1 data of QAOB)
- */
-struct qdio_outbuf_state {
-	void *user;
-};
-
-#define CHSC_AC1_INITIATE_INPUTQ	0x80
-
-
 /* qdio adapter-characteristics-1 flag */
+#define CHSC_AC1_INITIATE_INPUTQ	0x80
 #define AC1_SIGA_INPUT_NEEDED		0x40	/* process input queues */
 #define AC1_SIGA_OUTPUT_NEEDED		0x20	/* process output queues */
 #define AC1_SIGA_SYNC_NEEDED		0x10	/* ask hypervisor to sync */
@@ -338,7 +325,6 @@ typedef void qdio_handler_t(struct ccw_device *, unsigned int, int,
  * @int_parm: interruption parameter
  * @input_sbal_addr_array:  per-queue array, each element points to 128 SBALs
  * @output_sbal_addr_array: per-queue array, each element points to 128 SBALs
- * @output_sbal_state_array: no_output_qs * 128 state info (for CQ or NULL)
  */
 struct qdio_initialize {
 	unsigned char q_format;
@@ -357,7 +343,6 @@ struct qdio_initialize {
 	unsigned long int_parm;
 	struct qdio_buffer ***input_sbal_addr_array;
 	struct qdio_buffer ***output_sbal_addr_array;
-	struct qdio_outbuf_state *output_sbal_state_array;
 };
 
 #define QDIO_STATE_INACTIVE		0x00000002 /* after qdio_cleanup */
@@ -378,9 +363,10 @@ extern int qdio_allocate(struct ccw_device *cdev, unsigned int no_input_qs,
 extern int qdio_establish(struct ccw_device *cdev,
 			  struct qdio_initialize *init_data);
 extern int qdio_activate(struct ccw_device *);
+extern struct qaob *qdio_allocate_aob(void);
 extern void qdio_release_aob(struct qaob *);
-extern int do_QDIO(struct ccw_device *, unsigned int, int, unsigned int,
-		   unsigned int);
+extern int do_QDIO(struct ccw_device *cdev, unsigned int callflags, int q_nr,
+		   unsigned int bufnr, unsigned int count, struct qaob *aob);
 extern int qdio_start_irq(struct ccw_device *cdev);
 extern int qdio_stop_irq(struct ccw_device *cdev);
 extern int qdio_get_next_buffers(struct ccw_device *, int, int *, int *);
diff --git a/drivers/s390/cio/qdio.h b/drivers/s390/cio/qdio.h
index 34bf2f197c71..0e0044d70844 100644
--- a/drivers/s390/cio/qdio.h
+++ b/drivers/s390/cio/qdio.h
@@ -181,12 +181,6 @@ struct qdio_input_q {
 struct qdio_output_q {
 	/* PCIs are enabled for the queue */
 	int pci_out_enabled;
-	/* cq: use asynchronous output buffers */
-	int use_cq;
-	/* cq: aobs used for particual SBAL */
-	struct qaob **aobs;
-	/* cq: sbal state related to asynchronous operation */
-	struct qdio_outbuf_state *sbal_state;
 	/* timer to check for more outbound work */
 	struct timer_list timer;
 	/* tasklet to check for completions */
@@ -379,12 +373,8 @@ int qdio_setup_irq(struct qdio_irq *irq_ptr, struct qdio_initialize *init_data);
 void qdio_shutdown_irq(struct qdio_irq *irq);
 void qdio_print_subchannel_info(struct qdio_irq *irq_ptr);
 void qdio_free_queues(struct qdio_irq *irq_ptr);
-void qdio_free_async_data(struct qdio_irq *irq_ptr);
 int qdio_setup_init(void);
 void qdio_setup_exit(void);
-int qdio_enable_async_operation(struct qdio_output_q *q);
-void qdio_disable_async_operation(struct qdio_output_q *q);
-struct qaob *qdio_allocate_aob(void);
 
 int debug_get_buf_state(struct qdio_q *q, unsigned int bufnr,
 			unsigned char *state);
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 03a011619908..307ce7ff5ca4 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -517,24 +517,6 @@ static inline int qdio_inbound_q_done(struct qdio_q *q, unsigned int start)
 	return 1;
 }
 
-static inline unsigned long qdio_aob_for_buffer(struct qdio_output_q *q,
-					int bufnr)
-{
-	unsigned long phys_aob = 0;
-
-	if (!q->aobs[bufnr]) {
-		struct qaob *aob = qdio_allocate_aob();
-		q->aobs[bufnr] = aob;
-	}
-	if (q->aobs[bufnr]) {
-		q->aobs[bufnr]->user1 = (u64) q->sbal_state[bufnr].user;
-		phys_aob = virt_to_phys(q->aobs[bufnr]);
-		WARN_ON_ONCE(phys_aob & 0xFF);
-	}
-
-	return phys_aob;
-}
-
 static inline int qdio_tasklet_schedule(struct qdio_q *q)
 {
 	if (likely(q->irq_ptr->state == QDIO_IRQ_STATE_ACTIVE)) {
@@ -548,7 +530,6 @@ static int get_outbound_buffer_frontier(struct qdio_q *q, unsigned int start,
 					unsigned int *error)
 {
 	unsigned char state = 0;
-	unsigned int i;
 	int count;
 
 	q->timestamp = get_tod_clock_fast();
@@ -570,10 +551,6 @@ static int get_outbound_buffer_frontier(struct qdio_q *q, unsigned int start,
 
 	switch (state) {
 	case SLSB_P_OUTPUT_PENDING:
-		/* detach the utilized QAOBs: */
-		for (i = 0; i < count; i++)
-			q->u.out.aobs[QDIO_BUFNR(start + i)] = NULL;
-
 		*error = QDIO_ERROR_SLSB_PENDING;
 		fallthrough;
 	case SLSB_P_OUTPUT_EMPTY:
@@ -999,7 +976,6 @@ int qdio_free(struct ccw_device *cdev)
 	cdev->private->qdio_data = NULL;
 	mutex_unlock(&irq_ptr->setup_mutex);
 
-	qdio_free_async_data(irq_ptr);
 	qdio_free_queues(irq_ptr);
 	free_page((unsigned long) irq_ptr->qdr);
 	free_page(irq_ptr->chsc_page);
@@ -1075,28 +1051,6 @@ err_dbf:
 }
 EXPORT_SYMBOL_GPL(qdio_allocate);
 
-static void qdio_detect_hsicq(struct qdio_irq *irq_ptr)
-{
-	struct qdio_q *q = irq_ptr->input_qs[0];
-	int i, use_cq = 0;
-
-	if (irq_ptr->nr_input_qs > 1 && queue_type(q) == QDIO_IQDIO_QFMT)
-		use_cq = 1;
-
-	for_each_output_queue(irq_ptr, q, i) {
-		if (use_cq) {
-			if (multicast_outbound(q))
-				continue;
-			if (qdio_enable_async_operation(&q->u.out) < 0) {
-				use_cq = 0;
-				continue;
-			}
-		} else
-			qdio_disable_async_operation(&q->u.out);
-	}
-	DBF_EVENT("use_cq:%d", use_cq);
-}
-
 static void qdio_trace_init_data(struct qdio_irq *irq,
 				 struct qdio_initialize *data)
 {
@@ -1191,8 +1145,6 @@ int qdio_establish(struct ccw_device *cdev,
 
 	qdio_setup_ssqd_info(irq_ptr);
 
-	qdio_detect_hsicq(irq_ptr);
-
 	/* qebsm is now setup if available, initialize buffer states */
 	qdio_init_buf_states(irq_ptr);
 
@@ -1297,9 +1249,11 @@ static int handle_inbound(struct qdio_q *q, unsigned int callflags,
  * @callflags: flags
  * @bufnr: first buffer to process
  * @count: how many buffers are filled
+ * @aob: asynchronous operation block
  */
 static int handle_outbound(struct qdio_q *q, unsigned int callflags,
-			   unsigned int bufnr, unsigned int count)
+			   unsigned int bufnr, unsigned int count,
+			   struct qaob *aob)
 {
 	const unsigned int scan_threshold = q->irq_ptr->scan_threshold;
 	unsigned char state = 0;
@@ -1320,11 +1274,9 @@ static int handle_outbound(struct qdio_q *q, unsigned int callflags,
 		q->u.out.pci_out_enabled = 0;
 
 	if (queue_type(q) == QDIO_IQDIO_QFMT) {
-		unsigned long phys_aob = 0;
-
-		if (q->u.out.use_cq && count == 1)
-			phys_aob = qdio_aob_for_buffer(&q->u.out, bufnr);
+		unsigned long phys_aob = aob ? virt_to_phys(aob) : 0;
 
+		WARN_ON_ONCE(!IS_ALIGNED(phys_aob, 256));
 		rc = qdio_kick_outbound_q(q, count, phys_aob);
 	} else if (need_siga_sync(q)) {
 		rc = qdio_siga_sync_q(q);
@@ -1359,9 +1311,10 @@ static int handle_outbound(struct qdio_q *q, unsigned int callflags,
  * @q_nr: queue number
  * @bufnr: buffer number
  * @count: how many buffers to process
+ * @aob: asynchronous operation block (outbound only)
  */
 int do_QDIO(struct ccw_device *cdev, unsigned int callflags,
-	    int q_nr, unsigned int bufnr, unsigned int count)
+	    int q_nr, unsigned int bufnr, unsigned int count, struct qaob *aob)
 {
 	struct qdio_irq *irq_ptr = cdev->private->qdio_data;
 
@@ -1383,7 +1336,7 @@ int do_QDIO(struct ccw_device *cdev, unsigned int callflags,
 				      callflags, bufnr, count);
 	else if (callflags & QDIO_FLAG_SYNC_OUTPUT)
 		return handle_outbound(irq_ptr->output_qs[q_nr],
-				       callflags, bufnr, count);
+				       callflags, bufnr, count, aob);
 	return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(do_QDIO);
diff --git a/drivers/s390/cio/qdio_setup.c b/drivers/s390/cio/qdio_setup.c
index c8b9620bc688..da67e4979402 100644
--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -30,6 +30,7 @@ struct qaob *qdio_allocate_aob(void)
 {
 	return kmem_cache_zalloc(qdio_aob_cache, GFP_ATOMIC);
 }
+EXPORT_SYMBOL_GPL(qdio_allocate_aob);
 
 void qdio_release_aob(struct qaob *aob)
 {
@@ -247,8 +248,6 @@ static void setup_queues(struct qdio_irq *irq_ptr,
 			 struct qdio_initialize *qdio_init)
 {
 	struct qdio_q *q;
-	struct qdio_outbuf_state *output_sbal_state_array =
-				  qdio_init->output_sbal_state_array;
 	int i;
 
 	for_each_input_queue(irq_ptr, q, i) {
@@ -265,9 +264,6 @@ static void setup_queues(struct qdio_irq *irq_ptr,
 		DBF_EVENT("outq:%1d", i);
 		setup_queues_misc(q, irq_ptr, qdio_init->output_handler, i);
 
-		q->u.out.sbal_state = output_sbal_state_array;
-		output_sbal_state_array += QDIO_MAX_BUFFERS_PER_Q;
-
 		q->is_input_q = 0;
 		setup_storage_lists(q, irq_ptr,
 				    qdio_init->output_sbal_addr_array[i], i);
@@ -372,30 +368,6 @@ void qdio_setup_ssqd_info(struct qdio_irq *irq_ptr)
 	DBF_EVENT("3:%4x qib:%4x", irq_ptr->ssqd_desc.qdioac3, irq_ptr->qib.ac);
 }
 
-void qdio_free_async_data(struct qdio_irq *irq_ptr)
-{
-	struct qdio_q *q;
-	int i;
-
-	for (i = 0; i < irq_ptr->max_output_qs; i++) {
-		q = irq_ptr->output_qs[i];
-		if (q->u.out.use_cq) {
-			unsigned int n;
-
-			for (n = 0; n < QDIO_MAX_BUFFERS_PER_Q; n++) {
-				struct qaob *aob = q->u.out.aobs[n];
-
-				if (aob) {
-					qdio_release_aob(aob);
-					q->u.out.aobs[n] = NULL;
-				}
-			}
-
-			qdio_disable_async_operation(&q->u.out);
-		}
-	}
-}
-
 static void qdio_fill_qdr_desc(struct qdesfmt0 *desc, struct qdio_q *queue)
 {
 	desc->sliba = virt_to_phys(queue->slib);
@@ -545,25 +517,6 @@ void qdio_print_subchannel_info(struct qdio_irq *irq_ptr)
 	printk(KERN_INFO "%s", s);
 }
 
-int qdio_enable_async_operation(struct qdio_output_q *outq)
-{
-	outq->aobs = kcalloc(QDIO_MAX_BUFFERS_PER_Q, sizeof(struct qaob *),
-			     GFP_KERNEL);
-	if (!outq->aobs) {
-		outq->use_cq = 0;
-		return -ENOMEM;
-	}
-	outq->use_cq = 1;
-	return 0;
-}
-
-void qdio_disable_async_operation(struct qdio_output_q *q)
-{
-	kfree(q->aobs);
-	q->aobs = NULL;
-	q->use_cq = 0;
-}
-
 int __init qdio_setup_init(void)
 {
 	int rc;
diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 91acff493612..fd9b869d278e 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -437,6 +437,7 @@ struct qeth_qdio_out_buffer {
 
 	struct qeth_qdio_out_q *q;
 	struct list_head list_entry;
+	struct qaob *aob;
 };
 
 struct qeth_card;
@@ -499,7 +500,6 @@ struct qeth_out_q_stats {
 struct qeth_qdio_out_q {
 	struct qdio_buffer *qdio_bufs[QDIO_MAX_BUFFERS_PER_Q];
 	struct qeth_qdio_out_buffer *bufs[QDIO_MAX_BUFFERS_PER_Q];
-	struct qdio_outbuf_state *bufstates; /* convenience pointer */
 	struct list_head pending_bufs;
 	struct qeth_out_q_stats stats;
 	spinlock_t lock;
@@ -563,7 +563,6 @@ struct qeth_qdio_info {
 	/* output */
 	unsigned int no_out_queues;
 	struct qeth_qdio_out_q *out_qs[QETH_MAX_OUT_QUEUES];
-	struct qdio_outbuf_state *out_bufstates;
 
 	/* priority queueing */
 	int do_prio_queueing;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index a814698387bc..175b82b98f36 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -369,8 +369,7 @@ static int qeth_cq_init(struct qeth_card *card)
 				   QDIO_MAX_BUFFERS_PER_Q);
 		card->qdio.c_q->next_buf_to_init = 127;
 		rc = do_QDIO(CARD_DDEV(card), QDIO_FLAG_SYNC_INPUT,
-			     card->qdio.no_in_queues - 1, 0,
-			     127);
+			     card->qdio.no_in_queues - 1, 0, 127, NULL);
 		if (rc) {
 			QETH_CARD_TEXT_(card, 2, "1err%d", rc);
 			goto out;
@@ -383,48 +382,22 @@ out:
 
 static int qeth_alloc_cq(struct qeth_card *card)
 {
-	int rc;
-
 	if (card->options.cq == QETH_CQ_ENABLED) {
-		int i;
-		struct qdio_outbuf_state *outbuf_states;
-
 		QETH_CARD_TEXT(card, 2, "cqon");
 		card->qdio.c_q = qeth_alloc_qdio_queue();
 		if (!card->qdio.c_q) {
-			rc = -1;
-			goto kmsg_out;
+			dev_err(&card->gdev->dev, "Failed to create completion queue\n");
+			return -ENOMEM;
 		}
+
 		card->qdio.no_in_queues = 2;
-		card->qdio.out_bufstates =
-			kcalloc(card->qdio.no_out_queues *
-					QDIO_MAX_BUFFERS_PER_Q,
-				sizeof(struct qdio_outbuf_state),
-				GFP_KERNEL);
-		outbuf_states = card->qdio.out_bufstates;
-		if (outbuf_states == NULL) {
-			rc = -1;
-			goto free_cq_out;
-		}
-		for (i = 0; i < card->qdio.no_out_queues; ++i) {
-			card->qdio.out_qs[i]->bufstates = outbuf_states;
-			outbuf_states += QDIO_MAX_BUFFERS_PER_Q;
-		}
 	} else {
 		QETH_CARD_TEXT(card, 2, "nocq");
 		card->qdio.c_q = NULL;
 		card->qdio.no_in_queues = 1;
 	}
 	QETH_CARD_TEXT_(card, 2, "iqc%d", card->qdio.no_in_queues);
-	rc = 0;
-out:
-	return rc;
-free_cq_out:
-	qeth_free_qdio_queue(card->qdio.c_q);
-	card->qdio.c_q = NULL;
-kmsg_out:
-	dev_err(&card->gdev->dev, "Failed to create completion queue\n");
-	goto out;
+	return 0;
 }
 
 static void qeth_free_cq(struct qeth_card *card)
@@ -434,8 +407,6 @@ static void qeth_free_cq(struct qeth_card *card)
 		qeth_free_qdio_queue(card->qdio.c_q);
 		card->qdio.c_q = NULL;
 	}
-	kfree(card->qdio.out_bufstates);
-	card->qdio.out_bufstates = NULL;
 }
 
 static enum iucv_tx_notify qeth_compute_cq_notification(int sbalf15,
@@ -487,12 +458,12 @@ static void qeth_qdio_handle_aob(struct qeth_card *card,
 	switch (atomic_xchg(&buffer->state, new_state)) {
 	case QETH_QDIO_BUF_PRIMED:
 		/* Faster than TX completion code, let it handle the async
-		 * completion for us.
+		 * completion for us. It will also recycle the QAOB.
 		 */
 		break;
 	case QETH_QDIO_BUF_PENDING:
 		/* TX completion code is active and will handle the async
-		 * completion for us.
+		 * completion for us. It will also recycle the QAOB.
 		 */
 		break;
 	case QETH_QDIO_BUF_NEED_QAOB:
@@ -501,7 +472,7 @@ static void qeth_qdio_handle_aob(struct qeth_card *card,
 		qeth_notify_skbs(buffer->q, buffer, notification);
 
 		/* Free dangling allocations. The attached skbs are handled by
-		 * qeth_tx_complete_pending_bufs().
+		 * qeth_tx_complete_pending_bufs(), and so is the QAOB.
 		 */
 		for (i = 0;
 		     i < aob->sb_count && i < QETH_MAX_BUFFER_ELEMENTS(card);
@@ -520,8 +491,6 @@ static void qeth_qdio_handle_aob(struct qeth_card *card,
 	default:
 		WARN_ON_ONCE(1);
 	}
-
-	qdio_release_aob(aob);
 }
 
 static void qeth_setup_ccw(struct ccw1 *ccw, u8 cmd_code, u8 flags, u32 len,
@@ -1451,6 +1420,13 @@ static void qeth_clear_output_buffer(struct qeth_qdio_out_q *queue,
 	atomic_set(&buf->state, QETH_QDIO_BUF_EMPTY);
 }
 
+static void qeth_free_out_buf(struct qeth_qdio_out_buffer *buf)
+{
+	if (buf->aob)
+		qdio_release_aob(buf->aob);
+	kmem_cache_free(qeth_qdio_outbuf_cache, buf);
+}
+
 static void qeth_tx_complete_pending_bufs(struct qeth_card *card,
 					  struct qeth_qdio_out_q *queue,
 					  bool drain)
@@ -1468,7 +1444,7 @@ static void qeth_tx_complete_pending_bufs(struct qeth_card *card,
 			qeth_tx_complete_buf(buf, drain, 0);
 
 			list_del(&buf->list_entry);
-			kmem_cache_free(qeth_qdio_outbuf_cache, buf);
+			qeth_free_out_buf(buf);
 		}
 	}
 }
@@ -1485,7 +1461,7 @@ static void qeth_drain_output_queue(struct qeth_qdio_out_q *q, bool free)
 
 		qeth_clear_output_buffer(q, q->bufs[j], true, 0);
 		if (free) {
-			kmem_cache_free(qeth_qdio_outbuf_cache, q->bufs[j]);
+			qeth_free_out_buf(q->bufs[j]);
 			q->bufs[j] = NULL;
 		}
 	}
@@ -2637,7 +2613,7 @@ static struct qeth_qdio_out_q *qeth_alloc_output_queue(void)
 
 err_out_bufs:
 	while (i > 0)
-		kmem_cache_free(qeth_qdio_outbuf_cache, q->bufs[--i]);
+		qeth_free_out_buf(q->bufs[--i]);
 	qdio_free_buffers(q->qdio_bufs, QDIO_MAX_BUFFERS_PER_Q);
 err_qdio_bufs:
 	kfree(q);
@@ -3024,7 +3000,8 @@ static int qeth_init_qdio_queues(struct qeth_card *card)
 	}
 
 	card->qdio.in_q->next_buf_to_init = QDIO_BUFNR(rx_bufs);
-	rc = do_QDIO(CARD_DDEV(card), QDIO_FLAG_SYNC_INPUT, 0, 0, rx_bufs);
+	rc = do_QDIO(CARD_DDEV(card), QDIO_FLAG_SYNC_INPUT, 0, 0, rx_bufs,
+		     NULL);
 	if (rc) {
 		QETH_CARD_TEXT_(card, 2, "1err%d", rc);
 		return rc;
@@ -3516,7 +3493,7 @@ static unsigned int qeth_rx_refill_queue(struct qeth_card *card,
 		}
 
 		rc = do_QDIO(CARD_DDEV(card), QDIO_FLAG_SYNC_INPUT, 0,
-			     queue->next_buf_to_init, count);
+			     queue->next_buf_to_init, count, NULL);
 		if (rc) {
 			QETH_CARD_TEXT(card, 2, "qinberr");
 		}
@@ -3625,6 +3602,7 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 	struct qeth_qdio_out_buffer *buf = queue->bufs[index];
 	unsigned int qdio_flags = QDIO_FLAG_SYNC_OUTPUT;
 	struct qeth_card *card = queue->card;
+	struct qaob *aob = NULL;
 	int rc;
 	int i;
 
@@ -3637,16 +3615,24 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 				SBAL_EFLAGS_LAST_ENTRY;
 		queue->coalesced_frames += buf->frames;
 
-		if (queue->bufstates)
-			queue->bufstates[bidx].user = buf;
-
 		if (IS_IQD(card)) {
 			skb_queue_walk(&buf->skb_list, skb)
 				skb_tx_timestamp(skb);
 		}
 	}
 
-	if (!IS_IQD(card)) {
+	if (IS_IQD(card)) {
+		if (card->options.cq == QETH_CQ_ENABLED &&
+		    !qeth_iqd_is_mcast_queue(card, queue) &&
+		    count == 1) {
+			if (!buf->aob)
+				buf->aob = qdio_allocate_aob();
+			if (buf->aob) {
+				aob = buf->aob;
+				aob->user1 = (u64) buf;
+			}
+		}
+	} else {
 		if (!queue->do_pack) {
 			if ((atomic_read(&queue->used_buffers) >=
 				(QETH_HIGH_WATERMARK_PACK -
@@ -3677,8 +3663,8 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 	}
 
 	QETH_TXQ_STAT_INC(queue, doorbell);
-	rc = do_QDIO(CARD_DDEV(queue->card), qdio_flags,
-		     queue->queue_no, index, count);
+	rc = do_QDIO(CARD_DDEV(card), qdio_flags, queue->queue_no, index, count,
+		     aob);
 
 	switch (rc) {
 	case 0:
@@ -3814,8 +3800,7 @@ static void qeth_qdio_cq_handler(struct qeth_card *card, unsigned int qdio_err,
 		qeth_scrub_qdio_buffer(buffer, QDIO_MAX_ELEMENTS_PER_BUFFER);
 	}
 	rc = do_QDIO(CARD_DDEV(card), QDIO_FLAG_SYNC_INPUT, queue,
-		    card->qdio.c_q->next_buf_to_init,
-		    count);
+		     cq->next_buf_to_init, count, NULL);
 	if (rc) {
 		dev_warn(&card->gdev->dev,
 			"QDIO reported an error, rc=%i\n", rc);
@@ -5270,7 +5255,6 @@ static int qeth_qdio_establish(struct qeth_card *card)
 	init_data.int_parm               = (unsigned long) card;
 	init_data.input_sbal_addr_array  = in_sbal_ptrs;
 	init_data.output_sbal_addr_array = out_sbal_ptrs;
-	init_data.output_sbal_state_array = card->qdio.out_bufstates;
 	init_data.scan_threshold	 = IS_IQD(card) ? 0 : 32;
 
 	if (atomic_cmpxchg(&card->qdio.state, QETH_QDIO_ALLOCATED,
@@ -6069,7 +6053,15 @@ static void qeth_iqd_tx_complete(struct qeth_qdio_out_q *queue,
 	bool error = !!qdio_error;
 
 	if (qdio_error == QDIO_ERROR_SLSB_PENDING) {
-		WARN_ON_ONCE(card->options.cq != QETH_CQ_ENABLED);
+		struct qaob *aob = buffer->aob;
+
+		if (!aob) {
+			netdev_WARN_ONCE(card->dev,
+					 "Pending TX buffer %#x without QAOB on TX queue %u\n",
+					 bidx, queue->queue_no);
+			qeth_schedule_recovery(card);
+			return;
+		}
 
 		QETH_CARD_TEXT_(card, 5, "pel%u", bidx);
 
@@ -6125,6 +6117,8 @@ static void qeth_iqd_tx_complete(struct qeth_qdio_out_q *queue,
 		default:
 			WARN_ON_ONCE(1);
 		}
+
+		memset(aob, 0, sizeof(*aob));
 	} else if (card->options.cq == QETH_CQ_ENABLED) {
 		qeth_notify_skbs(queue, buffer,
 				 qeth_compute_cq_notification(sflags, 0));
diff --git a/drivers/s390/scsi/zfcp_qdio.c b/drivers/s390/scsi/zfcp_qdio.c
index 23ab16d65f2a..049596cbfb5d 100644
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -128,7 +128,7 @@ static void zfcp_qdio_int_resp(struct ccw_device *cdev, unsigned int qdio_err,
 	/*
 	 * put SBALs back to response queue
 	 */
-	if (do_QDIO(cdev, QDIO_FLAG_SYNC_INPUT, 0, idx, count))
+	if (do_QDIO(cdev, QDIO_FLAG_SYNC_INPUT, 0, idx, count, NULL))
 		zfcp_erp_adapter_reopen(qdio->adapter, 0, "qdires2");
 }
 
@@ -298,7 +298,7 @@ int zfcp_qdio_send(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req)
 	atomic_sub(sbal_number, &qdio->req_q_free);
 
 	retval = do_QDIO(qdio->adapter->ccw_device, QDIO_FLAG_SYNC_OUTPUT, 0,
-			 q_req->sbal_first, sbal_number);
+			 q_req->sbal_first, sbal_number, NULL);
 
 	if (unlikely(retval)) {
 		/* Failed to submit the IO, roll back our modifications. */
@@ -463,7 +463,8 @@ int zfcp_qdio_open(struct zfcp_qdio *qdio)
 		sbale->addr = 0;
 	}
 
-	if (do_QDIO(cdev, QDIO_FLAG_SYNC_INPUT, 0, 0, QDIO_MAX_BUFFERS_PER_Q))
+	if (do_QDIO(cdev, QDIO_FLAG_SYNC_INPUT, 0, 0, QDIO_MAX_BUFFERS_PER_Q,
+		    NULL))
 		goto failed_qdio;
 
 	/* set index of first available SBALS / number of available SBALS */
-- 
2.30.2



