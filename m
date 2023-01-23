Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8E36781E3
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 17:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbjAWQlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 11:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233409AbjAWQlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 11:41:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C95B2ED72;
        Mon, 23 Jan 2023 08:40:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22CC160FA7;
        Mon, 23 Jan 2023 16:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63142C433EF;
        Mon, 23 Jan 2023 16:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674492015;
        bh=qWUTRn6e7Trd0sj41WMJ6BQjE8Mh3daIepzHE5J6aeg=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=XVEyY3b3vTpoiA1wt7tXEaW9mvWVcPvJn0zg+7MyGgKcqRflT7Y/lm9zncpaF38U8
         Dax6X5/nlOZOAAK9icQbwvwNru40yKC7/VrYT3nGwkevTiX8iAvBA3PZEk1jo5LNpj
         VWTnK/mrqMoKb0zC/veiEi9Ux0NPdpyCilodcuxBAn+Shfup5zrNp/NkWrml8pslCk
         rJS6PlaMJEdt58vpgxbuHzHbvGAiTMdBXRnf7EL4VB3WAYAQ13FUOyZXpzY8ti4PH0
         Uz9lsVUi2GploOn7w81zOYb3KIKLlJBp5FOKt+Oazl+C2XCVcM9d4n+9Em/3hK3oae
         7hM+lZz5vAdGA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 044625C084D; Mon, 23 Jan 2023 08:40:15 -0800 (PST)
Date:   Mon, 23 Jan 2023 08:40:14 -0800
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
Message-ID: <20230123164014.GN2948950@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230120135525.25561-1-hernan.poncedeleon@huaweicloud.com>
 <562c883b-b2c3-3a27-f045-97e7e3281e0b@linux.intel.com>
 <20230120155439.GI2948950@paulmck-ThinkPad-P17-Gen-1>
 <9a1c7959-4b8c-94df-a3e2-e69be72bfd7d@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a1c7959-4b8c-94df-a3e2-e69be72bfd7d@huaweicloud.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 22, 2023 at 04:24:21PM +0100, Hernan Ponce de Leon wrote:
> On 1/20/2023 4:54 PM, Paul E. McKenney wrote:
> > On Fri, Jan 20, 2023 at 06:58:20AM -0800, Arjan van de Ven wrote:
> > > On 1/20/2023 5:55 AM, Hernan Ponce de Leon wrote:
> > > > From: Hernan Ponce de Leon <hernanl.leon@huawei.com>
> > > > 
> > > 
> > > >    kernel/locking/rtmutex.c | 2 +-
> > > >    1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
> > > > index 010cf4e6d0b8..7ed9472edd48 100644
> > > > --- a/kernel/locking/rtmutex.c
> > > > +++ b/kernel/locking/rtmutex.c
> > > > @@ -235,7 +235,7 @@ static __always_inline void mark_rt_mutex_waiters(struct rt_mutex_base *lock)
> > > >    	unsigned long owner, *p = (unsigned long *) &lock->owner;
> > > >    	do {
> > > > -		owner = *p;
> > > > +		owner = READ_ONCE(*p);
> > > >    	} while (cmpxchg_relaxed(p, owner,
> > > 
> > > 
> > > I don't see how this makes any difference at all.
> > > *p can be read a dozen times and it's fine; cmpxchg has barrier semantics for compilers afaics
> > 
> > Doing so does suppress a KCSAN warning.  You could also use data_race()
> > if it turns out that the volatile semantics would prevent a valuable
> > compiler optimization.
> 
> I think the import question is "is this a harmful data race (and needs to be
> fixed as proposed by the patch) or a harmless one (and we should use
> data_race() to silence tools)?".
> 
> In https://lkml.org/lkml/2023/1/22/160 I describe how this data race can
> affect important ordering guarantees for the rest of the code. For this
> reason I consider it a harmful one. If this is not the case, I would
> appreciate some feedback or pointer to resources about what races care to
> avoid spamming the mailing list in the future.

In the case, the value read is passed into cmpxchg_relaxed(), which
checks the value against memory.  In this case, as Arjan noted, the only
compiler-and-silicon difference between data_race() and READ_ONCE()
is that use of data_race() might allow the compiler to do things like
tear the load, thus forcing the occasional spurious cmpxchg_relaxed()
failure.  In contrast, LKMM (by design) throws up its hands when it sees
a data race.  Something about not being eager to track the idiosyncrasies
of many compiler versions.

My approach in my own code is to use *_ONCE() unless it causes a visible
performance regression or if it confuses KCSAN.  An example of the latter
can be debug code, in which case use of data_race() avoids suppressing
KCSAN warnings (and also false positives, depending).

Except that your other email seems to also be arguing that additional
ordering is required.  So is https://lkml.org/lkml/2023/1/20/702 really
sufficient just by itself, or is additional ordering required?

							Thanx, Paul
