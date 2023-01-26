Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2ED467CAD0
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 13:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbjAZMUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 07:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjAZMUn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 07:20:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A61814496;
        Thu, 26 Jan 2023 04:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VBcq1EUzF4WxvueXeUh58zPcfqregoSVwnaQDxMO/fc=; b=lWN00T4mWAMxbCobO06VWtWEaa
        ILw2tG5p5awAPhOCcE4KlY7ec2m+CHS7/JUDQYNJSYeICS11hEXw1kfytQJ5IFlr6eK8phlWcIA7o
        shIiRXZ55+qkIwJEM50BrIzUCqFwyeGr8oCBsBaXeqnD0prhps1p2t7d01vWIT5RDuOpgqeTNDMaP
        ZYSkn68iKFVIaAED/YmoWBZn5gKNJfSOdW8+vTyrLfEnv/t912hyT5GNt1OVx4qmnHK9gMiMRr1LX
        u64IolqEQ88tCMOeKYLOQl/Nld31cqHv7Yo7HjV12H+03nH8kEWJ0PnuhkWHpyYKS1aFJhrm2bE8d
        qXP+icXw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pL1Ee-006ic7-MS; Thu, 26 Jan 2023 12:20:09 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CB801300137;
        Thu, 26 Jan 2023 13:20:07 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B42192082E0E3; Thu, 26 Jan 2023 13:20:07 +0100 (CET)
Date:   Thu, 26 Jan 2023 13:20:07 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Hernan Ponce de Leon <hernan.poncedeleon@huaweicloud.com>
Cc:     Waiman Long <longman@redhat.com>, paulmck@kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>, mingo@redhat.com,
        will@kernel.org, boqun.feng@gmail.com, akpm@osdl.org,
        tglx@linutronix.de, joel@joelfernandes.org,
        stern@rowland.harvard.edu, diogo.behrens@huawei.com,
        jonas.oberhauser@huawei.com, linux-kernel@vger.kernel.org,
        Hernan Ponce de Leon <hernanl.leon@huawei.com>,
        stable@vger.kernel.org,
        Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>
Subject: Re: [PATCH] Fix data race in mark_rt_mutex_waiters
Message-ID: <Y9Jv9yL8x7/TAq/X@hirez.programming.kicks-ass.net>
References: <20230120135525.25561-1-hernan.poncedeleon@huaweicloud.com>
 <562c883b-b2c3-3a27-f045-97e7e3281e0b@linux.intel.com>
 <20230120155439.GI2948950@paulmck-ThinkPad-P17-Gen-1>
 <9a1c7959-4b8c-94df-a3e2-e69be72bfd7d@huaweicloud.com>
 <20230123164014.GN2948950@paulmck-ThinkPad-P17-Gen-1>
 <f17dcce0-d510-a112-3127-984e8e73f480@huaweicloud.com>
 <d1e28124-b7a7-ae19-87ec-b1dcd3701b61@redhat.com>
 <Y8/+2YBRD4rFySjh@hirez.programming.kicks-ass.net>
 <ae90e931-df19-9d60-610c-57dc34494d8e@redhat.com>
 <c300747a-cf81-0e2d-77ec-f861421291f9@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c300747a-cf81-0e2d-77ec-f861421291f9@huaweicloud.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 26, 2023 at 10:42:07AM +0100, Hernan Ponce de Leon wrote:
> On 1/24/2023 5:04 PM, Waiman Long wrote:
> > 
> > On 1/24/23 10:52, Peter Zijlstra wrote:
> > > On Tue, Jan 24, 2023 at 10:42:24AM -0500, Waiman Long wrote:
> > > 
> > > > I would suggest to do it as suggested by PeterZ. Instead of set_bit(),
> > > > however, it is probably better to use atomic_long_or() like
> > > > 
> > > > atomic_long_or_relaxed(RT_MUTEX_HAS_WAITERS, (atomic_long_t
> > > > *)&lock->owner)
> > > That function doesn't exist, atomic_long_or() is implicitly relaxed for
> > > not returning a value.
> > > 
> > You are right. atomic_long_or() doesn't have variants like some others.
> > 
> > Cheers,
> > Longman
> > 
> 
> When you say "replace the whole of that function", do you mean "barrier
> included"? I argue in the other email that I think this should not affect
> correctness (at least not obviously), but removing the barrier is doing more
> than just fixing the data race as this patch suggests.

Well, set_bit() implies smp_mb(), atomic_long_or() does not and would
need to retain the barrier.

That said, the comments are all batshit. The top comment states relaxed
ordering is suffient since holding lock, the comment with the barrier
utterly fails to explain what it's ordering against.

So all that would need to be updated as well.

That said, looking at 1c0908d8e441 I'm not at all sure we need that
barrier. Even in the try_to_take_rt_mutex(.waiter=NULL) case, where we
skip over the task->pi_lock region, rt_mutex_set_owner(.acquire=true)
will be ACQUIRE.

And in case of rt_mutex_owner(), we fail the trylock (return with 0) and
a failed trylock does not imply any ordering.

So why are we having this barrier?
