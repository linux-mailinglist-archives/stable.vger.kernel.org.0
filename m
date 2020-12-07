Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF272D1898
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 19:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgLGSfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 13:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgLGSfp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 13:35:45 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10D5C061749;
        Mon,  7 Dec 2020 10:35:04 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id x22so136228wmc.5;
        Mon, 07 Dec 2020 10:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/Z9lhLCbqim12y0oyf9t8xB8QwPHbNuf0ibPEkCv34Q=;
        b=KewT2AVaP7+nJNdtAh01lczfDEjYBSryYaqyWsrB6FmiVl0zN6jsg8tmQ45LM0pCMt
         qY7mpYjR6DGdWnrVfdMkJGoU1XWodOcd3joq5hNeg0fy1y+Zq7v9pU4xxyXB+JXjUCzk
         68kJLHQMmYo5/60rUyCLd4Df+N39gHFMLclc7qpZh6lSrOUYpHA7ExokrmPuRIETES2G
         VBs1GvvutuyOUDFxpH6wEP1pxS5/7vYbuEBE0CjR9TWfuxDuJuLYtW3nrrTvF03WAu2f
         exBB7q9JFzJKrfvHvxH/apa9tGZNSP3Z7sjgDOJspVY9DMVByQQMpRPoSDyxZGA2+y3l
         7MDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=/Z9lhLCbqim12y0oyf9t8xB8QwPHbNuf0ibPEkCv34Q=;
        b=msPvOk3X/t9mN1A5qhmyI23vKT10UAMvBCejTUWDTvKsgT/lKyqpv0/zruNsHLO5b3
         9fR5f78nwLoEWIB4QJuWqiD5u6jI9XWZdKuHoCef/DoBZ8hhDyL5aVIDyEAdS38Rs18f
         FplIBnGS5xjF8DF7XIX4LYDnSHxuYjMaItzk+ciSuBMli3Wk6GuggREh23I89IzlX4jq
         J2XZ9a/9hueRBHWpVHpZ7T7/QoPSJXqJdH3Swq/zCkyVApMd0qp+w4ukXIzjq5aTM5Zg
         wwVKn/S8A0IPrw8rtPaCcndyWq9S3Ngrk8qKSGh8m9HQetnapR1MF3YaIGa+0ALQSJpP
         jzhg==
X-Gm-Message-State: AOAM530o/SQw4cBqYLD7Qv4XNez62AFgW2KNLUIqFuElgi0d2mjxIxpq
        6tLdaK8rbMQX9vq4qDgSDdGvvRh9q0OAhg==
X-Google-Smtp-Source: ABdhPJwumYrBLIoQHxgdphKEhshbuJO6JHyBRU3ddB+2L5EExdb/46lOq8XXZHOt+TYkhlOpYDa1KQ==
X-Received: by 2002:a1c:7dd8:: with SMTP id y207mr110324wmc.181.1607366102841;
        Mon, 07 Dec 2020 10:35:02 -0800 (PST)
Received: from [192.168.8.107] ([185.69.145.78])
        by smtp.gmail.com with ESMTPSA id b14sm16447438wrx.35.2020.12.07.10.35.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 10:35:02 -0800 (PST)
Subject: Re: [PATCH 5.10 2/5] io_uring: fix racy IOPOLL completions
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <cover.1607293068.git.asml.silence@gmail.com>
 <3a8d4b11f6cbb28c5067fd77ba35c2995f4658be.1607293068.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <217e7f26-ef7f-672a-777b-9e9346faed9e@gmail.com>
Date:   Mon, 7 Dec 2020 18:31:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <3a8d4b11f6cbb28c5067fd77ba35c2995f4658be.1607293068.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/12/2020 22:22, Pavel Begunkov wrote:
> IOPOLL allows buffer remove/provide requests, but they doesn't
> synchronise by rules of IOPOLL, namely it have to hold uring_lock.
> 
> Cc: <stable@vger.kernel.org> # 5.7+
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index c895a306f919..4fac02ea5f4c 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3948,11 +3948,17 @@ static int io_remove_buffers(struct io_kiocb *req, bool force_nonblock,
>  	head = idr_find(&ctx->io_buffer_idr, p->bgid);
>  	if (head)
>  		ret = __io_remove_buffers(ctx, head, p->bgid, p->nbufs);
> -
> -	io_ring_submit_lock(ctx, !force_nonblock);

Here should be unlock(), not a second lock(). I didn't notice
first, but the patch fixes it. maybe for 5.10?

>  	if (ret < 0)
>  		req_set_fail_links(req);
> -	__io_req_complete(req, ret, 0, cs);
> +
> +	/* need to hold the lock to complete IOPOLL requests */
> +	if (ctx->flags & IORING_SETUP_IOPOLL) {
> +		__io_req_complete(req, ret, 0, cs);
> +		io_ring_submit_unlock(ctx, !force_nonblock);
> +	} else {
> +		io_ring_submit_unlock(ctx, !force_nonblock);
> +		__io_req_complete(req, ret, 0, cs);
> +	}
>  	return 0;
>  }


-- 
Pavel Begunkov
