Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6737E2A51D3
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730883AbgKCUo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:44:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:59708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730268AbgKCUo2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:44:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4042223C6;
        Tue,  3 Nov 2020 20:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436267;
        bh=mNJl9cG8Y+1552Euq8h77JQ9gjTlb+gr8qLXtSOVqyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xvIJYck53568/TkY3IYIg4+JObPtOJEOwgjJjNdxfp46ELFgpw8wjGpXfrmSSIr7H
         s7XpFhZldtWimvYaUxU3SIlJGgN2wzLcNp2HIRV3HiDS1uqRZhPbR6MG4u0Ptcf25Y
         vrka57qxIxgOlZ1LFnYUuPIBrl3jtdilM/w9mFnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maulik Shah <mkshah@codeaurora.org>,
        Douglas Anderson <dianders@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Lina Iyer <ilina@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 174/391] soc: qcom: rpmh-rsc: Sleep waiting for tcs slots to be free
Date:   Tue,  3 Nov 2020 21:33:45 +0100
Message-Id: <20201103203358.612104805@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 2bc20f3c8487bd5bc4dd9ad2c06d2ba05fd4e838 ]

The busy loop in rpmh_rsc_send_data() is written with the assumption
that the udelay will be preempted by the tcs_tx_done() irq handler when
the TCS slots are all full. This doesn't hold true when the calling
thread is an irqthread and the tcs_tx_done() irq is also an irqthread.
That's because kernel irqthreads are SCHED_FIFO and thus need to
voluntarily give up priority by calling into the scheduler so that other
threads can run.

I see RCU stalls when I boot with irqthreads on the kernel commandline
because the modem remoteproc driver is trying to send an rpmh async
message from an irqthread that needs to give up the CPU for the rpmh
irqthread to run and clear out tcs slots.

 rcu: INFO: rcu_preempt self-detected stall on CPU
 rcu:     0-....: (1 GPs behind) idle=402/1/0x4000000000000002 softirq=2108/2109 fqs=4920
  (t=21016 jiffies g=2933 q=590)
 Task dump for CPU 0:
 irq/11-smp2p    R  running task        0   148      2 0x00000028
 Call trace:
  dump_backtrace+0x0/0x154
  show_stack+0x20/0x2c
  sched_show_task+0xfc/0x108
  dump_cpu_task+0x44/0x50
  rcu_dump_cpu_stacks+0xa4/0xf8
  rcu_sched_clock_irq+0x7dc/0xaa8
  update_process_times+0x30/0x54
  tick_sched_handle+0x50/0x64
  tick_sched_timer+0x4c/0x8c
  __hrtimer_run_queues+0x21c/0x36c
  hrtimer_interrupt+0xf0/0x22c
  arch_timer_handler_phys+0x40/0x50
  handle_percpu_devid_irq+0x114/0x25c
  __handle_domain_irq+0x84/0xc4
  gic_handle_irq+0xd0/0x178
  el1_irq+0xbc/0x180
  save_return_addr+0x18/0x28
  return_address+0x54/0x88
  preempt_count_sub+0x40/0x88
  _raw_spin_unlock_irqrestore+0x4c/0x6c
  ___ratelimit+0xd0/0x128
  rpmh_rsc_send_data+0x24c/0x378
  __rpmh_write+0x1b0/0x208
  rpmh_write_async+0x90/0xbc
  rpmhpd_send_corner+0x60/0x8c
  rpmhpd_aggregate_corner+0x8c/0x124
  rpmhpd_set_performance_state+0x8c/0xbc
  _genpd_set_performance_state+0xdc/0x1b8
  dev_pm_genpd_set_performance_state+0xb8/0xf8
  q6v5_pds_disable+0x34/0x60 [qcom_q6v5_mss]
  qcom_msa_handover+0x38/0x44 [qcom_q6v5_mss]
  q6v5_handover_interrupt+0x24/0x3c [qcom_q6v5]
  handle_nested_irq+0xd0/0x138
  qcom_smp2p_intr+0x188/0x200
  irq_thread_fn+0x2c/0x70
  irq_thread+0xfc/0x14c
  kthread+0x11c/0x12c
  ret_from_fork+0x10/0x18

This busy loop naturally lends itself to using a wait queue so that each
thread that tries to send a message will sleep waiting on the waitqueue
and only be woken up when a free slot is available. This should make
things more predictable too because the scheduler will be able to sleep
tasks that are waiting on a free tcs instead of the busy loop we
currently have today.

Reviewed-by: Maulik Shah <mkshah@codeaurora.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Maulik Shah <mkshah@codeaurora.org>
Cc: Lina Iyer <ilina@codeaurora.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20200724211711.810009-1-sboyd@kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/rpmh-internal.h |   4 ++
 drivers/soc/qcom/rpmh-rsc.c      | 115 +++++++++++++++----------------
 2 files changed, 58 insertions(+), 61 deletions(-)

diff --git a/drivers/soc/qcom/rpmh-internal.h b/drivers/soc/qcom/rpmh-internal.h
index ef60e790a750a..344ba687c13be 100644
--- a/drivers/soc/qcom/rpmh-internal.h
+++ b/drivers/soc/qcom/rpmh-internal.h
@@ -8,6 +8,7 @@
 #define __RPM_INTERNAL_H__
 
 #include <linux/bitmap.h>
+#include <linux/wait.h>
 #include <soc/qcom/tcs.h>
 
 #define TCS_TYPE_NR			4
@@ -106,6 +107,8 @@ struct rpmh_ctrlr {
  * @lock:               Synchronize state of the controller.  If RPMH's cache
  *                      lock will also be held, the order is: drv->lock then
  *                      cache_lock.
+ * @tcs_wait:           Wait queue used to wait for @tcs_in_use to free up a
+ *                      slot
  * @client:             Handle to the DRV's client.
  */
 struct rsc_drv {
@@ -118,6 +121,7 @@ struct rsc_drv {
 	struct tcs_group tcs[TCS_TYPE_NR];
 	DECLARE_BITMAP(tcs_in_use, MAX_TCS_NR);
 	spinlock_t lock;
+	wait_queue_head_t tcs_wait;
 	struct rpmh_ctrlr client;
 };
 
diff --git a/drivers/soc/qcom/rpmh-rsc.c b/drivers/soc/qcom/rpmh-rsc.c
index ae66757825813..a297911afe571 100644
--- a/drivers/soc/qcom/rpmh-rsc.c
+++ b/drivers/soc/qcom/rpmh-rsc.c
@@ -19,6 +19,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/wait.h>
 
 #include <soc/qcom/cmd-db.h>
 #include <soc/qcom/tcs.h>
@@ -453,6 +454,7 @@ skip:
 		if (!drv->tcs[ACTIVE_TCS].num_tcs)
 			enable_tcs_irq(drv, i, false);
 		spin_unlock(&drv->lock);
+		wake_up(&drv->tcs_wait);
 		if (req)
 			rpmh_tx_done(req, err);
 	}
@@ -571,73 +573,34 @@ static int find_free_tcs(struct tcs_group *tcs)
 }
 
 /**
- * tcs_write() - Store messages into a TCS right now, or return -EBUSY.
+ * claim_tcs_for_req() - Claim a tcs in the given tcs_group; only for active.
  * @drv: The controller.
+ * @tcs: The tcs_group used for ACTIVE_ONLY transfers.
  * @msg: The data to be sent.
  *
- * Grabs a TCS for ACTIVE_ONLY transfers and writes the messages to it.
+ * Claims a tcs in the given tcs_group while making sure that no existing cmd
+ * is in flight that would conflict with the one in @msg.
  *
- * If there are no free TCSes for ACTIVE_ONLY transfers or if a command for
- * the same address is already transferring returns -EBUSY which means the
- * client should retry shortly.
+ * Context: Must be called with the drv->lock held since that protects
+ * tcs_in_use.
  *
- * Return: 0 on success, -EBUSY if client should retry, or an error.
- *         Client should have interrupts enabled for a bit before retrying.
+ * Return: The id of the claimed tcs or -EBUSY if a matching msg is in flight
+ * or the tcs_group is full.
  */
-static int tcs_write(struct rsc_drv *drv, const struct tcs_request *msg)
+static int claim_tcs_for_req(struct rsc_drv *drv, struct tcs_group *tcs,
+			     const struct tcs_request *msg)
 {
-	struct tcs_group *tcs;
-	int tcs_id;
-	unsigned long flags;
 	int ret;
 
-	tcs = get_tcs_for_msg(drv, msg);
-	if (IS_ERR(tcs))
-		return PTR_ERR(tcs);
-
-	spin_lock_irqsave(&drv->lock, flags);
 	/*
 	 * The h/w does not like if we send a request to the same address,
 	 * when one is already in-flight or being processed.
 	 */
 	ret = check_for_req_inflight(drv, tcs, msg);
 	if (ret)
-		goto unlock;
-
-	ret = find_free_tcs(tcs);
-	if (ret < 0)
-		goto unlock;
-	tcs_id = ret;
-
-	tcs->req[tcs_id - tcs->offset] = msg;
-	set_bit(tcs_id, drv->tcs_in_use);
-	if (msg->state == RPMH_ACTIVE_ONLY_STATE && tcs->type != ACTIVE_TCS) {
-		/*
-		 * Clear previously programmed WAKE commands in selected
-		 * repurposed TCS to avoid triggering them. tcs->slots will be
-		 * cleaned from rpmh_flush() by invoking rpmh_rsc_invalidate()
-		 */
-		write_tcs_reg_sync(drv, RSC_DRV_CMD_ENABLE, tcs_id, 0);
-		write_tcs_reg_sync(drv, RSC_DRV_CMD_WAIT_FOR_CMPL, tcs_id, 0);
-		enable_tcs_irq(drv, tcs_id, true);
-	}
-	spin_unlock_irqrestore(&drv->lock, flags);
-
-	/*
-	 * These two can be done after the lock is released because:
-	 * - We marked "tcs_in_use" under lock.
-	 * - Once "tcs_in_use" has been marked nobody else could be writing
-	 *   to these registers until the interrupt goes off.
-	 * - The interrupt can't go off until we trigger w/ the last line
-	 *   of __tcs_set_trigger() below.
-	 */
-	__tcs_buffer_write(drv, tcs_id, 0, msg);
-	__tcs_set_trigger(drv, tcs_id, true);
+		return ret;
 
-	return 0;
-unlock:
-	spin_unlock_irqrestore(&drv->lock, flags);
-	return ret;
+	return find_free_tcs(tcs);
 }
 
 /**
@@ -664,18 +627,47 @@ unlock:
  */
 int rpmh_rsc_send_data(struct rsc_drv *drv, const struct tcs_request *msg)
 {
-	int ret;
+	struct tcs_group *tcs;
+	int tcs_id;
+	unsigned long flags;
 
-	do {
-		ret = tcs_write(drv, msg);
-		if (ret == -EBUSY) {
-			pr_info_ratelimited("TCS Busy, retrying RPMH message send: addr=%#x\n",
-					    msg->cmds[0].addr);
-			udelay(10);
-		}
-	} while (ret == -EBUSY);
+	tcs = get_tcs_for_msg(drv, msg);
+	if (IS_ERR(tcs))
+		return PTR_ERR(tcs);
 
-	return ret;
+	spin_lock_irqsave(&drv->lock, flags);
+
+	/* Wait forever for a free tcs. It better be there eventually! */
+	wait_event_lock_irq(drv->tcs_wait,
+			    (tcs_id = claim_tcs_for_req(drv, tcs, msg)) >= 0,
+			    drv->lock);
+
+	tcs->req[tcs_id - tcs->offset] = msg;
+	set_bit(tcs_id, drv->tcs_in_use);
+	if (msg->state == RPMH_ACTIVE_ONLY_STATE && tcs->type != ACTIVE_TCS) {
+		/*
+		 * Clear previously programmed WAKE commands in selected
+		 * repurposed TCS to avoid triggering them. tcs->slots will be
+		 * cleaned from rpmh_flush() by invoking rpmh_rsc_invalidate()
+		 */
+		write_tcs_reg_sync(drv, RSC_DRV_CMD_ENABLE, tcs_id, 0);
+		write_tcs_reg_sync(drv, RSC_DRV_CMD_WAIT_FOR_CMPL, tcs_id, 0);
+		enable_tcs_irq(drv, tcs_id, true);
+	}
+	spin_unlock_irqrestore(&drv->lock, flags);
+
+	/*
+	 * These two can be done after the lock is released because:
+	 * - We marked "tcs_in_use" under lock.
+	 * - Once "tcs_in_use" has been marked nobody else could be writing
+	 *   to these registers until the interrupt goes off.
+	 * - The interrupt can't go off until we trigger w/ the last line
+	 *   of __tcs_set_trigger() below.
+	 */
+	__tcs_buffer_write(drv, tcs_id, 0, msg);
+	__tcs_set_trigger(drv, tcs_id, true);
+
+	return 0;
 }
 
 /**
@@ -983,6 +975,7 @@ static int rpmh_rsc_probe(struct platform_device *pdev)
 		return ret;
 
 	spin_lock_init(&drv->lock);
+	init_waitqueue_head(&drv->tcs_wait);
 	bitmap_zero(drv->tcs_in_use, MAX_TCS_NR);
 
 	irq = platform_get_irq(pdev, drv->id);
-- 
2.27.0



