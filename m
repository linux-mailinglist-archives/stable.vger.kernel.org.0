Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E9B2477C6
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbgHQT7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:59:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32187 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729126AbgHQT7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 15:59:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597694357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Akt231nbJT27WH5md9D56a/U0FCRNSIPTF5o4fM5va4=;
        b=WybhKnmcCi0rTAuvcZB17plFfKUaLqveWIby4onHUFQUQwPIrbxK6voQC+4ASj500y5ZC5
        rBGhhNYMGsLYdP703Sgf9FC5ewk0Vrk0P0aHQcfExD6C11dm4/Y04q64b0JMaG2r1BEC0V
        zoBI1xDy/jSP1goJ9NQ/28akfOPR+uw=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-LenuYAd6NQCw5bN-2-8wMw-1; Mon, 17 Aug 2020 15:59:15 -0400
X-MC-Unique: LenuYAd6NQCw5bN-2-8wMw-1
Received: by mail-oi1-f199.google.com with SMTP id j68so6599568oib.15
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 12:59:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Akt231nbJT27WH5md9D56a/U0FCRNSIPTF5o4fM5va4=;
        b=bybfzHK/mp6fwxHJSu6prJd3gwUn/eMT8PWs1wa2YfllRVH093P8lDjWMWFkKW0J88
         xD2/SBYl8XRljdZBbTo7G3owz2EX+dyTsE9+9tZusNUXg5SBovqxZmeAzxrWSWGdEnyp
         63xwAXH5vv9pXuj4MPRIiqZharvBEjjz2TVwFyVuNiznYPChmAqV90G43FdeuqLTNGVC
         Rm9QP4XLOOr3rnT+YiSUD8QT7x8x7E5evewXtsS62ZG0Brqr6rjYUGyZ9KkwtFZZN4Q5
         8DVv8tHWPLwULd19ynav4rQeYwGL+eNrTAA9HDFU5ayy4Og0kfLrqQ+pcbHoPmUPoSQ4
         y17A==
X-Gm-Message-State: AOAM532nd7+/diAsYO/RWQ89mD4clx+FatMaeMsTCrBRPNZGngrcvwws
        Q4wBittZ71kTDvGfXUjtpVraZc1+rnnht5Cm8ILC0bxhOj/VLsN7b2qHQK0P8RADJyXdvetUhbc
        sdi+beXgRnkNo0jDStPDyY+mvNl5Zja9H
X-Received: by 2002:aca:5295:: with SMTP id g143mr10368061oib.178.1597694354777;
        Mon, 17 Aug 2020 12:59:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmcY/DzmE+N9edYr9NSQmMn/ATGYSyGPIuPTnoP9kH8BAGbpSJJujQxh70rkCiaDL/ZOBUm5KAokfBwmJLefg=
X-Received: by 2002:aca:5295:: with SMTP id g143mr10368042oib.178.1597694354548;
 Mon, 17 Aug 2020 12:59:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200817143755.807583758@linuxfoundation.org> <20200817143802.211923175@linuxfoundation.org>
In-Reply-To: <20200817143802.211923175@linuxfoundation.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Mon, 17 Aug 2020 21:59:03 +0200
Message-ID: <CAHc6FU7-B6kpJSSz5JC-47qGVQEiSwB3oePr=R5QacHw_P=jcg@mail.gmail.com>
Subject: Re: [PATCH 5.4 129/270] iomap: Make sure iomap_end is called after iomap_begin
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg,

On Mon, Aug 17, 2020 at 6:06 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> From: Andreas Gruenbacher <agruenba@redhat.com>
>
> [ Upstream commit 856473cd5d17dbbf3055710857c67a4af6d9fcc0 ]
>
> Make sure iomap_end is always called when iomap_begin succeeds.
>
> Without this fix, iomap_end won't be called when a filesystem's
> iomap_begin operation returns an invalid mapping, bypassing any
> unlocking done in iomap_end.  With this fix, the unlocking will still
> happen.
>
> This bug was found by Bob Peterson during code review.  It's unlikely
> that such iomap_begin bugs will survive to affect users, so backporting
> this fix seems unnecessary.

as said for 5.7 / 5.8 already, this patch doesn't need to be backported.

Thanks,
Andreas

> Fixes: ae259a9c8593 ("fs: introduce iomap infrastructure")
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/iomap/apply.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/fs/iomap/apply.c b/fs/iomap/apply.c
> index 54c02aecf3cd8..c2281a6a7f320 100644
> --- a/fs/iomap/apply.c
> +++ b/fs/iomap/apply.c
> @@ -41,10 +41,14 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
>         ret = ops->iomap_begin(inode, pos, length, flags, &iomap);
>         if (ret)
>                 return ret;
> -       if (WARN_ON(iomap.offset > pos))
> -               return -EIO;
> -       if (WARN_ON(iomap.length == 0))
> -               return -EIO;
> +       if (WARN_ON(iomap.offset > pos)) {
> +               written = -EIO;
> +               goto out;
> +       }
> +       if (WARN_ON(iomap.length == 0)) {
> +               written = -EIO;
> +               goto out;
> +       }
>
>         /*
>          * Cut down the length to the one actually provided by the filesystem,
> @@ -60,6 +64,7 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
>          */
>         written = actor(inode, pos, length, data, &iomap);
>
> +out:
>         /*
>          * Now the data has been copied, commit the range we've copied.  This
>          * should not fail unless the filesystem has had a fatal error.
> --
> 2.25.1
>
>
>

