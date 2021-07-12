Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9DC3C4EEE
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236706AbhGLHWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:22:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52036 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343696AbhGLHUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 03:20:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626074233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jEQNuaft8PiLhWt6Cm320nOG2EJp568ZWWs6YU/oQ8I=;
        b=D7hvVomCv86kw1QpDm9cQbrCTRDSzzJVXqKq3YAHA6xH5DHP6e0I8XoOz8CNg81ne6qBz8
        I1Y+0nprIvMYgMUAZEijOrTALRsKaQLtZ+krpiAs2UT5ytH/X8WBRainx7yW1c9ge2ngER
        Ju+KhSMIy/fA1M8XoB7zNTqB7oDEj8A=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-hzk6HRmtN8mR-7SG66n-tQ-1; Mon, 12 Jul 2021 03:17:12 -0400
X-MC-Unique: hzk6HRmtN8mR-7SG66n-tQ-1
Received: by mail-qv1-f69.google.com with SMTP id p12-20020a0cfacc0000b02902a1b4396bc4so13662784qvo.22
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 00:17:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jEQNuaft8PiLhWt6Cm320nOG2EJp568ZWWs6YU/oQ8I=;
        b=EDbmU9Ijd7zZEqARuNN/6hgOt5/gbyC2krVYz+QZHgZMxKZ1hFfc/JfTa8LpZdRFn/
         sGeuMPL97hqEoJZs/w71wmtO6pYhr6jlSJgIUyyadikvsRNPWjdZo2Tyq6gCDy/S49yq
         aFI4eOePvcFazuIv4a9BY6jivCwYJm5/SKBv2PH/fLJ/gpiPKpgrnAxvVmFQ9iCfRFXw
         eOyUg84jTY3YHhqWbck9QnRmSh3v5mYfpy0zSpZMh3XxRQpKdyDk2np0U68o/YgwPuFX
         HoU9ebDA0N1uPyg3DkS487p286DjpI8GhgkJD+7pPrN6TQoaXngoZktpvaV7UizlAHR2
         9UhQ==
X-Gm-Message-State: AOAM530RM1o3+CE8GS/yJ68FsD0R0Ab8hV84cclX7ufyt1EcxFdCei46
        zrzn1aDigH/WazigS4PoGDem1TZCF6MHAsftFEhpMQ5l1xLahqjlv+fpTJwql9kQ7DsUYI/q5Yd
        QJdrduQBjs8l4ans/yfWTYLoZhM/rxN24
X-Received: by 2002:a0c:a286:: with SMTP id g6mr5866863qva.16.1626074231631;
        Mon, 12 Jul 2021 00:17:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxaAIb7Km8NeI2/Gm8NOAQGPrK8zvlJXvKpsAGwyyEmB6bVjdct2Fn4iur1NdzPvO81uJAG3b50KvSI6hSO1M8=
X-Received: by 2002:a0c:a286:: with SMTP id g6mr5866842qva.16.1626074231328;
 Mon, 12 Jul 2021 00:17:11 -0700 (PDT)
MIME-Version: 1.0
References: <1626009119113182@kroah.com>
In-Reply-To: <1626009119113182@kroah.com>
From:   Miklos Szeredi <mszeredi@redhat.com>
Date:   Mon, 12 Jul 2021 09:17:00 +0200
Message-ID: <CAOssrKeWW6P5d5-kk6GH_HV6QsinQpTDhXaCHzSFwtw4JXfvnw@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] fuse: reject internal errno" failed to
 apply to 4.19-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     anatoly.trosinenko@gmail.com, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Please apply with --fuzz=3 (though I don't really see why this is
needed, since there's just a single line of difference in the
context).

Should work for backports to all previous versions.

Thanks,
Miklos

On Sun, Jul 11, 2021 at 3:20 PM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From 49221cf86d18bb66fe95d3338cb33bd4b9880ca5 Mon Sep 17 00:00:00 2001
> From: Miklos Szeredi <mszeredi@redhat.com>
> Date: Tue, 22 Jun 2021 09:15:35 +0200
> Subject: [PATCH] fuse: reject internal errno
>
> Don't allow userspace to report errors that could be kernel-internal.
>
> Reported-by: Anatoly Trosinenko <anatoly.trosinenko@gmail.com>
> Fixes: 334f485df85a ("[PATCH] FUSE - device functions")
> Cc: <stable@vger.kernel.org> # v2.6.14
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
>
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 6e63bcba2a40..b8d58aa08206 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -1867,7 +1867,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
>         }
>
>         err = -EINVAL;
> -       if (oh.error <= -1000 || oh.error > 0)
> +       if (oh.error <= -512 || oh.error > 0)
>                 goto copy_finish;
>
>         spin_lock(&fpq->lock);
>

