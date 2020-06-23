Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBCA2053C8
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 15:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732744AbgFWNsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 09:48:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732629AbgFWNsx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 09:48:53 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A56320723;
        Tue, 23 Jun 2020 13:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592920132;
        bh=bTcejyDdkSqLnoJ0Q00ZbYqOexfpMOpzK9BCqdHalXw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nBDaik9T45+2xGULVPRpx4jkFJXvLyKzYi691tMamiGcwZAXzk5gjvQB06vnFh83A
         Zqk8tbwKlHvOL7QQp+GvzDCrfllc9oj+mn8dcVd4Wbpe+oC1gsG4E9E+8hIcLjUsP4
         ODrdfQI6fKr/ZOG73OvfacIRuLaTF5iuU+B2slBg=
Date:   Tue, 23 Jun 2020 09:48:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     jolsa@redhat.com, anders.roxell@linaro.org,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        gustavoars@kernel.org, jolsa@kernel.org, mhiramat@kernel.org,
        mingo@elte.hu, mingo@kernel.org, naveen.n.rao@linux.ibm.com,
        peterz@infradead.org, rostedt@goodmis.org, zsun@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] kretprobe: Prevent triggering kretprobe
 from within" failed to apply to 4.19-stable tree
Message-ID: <20200623134850.GY1931@sasha-vm>
References: <1592913476106162@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1592913476106162@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 23, 2020 at 01:57:56PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 9b38cc704e844e41d9cf74e647bff1d249512cb3 Mon Sep 17 00:00:00 2001
>From: Jiri Olsa <jolsa@redhat.com>
>Date: Tue, 12 May 2020 17:03:18 +0900
>Subject: [PATCH] kretprobe: Prevent triggering kretprobe from within
> kprobe_flush_task
>
>Ziqian reported lockup when adding retprobe on _raw_spin_lock_irqsave.
>My test was also able to trigger lockdep output:
>
> ============================================
> WARNING: possible recursive locking detected
> 5.6.0-rc6+ #6 Not tainted
> --------------------------------------------
> sched-messaging/2767 is trying to acquire lock:
> ffffffff9a492798 (&(kretprobe_table_locks[i].lock)){-.-.}, at: kretprobe_hash_lock+0x52/0xa0
>
> but task is already holding lock:
> ffffffff9a491a18 (&(kretprobe_table_locks[i].lock)){-.-.}, at: kretprobe_trampoline+0x0/0x50
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock(&(kretprobe_table_locks[i].lock));
>   lock(&(kretprobe_table_locks[i].lock));
>
>  *** DEADLOCK ***
>
>  May be due to missing lock nesting notation
>
> 1 lock held by sched-messaging/2767:
>  #0: ffffffff9a491a18 (&(kretprobe_table_locks[i].lock)){-.-.}, at: kretprobe_trampoline+0x0/0x50
>
> stack backtrace:
> CPU: 3 PID: 2767 Comm: sched-messaging Not tainted 5.6.0-rc6+ #6
> Call Trace:
>  dump_stack+0x96/0xe0
>  __lock_acquire.cold.57+0x173/0x2b7
>  ? native_queued_spin_lock_slowpath+0x42b/0x9e0
>  ? lockdep_hardirqs_on+0x590/0x590
>  ? __lock_acquire+0xf63/0x4030
>  lock_acquire+0x15a/0x3d0
>  ? kretprobe_hash_lock+0x52/0xa0
>  _raw_spin_lock_irqsave+0x36/0x70
>  ? kretprobe_hash_lock+0x52/0xa0
>  kretprobe_hash_lock+0x52/0xa0
>  trampoline_handler+0xf8/0x940
>  ? kprobe_fault_handler+0x380/0x380
>  ? find_held_lock+0x3a/0x1c0
>  kretprobe_trampoline+0x25/0x50
>  ? lock_acquired+0x392/0xbc0
>  ? _raw_spin_lock_irqsave+0x50/0x70
>  ? __get_valid_kprobe+0x1f0/0x1f0
>  ? _raw_spin_unlock_irqrestore+0x3b/0x40
>  ? finish_task_switch+0x4b9/0x6d0
>  ? __switch_to_asm+0x34/0x70
>  ? __switch_to_asm+0x40/0x70
>
>The code within the kretprobe handler checks for probe reentrancy,
>so we won't trigger any _raw_spin_lock_irqsave probe in there.
>
>The problem is in outside kprobe_flush_task, where we call:
>
>  kprobe_flush_task
>    kretprobe_table_lock
>      raw_spin_lock_irqsave
>        _raw_spin_lock_irqsave
>
>where _raw_spin_lock_irqsave triggers the kretprobe and installs
>kretprobe_trampoline handler on _raw_spin_lock_irqsave return.
>
>The kretprobe_trampoline handler is then executed with already
>locked kretprobe_table_locks, and first thing it does is to
>lock kretprobe_table_locks ;-) the whole lockup path like:
>
>  kprobe_flush_task
>    kretprobe_table_lock
>      raw_spin_lock_irqsave
>        _raw_spin_lock_irqsave ---> probe triggered, kretprobe_trampoline installed
>
>        ---> kretprobe_table_locks locked
>
>        kretprobe_trampoline
>          trampoline_handler
>            kretprobe_hash_lock(current, &head, &flags);  <--- deadlock
>
>Adding kprobe_busy_begin/end helpers that mark code with fake
>probe installed to prevent triggering of another kprobe within
>this code.
>
>Using these helpers in kprobe_flush_task, so the probe recursion
>protection check is hit and the probe is never set to prevent
>above lockup.
>
>Link: http://lkml.kernel.org/r/158927059835.27680.7011202830041561604.stgit@devnote2
>
>Fixes: ef53d9c5e4da ("kprobes: improve kretprobe scalability with hashed locking")
>Cc: Ingo Molnar <mingo@kernel.org>
>Cc: "Gustavo A . R . Silva" <gustavoars@kernel.org>
>Cc: Anders Roxell <anders.roxell@linaro.org>
>Cc: "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>
>Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
>Cc: David Miller <davem@davemloft.net>
>Cc: Ingo Molnar <mingo@elte.hu>
>Cc: Peter Zijlstra <peterz@infradead.org>
>Cc: stable@vger.kernel.org
>Reported-by: "Ziqian SUN (Zamir)" <zsun@redhat.com>
>Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
>Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

I'm not sure what was wrong with 4.19 and 4.14 as those just worked for
me.

On 4.9 and 4.4 I've grabbed these additional commits:

9b38cc704e84 ("kretprobe: Prevent triggering kretprobe from within kprobe_flush_task")
b191fa96ea6d ("x86/kprobes: Avoid kretprobe recursion bug")
30176466e36a ("powerpc/kprobes: Fixes for kprobe_lookup_name() on BE")
ebfa50df435e ("powerpc: Add helper to check if offset is within relative branch range")

But dropped the Optprobes stuff out as we don't have 51c9c0843993
("powerpc/kprobes: Implement Optprobes").

-- 
Thanks,
Sasha
