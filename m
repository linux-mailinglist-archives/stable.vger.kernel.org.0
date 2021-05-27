Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCEC7392B92
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 12:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236061AbhE0KRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 06:17:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:43844 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235978AbhE0KRT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 06:17:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1622110544; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7Tqg2oJdZxR+Sys5kciWyzhmhV8Hhlr9BuDDbot73Yw=;
        b=ka1Rz5Q2HXdp4QGEFWfv0X0d+KGjYQmq+MZISm65jgJ0iZthoM902leBiSvR/fhMuOSCiH
        b+H9xuspfgYD2cv9dY1Z7UU4iYjHgErDDufiO4AmLl2xPn418L2f7X28SrSObUo+oKXuc8
        0WQjucNiM9jgPd5XwKSoTfbqT+9e7Ck=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 68397AAA6;
        Thu, 27 May 2021 10:15:44 +0000 (UTC)
Date:   Thu, 27 May 2021 12:15:43 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Oleg Nesterov <oleg@redhat.com>, liumartin@google.com,
        akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>
Cc:     bp@suse.de, davidchao@google.com, jenhaochen@google.com,
        jkosina@suse.cz, josh@joshtriplett.org, mhocko@suse.cz,
        mingo@redhat.com, mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, rostedt@goodmis.org, stable@vger.kernel.org,
        tglx@linutronix.de, tj@kernel.org, vbabka@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: +
 kthread-fix-kthread_mod_delayed_work-vs-kthread_cancel_delayed_work_sync-race.patch
 added to -mm tree
Message-ID: <YK9xTzlNSj83mAne@alley>
References: <20210520214737.MrGGKbPrJ%akpm@linux-foundation.org>
 <20210521163526.GA17916@redhat.com>
 <YKvBVIJAc8/Qasdu@alley>
 <20210526170604.GC4581@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526170604.GC4581@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Added Tejun into CC because of the workqueue API related question
at the end of the mail.

On Wed 2021-05-26 19:06:06, Oleg Nesterov wrote:
> On 05/24, Petr Mladek wrote:
> >
> > Your patch changes the semantic. The current semantic is the same for
> > the workqueue's counter-part mod_delayed_work_on().
> 
> OK, I see, thanks. I was confused by the comment.
> 
> > We should actually keep the "ret" value as is to stay compatible with
> > workqueue API:
> >
> > 	/*
> > 	 * Canceling could run in parallel from kthread_cancel_delayed_work_sync
> > 	 * and change work's canceling count as the spinlock is released and regain
> > 	 * in __kthread_cancel_work so we need to check the count again. Otherwise,
> > 	 * we might incorrectly queue the dwork and further cause
> > 	 * cancel_delayed_work_sync thread waiting for flush dwork endlessly.
> > 	 *
> > 	 * Keep the ret code. The API primary informs the caller
> > 	 * whether some pending work has been canceled (not proceed).
> > 	 */
> > 	if (work->canceling)
> > 		goto out;
> 
> Agreed, we should keep the "ret" value.

Martin Liu, could you please resend the patch without the "ret =
false" line? See above.

Andrew, could you please remove this patch from the -mm tree for now?

> but unless I am confused again this doesn't match mod_delayed_work_on()
> which always returns true if it races with cancel(). Nevermind, I think
> this doesn't matter.

Good point. I think that it is actually a bug. Most callers ignore
the return code but there is the following user:

static void addrconf_del_dad_work(struct inet6_ifaddr *ifp)
{
	if (cancel_delayed_work(&ifp->dad_work))
		__in6_ifa_put(ifp);
}
static void addrconf_mod_dad_work(struct inet6_ifaddr *ifp,
				   unsigned long delay)
{
	in6_ifa_hold(ifp);
	if (mod_delayed_work(addrconf_wq, &ifp->dad_work, delay))
		in6_ifa_put(ifp);
}

If mod_delayed_work() races with cancel_delayed_work() then both might
return true and call in6_ifa_put(ifp).

I thought that they were serialized by ifp->lock. But, for example,
addrconf_dad_start() calls addrconf_mod_dad_work() after releasing
this lock.

It is possible that they are serialized another way. But I think that
in principle only the one that really cancelled a pending work
should return "true".

Tejun, any opinion?  Feel free to ask for more context.

Best Regards,
Petr
