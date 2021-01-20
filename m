Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4802FD073
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 13:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730951AbhATMjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 07:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730436AbhATLYk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jan 2021 06:24:40 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF15C061786;
        Wed, 20 Jan 2021 03:22:45 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id d81so30944696iof.3;
        Wed, 20 Jan 2021 03:22:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SZRUBoGdt/5UJx70V+GROL5BmBjThj3wB1sYVvK/m1s=;
        b=jjz48XnloqBQbcCVOU+UuzzdYDraFTGBJ1nuSLXezte3V6s0o45pVi6Idjv5JyyhCY
         MWWBJEUlFR96enQFK3B0fGvRny14Plru2pvTUQ+hNQKGPyo+jiGCLOBhkIcamUUgTKn+
         fw4oBik4i7WbHHB7tTybcL/Wvwfgs8asEauHnurMLGoZwoEnBwWjGPuWgD0s2plS1nu3
         6ZCuCNzMxf1dtE0G7acj+l7E5/CsnolyIM+RaMlSu9Wgm3f71TaxHp/LNpVodohl7+Vl
         6dMDwxkOWc/JvTnYhjUv6okZKtLqJyElaHs7uN+G17zSbUIOnd2RoSGLkMnuW2Zie/Gu
         IxEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SZRUBoGdt/5UJx70V+GROL5BmBjThj3wB1sYVvK/m1s=;
        b=U8rSfsTQyDxjI8WaAPwvZKKHl3FOHBpcTSYzH5OQAkRfrW95IJWfVmsEYo75KcTfXj
         nQe1BKwWuzgB1vkSkH7Ag7ytzgXB2petu8bMpaEPDXoku8Yww4g24AEmu0k1YhcSz8QC
         OQleW3ucjTUdu7eRRxk1rIRRTtM1/nOZFp987RER/oyuzWsbmjsspY7s+KJ7mBooeBqU
         y/W0IUcSm7HqWIZ4YAYpVUPRZaeJJOoVGdgA14Ku4iSd5JV/oIuGIfpLavKTvbjL5fn2
         rV1Q6TPlAM4pnS5VvcQPEDOnWsQGRO/0wSDPruQLp4D4zcFvGQMAZ0mef/ok0F04EDrs
         WmCg==
X-Gm-Message-State: AOAM530Vx+LsiJiUHJXIahFCJM9KizPxCQ1FdJip32FmM2SiVNp5+4uv
        hlJjvDZ5ibY99NyLavyL0jy8PI8vRq3B28Cb5ZHXgQW8
X-Google-Smtp-Source: ABdhPJz51+uC8eBr4zfCNfALFlel4kS4Mdm5v2Zui75zWFoT7W+J6bI5tqggKt4pUEVs1vMzjdHu2RUCSbswX5SYX9o=
X-Received: by 2002:a5d:938f:: with SMTP id c15mr6316232iol.72.1611141765056;
 Wed, 20 Jan 2021 03:22:45 -0800 (PST)
MIME-Version: 1.0
References: <20210105003611.194511-1-icenowy@aosc.io> <CAOQ4uxiFoQhrMbs91ZUNXqbJUXb5XRBgRrcq1rmChLKQGKg5xg@mail.gmail.com>
 <20210120102045.GD1236412@miu.piliscsaba.redhat.com>
In-Reply-To: <20210120102045.GD1236412@miu.piliscsaba.redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 20 Jan 2021 13:22:33 +0200
Message-ID: <CAOQ4uxiwu2L_v5n=f8LNkoLvU+horPNUvQ5U6pQ7b+Qhd4a1OQ@mail.gmail.com>
Subject: Re: [PATCH v3] ovl: use a dedicated semaphore for dir upperfile caching
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Icenowy Zheng <icenowy@aosc.io>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 20, 2021 at 12:20 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Tue, Jan 05, 2021 at 08:47:41AM +0200, Amir Goldstein wrote:
> > On Tue, Jan 5, 2021 at 2:36 AM Icenowy Zheng <icenowy@aosc.io> wrote:
> > >
> > > The function ovl_dir_real_file() currently uses the semaphore of the
> > > inode to synchronize write to the upperfile cache field.
> >
> > Although the inode lock is a rw_sem it is referred to as the "inode lock"
> > and you also left semaphore in the commit subject.
> > No need to re-post. This can be fixed on commit.
> >
> > >
> > > However, this function will get called by ovl_ioctl_set_flags(), which
> > > utilizes the inode semaphore too. In this case ovl_dir_real_file() will
> > > try to claim a lock that is owned by a function in its call stack, which
> > > won't get released before ovl_dir_real_file() returns.
> > >
> > > Define a dedicated semaphore for the upperfile cache, so that the
> > > deadlock won't happen.
> > >
> > > Fixes: 61536bed2149 ("ovl: support [S|G]ETFLAGS and FS[S|G]ETXATTR ioctls for directories")
> > > Cc: stable@vger.kernel.org # v5.10
> > > Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
> > > ---
> > > Changes in v2:
> > > - Fixed missing replacement in error handling path.
> > > Changes in v3:
> > > - Use mutex instead of semaphore.
> > >
> > >  fs/overlayfs/readdir.c | 10 +++++-----
> > >  1 file changed, 5 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> > > index 01620ebae1bd..3980f9982f34 100644
> > > --- a/fs/overlayfs/readdir.c
> > > +++ b/fs/overlayfs/readdir.c
> > > @@ -56,6 +56,7 @@ struct ovl_dir_file {
> > >         struct list_head *cursor;
> > >         struct file *realfile;
> > >         struct file *upperfile;
> > > +       struct mutex upperfile_mutex;
> >
> > That's a very specific name.
> > This mutex protects members of struct ovl_dir_file, which could evolve
> > into struct ovl_file one day (because no reason to cache only dir upper file),
> > so I would go with a more generic name, but let's leave it to Miklos to decide.
> >
> > He could have a different idea altogether for fixing this bug.
>
> How about this (untested) patch?
>

Much better :)

> It's a cleanup as well as a fix, but maybe we should separate the cleanup from
> the fix...
>
> Thanks,
> Miklos
> ---
>
>  fs/overlayfs/readdir.c |   23 +++++++----------------
>  1 file changed, 7 insertions(+), 16 deletions(-)
>
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -865,7 +865,7 @@ struct file *ovl_dir_real_file(const str
>
>         struct ovl_dir_file *od = file->private_data;
>         struct dentry *dentry = file->f_path.dentry;
> -       struct file *realfile = od->realfile;
> +       struct file *old, *realfile = od->realfile;
>
>         if (!OVL_TYPE_UPPER(ovl_path_type(dentry)))
>                 return want_upper ? NULL : realfile;
> @@ -874,29 +874,20 @@ struct file *ovl_dir_real_file(const str
>          * Need to check if we started out being a lower dir, but got copied up
>          */
>         if (!od->is_upper) {
> -               struct inode *inode = file_inode(file);
> -
>                 realfile = READ_ONCE(od->upperfile);
>                 if (!realfile) {
>                         struct path upperpath;
>
>                         ovl_path_upper(dentry, &upperpath);
>                         realfile = ovl_dir_open_realfile(file, &upperpath);
> +                       if (IS_ERR(realfile))
> +                               return realfile;
>
> -                       inode_lock(inode);
> -                       if (!od->upperfile) {
> -                               if (IS_ERR(realfile)) {
> -                                       inode_unlock(inode);
> -                                       return realfile;
> -                               }
> -                               smp_store_release(&od->upperfile, realfile);
> -                       } else {
> -                               /* somebody has beaten us to it */
> -                               if (!IS_ERR(realfile))
> -                                       fput(realfile);
> -                               realfile = od->upperfile;
> +                       old = cmpxchg_release(&od->upperfile, NULL, realfile);
> +                       if (old) {
> +                               fput(realfile);
> +                               realfile = old;
>                         }
> -                       inode_unlock(inode);
>                 }
>         }
>
