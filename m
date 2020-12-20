Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5FA62DF86C
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 05:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgLUEyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Dec 2020 23:54:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728367AbgLUEyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Dec 2020 23:54:38 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB86AC0613D3;
        Sun, 20 Dec 2020 20:53:57 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id a6so8699777wmc.2;
        Sun, 20 Dec 2020 20:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lX32/8Xuph8eHK0o6FlvjN3ViQPYOiihsp675ptbfAw=;
        b=TqiXC4GG8qMgAuFnnSaFFBni/YcP/e7+y876Ug82Ki1OWZ0Kf7ZznRilzfcXqgPQIT
         WuDzJoa4yQXBiWW61LM52ms1gOIIHTOSkbxttTu4SQqi+/3ahRzNVjY0KpX/E0wMnU6x
         YslHHkHyzY5mDowedT1deD+5n9QOoUjCtjo4H9rdUmHDYqyFaPpaYbDBxBOooRQULl+Z
         qVDi0ixfIoZT4jfWQXX5ChAMPpkfqgpEwaSvGAfrQ5CCCyI7PJkmAQO/P5nuK/SwPWOG
         Rsbfr7gskb5P2LCX9gkUOpnYMjzrMORo8bSGu3CogcXprMPiKLaSGp6Y/h/H2NE8Carj
         FEgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=lX32/8Xuph8eHK0o6FlvjN3ViQPYOiihsp675ptbfAw=;
        b=sIo3dzFITOLeIkdlelFT0yOyYU8vvnaBKNwCDAppGvZR91Sd+TTn9rtR/aJQiZh2t0
         v36PeQVFJ2bJss9ga/izwLiUc3X8uyHWtejKCsbtPmeQ+bzQVNy28iL0XxBAPbO4jJ6u
         A8EMXNaoo/G8G07RTe4PYozG+YYAvKDILOhOg3wdSIhg4SEoZSjg+aT3PmNzOzZOBom6
         7hzvCavfSl+/j3kw9pbrWkW8ypIoaxqcZald3dSvqTLiDDKdt3tashcNgAEie/ByqOZT
         EIgdmCVL6SZYA1tDOMVBkrxGsfOobiKA1ItZjIf/yI713D6FU7bucc0gk2BHDG8+snZh
         ALlQ==
X-Gm-Message-State: AOAM530qDnrLFGKWDkevLjXZkcytHr4oPYnSxIYNme1juai8dR4r2CV6
        MVdOTcc82CIR5B9nC7S5PCoHL+u97kXDXw==
X-Google-Smtp-Source: ABdhPJxTZliArfzYy9vO3j/qg6/aPevSm9akngxStZgZbAek13d+gqEq+mShTQGqsY3qng6y2mVFlQ==
X-Received: by 2002:a1c:2b05:: with SMTP id r5mr13053926wmr.179.1608491906090;
        Sun, 20 Dec 2020 11:18:26 -0800 (PST)
Received: from [192.168.8.142] ([85.255.237.164])
        by smtp.gmail.com with ESMTPSA id r7sm15802727wmh.2.2020.12.20.11.18.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Dec 2020 11:18:25 -0800 (PST)
Subject: Re: [PATCH 1/1] io_uring: actively cancel poll/timeouts on exit
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org, Josef <josef.grieb@gmail.com>,
        Dmitry Kadashev <dkadashev@gmail.com>
References: <ea52c20eba8ab65ce1e716fe8627a1938a354268.1608491503.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <a195a207-db03-6e23-b642-0d04bf7777ec@gmail.com>
Date:   Sun, 20 Dec 2020 19:15:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <ea52c20eba8ab65ce1e716fe8627a1938a354268.1608491503.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20/12/2020 19:13, Pavel Begunkov wrote:
> If io_ring_ctx_wait_and_kill() haven't killed all requests on the first
> attempt, new timeouts or requests enqueued for polling may appear. They
> won't be ever cancelled by io_ring_exit_work() unless we specifically
> handle that case. That hangs of the exit work locking up grabbed by
> io_uring resources.

Josef and Dmitry, it would be great to have your Tested-by: <>
 
> Cc: <stable@vger.kernel.org> # 5.5+
> Cc: Josef <josef.grieb@gmail.com>
> Reported-by: Dmitry Kadashev <dkadashev@gmail.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 55 +++++++++++++++++++++++++++------------------------
>  1 file changed, 29 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index fbf747803dbc..c1acc668fe96 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8620,6 +8620,32 @@ static int io_remove_personalities(int id, void *p, void *data)
>  	return 0;
>  }
>  
> +static void io_cancel_defer_files(struct io_ring_ctx *ctx,
> +				  struct task_struct *task,
> +				  struct files_struct *files)
> +{
> +	struct io_defer_entry *de = NULL;
> +	LIST_HEAD(list);
> +
> +	spin_lock_irq(&ctx->completion_lock);
> +	list_for_each_entry_reverse(de, &ctx->defer_list, list) {
> +		if (io_match_task(de->req, task, files)) {
> +			list_cut_position(&list, &ctx->defer_list, &de->list);
> +			break;
> +		}
> +	}
> +	spin_unlock_irq(&ctx->completion_lock);
> +
> +	while (!list_empty(&list)) {
> +		de = list_first_entry(&list, struct io_defer_entry, list);
> +		list_del_init(&de->list);
> +		req_set_fail_links(de->req);
> +		io_put_req(de->req);
> +		io_req_complete(de->req, -ECANCELED);
> +		kfree(de);
> +	}
> +}
> +
>  static void io_ring_exit_work(struct work_struct *work)
>  {
>  	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
> @@ -8633,6 +8659,8 @@ static void io_ring_exit_work(struct work_struct *work)
>  	 */
>  	do {
>  		io_iopoll_try_reap_events(ctx);
> +		io_poll_remove_all(ctx, NULL, NULL);
> +		io_kill_timeouts(ctx, NULL, NULL);
>  	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
>  	io_ring_ctx_free(ctx);
>  }
> @@ -8654,6 +8682,7 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
>  		io_cqring_overflow_flush(ctx, true, NULL, NULL);
>  	mutex_unlock(&ctx->uring_lock);
>  
> +	io_cancel_defer_files(ctx, NULL, NULL);
>  	io_kill_timeouts(ctx, NULL, NULL);
>  	io_poll_remove_all(ctx, NULL, NULL);
>  
> @@ -8716,32 +8745,6 @@ static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
>  	return ret;
>  }
>  
> -static void io_cancel_defer_files(struct io_ring_ctx *ctx,
> -				  struct task_struct *task,
> -				  struct files_struct *files)
> -{
> -	struct io_defer_entry *de = NULL;
> -	LIST_HEAD(list);
> -
> -	spin_lock_irq(&ctx->completion_lock);
> -	list_for_each_entry_reverse(de, &ctx->defer_list, list) {
> -		if (io_match_task(de->req, task, files)) {
> -			list_cut_position(&list, &ctx->defer_list, &de->list);
> -			break;
> -		}
> -	}
> -	spin_unlock_irq(&ctx->completion_lock);
> -
> -	while (!list_empty(&list)) {
> -		de = list_first_entry(&list, struct io_defer_entry, list);
> -		list_del_init(&de->list);
> -		req_set_fail_links(de->req);
> -		io_put_req(de->req);
> -		io_req_complete(de->req, -ECANCELED);
> -		kfree(de);
> -	}
> -}
> -
>  static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>  				  struct task_struct *task,
>  				  struct files_struct *files)
> 

-- 
Pavel Begunkov
