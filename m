Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC6D3C22FC
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 13:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhGILlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 07:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbhGILlN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Jul 2021 07:41:13 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88867C0613DD;
        Fri,  9 Jul 2021 04:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=43Lf+zzmrrH5VsxADYa58paCbsgJPKuh8uE7fsHJkIM=; b=bzOSMrlT2MuULTiykTbSEevQBy
        BqdAfWy86bLpmFBMKGulUid+AfAXjqmMFUE/hTY5FnWCpL/KlzmWPb2s5LfXZ5sLT3ZaHjEBKUIGH
        WEFtmOyZMHkNLohpfXlvj96GX6yeqXuqnKF+xXYezmnPc8aF08kg88bAKfTIkU1a7uiQtdRtdNe/M
        GAQeb2UhnWu8btSaep0kSrNWq1zCNnoN4Dnne9bBDZU01gOY7vrSdVBr8m5QS6rzo5jfE6ZeSsifk
        DAVz57tVGstU+gkOu9Qoii2LKaHW1Auuc65jH5sNLdUgFTZ9TcKwV25+880bZVD2BEleCpntOv9Fm
        yiqoAxPg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m1opq-00G47Y-On; Fri, 09 Jul 2021 11:38:23 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 154D130022B;
        Fri,  9 Jul 2021 13:38:21 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 02EA121BE8C9E; Fri,  9 Jul 2021 13:38:20 +0200 (CEST)
Date:   Fri, 9 Jul 2021 13:38:20 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Phil Auld <pauld@redhat.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Waiman Long <longman@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] sched: Fix nr_uninterruptible race causing increasing
 load average
Message-ID: <YOg1LHSDknjobJfR@hirez.programming.kicks-ass.net>
References: <20210707190457.60521-1-pauld@redhat.com>
 <YOaoomJAS2FzXi7I@hirez.programming.kicks-ass.net>
 <YOb82exzMcrOxfHa@lorien.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOb82exzMcrOxfHa@lorien.usersys.redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 08, 2021 at 09:25:45AM -0400, Phil Auld wrote:
> Hi Peter,
> 
> On Thu, Jul 08, 2021 at 09:26:26AM +0200 Peter Zijlstra wrote:
> > On Wed, Jul 07, 2021 at 03:04:57PM -0400, Phil Auld wrote:
> > > On systems with weaker memory ordering (e.g. power) commit dbfb089d360b
> > > ("sched: Fix loadavg accounting race") causes increasing values of load
> > > average (via rq->calc_load_active and calc_load_tasks) due to the wakeup
> > > CPU not always seeing the write to task->sched_contributes_to_load in
> > > __schedule(). Missing that we fail to decrement nr_uninterruptible when
> > > waking up a task which incremented nr_uninterruptible when it slept.
> > > 
> > > The rq->lock serialization is insufficient across different rq->locks.
> > > 
> > > Add smp_wmb() to schedule and smp_rmb() before the read in
> > > ttwu_do_activate().
> > 
> > > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > > index 4ca80df205ce..ced7074716eb 100644
> > > --- a/kernel/sched/core.c
> > > +++ b/kernel/sched/core.c
> > > @@ -2992,6 +2992,8 @@ ttwu_do_activate(struct rq *rq, struct task_struct *p, int wake_flags,
> > >  
> > >  	lockdep_assert_held(&rq->lock);
> > >  
> > > +	/* Pairs with smp_wmb in __schedule() */
> > > +	smp_rmb();
> > >  	if (p->sched_contributes_to_load)
> > >  		rq->nr_uninterruptible--;
> > >  
> > 
> > Is this really needed ?! (this question is a big fat clue the comment is
> > insufficient). AFAICT try_to_wake_up() has a LOAD-ACQUIRE on p->on_rq
> > and hence the p->sched_contributed_to_load must already happen after.
> >
> 
> Yes, it is needed.  We've got idle power systems with load average of 530.21.
> Calc_load_tasks is 530, and the sum of both nr_uninterruptible and
> calc_load_active across all the runqueues is 530. Basically monotonically
> non-decreasing load average. With the patch this no longer happens.

Have you tried without the rmb here? Do you really need both barriers?
