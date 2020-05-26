Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D964D1AB5AB
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 03:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388437AbgDPBzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 21:55:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388434AbgDPBzL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 21:55:11 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74172206D9;
        Thu, 16 Apr 2020 01:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587002110;
        bh=QDl1vjQ+71ilSjlpq3PmPv0T5gGPNl7XumfuPRdUMos=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ylisqhqOCL3cJ0OzYBhd6/lqLG3sWDdxsc0oELCFY1f1fCguEc8YLq0eTawYFHlVo
         jJeBglXB74HzxwlFD9D7F+RLEv1QRfKxEqedIw/fuEut1js5HOM86QkuKv89aYTW89
         JW41u5BKNlHhx3YYRBsU/YUxxEN/jg1mrXK0OE4I=
Date:   Thu, 16 Apr 2020 10:55:06 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "bibo,mao" <bibo.mao@intel.com>,
        "Ziqian SUN (Zamir)" <zsun@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] kretprobe: Prevent triggering kretprobe from within
 kprobe_flush_task
Message-Id: <20200416105506.904b7847a1b621b75463076d@kernel.org>
In-Reply-To: <20200415090507.GG208694@krava>
References: <20200408164641.3299633-1-jolsa@kernel.org>
        <20200409234101.8814f3cbead69337ac5a33fa@kernel.org>
        <20200409184451.GG3309111@krava>
        <20200409201336.GH3309111@krava>
        <20200410093159.0d7000a08fd76c2eaf1398f8@kernel.org>
        <20200414160338.GE208694@krava>
        <20200415090507.GG208694@krava>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 15 Apr 2020 11:05:07 +0200
Jiri Olsa <jolsa@redhat.com> wrote:

> Ziqian reported lockup when adding retprobe on _raw_spin_lock_irqsave.
> My test was also able to trigger lockdep output:
> 
>  ============================================
>  WARNING: possible recursive locking detected
>  5.6.0-rc6+ #6 Not tainted
>  --------------------------------------------
>  sched-messaging/2767 is trying to acquire lock:
>  ffffffff9a492798 (&(kretprobe_table_locks[i].lock)){-.-.}, at: kretprobe_hash_lock+0x52/0xa0
> 
>  but task is already holding lock:
>  ffffffff9a491a18 (&(kretprobe_table_locks[i].lock)){-.-.}, at: kretprobe_trampoline+0x0/0x50
> 
>  other info that might help us debug this:
>   Possible unsafe locking scenario:
> 
>         CPU0
>         ----
>    lock(&(kretprobe_table_locks[i].lock));
>    lock(&(kretprobe_table_locks[i].lock));
> 
>   *** DEADLOCK ***
> 
>   May be due to missing lock nesting notation
> 
>  1 lock held by sched-messaging/2767:
>   #0: ffffffff9a491a18 (&(kretprobe_table_locks[i].lock)){-.-.}, at: kretprobe_trampoline+0x0/0x50
> 
>  stack backtrace:
>  CPU: 3 PID: 2767 Comm: sched-messaging Not tainted 5.6.0-rc6+ #6
>  Call Trace:
>   dump_stack+0x96/0xe0
>   __lock_acquire.cold.57+0x173/0x2b7
>   ? native_queued_spin_lock_slowpath+0x42b/0x9e0
>   ? lockdep_hardirqs_on+0x590/0x590
>   ? __lock_acquire+0xf63/0x4030
>   lock_acquire+0x15a/0x3d0
>   ? kretprobe_hash_lock+0x52/0xa0
>   _raw_spin_lock_irqsave+0x36/0x70
>   ? kretprobe_hash_lock+0x52/0xa0
>   kretprobe_hash_lock+0x52/0xa0
>   trampoline_handler+0xf8/0x940
>   ? kprobe_fault_handler+0x380/0x380
>   ? find_held_lock+0x3a/0x1c0
>   kretprobe_trampoline+0x25/0x50
>   ? lock_acquired+0x392/0xbc0
>   ? _raw_spin_lock_irqsave+0x50/0x70
>   ? __get_valid_kprobe+0x1f0/0x1f0
>   ? _raw_spin_unlock_irqrestore+0x3b/0x40
>   ? finish_task_switch+0x4b9/0x6d0
>   ? __switch_to_asm+0x34/0x70
>   ? __switch_to_asm+0x40/0x70
> 
> The code within the kretprobe handler checks for probe reentrancy,
> so we won't trigger any _raw_spin_lock_irqsave probe in there.
> 
> The problem is in outside kprobe_flush_task, where we call:
> 
>   kprobe_flush_task
>     kretprobe_table_lock
>       raw_spin_lock_irqsave
>         _raw_spin_lock_irqsave
> 
> where _raw_spin_lock_irqsave triggers the kretprobe and installs
> kretprobe_trampoline handler on _raw_spin_lock_irqsave return.
> 
> The kretprobe_trampoline handler is then executed with already
> locked kretprobe_table_locks, and first thing it does is to
> lock kretprobe_table_locks ;-) the whole lockup path like:
> 
>   kprobe_flush_task
>     kretprobe_table_lock
>       raw_spin_lock_irqsave
>         _raw_spin_lock_irqsave ---> probe triggered, kretprobe_trampoline installed
> 
>         ---> kretprobe_table_locks locked
> 
>         kretprobe_trampoline
>           trampoline_handler
>             kretprobe_hash_lock(current, &head, &flags);  <--- deadlock
> 
> Adding kprobe_busy_begin/end helpers that mark code with fake
> probe installed to prevent triggering of another kprobe within
> this code.
> 
> Using these helpers in kprobe_flush_task, so the probe recursion
> protection check is hit and the probe is never set to prevent
> above lockup.
> 
> Reported-by: "Ziqian SUN (Zamir)" <zsun@redhat.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Thanks Jiri and Ziqian!

Looks good to me.

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>

BTW, this is a kind of bugfix. So should it add a Fixes tag?

Fixes: ef53d9c5e4da ('kprobes: improve kretprobe scalability with hashed locking')
Cc: stable@vger.kernel.org

Thank you,

> ---
>  arch/x86/kernel/kprobes/core.c | 16 +++-------------
>  include/linux/kprobes.h        |  4 ++++
>  kernel/kprobes.c               | 24 ++++++++++++++++++++++++
>  3 files changed, 31 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
> index 4d7022a740ab..a12adbe1559d 100644
> --- a/arch/x86/kernel/kprobes/core.c
> +++ b/arch/x86/kernel/kprobes/core.c
> @@ -753,16 +753,11 @@ asm(
>  NOKPROBE_SYMBOL(kretprobe_trampoline);
>  STACK_FRAME_NON_STANDARD(kretprobe_trampoline);
>  
> -static struct kprobe kretprobe_kprobe = {
> -	.addr = (void *)kretprobe_trampoline,
> -};
> -
>  /*
>   * Called from kretprobe_trampoline
>   */
>  __used __visible void *trampoline_handler(struct pt_regs *regs)
>  {
> -	struct kprobe_ctlblk *kcb;
>  	struct kretprobe_instance *ri = NULL;
>  	struct hlist_head *head, empty_rp;
>  	struct hlist_node *tmp;
> @@ -772,16 +767,12 @@ __used __visible void *trampoline_handler(struct pt_regs *regs)
>  	void *frame_pointer;
>  	bool skipped = false;
>  
> -	preempt_disable();
> -
>  	/*
>  	 * Set a dummy kprobe for avoiding kretprobe recursion.
>  	 * Since kretprobe never run in kprobe handler, kprobe must not
>  	 * be running at this point.
>  	 */
> -	kcb = get_kprobe_ctlblk();
> -	__this_cpu_write(current_kprobe, &kretprobe_kprobe);
> -	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
> +	kprobe_busy_begin();
>  
>  	INIT_HLIST_HEAD(&empty_rp);
>  	kretprobe_hash_lock(current, &head, &flags);
> @@ -857,7 +848,7 @@ __used __visible void *trampoline_handler(struct pt_regs *regs)
>  			__this_cpu_write(current_kprobe, &ri->rp->kp);
>  			ri->ret_addr = correct_ret_addr;
>  			ri->rp->handler(ri, regs);
> -			__this_cpu_write(current_kprobe, &kretprobe_kprobe);
> +			__this_cpu_write(current_kprobe, &kprobe_busy);
>  		}
>  
>  		recycle_rp_inst(ri, &empty_rp);
> @@ -873,8 +864,7 @@ __used __visible void *trampoline_handler(struct pt_regs *regs)
>  
>  	kretprobe_hash_unlock(current, &flags);
>  
> -	__this_cpu_write(current_kprobe, NULL);
> -	preempt_enable();
> +	kprobe_busy_end();
>  
>  	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
>  		hlist_del(&ri->hlist);
> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
> index 04bdaf01112c..645fd401c856 100644
> --- a/include/linux/kprobes.h
> +++ b/include/linux/kprobes.h
> @@ -350,6 +350,10 @@ static inline struct kprobe_ctlblk *get_kprobe_ctlblk(void)
>  	return this_cpu_ptr(&kprobe_ctlblk);
>  }
>  
> +extern struct kprobe kprobe_busy;
> +void kprobe_busy_begin(void);
> +void kprobe_busy_end(void);
> +
>  kprobe_opcode_t *kprobe_lookup_name(const char *name, unsigned int offset);
>  int register_kprobe(struct kprobe *p);
>  void unregister_kprobe(struct kprobe *p);
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 2625c241ac00..75bb4a8458e7 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1236,6 +1236,26 @@ __releases(hlist_lock)
>  }
>  NOKPROBE_SYMBOL(kretprobe_table_unlock);
>  
> +struct kprobe kprobe_busy = {
> +	.addr = (void *) get_kprobe,
> +};
> +
> +void kprobe_busy_begin(void)
> +{
> +	struct kprobe_ctlblk *kcb;
> +
> +	preempt_disable();
> +	__this_cpu_write(current_kprobe, &kprobe_busy);
> +	kcb = get_kprobe_ctlblk();
> +	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
> +}
> +
> +void kprobe_busy_end(void)
> +{
> +	__this_cpu_write(current_kprobe, NULL);
> +	preempt_enable();
> +}
> +
>  /*
>   * This function is called from finish_task_switch when task tk becomes dead,
>   * so that we can recycle any function-return probe instances associated
> @@ -1253,6 +1273,8 @@ void kprobe_flush_task(struct task_struct *tk)
>  		/* Early boot.  kretprobe_table_locks not yet initialized. */
>  		return;
>  
> +	kprobe_busy_begin();
> +
>  	INIT_HLIST_HEAD(&empty_rp);
>  	hash = hash_ptr(tk, KPROBE_HASH_BITS);
>  	head = &kretprobe_inst_table[hash];
> @@ -1266,6 +1288,8 @@ void kprobe_flush_task(struct task_struct *tk)
>  		hlist_del(&ri->hlist);
>  		kfree(ri);
>  	}
> +
> +	kprobe_busy_end();
>  }
>  NOKPROBE_SYMBOL(kprobe_flush_task);
>  
> -- 
> 2.18.2
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
