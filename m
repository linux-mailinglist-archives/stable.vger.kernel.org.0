Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043963C840A
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 13:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239275AbhGNLsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 07:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239270AbhGNLsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 07:48:07 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE9BC061760
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 04:45:13 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id j184so1217844qkd.6
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 04:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zxPicnNj0mGB/tmcGMwmXnv6kKv9n+OZmDAsE0BpNOI=;
        b=of51A5jV+4EsLMz/6UFrjhy6Fwu4/1Y9uszSSFtCb/0Qf58qKPNHTrHLxzR3i9kl5H
         4I3px+9vaeR0DpcF+Rcaa67LSUOsU0K7T/QnSGObafY4CCAkzABBHffef050xhPDGRKx
         nCJDI7Qbg4uz8zgkEugfNkFTLdDxsgEwItPs0NXLRLZFfnHIPTTQe+eBnc68wmHgFgIS
         wMi5zaOO+Bp6SD/m8tSFmnr0jmBPm8suupTM9sIdOee2oI4YCcFQgvJOUdi6+omxx7Ag
         m/oLtkyE5+30VLvSlYLKT3kGbUhm1R5pQ44wQF7tn0XU7tKsW9fm7jN+kdH8WV4BgkUg
         c5fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zxPicnNj0mGB/tmcGMwmXnv6kKv9n+OZmDAsE0BpNOI=;
        b=d9KlzBfgfhQzRmSmzi4Dgjtp5UwhIJBJ9czh7nZ4tpL6J7uYISlo78CCypU2y8CO6D
         pnGxMRX6u7g25/oCLWEKYNT5aVeKxPcFIfk6p8Dq7uBSYWaCdBcan35ycRhXKWCKX8dV
         zDUyOrlVVputCEw6p9Opa3SVGzlNpd9el+p6GkQo0BVucgVOyPrJPfxDRVA1kJgznROw
         alB9MsYZCjiQBMqywjNCJMi6aHJSewONmX6OzBfl1VT9JUj3rAVj04Mj8g5TRYBRun0Z
         Uf98dHPMROy/10FrX8Wy7+9o2mXDVctum+a0/XMpiu0+NouA9Ah5UTA942ciNtoUznwC
         gyYg==
X-Gm-Message-State: AOAM5307UkY5XPYnHVe9x07HI6bENiqDeoN53fg+mqbJ5t3fORK+zsz5
        cw1YFI/F3Fn0GfspoNnBOnnUSmF1n7cMfwa4QEQlPg==
X-Google-Smtp-Source: ABdhPJyx4laym9+h+45Vgrl9Y94NJBp3NLiQdaymRY5O2zbiPKn0HRhbZyM0RydO2WGGv8kkyoHL4Glcouyagw3soG4=
X-Received: by 2002:a05:620a:2091:: with SMTP id e17mr844903qka.265.1626263112836;
 Wed, 14 Jul 2021 04:45:12 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000069c40405be6bdad4@google.com> <000000000000b00c1105c6f971b2@google.com>
 <CAHk-=wgWv1s1FbTxS+T7kbF-7LLm9Nz1eC+WBn+kr1WdYGtisA@mail.gmail.com> <20210714075925.jtlfrhhuj4bzff3m@wittgenstein>
In-Reply-To: <20210714075925.jtlfrhhuj4bzff3m@wittgenstein>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 14 Jul 2021 13:45:01 +0200
Message-ID: <CACT4Y+bMWpKPjwaRg0L1x=db20qZc1F-F0DkmDw=-EHVKU8UuA@mail.gmail.com>
Subject: Re: [syzbot] KASAN: null-ptr-deref Read in filp_close (2)
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        syzbot <syzbot+283ce5a46486d6acdbaf@syzkaller.appspotmail.com>,
        brauner@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        gscrivan@redhat.com, Christoph Hellwig <hch@lst.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable-commits@vger.kernel.org, stable <stable@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 14 Jul 2021 at 09:59, Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> On Tue, Jul 13, 2021 at 11:49:14AM -0700, Linus Torvalds wrote:
> > On Mon, Jul 12, 2021 at 9:12 PM syzbot
> > <syzbot+283ce5a46486d6acdbaf@syzkaller.appspotmail.com> wrote:
> > >
> > > syzbot has found a reproducer for the following issue on:
> >
> > Hmm.
> >
> > This issue is reported to have been already fixed:
> >
> >     Fix commit: 9b5b8722 file: fix close_range() for unshare+cloexec
> >
> > and that fix is already in the reported HEAD commit:
> >
> > > HEAD commit:    7fef2edf sd: don't mess with SD_MINORS for CONFIG_DEBUG_BL..
> >
> > and the oops report clearly is from that:
> >
> > > CPU: 1 PID: 8445 Comm: syz-executor493 Not tainted 5.14.0-rc1-syzkaller #0
> >
> > so the alleged fix is already there.
> >
> > So clearly commit 9b5b872215fe ("file: fix close_range() for
> > unshare+cloexec") does *NOT* fix the issue.
> >
> > This was originally bisected to that 582f1fb6b721 ("fs, close_range:
> > add flag CLOSE_RANGE_CLOEXEC") in
> >
> >      https://syzkaller.appspot.com/bug?id=1bef50bdd9622a1969608d1090b2b4a588d0c6ac
> >
> > which is where the "fix" is from.
> >
> > It would probably be good if sysbot made this kind of "hey, it was
> > reported fixed, but it's not" very clear.
> >
> > The KASAN report looks like a use-after-free, and that "use" is
> > actually the sanity check that the file count is non-zero, so it's
> > really a "struct file *" that has already been free'd.
> >
> > That bogus free is a regular close() system call
> >
> > >  filp_close+0x22/0x170 fs/open.c:1306
> > >  close_fd+0x5c/0x80 fs/file.c:628
> > >  __do_sys_close fs/open.c:1331 [inline]
> > >  __se_sys_close fs/open.c:1329 [inline]
> >
> > And it was opened by a "creat()" system call:
> >
> > > Allocated by task 8445:
> > >  __alloc_file+0x21/0x280 fs/file_table.c:101
> > >  alloc_empty_file+0x6d/0x170 fs/file_table.c:150
> > >  path_openat+0xde/0x27f0 fs/namei.c:3493
> > >  do_filp_open+0x1aa/0x400 fs/namei.c:3534
> > >  do_sys_openat2+0x16d/0x420 fs/open.c:1204
> > >  do_sys_open fs/open.c:1220 [inline]
> > >  __do_sys_creat fs/open.c:1294 [inline]
> > >  __se_sys_creat fs/open.c:1288 [inline]
> > >  __x64_sys_creat+0xc9/0x120 fs/open.c:1288
> > >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > >  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> > >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> >
> > But it has apparently already been closed from a workqueue:
> >
> > > Freed by task 8445:
> > >  __fput+0x288/0x920 fs/file_table.c:280
> > >  task_work_run+0xdd/0x1a0 kernel/task_work.c:164
> >
> > So it's some kind of confusion and re-use of a struct file pointer.
> >
> > Which is certainly consistent with the "fix" in 9b5b872215fe ("file:
> > fix close_range() for unshare+cloexec"), but it very much looks like
> > that fix was incomplete and not the full story.
> >
> > Some fdtable got re-allocated? The fix that wasn't a fix ends up
> > re-checking the maximum file number under the file_lock, but there's
> > clearly something else going on too.
> >
> > Christian?
>
> Looking into this now.
>
> I have to say I'm very confused by the syzkaller report here.
>
> If I go to
>
> https://syzkaller.appspot.com/bug?extid=283ce5a46486d6acdbaf
>
> which is the original link in the report it shows me
>
> android-54      KASAN: use-after-free Read in filp_close        C                       2       183d    183d    0/1     upstream: reported C repro on 2021/01/11 12:38
>
> which seems to indicate that this happened on an Android specific 5.4
> kernel?

Hi Christian,

That's "similar bugs" section. In this section syzbot shows previous
similar bugs and similar bugs on other kernels (lts, android).

"KASAN: use-after-free Read in filp_close" also happened on Android
tree, if you click on the link, you can see crashes and reproducers on
the android tree:
https://syzkaller.appspot.com/bug?id=255edc9d4f00a881d3bf68b87d09a8b7843409e7

If you are interested only in upstream crashes/reproducers, then
ignore the "similar bugs" section.


> But ok, so I click on the link "upstream: reported C repro on 2021/01/11 12:38"
> which takes me to a google group
>
> https://groups.google.com/g/syzkaller-android-bugs/c/FQj0qcRSy_M/m/wrY70QFzBAAJ
>
> which again strongly indicates that this is an Android specific kernel?
>
> HEAD commit: c9951e5d Merge 5.4.88 into android12-5.4
> git tree: android12-5.4
>
> but then I can click on the dashboard link for that crash report and it
> takes me to:
>
> https://syzkaller.appspot.com/bug?extid=53897bcb31b82c7a08fe
>
> which seems to be the upstream report?
>
> So I'm a bit confused whether I'm even looking at the correct bug report
> but I'll just give the repro a try and see what's going on.
>
> Christian
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/20210714075925.jtlfrhhuj4bzff3m%40wittgenstein.
