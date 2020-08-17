Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD4B2477BD
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbgHQT4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729118AbgHQT4P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 15:56:15 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DE3C061389;
        Mon, 17 Aug 2020 12:56:15 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t13so15569609ile.9;
        Mon, 17 Aug 2020 12:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nR+WkSUvbjxRjE6e2Fq7UBkBLxbfa9F+C6jcTtMzcUQ=;
        b=Y9iPFtT3joyWZ/8aR73+KEvr4w5jepU+7JLHLPeFYT1u7Rz7VeHVsSdpLrRotq7zGA
         xSwqqkJqu4I78a4uxGybJclpVxmFwf7K/q6Ttllq6ChOHXVUWvKdDTTd4+FNq90M3pzq
         /xdzyOwshDVNfJSHOyV4S1IKhWywCXQXpGH0VHMjEKA8hcU2qDwDSkjuclT/O3XJckFQ
         STvqYk/sNTt97hG82crvvhGj59+OwmkQQ5owknrHotZ6CYPSnCFvq++zn5Z2/WD5vzwr
         cVrrbI83t7LQeDX1q0e88vTJcMmE2mMMlsxj9zbpEcMnpepyZPPozCCO146QaltgQbH8
         EV/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nR+WkSUvbjxRjE6e2Fq7UBkBLxbfa9F+C6jcTtMzcUQ=;
        b=gxjwRcHBqwNPyyWyAYop8lCIpbufYGAIZJjGm1nxMPnzsKJs85QW/7NR9w0MeFil8L
         iNZf7JKZ7snx286p45meocB0psh/0k6RTqcy1+JbOFOPB3tZDX1o5iPBLY7AKThZnEzq
         U5DTb65jFKPLy+aqkoRobM88yfOmd5qKub+V19meVTM5ruZxzlI2Ds4XU3D3ICKVeGws
         V2gqXpSe7ZyoclQkoPxemIXTyusbG0HNSD19HeLWwbxznqjbioMqSDKq9pjZFQOUCjVT
         +22lQKNakoaustFZvaYXOgSQSIa54I0CdFiZ2qdCAgpU4kIx7pD9vSVc339G6apNz0eA
         j7dw==
X-Gm-Message-State: AOAM532F44QMNfsshMCpvr1YpsuJvurAh2VcOqIcEj4uXdWWMY5WV0R0
        sWarQ3fNJ0PfKZHBnMjZTycL04wTHDFcvl4XkY8=
X-Google-Smtp-Source: ABdhPJxVyDjSo3EBTH/ouaNLR17TNwro2twQeA0S6xYCisC3BE+1X81TVzPs+v1S6btGnMXHwU79t/MmzmcXpljTCKA=
X-Received: by 2002:a92:40cb:: with SMTP id d72mr14785856ill.116.1597694174791;
 Mon, 17 Aug 2020 12:56:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200817143833.737102804@linuxfoundation.org> <20200817143844.062314049@linuxfoundation.org>
In-Reply-To: <20200817143844.062314049@linuxfoundation.org>
From:   =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Date:   Mon, 17 Aug 2020 21:56:02 +0200
Message-ID: <CAHpGcMJPQjfabb0_9n=rVBZXQqdnhvcaA3rgbNBemb4OqSYYgA@mail.gmail.com>
Subject: Re: [PATCH 5.8 214/464] iomap: Make sure iomap_end is called after iomap_begin
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

Gerg,

Am Mo., 17. Aug. 2020 um 21:39 Uhr schrieb Greg Kroah-Hartman
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
