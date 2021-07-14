Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD123C7FAB
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 09:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238404AbhGNICX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 04:02:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238287AbhGNICW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 04:02:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E0C96128B;
        Wed, 14 Jul 2021 07:59:28 +0000 (UTC)
Date:   Wed, 14 Jul 2021 09:59:25 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     syzbot <syzbot+283ce5a46486d6acdbaf@syzkaller.appspotmail.com>,
        brauner@kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        gscrivan@redhat.com, Christoph Hellwig <hch@lst.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable-commits@vger.kernel.org, stable <stable@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [syzbot] KASAN: null-ptr-deref Read in filp_close (2)
Message-ID: <20210714075925.jtlfrhhuj4bzff3m@wittgenstein>
References: <00000000000069c40405be6bdad4@google.com>
 <000000000000b00c1105c6f971b2@google.com>
 <CAHk-=wgWv1s1FbTxS+T7kbF-7LLm9Nz1eC+WBn+kr1WdYGtisA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wgWv1s1FbTxS+T7kbF-7LLm9Nz1eC+WBn+kr1WdYGtisA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 13, 2021 at 11:49:14AM -0700, Linus Torvalds wrote:
> On Mon, Jul 12, 2021 at 9:12 PM syzbot
> <syzbot+283ce5a46486d6acdbaf@syzkaller.appspotmail.com> wrote:
> >
> > syzbot has found a reproducer for the following issue on:
> 
> Hmm.
> 
> This issue is reported to have been already fixed:
> 
>     Fix commit: 9b5b8722 file: fix close_range() for unshare+cloexec
> 
> and that fix is already in the reported HEAD commit:
> 
> > HEAD commit:    7fef2edf sd: don't mess with SD_MINORS for CONFIG_DEBUG_BL..
> 
> and the oops report clearly is from that:
> 
> > CPU: 1 PID: 8445 Comm: syz-executor493 Not tainted 5.14.0-rc1-syzkaller #0
> 
> so the alleged fix is already there.
> 
> So clearly commit 9b5b872215fe ("file: fix close_range() for
> unshare+cloexec") does *NOT* fix the issue.
> 
> This was originally bisected to that 582f1fb6b721 ("fs, close_range:
> add flag CLOSE_RANGE_CLOEXEC") in
> 
>      https://syzkaller.appspot.com/bug?id=1bef50bdd9622a1969608d1090b2b4a588d0c6ac
> 
> which is where the "fix" is from.
> 
> It would probably be good if sysbot made this kind of "hey, it was
> reported fixed, but it's not" very clear.
> 
> The KASAN report looks like a use-after-free, and that "use" is
> actually the sanity check that the file count is non-zero, so it's
> really a "struct file *" that has already been free'd.
> 
> That bogus free is a regular close() system call
> 
> >  filp_close+0x22/0x170 fs/open.c:1306
> >  close_fd+0x5c/0x80 fs/file.c:628
> >  __do_sys_close fs/open.c:1331 [inline]
> >  __se_sys_close fs/open.c:1329 [inline]
> 
> And it was opened by a "creat()" system call:
> 
> > Allocated by task 8445:
> >  __alloc_file+0x21/0x280 fs/file_table.c:101
> >  alloc_empty_file+0x6d/0x170 fs/file_table.c:150
> >  path_openat+0xde/0x27f0 fs/namei.c:3493
> >  do_filp_open+0x1aa/0x400 fs/namei.c:3534
> >  do_sys_openat2+0x16d/0x420 fs/open.c:1204
> >  do_sys_open fs/open.c:1220 [inline]
> >  __do_sys_creat fs/open.c:1294 [inline]
> >  __se_sys_creat fs/open.c:1288 [inline]
> >  __x64_sys_creat+0xc9/0x120 fs/open.c:1288
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> But it has apparently already been closed from a workqueue:
> 
> > Freed by task 8445:
> >  __fput+0x288/0x920 fs/file_table.c:280
> >  task_work_run+0xdd/0x1a0 kernel/task_work.c:164
> 
> So it's some kind of confusion and re-use of a struct file pointer.
> 
> Which is certainly consistent with the "fix" in 9b5b872215fe ("file:
> fix close_range() for unshare+cloexec"), but it very much looks like
> that fix was incomplete and not the full story.
> 
> Some fdtable got re-allocated? The fix that wasn't a fix ends up
> re-checking the maximum file number under the file_lock, but there's
> clearly something else going on too.
> 
> Christian?

Looking into this now.

I have to say I'm very confused by the syzkaller report here.

If I go to

https://syzkaller.appspot.com/bug?extid=283ce5a46486d6acdbaf

which is the original link in the report it shows me

android-54	KASAN: use-after-free Read in filp_close	C			2	183d	183d	0/1	upstream: reported C repro on 2021/01/11 12:38

which seems to indicate that this happened on an Android specific 5.4
kernel?

But ok, so I click on the link "upstream: reported C repro on 2021/01/11 12:38"
which takes me to a google group

https://groups.google.com/g/syzkaller-android-bugs/c/FQj0qcRSy_M/m/wrY70QFzBAAJ

which again strongly indicates that this is an Android specific kernel?

HEAD commit: c9951e5d Merge 5.4.88 into android12-5.4
git tree: android12-5.4

but then I can click on the dashboard link for that crash report and it
takes me to:

https://syzkaller.appspot.com/bug?extid=53897bcb31b82c7a08fe

which seems to be the upstream report?

So I'm a bit confused whether I'm even looking at the correct bug report
but I'll just give the repro a try and see what's going on.

Christian
