Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086AE241180
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 22:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgHJUMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 16:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgHJUMV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 16:12:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFD4C061756;
        Mon, 10 Aug 2020 13:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=p+O5toKMk/YnlDlStHbGOELvhO9uaKOaIXKSC93w+JA=; b=rvCUTiFWiBdbSRwfn6/xoZVxJH
        5cDhXdRfT/ClZqQpzrVg4YAm1veleQXklLyhEy5EsvuECixhD00jBRBPFF3OgEehKeQpMAKwNsjpN
        S6DsoempqiW6Q0PsMIun0oG1SvUqlzVDjszu1TUI1jvnA3u7pjNCP/iYFndpSOo8sl0bxpOTME/rz
        /05gqK/v1F2U9ttxfu83f8rI3/aqxEoxKj1yHRUPEO9hz4m807T2PwCdkr6IZUpGcqJhXtQC3oG2K
        fIdHgekrEPDMr7wkkTW9LQR1LxeCsD+tbTd0SE4DPfyDkKzMOuMBNNs9amZao2lZQJhgwqfQGY41x
        1yOvGjzA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k5E9V-0005v2-OR; Mon, 10 Aug 2020 20:12:17 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 552D6980D39; Mon, 10 Aug 2020 22:12:13 +0200 (CEST)
Date:   Mon, 10 Aug 2020 22:12:13 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, stable@vger.kernel.org,
        Josef <josef.grieb@gmail.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
Message-ID: <20200810201213.GB3982@worktop.programming.kicks-ass.net>
References: <20200808183439.342243-1-axboe@kernel.dk>
 <20200808183439.342243-3-axboe@kernel.dk>
 <20200810114256.GS2674@hirez.programming.kicks-ass.net>
 <a6ee0a6d-5136-4fe9-8906-04fe6420aad9@kernel.dk>
 <07df8ab4-16a8-8537-b4fe-5438bd8110cf@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07df8ab4-16a8-8537-b4fe-5438bd8110cf@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 01:21:48PM -0600, Jens Axboe wrote:

> >> Wait.. so the only change here is that you look at tsk->state, _after_
> >> doing __task_work_add(), but nothing, not the Changelog nor the comment
> >> explains this.
> >>
> >> So you're relying on __task_work_add() being an smp_mb() vs the add, and
> >> you order this against the smp_mb() in set_current_state() ?
> >>
> >> This really needs spelling out.
> > 
> > I'll update the changelog, it suffers a bit from having been reused from
> > the earlier versions. Thanks for checking!
> 
> I failed to convince myself that the existing construct was safe, so
> here's an incremental on top of that. Basically we re-check the task
> state _after_ the initial notification, to protect ourselves from the
> case where we initially find the task running, but between that check
> and when we do the notification, it's now gone to sleep. Should be
> pretty slim, but I think it's there.
> 
> Hence do a loop around it, if we're using TWA_RESUME.
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 44ac103483b6..a4ecb6c7e2b0 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1780,12 +1780,27 @@ static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
>  	 * to ensure that the issuing task processes task_work. TWA_SIGNAL
>  	 * is needed for that.
>  	 */
> -	if (ctx->flags & IORING_SETUP_SQPOLL)
> +	if (ctx->flags & IORING_SETUP_SQPOLL) {
>  		notify = 0;
> -	else if (READ_ONCE(tsk->state) != TASK_RUNNING)
> -		notify = TWA_SIGNAL;
> +	} else {
> +		bool notified = false;
>  
> -	__task_work_notify(tsk, notify);
> +		/*
> +		 * If the task is running, TWA_RESUME notify is enough. Make
> +		 * sure to re-check after we've sent the notification, as not

Could we get a clue as to why TWA_RESUME is enough when it's running? I
presume it is because we'll do task_work_run() somewhere before we
block, but having an explicit reference here might help someone new to
this make sense of it all.

> +		 * to have a race between the check and the notification. This
> +		 * only applies for TWA_RESUME, as TWA_SIGNAL is safe with a
> +		 * sleeping task
> +		 */
> +		do {
> +			if (READ_ONCE(tsk->state) != TASK_RUNNING)
> +				notify = TWA_SIGNAL;
> +			else if (notified)
> +				break;
> +			__task_work_notify(tsk, notify);
> +			notified = true;
> +		} while (notify != TWA_SIGNAL);
> +	}
>  	wake_up_process(tsk);
>  	return 0;
>  }

Would it be clearer to write it like so perhaps?

	/*
	 * Optimization; when the task is RUNNING we can do with a
	 * cheaper TWA_RESUME notification because,... <reason goes
	 * here>. Otherwise do the more expensive, but always correct
	 * TWA_SIGNAL.
	 */
	if (READ_ONCE(tsk->state) == TASK_RUNNING) {
		__task_work_notify(tsk, TWA_RESUME);
		if (READ_ONCE(tsk->state) == TASK_RUNNING)
			return;
	}
	__task_work_notify(tsk, TWA_SIGNAL);
	wake_up_process(tsk);



