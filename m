Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7574565C60C
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 19:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbjACSYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 13:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238823AbjACSY0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 13:24:26 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F7B13D34
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 10:24:25 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id j16so25199721qtv.4
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 10:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gyzUkUkRXrWbqnLogkn/YRgVffpdv0ujzVAsh7a/y2U=;
        b=PeHOAO+KzAkwqiZ5CIjYlPexV4+nLZ+6gAwssCwloHRSHxpFDT34fBE7TkPvC2+Zjm
         T5XFy06pckwsXDQ12aOxAR2xOZAAFXCxFa9lEeFtPvnzrnVJe2yVd/gRHmbnCvJ8Gs2q
         n5ePob1ghM++0Gd6+hwa73lRqWY+rsP3+Ptb4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gyzUkUkRXrWbqnLogkn/YRgVffpdv0ujzVAsh7a/y2U=;
        b=Bejzl7dg3Mm/FBcmPT/s0afK1DlZP9VVsYCNyy9pBjXUb3nkqKBn8b9hz7jZv7d9rX
         rB/i/sAoEKIahCIF6bAd+YvxTBAUcsc3zvV7arLF+F6U/8rcx1+mpueqLhpz9+ajabFZ
         FEkfuZQe5HbYMN1owLVX068uKTXeN/ZX+cdk9povF6RDQsnsXQFSGBQBfWdiBM0Ifkzt
         LA+kWIjiWYli4OPrCW21nZOCnBip9M47MRzJjI5PEHv/YhX0tdCiduBWmmxHniB+kpLj
         EAb+zWb7O4ctLvL0dFyak1dnT7R2ZgBwUXrLhzcQ5ryWwGGw19KPfoMUvEnHX2gCalvL
         vkRA==
X-Gm-Message-State: AFqh2ko98T1iPgxtzh2Z6NKnM1f6PGp1QqYLs8xbRqG8zALOwm/yX5xu
        +nXAeqHiGix54xpMXaxZCh03rvLii4qoCYOj
X-Google-Smtp-Source: AMrXdXul9oA+pYoIrGwSof8bvXuSYPQIF8PvW/t01f3pc3Rc3QgzAMbTE3o+cWaad98PHcO+FNiRFA==
X-Received: by 2002:ac8:534c:0:b0:3a9:8183:6a04 with SMTP id d12-20020ac8534c000000b003a981836a04mr72845793qto.54.1672770264535;
        Tue, 03 Jan 2023 10:24:24 -0800 (PST)
Received: from localhost (228.221.150.34.bc.googleusercontent.com. [34.150.221.228])
        by smtp.gmail.com with ESMTPSA id u2-20020ac80502000000b003a81eef14efsm19111867qtg.45.2023.01.03.10.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 10:24:23 -0800 (PST)
Date:   Tue, 3 Jan 2023 18:24:23 +0000
From:   Joel Fernandes <joel@joelfernandes.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Davidlohr Bueso <dave@stgolabs.net>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Zhouyi Zhou <zhouzhouyi@gmail.com>, stable@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>, rcu@vger.kernel.org
Subject: Re: [PATCH] torture: Fix hang during kthread shutdown phase
Message-ID: <Y7Ry1yTT/mltqSUI@google.com>
References: <20230101061555.278129-1-joel@joelfernandes.org>
 <20230102164310.2olg7xhwwhzmzg24@offworld>
 <20230103180404.GA4028633@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230103180404.GA4028633@paulmck-ThinkPad-P17-Gen-1>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,WEIRD_PORT autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 03, 2023 at 10:04:04AM -0800, Paul E. McKenney wrote:
> On Mon, Jan 02, 2023 at 08:43:10AM -0800, Davidlohr Bueso wrote:
> > On Sun, 01 Jan 2023, Joel Fernandes (Google) wrote:
> > 
> > > During shutdown of rcutorture, the shutdown thread in
> > > rcu_torture_cleanup() calls torture_cleanup_begin() which sets fullstop
> > > to FULLSTOP_RMMOD. This is enough to cause the rcutorture threads for
> > > readers and fakewriters to breakout of their main while loop and start
> > > shutting down.
> > > 
> > > Once out of their main loop, they then call torture_kthread_stopping()
> > > which in turn waits for kthread_stop() to be called, however
> > > rcu_torture_cleanup() has not even called kthread_stop() on those
> > > threads yet, it does that a bit later.  However, before it gets a chance
> > > to do so, torture_kthread_stopping() calls
> > > schedule_timeout_interruptible(1) in a tight loop. Tracing confirmed
> > > this makes the timer softirq constantly execute timer callbacks, while
> > > never returning back to the softirq exit path and is essentially "locked
> > > up" because of that. If the softirq preempts the shutdown thread,
> > > kthread_stop() may never be called.
> > > 
> > > This commit improves the situation dramatically, by increasing timeout
> > > passed to schedule_timeout_interruptible() 1/20th of a second. This
> > > causes the timer softirq to not lock up a CPU and everything works fine.
> > > Testing has shown 100 runs of TREE07 passing reliably, which was not the
> > > case before because of RCU stalls.
> > > 
> > > Cc: Paul McKenney <paulmck@kernel.org>
> > > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > > Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>
> > > Cc: <stable@vger.kernel.org> # 6.0.x
> > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > 
> > Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
> 
> Queued for further review and testing, thank you all!
> 
> One thing still puzzles me.  Assuming HZ=1000 and given 16 CPUs, each
> timer hander must have consumed many tens of microseconds in order
> to keep the system busy, which seems a bit longer than it should be.
> Or am I underestimating the number of tasks involved?

Here are the traces between successive calls to process_timeout() which is the timer callback handler:

[ 1320.444210]   <idle>-0         0dNs.. 314229620us : __run_timers: Calling timerfn 5: process_timeout
[ 1320.444215]   <idle>-0         0dNs.. 314229620us : sched_waking: comm=rcu_torture_fak pid=145 prio=139 target_cpu=008
[ 1320.463393]   <idle>-0         7d.... 314229655us : sched_switch: prev_comm=swapper/7 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=rcu_torture_wri next_pid=144 next_prio=120
[ 1320.478870] rcu_tort-144       7d.... 314229658us : sched_switch: prev_comm=rcu_torture_wri prev_pid=144 prev_prio=120 prev_state=D ==> next_comm=swapper/7 next_pid=0 next_prio=120
[ 1320.494324]   <idle>-0         0dNs.. 314229738us : __run_timers: Calling timerfn 6: process_timeout

It appears the time delta in the above occurrence is 118 micro seconds
between 2 timer callbacks. It does appear to be doing a cross-CPU wake up.
Maybe that adds to the long time?

Here are the full logs with traces (in case it helps, search for "=D" for the
D-state sched_switch event before the "panic now" trace happens):
http://box.joelfernandes.org:9080/job/rcutorture_stable/job/linux-6.0.y/26/artifact/tools/testing/selftests/rcutorture/res/2022.12.31-23.04.42/TREE07.2/console.log

thanks,

 - Joel

