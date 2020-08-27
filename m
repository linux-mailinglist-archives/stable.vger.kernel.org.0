Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A25B2549FB
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 17:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgH0PzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 11:55:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727048AbgH0PzG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Aug 2020 11:55:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED2482087D;
        Thu, 27 Aug 2020 15:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598543705;
        bh=jVhrsCJ+LgOz74KtTe3g9ISDjncNRsQpYmDTHxjcXQs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wpfl/PWbFSllfNe4H8ij3Ae3/AzxcTykiPhND8X9Qk0l4SpJzdU85FhDGeEB8xyvT
         6TDTaEFlRnFFWY/hp3GXhVowUMHGM01E71I7jrhMl2Afy3hJ3vlFDjRwnna9II3EcS
         A7+zHR37zQbDmDPPUOy1qlF0YPMw1xXvvVB5gk24=
Date:   Thu, 27 Aug 2020 17:55:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Qais Yousef <qais.yousef@arm.com>
Cc:     "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Lukasz Luba <lukasz.luba@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.8 130/232] sched/uclamp: Protect uclamp fast path code
 with static key
Message-ID: <20200827155518.GA682821@kroah.com>
References: <20200820091612.692383444@linuxfoundation.org>
 <20200820091619.114657136@linuxfoundation.org>
 <20200827135330.246pbwc7h5gvdli7@e107158-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827135330.246pbwc7h5gvdli7@e107158-lin.cambridge.arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 27, 2020 at 02:53:31PM +0100, Qais Yousef wrote:
> On 08/20/20 11:19, Greg Kroah-Hartman wrote:
> > From: Qais Yousef <qais.yousef@arm.com>
> > 
> > [ Upstream commit 46609ce227039fd192e0ecc7d940bed587fd2c78 ]
> > 
> > There is a report that when uclamp is enabled, a netperf UDP test
> > regresses compared to a kernel compiled without uclamp.
> > 
> > https://lore.kernel.org/lkml/20200529100806.GA3070@suse.de/
> > 
> > While investigating the root cause, there were no sign that the uclamp
> > code is doing anything particularly expensive but could suffer from bad
> > cache behavior under certain circumstances that are yet to be
> > understood.
> > 
> > https://lore.kernel.org/lkml/20200616110824.dgkkbyapn3io6wik@e107158-lin/
> > 
> > To reduce the pressure on the fast path anyway, add a static key that is
> > by default will skip executing uclamp logic in the
> > enqueue/dequeue_task() fast path until it's needed.
> > 
> > As soon as the user start using util clamp by:
> > 
> > 	1. Changing uclamp value of a task with sched_setattr()
> > 	2. Modifying the default sysctl_sched_util_clamp_{min, max}
> > 	3. Modifying the default cpu.uclamp.{min, max} value in cgroup
> > 
> > We flip the static key now that the user has opted to use util clamp.
> > Effectively re-introducing uclamp logic in the enqueue/dequeue_task()
> > fast path. It stays on from that point forward until the next reboot.
> > 
> > This should help minimize the effect of util clamp on workloads that
> > don't need it but still allow distros to ship their kernels with uclamp
> > compiled in by default.
> > 
> > SCHED_WARN_ON() in uclamp_rq_dec_id() was removed since now we can end
> > up with unbalanced call to uclamp_rq_dec_id() if we flip the key while
> > a task is running in the rq. Since we know it is harmless we just
> > quietly return if we attempt a uclamp_rq_dec_id() when
> > rq->uclamp[].bucket[].tasks is 0.
> > 
> > In schedutil, we introduce a new uclamp_is_enabled() helper which takes
> > the static key into account to ensure RT boosting behavior is retained.
> > 
> > The following results demonstrates how this helps on 2 Sockets Xeon E5
> > 2x10-Cores system.
> > 
> >                                    nouclamp                 uclamp      uclamp-static-key
> > Hmean     send-64         162.43 (   0.00%)      157.84 *  -2.82%*      163.39 *   0.59%*
> > Hmean     send-128        324.71 (   0.00%)      314.78 *  -3.06%*      326.18 *   0.45%*
> > Hmean     send-256        641.55 (   0.00%)      628.67 *  -2.01%*      648.12 *   1.02%*
> > Hmean     send-1024      2525.28 (   0.00%)     2448.26 *  -3.05%*     2543.73 *   0.73%*
> > Hmean     send-2048      4836.14 (   0.00%)     4712.08 *  -2.57%*     4867.69 *   0.65%*
> > Hmean     send-3312      7540.83 (   0.00%)     7425.45 *  -1.53%*     7621.06 *   1.06%*
> > Hmean     send-4096      9124.53 (   0.00%)     8948.82 *  -1.93%*     9276.25 *   1.66%*
> > Hmean     send-8192     15589.67 (   0.00%)    15486.35 *  -0.66%*    15819.98 *   1.48%*
> > Hmean     send-16384    26386.47 (   0.00%)    25752.25 *  -2.40%*    26773.74 *   1.47%*
> > 
> > The perf diff between nouclamp and uclamp-static-key when uclamp is
> > disabled in the fast path:
> > 
> >      8.73%     -1.55%  [kernel.kallsyms]        [k] try_to_wake_up
> >      0.07%     +0.04%  [kernel.kallsyms]        [k] deactivate_task
> >      0.13%     -0.02%  [kernel.kallsyms]        [k] activate_task
> > 
> > The diff between nouclamp and uclamp-static-key when uclamp is enabled
> > in the fast path:
> > 
> >      8.73%     -0.72%  [kernel.kallsyms]        [k] try_to_wake_up
> >      0.13%     +0.39%  [kernel.kallsyms]        [k] activate_task
> >      0.07%     +0.38%  [kernel.kallsyms]        [k] deactivate_task
> > 
> > Fixes: 69842cba9ace ("sched/uclamp: Add CPU's clamp buckets refcounting")
> > Reported-by: Mel Gorman <mgorman@suse.de>
> > Signed-off-by: Qais Yousef <qais.yousef@arm.com>
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Tested-by: Lukasz Luba <lukasz.luba@arm.com>
> > Link: https://lkml.kernel.org/r/20200630112123.12076-3-qais.yousef@arm.com
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> 
> Greg/Peter/Mel
> 
> Should this go to 5.4 too? Not saying it should, but I don't know if distros
> could care about potential performance hit that this patch addresses.

If you want to provide a backported version of this to 5.4.y, that you
have tested that works properly, I will be glad to queue it up.

thanks,

greg k-h
