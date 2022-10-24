Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CC860A8EA
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235394AbiJXNMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235392AbiJXNKi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:10:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BFA55AF;
        Mon, 24 Oct 2022 05:24:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84901B8128A;
        Mon, 24 Oct 2022 12:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D805DC433D6;
        Mon, 24 Oct 2022 12:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613303;
        bh=UyuZpJtDdBlAMBxwjO1LoIr8P8/jB/CSrlcYvn14KoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5U1Q4RG7gldGGmgXQC+Siln4PCbkNau40FYisjghvZsu4KqvwwRZyowdDbjiwkV5
         ih61cxqNCwmwhvFFKtq99Xql5oRRzodbc/JsYPL/WNCcyhDFNB/PU3MsOGSAnCFaWh
         UQ/R4BE8Sa8FdxC91AJIzrPhBwRRSvRAKVAeOu6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Waiman Long <longman@redhat.com>
Subject: [PATCH 5.4 058/255] tracing: Disable interrupt or preemption before acquiring arch_spinlock_t
Date:   Mon, 24 Oct 2022 13:29:28 +0200
Message-Id: <20221024113004.424681161@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

commit c0a581d7126c0bbc96163276f585fd7b4e4d8d0e upstream.

It was found that some tracing functions in kernel/trace/trace.c acquire
an arch_spinlock_t with preemption and irqs enabled. An example is the
tracing_saved_cmdlines_size_read() function which intermittently causes
a "BUG: using smp_processor_id() in preemptible" warning when the LTP
read_all_proc test is run.

That can be problematic in case preemption happens after acquiring the
lock. Add the necessary preemption or interrupt disabling code in the
appropriate places before acquiring an arch_spinlock_t.

The convention here is to disable preemption for trace_cmdline_lock and
interupt for max_lock.

Link: https://lkml.kernel.org/r/20220922145622.1744826-1-longman@redhat.com

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: stable@vger.kernel.org
Fixes: a35873a0993b ("tracing: Add conditional snapshot")
Fixes: 939c7a4f04fc ("tracing: Introduce saved_cmdlines_size file")
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1015,12 +1015,14 @@ void *tracing_cond_snapshot_data(struct
 {
 	void *cond_data = NULL;
 
+	local_irq_disable();
 	arch_spin_lock(&tr->max_lock);
 
 	if (tr->cond_snapshot)
 		cond_data = tr->cond_snapshot->cond_data;
 
 	arch_spin_unlock(&tr->max_lock);
+	local_irq_enable();
 
 	return cond_data;
 }
@@ -1156,9 +1158,11 @@ int tracing_snapshot_cond_enable(struct
 		goto fail_unlock;
 	}
 
+	local_irq_disable();
 	arch_spin_lock(&tr->max_lock);
 	tr->cond_snapshot = cond_snapshot;
 	arch_spin_unlock(&tr->max_lock);
+	local_irq_enable();
 
 	mutex_unlock(&trace_types_lock);
 
@@ -1185,6 +1189,7 @@ int tracing_snapshot_cond_disable(struct
 {
 	int ret = 0;
 
+	local_irq_disable();
 	arch_spin_lock(&tr->max_lock);
 
 	if (!tr->cond_snapshot)
@@ -1195,6 +1200,7 @@ int tracing_snapshot_cond_disable(struct
 	}
 
 	arch_spin_unlock(&tr->max_lock);
+	local_irq_enable();
 
 	return ret;
 }
@@ -1951,6 +1957,11 @@ static size_t tgid_map_max;
 
 #define SAVED_CMDLINES_DEFAULT 128
 #define NO_CMDLINE_MAP UINT_MAX
+/*
+ * Preemption must be disabled before acquiring trace_cmdline_lock.
+ * The various trace_arrays' max_lock must be acquired in a context
+ * where interrupt is disabled.
+ */
 static arch_spinlock_t trace_cmdline_lock = __ARCH_SPIN_LOCK_UNLOCKED;
 struct saved_cmdlines_buffer {
 	unsigned map_pid_to_cmdline[PID_MAX_DEFAULT+1];
@@ -2163,6 +2174,9 @@ static int trace_save_cmdline(struct tas
 	 * the lock, but we also don't want to spin
 	 * nor do we want to disable interrupts,
 	 * so if we miss here, then better luck next time.
+	 *
+	 * This is called within the scheduler and wake up, so interrupts
+	 * had better been disabled and run queue lock been held.
 	 */
 	if (!arch_spin_trylock(&trace_cmdline_lock))
 		return 0;
@@ -5199,9 +5213,11 @@ tracing_saved_cmdlines_size_read(struct
 	char buf[64];
 	int r;
 
+	preempt_disable();
 	arch_spin_lock(&trace_cmdline_lock);
 	r = scnprintf(buf, sizeof(buf), "%u\n", savedcmd->cmdline_num);
 	arch_spin_unlock(&trace_cmdline_lock);
+	preempt_enable();
 
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 }
@@ -5226,10 +5242,12 @@ static int tracing_resize_saved_cmdlines
 		return -ENOMEM;
 	}
 
+	preempt_disable();
 	arch_spin_lock(&trace_cmdline_lock);
 	savedcmd_temp = savedcmd;
 	savedcmd = s;
 	arch_spin_unlock(&trace_cmdline_lock);
+	preempt_enable();
 	free_saved_cmdlines_buffer(savedcmd_temp);
 
 	return 0;
@@ -5684,10 +5702,12 @@ static int tracing_set_tracer(struct tra
 
 #ifdef CONFIG_TRACER_SNAPSHOT
 	if (t->use_max_tr) {
+		local_irq_disable();
 		arch_spin_lock(&tr->max_lock);
 		if (tr->cond_snapshot)
 			ret = -EBUSY;
 		arch_spin_unlock(&tr->max_lock);
+		local_irq_enable();
 		if (ret)
 			goto out;
 	}
@@ -6767,10 +6787,12 @@ tracing_snapshot_write(struct file *filp
 		goto out;
 	}
 
+	local_irq_disable();
 	arch_spin_lock(&tr->max_lock);
 	if (tr->cond_snapshot)
 		ret = -EBUSY;
 	arch_spin_unlock(&tr->max_lock);
+	local_irq_enable();
 	if (ret)
 		goto out;
 


