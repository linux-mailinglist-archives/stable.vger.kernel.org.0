Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA265419EE
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378318AbiFGV1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378209AbiFGVX4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:23:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FE42271B1;
        Tue,  7 Jun 2022 12:00:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7F98B823A0;
        Tue,  7 Jun 2022 19:00:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55743C385A2;
        Tue,  7 Jun 2022 19:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628453;
        bh=WOGbrWxzyZjlwEgeZMiKrO6Yp8c0OJ/aqaNZJ65xRjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rw7vUjNfbsODbKOI5E6aW8i8a3mOUipAVrM5zZVjRMA0ZA/yWHceuj9CBpBxAyC4Y
         z0D0j8pXgYVYHSAOvJWl/lg1clrlNv9QlohLMQvg+gi1UvML2BjJfMSgGVOdJzF3Io
         UIVybriGGfP3dW/a8FaK2eOFPuzZtzo0r1Q9GSM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Ogness <john.ogness@linutronix.de>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 336/879] printk: add missing memory barrier to wake_up_klogd()
Date:   Tue,  7 Jun 2022 18:57:34 +0200
Message-Id: <20220607165012.610008844@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit 1f5d783094cf28b4905f51cad846eb5d1db6673e ]

It is important that any new records are visible to preparing
waiters before the waker checks if the wait queue is empty.
Otherwise it is possible that:

- there are new records available
- the waker sees an empty wait queue and does not wake
- the preparing waiter sees no new records and begins to wait

This is exactly the problem that the function description of
waitqueue_active() warns about.

Use wq_has_sleeper() instead of waitqueue_active() because it
includes the necessary full memory barrier.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20220421212250.565456-4-john.ogness@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 39 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index da03c15ecc89..ed6f20992915 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -746,8 +746,19 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 			goto out;
 		}
 
+		/*
+		 * Guarantee this task is visible on the waitqueue before
+		 * checking the wake condition.
+		 *
+		 * The full memory barrier within set_current_state() of
+		 * prepare_to_wait_event() pairs with the full memory barrier
+		 * within wq_has_sleeper().
+		 *
+		 * This pairs with wake_up_klogd:A.
+		 */
 		ret = wait_event_interruptible(log_wait,
-				prb_read_valid(prb, atomic64_read(&user->seq), r));
+				prb_read_valid(prb,
+					atomic64_read(&user->seq), r)); /* LMM(devkmsg_read:A) */
 		if (ret)
 			goto out;
 	}
@@ -1513,7 +1524,18 @@ static int syslog_print(char __user *buf, int size)
 		seq = syslog_seq;
 
 		mutex_unlock(&syslog_lock);
-		len = wait_event_interruptible(log_wait, prb_read_valid(prb, seq, NULL));
+		/*
+		 * Guarantee this task is visible on the waitqueue before
+		 * checking the wake condition.
+		 *
+		 * The full memory barrier within set_current_state() of
+		 * prepare_to_wait_event() pairs with the full memory barrier
+		 * within wq_has_sleeper().
+		 *
+		 * This pairs with wake_up_klogd:A.
+		 */
+		len = wait_event_interruptible(log_wait,
+				prb_read_valid(prb, seq, NULL)); /* LMM(syslog_print:A) */
 		mutex_lock(&syslog_lock);
 
 		if (len)
@@ -3316,7 +3338,18 @@ void wake_up_klogd(void)
 		return;
 
 	preempt_disable();
-	if (waitqueue_active(&log_wait)) {
+	/*
+	 * Guarantee any new records can be seen by tasks preparing to wait
+	 * before this context checks if the wait queue is empty.
+	 *
+	 * The full memory barrier within wq_has_sleeper() pairs with the full
+	 * memory barrier within set_current_state() of
+	 * prepare_to_wait_event(), which is called after ___wait_event() adds
+	 * the waiter but before it has checked the wait condition.
+	 *
+	 * This pairs with devkmsg_read:A and syslog_print:A.
+	 */
+	if (wq_has_sleeper(&log_wait)) { /* LMM(wake_up_klogd:A) */
 		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
 		irq_work_queue(this_cpu_ptr(&wake_up_klogd_work));
 	}
-- 
2.35.1



