Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E381675950
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 16:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbjATPzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 10:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbjATPzF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 10:55:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F82707D8;
        Fri, 20 Jan 2023 07:54:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1551A61FDA;
        Fri, 20 Jan 2023 15:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C483C433D2;
        Fri, 20 Jan 2023 15:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674230079;
        bh=Lyzp89/oUt/Y+HS78U5nbaABso705ppG1wwrowaJd5k=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=YTzNIkRBatAMAnoFrKr6O9Jwkv2d6st4V+W1ZmWuVxiNC87cMqqtyzuJVuQLhRLtw
         cKGiFR7L6u/2Musmn3K/MvZQOXigdfi99RohHyjZ0lPUQvCjoIU30a8d7AmPQmjzXh
         z3ZIEhVxS/pNlQC72D2tLvOw2PV0BBNMHjNI2VlvsTYcADEAmL1m/rk5i/GTu00hGZ
         WFGLKP2xM1WzToGPlJhHpgVlv8PWfmV4G1wVLsteXbW17lyd2vOvYx8hy/QU/EJc7A
         3QNBo6RxY08+fPmZ7HVrmOSYQSdV5WmdKMvVG1oJlJ8G1kK2u7fyQBkHy0ozLjYoGy
         0bHMZbSjgQluQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 104335C0DFC; Fri, 20 Jan 2023 07:54:39 -0800 (PST)
Date:   Fri, 20 Jan 2023 07:54:39 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Arjan van de Ven <arjan@linux.intel.com>
Cc:     Hernan Ponce de Leon <hernan.poncedeleon@huaweicloud.com>,
        peterz@infradead.org, mingo@redhat.com, will@kernel.org,
        longman@redhat.com, boqun.feng@gmail.com, akpm@osdl.org,
        tglx@linutronix.de, joel@joelfernandes.org,
        stern@rowland.harvard.edu, diogo.behrens@huawei.com,
        jonas.oberhauser@huawei.com, linux-kernel@vger.kernel.org,
        Hernan Ponce de Leon <hernanl.leon@huawei.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] Fix data race in mark_rt_mutex_waiters
Message-ID: <20230120155439.GI2948950@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230120135525.25561-1-hernan.poncedeleon@huaweicloud.com>
 <562c883b-b2c3-3a27-f045-97e7e3281e0b@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <562c883b-b2c3-3a27-f045-97e7e3281e0b@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 20, 2023 at 06:58:20AM -0800, Arjan van de Ven wrote:
> On 1/20/2023 5:55 AM, Hernan Ponce de Leon wrote:
> > From: Hernan Ponce de Leon <hernanl.leon@huawei.com>
> > 
> 
> >   kernel/locking/rtmutex.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
> > index 010cf4e6d0b8..7ed9472edd48 100644
> > --- a/kernel/locking/rtmutex.c
> > +++ b/kernel/locking/rtmutex.c
> > @@ -235,7 +235,7 @@ static __always_inline void mark_rt_mutex_waiters(struct rt_mutex_base *lock)
> >   	unsigned long owner, *p = (unsigned long *) &lock->owner;
> >   	do {
> > -		owner = *p;
> > +		owner = READ_ONCE(*p);
> >   	} while (cmpxchg_relaxed(p, owner,
> 
> 
> I don't see how this makes any difference at all.
> *p can be read a dozen times and it's fine; cmpxchg has barrier semantics for compilers afaics

Doing so does suppress a KCSAN warning.  You could also use data_race()
if it turns out that the volatile semantics would prevent a valuable
compiler optimization.

							Thanx, Paul
