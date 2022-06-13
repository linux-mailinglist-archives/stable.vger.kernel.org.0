Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC79549651
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349215AbiFMMeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352727AbiFMMci (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:32:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD2926123;
        Mon, 13 Jun 2022 04:07:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E8C68CE1184;
        Mon, 13 Jun 2022 11:07:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B04C34114;
        Mon, 13 Jun 2022 11:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118444;
        bh=gZn3VS3JM8zDLwPakO824699rxrNIkXxQcrQKKhndbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=okrfx/5cNR7Hwn1UIn33aspj//M94oc42oA9rRFHkSnEf+VEMO1sQ7ZUcA/vMpJSQ
         V4i1e9zzjw45z6QbrlZ7RS64qd8CVlY/dnTYcKvQKpvlbalxtY5yKztotv/3GW9ip2
         TxGvNdWuSbaFkR4koVbtHEoXToVuHlLjD7T3z0Ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jun Miao <jun.miao@intel.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/172] tracing: Fix sleeping function called from invalid context on RT kernel
Date:   Mon, 13 Jun 2022 12:10:38 +0200
Message-Id: <20220613094909.166914198@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
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

From: Jun Miao <jun.miao@intel.com>

[ Upstream commit 12025abdc8539ed9d5014e2d647a3fd1bd3de5cd ]

When setting bootparams="trace_event=initcall:initcall_start tp_printk=1" in the
cmdline, the output_printk() was called, and the spin_lock_irqsave() was called in the
atomic and irq disable interrupt context suitation. On the PREEMPT_RT kernel,
these locks are replaced with sleepable rt-spinlock, so the stack calltrace will
be triggered.
Fix it by raw_spin_lock_irqsave when PREEMPT_RT and "trace_event=initcall:initcall_start
tp_printk=1" enabled.

 BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:46
 in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
 preempt_count: 2, expected: 0
 RCU nest depth: 0, expected: 0
 Preemption disabled at:
 [<ffffffff8992303e>] try_to_wake_up+0x7e/0xba0
 CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.17.1-rt17+ #19 34c5812404187a875f32bee7977f7367f9679ea7
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0x60/0x8c
  dump_stack+0x10/0x12
  __might_resched.cold+0x11d/0x155
  rt_spin_lock+0x40/0x70
  trace_event_buffer_commit+0x2fa/0x4c0
  ? map_vsyscall+0x93/0x93
  trace_event_raw_event_initcall_start+0xbe/0x110
  ? perf_trace_initcall_finish+0x210/0x210
  ? probe_sched_wakeup+0x34/0x40
  ? ttwu_do_wakeup+0xda/0x310
  ? trace_hardirqs_on+0x35/0x170
  ? map_vsyscall+0x93/0x93
  do_one_initcall+0x217/0x3c0
  ? trace_event_raw_event_initcall_level+0x170/0x170
  ? push_cpu_stop+0x400/0x400
  ? cblist_init_generic+0x241/0x290
  kernel_init_freeable+0x1ac/0x347
  ? _raw_spin_unlock_irq+0x65/0x80
  ? rest_init+0xf0/0xf0
  kernel_init+0x1e/0x150
  ret_from_fork+0x22/0x30
  </TASK>

Link: https://lkml.kernel.org/r/20220419013910.894370-1-jun.miao@intel.com

Signed-off-by: Jun Miao <jun.miao@intel.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 953dd9568dd7..124e3e25e155 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2784,7 +2784,7 @@ trace_event_buffer_lock_reserve(struct trace_buffer **current_rb,
 }
 EXPORT_SYMBOL_GPL(trace_event_buffer_lock_reserve);
 
-static DEFINE_SPINLOCK(tracepoint_iter_lock);
+static DEFINE_RAW_SPINLOCK(tracepoint_iter_lock);
 static DEFINE_MUTEX(tracepoint_printk_mutex);
 
 static void output_printk(struct trace_event_buffer *fbuffer)
@@ -2812,14 +2812,14 @@ static void output_printk(struct trace_event_buffer *fbuffer)
 
 	event = &fbuffer->trace_file->event_call->event;
 
-	spin_lock_irqsave(&tracepoint_iter_lock, flags);
+	raw_spin_lock_irqsave(&tracepoint_iter_lock, flags);
 	trace_seq_init(&iter->seq);
 	iter->ent = fbuffer->entry;
 	event_call->event.funcs->trace(iter, 0, event);
 	trace_seq_putc(&iter->seq, 0);
 	printk("%s", iter->seq.buffer);
 
-	spin_unlock_irqrestore(&tracepoint_iter_lock, flags);
+	raw_spin_unlock_irqrestore(&tracepoint_iter_lock, flags);
 }
 
 int tracepoint_printk_sysctl(struct ctl_table *table, int write,
-- 
2.35.1



