Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4C42CD4BC
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 12:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388005AbgLCLkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 06:40:09 -0500
Received: from foss.arm.com ([217.140.110.172]:37910 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbgLCLkG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 06:40:06 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C6BA6113E;
        Thu,  3 Dec 2020 03:39:20 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.0.87])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 591AB3F66B;
        Thu,  3 Dec 2020 03:39:18 -0800 (PST)
Date:   Thu, 3 Dec 2020 11:39:15 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Boqun Feng <boqun.feng@gmail.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux-stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, rcu@vger.kernel.org,
        lkft-triage@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [arm64] db410c: BUG: Invalid wait context
Message-ID: <20201203113915.GE96754@C02TD0UTHF1T.local>
References: <CA+G9fYupbQK02Yor=U-80JEdkwacZ7bi3RKt3+D=e+qZ-o0uCA@mail.gmail.com>
 <20201203014922.GA1785576@boqun-archlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203014922.GA1785576@boqun-archlinux>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Naresh, Boqun,

On Thu, Dec 03, 2020 at 09:49:22AM +0800, Boqun Feng wrote:
> On Wed, Dec 02, 2020 at 10:15:44AM +0530, Naresh Kamboju wrote:
> > While running kselftests on arm64 db410c platform "BUG: Invalid wait context"
> > noticed at different runs this specific platform running stable-rc 5.9.12-rc1.
> > 
> > While running these two test cases we have noticed this BUG and not easily
> > reproducible.
> > 
> > # selftests: bpf: test_xdp_redirect.sh
> > # selftests: net: ip6_gre_headroom.sh
> > 
> > [  245.694901] kauditd_printk_skb: 100 callbacks suppressed
> > [  245.694913] audit: type=1334 audit(251.699:25757): prog-id=12883 op=LOAD
> > [  245.735658] audit: type=1334 audit(251.743:25758): prog-id=12884 op=LOAD
> > [  245.801299] audit: type=1334 audit(251.807:25759): prog-id=12885 op=LOAD
> > [  245.832034] audit: type=1334 audit(251.839:25760): prog-id=12886 op=LOAD
> > [  245.888601]
> > [  245.888631] =============================
> > [  245.889156] [ BUG: Invalid wait context ]
> > [  245.893071] 5.9.12-rc1 #1 Tainted: G        W
> > [  245.897056] -----------------------------
> > [  245.902091] pool/1279 is trying to lock:
> > [  245.906083] ffff000032fc1218
> > (&child->perf_event_mutex){+.+.}-{3:3}, at:
> > perf_event_exit_task+0x34/0x3a8
> > [  245.910085] other info that might help us debug this:
> > [  245.919539] context-{4:4}
> > [  245.924484] 1 lock held by pool/1279:
> > [  245.927087]  #0: ffff8000127819b8 (rcu_read_lock){....}-{1:2}, at:
> > dput+0x54/0x460
> > [  245.930739] stack backtrace:
> > [  245.938203] CPU: 1 PID: 1279 Comm: pool Tainted: G        W
> > 5.9.12-rc1 #1
> > [  245.941243] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
> > [  245.948621] Call trace:
> > [  245.955390]  dump_backtrace+0x0/0x1f8
> > [  245.957560]  show_stack+0x2c/0x38
> > [  245.961382]  dump_stack+0xec/0x158
> > [  245.964679]  __lock_acquire+0x59c/0x15c8
> > [  245.967978]  lock_acquire+0x124/0x4d0
> > [  245.972058]  __mutex_lock+0xa4/0x970
> > [  245.975615]  mutex_lock_nested+0x54/0x70
> > [  245.979261]  perf_event_exit_task+0x34/0x3a8
> > [  245.983168]  do_exit+0x394/0xad8
> > [  245.987420]  do_group_exit+0x4c/0xa8
> > [  245.990633]  get_signal+0x16c/0xb40
> > [  245.994193]  do_notify_resume+0x2ec/0x678
> > [  245.997404]  work_pending+0x8/0x200
> > 
> 
> For the PoV of lockdep, this means some one tries to acquire a mutex
> inside an RCU read-side critical section, which is bad, because one can
> not sleep (voluntarily) inside RCU.
> 
> However I don't think it's the true case here, because 1) normally
> people are very careful not putting mutex or other sleepable locks
> inside RCU and 2) in the above splats, lockdep find the rcu read lock is
> held at dput() while the acquiring of the mutex is at ret_to_user(),
> clearly there is no call site (in the same context) from the RCU
> read-side critial section of dput() to ret_to_user().
> 
> One chance of hitting this is that there is a bug in context/irq tracing
> that makes the contexts of dput() and ret_to_user() as one contexts so
> that lockdep gets confused and reports a false postive.

That sounds likely to me (but I haven't looked too deeply at the above
report).

> FWIW, I think this might be related to some know issues for ARM64 with
> lockdep and irq tracing:
> 
> 	https://lore.kernel.org/lkml/20201119225352.GA5251@willie-the-truck/
> 
> And Mark already has series to fix them:
> 
> 	https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=arm64/irq-fixes
> 
> But I must defer to Mark for the latest fix ;-)

That went into mainline a few hours ago, and will be part of v5.10-rc7.

So if it's possible to test with mainline, that would be helpful!

Thanks,
Mark.
