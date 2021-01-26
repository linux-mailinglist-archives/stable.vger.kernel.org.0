Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8368D30434A
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 17:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404207AbhAZQAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 11:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404319AbhAZQAm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 11:00:42 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383DDC0617A7;
        Tue, 26 Jan 2021 08:00:02 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id c6so20399459ede.0;
        Tue, 26 Jan 2021 08:00:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0WISkoBlmvHDk8gXEIM5j16DAC7Y4L+QFxJxfjJ09w8=;
        b=UUZdgMlkeumiCcfsbUOxKhP1PqaAy4EGMG7B0fCB9RqiMs0UmG4q74mv4xNnEfFxN0
         l+/w4dQBwHKAg9EJo7MT+Zm3LF5YTxdAPvdNFp+l2IdWqARFI+xCe3nZa/I/6w1k998u
         uZiEB3RQm+D5NqHP756m6ANu2S6vNo+D74FVUEfdJRCg250M4/KGPyNYu9OALCHaN9iA
         PCsKkhVPap9O1C0xt2XssU/v1+rqvasy4BLh/IHNaPV6vD4xoNMnJrInUsaSIQ9yK3Fb
         098X77DOLm0bnVNJf13n8YlaxJRtY2sdHKINTE1eDxIvFgtSDADikWz44JyWzxFSbq00
         U/7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=0WISkoBlmvHDk8gXEIM5j16DAC7Y4L+QFxJxfjJ09w8=;
        b=lIQc1VCEXI71Gxp78Fq1LRTqsdT0wOnfqhO7C1GSHzAqfqTOg2hWvFAznCW+ChR0Xa
         vlaCNojo/0F3Zq3lmV+CIFjsCh0WYtH31xuDWufbpCTi8AFoYzseZFf7iQGIcKQXTpgy
         cP1qgxJLxgfGtlO+i1Fe6Zx3RM/uc5sK4mX1oM3FPqlLA8YqXOuh9i+Uh0JubqiJ9RTt
         oi9Na3xL3z/JWjUgI7ssNBC1h4LWeRDosJLsDBu4KsNI5HMS+MO/STeaMAevNkZz3OhS
         GMA90jZbXusamsG2gcheeRdc00jIMwOI+3gOKEbSGg+ZayQHPbWaQU4EjAFEvSx2g0Tg
         //sg==
X-Gm-Message-State: AOAM533yhCRK30xTYKVDANh7yVfmGeP6gpo+9kqrEcDlovdWPoybGAS7
        XQObalOYVQ0P3LmGNAwSueU=
X-Google-Smtp-Source: ABdhPJxhmZHXHdyLi9AU76BPvhL/MQx1ClxbP5UqdS1s9+Lwno6KT0GEiwGMYKjR5aNG6KXhPzsytg==
X-Received: by 2002:a05:6402:1bcc:: with SMTP id ch12mr5096191edb.283.1611676800912;
        Tue, 26 Jan 2021 08:00:00 -0800 (PST)
Received: from [192.168.8.158] ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id o4sm6393362edw.78.2021.01.26.07.59.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 08:00:00 -0800 (PST)
Subject: Re: [PATCH 2/2] io_uring: fix cancellation taking mutex while
 TASK_UNINTERRUPTIBLE
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org,
        syzbot+f655445043a26a7cfab8@syzkaller.appspotmail.com
References: <cover.1611674535.git.asml.silence@gmail.com>
 <70fb7f91ecc0aeff3427c215ec7f46ceb77f88ef.1611674535.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <5955c0cc-b671-9470-fe31-e4450e9c9c9a@gmail.com>
Date:   Tue, 26 Jan 2021 15:56:19 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <70fb7f91ecc0aeff3427c215ec7f46ceb77f88ef.1611674535.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26/01/2021 15:28, Pavel Begunkov wrote:
> do not call blocking ops when !TASK_RUNNING; state=2 set at
> 	[<00000000ced9dbfc>] prepare_to_wait+0x1f4/0x3b0
> 	kernel/sched/wait.c:262
> WARNING: CPU: 1 PID: 19888 at kernel/sched/core.c:7853
> 	__might_sleep+0xed/0x100 kernel/sched/core.c:7848
> RIP: 0010:__might_sleep+0xed/0x100 kernel/sched/core.c:7848
> Call Trace:
>  __mutex_lock_common+0xc4/0x2ef0 kernel/locking/mutex.c:935
>  __mutex_lock kernel/locking/mutex.c:1103 [inline]
>  mutex_lock_nested+0x1a/0x20 kernel/locking/mutex.c:1118
>  io_wq_submit_work+0x39a/0x720 fs/io_uring.c:6411
>  io_run_cancel fs/io-wq.c:856 [inline]
>  io_wqe_cancel_pending_work fs/io-wq.c:990 [inline]
>  io_wq_cancel_cb+0x614/0xcb0 fs/io-wq.c:1027
>  io_uring_cancel_files fs/io_uring.c:8874 [inline]
>  io_uring_cancel_task_requests fs/io_uring.c:8952 [inline]
>  __io_uring_files_cancel+0x115d/0x19e0 fs/io_uring.c:9038
>  io_uring_files_cancel include/linux/io_uring.h:51 [inline]
>  do_exit+0x2e6/0x2490 kernel/exit.c:780
>  do_group_exit+0x168/0x2d0 kernel/exit.c:922
>  get_signal+0x16b5/0x2030 kernel/signal.c:2770
>  arch_do_signal_or_restart+0x8e/0x6a0 arch/x86/kernel/signal.c:811
>  handle_signal_work kernel/entry/common.c:147 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
>  exit_to_user_mode_prepare+0xac/0x1e0 kernel/entry/common.c:201
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
>  syscall_exit_to_user_mode+0x48/0x190 kernel/entry/common.c:302
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Rewrite io_uring_cancel_files() to mimic __io_uring_task_cancel()'s
> counting scheme, so it does all the heavy work before setting
> TASK_UNINTERRUPTIBLE.
> 
> Cc: stable@vger.kernel.org # 5.9+
> Reported-by: syzbot+f655445043a26a7cfab8@syzkaller.appspotmail.com
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 41 ++++++++++++++++++++++++-----------------
>  1 file changed, 24 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 09aada153a71..f3f2b37e7021 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8873,30 +8873,33 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
>  	}
>  }
>  
> +static int io_uring_count_inflight(struct io_ring_ctx *ctx,
> +				   struct task_struct *task,
> +				   struct files_struct *files)
> +{
> +	struct io_kiocb *req;
> +	int cnt = 0;
> +
> +	spin_lock_irq(&ctx->inflight_lock);
> +	list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
> +		if (!io_match_task(req, task, files))

This condition should be inversed. Jens, please drop it

p.s. I wonder how tests didn't catch that

> +			cnt++;
> +	}
> +	spin_unlock_irq(&ctx->inflight_lock);
> +	return cnt;
> +}
> +
>  static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>  				  struct task_struct *task,
>  				  struct files_struct *files)
>  {
>  	while (!list_empty_careful(&ctx->inflight_list)) {
>  		struct io_task_cancel cancel = { .task = task, .files = files };
> -		struct io_kiocb *req;
>  		DEFINE_WAIT(wait);
> -		bool found = false;
> +		int inflight;
>  
> -		spin_lock_irq(&ctx->inflight_lock);
> -		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
> -			if (!io_match_task(req, task, files))
> -				continue;
> -			found = true;
> -			break;
> -		}
> -		if (found)
> -			prepare_to_wait(&task->io_uring->wait, &wait,
> -					TASK_UNINTERRUPTIBLE);
> -		spin_unlock_irq(&ctx->inflight_lock);
> -
> -		/* We need to keep going until we don't find a matching req */
> -		if (!found)
> +		inflight = io_uring_count_inflight(ctx, task, files);
> +		if (!inflight)
>  			break;
>  
>  		io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, &cancel, true);
> @@ -8905,7 +8908,11 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>  		io_cqring_overflow_flush(ctx, true, task, files);
>  		/* cancellations _may_ trigger task work */
>  		io_run_task_work();
> -		schedule();
> +
> +		prepare_to_wait(&task->io_uring->wait, &wait,
> +				TASK_UNINTERRUPTIBLE);
> +		if (inflight == io_uring_count_inflight(ctx, task, files))
> +			schedule();
>  		finish_wait(&task->io_uring->wait, &wait);
>  	}
>  }
> 

-- 
Pavel Begunkov
