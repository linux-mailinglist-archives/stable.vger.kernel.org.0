Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4324765C6D7
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 20:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238542AbjACTAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 14:00:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238480AbjACTAB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 14:00:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3867C12AB4;
        Tue,  3 Jan 2023 11:00:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C99CB614D8;
        Tue,  3 Jan 2023 18:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4D6C433EF;
        Tue,  3 Jan 2023 18:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672772399;
        bh=Bcl97MvZxGp2cIxCgvKWYeouxf8nNhFpHCLxoHRZfBE=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=IToNTq4FSX/qGvRYaeLOSFjfSgE2xjFloWVTnJPQQ4uzOUJ0vW8cc8GgOlFkrpIxn
         YeQC20Spclj7DG4lsMHbFTESwZZMjKkppobTMXaK9rPoye4M9yWYADI1bBdocuqrGQ
         eFnDdqo1kZSYQwKLIV6qzJNO2NQ7d26fXgEwRXlUY4QOo9Iaiy0xKRetOVzJvtcFwK
         yZKI0waBcc9JMpY8QM4vJkMRbZMINjwsEy4Y3XDImMt+/qIFFD12MXMy1eOVPQ4V50
         4EIwvR1b0su/elxQtVO6mwEIHIE/3xwfC4XFT7sK3Jo7XI2ucoFVfkSVYvZoY/utsd
         MSdQAqgMy7uxQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id D18E15C04EE; Tue,  3 Jan 2023 10:59:58 -0800 (PST)
Date:   Tue, 3 Jan 2023 10:59:58 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Davidlohr Bueso <dave@stgolabs.net>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Zhouyi Zhou <zhouzhouyi@gmail.com>, stable@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>, rcu@vger.kernel.org
Subject: Re: [PATCH] torture: Fix hang during kthread shutdown phase
Message-ID: <20230103185958.GB4028633@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230101061555.278129-1-joel@joelfernandes.org>
 <20230102164310.2olg7xhwwhzmzg24@offworld>
 <20230103180404.GA4028633@paulmck-ThinkPad-P17-Gen-1>
 <Y7Ry1yTT/mltqSUI@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y7Ry1yTT/mltqSUI@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,WEIRD_PORT autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 03, 2023 at 06:24:23PM +0000, Joel Fernandes wrote:
> On Tue, Jan 03, 2023 at 10:04:04AM -0800, Paul E. McKenney wrote:
> > On Mon, Jan 02, 2023 at 08:43:10AM -0800, Davidlohr Bueso wrote:
> > > On Sun, 01 Jan 2023, Joel Fernandes (Google) wrote:
> > > 
> > > > During shutdown of rcutorture, the shutdown thread in
> > > > rcu_torture_cleanup() calls torture_cleanup_begin() which sets fullstop
> > > > to FULLSTOP_RMMOD. This is enough to cause the rcutorture threads for
> > > > readers and fakewriters to breakout of their main while loop and start
> > > > shutting down.
> > > > 
> > > > Once out of their main loop, they then call torture_kthread_stopping()
> > > > which in turn waits for kthread_stop() to be called, however
> > > > rcu_torture_cleanup() has not even called kthread_stop() on those
> > > > threads yet, it does that a bit later.  However, before it gets a chance
> > > > to do so, torture_kthread_stopping() calls
> > > > schedule_timeout_interruptible(1) in a tight loop. Tracing confirmed
> > > > this makes the timer softirq constantly execute timer callbacks, while
> > > > never returning back to the softirq exit path and is essentially "locked
> > > > up" because of that. If the softirq preempts the shutdown thread,
> > > > kthread_stop() may never be called.
> > > > 
> > > > This commit improves the situation dramatically, by increasing timeout
> > > > passed to schedule_timeout_interruptible() 1/20th of a second. This
> > > > causes the timer softirq to not lock up a CPU and everything works fine.
> > > > Testing has shown 100 runs of TREE07 passing reliably, which was not the
> > > > case before because of RCU stalls.
> > > > 
> > > > Cc: Paul McKenney <paulmck@kernel.org>
> > > > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > > > Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>
> > > > Cc: <stable@vger.kernel.org> # 6.0.x
> > > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > > 
> > > Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
> > 
> > Queued for further review and testing, thank you all!
> > 
> > One thing still puzzles me.  Assuming HZ=1000 and given 16 CPUs, each
> > timer hander must have consumed many tens of microseconds in order
> > to keep the system busy, which seems a bit longer than it should be.
> > Or am I underestimating the number of tasks involved?
> 
> Here are the traces between successive calls to process_timeout() which is the timer callback handler:
> 
> [ 1320.444210]   <idle>-0         0dNs.. 314229620us : __run_timers: Calling timerfn 5: process_timeout
> [ 1320.444215]   <idle>-0         0dNs.. 314229620us : sched_waking: comm=rcu_torture_fak pid=145 prio=139 target_cpu=008
> [ 1320.463393]   <idle>-0         7d.... 314229655us : sched_switch: prev_comm=swapper/7 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=rcu_torture_wri next_pid=144 next_prio=120
> [ 1320.478870] rcu_tort-144       7d.... 314229658us : sched_switch: prev_comm=rcu_torture_wri prev_pid=144 prev_prio=120 prev_state=D ==> next_comm=swapper/7 next_pid=0 next_prio=120
> [ 1320.494324]   <idle>-0         0dNs.. 314229738us : __run_timers: Calling timerfn 6: process_timeout
> 
> It appears the time delta in the above occurrence is 118 micro seconds
> between 2 timer callbacks. It does appear to be doing a cross-CPU wake up.
> Maybe that adds to the long time?
> 
> Here are the full logs with traces (in case it helps, search for "=D" for the
> D-state sched_switch event before the "panic now" trace happens):
> http://box.joelfernandes.org:9080/job/rcutorture_stable/job/linux-6.0.y/26/artifact/tools/testing/selftests/rcutorture/res/2022.12.31-23.04.42/TREE07.2/console.log

118 microseconds would do it!

Still seems excessive to me, but what do I know?

							Thanx, Paul
