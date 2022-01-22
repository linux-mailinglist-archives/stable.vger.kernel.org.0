Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B227B496A1B
	for <lists+stable@lfdr.de>; Sat, 22 Jan 2022 06:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiAVFAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 00:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiAVFAd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 00:00:33 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6E9C06173B;
        Fri, 21 Jan 2022 21:00:33 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id m1so38107526lfq.4;
        Fri, 21 Jan 2022 21:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0xeo+SxRyYCcfYG4yaBPKLDDT2PHvbm7TvCVnMGHbRo=;
        b=Q3+5sdezWsb9CJOHU0O9DYlmHwdMDuhxH9Cqb7/UDMgZ23mf5TWsjAG5DRcgqupdtm
         5t6n3TO2IZ8tBgdbxICrepvjAkNYBhWtw5TA+J0De6sgy5TqROReA9Sphzud+9FAv7J5
         JzC8RxS9a7OvLaiBPED8elte/U8Ezh518K+WqQE01xbWy9SAY5tAoK0KfWU87/RpsgAI
         6Vq5b+DVnQfm/L1oydlWqVlKBGSEt7hmJkBTk9eOk24lt97+KB6bLmGKWTw9hTWDILuW
         Jaa1kcjsg1qkqXJTh7yubm4UO2E/X+J4/XlDK3tXUqD3WHjEQnfAeHuy2uRDtqxUtmLt
         rryQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0xeo+SxRyYCcfYG4yaBPKLDDT2PHvbm7TvCVnMGHbRo=;
        b=qYgdmIJzsBMY2dwn55HbqDbQ16NQNU1vXlo5u9rMhrzx0GYzrZBuisC6SY9uKE43Vn
         dRMTBOc9ziWdwK64eA/C26M+QR3lOqGA3elna3sN2H0lqEtCi5X7VSl5IWE+HtXNXSoY
         b7u52I8EBNdJP8UjdMIW4C9NMbYjxAvAb5DToozBFgBHZRe3zd67vouTGGmsWXJFg8UC
         8X0bxnXtOw602bEk1xCDm1FfIzfrcP+HvOBe7AuIAAOLqdP9QOglTSpGt7Ryor4Mq0Qw
         ikO8ur3g7bRTRTsTipIeZx0rhikJVLGDqCOJPsxODlePyrPpofJUEYtROvOHgPQ/Qaz8
         B6Zg==
X-Gm-Message-State: AOAM532fsBVDROzVrpXW9MSpmmpuHWn6XwC+W91W/XtHZgQpVk7zKa6P
        Bnf5LAWsAtpMb8yfCJ4BxZiRZ9+zY8Qi9/Y6GbiQ7a1Y
X-Google-Smtp-Source: ABdhPJzyLyKQSE3yGS6yvUyUgEBFiVbytTVC5iOADZHou+8bgJ1Omsq/v+ZM9xF1aadukOS7nSBws3CjrPhP/Zi00ng=
X-Received: by 2002:ac2:4c41:: with SMTP id o1mr6289241lfk.545.1642827631340;
 Fri, 21 Jan 2022 21:00:31 -0800 (PST)
MIME-Version: 1.0
References: <20220122014722.8699-1-linkinjeon@kernel.org>
In-Reply-To: <20220122014722.8699-1-linkinjeon@kernel.org>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 21 Jan 2022 23:00:20 -0600
Message-ID: <CAH2r5mugHc1wLtmQsnubUEJo_oHwC1W2ywyEnjFi2ePWdRiWiA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix SMB 3.11 posix extension mount failure
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good.  I tested it and it works.

With this I can see some additional things work e.g. "stat /mnt/file"
shows the correct mode bits, but the owner and group are reported as
the default (0) instead of the actual uid/gid

On Fri, Jan 21, 2022 at 7:47 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> cifs client set 4 to DataLength of create_posix context, which mean
> Mode variable of create_posix context is only available. So buffer
> validation of ksmbd should check only the size of Mode except for
> the size of Reserved variable.
>
> Fixes: 8f77150c15f8 ("ksmbd: add buffer validation for SMB2_CREATE_CONTEXT")
> Cc: stable@vger.kernel.org # v5.15+
> Reported-by: Steve French <smfrench@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ksmbd/smb2pdu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 1866c81c5c99..3926ca18dca4 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -2688,7 +2688,7 @@ int smb2_open(struct ksmbd_work *work)
>                                         (struct create_posix *)context;
>                                 if (le16_to_cpu(context->DataOffset) +
>                                     le32_to_cpu(context->DataLength) <
> -                                   sizeof(struct create_posix)) {
> +                                   sizeof(struct create_posix) - 4) {
>                                         rc = -EINVAL;
>                                         goto err_out1;
>                                 }
> --
> 2.25.1
>


-- 
Thanks,

Steve
