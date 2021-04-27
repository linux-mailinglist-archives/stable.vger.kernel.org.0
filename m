Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE49236C6B9
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 15:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236734AbhD0NJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 09:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236412AbhD0NJO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 09:09:14 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFE0C061574;
        Tue, 27 Apr 2021 06:08:29 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id x7so59369603wrw.10;
        Tue, 27 Apr 2021 06:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bJvGh786pSp2+xw3WDqNmNqzwSTVt/HxDfR6swJxO7U=;
        b=fbX8M4MqzmIkM9qDTRgc5EzsDkrUI0Azseg5GVTTKdgikdabvyqQSI5C5bilUR/xEA
         T8lBtrqy4rTEh40PCxq5ynTSYpWF6RCzL6IRfNr/yEDDV8x2gb6/T5lYFPFlihNX7Y/t
         o/N43VG+cnkSLeyID+GwzZDx4UOIVNOdBp7cWv7u0vjgLOVZtRTssXAt8P+n0VVZh8p3
         JwyZ9TYIQulx/N6JWidn92mfFuFMGpWf2iEEUZ2qPYj0ynkMsldgdmzO5w2+CJx937Pv
         GVN8qwVX+gzGGKjDWFbt5hdrGynp/JLMuED0D2CJfpPGb+tDrzbqyHGLTW7H6Qnp0r0Q
         HpxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bJvGh786pSp2+xw3WDqNmNqzwSTVt/HxDfR6swJxO7U=;
        b=S1TNYuMzsEtNQ1GFKCj6L8oatBByMeXOf1bWltnh7jXhPtGw+j4xJgcpp2lmmg4uKR
         pVq6EuRjF8WOb5WpqQK4qov+2P72qAAXq45EPTVrsH7Hf/00xToSonMRWDp+pYRg+VYU
         tpSsfvKf7bD0yOyjnsVOoiaKUtzPB2XAQ/caMacS/p1J+M8aUVKUOKARpTpr/JG/EPAZ
         PSLWqcvV+1xqayJqllRmCOlreAa0HjV4sH07ILhpKspPrRkDL2cXrsX6rhg3BBPCHDl7
         VEnoPGFauKlQqehHTZBepisBxtpOKYu4Qp8U0d6iI11oPNNiKmArYKbo9tAeCql4U3Tn
         in4w==
X-Gm-Message-State: AOAM5321FTi7nktE/n8kCXa9BUp90hhQ++kG2yyc27d3wNVle/0pvaU+
        +bvmjRox/4gVNk2F+PY3sX4/zhVxZOo=
X-Google-Smtp-Source: ABdhPJzOFW0aS5C+74hkZzL1CAWbA01ZyOn9wZWdt0HgHK5C6Sp5UO0iMAA6u/ozFtZbZC3sCiwxGA==
X-Received: by 2002:a05:6000:2ad:: with SMTP id l13mr28691618wry.417.1619528908268;
        Tue, 27 Apr 2021 06:08:28 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.129.131])
        by smtp.gmail.com with ESMTPSA id i2sm1005054wro.0.2021.04.27.06.08.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Apr 2021 06:08:27 -0700 (PDT)
Subject: Re: [PATCH 5.13] io_uring: Check current->io_uring in
 io_uring_cancel_sqpoll
To:     Palash Oswal <hello@oswalpalash.com>
Cc:     axboe@kernel.dk, dvyukov@google.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, oswalpalash@gmail.com,
        syzbot+be51ca5a4d97f017cd50@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, stable@vger.kernel.org
References: <e67b2f55-dd0a-1e1f-e34b-87e8613cd701@gmail.com>
 <20210427125148.21816-1-hello@oswalpalash.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <b62f1985-f336-d0ec-bcdc-5dac16fb760b@gmail.com>
Date:   Tue, 27 Apr 2021 14:08:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210427125148.21816-1-hello@oswalpalash.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/27/21 1:51 PM, Palash Oswal wrote:
> syzkaller identified KASAN: null-ptr-deref Write in
> io_uring_cancel_sqpoll on v5.12
> 
> io_uring_cancel_sqpoll is called by io_sq_thread before calling
> io_uring_alloc_task_context. This leads to current->io_uring being
> NULL. io_uring_cancel_sqpoll should not have to deal with threads
> where current->io_uring is NULL.
> 
> In order to cast a wider safety net, perform input sanitisation
> directly in io_uring_cancel_sqpoll and return for NULL value of
> current->io_uring.

Looks good to me, but better to add a comment why it can be ignored,
e.g. "can skip it as it couldn't have submitted requests without tctx"

Also a nit: s/current->io_uring/tctx/

> 
> Reported-by: syzbot+be51ca5a4d97f017cd50@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Palash Oswal <hello@oswalpalash.com>
> ---
>  fs/io_uring.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index dff34975d86b..eccad51b7954 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8998,6 +8998,8 @@ static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx)
>  	s64 inflight;
>  	DEFINE_WAIT(wait);
>  
> +	if (!current->io_uring)
> +		return;
>  	WARN_ON_ONCE(!sqd || ctx->sq_data->thread != current);
>  
>  	atomic_inc(&tctx->in_idle);
> 

-- 
Pavel Begunkov
