Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C19A2E8C88
	for <lists+stable@lfdr.de>; Sun,  3 Jan 2021 15:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbhACOLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Jan 2021 09:11:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbhACOLr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Jan 2021 09:11:47 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F39C061573;
        Sun,  3 Jan 2021 06:11:07 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id e7so19231306ile.7;
        Sun, 03 Jan 2021 06:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SsNZGoLzdSXQyiIM63lxMbZN+jRAOh5izEIZB+klgno=;
        b=gPMeLdqvvFCCbqJmtqgg/ggFc8rnNDCg0G8Et1H2P9nlP8xic8yl21ZRqfw1dg3w8V
         +qJe5A+CAVLxbJ9pBB7WBaXWXXoohfY5AiAn5DVffNOekn2Oyp/iAFF/frt5uNRsrxYN
         +4OWcVANKVsH7eQ2956o7mu+QtMzbYLzpL6B7/e8UvNdaDEAdRsLtWEq0mgvCZf0udoT
         4HKc9qibtt4TeNCRu3d9WF6m2yhHDsto2lsYP6KIuRJPZtOrbE9sFFOmeEBwmqpg3c4i
         AipKhNiPIH/rkyEIob9D5LOkLZOGKH5rTbTFM5aE3yJ58TcG3MnwTFH5MK7ACzmMABNg
         3oSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SsNZGoLzdSXQyiIM63lxMbZN+jRAOh5izEIZB+klgno=;
        b=KYgjuF3FNKfCBIv73daFXJ8bCZMvmOScIyOx/lOy482qwr/ghKKlgz6dUwdLQssMc/
         rJdWK2DQuOTt0W4XHB5qttvflUG3DTRvJRrBMMAqahM8mbACd6i03U1ySl2SUlJbyXGG
         rg513lXBoH3y8vQd9707iCYoKRkEpQa9RI6vLZWOuKi8fecDWA6qa7UoIoZPa3Hoe/YH
         Ei+yVNXovnz7XcpJkgose/GfAKrLUOrdHGD/FbJFFpogm6N04DiwFLsi1ppZCjQl/fV0
         4l084TZn4LxROtoFvSV65Q/ON6JWS5O3PfJqFhXDh9wWWVl5l97s9Qy2vGikUTWmp5UP
         kOMw==
X-Gm-Message-State: AOAM532sGpLriFUue+WOvMlsDK5t+a5073hjGZre/hbhLQhuM5SzoMs9
        gebE9VCbwjgQKl6kFlDHuWIbUr6yUXiLlZaOFR2FLIv22XE=
X-Google-Smtp-Source: ABdhPJw8YvhDG3S7Xh3RhCVPYKg4UEzcZQeWn5mfpUbTRyqouWRWKXZEBMPh/4FD45AqO9aJXU2wBIk4p+zAI8fnfY8=
X-Received: by 2002:a92:6403:: with SMTP id y3mr65359341ilb.72.1609683066480;
 Sun, 03 Jan 2021 06:11:06 -0800 (PST)
MIME-Version: 1.0
References: <20210101201230.768653-1-icenowy@aosc.io>
In-Reply-To: <20210101201230.768653-1-icenowy@aosc.io>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 3 Jan 2021 16:10:55 +0200
Message-ID: <CAOQ4uxgNWkzVphdB7cAkwdUXagM_NsCUYDRT1f-=X1rn1-KpUQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: use a dedicated semaphore for dir upperfile caching
To:     Icenowy Zheng <icenowy@aosc.io>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 1, 2021 at 10:12 PM Icenowy Zheng <icenowy@aosc.io> wrote:
>
> The function ovl_dir_real_file() currently uses the semaphore of the
> inode to synchronize write to the upperfile cache field.
>
> However, this function will get called by ovl_ioctl_set_flags(), which
> utilizes the inode semaphore too. In this case ovl_dir_real_file() will
> try to claim a lock that is owned by a function in its call stack, which
> won't get released before ovl_dir_real_file() returns.

oops. I wondered why I didn't see any warnings on this from lockdep.
Ah! because the xfstest that exercises ovl_ioctl_set_flags() on directory,
generic/079, starts with an already upper dir.

And the xfstest that checks chattr+i on lower/upper files, overlay/040,
does not check chattr on dirs (ioctl on overlay dirs wasn't supported at
the time the test was written).

Would you be able to create a variant of test overlay/040 that also tests
chattr +i on lower/upper dirs to test your patch and confirm that the test
fails on master with the appropriate Kconfig debug options.

>
> Define a dedicated semaphore for the upperfile cache, so that the
> deadlock won't happen.
>
> Fixes: 61536bed2149 ("ovl: support [S|G]ETFLAGS and FS[S|G]ETXATTR ioctls for directories")
> Cc: stable@vger.kernel.org # v5.10
> Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
> ---
>  fs/overlayfs/readdir.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 01620ebae1bd..f10701aabb71 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -56,6 +56,7 @@ struct ovl_dir_file {
>         struct list_head *cursor;
>         struct file *realfile;
>         struct file *upperfile;
> +       struct semaphore upperfile_sem;

mutex please

>  };
>
>  static struct ovl_cache_entry *ovl_cache_entry_from_node(struct rb_node *n)
> @@ -883,7 +884,7 @@ struct file *ovl_dir_real_file(const struct file *file, bool want_upper)
>                         ovl_path_upper(dentry, &upperpath);
>                         realfile = ovl_dir_open_realfile(file, &upperpath);
>
> -                       inode_lock(inode);
> +                       down(&od->upperfile_sem);
>                         if (!od->upperfile) {
>                                 if (IS_ERR(realfile)) {
>                                         inode_unlock(inode);

You missed this unlock

Thanks,
Amir.
