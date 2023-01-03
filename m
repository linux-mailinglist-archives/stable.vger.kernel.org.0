Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C0465C7BE
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 20:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjACTv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 14:51:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbjACTvy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 14:51:54 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9060E12D26
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 11:51:52 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id f20so33114630lja.4
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 11:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jLl/VBpTeAUex90BhERl8MGE6mygiDh6d8Zf8SUBHPU=;
        b=KDMaHJXANJpPoCFDrxBW4CxJPTb1ijSzp0nrjDks6+905S5frx0CrBENdGluzq6QWT
         naIFLbRDdpWQHpj8UWPMCrAj+2/Sal5qICq+EocHyd0TxHAUBS/qi54Un19mCp7Vym1k
         eq7tbs8YOzQwDXvAt4xL1PEEAGJXZr0tVTReU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jLl/VBpTeAUex90BhERl8MGE6mygiDh6d8Zf8SUBHPU=;
        b=winNQPd/Bl6WvDkwzAK3/6gonjG9yr47PlNsW7SxpuY6u5TJmGhrXRDqXqxUKmoRkU
         M1c/sI5i7GsUZsF9u1KblikbmNxP18Lp0lrzxbIsxJ2oZ2B855t9QgAo4e+NkwAFK35b
         Ie7sHZeJW9x13fJHFXG5x3ISgRgqiwMpSPxAvlT86r94TYg2C83PQmvqweWj3zwozElA
         eeAPaWy8qKH8B2yB9e01VZfVX3f3dGq2FevcKoTds7nzHcZI9PO3AxXl1VDZh5rOQDTV
         Gmj+CX6ySDTVGF9dzygDHNaPOAeWq0MO/Hqvv8fz0e2RDX/mDd7wTdZtWSXp5DDqjS/+
         jIIw==
X-Gm-Message-State: AFqh2kqN24fDMqhkvRxI3q+yMvrTDBgqNhmiKpD5mCSsSizSszk04Kqx
        TpzEqJr96a+tNJCI3kmY02VyQSjswpC/0Kzj4tlGsQ==
X-Google-Smtp-Source: AMrXdXtR2aN9oMyc5niWecpovOi01R6wJz6os+F4PQBl/sFdc0exT9zbFH9GrrJksjcJa68duB7B3Vydeu54pIHClIE=
X-Received: by 2002:a2e:3215:0:b0:27f:b98c:7a0e with SMTP id
 y21-20020a2e3215000000b0027fb98c7a0emr2682588ljy.356.1672775510916; Tue, 03
 Jan 2023 11:51:50 -0800 (PST)
MIME-Version: 1.0
References: <20230101061555.278129-1-joel@joelfernandes.org>
 <20230102164310.2olg7xhwwhzmzg24@offworld> <20230103180404.GA4028633@paulmck-ThinkPad-P17-Gen-1>
 <Y7Ry1yTT/mltqSUI@google.com> <20230103185958.GB4028633@paulmck-ThinkPad-P17-Gen-1>
In-Reply-To: <20230103185958.GB4028633@paulmck-ThinkPad-P17-Gen-1>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Tue, 3 Jan 2023 19:51:39 +0000
Message-ID: <CAEXW_YTSh-QLzbBf_JK4-X8MoAvbNzOdfeOPsXk6MhT+Dk8uTg@mail.gmail.com>
Subject: Re: [PATCH] torture: Fix hang during kthread shutdown phase
To:     paulmck@kernel.org
Cc:     Davidlohr Bueso <dave@stgolabs.net>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Zhouyi Zhou <zhouzhouyi@gmail.com>, stable@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,WEIRD_PORT autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 3, 2023 at 7:00 PM Paul E. McKenney <paulmck@kernel.org> wrote:
>
> On Tue, Jan 03, 2023 at 06:24:23PM +0000, Joel Fernandes wrote:
> > On Tue, Jan 03, 2023 at 10:04:04AM -0800, Paul E. McKenney wrote:
> > > On Mon, Jan 02, 2023 at 08:43:10AM -0800, Davidlohr Bueso wrote:
> > > > On Sun, 01 Jan 2023, Joel Fernandes (Google) wrote:
> > > >
> > > > > During shutdown of rcutorture, the shutdown thread in
> > > > > rcu_torture_cleanup() calls torture_cleanup_begin() which sets fullstop
> > > > > to FULLSTOP_RMMOD. This is enough to cause the rcutorture threads for
> > > > > readers and fakewriters to breakout of their main while loop and start
> > > > > shutting down.
> > > > >
> > > > > Once out of their main loop, they then call torture_kthread_stopping()
> > > > > which in turn waits for kthread_stop() to be called, however
> > > > > rcu_torture_cleanup() has not even called kthread_stop() on those
> > > > > threads yet, it does that a bit later.  However, before it gets a chance
> > > > > to do so, torture_kthread_stopping() calls
> > > > > schedule_timeout_interruptible(1) in a tight loop. Tracing confirmed
> > > > > this makes the timer softirq constantly execute timer callbacks, while
> > > > > never returning back to the softirq exit path and is essentially "locked
> > > > > up" because of that. If the softirq preempts the shutdown thread,
> > > > > kthread_stop() may never be called.
> > > > >
> > > > > This commit improves the situation dramatically, by increasing timeout
> > > > > passed to schedule_timeout_interruptible() 1/20th of a second. This
> > > > > causes the timer softirq to not lock up a CPU and everything works fine.
> > > > > Testing has shown 100 runs of TREE07 passing reliably, which was not the
> > > > > case before because of RCU stalls.
> > > > >
> > > > > Cc: Paul McKenney <paulmck@kernel.org>
> > > > > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > > > > Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>
> > > > > Cc: <stable@vger.kernel.org> # 6.0.x
> > > > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > > >
> > > > Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
> > >
> > > Queued for further review and testing, thank you all!
> > >
> > > One thing still puzzles me.  Assuming HZ=1000 and given 16 CPUs, each
> > > timer hander must have consumed many tens of microseconds in order
> > > to keep the system busy, which seems a bit longer than it should be.
> > > Or am I underestimating the number of tasks involved?
> >
> > Here are the traces between successive calls to process_timeout() which is the timer callback handler:
> >
> > [ 1320.444210]   <idle>-0         0dNs.. 314229620us : __run_timers: Calling timerfn 5: process_timeout
> > [ 1320.444215]   <idle>-0         0dNs.. 314229620us : sched_waking: comm=rcu_torture_fak pid=145 prio=139 target_cpu=008
> > [ 1320.463393]   <idle>-0         7d.... 314229655us : sched_switch: prev_comm=swapper/7 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=rcu_torture_wri next_pid=144 next_prio=120
> > [ 1320.478870] rcu_tort-144       7d.... 314229658us : sched_switch: prev_comm=rcu_torture_wri prev_pid=144 prev_prio=120 prev_state=D ==> next_comm=swapper/7 next_pid=0 next_prio=120
> > [ 1320.494324]   <idle>-0         0dNs.. 314229738us : __run_timers: Calling timerfn 6: process_timeout
> >
> > It appears the time delta in the above occurrence is 118 micro seconds
> > between 2 timer callbacks. It does appear to be doing a cross-CPU wake up.
> > Maybe that adds to the long time?
> >
> > Here are the full logs with traces (in case it helps, search for "=D" for the
> > D-state sched_switch event before the "panic now" trace happens):
> > http://box.joelfernandes.org:9080/job/rcutorture_stable/job/linux-6.0.y/26/artifact/tools/testing/selftests/rcutorture/res/2022.12.31-23.04.42/TREE07.2/console.log
>
> 118 microseconds would do it!
>
> Still seems excessive to me

True, also my machine is a bit slow so maybe it took more CPU cycles
than usual. Still if it happened to me and Zhouyi, it could happen to
anyone ;-)

thanks,

 - Joel
