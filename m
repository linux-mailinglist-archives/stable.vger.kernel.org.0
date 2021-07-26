Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E513D5CDC
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234823AbhGZOmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 10:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233937AbhGZOmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 10:42:05 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B36EC061757
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 08:22:33 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id h24-20020a1ccc180000b029022e0571d1a0so231996wmb.5
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 08:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GrI9+wrVwRvoOtwRhsj0ZOHoAXVgzNQabddLbvKeEu4=;
        b=gpEB7bSVcfOM04/zIHTgYBY5gzTaysqMYIt4xjW2YGbX1HBr3czOlu7FPmWfV2aYV6
         qDTTaZxjoPt+TS2OIa3ug7GP4aK081ARIzabRwMayRBELjd/fPG7AMBYHFe7rwUn4rBO
         lfaXLJCIf/hE8Lu/sIt4e3Ee/N+Z9oPItsmXiWNyNi8ia+CjFZbXWtmZAe7F4TOnCQax
         L9pG5gZ0stUr+9hpvL+qqm5IMqRcE25hfJTvxcm2cZ2NJJB7hy/9yMNmCdHS65xsGOsT
         5PN2vo8z9FEfW1B/HFYVMLN09nMenzM+OHnEo5vn7Cm72TCBBrDA2R1ffKgmQtZZ9J1H
         NlSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GrI9+wrVwRvoOtwRhsj0ZOHoAXVgzNQabddLbvKeEu4=;
        b=VijkKIltNnIU2m4xyeujLH8jyEKxtK30oCtGQmTq+jHx/eu6yflD9qSxiPfpIWa1kv
         ZGEuJog2OxcZymxjHifz9xLhXHmtT75Myd+X5pOdlmvQIUukhWiYuBSHGIsLMvN2YNEG
         xiYZUWgmexdH5DvG2x7e0MLWoUCePz84l8NFr84IjC2GqoARrDjGJ7kce24FGhqpNyM8
         d55oszdfjWCZ+H6nrsF5VzzdQ1/XVUxOTujf5Le757SL4T7ECyrHmd15ohEB99ccGtYR
         xuEJQcvfJvLc5iuprxh8l8Pp5jnOVETu+fznh2BtOPR08rKxZaGdT6UQqeNboNPiX1Uu
         prgg==
X-Gm-Message-State: AOAM531mVJNso/hN8J8rZIfm8nxVG9WrHXK9zy6k8sYxCKbGNxLsT2IT
        JAjwOMB6cz7NxyYI+DOZ3yY=
X-Google-Smtp-Source: ABdhPJzGpAb6sEZ8aq21vQWwY4NZFZpUy30q2OKyMAMOYUNk7K5TpxWWhOUt5PnMzH6WZaMbpGMZgg==
X-Received: by 2002:a05:600c:19cb:: with SMTP id u11mr13401747wmq.1.1627312952034;
        Mon, 26 Jul 2021 08:22:32 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.244])
        by smtp.gmail.com with ESMTPSA id p4sm77516wre.83.2021.07.26.08.22.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 08:22:31 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix link timeout refs
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        syzbot+a2910119328ce8e7996f@syzkaller.appspotmail.com
References: <caf9dc2dc29367bb38fee4064b7d562d9837e441.1627312513.git.asml.silence@gmail.com>
Message-ID: <6564af0e-72b0-5308-4561-706ec4026385@gmail.com>
Date:   Mon, 26 Jul 2021 16:22:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <caf9dc2dc29367bb38fee4064b7d562d9837e441.1627312513.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/26/21 4:17 PM, Pavel Begunkov wrote:
> [ Upstream commit a298232ee6b9a1d5d732aa497ff8be0d45b5bd82 ]

Looking at it, it just reverts the backported patch,
i.e. 0b2a990e5d2f76d020cb840c456e6ec5f0c27530.
Wasn't needed in 5.10 in the first place.

Sudip, would be great if you can try it out


> WARNING: CPU: 0 PID: 10242 at lib/refcount.c:28 refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
> RIP: 0010:refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
> Call Trace:
>  __refcount_sub_and_test include/linux/refcount.h:283 [inline]
>  __refcount_dec_and_test include/linux/refcount.h:315 [inline]
>  refcount_dec_and_test include/linux/refcount.h:333 [inline]
>  io_put_req fs/io_uring.c:2140 [inline]
>  io_queue_linked_timeout fs/io_uring.c:6300 [inline]
>  __io_queue_sqe+0xbef/0xec0 fs/io_uring.c:6354
>  io_submit_sqe fs/io_uring.c:6534 [inline]
>  io_submit_sqes+0x2bbd/0x7c50 fs/io_uring.c:6660
>  __do_sys_io_uring_enter fs/io_uring.c:9240 [inline]
>  __se_sys_io_uring_enter+0x256/0x1d60 fs/io_uring.c:9182
> 
> io_link_timeout_fn() should put only one reference of the linked timeout
> request, however in case of racing with the master request's completion
> first io_req_complete() puts one and then io_put_req_deferred() is
> called.
> 
> Cc: stable@vger.kernel.org # 5.12+
> Fixes: 9ae1f8dd372e0 ("io_uring: fix inconsistent lock state")
> Reported-by: syzbot+a2910119328ce8e7996f@syzkaller.appspotmail.com
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Link: https://lore.kernel.org/r/ff51018ff29de5ffa76f09273ef48cb24c720368.1620417627.git.asml.silence@gmail.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 42153106b7bc..42439838eaf7 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6260,7 +6260,6 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
>  	if (prev) {
>  		io_async_find_and_cancel(ctx, req, prev->user_data, -ETIME);
>  		io_put_req_deferred(prev, 1);
> -		io_put_req_deferred(req, 1);
>  	} else {
>  		io_cqring_add_event(req, -ETIME, 0);
>  		io_put_req_deferred(req, 1);
> 

-- 
Pavel Begunkov
