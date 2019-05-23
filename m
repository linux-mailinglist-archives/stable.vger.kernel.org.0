Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48B4628B1E
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387429AbfEWT5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:57:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387408AbfEWT5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:57:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84B2720856;
        Thu, 23 May 2019 19:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558641464;
        bh=xs5QhlJyUpS9m47SKKZyS/Cye4NdlUAIytXOtL+6qgQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qBSvyKR9Jsv9aWUhfUcvQToNmVOICEH9ehtiNMpVgs4iGN9EX1JNwM6I+hn2yzK1I
         Cw6JKBuSqytaRx7vtqnA+7flJXIoBOHGJzcWvMRpseYd5dm+m0USIvXwY0BQX6Q0LN
         ppixdufBl+jbD/eMPYK2rGPhTnznltbIGfZYaZWA=
Date:   Thu, 23 May 2019 21:57:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        stable <stable@vger.kernel.org>
Subject: Re: Patch "ovl: fix missing upper fs freeze protection on copy up
 for ioctl" has been added to the 4.19-stable tree
Message-ID: <20190523195741.GA4436@kroah.com>
References: <1558603746191117@kroah.com>
 <CAOQ4uxip8H45S-UmWhNowv9sQUTYzcDMVCZxw=6AvFN-4c1Uvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxip8H45S-UmWhNowv9sQUTYzcDMVCZxw=6AvFN-4c1Uvw@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 23, 2019 at 10:51:58PM +0300, Amir Goldstein wrote:
> On Thu, May 23, 2019 at 12:30 PM <gregkh@linuxfoundation.org> wrote:
> >
> >
> > This is a note to let you know that I've just added the patch titled
> >
> >     ovl: fix missing upper fs freeze protection on copy up for ioctl
> >
> > to the 4.19-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> >
> > The filename of the patch is:
> >      ovl-fix-missing-upper-fs-freeze-protection-on-copy-up-for-ioctl.patch
> > and it can be found in the queue-4.19 subdirectory.
> >
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> >
> >
> > From 3428030da004a1128cbdcf93dc03e16f184d845b Mon Sep 17 00:00:00 2001
> > From: Amir Goldstein <amir73il@gmail.com>
> > Date: Tue, 22 Jan 2019 07:01:39 +0200
> > Subject: ovl: fix missing upper fs freeze protection on copy up for ioctl
> >
> > From: Amir Goldstein <amir73il@gmail.com>
> >
> > commit 3428030da004a1128cbdcf93dc03e16f184d845b upstream.
> >
> > Generalize the helper ovl_open_maybe_copy_up() and use it to copy up file
> > with data before FS_IOC_SETFLAGS ioctl.
> >
> > The FS_IOC_SETFLAGS ioctl is a bit of an odd ball in vfs, which probably
> > caused the confusion.  File may be open O_RDONLY, but ioctl modifies the
> > file.  VFS does not call mnt_want_write_file() nor lock inode mutex, but
> > fs-specific code for FS_IOC_SETFLAGS does.  So ovl_ioctl() calls
> > mnt_want_write_file() for the overlay file, and fs-specific code calls
> > mnt_want_write_file() for upper fs file, but there was no call for
> > ovl_want_write() for copy up duration which prevents overlayfs from copying
> > up on a frozen upper fs.
> >
> > Fixes: dab5ca8fd9dd ("ovl: add lsattr/chattr support")
> > Cc: <stable@vger.kernel.org> # v4.19
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > Acked-by: Vivek Goyal <vgoyal@redhat.com>
> > Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > ---
> >  fs/overlayfs/copy_up.c   |    6 +++---
> >  fs/overlayfs/file.c      |    5 ++---
> >  fs/overlayfs/overlayfs.h |    2 +-
> >  3 files changed, 6 insertions(+), 7 deletions(-)
> >
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -878,14 +878,14 @@ static bool ovl_open_need_copy_up(struct
> >         return true;
> >  }
> >
> > -int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags)
> > +int ovl_maybe_copy_up(struct dentry *dentry, int flags)
> >  {
> >         int err = 0;
> >
> > -       if (ovl_open_need_copy_up(dentry, file_flags)) {
> > +       if (ovl_open_need_copy_up(dentry, flags)) {
> >                 err = ovl_want_write(dentry);
> >                 if (!err) {
> > -                       err = ovl_copy_up_flags(dentry, file_flags);
> > +                       err = ovl_copy_up_flags(dentry, flags);
> >                         ovl_drop_write(dentry);
> >                 }
> >         }
> > --- a/fs/overlayfs/file.c
> > +++ b/fs/overlayfs/file.c
> > @@ -116,11 +116,10 @@ static int ovl_real_fdget(const struct f
> >
> >  static int ovl_open(struct inode *inode, struct file *file)
> >  {
> > -       struct dentry *dentry = file_dentry(file);
> >         struct file *realfile;
> >         int err;
> >
> > -       err = ovl_open_maybe_copy_up(dentry, file->f_flags);
> > +       err = ovl_maybe_copy_up(file_dentry(file), file->f_flags);
> >         if (err)
> >                 return err;
> >
> > @@ -390,7 +389,7 @@ static long ovl_ioctl(struct file *file,
> >                 if (ret)
> >                         return ret;
> >
> > -               ret = ovl_copy_up_with_data(file_dentry(file));
> > +               ret = ovl_maybe_copy_up(file_dentry(file), O_WRONLY);
> >                 if (!ret) {
> >                         ret = ovl_real_ioctl(file, cmd, arg);
> >
> > --- a/fs/overlayfs/overlayfs.h
> > +++ b/fs/overlayfs/overlayfs.h
> > @@ -411,7 +411,7 @@ extern const struct file_operations ovl_
> >  int ovl_copy_up(struct dentry *dentry);
> >  int ovl_copy_up_with_data(struct dentry *dentry);
> >  int ovl_copy_up_flags(struct dentry *dentry, int flags);
> > -int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags);
> > +int ovl_maybe_copy_up(struct dentry *dentry, int flags);
> >  int ovl_copy_xattr(struct dentry *old, struct dentry *new);
> >  int ovl_set_attr(struct dentry *upper, struct kstat *stat);
> >  struct ovl_fh *ovl_encode_real_fh(struct dentry *real, bool is_upper);
> >
> >
> > Patches currently in stable-queue which might be from amir73il@gmail.com are
> >
> > queue-4.19/ovl-fix-missing-upper-fs-freeze-protection-on-copy-up-for-ioctl.patch
> 
> This patch is fine for stable, but I have a process question.
> All these patches from overlayfs 5.2-rc1 are also v4.9 stable candidates:
> 
> 1. acf3062a7e1c - ovl: relax WARN_ON() for overlapping layers use case
> 2. 98487de318a6 - ovl: check the capability before cred overridden
> 3. d989903058a8 - ovl: do not generate duplicate fsnotify events for "fake" path
> 4. 9e46b840c705 - ovl: support stacked SEEK_HOLE/SEEK_DATA
> 
> #2 wasn't properly marked for stable, but the other are marked with
> Fixes: and Reported-by:
> 
> Are those marks not sufficient to get selected for stable trees these days?

Not by default, no.  Sometimes they might get picked up if we get bored,
or the auto-bot notices them.

> I must admit that #1 in borderline stable. Not sure if eliminating an unjust
> WARN_ON qualified, but syzbot did report a bug..

syzbot things are good to fix in stable kernels, so that syzbot can
continue to find real things in stable kernels.  So yes, that is fine to
backport.

> Just asking in order to improve the process, but in any case,
> please pick those patches for v4.9+ (unless anyone objects?)
> They all already have LTP/xfstests/syzkaller tests that cover them.

I'll queue them up for the next round after this, thanks.

greg k-h
