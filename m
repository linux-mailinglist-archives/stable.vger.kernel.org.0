Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660C01C1F35
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 23:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgEAVCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 17:02:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:56454 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgEAVCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 17:02:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 08F59ABC2;
        Fri,  1 May 2020 21:02:51 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 01 May 2020 23:02:51 +0200
From:   Roman Penyaev <rpenyaev@suse.de>
To:     Jason Baron <jbaron@akamai.com>
Cc:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, Heiher <r@hev.cc>,
        Khazhismel Kumykov <khazhy@google.com>,
        Davidlohr Bueso <dbueso@suse.de>, stable@vger.kernel.org
Subject: Re: [PATCH] epoll: ensure ep_poll() doesn't miss wakeup events
In-Reply-To: <1588360533-11828-1-git-send-email-jbaron@akamai.com>
References: <1588360533-11828-1-git-send-email-jbaron@akamai.com>
Message-ID: <930c565705249d2b6264a31f1be6529e@suse.de>
X-Sender: rpenyaev@suse.de
User-Agent: Roundcube Webmail
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jason,

That is indeed a nice catch.
Seems we need smp_rmb() pair between list_empty_careful(&rp->rdllist) 
and
READ_ONCE(ep->ovflist) for ep_events_available(), do we?

Other than that:

Reviewed-by: Roman Penyaev <rpenyaev@suse.de>

--
Roman

On 2020-05-01 21:15, Jason Baron wrote:
> Now that the ep_events_available() check is done in a lockless way, and
> we no longer perform wakeups from ep_scan_ready_list(), we need to 
> ensure
> that either ep->rdllist has items or the overflow list is active. Prior 
> to:
> commit 339ddb53d373 ("fs/epoll: remove unnecessary wakeups of nested
> epoll"), we did wake_up(&ep->wq) after manipulating the ep->rdllist and 
> the
> overflow list. Thus, any waiters would observe the correct state. 
> However,
> with that wake_up() now removed we need to be more careful to ensure 
> that
> condition.
> 
> Here's an example of what could go wrong:
> 
> We have epoll fds: epfd1, epfd2. And epfd1 is added to epfd2 and epfd2 
> is
> added to a socket: epfd1->epfd2->socket. Thread a is doing epoll_wait() 
> on
> epfd1, and thread b is doing epoll_wait on epfd2. Then:
> 
> 1) data comes in on socket
> 
> ep_poll_callback() wakes up threads a and b
> 
> 2) thread a runs
> 
> ep_poll()
>  ep_scan_ready_list()
>   ep_send_events_proc()
>    ep_item_poll()
>      ep_scan_ready_list()
>        list_splice_init(&ep->rdllist, &txlist);
> 
> 3) now thread b is running
> 
> ep_poll()
>  ep_events_available()
>    returns false
>  schedule_hrtimeout_range()
> 
> Thus, thread b has now scheduled and missed the wakeup.
> 
> Fixes: 339ddb53d373 ("fs/epoll: remove unnecessary wakeups of nested 
> epoll")
> Signed-off-by: Jason Baron <jbaron@akamai.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Heiher <r@hev.cc>
> Cc: Roman Penyaev <rpenyaev@suse.de>
> Cc: Khazhismel Kumykov <khazhy@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Davidlohr Bueso <dbueso@suse.de>
> Cc: <stable@vger.kernel.org>
> ---
>  fs/eventpoll.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index aba03ee749f8..4af2d020f548 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -704,8 +704,14 @@ static __poll_t ep_scan_ready_list(struct 
> eventpoll *ep,
>  	 * in a lockless way.
>  	 */
>  	write_lock_irq(&ep->lock);
> -	list_splice_init(&ep->rdllist, &txlist);
>  	WRITE_ONCE(ep->ovflist, NULL);
> +	/*
> +	 * In ep_poll() we use ep_events_available() in a lockless way to 
> decide
> +	 * if events are available. So we need to preserve that either
> +	 * ep->oflist != EP_UNACTIVE_PTR or there are events on the 
> ep->rdllist.
> +	 */
> +	smp_wmb();
> +	list_splice_init(&ep->rdllist, &txlist);
>  	write_unlock_irq(&ep->lock);
> 
>  	/*
> @@ -737,16 +743,21 @@ static __poll_t ep_scan_ready_list(struct 
> eventpoll *ep,
>  		}
>  	}
>  	/*
> +	 * Quickly re-inject items left on "txlist".
> +	 */
> +	list_splice(&txlist, &ep->rdllist);
> +	/*
> +	 * In ep_poll() we use ep_events_available() in a lockless way to 
> decide
> +	 * if events are available. So we need to preserve that either
> +	 * ep->oflist != EP_UNACTIVE_PTR or there are events on the 
> ep->rdllist.
> +	 */
> +	smp_wmb();
> +	/*
>  	 * We need to set back ep->ovflist to EP_UNACTIVE_PTR, so that after
>  	 * releasing the lock, events will be queued in the normal way inside
>  	 * ep->rdllist.
>  	 */
>  	WRITE_ONCE(ep->ovflist, EP_UNACTIVE_PTR);
> -
> -	/*
> -	 * Quickly re-inject items left on "txlist".
> -	 */
> -	list_splice(&txlist, &ep->rdllist);
>  	__pm_relax(ep->ws);
>  	write_unlock_irq(&ep->lock);

