Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3C81C50A4
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 10:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbgEEImI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 04:42:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:39482 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728627AbgEEImH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 May 2020 04:42:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 808AFAFF2;
        Tue,  5 May 2020 08:42:08 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 05 May 2020 10:42:05 +0200
From:   Roman Penyaev <rpenyaev@suse.de>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Jason Baron <jbaron@akamai.com>,
        Khazhismel Kumykov <khazhy@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] epoll: call final ep_events_available() check under
 the lock
In-Reply-To: <20200505084049.1779243-1-rpenyaev@suse.de>
References: <20200505084049.1779243-1-rpenyaev@suse.de>
Message-ID: <a9898eaefa85fa9c85e179ff162d5e8d@suse.de>
X-Sender: rpenyaev@suse.de
User-Agent: Roundcube Webmail
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi Andrew,

May I ask you to remove "epoll: ensure ep_poll() doesn't miss wakeup
events" from your -mm queue? Jason lately found out that the patch
does not fully solve the problem and this one patch is a second
attempt to do things correctly in a different way (namely to do
the final check under the lock). Previous changes are not needed.

Thanks.

--
Roman


On 2020-05-05 10:40, Roman Penyaev wrote:
> The original problem was described here:
>    https://lkml.org/lkml/2020/4/27/1121
> 
> There is a possible race when ep_scan_ready_list() leaves ->rdllist
> and ->obflist empty for a short period of time although some events
> are pending. It is quite likely that ep_events_available() observes
> empty lists and goes to sleep. Since 339ddb53d373 ("fs/epoll: remove
> unnecessary wakeups of nested epoll") we are conservative in wakeups
> (there is only one place for wakeup and this is ep_poll_callback()),
> thus ep_events_available() must always observe correct state of
> two lists. The easiest and correct way is to do the final check
> under the lock. This does not impact the performance, since lock
> is taken anyway for adding a wait entry to the wait queue.
> 
> In this patch barrierless __set_current_state() is used. This is
> safe since waitqueue_active() is called under the same lock on wakeup
> side.
> 
> Short-circuit for fatal signals (i.e. fatal_signal_pending() check)
> is moved to the line just before actual events harvesting routine.
> This is fully compliant to what is said in the comment of the patch
> where the actual fatal_signal_pending() check was added:
> c257a340ede0 ("fs, epoll: short circuit fetching events if thread
> has been killed").
> 
> Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
> Reported-by: Jason Baron <jbaron@akamai.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Khazhismel Kumykov <khazhy@google.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
>  fs/eventpoll.c | 48 ++++++++++++++++++++++++++++--------------------
>  1 file changed, 28 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index aba03ee749f8..8453e5403283 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1879,34 +1879,33 @@ static int ep_poll(struct eventpoll *ep,
> struct epoll_event __user *events,
>  		 * event delivery.
>  		 */
>  		init_wait(&wait);
> -		write_lock_irq(&ep->lock);
> -		__add_wait_queue_exclusive(&ep->wq, &wait);
> -		write_unlock_irq(&ep->lock);
> 
> +		write_lock_irq(&ep->lock);
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
> @@ -1927,6 +1926,15 @@ static int ep_poll(struct eventpoll *ep, struct
> epoll_event __user *events,
>  	}
> 
>  send_events:
> +	if (fatal_signal_pending(current))
> +		/*
> +		 * Always short-circuit for fatal signals to allow
> +		 * threads to make a timely exit without the chance of
> +		 * finding more events available and fetching
> +		 * repeatedly.
> +		 */
> +		res = -EINTR;
> +
>  	/*
>  	 * Try to transfer events to user space. In case we get 0 events and
>  	 * there's still timeout left over, we go trying again in search of

