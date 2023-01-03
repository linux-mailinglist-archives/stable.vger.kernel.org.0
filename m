Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F96165C5A7
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 19:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238646AbjACSEc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 13:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238648AbjACSER (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 13:04:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BAE13F01;
        Tue,  3 Jan 2023 10:04:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A0A3B81076;
        Tue,  3 Jan 2023 18:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4AFC433D2;
        Tue,  3 Jan 2023 18:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672769044;
        bh=CAmWTEbYb6d94H3u+jMGJnp6y/APdybj4ueVDKzwgrE=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=mSrTCw2Cfjo15/d2U+HaUdVAV/nnT1FdNztJ5rAtXXR6oMAZ6CMegikL0WYTsaYty
         HGv+2hFM+9H9RReXNkr4ldStXnUsB/6DMNyGhkmkpBBJTrmfM4GIkw1H/a/NRvCaND
         KVyOlSklgHfWnBGHEHqODE4O1BkwcB63bSnbaz7fgG3A+QQEYiLmPj0X3JFdJ45NHK
         LywebzvimhJabrybJKBTRH5tHb4FzVwBLdO+vPTdQrvQ+o/I1NZliwdg3qWUBk6Jzn
         cx/0FLst320Ijd4F6QaOAdyUgJUEwDJEeqIcgbK3KJ0dpU2xiO3j25wrR6N28nvdkL
         6LRKF0GqCtWPw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 5D7BD5C04EE; Tue,  3 Jan 2023 10:04:04 -0800 (PST)
Date:   Tue, 3 Jan 2023 10:04:04 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Zhouyi Zhou <zhouzhouyi@gmail.com>, stable@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH] torture: Fix hang during kthread shutdown phase
Message-ID: <20230103180404.GA4028633@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230101061555.278129-1-joel@joelfernandes.org>
 <20230102164310.2olg7xhwwhzmzg24@offworld>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102164310.2olg7xhwwhzmzg24@offworld>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 02, 2023 at 08:43:10AM -0800, Davidlohr Bueso wrote:
> On Sun, 01 Jan 2023, Joel Fernandes (Google) wrote:
> 
> > During shutdown of rcutorture, the shutdown thread in
> > rcu_torture_cleanup() calls torture_cleanup_begin() which sets fullstop
> > to FULLSTOP_RMMOD. This is enough to cause the rcutorture threads for
> > readers and fakewriters to breakout of their main while loop and start
> > shutting down.
> > 
> > Once out of their main loop, they then call torture_kthread_stopping()
> > which in turn waits for kthread_stop() to be called, however
> > rcu_torture_cleanup() has not even called kthread_stop() on those
> > threads yet, it does that a bit later.  However, before it gets a chance
> > to do so, torture_kthread_stopping() calls
> > schedule_timeout_interruptible(1) in a tight loop. Tracing confirmed
> > this makes the timer softirq constantly execute timer callbacks, while
> > never returning back to the softirq exit path and is essentially "locked
> > up" because of that. If the softirq preempts the shutdown thread,
> > kthread_stop() may never be called.
> > 
> > This commit improves the situation dramatically, by increasing timeout
> > passed to schedule_timeout_interruptible() 1/20th of a second. This
> > causes the timer softirq to not lock up a CPU and everything works fine.
> > Testing has shown 100 runs of TREE07 passing reliably, which was not the
> > case before because of RCU stalls.
> > 
> > Cc: Paul McKenney <paulmck@kernel.org>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>
> > Cc: <stable@vger.kernel.org> # 6.0.x
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> 
> Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>

Queued for further review and testing, thank you all!

One thing still puzzles me.  Assuming HZ=1000 and given 16 CPUs, each
timer hander must have consumed many tens of microseconds in order
to keep the system busy, which seems a bit longer than it should be.
Or am I underestimating the number of tasks involved?

							Thanx, Paul
