Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACAB3637313
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 08:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiKXHsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 02:48:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiKXHs0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 02:48:26 -0500
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64CB28E3D;
        Wed, 23 Nov 2022 23:48:17 -0800 (PST)
Received: from quatroqueijos.cascardo.eti.br (1.general.cascardo.us.vpn [10.172.70.58])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id C18C941D19;
        Thu, 24 Nov 2022 07:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1669276095;
        bh=8uiv7qtZwPv5Ax7DFnLsvbaxEDQrQ7aC1xDdNwezPI4=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=nGPs2YcPuElQVdstHCfyzz4FMkovMEsoPWE1KYRjHOsdawrcDMq4fbACf/KtXuvc9
         OY6Fir46VR7cuDemmUVKru+A7Jb36GENnPTPtnANqi6DEosQ+wPYNgBtzXvQ29WBkz
         kJi3VZ8FWCsTlQMnlhdB1cZwY9qUty5bbZlx86HlXUtcf2cfZPeneivfkNFr20wAVq
         D5qcvtkJdg6TGNcc06aVxqcojdswGufDa5lwk642u/m2pj5k948teAAB4x3feUiQP0
         2ME/m+emrBQlMV3QavQ2Q1UBO7k+m+LD1asr1HwQwew6HIOXyxjr8H+uBow8l9nRfO
         6McimC2/J+4hg==
Date:   Thu, 24 Nov 2022 04:48:07 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Rishabh Bhatnagar <risbhat@amazon.com>
Cc:     gregkh@linuxfoundation.org, shakeelb@google.com,
        viro@zeniv.linux.org.uk, bsegall@google.com, mdecandia@gmail.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Roman Penyaev <rpenyaev@suse.de>,
        Jason Baron <jbaron@akamai.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Khazhismel Kumykov <khazhy@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 5.4 1/2] epoll: call final ep_events_available() check
 under the lock
Message-ID: <Y38ht+WvJF4ahygT@quatroqueijos.cascardo.eti.br>
References: <20221124001123.3248571-1-risbhat@amazon.com>
 <20221124001123.3248571-2-risbhat@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221124001123.3248571-2-risbhat@amazon.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

Acked-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

I ended up picking these two fixes to our kernels as well, even though we could
not pinpoint the process kernel stacktrace as you did as a way to determine the
failure has happened. We are still testing that this is really fixed with these
two commits.

On the other hand,
tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c epoll61 test
starts passing once these two commits are applied.

Cascardo.


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
