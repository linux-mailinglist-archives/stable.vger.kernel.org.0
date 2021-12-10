Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61BBC46FB3A
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 08:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237435AbhLJHYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 02:24:40 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:54860 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237181AbhLJHYk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 02:24:40 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0V-8HLik_1639120863;
Received: from 30.226.12.31(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V-8HLik_1639120863)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 10 Dec 2021 15:21:04 +0800
Subject: Re: [PATCH 1/2] io_uring: check tctx->in_idle when decrementing
 inflight_tracked
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20211209155956.383317-1-axboe@kernel.dk>
 <20211209155956.383317-2-axboe@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <2c527587-36c4-900b-bda6-1357d9bb5ba0@linux.alibaba.com>
Date:   Fri, 10 Dec 2021 15:21:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211209155956.383317-2-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


在 2021/12/9 下午11:59, Jens Axboe 写道:
> If we have someone potentially waiting for tracked requests to finish,
> ensure that we check in_idle and wake them up appropriately.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---

Hi Jens,

I saw every/several( in batching cases)  io_clean_op() followed by an 
io_put_task() which does the same thing

as this patch, so it seems this one is not neccessary? Correct me if I'm 
wrong since I haven't touch this code for

a long time.


Regards,
Hao

>   fs/io_uring.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index c4f217613f56..b4d5b8d168bf 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6640,6 +6640,8 @@ static void io_clean_op(struct io_kiocb *req)
>   		struct io_uring_task *tctx = req->task->io_uring;
>   
>   		atomic_dec(&tctx->inflight_tracked);
> +		if (unlikely(atomic_read(&tctx->in_idle)))
> +			wake_up(&tctx->wait);
>   	}
>   	if (req->flags & REQ_F_CREDS)
>   		put_cred(req->creds);
