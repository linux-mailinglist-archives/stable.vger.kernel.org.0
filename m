Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42F562E91CB
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 09:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbhADIgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 03:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbhADIgN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 03:36:13 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EB1C061574;
        Mon,  4 Jan 2021 00:35:32 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id m23so24353887ioy.2;
        Mon, 04 Jan 2021 00:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Swxt5GP34KImzcldIcSZSeux0tNoxofo5H5/a1gDAO4=;
        b=BeyAJtQJMePVN/9bcTvnjqKwoy28eZLR3TXqGDKAWp6WyorU6A4DCW73y7akWIyxrD
         5K05CPV/dhgypAxjqn8PTnlVE3Zav5JX5zmcjydElJUPmwR8V4nlEETxoX7e0Mmkuxxj
         jJOJaz+APqROS4WwO7UdPEMHKu2JILz6sm2Kga4yP8X7D3jyJagHIvmp3dTf1M/5aULQ
         mvjZm5oQbET9NknhLtVIKF8ANPUp6CWaehrAGUMJpT/LiMVjS1SIy35inhM5+RCtnBbq
         Q5Oy/D2imaO16g33rgTWc0ZYIJ8b/cgVAjUBg9lpZx0QiW5VpOHxtwE2pLS0RQ0EHkmA
         5Jsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Swxt5GP34KImzcldIcSZSeux0tNoxofo5H5/a1gDAO4=;
        b=gNB9twp8S++wLJO1Icj7U3Lnj56TGVwwUHFheb5RYXVJeopjH3ec0DWDdyiA9pI96w
         JN19kYpK6UusSgBTfG22+httKiBKg57qV53sZTfhUOsujTTe61ilCR3ZwxE5qm57YNG/
         dXAXcvaEG0dV5E0Vo6OU48zfGAMLQHbstUCDT+llFj7JdesHOELitzgV9BvvtEzgML55
         iJOVi8ykuZavPFNdNWBzNyYBmf8kPbdxc7wlwDelQScKa/F5n9YqLYZS8t3vgIn0xhax
         KsJKoheDGyRobfYnWxLNGArEVKlydhcITWd/euU9PXQkFWIuY++8XwDBGGl3pX/IQXuH
         N1ng==
X-Gm-Message-State: AOAM5318kCFpjXdDq3GeNp9Tad99wiOa+kAhdy0lvc0TEuM5n1FdHf0F
        dcybgSrNVWeQdVLn0qgKVURiWdGUy6MaPkaBYPg=
X-Google-Smtp-Source: ABdhPJzfgC8nk4qrOtTkN54zA862MLh0zgHNHT9avOWn6bXOwAi/r6qmEDMrTpbljAm5RzdWyasMjRRsQNuQ/5x18SU=
X-Received: by 2002:a02:9f19:: with SMTP id z25mr60666082jal.30.1609749331741;
 Mon, 04 Jan 2021 00:35:31 -0800 (PST)
MIME-Version: 1.0
References: <20210101201230.768653-1-icenowy@aosc.io> <CAOQ4uxgNWkzVphdB7cAkwdUXagM_NsCUYDRT1f-=X1rn1-KpUQ@mail.gmail.com>
 <a77b2beb832d64f9f019c4505e91c7ffcbbfb61b.camel@aosc.io>
In-Reply-To: <a77b2beb832d64f9f019c4505e91c7ffcbbfb61b.camel@aosc.io>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 4 Jan 2021 10:35:20 +0200
Message-ID: <CAOQ4uxifcZTeZ15jz0PqTs-tQnDDuijV_3QjQ28EayBX-=rtdA@mail.gmail.com>
Subject: Re: [PATCH] ovl: use a dedicated semaphore for dir upperfile caching
To:     Icenowy Zheng <icenowy@aosc.io>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 4, 2021 at 9:28 AM Icenowy Zheng <icenowy@aosc.io> wrote:
>
> =E5=9C=A8 2021-01-03=E6=98=9F=E6=9C=9F=E6=97=A5=E7=9A=84 16:10 +0200=EF=
=BC=8CAmir Goldstein=E5=86=99=E9=81=93=EF=BC=9A
> > On Fri, Jan 1, 2021 at 10:12 PM Icenowy Zheng <icenowy@aosc.io>
> > wrote:
> > >
> > > The function ovl_dir_real_file() currently uses the semaphore of
> > > the
> > > inode to synchronize write to the upperfile cache field.
> > >
> > > However, this function will get called by ovl_ioctl_set_flags(),
> > > which
> > > utilizes the inode semaphore too. In this case ovl_dir_real_file()
> > > will
> > > try to claim a lock that is owned by a function in its call stack,
> > > which
> > > won't get released before ovl_dir_real_file() returns.
> >
> > oops. I wondered why I didn't see any warnings on this from lockdep.
> > Ah! because the xfstest that exercises ovl_ioctl_set_flags() on
> > directory,
> > generic/079, starts with an already upper dir.
> >
> > And the xfstest that checks chattr+i on lower/upper files,
> > overlay/040,
> > does not check chattr on dirs (ioctl on overlay dirs wasn't supported
> > at
> > the time the test was written).
> >
> > Would you be able to create a variant of test overlay/040 that also
> > tests
> > chattr +i on lower/upper dirs to test your patch and confirm that the
> > test
> > fails on master with the appropriate Kconfig debug options.
>
> https://gist.github.com/Icenowy/c7d8decb6812d6e5064d143c57281ad3
>
> Here's a test that would break on master (I used linux-next/master for
> test).

Thanks.
I am working on another test to improve overlay/030 that may also
cover this bug, so maybe no need for both tests. I'll let you know when
I'm done.
If you like, I can post your test for you with your Signed-of-by if I think
it is also needed.

>
> [  246.521880] INFO: task chattr:715 blocked for more than 122 seconds.
> [  246.525659]       Not tainted 5.11.0-rc1-next-20210104+ #20
> [  246.528498] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  246.535076] task:chattr          state:D stack:13736 pid:  715 ppid:
> 529 flags:0x00000000
> [  246.538923] Call Trace:
> [  246.540241]  __schedule+0x2a9/0x820
> [  246.541986]  schedule+0x56/0xc0
> [  246.543616]  rwsem_down_write_slowpath+0x375/0x630
> [  246.545565]  ovl_dir_real_file+0xc1/0x120
> [  246.547512]  ovl_real_fdget+0x35/0x80
> [  246.549303]  ovl_real_ioctl+0x26/0x90
> [  246.551050]  ? mnt_drop_write+0x2c/0x70
> [  246.553068]  ovl_ioctl_set_flags+0x93/0x110
> [  246.555407]  __x64_sys_ioctl+0x7e/0xb0
> [  246.557175]  do_syscall_64+0x33/0x40
> [  246.558869]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  246.561057] RIP: 0033:0x7fe4a3830b67
> [  246.565799] RSP: 002b:00007ffe7ad504f8 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000010
> [  246.569438] RAX: ffffffffffffffda RBX: 0000000000000001 RCX:
> 00007fe4a3830b67
> [  246.572061] RDX: 00007ffe7ad5050c RSI: 0000000040086602 RDI:
> 0000000000000003
> [  246.575509] RBP: 0000000000000003 R08: 0000000000000001 R09:
> 0000000000000000
> [  246.578932] R10: 0000000000000000 R11: 0000000000000246 R12:
> 0000000000000010
> [  246.581014] R13: 00007ffe7ad50810 R14: 0000000000000002 R15:
> 0000000000000001
> [  246.582818]
> [  246.582818] Showing all locks held in the system:
> [  246.584741] 1 lock held by khungtaskd/18:
> [  246.586085]  #0: ffffffff9e951540 (rcu_read_lock){....}-{1:2}, at:
> debug_show_all_locks+0x15/0x100
> [  246.589775] 3 locks held by chattr/715:
> [  246.591364]  #0: ffff96a74b92c450 (sb_writers#11){....}-{0:0}, at:
> ovl_ioctl_set_flags+0x2f/0x110
> [  246.597182]  #1: ffff96a7489c3500
> (&ovl_i_mutex_dir_key[depth]){....}-{3:3}, at:
> ovl_ioctl_set_flags+0x54/0x110
> [  246.601325]  #2: ffff96a7489c3500
> (&ovl_i_mutex_dir_key[depth]){....}-{3:3}, at:
> ovl_dir_real_file+0xc1/0x120
>
> >
> > >
> > > Define a dedicated semaphore for the upperfile cache, so that the
> > > deadlock won't happen.
> > >
> > > Fixes: 61536bed2149 ("ovl: support [S|G]ETFLAGS and FS[S|G]ETXATTR
> > > ioctls for directories")
> > > Cc: stable@vger.kernel.org # v5.10
> > > Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
> > > ---
> > >  fs/overlayfs/readdir.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> > > index 01620ebae1bd..f10701aabb71 100644
> > > --- a/fs/overlayfs/readdir.c
> > > +++ b/fs/overlayfs/readdir.c
> > > @@ -56,6 +56,7 @@ struct ovl_dir_file {
> > >         struct list_head *cursor;
> > >         struct file *realfile;
> > >         struct file *upperfile;
> > > +       struct semaphore upperfile_sem;
> >
> > mutex please
> >

You missed this comment.
semaphore is discouraged as a locking primitive.
Please use struct mutex.

Thanks,
Amir.
