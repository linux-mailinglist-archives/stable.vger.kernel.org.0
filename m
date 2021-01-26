Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46DB4305108
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 05:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239283AbhA0Ejh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 23:39:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728833AbhA0AUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 19:20:07 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2A5C0698C2;
        Tue, 26 Jan 2021 15:41:00 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id r12so90315ejb.9;
        Tue, 26 Jan 2021 15:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xuTN9aZIYreTv1ji2Tqw+quSeWAQAiHw/YoS4yo7cuw=;
        b=g3kKbX1RvhEDw37pYXd0R+MCmkFJt+KRbSRytPVIQR9iABf/S8QU4xcU5RKupZ8+JJ
         /a0/kad0wwV+n66+2a7bkHRRyv6F2fGaydbSNauan1TaZqR/q9S6bJDwPE1722tDyo5v
         G9m0h5Nz9A2lQxowCkCO7IP/GWd7Qv9VuIujPSA2DS0+yOW5FlBBxvu8nLteCHWSoUYp
         VhQ3Ekt1xbsR91llHpelTZv/Ral6PPmITadH5HnDr0WB04UsDsDQEmwgfSrE4nJujwfE
         fz1arx/aSzSfoI1DHq2CeSERop/xEUOqqagqogww4qprOl6KH88KloQ4RQhoWl3WsEh8
         69mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=xuTN9aZIYreTv1ji2Tqw+quSeWAQAiHw/YoS4yo7cuw=;
        b=Pg3JKwN/7QSywk5bBhsKe38stI+MPJN0pyEoU/5C50nJ7pD7gB6VDmwljrpRruSus/
         AusWJAW2LHeilGGMLhPWzheqpJQqzXCEnlKWZMQym37QaSNDhBTa6qhzqUQzENatZgz0
         NH2PCNt6ptLZHXfFTlex9hcvjp407+dggk+rt79px1MDHdFPP7WLxYpuAO83XvGGT9yE
         pj06PXB1b4aq96hturOOEKMVhiclqHWUVxT3bZWvXqKtItjszgI56OdN4JtAOr23wncI
         BkZEizkiH9ia0J3b7XvL17IVbp+EWp4ZAtXvK6dgDmI37VSvk5hpeZDVfecPLyL9vuw6
         cjcg==
X-Gm-Message-State: AOAM532QrptaDfLCydnFsUDYcQsUI9UmonO3o6Ap+97jDw0ZN1NkYxFl
        nbDDnRCp4Pq9OiPcGpL3/5M=
X-Google-Smtp-Source: ABdhPJzIUbICSpYS5cgjOF6o4WAsQGHo4YCTdECJPHLW8idAhIr/eZdqVTPmpJ/i0COuEr9DriiLMA==
X-Received: by 2002:a17:906:538c:: with SMTP id g12mr4931202ejo.248.1611704458964;
        Tue, 26 Jan 2021 15:40:58 -0800 (PST)
Received: from [192.168.8.159] ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id x5sm166992edi.35.2021.01.26.15.40.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 15:40:58 -0800 (PST)
Subject: Re: [PATCH 5.11] io_uring: fix wqe->lock/completion_lock deadlock
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <9c4f7eb623ae774f3f17afbc1702749480ee19be.1611703952.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <edc3eca8-e1b7-bae2-8870-08e68b1905d8@gmail.com>
Date:   Tue, 26 Jan 2021 23:37:18 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <9c4f7eb623ae774f3f17afbc1702749480ee19be.1611703952.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26/01/2021 23:35, Pavel Begunkov wrote:
> Joseph reports following deadlock:
> 
> CPU0:
> ...
> io_kill_linked_timeout  // &ctx->completion_lock
> io_commit_cqring
> __io_queue_deferred
> __io_queue_async_work
> io_wq_enqueue
> io_wqe_enqueue  // &wqe->lock
> 
> CPU1:
> ...
> __io_uring_files_cancel
> io_wq_cancel_cb
> io_wqe_cancel_pending_work  // &wqe->lock
> io_cancel_task_cb  // &ctx->completion_lock
> 
> Only __io_queue_deferred() calls queue_async_work() while holding
> ctx->completion_lock, enqueue drained requests via io_req_task_queue()
> instead.

Joseph, can you try it out? would much appreciate

> 
> Cc: stable@vger.kernel.org # 5.9+
> Reported-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index bb0270eeb8cb..c218deaf73a9 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1026,6 +1026,7 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
>  			     const struct iovec *fast_iov,
>  			     struct iov_iter *iter, bool force);
>  static void io_req_drop_files(struct io_kiocb *req);
> +static void io_req_task_queue(struct io_kiocb *req);
>  
>  static struct kmem_cache *req_cachep;
>  
> @@ -1634,18 +1635,11 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
>  	do {
>  		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
>  						struct io_defer_entry, list);
> -		struct io_kiocb *link;
>  
>  		if (req_need_defer(de->req, de->seq))
>  			break;
>  		list_del_init(&de->list);
> -		/* punt-init is done before queueing for defer */
> -		link = __io_queue_async_work(de->req);
> -		if (link) {
> -			__io_queue_linked_timeout(link);
> -			/* drop submission reference */
> -			io_put_req_deferred(link, 1);
> -		}
> +		io_req_task_queue(de->req);
>  		kfree(de);
>  	} while (!list_empty(&ctx->defer_list));
>  }
> 

-- 
Pavel Begunkov
