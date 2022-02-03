Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE3CF4A8B68
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 19:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343491AbiBCSTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 13:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234287AbiBCSTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 13:19:13 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604D9C061714;
        Thu,  3 Feb 2022 10:19:12 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id s5so11371936ejx.2;
        Thu, 03 Feb 2022 10:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MXUPAf5aXmp6w/5uWB/DhRxTO8yyeowOCWlMvMizPTE=;
        b=CqIEFZuDwccYOvD96Az75oR/nYY+OofjGMJ5LLA+B/Jth8srxNJ3XTNuMOxmFEdSpo
         d3AvxokjJmXWlE4N8eUyt40LiSuBqOP5YzNDY860q+9NL9DDup9jK2FYbk5IHlqY0Whk
         D6t0NKnafNn5oMf1hE18ZdnCBrp+5trObYFGkYtJD4ERTcyGlvkwuMy0Tolq9l16OYuj
         LmwbEhjtJzOsLyGdzrsJyebZTiOun7VB1n4PEeanxz1DEvJrg3A/qWFcKJO2eU38zKpH
         opRIa7INcEHH3bQTppwq3qTm6HPMHNkeN0D1ckkPQA/emfFu0RU9ewQAbJZlLFgTYbRa
         xJVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MXUPAf5aXmp6w/5uWB/DhRxTO8yyeowOCWlMvMizPTE=;
        b=Prb/2NuX4MHSCKsL0QDFXS05e3L2OWfIyAqnl7cLQqmKo8ObLZmZ002fOVY7ICqSbE
         xFUk5OxyjGyBaQGiz/dF90y4h86GBnR/yrWhRqKJ1hZa7w41yoOARY88oqNN0BAHf/Nm
         +zN2abhzeSic/iDhhjF26IJIjbggoxaPt5cBAxsVMcuvTceZeiz6ECs52JmXR+Zefg9j
         XVbSTngcSzecqrfJ+Yh2HnvSuariD0x8VjA2X0vWXVNE9xG3zUAGYqW8T2EFH5ansnTs
         tbu5EB5rwYrsG50LaMcbl/3CsJEHkA2kyeHijxgcADBScVC0UWQRnHS/8p6i5cxk2ZU5
         kt7g==
X-Gm-Message-State: AOAM532turoxi8aGVl1/4JFzOkpZXQSsv+tIm79QNsEjzxlQmM2lFH6s
        HGdhLvCcVuyxHlplB7ygt5+fSVx3XZLdlbGm7eM=
X-Google-Smtp-Source: ABdhPJx/p2dXpsI30KxLEdXxUBHffNnvD5GM3myjox1llU6UgosBPf62UpKdu7Y4008UhmdufeocRGwYNKVVTgISNLE=
X-Received: by 2002:a17:907:6089:: with SMTP id ht9mr29709939ejc.612.1643912350815;
 Thu, 03 Feb 2022 10:19:10 -0800 (PST)
MIME-Version: 1.0
References: <20220201223837.790617-1-shy828301@gmail.com> <eef6fe68-1501-b07c-acc9-287e76c65420@redhat.com>
In-Reply-To: <eef6fe68-1501-b07c-acc9-287e76c65420@redhat.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Thu, 3 Feb 2022 10:18:53 -0800
Message-ID: <CAHbLzkqxe0-5AKp2ALPYpisfiYKFk2Fp8w8JP0viYoAry2aiKA@mail.gmail.com>
Subject: Re: [v3 PATCH] fs/proc: task_mmu.c: don't read mapcount for migration entry
To:     David Hildenbrand <david@redhat.com>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jann Horn <jannh@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 1, 2022 at 11:53 PM David Hildenbrand <david@redhat.com> wrote:
>
> On 01.02.22 23:38, Yang Shi wrote:
> > The syzbot reported the below BUG:
> >
> > kernel BUG at include/linux/page-flags.h:785!
> > invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> > CPU: 1 PID: 4392 Comm: syz-executor560 Not tainted 5.16.0-rc6-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > RIP: 0010:PageDoubleMap include/linux/page-flags.h:785 [inline]
> > RIP: 0010:__page_mapcount+0x2d2/0x350 mm/util.c:744
> > Code: e8 d3 16 d1 ff 48 c7 c6 c0 00 b6 89 48 89 ef e8 94 4e 04 00 0f 0b e8 bd 16 d1 ff 48 c7 c6 60 01 b6 89 48 89 ef e8 7e 4e 04 00 <0f> 0b e8 a7 16 d1 ff 48 c7 c6 a0 01 b6 89 4c 89 f7 e8 68 4e 04 00
> > RSP: 0018:ffffc90002b6f7b8 EFLAGS: 00010293
> > RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> > RDX: ffff888019619d00 RSI: ffffffff81a68c12 RDI: 0000000000000003
> > RBP: ffffea0001bdc2c0 R08: 0000000000000029 R09: 00000000ffffffff
> > R10: ffffffff8903e29f R11: 00000000ffffffff R12: 00000000ffffffff
> > R13: 00000000ffffea00 R14: ffffc90002b6fb30 R15: ffffea0001bd8001
> > FS:  00007faa2aefd700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007fff7e663318 CR3: 0000000018c6e000 CR4: 00000000003506e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  <TASK>
> >  page_mapcount include/linux/mm.h:837 [inline]
> >  smaps_account+0x470/0xb10 fs/proc/task_mmu.c:466
> >  smaps_pte_entry fs/proc/task_mmu.c:538 [inline]
> >  smaps_pte_range+0x611/0x1250 fs/proc/task_mmu.c:601
> >  walk_pmd_range mm/pagewalk.c:128 [inline]
> >  walk_pud_range mm/pagewalk.c:205 [inline]
> >  walk_p4d_range mm/pagewalk.c:240 [inline]
> >  walk_pgd_range mm/pagewalk.c:277 [inline]
> >  __walk_page_range+0xe23/0x1ea0 mm/pagewalk.c:379
> >  walk_page_vma+0x277/0x350 mm/pagewalk.c:530
> >  smap_gather_stats.part.0+0x148/0x260 fs/proc/task_mmu.c:768
> >  smap_gather_stats fs/proc/task_mmu.c:741 [inline]
> >  show_smap+0xc6/0x440 fs/proc/task_mmu.c:822
> >  seq_read_iter+0xbb0/0x1240 fs/seq_file.c:272
> >  seq_read+0x3e0/0x5b0 fs/seq_file.c:162
> >  vfs_read+0x1b5/0x600 fs/read_write.c:479
> >  ksys_read+0x12d/0x250 fs/read_write.c:619
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > RIP: 0033:0x7faa2af6c969
> > Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007faa2aefd288 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> > RAX: ffffffffffffffda RBX: 00007faa2aff4418 RCX: 00007faa2af6c969
> > RDX: 0000000000002025 RSI: 0000000020000100 RDI: 0000000000000003
> > RBP: 00007faa2aff4410 R08: 00007faa2aefd700 R09: 0000000000000000
> > R10: 00007faa2aefd700 R11: 0000000000000246 R12: 00007faa2afc20ac
> > R13: 00007fff7e6632bf R14: 00007faa2aefd400 R15: 0000000000022000
> >  </TASK>
> > Modules linked in:
> > ---[ end trace 24ec93ff95e4ac3d ]---
> > RIP: 0010:PageDoubleMap include/linux/page-flags.h:785 [inline]
> > RIP: 0010:__page_mapcount+0x2d2/0x350 mm/util.c:744
> > Code: e8 d3 16 d1 ff 48 c7 c6 c0 00 b6 89 48 89 ef e8 94 4e 04 00 0f 0b e8 bd 16 d1 ff 48 c7 c6 60 01 b6 89 48 89 ef e8 7e 4e 04 00 <0f> 0b e8 a7 16 d1 ff 48 c7 c6 a0 01 b6 89 4c 89 f7 e8 68 4e 04 00
> > RSP: 0018:ffffc90002b6f7b8 EFLAGS: 00010293
> > RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> > RDX: ffff888019619d00 RSI: ffffffff81a68c12 RDI: 0000000000000003
> > RBP: ffffea0001bdc2c0 R08: 0000000000000029 R09: 00000000ffffffff
> > R10: ffffffff8903e29f R11: 00000000ffffffff R12: 00000000ffffffff
> > R13: 00000000ffffea00 R14: ffffc90002b6fb30 R15: ffffea0001bd8001
> > FS:  00007faa2aefd700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007fff7e663318 CR3: 0000000018c6e000 CR4: 00000000003506e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >
> > The reproducer was trying to reading /proc/$PID/smaps when calling
> > MADV_FREE at the mean time.  MADV_FREE may split THPs if it is called
> > for partial THP.  It may trigger the below race:
> >
> >          CPU A                         CPU B
> >          -----                         -----
> > smaps walk:                      MADV_FREE:
> > page_mapcount()
> >   PageCompound()
> >                                  split_huge_page()
> >   page = compound_head(page)
> >   PageDoubleMap(page)
> >
> > When calling PageDoubleMap() this page is not a tail page of THP anymore
> > so the BUG is triggered.
> >
> > This could be fixed by elevated refcount of the page before calling
> > mapcount, but it prevents from counting migration entries, and it seems
> > overkilling because the race just could happen when PMD is split so all
> > PTE entries of tail pages are actually migration entries, and
> > smaps_account() does treat migration entries as mapcount == 1 as Kirill
> > pointed out.
> >
> > Add a new parameter for smaps_account() to tell this entry is migration
> > entry then skip calling page_mapcount().  Don't skip getting mapcount for
> > device private entries since they do track references with mapcount.
> >
> > Pagemap also has the similar issue although it was not reported.  Fixed
> > it as well.
> >
> > Fixes: e9b61f19858a ("thp: reintroduce split_huge_page()")
> > Reported-by: syzbot+1f52b3a18d5633fa7f82@syzkaller.appspotmail.com
> > Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > Cc: Jann Horn <jannh@google.com>
> > Cc: Matthew Wilcox <willy@infradead.org>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Yang Shi <shy828301@gmail.com>
> > ---
> > v3: * Fixed the fix tag, the one used by v2 was not accurate
> >     * Added comment about the risk calling page_mapcount() per David
> >     * Fix pagemap
> >
> > v2: * Added proper fix tag per Jann Horn
> >     * Rebased to the latest linus's tree
> >
> >  fs/proc/task_mmu.c | 38 ++++++++++++++++++++++++++++++--------
> >  1 file changed, 30 insertions(+), 8 deletions(-)
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 18f8c3acbb85..d753eda6020c 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -440,7 +440,8 @@ static void smaps_page_accumulate(struct mem_size_stats *mss,
> >  }
> >
> >  static void smaps_account(struct mem_size_stats *mss, struct page *page,
> > -             bool compound, bool young, bool dirty, bool locked)
> > +             bool compound, bool young, bool dirty, bool locked,
> > +             bool migration)
> >  {
> >       int i, nr = compound ? compound_nr(page) : 1;
> >       unsigned long size = nr * PAGE_SIZE;
> > @@ -467,8 +468,15 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
> >        * page_count(page) == 1 guarantees the page is mapped exactly once.
> >        * If any subpage of the compound page mapped with PTE it would elevate
> >        * page_count().
> > +      *
> > +      * The page_mapcount() is called to get a snapshot of the mapcount.
> > +      * Without holding the page lock this snapshot can be slightly wrong as
> > +      * we cannot always read the mapcount atomically.  It is not safe to
> > +      * call page_mapcount() even with PTL held if the page is not mapped,
> > +      * especially for migration entries.  Treated regular migration entries
> > +      * as mapcount == 1.
>
> Minor nit: s/Treated/Treat/

Will fix in v4.

>
> Thanks!
>
> Acked-by: David Hildenbrand <david@redhat.com>

Thanks.

>
> --
> Thanks,
>
> David / dhildenb
>
