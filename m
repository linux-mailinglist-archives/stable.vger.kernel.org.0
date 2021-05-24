Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0400038EC5F
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbhEXPOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:14:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:39602 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235160AbhEXPJh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:09:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1621868885; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6Jmqz6BcAV4sgU0W+YCi555UhdpmhQ/W0XK3YXYPUp4=;
        b=XpEOgdetWkdVmZD2StG26Vo+v/2PzFKf83EWwnYkCD26KY55xkDPOorhb/svqkbw58Mc27
        dttUtBFh5nydKk3WMLei4cV2WXOKfpWxVhreWlPTwCtS53Rk935jyploCrzYhEMJ8wF38u
        gfz3fGZvKkv22bpJCg2sijgjKn38DVI=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9BB5CAB6D;
        Mon, 24 May 2021 15:08:05 +0000 (UTC)
Date:   Mon, 24 May 2021 17:08:04 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     akpm@linux-foundation.org, bp@suse.de, davidchao@google.com,
        jenhaochen@google.com, jkosina@suse.cz, josh@joshtriplett.org,
        liumartin@google.com, mhocko@suse.cz, mingo@redhat.com,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, rostedt@goodmis.org, stable@vger.kernel.org,
        tglx@linutronix.de, tj@kernel.org, vbabka@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: +
 kthread-fix-kthread_mod_delayed_work-vs-kthread_cancel_delayed_work_sync-race.patch
 added to -mm tree
Message-ID: <YKvBVIJAc8/Qasdu@alley>
References: <20210520214737.MrGGKbPrJ%akpm@linux-foundation.org>
 <20210521163526.GA17916@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521163526.GA17916@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 2021-05-21 18:35:27, Oleg Nesterov wrote:
> On 05/20, Andrew Morton wrote:
> >
> > --- a/kernel/kthread.c~kthread-fix-kthread_mod_delayed_work-vs-kthread_cancel_delayed_work_sync-race
> > +++ a/kernel/kthread.c
> > @@ -1181,6 +1181,19 @@ bool kthread_mod_delayed_work(struct kth
> >  		goto out;
> >
> >  	ret = __kthread_cancel_work(work, true, &flags);
> > +
> > +	/*
> > +	 * Canceling could run in parallel from kthread_cancel_delayed_work_sync
> > +	 * and change work's canceling count as the spinlock is released and regain
> > +	 * in __kthread_cancel_work so we need to check the count again. Otherwise,
> > +	 * we might incorrectly queue the dwork and further cause
> > +	 * cancel_delayed_work_sync thread waiting for flush dwork endlessly.
> > +	 */
> > +	if (work->canceling) {
> > +		ret = false;
> > +		goto out;
> > +	}
> > +
> >  fast_queue:
> >  	__kthread_queue_delayed_work(worker, dwork, delay);
> 
> Never looked at this code before, can't review...
> 
> but note that another caller of __kthread_queue_delayed_work() needs to
> check work->canceling too. So perhaps we should simply add queuing_blocked()
> into __kthread_queue_delayed_work() ?

Good point. I do not have strong opinion. But if we move the check
to __kthread_queue_delayed_work() than it would make sense to
move it also into kthread_insert_work() to keep it symmetric.
But then we would do the check twice in some code paths.
Well, it would make the API more safe.


> Something like below, uncompiled/untested, most probably incorrect.
> 
> Either way, this comment
> 
> 	 * Return: %true if @dwork was pending and its timer was modified,
> 	 * %false otherwise.
> 
> above kthread_mod_delayed_work looks obviously wrong. Currently it returns
> true if this work was pending. With your patch it returns true if it was
> pending and not canceling.
>
> With the patch below it returns true if the work was (re)queued successfully,
> and this makes more sense to me. But again, I can easily misread this code.

Your patch changes the semantic. The current semantic is the same for
the workqueue's counter-part mod_delayed_work_on().

It look's weird by it makes sense.

kthread_mod_delayed_work() should always succeed and queue the work
with the new delay. Normally, the only interesting information is
whether the work was canceled (queued but not proceed). It means
that some job was not done.

The only situation when kthread_mod_delayed_work() is not able to
queue the work is when another process is canceling the work at
the same time. But it means that kthread_mod_delayed_work()
and kthread_cancel_delayed_work_sync() are called in parallel.
The result is racy by definition. It means that the code is racy.
And it typically means that the API is used a wrong way.
Note the comment:

 * A special case is when the work is being canceled in parallel.
 * It might be caused either by the real kthread_cancel_delayed_work_sync()
 * or yet another kthread_mod_delayed_work() call. We let the other command
 * win and return %false here. The caller is supposed to synchronize these
 * operations a reasonable way.


But you have a point. The new code returns "false" even when the work
was canceled. It means that the previously queue work was not
proceed.

We should actually keep the "ret" value as is to stay compatible with
workqueue API:

	/*
	 * Canceling could run in parallel from kthread_cancel_delayed_work_sync
	 * and change work's canceling count as the spinlock is released and regain
	 * in __kthread_cancel_work so we need to check the count again. Otherwise,
	 * we might incorrectly queue the dwork and further cause
	 * cancel_delayed_work_sync thread waiting for flush dwork endlessly.
	 *
	 * Keep the ret code. The API primary informs the caller
	 * whether some pending work has been canceled (not proceed).
	 */
	if (work->canceling)
		goto out;

Best Regards,
Petr
