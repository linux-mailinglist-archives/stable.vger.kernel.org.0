Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 860CA34FE0
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 20:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfFDSfY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 14:35:24 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:59492 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbfFDSfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 14:35:23 -0400
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id 4A3DF1F462;
        Tue,  4 Jun 2019 18:35:23 +0000 (UTC)
Date:   Tue, 4 Jun 2019 18:35:23 +0000
From:   Eric Wong <e@80x24.org>
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        linux-kernel@vger.kernel.org, arnd@arndb.de, dbueso@suse.de,
        axboe@kernel.dk, dave@stgolabs.net, jbaron@akamai.com,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        omar.kilani@gmail.com, tglx@linutronix.de, stable@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Laight <David.Laight@ACULAB.COM>
Subject: Re: [PATCH] signal: remove the wrong signal_pending() check in
 restore_user_sigmask()
Message-ID: <20190604183523.kkruvskcgbli2fpu@dcvr>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com>
 <20190604134117.GA29963@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190604134117.GA29963@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:
> This is the minimal fix for stable, I'll send cleanups later.
> 
> The commit 854a6ed56839a40f6b5d02a2962f48841482eec4 ("signal: Add
> restore_user_sigmask()") introduced the visible change which breaks
> user-space: a signal temporary unblocked by set_user_sigmask() can
> be delivered even if the caller returns success or timeout.
> 
> Change restore_user_sigmask() to accept the additional "interrupted"
> argument which should be used instead of signal_pending() check, and
> update the callers.
> 
> Reported-by: Eric Wong <e@80x24.org>
> Fixes: 854a6ed56839a40f6b5d02a2962f48841482eec4 ("signal: Add restore_user_sigmask()")
> cc: stable@vger.kernel.org (v5.0+)
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Thanks, for epoll_pwait on top of Linux v5.1.7 and cmogstored v1.7.0:

Tested-by: Eric Wong <e@80x24.org>

(cmogstored v1.7.1 already works around this when it sees a 0
return value (but not >0, yet...))

> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 0fbb486..1147c5d 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2201,11 +2201,12 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>  	}
>  
>  	ret = wait_event_interruptible(ctx->wait, io_cqring_events(ring) >= min_events);
> -	if (ret == -ERESTARTSYS)
> -		ret = -EINTR;
>  
>  	if (sig)
> -		restore_user_sigmask(sig, &sigsaved);
> +		restore_user_sigmask(sig, &sigsaved, ret == -ERESTARTSYS);
> +
> +	if (ret == -ERESTARTSYS)
> +		ret = -EINTR;
>  
>  	return READ_ONCE(ring->r.head) == READ_ONCE(ring->r.tail) ? ret : 0;
>  }

That io_uring bit didn't apply cleanly to stable,
since stable is missing fdb288a679cdf6a71f3c1ae6f348ba4dae742681
("io_uring: use wait_event_interruptible for cq_wait conditional wait")
and related commits.

In any case, I'm not using io_uring anywhere, yet (and probably
won't, since I'll still need threads to deal with open/unlink/rename
on slow JBOD HDDs).
