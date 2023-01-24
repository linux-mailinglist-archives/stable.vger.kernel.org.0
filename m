Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57783679E4F
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 17:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234118AbjAXQMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 11:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbjAXQMS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 11:12:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925A145F6D;
        Tue, 24 Jan 2023 08:12:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CC43612AF;
        Tue, 24 Jan 2023 16:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E9EC433D2;
        Tue, 24 Jan 2023 16:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674576731;
        bh=s1R7NoV2ya/D81mpK5OG28/EQSy+HDOHhZykgAIMQNs=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=RnLU0HcX0MqCRCjZPmcIIk2zH95eQiiQwGjVzWdtKFBbnAX9+Zqk/ZJgjsP5pEnzC
         BYghRRlAca+hFeEAJehfhguShs170UltUu9IznDs8GQEIkwBwl69vHTOCSLsdZz6Ou
         PzEodOA1kdcj66pmGiugJOJMFdT8rL2M48NEc2ro0u3aoZIkPqf0N2Flm/SwSpX9P7
         ID/bKz2DBG+w4l25a0yvidlrSZ/j6T/ArD+7oQ7XsuUAdF2L3nKCgYEJg94tIS684e
         rU74oSgRBn5Kg2C9NIpE7eo4Fg266LQno9RwGNBKCh0d/u7ZUcnXtXKXUMQiRtRhRn
         VCCqQ1VmhFzbg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 10BC35C06D0; Tue, 24 Jan 2023 08:12:11 -0800 (PST)
Date:   Tue, 24 Jan 2023 08:12:11 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Hernan Ponce de Leon <hernan.poncedeleon@huaweicloud.com>
Cc:     Arjan van de Ven <arjan@linux.intel.com>, peterz@infradead.org,
        mingo@redhat.com, will@kernel.org, longman@redhat.com,
        boqun.feng@gmail.com, akpm@osdl.org, tglx@linutronix.de,
        joel@joelfernandes.org, stern@rowland.harvard.edu,
        diogo.behrens@huawei.com, jonas.oberhauser@huawei.com,
        linux-kernel@vger.kernel.org,
        Hernan Ponce de Leon <hernanl.leon@huawei.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] Fix data race in mark_rt_mutex_waiters
Message-ID: <20230124161211.GK2948950@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230120135525.25561-1-hernan.poncedeleon@huaweicloud.com>
 <562c883b-b2c3-3a27-f045-97e7e3281e0b@linux.intel.com>
 <20230120155439.GI2948950@paulmck-ThinkPad-P17-Gen-1>
 <9a1c7959-4b8c-94df-a3e2-e69be72bfd7d@huaweicloud.com>
 <20230123164014.GN2948950@paulmck-ThinkPad-P17-Gen-1>
 <f17dcce0-d510-a112-3127-984e8e73f480@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17dcce0-d510-a112-3127-984e8e73f480@huaweicloud.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 24, 2023 at 03:57:55PM +0100, Hernan Ponce de Leon wrote:
> On 1/23/2023 5:40 PM, Paul E. McKenney wrote:
> > On Sun, Jan 22, 2023 at 04:24:21PM +0100, Hernan Ponce de Leon wrote:
> > > On 1/20/2023 4:54 PM, Paul E. McKenney wrote:
> > > > On Fri, Jan 20, 2023 at 06:58:20AM -0800, Arjan van de Ven wrote:
> > > > > On 1/20/2023 5:55 AM, Hernan Ponce de Leon wrote:
> > > > > > From: Hernan Ponce de Leon <hernanl.leon@huawei.com>
> > > > > > 
> > > > > 
> > > > > >     kernel/locking/rtmutex.c | 2 +-
> > > > > >     1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > > 
> > > > > > diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
> > > > > > index 010cf4e6d0b8..7ed9472edd48 100644
> > > > > > --- a/kernel/locking/rtmutex.c
> > > > > > +++ b/kernel/locking/rtmutex.c
> > > > > > @@ -235,7 +235,7 @@ static __always_inline void mark_rt_mutex_waiters(struct rt_mutex_base *lock)
> > > > > >     	unsigned long owner, *p = (unsigned long *) &lock->owner;
> > > > > >     	do {
> > > > > > -		owner = *p;
> > > > > > +		owner = READ_ONCE(*p);
> > > > > >     	} while (cmpxchg_relaxed(p, owner,
> > > > > 
> > > > > 
> > > > > I don't see how this makes any difference at all.
> > > > > *p can be read a dozen times and it's fine; cmpxchg has barrier semantics for compilers afaics
> > > > 
> > > > Doing so does suppress a KCSAN warning.  You could also use data_race()
> > > > if it turns out that the volatile semantics would prevent a valuable
> > > > compiler optimization.
> > > 
> > > I think the import question is "is this a harmful data race (and needs to be
> > > fixed as proposed by the patch) or a harmless one (and we should use
> > > data_race() to silence tools)?".
> > > 
> > > In https://lkml.org/lkml/2023/1/22/160 I describe how this data race can
> > > affect important ordering guarantees for the rest of the code. For this
> > > reason I consider it a harmful one. If this is not the case, I would
> > > appreciate some feedback or pointer to resources about what races care to
> > > avoid spamming the mailing list in the future.
> > 
> > In the case, the value read is passed into cmpxchg_relaxed(), which
> > checks the value against memory.  In this case, as Arjan noted, the only
> > compiler-and-silicon difference between data_race() and READ_ONCE()
> > is that use of data_race() might allow the compiler to do things like
> > tear the load, thus forcing the occasional spurious cmpxchg_relaxed()
> > failure.  In contrast, LKMM (by design) throws up its hands when it sees
> > a data race.  Something about not being eager to track the idiosyncrasies
> > of many compiler versions.
> > 
> > My approach in my own code is to use *_ONCE() unless it causes a visible
> > performance regression or if it confuses KCSAN.  An example of the latter
> > can be debug code, in which case use of data_race() avoids suppressing
> > KCSAN warnings (and also false positives, depending).
> 
> I understand that *_ONCE() might avoid some compiler optimization and reduce
> performance in the general case. However, if I understand your first
> paragraph correctly, in this particular case data_race() could allow the CAS
> to fail more often, resulting in more spinning iterations and degraded
> performance. Am I right?

In theory, yes.  The overall effect on performance will depend on the
hardware, the compiler, the compiler version, the flags passed to that
compiler, and who knows what all else.

> > Except that your other email seems to also be arguing that additional
> > ordering is required.  So is https://lkml.org/lkml/2023/1/20/702 really
> > sufficient just by itself, or is additional ordering required?
> 
> I do not claim that we need to mark the read to add the ordering that is
> needed for correctness (mutual exclusion). What I claim in this patch is
> that there is a data race, and since it can affect ordering constrains in
> subtle ways, I consider it harmful and thus I want to fix it.
> 
> What I explain in the other email is that if we fix the data race, either
> the fence or the acquire store might be relaxed (because marking the read
> gives us some extra ordering guarantees). If the race is not fixed, both the
> fence and the acquire are needed according to LKMM. The situation is
> different wrt hardware models. In that case the tool cannot find any
> violation even if we don't fix the race and we relax the store / remove the
> fence.

Plus there might be other options, as Waiman and Peter are discussing.

							Thanx, Paul
