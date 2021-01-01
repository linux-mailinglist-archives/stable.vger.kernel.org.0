Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFCE92E8423
	for <lists+stable@lfdr.de>; Fri,  1 Jan 2021 17:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbhAAQFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jan 2021 11:05:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:59588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727181AbhAAQFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Jan 2021 11:05:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0A2A221F2;
        Fri,  1 Jan 2021 16:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609517111;
        bh=PE3Yh5iJRE9h1nZoPLqiutJok5vYke190iIOLG7X7JY=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=smzN+TWH0xTcFRu0ewdMy89ASPghCXoGhbFTNMW3QrrcCgnXFy0K1CGFQVnJWVJz8
         AYy2ZkLwahZYR3TFh7q6uLqEQRFQWW7W+4a4wq/dn1zr7Axmh3MxKFaeyJkDReQU38
         +AEi+uhS47amfn6ver5SFXNLtnVVhcEsKwgvkIVkbt8pn90l6KFmO6n8W7/xLkflNH
         C7dj9rF87JWMKckuSjr9XgPBDk9IvVanz8oqDq6Nj2+NwoFv+J5eTSJln38tQMFA1w
         ijrbRdIc4RbYtjVCryK3BZR/+IGi1iAfTlgp6G51o+5Ph8cSiijHnEwLTtHGTbPmi3
         O3LVFeKk0rgjw==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 6ED513522781; Fri,  1 Jan 2021 08:05:11 -0800 (PST)
Date:   Fri, 1 Jan 2021 08:05:11 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <lenb@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Linux PM <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 0/4] sched/idle: Fix missing need_resched() checks after
 rcu_idle_enter()
Message-ID: <20210101160511.GB12032@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20201222013712.15056-1-frederic@kernel.org>
 <4de33f1a-890b-4d29-20e8-a1163b9c1bf7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4de33f1a-890b-4d29-20e8-a1163b9c1bf7@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 22, 2020 at 05:19:51PM +0100, Rafael J. Wysocki wrote:
> On 12/22/2020 2:37 AM, Frederic Weisbecker wrote:
> > With Paul, we've been thinking that the idle loop wasn't twisted enough
> > yet to deserve 2020.
> > 
> > rcutorture, after some recent parameter changes, has been complaining
> > about a hung task.
> > 
> > It appears that rcu_idle_enter() may wake up a NOCB kthread but this
> > happens after the last generic need_resched() check. Some cpuidle drivers
> > fix it by chance but many others don't.
> > 
> > Here is a proposed bunch of fixes. I will need to also fix the
> > rcu_user_enter() case, likely using irq_work, since nohz_full requires
> > irq work to support self IPI.
> > 
> > Also more generally, this raise the question of local task wake_up()
> > under disabled interrupts. When a wake up occurs in a preempt disabled
> > section, it gets handled by the outer preempt_enable() call. There is no
> > similar mechanism when a wake up occurs with interrupts disabled. I guess
> > it is assumed to be handled, at worst, in the next tick. But a local irq
> > work would provide instant preemption once IRQs are re-enabled. Of course
> > this would only make sense in CONFIG_PREEMPTION, and when the tick is
> > disabled...
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> > 	sched/idle
> > 
> > HEAD: f2fa6e4a070c1535b9edc9ee097167fd2b15d235
> > 
> > Thanks,
> > 	Frederic
> > ---
> > 
> > Frederic Weisbecker (4):
> >        sched/idle: Fix missing need_resched() check after rcu_idle_enter()
> >        cpuidle: Fix missing need_resched() check after rcu_idle_enter()
> >        ARM: imx6q: Fix missing need_resched() check after rcu_idle_enter()
> >        ACPI: processor: Fix missing need_resched() check after rcu_idle_enter()
> > 
> > 
> >   arch/arm/mach-imx/cpuidle-imx6q.c |  7 ++++++-
> >   drivers/acpi/processor_idle.c     | 10 ++++++++--
> >   drivers/cpuidle/cpuidle.c         | 33 +++++++++++++++++++++++++--------
> >   kernel/sched/idle.c               | 18 ++++++++++++------
> >   4 files changed, 51 insertions(+), 17 deletions(-)
> 
> Please feel free to add
> 
> Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> to all patches in the series.

I would guess that they will take some other path to mainline, but I have
queued these to cut down on rcutorture's whining.  ;-)

							Thanx, Paul
