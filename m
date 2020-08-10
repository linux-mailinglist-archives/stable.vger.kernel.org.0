Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6747224056C
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 13:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbgHJLnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 07:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbgHJLnB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 07:43:01 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A231C061756;
        Mon, 10 Aug 2020 04:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rUV8TXBIF69VSVuOkNWllqKBBv485GNQxeZ0WslsuZ8=; b=BdG9w4gzRBOt0kOfkwBh8eN1lc
        Edl/E9w5HnGanLdGs1iPbmWqMD7K4OBdBrq4HuQn3+PCMAI0NJoZuHAny3xzlNgmpkl8df4AykuOk
        PggZEZnx800pQNGzKRsCfSkqAwljfFW+VOy/5afvknkEvSyzqaRq5m09t1u1OykVn+jEM4uOBdLbH
        h0vD6yDoalhD1c4WCXi1mbyqg+XkPa44l/JA3d5zx1zzRQVZztf0UYHlylEbVYrHhwIXW2qocmLRg
        cB6swyEDDFTW+nl07poOPQxjcugzBeeEIx0Vh5FTYKSfVu0W5yC6on3QbiAYEHTSADkQ0q4ofAay3
        bomoP3hw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k56Cf-0005Ca-Ru; Mon, 10 Aug 2020 11:42:58 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 71D35300DAE;
        Mon, 10 Aug 2020 13:42:56 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5506823D39366; Mon, 10 Aug 2020 13:42:56 +0200 (CEST)
Date:   Mon, 10 Aug 2020 13:42:56 +0200
From:   peterz@infradead.org
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, stable@vger.kernel.org,
        Josef <josef.grieb@gmail.com>
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
Message-ID: <20200810114256.GS2674@hirez.programming.kicks-ass.net>
References: <20200808183439.342243-1-axboe@kernel.dk>
 <20200808183439.342243-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200808183439.342243-3-axboe@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 08, 2020 at 12:34:39PM -0600, Jens Axboe wrote:
> An earlier commit:
> 
> b7db41c9e03b ("io_uring: fix regression with always ignoring signals in io_cqring_wait()")
> 
> ensured that we didn't get stuck waiting for eventfd reads when it's
> registered with the io_uring ring for event notification, but we still
> have a gap where the task can be waiting on other events in the kernel
> and need a bigger nudge to make forward progress.
> 
> Ensure that we use signaled notifications for a task that isn't currently
> running, to be certain the work is seen and processed immediately.
> 
> Cc: stable@vger.kernel.org # v5.7+
> Reported-by: Josef <josef.grieb@gmail.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e9b27cdaa735..443eecdfeda9 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1712,21 +1712,27 @@ static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
>  	struct io_ring_ctx *ctx = req->ctx;
>  	int ret, notify = TWA_RESUME;
>  
> +	ret = __task_work_add(tsk, cb);
> +	if (unlikely(ret))
> +		return ret;
> +
>  	/*
>  	 * SQPOLL kernel thread doesn't need notification, just a wakeup.
> -	 * If we're not using an eventfd, then TWA_RESUME is always fine,
> -	 * as we won't have dependencies between request completions for
> -	 * other kernel wait conditions.
> +	 * For any other work, use signaled wakeups if the task isn't
> +	 * running to avoid dependencies between tasks or threads. If
> +	 * the issuing task is currently waiting in the kernel on a thread,
> +	 * and same thread is waiting for a completion event, then we need
> +	 * to ensure that the issuing task processes task_work. TWA_SIGNAL
> +	 * is needed for that.
>  	 */
>  	if (ctx->flags & IORING_SETUP_SQPOLL)
>  		notify = 0;
> -	else if (ctx->cq_ev_fd)
> +	else if (READ_ONCE(tsk->state) != TASK_RUNNING)
>  		notify = TWA_SIGNAL;
>  
> -	ret = task_work_add(tsk, cb, notify);
> -	if (!ret)
> -		wake_up_process(tsk);
> -	return ret;
> +	__task_work_notify(tsk, notify);
> +	wake_up_process(tsk);
> +	return 0;
>  }

Wait.. so the only change here is that you look at tsk->state, _after_
doing __task_work_add(), but nothing, not the Changelog nor the comment
explains this.

So you're relying on __task_work_add() being an smp_mb() vs the add, and
you order this against the smp_mb() in set_current_state() ?

This really needs spelling out.
