Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A911F5776
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 17:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730091AbgFJPOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 11:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730088AbgFJPOt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 11:14:49 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57580C08C5C1
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 08:14:49 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id k4so2396622oik.2
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 08:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oDtkEAKzZyv3dXNpsPsqMVmJ4Y+cSfCKakpKBa1zwUc=;
        b=udMylkJsBkLSPX/fhP5jeC4vIZEIk7TjusiPwvDt4TqgrxhpxZ32ukAYcSJ5mMIM9/
         gboTn/jhWul6F0UPWXzXg7jF4ZdDjjdwpiV7Sl8cLMvCDhOBOxJJGxdfWChSjWjNVmIh
         vpKi/71gW267IO6ChJVTCWAdeNh3yRhOyFajVZn9Bcl5PFGWoWyEvfkJ6+oZQJGfuo2s
         RumZM5ygadgjL17Q4SHDCYZLwcQ15xcngMgMDL5NNLosOL7bI+wqMcq161vNf+oWYHen
         4LIlPYpPZ5BIuUp53K9CHX8rMpO7BHFKXoBYKpJutad2geY1d6L+GMb/Nfu0+SiUBmRr
         F4Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oDtkEAKzZyv3dXNpsPsqMVmJ4Y+cSfCKakpKBa1zwUc=;
        b=GVW7bEd/s3GGnFhJYEJ8GxocbQCRLRqzafyeMwdKfRBqT7PDaupeX99Z0ZN+dIIp06
         GR9Yc+TiIwqGQKRllHrP4rj/x4rAUO0KbxA8VfNTcoHxpvg6BbW4PdPKuuvjGTUqYbAu
         u47s47PUqTIQu5k296vJdgdkCGy/3jRob/WH0HjXwPoJwbzEE/W0EYJFRxgGJ6PQTWTj
         D5q0Y5t5E36rhk2IO6DXvo5EUosUsraTCgiUICVO8L0ZsaX27e+kFkZVsSm8Nb385Zzt
         LSdHLcN/uSOlo8DXRTag3GcXTfWtz1NBPcfYOUW0t8nY6jt11m/eI2JoHLNVd4k6s8Z6
         iE0A==
X-Gm-Message-State: AOAM533ZrmgBzPGDYrIGhyFsXMix3XT4hAgoBL9VVwfffUTwQwQWzlRT
        SEOUGdOb9dBXq9Cz8K096D/V0Obcrw5n0VqfhctgAw==
X-Google-Smtp-Source: ABdhPJz7VsuBtbPfx9RhfASCfcCtNEZDfA1tM4aFTMIKx3YAxZCxiJua2WBQytWigumUFZm42pnwJaUbj0Binjq2P/c=
X-Received: by 2002:aca:1308:: with SMTP id e8mr2665439oii.119.1591802088505;
 Wed, 10 Jun 2020 08:14:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200610083333.455-1-sumit.semwal@linaro.org> <CAK8P3a0PzmtWc1p-KgHzHhY+=gca0J8YsGD=ALGESWsgijQQ7w@mail.gmail.com>
In-Reply-To: <CAK8P3a0PzmtWc1p-KgHzHhY+=gca0J8YsGD=ALGESWsgijQQ7w@mail.gmail.com>
From:   Sumit Semwal <sumit.semwal@linaro.org>
Date:   Wed, 10 Jun 2020 20:44:37 +0530
Message-ID: <CAO_48GEqxOOOZupGLAa92HXcnbe6_3ZfLvaJsDnv9_XFTTFe6w@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: Move dma_buf_release() from fops to dentry_ops
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Chenbo Feng <fengc@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        Charan Teja Reddy <charante@codeaurora.org>,
        syzbot+3643a18836bce555bff6@syzkaller.appspotmail.com,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Jun 2020 at 14:57, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Wed, Jun 10, 2020 at 10:33 AM Sumit Semwal <sumit.semwal@linaro.org> wrote:
> >
> > Charan Teja reported a 'use-after-free' in dmabuffs_dname [1], which
> > happens if the dma_buf_release() is called while the userspace is
> > accessing the dma_buf pseudo fs's dmabuffs_dname() in another process,
> > and dma_buf_release() releases the dmabuf object when the last reference
> > to the struct file goes away.
> >
> > I discussed with Arnd Bergmann, and he suggested that rather than tying
> > the dma_buf_release() to the file_operations' release(), we can tie it to
> > the dentry_operations' d_release(), which will be called when the last ref
> > to the dentry is removed.
> >
> > The path exercised by __fput() calls f_op->release() first, and then calls
> > dput, which eventually calls d_op->d_release().
> >
> > In the 'normal' case, when no userspace access is happening via dma_buf
> > pseudo fs, there should be exactly one fd, file, dentry and inode, so
> > closing the fd will kill of everything right away.
> >
> > In the presented case, the dentry's d_release() will be called only when
> > the dentry's last ref is released.
> >
> > Therefore, lets move dma_buf_release() from fops->release() to
> > d_ops->d_release().
> >
> > Many thanks to Arnd for his FS insights :)
> >
> > [1]: https://lore.kernel.org/patchwork/patch/1238278/
> >
> > Fixes: bb2bb9030425 ("dma-buf: add DMA_BUF_SET_NAME ioctls")
> > Reported-by: syzbot+3643a18836bce555bff6@syzkaller.appspotmail.com
> > Cc: <stable@vger.kernel.org> [5.3+]
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Reported-by: Charan Teja Reddy <charante@codeaurora.org>
> > Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
>
> The patch looks correct to me.
>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>
> Obviously this should still be verified against the original report if possible.
Thanks, Arnd!
>
> >  drivers/dma-buf/dma-buf.c | 13 +++++++------
> >  1 file changed, 7 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> > index 01ce125f8e8d..92ba4b6ef3e7 100644
> > --- a/drivers/dma-buf/dma-buf.c
> > +++ b/drivers/dma-buf/dma-buf.c
> > @@ -54,8 +54,11 @@ static char *dmabuffs_dname(struct dentry *dentry, char *buffer, int buflen)
> >                              dentry->d_name.name, ret > 0 ? name : "");
> >  }
> >
> > +static void dma_buf_release(struct dentry *dentry);
> > +
> >  static const struct dentry_operations dma_buf_dentry_ops = {
> >         .d_dname = dmabuffs_dname,
> > +       .d_release = dma_buf_release,
> >  };
>
> I'd suggest rearranging the file to avoid the forward declaration, even
> if it makes it a little harder to review the change, the resulting code
> will remain organized more logically.
Got it, will update it in v2.
>
> >  static struct vfsmount *dma_buf_mnt;
> > @@ -77,14 +80,14 @@ static struct file_system_type dma_buf_fs_type = {
> >         .kill_sb = kill_anon_super,
> >  };
> >
> > -static int dma_buf_release(struct inode *inode, struct file *file)
> > +static void dma_buf_release(struct dentry *dentry)
> >  {
> >         struct dma_buf *dmabuf;
> >
> > -       if (!is_dma_buf_file(file))
> > -               return -EINVAL;
> > +       if (dentry->d_op != &dma_buf_dentry_ops)
> > +               return;
>
> I think the check here is redundant and it's clearer without it.
Ok, will remove.
>
>           Arnd

Best,
Sumit.
