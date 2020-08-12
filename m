Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B65242ED6
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 21:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgHLTBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 15:01:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgHLTBD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Aug 2020 15:01:03 -0400
Received: from paulmck-ThinkPad-P72.home (unknown [50.45.173.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2D0120781;
        Wed, 12 Aug 2020 19:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597258862;
        bh=Lyp6UJJuG/8lZ1akf0m3/bkg8Lo0dmkVxOXoHpckVtk=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=p2wByT2hjS3n5m9FNFn5UO79ntxtiIySENKTMv3UiLF42ono2E36CZCOST6ENiHHu
         7u/FZdwqqOMr8pCTSAKzt+XvDq8qs7TNVS3LE5z+lj6gNUDdoMJN+fMfyCoraUw1Cl
         +DqCyQEsyYjGwelaU24H+ajsnppS2Vy3Dvuzum24=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 936D43522615; Wed, 12 Aug 2020 12:01:02 -0700 (PDT)
Date:   Wed, 12 Aug 2020 12:01:02 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, rcu@vger.kernel.org,
        linux- stable <stable@vger.kernel.org>, srostedt@redhat.com,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
        lkft-triage@lists.linaro.org, Basil Eljuse <Basil.Eljuse@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john.fastabend@gmail.com, jakub@cloudflare.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: WARNING: kernel/rcu/tree.c:618 rcu_eqs_enter.isra.67+0xd8
Message-ID: <20200812190102.GI4295@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <CA+G9fYt9J3tzYjVMq2Z-i8+j3qHTNVX8zwVOJrzRbiJmei7OHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYt9J3tzYjVMq2Z-i8+j3qHTNVX8zwVOJrzRbiJmei7OHw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 12, 2020 at 09:43:35PM +0530, Naresh Kamboju wrote:
> While running kselftests bpf test_verifier on arm64 juno-r2 device
> the kernel BUG and WARNING noticed.
> 
> metadata:
>   git branch: linux-5.8.y
>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>   git commit: b30c8c9d42601af8ebeb3ad42085ff4134a111a0

I don't see this commit in -stable.  Where should I be looking?

git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git

>   git describe: v5.8-39-gb30c8c9d4260
>   make_kernelversion: 5.8.1-rc1
>   kernel-config:
> http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/juno/lkft/linux-stable-rc-5.8/3/config
> 
> [  102.671323]  bpf_prog_test_run_xdp+0xf4/0x1b0
> [  102.675688]  __do_sys_bpf+0x708/0x1d18
> [  102.679442]  __arm64_sys_bpf+0x28/0x38
> [  102.683197]  el0_svc_common.constprop.3+0x7c/0x198
> [  102.687995]  do_el0_svc+0x34/0xa0
> [  102.691315]  el0_sync_handler+0x16c/0x210
> [  102.695329]  el0_sync+0x140/0x180
> [  102.698651] Code: d4202000 d4202000 d4202000 d4202000 (d4202000)
> [  102.704758] ---[ end trace 14c3fdd625b93f51 ]---

Whatever error prompted this last stack trace needs attention.

> [  102.709383] note: test_verifier[740] exited with preempt_count 2

Looks like there is a preempt_disable() that is lacking the
corresponding preempt_disable() on some code path.

Could you please try to bisect this?

> [  102.715399] BUG: sleeping function called from invalid context at
> /usr/src/kernel/include/linux/percpu-rwsem.h:49
> [  102.725680] in_atomic(): 0, irqs_disabled(): 128, non_block: 0,

As the "BUG:" message says...

> pid: 740, name: test_verifier
> [  102.734219] INFO: lockdep is turned off.
> [  102.738146] irq event stamp: 4369860
> [  102.741729] hardirqs last  enabled at (4369859):
> [<ffff80001015ab18>] ktime_get+0xc0/0x178
> [  102.750010] hardirqs last disabled at (4369860):
> [<ffff800010029a04>] debug_exception_enter+0xac/0xe8
> [  102.759249] softirqs last  enabled at (4369842):
> [<ffff8000102161d4>] bpf_ksym_add+0x12c/0x148
> [  102.767878] softirqs last disabled at (4369840):
> [<ffff8000102160d4>] bpf_ksym_add+0x2c/0x148
> [  102.776419] CPU: 2 PID: 740 Comm: test_verifier Tainted: G      D W
>         5.8.1-rc1 #1
> [  102.784523] Hardware name: ARM Juno development board (r2) (DT)
> [  102.790451] Call trace:
> [  102.792900]  dump_backtrace+0x0/0x1f8
> [  102.796567]  show_stack+0x2c/0x38
> [  102.799889]  dump_stack+0xf0/0x16c
> [  102.803296]  ___might_sleep+0x144/0x208
> [  102.807137]  __might_sleep+0x54/0x90
> [  102.810719]  exit_signals+0x54/0x3e8
> [  102.814301]  do_exit+0xc8/0xae0
> [  102.817446]  die+0x200/0x268
> [  102.820329]  arm64_notify_die+0xa0/0xc0
> [  102.824172]  do_debug_exception+0xf0/0x128
> [  102.828275]  el1_sync_handler+0x90/0xf0
> [  102.832116]  el1_sync+0x7c/0x100
> [  102.835347]  0xffff8000000129b8
> [  102.838493]  bpf_prog_d53bb52e3f4483f9_F+0x38/0x8d0
> [  102.843379]  bpf_dispatcher_xdp_func+0x30/0x40
> [  102.847830]  bpf_test_run+0x180/0x570
> [  102.851497]  bpf_prog_test_run_xdp+0xf4/0x1b0
> [  102.855861]  __do_sys_bpf+0x708/0x1d18
> [  102.859615]  __arm64_sys_bpf+0x28/0x38
> [  102.863369]  el0_svc_common.constprop.3+0x7c/0x198
> [  102.868167]  do_el0_svc+0x34/0xa0
> [  102.871486]  el0_sync_handler+0x16c/0x210
> [  102.875501]  el0_sync+0x140/0x180
> [  102.886823] ------------[ cut here ]------------
> [  102.887376] kauditd_printk_skb: 125 callbacks suppressed
> [  102.887387] audit: type=1701 audit(1597081698.472:1942):
> auid=4294967295 uid=0 gid=0 ses=4294967295 pid=738 comm=\"timeout\"
> exe=\"/usr/bin/timeout.coreutils\" sig=11 res=1
> 
> [  102.891463] WARNING: CPU: 2 PID: 0 at
> /usr/src/kernel/kernel/rcu/tree.c:618 rcu_eqs_enter.isra.67+0xd8/0xe0

If the line number matches -stable v5.8.1, this could be due
to exception-handler entry/exit updates of RCU state not being
set up properly.  For example, if some system-call-like entry from
userspace failed to call rcu_user_exit() in a kernel built with context
tracking, though there are many ways to make this sort of error appear.
Historically, the most common cause has been a missing rcu_irq_enter()
or rcu_irq_exit() call one one of the exception paths.

It is of course quite possible that this error is a consequence of
earlier errors, so I would suggest focusing first on fixing the
earlier errors.

						Thanx, Paul

> [  102.891467] Modules linked in: rfkill tda998x cec drm_kms_helper
> drm crct10dif_ce fuse
> [  102.891486] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D W
>   5.8.1-rc1 #1
> [  102.891490] Hardware name: ARM Juno development board (r2) (DT)
> [  102.891495] pstate: 200003c5 (nzCv DAIF -PAN -UAO BTYPE=--)
> [  102.891501] pc : rcu_eqs_enter.isra.67+0xd8/0xe0
> [  102.891511] lr : rcu_eqs_enter.isra.67+0x10/0xe0
> [  102.957881] sp : ffff800013683f20
> [  102.961198] x29: ffff800013683f20 x28: 0000000000000000
> [  102.966519] x27: 0000000000000000 x26: ffff000973033800
> [  102.971840] x25: ffff00097ef5fc80 x24: ffff800012651410
> [  102.977162] x23: ffff800011f00c78 x22: ffff800012650000
> [  102.982483] x21: ffff800012651000 x20: ffff800011f02000
> [  102.987803] x19: ffff00097ef61ec0 x18: ffffffffffffffff
> [  102.993124] x17: 0000000000000000 x16: 0000000000000000
> [  102.998444] x15: 000000000000006c x14: 000000000000002a
> [  103.003765] x13: 0000000000000002 x12: 0000000000000000
> [  103.009086] x11: 0000000000000000 x10: ffff80001264b1c8
> [  103.014406] x9 : 0000000000000000 x8 : ffff800012650a88
> [  103.019727] x7 : ffff80001016d09c x6 : 0000000000000000
> [  103.025048] x5 : 0000000000000000 x4 : 0000000000000000
> [  103.030368] x3 : ffff800012650a88 x2 : 00000017f0129f00
> [  103.035689] x1 : 4000000000000002 x0 : 4000000000000000
> [  103.041011] Call trace:
> [  103.043461]  rcu_eqs_enter.isra.67+0xd8/0xe0
> [  103.047739]  rcu_idle_enter+0x44/0x70
> [  103.051406]  do_idle+0x214/0x2c0
> [  103.054637]  cpu_startup_entry+0x2c/0x70
> [  103.058567]  secondary_start_kernel+0x1a8/0x200
> [  103.063103] irq event stamp: 449856
> [  103.066599] hardirqs last  enabled at (449855):
> [<ffff80001016d1ec>] tick_nohz_idle_exit+0x64/0xd0
> [  103.075574] hardirqs last disabled at (449856):
> [<ffff800011329c08>] __schedule+0xf0/0x8f0
> [  103.083853] softirqs last  enabled at (449814):
> [<ffff8000100019bc>] __do_softirq+0x59c/0x5dc
> [  103.092396] softirqs last disabled at (449803):
> [<ffff80001008fbf4>] irq_exit+0x144/0x150
> 
> 
> Full output log:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-5.8-oe/build/v5.8-39-gb30c8c9d4260/testrun/3049360/suite/linux-log-parser/test/check-kernel-exception-1657446/log
> 
> --
> Linaro LKFT
> https://lkft.linaro.org
