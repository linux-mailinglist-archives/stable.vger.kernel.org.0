Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585F5637318
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 08:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiKXHtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 02:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiKXHtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 02:49:23 -0500
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52422286E9;
        Wed, 23 Nov 2022 23:49:22 -0800 (PST)
Received: from quatroqueijos.cascardo.eti.br (1.general.cascardo.us.vpn [10.172.70.58])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 040673F1C2;
        Thu, 24 Nov 2022 07:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1669276159;
        bh=TVUCi+GUR+3L+hwsSYw2wjNWpr9vB+c6Ivyh3fy1Vz0=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=bbBh06+rsP/f0k8tdL2qiZbmQ/DUgMC3YYJF8r3RASHEkDNMXSLAHfHpbqT1WyuGR
         xzrAgk+JpzQlCz6KlExRdY4KGoNzsg1vK4Wu+bsy2vJfxrgw7bnhKOC5V+uTCTAMyQ
         eWNVtQrAIu+Ul755J3HhYYq0PFkfH7KkYlZbifyduPY4lTI9Zu9sLtG0QKYJgLVR3Z
         OHRyAWahSdP/rNTJaN8vPvPRz8yB+TNEoxbT9vPcmYfd8FwhViQNivZBSsCFb6xOi2
         esSQRJhWQDeQm5lipZlMEN31Fk7OFQh9lQrjrfdsOvip7TtXzqhz2JAf09eyS/WtOp
         06AerE+r3IY6A==
Date:   Thu, 24 Nov 2022 04:49:10 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Rishabh Bhatnagar <risbhat@amazon.com>
Cc:     gregkh@linuxfoundation.org, shakeelb@google.com,
        viro@zeniv.linux.org.uk, bsegall@google.com, mdecandia@gmail.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Guantao Liu <guantaol@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Khazhismel Kumykov <khazhy@google.com>,
        Davidlohr Bueso <dbueso@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] epoll: check for events when removing a timed out
 thread from the wait queue
Message-ID: <Y38h9oe4ZEGNd7Zx@quatroqueijos.cascardo.eti.br>
References: <20221124001123.3248571-1-risbhat@amazon.com>
 <20221124001123.3248571-3-risbhat@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221124001123.3248571-3-risbhat@amazon.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 24, 2022 at 12:11:23AM +0000, Rishabh Bhatnagar wrote:
> From: Soheil Hassas Yeganeh <soheil@google.com>
> 
> Commit 289caf5d8f6c61c6d2b7fd752a7f483cd153f182 upstream.
> 
> Patch series "simplify ep_poll".
> 
> This patch series is a followup based on the suggestions and feedback by
> Linus:
> https://lkml.kernel.org/r/CAHk-=wizk=OxUyQPbO8MS41w2Pag1kniUV5WdD5qWL-gq1kjDA@mail.gmail.com
> 
> The first patch in the series is a fix for the epoll race in presence of
> timeouts, so that it can be cleanly backported to all affected stable
> kernels.
> 
> The rest of the patch series simplify the ep_poll() implementation.  Some
> of these simplifications result in minor performance enhancements as well.
> We have kept these changes under self tests and internal benchmarks for a
> few days, and there are minor (1-2%) performance enhancements as a result.
> 
> This patch (of 8):
> 
> After abc610e01c66 ("fs/epoll: avoid barrier after an epoll_wait(2)
> timeout"), we break out of the ep_poll loop upon timeout, without checking
> whether there is any new events available.  Prior to that patch-series we
> always called ep_events_available() after exiting the loop.
> 
> This can cause races and missed wakeups.  For example, consider the
> following scenario reported by Guantao Liu:
> 
> Suppose we have an eventfd added using EPOLLET to an epollfd.
> 
> Thread 1: Sleeps for just below 5ms and then writes to an eventfd.
> Thread 2: Calls epoll_wait with a timeout of 5 ms. If it sees an
>           event of the eventfd, it will write back on that fd.
> Thread 3: Calls epoll_wait with a negative timeout.
> 
> Prior to abc610e01c66, it is guaranteed that Thread 3 will wake up either
> by Thread 1 or Thread 2.  After abc610e01c66, Thread 3 can be blocked
> indefinitely if Thread 2 sees a timeout right before the write to the
> eventfd by Thread 1.  Thread 2 will be woken up from
> schedule_hrtimeout_range and, with evail 0, it will not call
> ep_send_events().
> 
> To fix this issue:
> 1) Simplify the timed_out case as suggested by Linus.
> 2) while holding the lock, recheck whether the thread was woken up
>    after its time out has reached.
> 
> Note that (2) is different from Linus' original suggestion: It do not set
> "eavail = ep_events_available(ep)" to avoid unnecessary contention (when
> there are too many timed-out threads and a small number of events), as
> well as races mentioned in the discussion thread.
> 
> This is the first patch in the series so that the backport to stable
> releases is straightforward.
> 
> Link: https://lkml.kernel.org/r/20201106231635.3528496-1-soheil.kdev@gmail.com
> Link: https://lkml.kernel.org/r/CAHk-=wizk=OxUyQPbO8MS41w2Pag1kniUV5WdD5qWL-gq1kjDA@mail.gmail.com
> Link: https://lkml.kernel.org/r/20201106231635.3528496-2-soheil.kdev@gmail.com
> Fixes: abc610e01c66 ("fs/epoll: avoid barrier after an epoll_wait(2) timeout")
> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> Tested-by: Guantao Liu <guantaol@google.com>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Reported-by: Guantao Liu <guantaol@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: Willem de Bruijn <willemb@google.com>
> Reviewed-by: Khazhismel Kumykov <khazhy@google.com>
> Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>

Acked-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

> ---
>  fs/eventpoll.c | 25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index e5496483a882..877f9f61a4e8 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1928,23 +1928,30 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>  		}
>  		write_unlock_irq(&ep->lock);
>  
> -		if (eavail || res)
> -			break;
> +		if (!eavail && !res)
> +			timed_out = !schedule_hrtimeout_range(to, slack,
> +							      HRTIMER_MODE_ABS);
>  
> -		if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS)) {
> -			timed_out = 1;
> -			break;
> -		}
> -
> -		/* We were woken up, thus go and try to harvest some events */
> +		/*
> +		 * We were woken up, thus go and try to harvest some events.
> +		 * If timed out and still on the wait queue, recheck eavail
> +		 * carefully under lock, below.
> +		 */
>  		eavail = 1;
> -
>  	} while (0);
>  
>  	__set_current_state(TASK_RUNNING);
>  
>  	if (!list_empty_careful(&wait.entry)) {
>  		write_lock_irq(&ep->lock);
> +		/*
> +		 * If the thread timed out and is not on the wait queue, it
> +		 * means that the thread was woken up after its timeout expired
> +		 * before it could reacquire the lock. Thus, when wait.entry is
> +		 * empty, it needs to harvest events.
> +		 */
> +		if (timed_out)
> +			eavail = list_empty(&wait.entry);
>  		__remove_wait_queue(&ep->wq, &wait);
>  		write_unlock_irq(&ep->lock);
>  	}
> -- 
> 2.37.1
> 
