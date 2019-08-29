Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62D95A285A
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 22:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfH2UsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 16:48:03 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44419 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfH2UsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 16:48:03 -0400
Received: by mail-io1-f65.google.com with SMTP id j4so9615422iog.11;
        Thu, 29 Aug 2019 13:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I1nzOTXRSvtsbJ+ewgmrwsmeWIh6DuCYG1u3Ks75aJ4=;
        b=dqryB45JKi6c599K+mta/pUXZ+fUf5PjqzxsclCkbRqBj+c2qL8jh7cb7pe5txPSoK
         I+G9tGjnpArIs5qMDd+vfi6ZzE2pKK9qWlI6JDl0dW7pne2y4G/oGvV+sCF66pQlrve/
         LO9P+ZOi0skdAVJwSRvPHa6keJAmU8TJ1x9c/FVQa9MzjWQUX4vZhpbK1xg7Wa9QTtc6
         0HVTlE/bTYj65fujkKuvOe2mW3oqSAyQKSi/txoBvBXAjXMOyNq9lQ58upjNmYooi3zW
         djlydfuUwQEcZ5CmrepPandprZdtvcWLg/2l6JFyHz78Kv471UuCr7SIo6EERno4PNB9
         mZLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I1nzOTXRSvtsbJ+ewgmrwsmeWIh6DuCYG1u3Ks75aJ4=;
        b=LuRsoCiTW6TJaP9WXqYKn4CYuGIRf9AnVFc77HjQ4PYJQrj1Xi4WYOOE0GU5z+jBXB
         xSmWllHj1u2rmIxWc8dOW3BpKKJNXRx9yhKByb5AM1hO8eUnb5hQg78PQMpnTP7DSp5t
         1SQoAjDfINgeVJtS6Svx9tlgPyA8VSIcHYwqTXfqZBsGocKXIej2Hg/gj7NI7zdTE/tr
         pgIH0nGKfUAR4S07KcY6ZtC81DKOJIHRKQqzgsGcFTgBKBsXFMXLGlvfFcZV/3wCxjP7
         p4uN9634KFsZKSuwuunllDjOrE/9QAsxx61h9bHwal2Ok/syHULqJYNYx9DKKAO35dMQ
         M2ZA==
X-Gm-Message-State: APjAAAXPpYYWD7Fflfn9opyILZINpiTCGI/cYdf3EXSRSOhh1Jmx03Zs
        O5YGcnWyXCgYCgZLpVmLNGoit+/cxtO5ALuu6SjHZv8+tfk=
X-Google-Smtp-Source: APXvYqxzpsYrSjNMwic87+EkulVTAG0JIV9CVRFNncFp6ZgIwjvscM/KVpuk7eQkkxhu/nL6vWCyacvLlRGYsyv1QO4=
X-Received: by 2002:a05:6638:3af:: with SMTP id z15mr12495908jap.39.1567111682445;
 Thu, 29 Aug 2019 13:48:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190829181311.7562-1-sashal@kernel.org> <20190829181311.7562-66-sashal@kernel.org>
In-Reply-To: <20190829181311.7562-66-sashal@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 29 Aug 2019 22:51:04 +0200
Message-ID: <CAOi1vP9-A-U6J15hT+XmtXzBw5WVRZECry8gPFzqp0CV36ecig@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.2 66/76] ceph: fix buffer free while holding
 i_ceph_lock in __ceph_setxattr()
To:     Sasha Levin <sashal@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Luis Henriques <lhenriques@suse.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 8:15 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Luis Henriques <lhenriques@suse.com>
>
> [ Upstream commit 86968ef21596515958d5f0a40233d02be78ecec0 ]
>
> Calling ceph_buffer_put() in __ceph_setxattr() may end up freeing the
> i_xattrs.prealloc_blob buffer while holding the i_ceph_lock.  This can be
> fixed by postponing the call until later, when the lock is released.
>
> The following backtrace was triggered by fstests generic/117.
>
>   BUG: sleeping function called from invalid context at mm/vmalloc.c:2283
>   in_atomic(): 1, irqs_disabled(): 0, pid: 650, name: fsstress
>   3 locks held by fsstress/650:
>    #0: 00000000870a0fe8 (sb_writers#8){.+.+}, at: mnt_want_write+0x20/0x50
>    #1: 00000000ba0c4c74 (&type->i_mutex_dir_key#6){++++}, at: vfs_setxattr+0x55/0xa0
>    #2: 000000008dfbb3f2 (&(&ci->i_ceph_lock)->rlock){+.+.}, at: __ceph_setxattr+0x297/0x810
>   CPU: 1 PID: 650 Comm: fsstress Not tainted 5.2.0+ #437
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58-prebuilt.qemu.org 04/01/2014
>   Call Trace:
>    dump_stack+0x67/0x90
>    ___might_sleep.cold+0x9f/0xb1
>    vfree+0x4b/0x60
>    ceph_buffer_release+0x1b/0x60
>    __ceph_setxattr+0x2b4/0x810
>    __vfs_setxattr+0x66/0x80
>    __vfs_setxattr_noperm+0x59/0xf0
>    vfs_setxattr+0x81/0xa0
>    setxattr+0x115/0x230
>    ? filename_lookup+0xc9/0x140
>    ? rcu_read_lock_sched_held+0x74/0x80
>    ? rcu_sync_lockdep_assert+0x2e/0x60
>    ? __sb_start_write+0x142/0x1a0
>    ? mnt_want_write+0x20/0x50
>    path_setxattr+0xba/0xd0
>    __x64_sys_lsetxattr+0x24/0x30
>    do_syscall_64+0x50/0x1c0
>    entry_SYSCALL_64_after_hwframe+0x49/0xbe
>   RIP: 0033:0x7ff23514359a
>
> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/ceph/xattr.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 0619adbcbe14c..8382299fc2d84 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -1028,6 +1028,7 @@ int __ceph_setxattr(struct inode *inode, const char *name,
>         struct ceph_inode_info *ci = ceph_inode(inode);
>         struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>         struct ceph_cap_flush *prealloc_cf = NULL;
> +       struct ceph_buffer *old_blob = NULL;
>         int issued;
>         int err;
>         int dirty = 0;
> @@ -1101,13 +1102,15 @@ int __ceph_setxattr(struct inode *inode, const char *name,
>                 struct ceph_buffer *blob;
>
>                 spin_unlock(&ci->i_ceph_lock);
> -               dout(" preaallocating new blob size=%d\n", required_blob_size);
> +               ceph_buffer_put(old_blob); /* Shouldn't be required */
> +               dout(" pre-allocating new blob size=%d\n", required_blob_size);
>                 blob = ceph_buffer_new(required_blob_size, GFP_NOFS);
>                 if (!blob)
>                         goto do_sync_unlocked;
>                 spin_lock(&ci->i_ceph_lock);
> +               /* prealloc_blob can't be released while holding i_ceph_lock */
>                 if (ci->i_xattrs.prealloc_blob)
> -                       ceph_buffer_put(ci->i_xattrs.prealloc_blob);
> +                       old_blob = ci->i_xattrs.prealloc_blob;
>                 ci->i_xattrs.prealloc_blob = blob;
>                 goto retry;
>         }
> @@ -1123,6 +1126,7 @@ int __ceph_setxattr(struct inode *inode, const char *name,
>         }
>
>         spin_unlock(&ci->i_ceph_lock);
> +       ceph_buffer_put(old_blob);
>         if (lock_snap_rwsem)
>                 up_read(&mdsc->snap_rwsem);
>         if (dirty)

Hi Sasha,

I didn't tag i_ceph_lock series for stable because this is a very old
bug which no one ever hit in real life, at least to my knowledge.

Please note that each of these patches requires 5c498950f730 ("libceph:
allow ceph_buffer_put() to receive a NULL ceph_buffer").

Thanks,

                Ilya
