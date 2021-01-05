Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C481C2EA594
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 07:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbhAEGsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 01:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbhAEGsd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 01:48:33 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A34C061793;
        Mon,  4 Jan 2021 22:47:53 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id w17so27625888ilj.8;
        Mon, 04 Jan 2021 22:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WEIUrnV7kwpRZdk2n4ViOS8PBMynqQODHepR4XVRnjk=;
        b=cPtGkacRM9TDsxMA69xv6SLX5aOxuxGEIUHQAJVGf7GagmC2jPQrT5B37Ammol18iN
         HwhGtLcp2If7zovIDMUIKPWphP80vQLCXTW9F4sT7aWSml+M2OSp9fbV70OsjzdS4Jnl
         AbvXYfpEfmMEqePbuKlsuOydIaftuyD8/Lvjif/rNXuAeBB1f0uOSL231+zvvU+GV4Bk
         WTvwHAaKlLW5TLVrieAEBxiTHFXomTITNs3bK4re0GyXLY2qZJ47/WK5NP+YODofOnTW
         r7zzcnfdtRPg7tttz2w1uLJShrCyJuxCdFirf4pPG9mVaJT10ojS0QEWDlLwBHWKIbwX
         qXvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WEIUrnV7kwpRZdk2n4ViOS8PBMynqQODHepR4XVRnjk=;
        b=JL8oSI2cCc3wgcqcy+zWrgtd1xHrRluYpdoB3rx5f368SUiZZy+xaUPPTqsXaaCNRc
         lZgXvfKDKni6z431ujEmZ9oJGAqVaLXDcNYrw5qcT0C9fcs4wYhMunV4HFSN3TvaG4vv
         GKQLoUmLTt9pP5lYrvPt6lh1ywOzdKdPjAYC7Av6qwHNnCp0NtXk3c8vix8xN82+SKLw
         ejRS2g6IPJT4SuxB7ORIgY0bL1F1BWCqz90akaqcJnUMUzMqhs6L2cdcPSfYWnyIPpYZ
         1ztXtG+qRicyM4HrzHQ3lSpbiHUrzv6B/1XUQqOlTlh8kU7ewRH0GULEvz3obsvxy4Xa
         0Zqw==
X-Gm-Message-State: AOAM532pCyGpF2IJeKW7t2RWS4vJctjX0UgRGKD9AdVBfwkgYehktt4s
        tjN7lnYtAnjHYBF4fOjMP8MpqUNb8/LI3KYk6G9V9EiDFgI=
X-Google-Smtp-Source: ABdhPJwKiwaQfeoCWzR0lPATVutk08oY9xuYHYL6tMf6GYLD46UDJggODg6tov1r5nlami5e3qeJemwtr7l7heUD0ko=
X-Received: by 2002:a92:6403:: with SMTP id y3mr72656126ilb.72.1609829272565;
 Mon, 04 Jan 2021 22:47:52 -0800 (PST)
MIME-Version: 1.0
References: <20210105003611.194511-1-icenowy@aosc.io>
In-Reply-To: <20210105003611.194511-1-icenowy@aosc.io>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 5 Jan 2021 08:47:41 +0200
Message-ID: <CAOQ4uxiFoQhrMbs91ZUNXqbJUXb5XRBgRrcq1rmChLKQGKg5xg@mail.gmail.com>
Subject: Re: [PATCH v3] ovl: use a dedicated semaphore for dir upperfile caching
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

On Tue, Jan 5, 2021 at 2:36 AM Icenowy Zheng <icenowy@aosc.io> wrote:
>
> The function ovl_dir_real_file() currently uses the semaphore of the
> inode to synchronize write to the upperfile cache field.

Although the inode lock is a rw_sem it is referred to as the "inode lock"
and you also left semaphore in the commit subject.
No need to re-post. This can be fixed on commit.

>
> However, this function will get called by ovl_ioctl_set_flags(), which
> utilizes the inode semaphore too. In this case ovl_dir_real_file() will
> try to claim a lock that is owned by a function in its call stack, which
> won't get released before ovl_dir_real_file() returns.
>
> Define a dedicated semaphore for the upperfile cache, so that the
> deadlock won't happen.
>
> Fixes: 61536bed2149 ("ovl: support [S|G]ETFLAGS and FS[S|G]ETXATTR ioctls for directories")
> Cc: stable@vger.kernel.org # v5.10
> Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
> ---
> Changes in v2:
> - Fixed missing replacement in error handling path.
> Changes in v3:
> - Use mutex instead of semaphore.
>
>  fs/overlayfs/readdir.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 01620ebae1bd..3980f9982f34 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -56,6 +56,7 @@ struct ovl_dir_file {
>         struct list_head *cursor;
>         struct file *realfile;
>         struct file *upperfile;
> +       struct mutex upperfile_mutex;

That's a very specific name.
This mutex protects members of struct ovl_dir_file, which could evolve
into struct ovl_file one day (because no reason to cache only dir upper file),
so I would go with a more generic name, but let's leave it to Miklos to decide.

He could have a different idea altogether for fixing this bug.

Thanks,
Amir.
