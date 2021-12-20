Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB8F47B36B
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 20:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240682AbhLTTG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 14:06:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234213AbhLTTGX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 14:06:23 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451B0C06173F
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 11:06:23 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id k21so5765520lfu.0
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 11:06:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6ih+OZifVnNfA/pSv3qRAPIHOXmc5ub5T4okFRSsryU=;
        b=a1+ZPRgM0N04BQMXXDijj417WU8sL4jlUQ04ppDhgKjXom6+7Z4rwLXR6QX+tZ51RQ
         DuaNhJ/Y5vmawfKm92tiIc7T5vIb3EuZ4KI9/jQdE9ghrS3ulZ6F57QAgDyDAhiEkkOE
         s1jlUQF4u6FOMjWznVModYLHXbNyEaUD2hLX6Tp1d+Mgea6Eo340ovYW/g05KJ0FoZDa
         eT+wTa3vfcD8xA3Kt8B5Apfar7SiuYKPXZQgid9kitBfA+jhy5kfWu8ZsBb5/m6qy6JX
         jyeYrPVWHPk9HBw5BOnK/kThTrvF6xbtJBD5At+ZGvK037oe0gv7maiEF/pgjbyUn+or
         2iPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6ih+OZifVnNfA/pSv3qRAPIHOXmc5ub5T4okFRSsryU=;
        b=ym8z+LfGwKG56LkHVMINTgE1bA6U9kIulDjGQTdpv9znKRLFpSK+AmnS6oue0fYGO1
         CzvpMSSZ5r5WAXMienkrsKwxde0GCePWrKpNZrAcrJz4la7DMnSOSxXnNJeTES1ZZgvJ
         GkCWmruUAjwDk6QyUW+gCEBApFXwBkWKVaqdxti6vXGll13FH8qe7AyICPWy19XbsS+E
         VGHgh+wL0SOXN19Vsg7ugCJuemDBWbBFiDPe+iLPWGKyzEPngvEqWX2u1q/zNVVcv+wL
         NS/dBGWLR8jOoeFDMC5g5RTZpftRrJfu3E4UraodECJ+fZQ3tXBm59xXf3pMbTJqiSg5
         /sTw==
X-Gm-Message-State: AOAM531Gu0RquSLT1KYwgw9o7vXm7XgAfR2Pz1bqBVdOlNFhOtxQ4lp5
        6p/q2jRnTwyTpt7Fy9rQ4WVY7oglOvroOfdSpIOdig==
X-Google-Smtp-Source: ABdhPJxt/GrhGIBD3Rsq6dAv0bDvoKbp5GHKXPNxZ7Wv38eMaBgjqPj0v5gqgh0m8NKzYlAAyqnDqY/TB6zUFXJI2Bk=
X-Received: by 2002:a05:6512:3047:: with SMTP id b7mr10551009lfb.424.1640027181280;
 Mon, 20 Dec 2021 11:06:21 -0800 (PST)
MIME-Version: 1.0
References: <20211220190150.2107077-1-tkjos@google.com>
In-Reply-To: <20211220190150.2107077-1-tkjos@google.com>
From:   Todd Kjos <tkjos@google.com>
Date:   Mon, 20 Dec 2021 11:06:09 -0800
Message-ID: <CAHRSSExTHHOdqEnRF0g435BrO5L-X6M3pxPg3OmLz8xUWDuNKA@mail.gmail.com>
Subject: Re: [PATCH] binder: fix async_free_space accounting for empty parcels
To:     tkjos@google.com, gregkh@linuxfoundation.org, christian@brauner.io,
        arve@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, maco@google.com
Cc:     joel@joelfernandes.org, kernel-team@android.com,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 11:02 AM Todd Kjos <tkjos@google.com> wrote:
>
> In 4.13, commit 74310e06be4d ("android: binder: Move buffer out of area shared with user space")
> fixed a kernel structure visibility issue. As part of that patch,
> sizeof(void *) was used as the buffer size for 0-length data payloads so
> the driver could detect abusive clients sending 0-length asynchronous
> transactions to a server by enforcing limits on async_free_size.
>
> Unfortunately, on the "free" side, the accounting of async_free_space
> did not add the sizeof(void *) back. The result was that up to 8-bytes of
> async_free_space were leaked on every async transaction of 8-bytes or
> less.  These small transactions are uncommon, so this accounting issue
> has gone undetected for several years.
>
> The fix is to use "buffer_size" (the allocated buffer size) instead of
> "size" (the logical buffer size) when updating the async_free_space
> during the free operation. These are the same except for this
> corner case of asynchronous transactions with payloads < 8 bytes.
>
> Fixes: 74310e06be4d ("android: binder: Move buffer out of area shared with user space")
> Signed-off-by: Todd Kjos <tkjos@google.com>

I forgot to CC stable. This applies to all stable branches back to 4.14.
Cc: stable@vger.kernel.org # 4.14+

> ---
>  drivers/android/binder_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
> index 340515f54498..47bc74a8c7b6 100644
> --- a/drivers/android/binder_alloc.c
> +++ b/drivers/android/binder_alloc.c
> @@ -671,7 +671,7 @@ static void binder_free_buf_locked(struct binder_alloc *alloc,
>         BUG_ON(buffer->user_data > alloc->buffer + alloc->buffer_size);
>
>         if (buffer->async_transaction) {
> -               alloc->free_async_space += size + sizeof(struct binder_buffer);
> +               alloc->free_async_space += buffer_size + sizeof(struct binder_buffer);
>
>                 binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC_ASYNC,
>                              "%d: binder_free_buf size %zd async free %zd\n",
> --
> 2.34.1.307.g9b7440fafd-goog
>
