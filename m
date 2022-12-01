Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1B563E8BD
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 05:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiLAEIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 23:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiLAEIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 23:08:11 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C880712ACD;
        Wed, 30 Nov 2022 20:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1669867684; x=1701403684;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AkHGE9n9vEWIxGjO613+X4B7Rt+ERcB5SUu0QSiXWfY=;
  b=O65tQ7LVYy8xmzR/NMR/xbugNU4pNFhWbDcw1vqbubVlujQfUDjLolpR
   2+okkuCCg0mp1DAZPt7iCdejZNj9jzA4t5X5MoYp58+gjEpIq0gpGv4aJ
   +R3KfD0DYrJwmlolkco52G1rCzrEjMsAvcQ0EsgnePQ2bkmq4naFSqwe+
   s=;
X-IronPort-AV: E=Sophos;i="5.96,207,1665446400"; 
   d="scan'208";a="272590912"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-529f0975.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 04:08:03 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-m6i4x-529f0975.us-east-1.amazon.com (Postfix) with ESMTPS id 9C58D42658;
        Thu,  1 Dec 2022 04:07:59 +0000 (UTC)
Received: from EX19D001UWA002.ant.amazon.com (10.13.138.236) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 1 Dec 2022 04:07:58 +0000
Received: from localhost (10.43.160.223) by EX19D001UWA002.ant.amazon.com
 (10.13.138.236) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20; Thu, 1 Dec 2022
 04:07:57 +0000
Date:   Wed, 30 Nov 2022 20:07:55 -0800
From:   Samuel Mendoza-Jonas <samjonas@amazon.com>
To:     Rishabh Bhatnagar <risbhat@amazon.com>
CC:     <gregkh@linuxfoundation.org>, <shakeelb@google.com>,
        <viro@zeniv.linux.org.uk>, <bsegall@google.com>,
        <mdecandia@gmail.com>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Roman Penyaev <rpenyaev@suse.de>,
        Jason Baron <jbaron@akamai.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Khazhismel Kumykov <khazhy@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <benh@amazon.com>
Subject: Re: [PATCH 5.4 1/2] epoll: call final ep_events_available() check
 under the lock
Message-ID: <20221201040755.67mu5lvuvkoxleg3@u46989501580c5c.ant.amazon.com>
References: <20221124001123.3248571-1-risbhat@amazon.com>
 <20221124001123.3248571-2-risbhat@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221124001123.3248571-2-risbhat@amazon.com>
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D31UWC004.ant.amazon.com (10.43.162.27) To
 EX19D001UWA002.ant.amazon.com (10.13.138.236)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 24, 2022 at 12:11:22AM +0000, Rishabh Bhatnagar wrote:
> From: Roman Penyaev <rpenyaev@suse.de>
> 
> Commit 65759097d804d2a9ad2b687db436319704ba7019 upstream.
> 
> There is a possible race when ep_scan_ready_list() leaves ->rdllist and
> ->obflist empty for a short period of time although some events are
> pending.  It is quite likely that ep_events_available() observes empty
> lists and goes to sleep.
> 
> Since commit 339ddb53d373 ("fs/epoll: remove unnecessary wakeups of
> nested epoll") we are conservative in wakeups (there is only one place
> for wakeup and this is ep_poll_callback()), thus ep_events_available()
> must always observe correct state of two lists.
> 
> The easiest and correct way is to do the final check under the lock.
> This does not impact the performance, since lock is taken anyway for
> adding a wait entry to the wait queue.
> 
> The discussion of the problem can be found here:
> 
>    https://lore.kernel.org/linux-fsdevel/a2f22c3c-c25a-4bda-8339-a7bdaf17849e@akamai.com/
> 
> In this patch barrierless __set_current_state() is used.  This is safe
> since waitqueue_active() is called under the same lock on wakeup side.
> 
> Short-circuit for fatal signals (i.e.  fatal_signal_pending() check) is
> moved to the line just before actual events harvesting routine.  This is
> fully compliant to what is said in the comment of the patch where the
> actual fatal_signal_pending() check was added: c257a340ede0 ("fs, epoll:
> short circuit fetching events if thread has been killed").
> 
> Fixes: 339ddb53d373 ("fs/epoll: remove unnecessary wakeups of nested epoll")

We may want to consider pulling in this commit as well to 5.4.
339ddb53d373 was merged in v5.5, but there are at least two other
commits already in 5.4 stable that reference it, e.g.

$ git log --oneline v5.4..stable/linux-5.4.y --grep '339ddb53d373'       
ee922a2f6be9 eventpoll: fix missing wakeup for ovflist in ep_poll_callback
5d77631de15a epoll: atomically remove wait entry on wake up

Technically it broke things originally, but it smells bad to have
several fixes in the tree for removed code that is still there - any
thoughts?

Cheers,
Sam

> Reported-by: Jason Baron <jbaron@akamai.com>
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Jason Baron <jbaron@akamai.com>
> Cc: Khazhismel Kumykov <khazhy@google.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: <stable@vger.kernel.org>
> Link: http://lkml.kernel.org/r/20200505145609.1865152-1-rpenyaev@suse.de
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
> ---
>  fs/eventpoll.c | 47 +++++++++++++++++++++++++++--------------------
>  1 file changed, 27 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 7e11135bc915..e5496483a882 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1905,33 +1905,31 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>  		init_wait(&wait);
>  		wait.func = ep_autoremove_wake_function;
>  		write_lock_irq(&ep->lock);
> -		__add_wait_queue_exclusive(&ep->wq, &wait);
> -		write_unlock_irq(&ep->lock);
> -
>  		/*
> -		 * We don't want to sleep if the ep_poll_callback() sends us
> -		 * a wakeup in between. That's why we set the task state
> -		 * to TASK_INTERRUPTIBLE before doing the checks.
> +		 * Barrierless variant, waitqueue_active() is called under
> +		 * the same lock on wakeup ep_poll_callback() side, so it
> +		 * is safe to avoid an explicit barrier.
>  		 */
> -		set_current_state(TASK_INTERRUPTIBLE);
> +		__set_current_state(TASK_INTERRUPTIBLE);
> +
>  		/*
> -		 * Always short-circuit for fatal signals to allow
> -		 * threads to make a timely exit without the chance of
> -		 * finding more events available and fetching
> -		 * repeatedly.
> +		 * Do the final check under the lock. ep_scan_ready_list()
> +		 * plays with two lists (->rdllist and ->ovflist) and there
> +		 * is always a race when both lists are empty for short
> +		 * period of time although events are pending, so lock is
> +		 * important.
>  		 */
> -		if (fatal_signal_pending(current)) {
> -			res = -EINTR;
> -			break;
> +		eavail = ep_events_available(ep);
> +		if (!eavail) {
> +			if (signal_pending(current))
> +				res = -EINTR;
> +			else
> +				__add_wait_queue_exclusive(&ep->wq, &wait);
>  		}
> +		write_unlock_irq(&ep->lock);
>  
> -		eavail = ep_events_available(ep);
> -		if (eavail)
> -			break;
> -		if (signal_pending(current)) {
> -			res = -EINTR;
> +		if (eavail || res)
>  			break;
> -		}
>  
>  		if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS)) {
>  			timed_out = 1;
> @@ -1952,6 +1950,15 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>  	}
>  
>  send_events:
> +	if (fatal_signal_pending(current)) {
> +		/*
> +		 * Always short-circuit for fatal signals to allow
> +		 * threads to make a timely exit without the chance of
> +		 * finding more events available and fetching
> +		 * repeatedly.
> +		 */
> +		res = -EINTR;
> +	}
>  	/*
>  	 * Try to transfer events to user space. In case we get 0 events and
>  	 * there's still timeout left over, we go trying again in search of
> -- 
> 2.37.1
> 
