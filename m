Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DACE541301
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357557AbiFGTzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358892AbiFGTxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:53:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E486CF4E;
        Tue,  7 Jun 2022 11:22:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32EA460DDF;
        Tue,  7 Jun 2022 18:22:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6AFC3411C;
        Tue,  7 Jun 2022 18:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626178;
        bh=o0MfHiFg0qTpc2nNL/SOYVQq3GUqMujoqpOGgasXE9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yG/psrwqxt2lyJFV3lUQSXFj3qIJpMVAVInpFKQatwwp9wwMPXddQZ7z2WWmVN5JQ
         vvQShthmD0wDO3jKyR6t3g0Z8eglTyoG9Zr323ONhJF6c/WNFvdl0AVO+BEGCdiOoV
         CQ9K5qo3u1XgzSQXNKc0df1PG+TxSaNwnFYO3ikc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Ogness <john.ogness@linutronix.de>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 284/772] printk: wake waiters for safe and NMI contexts
Date:   Tue,  7 Jun 2022 18:57:56 +0200
Message-Id: <20220607164957.394816652@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

[ Upstream commit 5341b93dea8c39d7612f7a227015d4b1d5cf30db ]

When printk() is called from safe or NMI contexts, it will directly
store the record (vprintk_store()) and then defer the console output.
However, defer_console_output() only causes console printing and does
not wake any waiters of new records.

Wake waiters from defer_console_output() so that they also are aware
of the new records from safe and NMI contexts.

Fixes: 03fc7f9c99c1 ("printk/nmi: Prevent deadlock when accessing the main log buffer in NMI")
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20220421212250.565456-6-john.ogness@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 8964b1db2745..4f344e7b2878 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -743,7 +743,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 		 * prepare_to_wait_event() pairs with the full memory barrier
 		 * within wq_has_sleeper().
 		 *
-		 * This pairs with wake_up_klogd:A.
+		 * This pairs with __wake_up_klogd:A.
 		 */
 		ret = wait_event_interruptible(log_wait,
 				prb_read_valid(prb,
@@ -1521,7 +1521,7 @@ static int syslog_print(char __user *buf, int size)
 		 * prepare_to_wait_event() pairs with the full memory barrier
 		 * within wq_has_sleeper().
 		 *
-		 * This pairs with wake_up_klogd:A.
+		 * This pairs with __wake_up_klogd:A.
 		 */
 		len = wait_event_interruptible(log_wait,
 				prb_read_valid(prb, seq, NULL)); /* LMM(syslog_print:A) */
@@ -3267,7 +3267,7 @@ static void wake_up_klogd_work_func(struct irq_work *irq_work)
 static DEFINE_PER_CPU(struct irq_work, wake_up_klogd_work) =
 	IRQ_WORK_INIT_LAZY(wake_up_klogd_work_func);
 
-void wake_up_klogd(void)
+static void __wake_up_klogd(int val)
 {
 	if (!printk_percpu_data_ready())
 		return;
@@ -3284,22 +3284,26 @@ void wake_up_klogd(void)
 	 *
 	 * This pairs with devkmsg_read:A and syslog_print:A.
 	 */
-	if (wq_has_sleeper(&log_wait)) { /* LMM(wake_up_klogd:A) */
-		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
+	if (wq_has_sleeper(&log_wait) || /* LMM(__wake_up_klogd:A) */
+	    (val & PRINTK_PENDING_OUTPUT)) {
+		this_cpu_or(printk_pending, val);
 		irq_work_queue(this_cpu_ptr(&wake_up_klogd_work));
 	}
 	preempt_enable();
 }
 
-void defer_console_output(void)
+void wake_up_klogd(void)
 {
-	if (!printk_percpu_data_ready())
-		return;
+	__wake_up_klogd(PRINTK_PENDING_WAKEUP);
+}
 
-	preempt_disable();
-	this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
-	irq_work_queue(this_cpu_ptr(&wake_up_klogd_work));
-	preempt_enable();
+void defer_console_output(void)
+{
+	/*
+	 * New messages may have been added directly to the ringbuffer
+	 * using vprintk_store(), so wake any waiters as well.
+	 */
+	__wake_up_klogd(PRINTK_PENDING_WAKEUP | PRINTK_PENDING_OUTPUT);
 }
 
 void printk_trigger_flush(void)
-- 
2.35.1



