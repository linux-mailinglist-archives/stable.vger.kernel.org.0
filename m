Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542464925B0
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 13:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241876AbiARM1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 07:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234413AbiARM1R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 07:27:17 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E7E8C061574;
        Tue, 18 Jan 2022 04:27:17 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id a2so11483322ilr.0;
        Tue, 18 Jan 2022 04:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pYLlRD99Rz4D8D8EFfAOvi+cuOnyBu6LT0ax/HdUAW8=;
        b=HQENVoDnS5popVrwNgMRiH2t26Msaa3pBT9VvGcHbYXxcMFrniRWByy4qGw+LZmdHC
         SiSVrqR3wF0PNQjtVDmopQcOPUuHt+4p70CBRZDZiG6YXRW3MAZoPWMn0sjruiPhfazD
         ACg1OoJ5jA2nnU672DZrNT3n3kS7PA3jgQ2Olg9jN0Lc3I8HiF12niBR2yOnnKiwfnLO
         FA0grxgWm38yZvIOyqM6DW1zNebvfLiPNt6hE5jYRuHKq0fPuv7aKz3P8LPm9mOqBJgi
         LNOIp6x3X41c/i8mrRiKhDcTiY83jAKdMqFGJjZxq5BAEnzbnPYPOAa3jvIS2pXTM4aq
         /4Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pYLlRD99Rz4D8D8EFfAOvi+cuOnyBu6LT0ax/HdUAW8=;
        b=ElrzmrhH78ML6id+QmUkK4zZAFp8wmBE3r1Z6cHCHAneAGAKy45aGF6SUanHkOjtX3
         AnYu59zEdOHXhHrGT+jIzi7KZ2uvn6Mn8wRT32obtYlMsuRZoEssYubTMLNxFGhjn1wn
         7PBRNUmG585V0aXAMVuNs49vkfrgQ3wjnMaMQKc/L7lDQX+dgOUXkkvvcKfJr/rKs6hB
         zV/FcNwfA+0e8ys/BDbm+XFSxkA0HAQtWUp0tMhwjhiu8DgxEwe5yLCxXs7fTAAkxnzq
         k8o5WkmzPuZeq5LjXTfBYFwu4yRuUSWkkkhWFT6WFWu8yeoXDlj3DrQCDGotEDnvzNCa
         bqwQ==
X-Gm-Message-State: AOAM530anFrtus8BaLBUaOaun/KnaCDXyE3+8l6ZnGLtoJv7dy8EdUs9
        e7w/dSKVFLgbqbYrrbp67X/i+sOfLn7oPVkgMao=
X-Google-Smtp-Source: ABdhPJzpJQUqRjCwGM5v0i9hUV+DkW7ufrPpgzCnbQjGahgFEJ0t2xDaWNS9eavha93xTlAy+YocQMkJ4txbevUvXHI=
X-Received: by 2002:a05:6e02:1948:: with SMTP id x8mr14609753ilu.107.1642508836861;
 Tue, 18 Jan 2022 04:27:16 -0800 (PST)
MIME-Version: 1.0
References: <20220118120031.196123-1-amir73il@gmail.com>
In-Reply-To: <20220118120031.196123-1-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Jan 2022 14:27:05 +0200
Message-ID: <CAOQ4uxg3PJBx6MjDnPYcLjJ-tY-Kc-c1d0YDr7OZAiJ=qk7USw@mail.gmail.com>
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

On Tue, Jan 18, 2022 at 2:00 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Apparently, there are some applications that use IN_DELETE event as an
> invalidation mechanism and expect that if they try to open a file with
> the name reported with the delete event, that it should not contain the
> content of the deleted file.
>
> Commit 49246466a989 ("fsnotify: move fsnotify_nameremove() hook out of
> d_delete()") moved the fsnotify delete hook before d_delete() so fsnotify
> will have access to a positive dentry.
>
> This allowed a race where opening the deleted file via cached dentry
> is now possible after receiving the IN_DELETE event.
>
> To fix the regression, we use two different techniques:
> 1) For call sites that call d_delete() with elevated refcount, convert
>    the call to d_drop() and move the fsnotify hook after d_drop().
> 2) For the vfs helpers that may turn dentry to negative on d_delete(),
>    use a helper d_delete_notify() to pin the inode, so we can pass it
>    to an fsnotify hook after d_delete().
>
> Create a new hook fsnotify_delete() that allows to pass a negative
> dentry and takes the unlinked inode as an argument.
>
> Add a missing fsnotify_unlink() hook in nfsdfs that was found during
> the call sites audit.
>
> Note that the call sites in simple_recursive_removal() follow
> d_invalidate(), so they require no change.
>
> Backporting hint: this regression is from v5.3. Although patch will
> apply with only trivial conflicts to v5.4 and v5.10, it won't build,
> because fsnotify_delete() implementation is different in each of those
> versions (see fsnotify_link()).
>
> Reported-by: Ivan Delalande <colona@arista.com>
> Link: https://lore.kernel.org/linux-fsdevel/YeNyzoDM5hP5LtGW@visor/
> Fixes: 49246466a989 ("fsnotify: move fsnotify_nameremove() hook out of d_delete()")
> Cc: stable@vger.kernel.org # v5.3+
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Jan,
>
> This turned into an audit of fsnotify_unlink/rmdir() call sites, so
> besides fixing the regression, I also added one missing hook and replaced
> most of the d_delete() calls with d_drop() to simplify things.
>
> I will follow up with backports for v5.4 and v5.10 and will send the
> repro to LTP guys.
>
> Thanks,
> Amir.
>
>  fs/btrfs/ioctl.c         |  5 ++---
>  fs/configfs/dir.c        |  6 +++---
>  fs/devpts/inode.c        |  2 +-
>  fs/namei.c               | 27 ++++++++++++++++++++++-----
>  fs/nfsd/nfsctl.c         |  5 +++--
>  include/linux/fsnotify.h | 20 ++++++++++++++++++++
>  net/sunrpc/rpc_pipe.c    |  4 ++--
>  7 files changed, 53 insertions(+), 16 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index edfecfe62b4b..121e8f439996 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3060,10 +3060,9 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
>         btrfs_inode_lock(inode, 0);
>         err = btrfs_delete_subvolume(dir, dentry);
>         btrfs_inode_unlock(inode, 0);
> -       if (!err) {
> +       d_drop(dentry);
> +       if (!err)
>                 fsnotify_rmdir(dir, dentry);
> -               d_delete(dentry);
> -       }
>

oops that an unintentional logic change.
Was supposed to be:

        if (!err) {
+               d_drop(dentry);
                fsnotify_rmdir(dir, dentry);
-               d_delete(dentry);
        }

Anyway, fix is pushed to fsnotify-fixes branch.

Thanks,
Amir.
