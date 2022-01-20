Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44B549502A
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 15:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347536AbiATObX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 09:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345897AbiATObX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 09:31:23 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0B3C061574;
        Thu, 20 Jan 2022 06:31:23 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id i14so5095592ila.11;
        Thu, 20 Jan 2022 06:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jyaTCgjaFQUju0SFsP0ZB8pA8uyEshT7ZeJShX00Fic=;
        b=bgkkQZRmFjDjpdaYb5ZeVctERtljthNdF+gUDXurru0NOJ6BzHDqwo89PYJh0QFWCI
         gvHRhIN04YyF6e1yH5tuAT6S0l1HiM7PLWOcK47lK+LpNRzfBUDYukzPcxS+PReyg5BO
         ercxx03DE1hEOX4DaLvMZlEj+Wm+LVj4dtbMBzDQiR2VBNer+0p+xMdfdk8KemUm0sCD
         y32fQIUA4/xY8fYZLsgtyLEilHnq7cCaTJ5aHTWE8F/9QJLjiwyveyzYjuN5Ftp2cX1T
         yKTbcvWe4vSQlqAsxeVKdFGUj2wceFpJuD+udeabcgcdMIQFi41DNfoNoxOX3d5x+P+3
         8P1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jyaTCgjaFQUju0SFsP0ZB8pA8uyEshT7ZeJShX00Fic=;
        b=P0mBJzTOzR20TKXp2//3pPVO73n15KJUHCLBTMcBJ0H34C7EnopLOb6faZKKFYzuXe
         RWttW+mfCitUQCPyeA5x9KbimyE8JavO61pNaef4CPnpGkIAaslssaE0U+BlyX3XIjY/
         N1z0TA4aNbBg6j1kBXi3HU+nYfh4BTqmBbT2LbAs6SnDPqYYzdmX20IF+i+oQ7Y90z51
         v+7iRqrXn1LwyCwlXL3CPBPN8nV0+csSJ6OU4roLw8rZmbiUBbPEpTeCuxum5GyP+wDW
         qJZ+8qcH1Ky4NXdAn300HQLNH0UjVij25a36IVdrg1CRpBGvhJL2XK2Pmy95z+NZySu2
         x0+A==
X-Gm-Message-State: AOAM532xZuRi22IcOQ1yTM4eoRmrw32goFdP9uULRDKiTBQQkwNIRQcf
        +aLcW3N/dfbwLAPGV2AJVCS9/vbyR8r76ULy0xI=
X-Google-Smtp-Source: ABdhPJy7vtpI17SbG63ALoJsRPqPxEIS1qyiEDiaHGBzQL8q4Ik4B6fALDftrmtq2SPx4UCGRd+uZQrS/re5qMg5/OM=
X-Received: by 2002:a92:c242:: with SMTP id k2mr17334765ilo.198.1642689082674;
 Thu, 20 Jan 2022 06:31:22 -0800 (PST)
MIME-Version: 1.0
References: <20220118120031.196123-1-amir73il@gmail.com> <20220120125208.jmm2xjwcxaswt3tn@quack3.lan>
In-Reply-To: <20220120125208.jmm2xjwcxaswt3tn@quack3.lan>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 20 Jan 2022 16:31:11 +0200
Message-ID: <CAOQ4uxjxayK006RDAiEm9hKP_JAZhZZDcj7tbnANjQWP-_XObA@mail.gmail.com>
Subject: Re: [PATCH] fnotify: invalidate dcache before IN_DELETE event
To:     Jan Kara <jack@suse.cz>
Cc:     Matthew Bobrowski <repnop@google.com>,
        Ivan Delalande <colona@arista.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 20, 2022 at 2:52 PM Jan Kara <jack@suse.cz> wrote:
>
> On Tue 18-01-22 14:00:31, Amir Goldstein wrote:
> > Apparently, there are some applications that use IN_DELETE event as an
> > invalidation mechanism and expect that if they try to open a file with
> > the name reported with the delete event, that it should not contain the
> > content of the deleted file.
> >
> > Commit 49246466a989 ("fsnotify: move fsnotify_nameremove() hook out of
> > d_delete()") moved the fsnotify delete hook before d_delete() so fsnotify
> > will have access to a positive dentry.
> >
> > This allowed a race where opening the deleted file via cached dentry
> > is now possible after receiving the IN_DELETE event.
> >
> > To fix the regression, we use two different techniques:
> > 1) For call sites that call d_delete() with elevated refcount, convert
> >    the call to d_drop() and move the fsnotify hook after d_drop().
>
> Maybe do this in a separate patch? It's quite a bit of mostly mechanical
> changes, after separating them it is more obvious what the logical changes
> actually are (and backporting is actually less error prone as well).

ok.

>
> > 2) For the vfs helpers that may turn dentry to negative on d_delete(),
> >    use a helper d_delete_notify() to pin the inode, so we can pass it
> >    to an fsnotify hook after d_delete().
> >
> > Create a new hook fsnotify_delete() that allows to pass a negative
> > dentry and takes the unlinked inode as an argument.
> >
> > Add a missing fsnotify_unlink() hook in nfsdfs that was found during
> > the call sites audit.
> >
> > Note that the call sites in simple_recursive_removal() follow
> > d_invalidate(), so they require no change.
> >
> > Backporting hint: this regression is from v5.3. Although patch will
> > apply with only trivial conflicts to v5.4 and v5.10, it won't build,
> > because fsnotify_delete() implementation is different in each of those
> > versions (see fsnotify_link()).
> >
> > Reported-by: Ivan Delalande <colona@arista.com>
> > Link: https://lore.kernel.org/linux-fsdevel/YeNyzoDM5hP5LtGW@visor/
> > Fixes: 49246466a989 ("fsnotify: move fsnotify_nameremove() hook out of d_delete()")
> > Cc: stable@vger.kernel.org # v5.3+
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>
> ...
>
> > diff --git a/fs/namei.c b/fs/namei.c
> > index 1f9d2187c765..b11991b57f9b 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -3929,6 +3929,23 @@ SYSCALL_DEFINE2(mkdir, const char __user *, pathname, umode_t, mode)
> >       return do_mkdirat(AT_FDCWD, getname(pathname), mode);
> >  }
> >
> > +/**
> > + * d_delete_notify - delete a dentry and call fsnotify_delete()
> > + * @dentry: The dentry to delete
> > + *
> > + * This helper is used to guaranty that the unlinked inode cannot be found
>                              ^^^ guarantee
>
> > + * by lookup of this name after fsnotify_delete() event has been delivered.
> > + */
> > +static void d_delete_notify(struct inode *dir, struct dentry *dentry)
> > +{
> > +     struct inode *inode = d_inode(dentry);
> > +
> > +     ihold(inode);
> > +     d_delete(dentry);
> > +     fsnotify_delete(dir, inode, dentry);
> > +     iput(inode);
> > +}
> > +
> >  /**
> >   * vfs_rmdir - remove directory
> >   * @mnt_userns:      user namespace of the mount the inode was found from
> ...
> > @@ -4101,7 +4117,6 @@ int vfs_unlink(struct user_namespace *mnt_userns, struct inode *dir,
> >                       if (!error) {
> >                               dont_mount(dentry);
> >                               detach_mounts(dentry);
> > -                             fsnotify_unlink(dir, dentry);
> >                       }
> >               }
> >       }
> > @@ -4109,9 +4124,11 @@ int vfs_unlink(struct user_namespace *mnt_userns, struct inode *dir,
> >       inode_unlock(target);
> >
> >       /* We don't d_delete() NFS sillyrenamed files--they still exist. */
> > -     if (!error && !(dentry->d_flags & DCACHE_NFSFS_RENAMED)) {
> > +     if (dentry->d_flags & DCACHE_NFSFS_RENAMED) {
> > +             fsnotify_unlink(dir, dentry);
> > +     } else if (!error) {
> >               fsnotify_link_count(target);
> > -             d_delete(dentry);
> > +             d_delete_notify(dir, dentry);
> >       }
>
> Are we sure that if DCACHE_NFSFS_RENAMED is set, error == 0? Maybe yes but
> it is not completely clear to me - e.g. if you try to rename something to a
> name that is taken by sillyrenamed file, the unlink will fail but dentry
> has DCACHE_NFSFS_RENAMED set...
>

That's an oversight.

> > +/*
> > + * fsnotify_delete - @dentry was unlinked and unhashed
> > + *
> > + * Caller must make sure that dentry->d_name is stable.
> > + *
> > + * Note: unlike fsnotify_unlink(), we have to pass also the unlinked inode
> > + * as this may be called after d_delete() and old_dentry may be negative.
> > + */
> > +static inline void fsnotify_delete(struct inode *dir, struct inode *inode,
> > +                                struct dentry *dentry)
> > +{
> > +     __u32 mask = FS_DELETE;
> > +
> > +     if (S_ISDIR(inode->i_mode))
> > +             mask |= FS_ISDIR;
> > +
> > +     fsnotify_name(mask, inode, FSNOTIFY_EVENT_INODE, dir, &dentry->d_name,
> > +                   0);
> > +}
> > +
>
> OK, this is fine because we use dentry only for FAN_RENAME event, don't we?

Almost.
We also use dentry in FS_CREATE to get sb from d_sb for error event, because:
 * Note: some filesystems (e.g. kernfs) leave @dentry negative and instantiate
 * ->d_inode later

> In all other cases we always use only inode anyway. Can we perhaps cleanup
> include/linux/fsnotify.h to use FSNOTIFY_EVENT_DENTRY only in that one call
> site inside fsnotify_move() and use FSNOTIFY_EVENT_INODE in all the other
> cases? So that this is clear and also so that we don't start using dentry
> inadvertedly for something inside fsnotify thus breaking unlink reporting
> in subtle ways...
>

I don't know.
For fsnotify_unlink/rmdir we check d_is_negative, so it's fine to use
FSNOTIFY_EVENT_INODE.
For fsnotify_link,fsnotify_move we get the inode explicitly, but we already
use FSNOTIFY_EVENT_INODE in those cases (except FS_RENAME).

Thanks,
Amir.
