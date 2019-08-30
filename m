Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2962CA3250
	for <lists+stable@lfdr.de>; Fri, 30 Aug 2019 10:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfH3I2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Aug 2019 04:28:51 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43417 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfH3I2v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Aug 2019 04:28:51 -0400
Received: by mail-io1-f68.google.com with SMTP id u185so8581361iod.10;
        Fri, 30 Aug 2019 01:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FnQGezDYO5hoi4qMr6hFteu6J0hxc2afK6Bu1JCgpJs=;
        b=J0175i7PLeHrpTIwJsAcjfdidXf+v04TTsZELE9ltkPQ4tU0FTMGiEGfrh7gzahRcN
         gI+2m7WmnEzGmVtL3lyOvPLu7WpeJgT7zFZPDvYyusZZXIYHpGS3KoTemenCmRAWNvKQ
         lBpSeCe5b/5846aDMypZHsV6xObfkqZ8XP2ezfzf/I4kGiRPvHd4/D2+X+aU5u9bFwzI
         DiL9qH19yqf1m3gkHvPWFC5Ra2kJjO2qSOMNd4qfNlma5nCIVbpbA2RF+V1MnAC8nV4E
         uKvZ0eEVqRYb8OGAV3fCBPv+5v/DwhFuh55ASVp/AvZmnT2aKq0ZeEE+qRi4aVlcJo9Z
         7XTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FnQGezDYO5hoi4qMr6hFteu6J0hxc2afK6Bu1JCgpJs=;
        b=nsDDoj16Ko9L5+cmuHbARIBt1qVToQ8rrPEtJf23Zn2X45QIFnB6NuXYVsribmrO4I
         sHVGn1mwN9yBds6FChZp2hprEF2emEHIBfmqdHLZWPbAEHKAWIbHRLZh9FiRXiaqppWl
         gx0AJwS0MQGkwHwtBnAJZCllfny4qrUV92C510HBwJu474kPBoYjt0RcvbTrjpCJI/9c
         WYR4arC57MVTx7eQaxyfSdFxcRRKUEJQ3UmQAFDv1k8M+5m53CJXjj73Q7L1leL5TS6H
         a7e7zntT2FXRRY0pdj547NNOl5qGgwMp5RNkDnVKfTHxX1WrkmqN5MWWoc1tckD3D1wd
         8tDA==
X-Gm-Message-State: APjAAAX6A9dBjj/J37LJaewwBS+0XiZuREmb1sBaLG1Ha0BuvmvnE1sr
        zztxQm9lGDqp3C75uzjhLTdJCb1c6e0pSvvrpRU=
X-Google-Smtp-Source: APXvYqzh4ZWbYUgOrIXRKzNwKFlVdvLdRsMAd4czJUiBBQ34pQ8gvCsfatlbWy3/zbYJpGODP3+G603e8CbSc4iZKHc=
X-Received: by 2002:a5d:9d49:: with SMTP id k9mr1449448iok.106.1567153729688;
 Fri, 30 Aug 2019 01:28:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190829181311.7562-1-sashal@kernel.org> <20190829181311.7562-66-sashal@kernel.org>
 <CAOi1vP9-A-U6J15hT+XmtXzBw5WVRZECry8gPFzqp0CV36ecig@mail.gmail.com> <20190829211640.GN5281@sasha-vm>
In-Reply-To: <20190829211640.GN5281@sasha-vm>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 30 Aug 2019 10:31:53 +0200
Message-ID: <CAOi1vP-EPJ5VfEAMa_-4LyNv-mXf1acozoa=Z0kHDMAnVKfGxw@mail.gmail.com>
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

On Thu, Aug 29, 2019 at 11:16 PM Sasha Levin <sashal@kernel.org> wrote:
>
> On Thu, Aug 29, 2019 at 10:51:04PM +0200, Ilya Dryomov wrote:
> >On Thu, Aug 29, 2019 at 8:15 PM Sasha Levin <sashal@kernel.org> wrote:
> >>
> >> From: Luis Henriques <lhenriques@suse.com>
> >>
> >> [ Upstream commit 86968ef21596515958d5f0a40233d02be78ecec0 ]
> >>
> >> Calling ceph_buffer_put() in __ceph_setxattr() may end up freeing the
> >> i_xattrs.prealloc_blob buffer while holding the i_ceph_lock.  This can be
> >> fixed by postponing the call until later, when the lock is released.
> >>
> >> The following backtrace was triggered by fstests generic/117.
> >>
> >>   BUG: sleeping function called from invalid context at mm/vmalloc.c:2283
> >>   in_atomic(): 1, irqs_disabled(): 0, pid: 650, name: fsstress
> >>   3 locks held by fsstress/650:
> >>    #0: 00000000870a0fe8 (sb_writers#8){.+.+}, at: mnt_want_write+0x20/0x50
> >>    #1: 00000000ba0c4c74 (&type->i_mutex_dir_key#6){++++}, at: vfs_setxattr+0x55/0xa0
> >>    #2: 000000008dfbb3f2 (&(&ci->i_ceph_lock)->rlock){+.+.}, at: __ceph_setxattr+0x297/0x810
> >>   CPU: 1 PID: 650 Comm: fsstress Not tainted 5.2.0+ #437
> >>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58-prebuilt.qemu.org 04/01/2014
> >>   Call Trace:
> >>    dump_stack+0x67/0x90
> >>    ___might_sleep.cold+0x9f/0xb1
> >>    vfree+0x4b/0x60
> >>    ceph_buffer_release+0x1b/0x60
> >>    __ceph_setxattr+0x2b4/0x810
> >>    __vfs_setxattr+0x66/0x80
> >>    __vfs_setxattr_noperm+0x59/0xf0
> >>    vfs_setxattr+0x81/0xa0
> >>    setxattr+0x115/0x230
> >>    ? filename_lookup+0xc9/0x140
> >>    ? rcu_read_lock_sched_held+0x74/0x80
> >>    ? rcu_sync_lockdep_assert+0x2e/0x60
> >>    ? __sb_start_write+0x142/0x1a0
> >>    ? mnt_want_write+0x20/0x50
> >>    path_setxattr+0xba/0xd0
> >>    __x64_sys_lsetxattr+0x24/0x30
> >>    do_syscall_64+0x50/0x1c0
> >>    entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >>   RIP: 0033:0x7ff23514359a
> >>
> >> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> >> Reviewed-by: Jeff Layton <jlayton@kernel.org>
> >> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> >> Signed-off-by: Sasha Levin <sashal@kernel.org>
> >> ---
> >>  fs/ceph/xattr.c | 8 ++++++--
> >>  1 file changed, 6 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> >> index 0619adbcbe14c..8382299fc2d84 100644
> >> --- a/fs/ceph/xattr.c
> >> +++ b/fs/ceph/xattr.c
> >> @@ -1028,6 +1028,7 @@ int __ceph_setxattr(struct inode *inode, const char *name,
> >>         struct ceph_inode_info *ci = ceph_inode(inode);
> >>         struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
> >>         struct ceph_cap_flush *prealloc_cf = NULL;
> >> +       struct ceph_buffer *old_blob = NULL;
> >>         int issued;
> >>         int err;
> >>         int dirty = 0;
> >> @@ -1101,13 +1102,15 @@ int __ceph_setxattr(struct inode *inode, const char *name,
> >>                 struct ceph_buffer *blob;
> >>
> >>                 spin_unlock(&ci->i_ceph_lock);
> >> -               dout(" preaallocating new blob size=%d\n", required_blob_size);
> >> +               ceph_buffer_put(old_blob); /* Shouldn't be required */
> >> +               dout(" pre-allocating new blob size=%d\n", required_blob_size);
> >>                 blob = ceph_buffer_new(required_blob_size, GFP_NOFS);
> >>                 if (!blob)
> >>                         goto do_sync_unlocked;
> >>                 spin_lock(&ci->i_ceph_lock);
> >> +               /* prealloc_blob can't be released while holding i_ceph_lock */
> >>                 if (ci->i_xattrs.prealloc_blob)
> >> -                       ceph_buffer_put(ci->i_xattrs.prealloc_blob);
> >> +                       old_blob = ci->i_xattrs.prealloc_blob;
> >>                 ci->i_xattrs.prealloc_blob = blob;
> >>                 goto retry;
> >>         }
> >> @@ -1123,6 +1126,7 @@ int __ceph_setxattr(struct inode *inode, const char *name,
> >>         }
> >>
> >>         spin_unlock(&ci->i_ceph_lock);
> >> +       ceph_buffer_put(old_blob);
> >>         if (lock_snap_rwsem)
> >>                 up_read(&mdsc->snap_rwsem);
> >>         if (dirty)
> >
> >Hi Sasha,
> >
> >I didn't tag i_ceph_lock series for stable because this is a very old
> >bug which no one ever hit in real life, at least to my knowledge.
>
> I can drop it if you prefer.

Either is fine with me.  I just wanted to explain my rationale for not
tagging them for stable in the first place and point out that there is
a prerequisite.

Thanks,

                Ilya
