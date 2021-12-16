Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E846E47750B
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 15:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235042AbhLPOx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 09:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235033AbhLPOx5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 09:53:57 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D27C061574
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 06:53:57 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id e5so11258942wrc.5
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 06:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KG5mUJCb01JBVoaJjxJq5z5Mbg9NI3DkFPoMmCWKgtA=;
        b=tXkbF8+YWd4gOWErWCGsurwAecwmMmEb5sLcYiZpyXKeV45pU0boB7BC5kpAdNhZdI
         1XDaQW6Hxr1HvExKvwT/Kv+/1/pWTM2tRBJ1340OfzMW3uMQZEqvy2IfIOqTYm8CB+6l
         B1AOz3n0fRVPnGba68gShCsF6DdGOPozeaeIhmUKqekts61vojn7YcofGXUQd3GS5K9M
         Qi0fgwcETp6hrnls5sSeorqJjAyN9KSyJjpM/aPpvfr47nDxPeXne4v2i9gqBU5BIYYW
         0ckXpSQsLJ6+K7Akh090r/T3cdLitBl4/k9Zva3ZiuFyGbpCnUBWtIrOgwimw4CGx0pT
         1vCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KG5mUJCb01JBVoaJjxJq5z5Mbg9NI3DkFPoMmCWKgtA=;
        b=6T9+8VrByASzwdk5jBZ7S9uJvc4Yz04zRMWkI8GlUAPgOMO2t/bX1Yu4bCqHBcCrTQ
         V9aeAH/cvT4UDm8woVFfTs9zJNGTt+C2eXcGINF30Zvc4fW3Cl2DhDcv/RScZ1QqDLw2
         0YLiaBQ4k+0O1Z0M8sbolYS69vPmdwLavApBnYLQ7Se+CcT1rINrlNzWEWwYSkGO6vp3
         QJz4eAvP9On+pQJNXVa78ra1GahmnHcnJ866lsIjBrsH0hQd7Pmr/HFtgieVqyi6EgQ7
         yIL+9U2sU6RZYfTNbuTr/7S6zBc+jnLaVtbRUSENVPzQDgwfQNj9HJInwPa2l0o5oCoW
         lnFg==
X-Gm-Message-State: AOAM5317ndcL4M8bg2AowEs3LYj9orv70anGcO6dLETcnXLvA1ZSzV8C
        t1ciBuepUmuCXAI98Y/OJDsAXo6hMD9tVozMCTZgjA==
X-Google-Smtp-Source: ABdhPJzUhHwUSvImATVgqMC5FL1L4V7zSStjnHjpE5HO34i+9pSD6eCC/BWuBLktw2uC755bv8oIu69YBOQ1AARE+S0=
X-Received: by 2002:a5d:4acb:: with SMTP id y11mr9440986wrs.64.1639666435831;
 Thu, 16 Dec 2021 06:53:55 -0800 (PST)
MIME-Version: 1.0
References: <20211216054725.3873834-1-sumit.garg@linaro.org>
In-Reply-To: <20211216054725.3873834-1-sumit.garg@linaro.org>
From:   Jens Wiklander <jens.wiklander@linaro.org>
Date:   Thu, 16 Dec 2021 15:53:44 +0100
Message-ID: <CAHUa44GtgYD7WNG+aia+1apwqEw1aBOYqxzrv1qwKW_wM5HGtA@mail.gmail.com>
Subject: Re: [PATCH v2] tee: optee: Fix incorrect page free bug
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     op-tee@lists.trustedfirmware.org, tyhicks@linux.microsoft.com,
        Patrik.Lantz@axis.com, lars.persson@axis.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 16, 2021 at 6:47 AM Sumit Garg <sumit.garg@linaro.org> wrote:
>
> Pointer to the allocated pages (struct page *page) has already
> progressed towards the end of allocation. It is incorrect to perform
> __free_pages(page, order) using this pointer as we would free any
> arbitrary pages. Fix this by stop modifying the page pointer.
>
> Fixes: ec185dd3ab25 ("optee: Fix memory leak when failing to register shm pages")
> Cc: stable@vger.kernel.org
> Reported-by: Patrik Lantz <patrik.lantz@axis.com>
> Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
> ---
>
> Changes since v1:
> - Added stable CC tag.
> - Picked up Tyler's review tag.
>
>  drivers/tee/optee/core.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

I'm picking up this.

Thanks,
Jens

>
> diff --git a/drivers/tee/optee/core.c b/drivers/tee/optee/core.c
> index ab2edfcc6c70..2a66a5203d2f 100644
> --- a/drivers/tee/optee/core.c
> +++ b/drivers/tee/optee/core.c
> @@ -48,10 +48,8 @@ int optee_pool_op_alloc_helper(struct tee_shm_pool_mgr *poolm,
>                         goto err;
>                 }
>
> -               for (i = 0; i < nr_pages; i++) {
> -                       pages[i] = page;
> -                       page++;
> -               }
> +               for (i = 0; i < nr_pages; i++)
> +                       pages[i] = page + i;
>
>                 shm->flags |= TEE_SHM_REGISTER;
>                 rc = shm_register(shm->ctx, shm, pages, nr_pages,
> --
> 2.25.1
>
