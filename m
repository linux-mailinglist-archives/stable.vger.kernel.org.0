Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D6D2F6444
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 16:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbhANPUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 10:20:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:34002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728098AbhANPUO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Jan 2021 10:20:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B800E238EA;
        Thu, 14 Jan 2021 15:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610637573;
        bh=kNliLvzqeg0Eanb5VCqEWzB2DupsN14d0HHdEkAschU=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=kg1DGNIhM9ZzHAwP96psAiuOU2ajqZTJDPbCWtyxwRhtvyjnxU/zWZR5B/NoQYneJ
         3VB819zOo6FuScKi+eCIVZ+4nALjjVeLM35siNNfBMuENnugAhRXrohH2nsnLGyHir
         ZIQO8dMF9Jv968+ZZ+acxN+er1veT4xtPoFZjM9xvjGS9hfWTjKdoebIJbkVtyVNRt
         k57J8hUuG+kF91PFXdI42oxjs72dExdotIRzWJ91IqnJqlsuu3c/gWJWvlKC4YOLZJ
         S+oS+K6G5lQP3Wfa2JQDyRERRr1rOe7ggKStIb1gURws+z8MYhibL5V/5vwK1ShM48
         2vW742h4BlTbA==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 7F12835225DC; Thu, 14 Jan 2021 07:19:33 -0800 (PST)
Date:   Thu, 14 Jan 2021 07:19:33 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [RFC PATCH 6/8] sched: Report local wake up on resched blind
 zone within idle loop
Message-ID: <20210114151933.GH2743@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20210109020536.127953-1-frederic@kernel.org>
 <20210109020536.127953-7-frederic@kernel.org>
 <161062476680.19482.8402362019173198799@build.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161062476680.19482.8402362019173198799@build.alporthouse.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 14, 2021 at 11:46:06AM +0000, Chris Wilson wrote:
> Quoting Frederic Weisbecker (2021-01-09 02:05:34)
> > +void noinstr sched_resched_local_assert_allowed(void)
> > +{
> > +       if (this_rq()->resched_local_allow)
> > +               return;
> > +
> > +       /*
> > +        * Idle interrupts break the CPU from its pause and
> > +        * rescheduling happens on idle loop exit.
> > +        */
> > +       if (in_hardirq())
> > +               return;
> > +
> > +       /*
> > +        * What applies to hardirq also applies to softirq as
> > +        * we assume they execute on hardirq tail. Ksoftirqd
> > +        * shouldn't have resched_local_allow == 0.
> > +        * We also assume that no local_bh_enable() call may
> > +        * execute softirqs inline on fragile idle/entry
> > +        * path...
> > +        */
> > +       if (in_serving_softirq())
> > +               return;
> > +
> > +       WARN_ONCE(1, "Late current task rescheduling may be lost\n");
> > +}
> 
> This warn is impacting all suspend testing in linux-next:

Does the patch series here help?

https://lore.kernel.org/lkml/20210112144344.850850975@infradead.org/

And in Frederic's defense, his patch isn't causing the problem, but
rather calling attention to a condition that can lead to hangs.

							Thanx, Paul

> <4> [124.226839] Late current task rescheduling may be lost
> <4> [124.226847] WARNING: CPU: 0 PID: 0 at kernel/sched/core.c:628 sched_resched_local_assert_allowed+0x53/0x60
> <4> [124.226854] Modules linked in: vgem btusb btrtl btbcm btintel snd_hda_codec_hdmi bluetooth snd_hda_codec_realtek snd_hda_codec_generic coretemp ledtrig_audio crct10dif_pclmul crc32_pclmul ghash_clmulni_intel ecdh_generic ecc r8169 realtek i915 lpc_ich snd_hda_intel snd_intel_dspcfg snd_hda_codec snd_hwdep snd_hda_core snd_pcm pinctrl_cherryview prime_numbers
> <4> [124.226905] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.11.0-rc3-next-20210113-gaa515cdce7a15-next-20210113 #1
> <4> [124.226909] Hardware name:  /NUC5CPYB, BIOS PYBSWCEL.86A.0058.2016.1102.1842 11/02/2016
> <4> [124.226912] RIP: 0010:sched_resched_local_assert_allowed+0x53/0x60
> <4> [124.226918] Code: a9 00 00 0f 00 75 0e f6 c4 01 75 09 80 3d 55 42 d9 00 00 74 02 5b c3 48 c7 c7 68 0e 31 82 c6 05 43 42 d9 00 01 e8 9c 39 fb ff <0f> 0b 5b c3 cc cc cc cc cc cc cc cc cc 48 39 77 10 0f 84 97 00 00
> <4> [124.226922] RSP: 0018:ffffffff82603cf8 EFLAGS: 00010082
> <4> [124.226926] RAX: 0000000000000000 RBX: 000000000003b280 RCX: 0000000000000007
> <4> [124.226929] RDX: 0000000000000007 RSI: ffffffff8112d041 RDI: 00000000ffffffff
> <4> [124.226931] RBP: ffff888121b9a840 R08: 0000000000000000 R09: 0000000000000000
> <4> [124.226934] R10: 00000000ffff0c3c R11: 0000000000000001 R12: ffffffff82603d50
> <4> [124.226937] R13: ffff888121b9b0c8 R14: 0000000000000083 R15: ffff88817b83b280
> <4> [124.226940] FS:  0000000000000000(0000) GS:ffff88817b800000(0000) knlGS:0000000000000000
> <4> [124.226943] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> <4> [124.226946] CR2: 00005645075dd1b0 CR3: 0000000005612000 CR4: 00000000001006f0
> <4> [124.226949] Call Trace:
> <4> [124.226951]  check_preempt_curr+0x44/0x90
> <4> [124.226956]  ttwu_do_wakeup+0x14/0x220
> <4> [124.226961]  try_to_wake_up+0x1ef/0x7b0
> <4> [124.226966]  ? get_pwq.isra.21+0x2c/0x40
> <4> [124.226972]  __queue_work+0x180/0x610
> <4> [124.226977]  queue_work_on+0x65/0x70
> <4> [124.226981]  timekeeping_resume+0x150/0x1b0
> <4> [124.226986]  tick_unfreeze+0x3c/0x120
> <4> [124.226990]  cpuidle_enter_s2idle+0xec/0x180
> <4> [124.226995]  do_idle+0x1f3/0x2b0
> <4> [124.227000]  cpu_startup_entry+0x14/0x20
> <4> [124.227004]  start_kernel+0x551/0x576
> <4> [124.227009]  secondary_startup_64_no_verify+0xb0/0xbb
> <4> [124.227017] irq event stamp: 595206
> <4> [124.227019] hardirqs last  enabled at (595205): [<ffffffff81c00c42>] asm_sysvec_apic_timer_interrupt+0x12/0x20
> <4> [124.227024] hardirqs last disabled at (595206): [<ffffffff810ef1da>] do_idle+0xaa/0x2b0
> <4> [124.227028] softirqs last  enabled at (595182): [<ffffffff81e00342>] __do_softirq+0x342/0x48e
> <4> [124.227033] softirqs last disabled at (595171): [<ffffffff81c00f52>] asm_call_irq_on_stack+0x12/0x20
> <4> [124.227038] ---[ end trace 6fff00bd318698a4 ]---
> <4> [124.227050] 
> <4> [124.227052] ======================================================
> <4> [124.227054] WARNING: possible circular locking dependency detected
> <4> [124.227055] 5.11.0-rc3-next-20210113-gaa515cdce7a15-next-20210113 #1 Not tainted
> <4> [124.227056] ------------------------------------------------------
> <4> [124.227058] swapper/0/0 is trying to acquire lock:
> <4> [124.227059] ffffffff8272fdb8 ((console_sem).lock){-...}-{2:2}, at: down_trylock+0xa/0x30
> <4> [124.227063] 
> <4> [124.227064] but task is already holding lock:
> <4> [124.227065] ffff88817b83b298 (&rq->lock){-.-.}-{2:2}, at: try_to_wake_up+0x1c9/0x7b0
> <4> [124.227069] 
> <4> [124.227070] which lock already depends on the new lock.
> <4> [124.227071] 
> <4> [124.227072] 
> <4> [124.227073] the existing dependency chain (in reverse order) is:
> <4> [124.227074] 
> <4> [124.227074] -> #2 (&rq->lock){-.-.}-{2:2}:
> <4> [124.227078]        _raw_spin_lock+0x2a/0x40
> <4> [124.227079]        task_fork_fair+0x41/0x170
> <4> [124.227080]        sched_fork+0x13c/0x240
> <4> [124.227081]        copy_process+0x7aa/0x1c70
> <4> [124.227082]        kernel_clone+0x98/0x6f0
> <4> [124.227083]        kernel_thread+0x50/0x70
> <4> [124.227084]        rest_init+0x1d/0x231
> <4> [124.227084]        start_kernel+0x551/0x576
> <4> [124.227085]        secondary_startup_64_no_verify+0xb0/0xbb
> <4> [124.227086] 
> <4> [124.227087] -> #1 (&p->pi_lock){-.-.}-{2:2}:
> <4> [124.227091]        _raw_spin_lock_irqsave+0x33/0x50
> <4> [124.227092]        try_to_wake_up+0x5a/0x7b0
> <4> [124.227093]        up+0x3b/0x50
> <4> [124.227093]        __up_console_sem+0x29/0x60
> <4> [124.227094]        console_unlock+0x32f/0x580
> <4> [124.227095]        con_font_op+0x2af/0x360
> <4> [124.227096]        vt_ioctl+0x4f3/0x12b0
> <4> [124.227097]        tty_ioctl+0x23d/0x920
> <4> [124.227098]        __x64_sys_ioctl+0x6d/0xa0
> <4> [124.227099]        do_syscall_64+0x33/0x80
> <4> [124.227100]        entry_SYSCALL_64_after_hwframe+0x44/0xa9
> <4> [124.227101] 
> <4> [124.227101] -> #0 ((console_sem).lock){-...}-{2:2}:
> <4> [124.227105]        __lock_acquire+0x1502/0x2570
> <4> [124.227106]        lock_acquire+0xdc/0x3c0
> <4> [124.227107]        _raw_spin_lock_irqsave+0x33/0x50
> <4> [124.227108]        down_trylock+0xa/0x30
> <4> [124.227109]        __down_trylock_console_sem+0x23/0x90
> <4> [124.227110]        console_trylock+0xe/0x60
> <4> [124.227111]        vprintk_emit+0x135/0x340
> <4> [124.227112]        printk+0x53/0x6a
> <4> [124.227113]        __warn_printk+0x41/0x82
> <4> [124.227114]        sched_resched_local_assert_allowed+0x53/0x60
> <4> [124.227115]        check_preempt_curr+0x44/0x90
> <4> [124.227116]        ttwu_do_wakeup+0x14/0x220
> <4> [124.227117]        try_to_wake_up+0x1ef/0x7b0
> <4> [124.227117]        __queue_work+0x180/0x610
> <4> [124.227118]        queue_work_on+0x65/0x70
> <4> [124.227119]        timekeeping_resume+0x150/0x1b0
> <4> [124.227120]        tick_unfreeze+0x3c/0x120
> <4> [124.227121]        cpuidle_enter_s2idle+0xec/0x180
> <4> [124.227122]        do_idle+0x1f3/0x2b0
> <4> [124.227123]        cpu_startup_entry+0x14/0x20
> <4> [124.227124]        start_kernel+0x551/0x576
> <4> [124.227125]        secondary_startup_64_no_verify+0xb0/0xbb
> <4> [124.227126] 
> <4> [124.227127] other info that might help us debug this:
> <4> [124.227127] 
> <4> [124.227128] Chain exists of:
> <4> [124.227129]   (console_sem).lock --> &p->pi_lock --> &rq->lock
> <4> [124.227134] 
> <4> [124.227135]  Possible unsafe locking scenario:
> <4> [124.227136] 
> <4> [124.227136]        CPU0                    CPU1
> <4> [124.227137]        ----                    ----
> <4> [124.227138]   lock(&rq->lock);
> <4> [124.227140]                                lock(&p->pi_lock);
> <4> [124.227143]                                lock(&rq->lock);
> <4> [124.227145]   lock((console_sem).lock);
> <4> [124.227147] 
> <4> [124.227148]  *** DEADLOCK ***
> <4> [124.227149] 
> <4> [124.227149] 5 locks held by swapper/0/0:
> <4> [124.227150]  #0: ffffffff827370f8 (tick_freeze_lock){....}-{2:2}, at: tick_unfreeze+0xc/0x120
> <4> [124.227155]  #1: ffffffff82732360 (rcu_read_lock){....}-{1:2}, at: __queue_work+0x54/0x610
> <4> [124.227159]  #2: ffff88817b83aa98 (&pool->lock){-.-.}-{2:2}, at: __queue_work+0xe3/0x610
> <4> [124.227164]  #3: ffff888121b9b0e0 (&p->pi_lock){-.-.}-{2:2}, at: try_to_wake_up+0x5a/0x7b0
> <4> [124.227169]  #4: ffff88817b83b298 (&rq->lock){-.-.}-{2:2}, at: try_to_wake_up+0x1c9/0x7b0
> <4> [124.227173] 
> <4> [124.227174] stack backtrace:
> <4> [124.227175] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.11.0-rc3-next-20210113-gaa515cdce7a15-next-20210113 #1
> <4> [124.227177] Hardware name:  /NUC5CPYB, BIOS PYBSWCEL.86A.0058.2016.1102.1842 11/02/2016
> <4> [124.227178] Call Trace:
> <4> [124.227178]  dump_stack+0x77/0x97
> <4> [124.227179]  check_noncircular+0x12e/0x150
> <4> [124.227180]  __lock_acquire+0x1502/0x2570
> <4> [124.227181]  lock_acquire+0xdc/0x3c0
> <4> [124.227182]  ? down_trylock+0xa/0x30
> <4> [124.227183]  ? vprintk_store+0x36a/0x440
> <4> [124.227184]  ? vprintk_emit+0x135/0x340
> <4> [124.227185]  _raw_spin_lock_irqsave+0x33/0x50
> <4> [124.227185]  ? down_trylock+0xa/0x30
> <4> [124.227186]  down_trylock+0xa/0x30
> <4> [124.227187]  __down_trylock_console_sem+0x23/0x90
> <4> [124.227188]  console_trylock+0xe/0x60
> <4> [124.227189]  vprintk_emit+0x135/0x340
> <4> [124.227190]  printk+0x53/0x6a
> <4> [124.227191]  __warn_printk+0x41/0x82
> <4> [124.227191]  sched_resched_local_assert_allowed+0x53/0x60
> <4> [124.227192]  check_preempt_curr+0x44/0x90
> <4> [124.227193]  ttwu_do_wakeup+0x14/0x220
> <4> [124.227194]  try_to_wake_up+0x1ef/0x7b0
> <4> [124.227195]  ? get_pwq.isra.21+0x2c/0x40
> <4> [124.227196]  __queue_work+0x180/0x610
> <4> [124.227197]  queue_work_on+0x65/0x70
> <4> [124.227198]  timekeeping_resume+0x150/0x1b0
> <4> [124.227199]  tick_unfreeze+0x3c/0x120
> <4> [124.227199]  cpuidle_enter_s2idle+0xec/0x180
> <4> [124.227200]  do_idle+0x1f3/0x2b0
> <4> [124.227201]  cpu_startup_entry+0x14/0x20
> <4> [124.227202]  start_kernel+0x551/0x576
> <4> [124.227203]  secondary_startup_64_no_verify+0xb0/0xbb
