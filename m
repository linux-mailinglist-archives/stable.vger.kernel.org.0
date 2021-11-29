Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B6C4625CA
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234842AbhK2WnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234539AbhK2Wmn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:42:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09933C1E0FD5;
        Mon, 29 Nov 2021 10:42:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 82555CE13AA;
        Mon, 29 Nov 2021 18:42:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3FCC53FC7;
        Mon, 29 Nov 2021 18:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211324;
        bh=3tE4lGDS51siPyHhLdWt2B0Qifa5CIu6BKAnaaukIic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tD7LS2kXiaKlWgYn1uPuoOWuaaLYbvAGe5rky7b4HOHXefkMtOgpsY2O0dh1uFT22
         SA45OO7jhq5syaaTub8xS+l65vMa9+5tJbOg8FeMoB2BnfYw7qWuoz4eGDYE0ksMxR
         5hnJE0NMhQf1Y75UFZ7aBiAxrKnrGgvpZQASBan8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <quic_qiancai@quicinc.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 157/179] sched/scs: Reset task stack state in bringup_cpu()
Date:   Mon, 29 Nov 2021 19:19:11 +0100
Message-Id: <20211129181724.114107875@linuxfoundation.org>
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

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit dce1ca0525bfdc8a69a9343bc714fbc19a2f04b3 ]

To hot unplug a CPU, the idle task on that CPU calls a few layers of C
code before finally leaving the kernel. When KASAN is in use, poisoned
shadow is left around for each of the active stack frames, and when
shadow call stacks are in use. When shadow call stacks (SCS) are in use
the task's saved SCS SP is left pointing at an arbitrary point within
the task's shadow call stack.

When a CPU is offlined than onlined back into the kernel, this stale
state can adversely affect execution. Stale KASAN shadow can alias new
stackframes and result in bogus KASAN warnings. A stale SCS SP is
effectively a memory leak, and prevents a portion of the shadow call
stack being used. Across a number of hotplug cycles the idle task's
entire shadow call stack can become unusable.

We previously fixed the KASAN issue in commit:

  e1b77c92981a5222 ("sched/kasan: remove stale KASAN poison after hotplug")

... by removing any stale KASAN stack poison immediately prior to
onlining a CPU.

Subsequently in commit:

  f1a0a376ca0c4ef1 ("sched/core: Initialize the idle task with preemption disabled")

... the refactoring left the KASAN and SCS cleanup in one-time idle
thread initialization code rather than something invoked prior to each
CPU being onlined, breaking both as above.

We fixed SCS (but not KASAN) in commit:

  63acd42c0d4942f7 ("sched/scs: Reset the shadow stack when idle_task_exit")

... but as this runs in the context of the idle task being offlined it's
potentially fragile.

To fix these consistently and more robustly, reset the SCS SP and KASAN
shadow of a CPU's idle task immediately before we online that CPU in
bringup_cpu(). This ensures the idle task always has a consistent state
when it is running, and removes the need to so so when exiting an idle
task.

Whenever any thread is created, dup_task_struct() will give the task a
stack which is free of KASAN shadow, and initialize the task's SCS SP,
so there's no need to specially initialize either for idle thread within
init_idle(), as this was only necessary to handle hotplug cycles.

I've tested this on arm64 with:

* gcc 11.1.0, defconfig +KASAN_INLINE, KASAN_STACK
* clang 12.0.0, defconfig +KASAN_INLINE, KASAN_STACK, SHADOW_CALL_STACK

... offlining and onlining CPUS with:

| while true; do
|   for C in /sys/devices/system/cpu/cpu*/online; do
|     echo 0 > $C;
|     echo 1 > $C;
|   done
| done

Fixes: f1a0a376ca0c4ef1 ("sched/core: Initialize the idle task with preemption disabled")
Reported-by: Qian Cai <quic_qiancai@quicinc.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Tested-by: Qian Cai <quic_qiancai@quicinc.com>
Link: https://lore.kernel.org/lkml/20211115113310.35693-1-mark.rutland@arm.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cpu.c        | 7 +++++++
 kernel/sched/core.c | 4 ----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 192e43a874076..407a2568f35eb 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -31,6 +31,7 @@
 #include <linux/smpboot.h>
 #include <linux/relay.h>
 #include <linux/slab.h>
+#include <linux/scs.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/cpuset.h>
 
@@ -587,6 +588,12 @@ static int bringup_cpu(unsigned int cpu)
 	struct task_struct *idle = idle_thread_get(cpu);
 	int ret;
 
+	/*
+	 * Reset stale stack state from the last time this CPU was online.
+	 */
+	scs_task_reset(idle);
+	kasan_unpoison_task_stack(idle);
+
 	/*
 	 * Some architectures have to walk the irq descriptors to
 	 * setup the vector space for the cpu which comes online.
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 779f27a4b46ac..6f4625f8276f1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8641,9 +8641,6 @@ void __init init_idle(struct task_struct *idle, int cpu)
 	idle->flags |= PF_IDLE | PF_KTHREAD | PF_NO_SETAFFINITY;
 	kthread_set_per_cpu(idle, cpu);
 
-	scs_task_reset(idle);
-	kasan_unpoison_task_stack(idle);
-
 #ifdef CONFIG_SMP
 	/*
 	 * It's possible that init_idle() gets called multiple times on a task,
@@ -8799,7 +8796,6 @@ void idle_task_exit(void)
 		finish_arch_post_lock_switch();
 	}
 
-	scs_task_reset(current);
 	/* finish_cpu(), as ran on the BP, will clean up the active_mm state */
 }
 
-- 
2.33.0



