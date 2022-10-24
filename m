Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9E960B0CE
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbiJXQK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbiJXQHD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:07:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188925C97E;
        Mon, 24 Oct 2022 07:58:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09C01B81640;
        Mon, 24 Oct 2022 12:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61EF0C433C1;
        Mon, 24 Oct 2022 12:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613960;
        bh=YHlGoIAmAenQP3/GZa8JYaGtlSrrfBGnz47Nyu7CR1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WKKbbspSP7rcDChSZ/R6qjbx06vE3svapO3IKVXOkmgcyO4Q4hxSTEy37OVUPBSO0
         KbxQlfK+G9WQyVTYWew+rOqNW0tdZphIfLh6/m07HHSDdq0ar2l4CkwTlsoDeegjUc
         FgLkJFxKx5cFZ4MwwoJ0j4i8DdP7dWbFEVvA8PEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Waiman Long <longman@redhat.com>
Subject: [PATCH 5.10 078/390] tracing: Disable interrupt or preemption before acquiring arch_spinlock_t
Date:   Mon, 24 Oct 2022 13:27:55 +0200
Message-Id: <20221024113025.947333118@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
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
 kernel/trace/trace.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1197,12 +1197,14 @@ void *tracing_cond_snapshot_data(struct
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
@@ -1338,9 +1340,11 @@ int tracing_snapshot_cond_enable(struct
 		goto fail_unlock;
 	}
 
+	local_irq_disable();
 	arch_spin_lock(&tr->max_lock);
 	tr->cond_snapshot = cond_snapshot;
 	arch_spin_unlock(&tr->max_lock);
+	local_irq_enable();
 
 	mutex_unlock(&trace_types_lock);
 
@@ -1367,6 +1371,7 @@ int tracing_snapshot_cond_disable(struct
 {
 	int ret = 0;
 
+	local_irq_disable();
 	arch_spin_lock(&tr->max_lock);
 
 	if (!tr->cond_snapshot)
@@ -1377,6 +1382,7 @@ int tracing_snapshot_cond_disable(struct
 	}
 
 	arch_spin_unlock(&tr->max_lock);
+	local_irq_enable();
 
 	return ret;
 }
@@ -2198,6 +2204,11 @@ static size_t tgid_map_max;
 
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
@@ -2410,7 +2421,11 @@ static int trace_save_cmdline(struct tas
 	 * the lock, but we also don't want to spin
 	 * nor do we want to disable interrupts,
 	 * so if we miss here, then better luck next time.
+	 *
+	 * This is called within the scheduler and wake up, so interrupts
+	 * had better been disabled and run queue lock been held.
 	 */
+	lockdep_assert_preemption_disabled();
 	if (!arch_spin_trylock(&trace_cmdline_lock))
 		return 0;
 
@@ -5470,9 +5485,11 @@ tracing_saved_cmdlines_size_read(struct
 	char buf[64];
 	int r;
 
+	preempt_disable();
 	arch_spin_lock(&trace_cmdline_lock);
 	r = scnprintf(buf, sizeof(buf), "%u\n", savedcmd->cmdline_num);
 	arch_spin_unlock(&trace_cmdline_lock);
+	preempt_enable();
 
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 }
@@ -5497,10 +5514,12 @@ static int tracing_resize_saved_cmdlines
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
@@ -5953,10 +5972,12 @@ int tracing_set_tracer(struct trace_arra
 
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
@@ -7030,10 +7051,12 @@ tracing_snapshot_write(struct file *filp
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
 


