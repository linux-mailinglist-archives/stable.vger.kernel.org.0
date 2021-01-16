Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455FB2F8DE4
	for <lists+stable@lfdr.de>; Sat, 16 Jan 2021 18:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbhAPRLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Jan 2021 12:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728563AbhAPRLE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Jan 2021 12:11:04 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD7BC061381;
        Sat, 16 Jan 2021 06:51:53 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id q2so22337687iow.13;
        Sat, 16 Jan 2021 06:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AOtIW1TpMWQT7D+7SJG3WQ68jlg029fmkeplzOb6Z1U=;
        b=TMqHvgUKSFWM3EeQmw5WtzEPnvmJzzEs7K1ZaVClkUWLaE4dMlChMuQ5/REpQlYKDn
         WkoVJ0LjYTxDYZnlf7n9pUMa3A96+OD3g12vWNkjQ/QaD566PIY5PuHvSt1rk/LPwNEf
         U2AF7FoRzYrctcPt/0cVhBvx6Dzu/k1yyt88cmEPIhQ0VPi1JyCdB7wHAjdKNkxaK4cL
         N/O+M4fv1z7Ec+sz7R1BHIxiJgkPJfkD44RHHArkhJJX59L2DHwAcuBRoogcoAsWn3sy
         KpIhAL3mcj5iojqcghkD1srd+cL++4neKkPA44a3SSk7fNvzFxzWtrTJKG8aC8UDpObF
         cpsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AOtIW1TpMWQT7D+7SJG3WQ68jlg029fmkeplzOb6Z1U=;
        b=ob6n299ujOlJBxXYTnzNuD6SOa9wVTZuj54NdOwUAe9Mnfu3CJuINEBvHvMTurp1+1
         8siMb6MHbABrwGMaFdVZq/jylxlWxfypr9KqN3NKVUDSC9uWS0E9y69aC2YfYsoUtA7C
         AgZcZHOa5qrpZq3t53+6uHOmy0u6Wu4Zsp4mup2DB6XC9l5GRxc8Vv9GGMozKuQAFqqS
         vIr3dM+gWkseLQdZvCojAEf6hhFD6wFaPHb6JpP2g12xfFumaF3pfF6kqD4Z31INE+7P
         cQe25eWIAiskEz/cQPTvJ/LNpDWdugQEKKq4bL7yqrNiz7GQOS3DBFxHEFlBEG5tODW7
         WNYw==
X-Gm-Message-State: AOAM530IRYiuT/ETM2buk+NZxuPuIwPVvH3vdrjGtCOLDBqljTHla5e3
        IbqCxG6TVE7KYoyWYMm9maEqqw9KX+u2TQgwKYiA6jAqpSI=
X-Google-Smtp-Source: ABdhPJzaUirliDZgIg617gZaMgZM5ngpgtwnL2XN8HR32Fqw5IG/UKujZXF3T1Mvsfj3IAGWmDyJBwghcoho4J7aBhU=
X-Received: by 2002:a05:6e02:14ce:: with SMTP id o14mr15305599ilk.9.1610808712749;
 Sat, 16 Jan 2021 06:51:52 -0800 (PST)
MIME-Version: 1.0
References: <20210105003611.194511-1-icenowy@aosc.io> <CAOQ4uxiFoQhrMbs91ZUNXqbJUXb5XRBgRrcq1rmChLKQGKg5xg@mail.gmail.com>
In-Reply-To: <CAOQ4uxiFoQhrMbs91ZUNXqbJUXb5XRBgRrcq1rmChLKQGKg5xg@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 16 Jan 2021 16:51:41 +0200
Message-ID: <CAOQ4uxj7CkB=0X3qnEKFipZyy4v7BypRZBvTKM12XFBF=ARKiw@mail.gmail.com>
Subject: Re: [PATCH v3] ovl: use a dedicated semaphore for dir upperfile caching
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Xiao Yang <yangx.jy@cn.fujitsu.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Icenowy Zheng <icenowy@aosc.io>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 5, 2021 at 8:47 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Jan 5, 2021 at 2:36 AM Icenowy Zheng <icenowy@aosc.io> wrote:
> >
> > The function ovl_dir_real_file() currently uses the semaphore of the
> > inode to synchronize write to the upperfile cache field.
>
> Although the inode lock is a rw_sem it is referred to as the "inode lock"
> and you also left semaphore in the commit subject.
> No need to re-post. This can be fixed on commit.
>
> >
> > However, this function will get called by ovl_ioctl_set_flags(), which
> > utilizes the inode semaphore too. In this case ovl_dir_real_file() will
> > try to claim a lock that is owned by a function in its call stack, which
> > won't get released before ovl_dir_real_file() returns.
> >
> > Define a dedicated semaphore for the upperfile cache, so that the
> > deadlock won't happen.
> >
> > Fixes: 61536bed2149 ("ovl: support [S|G]ETFLAGS and FS[S|G]ETXATTR ioctls for directories")
> > Cc: stable@vger.kernel.org # v5.10
> > Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
> > ---
> > Changes in v2:
> > - Fixed missing replacement in error handling path.
> > Changes in v3:
> > - Use mutex instead of semaphore.
> >
> >  fs/overlayfs/readdir.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> > index 01620ebae1bd..3980f9982f34 100644
> > --- a/fs/overlayfs/readdir.c
> > +++ b/fs/overlayfs/readdir.c
> > @@ -56,6 +56,7 @@ struct ovl_dir_file {
> >         struct list_head *cursor;
> >         struct file *realfile;
> >         struct file *upperfile;
> > +       struct mutex upperfile_mutex;
>
> That's a very specific name.
> This mutex protects members of struct ovl_dir_file, which could evolve
> into struct ovl_file one day (because no reason to cache only dir upper file),
> so I would go with a more generic name, but let's leave it to Miklos to decide.
>
> He could have a different idea altogether for fixing this bug.
>

Miklos,

Please fast track this or an alternative fix.
It fixes an easy to reproduce deadlock introduced in 5.10.
Icenowy Zheng has written a simple xfstest reproducer, but it wasn't
posted - best to avoid hanging tester's machines until a fix is merged...

Thanks,
Amir.
