Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836A94013D5
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240301AbhIFB3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:29:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240322AbhIFB1F (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:27:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBCCC61167;
        Mon,  6 Sep 2021 01:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891362;
        bh=XLyyDGECmc/pR2d+FfbJVv8Z5J+scxDEk5ta0GUjfjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2+qc/zu7LpGELtmMFlqnK4pihbdd8QSo1Te1obNmDdVU2xK3eQ0MNM+9QaBgNtWQ
         sqSBUZaGgwj6F/N/ury+3/81tQstwgv/OvJ3QUuV5MMj559l2i61mQz55gmoQGCedy
         F/6J6m2aFj60wgBuGGQTGRBoJmrBpeAJs4DVJ/LDNHexfTzaeezsuWpFf/k3qLSnGC
         Y6mrGqG82iiyqzkMHYp12r+DclqcC7gpRaxhmpJaOfTSXSimHko1yOu3u+VCTp2SiO
         T/TspDRC+meYUusxhySuPMflejcoYmHK4ySn1DkYRxTAHLiOgkyuLug42OJSGpgggR
         d48nqmwAU3M8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harald Freudenberger <freude@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 39/39] s390/ap: fix state machine hang after failure to enable irq
Date:   Sun,  5 Sep 2021 21:21:53 -0400
Message-Id: <20210906012153.929962-39-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012153.929962-1-sashal@kernel.org>
References: <20210906012153.929962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit cabebb697c98fb1f05cc950a747a9b6ec61a5b01 ]

If for any reason the interrupt enable for an ap queue fails the
state machine run for the queue returned wrong return codes to the
caller. So the caller assumed interrupt support for this queue in
enabled and thus did not re-establish the high resolution timer used
for polling. In the end this let to a hang for the user space process
waiting "forever" for the reply.

This patch reworks these return codes to return correct indications
for the caller to re-establish the timer when a queue runs without
interrupt support.

Please note that this is fixing a wrong behavior after a first
failure (enable interrupt support for the queue) failed. However,
looks like this occasionally happens on KVM systems.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/ap_bus.c   | 25 ++++++++-----------------
 drivers/s390/crypto/ap_bus.h   | 10 ++--------
 drivers/s390/crypto/ap_queue.c | 20 +++++++++++---------
 3 files changed, 21 insertions(+), 34 deletions(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index ef738b42a092..c00a288a4eca 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -114,22 +114,13 @@ static struct bus_type ap_bus_type;
 /* Adapter interrupt definitions */
 static void ap_interrupt_handler(struct airq_struct *airq, bool floating);
 
-static int ap_airq_flag;
+static bool ap_irq_flag;
 
 static struct airq_struct ap_airq = {
 	.handler = ap_interrupt_handler,
 	.isc = AP_ISC,
 };
 
-/**
- * ap_using_interrupts() - Returns non-zero if interrupt support is
- * available.
- */
-static inline int ap_using_interrupts(void)
-{
-	return ap_airq_flag;
-}
-
 /**
  * ap_airq_ptr() - Get the address of the adapter interrupt indicator
  *
@@ -139,7 +130,7 @@ static inline int ap_using_interrupts(void)
  */
 void *ap_airq_ptr(void)
 {
-	if (ap_using_interrupts())
+	if (ap_irq_flag)
 		return ap_airq.lsi_ptr;
 	return NULL;
 }
@@ -369,7 +360,7 @@ void ap_wait(enum ap_sm_wait wait)
 	switch (wait) {
 	case AP_SM_WAIT_AGAIN:
 	case AP_SM_WAIT_INTERRUPT:
-		if (ap_using_interrupts())
+		if (ap_irq_flag)
 			break;
 		if (ap_poll_kthread) {
 			wake_up(&ap_poll_wait);
@@ -444,7 +435,7 @@ static void ap_tasklet_fn(unsigned long dummy)
 	 * be received. Doing it in the beginning of the tasklet is therefor
 	 * important that no requests on any AP get lost.
 	 */
-	if (ap_using_interrupts())
+	if (ap_irq_flag)
 		xchg(ap_airq.lsi_ptr, 0);
 
 	spin_lock_bh(&ap_queues_lock);
@@ -514,7 +505,7 @@ static int ap_poll_thread_start(void)
 {
 	int rc;
 
-	if (ap_using_interrupts() || ap_poll_kthread)
+	if (ap_irq_flag || ap_poll_kthread)
 		return 0;
 	mutex_lock(&ap_poll_thread_mutex);
 	ap_poll_kthread = kthread_run(ap_poll_thread, NULL, "appoll");
@@ -1014,7 +1005,7 @@ static BUS_ATTR_RO(ap_adapter_mask);
 static ssize_t ap_interrupts_show(struct bus_type *bus, char *buf)
 {
 	return scnprintf(buf, PAGE_SIZE, "%d\n",
-			 ap_using_interrupts() ? 1 : 0);
+			 ap_irq_flag ? 1 : 0);
 }
 
 static BUS_ATTR_RO(ap_interrupts);
@@ -1687,7 +1678,7 @@ static int __init ap_module_init(void)
 	/* enable interrupts if available */
 	if (ap_interrupts_available()) {
 		rc = register_adapter_interrupt(&ap_airq);
-		ap_airq_flag = (rc == 0);
+		ap_irq_flag = (rc == 0);
 	}
 
 	/* Create /sys/bus/ap. */
@@ -1737,7 +1728,7 @@ static int __init ap_module_init(void)
 		bus_remove_file(&ap_bus_type, ap_bus_attrs[i]);
 	bus_unregister(&ap_bus_type);
 out:
-	if (ap_using_interrupts())
+	if (ap_irq_flag)
 		unregister_adapter_interrupt(&ap_airq);
 	kfree(ap_qci_info);
 	return rc;
diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
index 5029b80132aa..ccdbd95cab70 100644
--- a/drivers/s390/crypto/ap_bus.h
+++ b/drivers/s390/crypto/ap_bus.h
@@ -77,12 +77,6 @@ static inline int ap_test_bit(unsigned int *ptr, unsigned int nr)
 #define AP_FUNC_EP11  5
 #define AP_FUNC_APXA  6
 
-/*
- * AP interrupt states
- */
-#define AP_INTR_DISABLED	0	/* AP interrupt disabled */
-#define AP_INTR_ENABLED		1	/* AP interrupt enabled */
-
 /*
  * AP queue state machine states
  */
@@ -109,7 +103,7 @@ enum ap_sm_event {
  * AP queue state wait behaviour
  */
 enum ap_sm_wait {
-	AP_SM_WAIT_AGAIN,	/* retry immediately */
+	AP_SM_WAIT_AGAIN = 0,	/* retry immediately */
 	AP_SM_WAIT_TIMEOUT,	/* wait for timeout */
 	AP_SM_WAIT_INTERRUPT,	/* wait for thin interrupt (if available) */
 	AP_SM_WAIT_NONE,	/* no wait */
@@ -182,7 +176,7 @@ struct ap_queue {
 	enum ap_dev_state dev_state;	/* queue device state */
 	bool config;			/* configured state */
 	ap_qid_t qid;			/* AP queue id. */
-	int interrupt;			/* indicate if interrupts are enabled */
+	bool interrupt;			/* indicate if interrupts are enabled */
 	int queue_count;		/* # messages currently on AP queue. */
 	int pendingq_count;		/* # requests on pendingq list. */
 	int requestq_count;		/* # requests on requestq list. */
diff --git a/drivers/s390/crypto/ap_queue.c b/drivers/s390/crypto/ap_queue.c
index 337353c9655e..639f8d25679c 100644
--- a/drivers/s390/crypto/ap_queue.c
+++ b/drivers/s390/crypto/ap_queue.c
@@ -19,7 +19,7 @@
 static void __ap_flush_queue(struct ap_queue *aq);
 
 /**
- * ap_queue_enable_interruption(): Enable interruption on an AP queue.
+ * ap_queue_enable_irq(): Enable interrupt support on this AP queue.
  * @qid: The AP queue number
  * @ind: the notification indicator byte
  *
@@ -27,7 +27,7 @@ static void __ap_flush_queue(struct ap_queue *aq);
  * value it waits a while and tests the AP queue if interrupts
  * have been switched on using ap_test_queue().
  */
-static int ap_queue_enable_interruption(struct ap_queue *aq, void *ind)
+static int ap_queue_enable_irq(struct ap_queue *aq, void *ind)
 {
 	struct ap_queue_status status;
 	struct ap_qirq_ctrl qirqctrl = { 0 };
@@ -198,7 +198,8 @@ static enum ap_sm_wait ap_sm_read(struct ap_queue *aq)
 		return AP_SM_WAIT_NONE;
 	case AP_RESPONSE_NO_PENDING_REPLY:
 		if (aq->queue_count > 0)
-			return AP_SM_WAIT_INTERRUPT;
+			return aq->interrupt ?
+				AP_SM_WAIT_INTERRUPT : AP_SM_WAIT_TIMEOUT;
 		aq->sm_state = AP_SM_STATE_IDLE;
 		return AP_SM_WAIT_NONE;
 	default:
@@ -252,7 +253,8 @@ static enum ap_sm_wait ap_sm_write(struct ap_queue *aq)
 		fallthrough;
 	case AP_RESPONSE_Q_FULL:
 		aq->sm_state = AP_SM_STATE_QUEUE_FULL;
-		return AP_SM_WAIT_INTERRUPT;
+		return aq->interrupt ?
+			AP_SM_WAIT_INTERRUPT : AP_SM_WAIT_TIMEOUT;
 	case AP_RESPONSE_RESET_IN_PROGRESS:
 		aq->sm_state = AP_SM_STATE_RESET_WAIT;
 		return AP_SM_WAIT_TIMEOUT;
@@ -302,7 +304,7 @@ static enum ap_sm_wait ap_sm_reset(struct ap_queue *aq)
 	case AP_RESPONSE_NORMAL:
 	case AP_RESPONSE_RESET_IN_PROGRESS:
 		aq->sm_state = AP_SM_STATE_RESET_WAIT;
-		aq->interrupt = AP_INTR_DISABLED;
+		aq->interrupt = false;
 		return AP_SM_WAIT_TIMEOUT;
 	default:
 		aq->dev_state = AP_DEV_STATE_ERROR;
@@ -335,7 +337,7 @@ static enum ap_sm_wait ap_sm_reset_wait(struct ap_queue *aq)
 	switch (status.response_code) {
 	case AP_RESPONSE_NORMAL:
 		lsi_ptr = ap_airq_ptr();
-		if (lsi_ptr && ap_queue_enable_interruption(aq, lsi_ptr) == 0)
+		if (lsi_ptr && ap_queue_enable_irq(aq, lsi_ptr) == 0)
 			aq->sm_state = AP_SM_STATE_SETIRQ_WAIT;
 		else
 			aq->sm_state = (aq->queue_count > 0) ?
@@ -376,7 +378,7 @@ static enum ap_sm_wait ap_sm_setirq_wait(struct ap_queue *aq)
 
 	if (status.irq_enabled == 1) {
 		/* Irqs are now enabled */
-		aq->interrupt = AP_INTR_ENABLED;
+		aq->interrupt = true;
 		aq->sm_state = (aq->queue_count > 0) ?
 			AP_SM_STATE_WORKING : AP_SM_STATE_IDLE;
 	}
@@ -566,7 +568,7 @@ static ssize_t interrupt_show(struct device *dev,
 	spin_lock_bh(&aq->lock);
 	if (aq->sm_state == AP_SM_STATE_SETIRQ_WAIT)
 		rc = scnprintf(buf, PAGE_SIZE, "Enable Interrupt pending.\n");
-	else if (aq->interrupt == AP_INTR_ENABLED)
+	else if (aq->interrupt)
 		rc = scnprintf(buf, PAGE_SIZE, "Interrupts enabled.\n");
 	else
 		rc = scnprintf(buf, PAGE_SIZE, "Interrupts disabled.\n");
@@ -747,7 +749,7 @@ struct ap_queue *ap_queue_create(ap_qid_t qid, int device_type)
 	aq->ap_dev.device.type = &ap_queue_type;
 	aq->ap_dev.device_type = device_type;
 	aq->qid = qid;
-	aq->interrupt = AP_INTR_DISABLED;
+	aq->interrupt = false;
 	spin_lock_init(&aq->lock);
 	INIT_LIST_HEAD(&aq->pendingq);
 	INIT_LIST_HEAD(&aq->requestq);
-- 
2.30.2

