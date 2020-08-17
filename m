Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07B42477BB
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgHQT4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729118AbgHQT4H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 15:56:07 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75ACC061389;
        Mon, 17 Aug 2020 12:56:07 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id p13so15619554ilh.4;
        Mon, 17 Aug 2020 12:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x+NWj5YR3XZpyWPvRZ0+fp9XxhRMUklx8Gk0K/Gyh9I=;
        b=hgalG2oYNStULjDXT49Sii2eEZfW4u0E02z9qeP/63YN8EDkDLZsJrYZmtz7gFr0Wg
         Xv8o2O2Fg2Cc0q7zS1KcMnGNNjQnLYzyGVCMXQZie8c8kfwF3yFZwLc8ov8VrBQkOILG
         mvlsiLmcpFPIg17OchBEO1VRQwJsWzEGYiFZ1AqdwRhfX8cOnY3cZpy3zkCOa9Zp+ay5
         cH0kVagad29ndIsLS1owQEglczMVKxyOUec44xQEjKuRFGn0YTl56TnBQIcMntiFMm11
         +V0UQJ1bOz5T4BB+RTw2gMKGgqFrVImp2K/3KuMGNzSnZ2hzb6UwncAScMnZTXAv/IZW
         3CEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x+NWj5YR3XZpyWPvRZ0+fp9XxhRMUklx8Gk0K/Gyh9I=;
        b=CGeVCmYsCWrAbW6h5byWL7gT1JWPivT5UXnP5i2yHDE5i43tb90xWcX8D/1WEx7lRW
         SkM2ulrw5weLkloIOTi+pyb3/7lPFIFL50WsLyxuHtycGSCiuL/dZXqOaL9KdsVDLSEb
         ZHIlBlwSj8aLJ3YRdRbOVSHYmGC7SzIDb7eZ1jcptopd54BB9rxncX+WXEmwTxLDtBWy
         crCRdP1L/JBCJDX0lWFnVvVvsrz5qAptk/i2gzXr3a6YejULZjnv2jOcSViqOPVH2Y/2
         Oi8T0Rz9/e4Ke+pNvIA6LeQvBDEGhLwgMjHDdGqT2tGVNgti4QxK6NiRyiUWp9eihUcf
         7gbA==
X-Gm-Message-State: AOAM533T2ccnQ1FJfYXybSE8WMqS8IEy6ye2jHw3gBlp96f58Y0jcbgo
        z3SBRM81SgZkdvve4ZJyLv1eEGYeWUO8aV59Owo=
X-Google-Smtp-Source: ABdhPJx/DHLK0s4jPxayJcgzBpsXrf7qFd+aR60aLgOfg7NrXVYHHc1cMhrOZyyu2uMUYLEVilJhn69n+/1CIIF8EIo=
X-Received: by 2002:a92:bb13:: with SMTP id w19mr15413463ili.300.1597694166986;
 Mon, 17 Aug 2020 12:56:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200817143819.579311991@linuxfoundation.org> <20200817143828.740143105@linuxfoundation.org>
In-Reply-To: <20200817143828.740143105@linuxfoundation.org>
From:   =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Date:   Mon, 17 Aug 2020 21:55:55 +0200
Message-ID: <CAHpGcMJOQi_RV5z2+dOV=K5sYr+tzUbDQCJynhN54y3f1JiKeg@mail.gmail.com>
Subject: Re: [PATCH 5.7 188/393] iomap: Make sure iomap_end is called after iomap_begin
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg,

Am Mo., 17. Aug. 2020 um 21:01 Uhr schrieb Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
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

this doesn't need to be backported.

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
> index 76925b40b5fd2..26ab6563181fc 100644
> --- a/fs/iomap/apply.c
> +++ b/fs/iomap/apply.c
> @@ -46,10 +46,14 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
>         ret = ops->iomap_begin(inode, pos, length, flags, &iomap, &srcmap);
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
>         trace_iomap_apply_dstmap(inode, &iomap);
>         if (srcmap.type != IOMAP_HOLE)
> @@ -80,6 +84,7 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
>         written = actor(inode, pos, length, data, &iomap,
>                         srcmap.type != IOMAP_HOLE ? &srcmap : &iomap);
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
