Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0F5462655
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235715AbhK2Wul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235591AbhK2WuH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:50:07 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB5FC1E0FD3;
        Mon, 29 Nov 2021 10:42:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 97780CE13F9;
        Mon, 29 Nov 2021 18:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B88C53FC7;
        Mon, 29 Nov 2021 18:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211321;
        bh=O24e2Bnp77tO+zQbv5DJ+Q3YTNRCgOIhJT0JJS+VHbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xuu/xAJKquLRvNrJJ8fWKjcrvybXKdFq+fvvVRslCofDZA3UWaWpt8wIyGkeGuAfq
         r4LxbwxZL/YKxxOO4XQduswxoA8xwTN0ErN5oiaJ8HDDBLc4kvkl5Oa08mIpEvvP49
         lWtLnj5yLRKgmbnIelRMvYpNjFQ/ZnfHuNfSd9fQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+663359e32ce6f1a305ad@syzkaller.appspotmail.com,
        Marco Elver <elver@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 156/179] perf: Ignore sigtrap for tracepoints destined for other tasks
Date:   Mon, 29 Nov 2021 19:19:10 +0100
Message-Id: <20211129181724.081850187@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

[ Upstream commit 73743c3b092277febbf69b250ce8ebbca0525aa2 ]

syzbot reported that the warning in perf_sigtrap() fires, saying that
the event's task does not match current:

 | WARNING: CPU: 0 PID: 9090 at kernel/events/core.c:6446 perf_pending_event+0x40d/0x4b0 kernel/events/core.c:6513
 | Modules linked in:
 | CPU: 0 PID: 9090 Comm: syz-executor.1 Not tainted 5.15.0-syzkaller #0
 | Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
 | RIP: 0010:perf_sigtrap kernel/events/core.c:6446 [inline]
 | RIP: 0010:perf_pending_event_disable kernel/events/core.c:6470 [inline]
 | RIP: 0010:perf_pending_event+0x40d/0x4b0 kernel/events/core.c:6513
 | ...
 | Call Trace:
 |  <IRQ>
 |  irq_work_single+0x106/0x220 kernel/irq_work.c:211
 |  irq_work_run_list+0x6a/0x90 kernel/irq_work.c:242
 |  irq_work_run+0x4f/0xd0 kernel/irq_work.c:251
 |  __sysvec_irq_work+0x95/0x3d0 arch/x86/kernel/irq_work.c:22
 |  sysvec_irq_work+0x8e/0xc0 arch/x86/kernel/irq_work.c:17
 |  </IRQ>
 |  <TASK>
 |  asm_sysvec_irq_work+0x12/0x20 arch/x86/include/asm/idtentry.h:664
 | RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:152 [inline]
 | RIP: 0010:_raw_spin_unlock_irqrestore+0x38/0x70 kernel/locking/spinlock.c:194
 | ...
 |  coredump_task_exit kernel/exit.c:371 [inline]
 |  do_exit+0x1865/0x25c0 kernel/exit.c:771
 |  do_group_exit+0xe7/0x290 kernel/exit.c:929
 |  get_signal+0x3b0/0x1ce0 kernel/signal.c:2820
 |  arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
 |  handle_signal_work kernel/entry/common.c:148 [inline]
 |  exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 |  exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
 |  __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 |  syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 |  do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 |  entry_SYSCALL_64_after_hwframe+0x44/0xae

On x86 this shouldn't happen, which has arch_irq_work_raise().

The test program sets up a perf event with sigtrap set to fire on the
'sched_wakeup' tracepoint, which fired in ttwu_do_wakeup().

This happened because the 'sched_wakeup' tracepoint also takes a task
argument passed on to perf_tp_event(), which is used to deliver the
event to that other task.

Since we cannot deliver synchronous signals to other tasks, skip an event if
perf_tp_event() is targeted at another task and perf_event_attr::sigtrap is
set, which will avoid ever entering perf_sigtrap() for such events.

Fixes: 97ba62b27867 ("perf: Add support for SIGTRAP on perf events")
Reported-by: syzbot+663359e32ce6f1a305ad@syzkaller.appspotmail.com
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/YYpoCOBmC/kJWfmI@elver.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7162b600e7eaa..2931faf92a76f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9729,6 +9729,9 @@ void perf_tp_event(u16 event_type, u64 count, void *record, int entry_size,
 				continue;
 			if (event->attr.config != entry->type)
 				continue;
+			/* Cannot deliver synchronous signal to other task. */
+			if (event->attr.sigtrap)
+				continue;
 			if (perf_tp_event_match(event, &data, regs))
 				perf_swevent_event(event, count, &data, regs);
 		}
-- 
2.33.0



