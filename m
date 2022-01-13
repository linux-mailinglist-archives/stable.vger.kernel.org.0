Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6546E48DDFD
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 20:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbiAMTCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 14:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237805AbiAMTCV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 14:02:21 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8740EC06161C;
        Thu, 13 Jan 2022 11:02:20 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id w16so26610627edc.11;
        Thu, 13 Jan 2022 11:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BYuO2RToGrqH8LgFfhvjBYsbSoicgjpkDp2gRNvqWQY=;
        b=DZ/kbWgGMCTHV+uHtOVk0+tROYcfvDCgCOtrieSG8Ny8eX5ZPA1/remMhqbVrXcPGk
         uXPygKvZIuTlj/52UHMLFqG0+LzYpt4jOyagC8NNAlQlE2DChbTYwpWyHXmuhgAhnyb3
         IPqIApubpmJhFsp2RIZsHVLgqiXdvUQbwPtpoEqer4yIfcjgEmHh+RDukAHuBbSaK7JX
         M0gqTGI+BRSdf/m1kDhWI/n3i/loiNxiIdKejxBtUE10gK6KiuRtumREUnT4jPyGoATZ
         Ra5oNtcki7J4ERsAC2YRNAUNYCWfZajR4fTKlORkWmPGkerwlJlgPCs42UiBbOXC6Kpl
         MisQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BYuO2RToGrqH8LgFfhvjBYsbSoicgjpkDp2gRNvqWQY=;
        b=S+Ygm3ufdzrAeLZvuwOL2bYX9tYpzCgsOJWjsQdnQgdTp8vesXU1dMs6GpjvOkxucM
         KfKZ1oz9d1YTv0wbmReLeaFbKU3mBO3UmOOwihkXQqm16zIczzIZsn26rd+tAFUxD9Td
         pK4cq5/EOfyeWDdN1ZxLQiARQ9QAvwfMkhdV3MG6Nc7aM82KmTD9YV4l+t8VnzaZkhm6
         Y1GChjGwPR3d5ojWYDdSHyuBScCEuweZXqMjl0BrMbuS8z+OWq8lw2q/GJRkUtM0qJbF
         dgfiGL/DzK/f5lQNYf4nf3gNw4vq9J5/EHoWDhfFYnkgRBvt+VAjD31VUF0gdK1EMj2z
         bMtA==
X-Gm-Message-State: AOAM5319i/e9Ux9+NFbSvFUKJ9kpPEwKCIyW2llbXHGmT1XNmaUxq3QP
        Vef7BvuVYwQxNO/iGu15DDdMsEUiJquszU43a7g=
X-Google-Smtp-Source: ABdhPJz+GwLUrKvddOdQvVc3w8lNqKV1TIumclPWYxvOpP6lr10DXXA80B+w1hRkNtLCBFLOIzskrax6dHUBXGApSN0=
X-Received: by 2002:a17:906:f251:: with SMTP id gy17mr4787717ejb.377.1642100539082;
 Thu, 13 Jan 2022 11:02:19 -0800 (PST)
MIME-Version: 1.0
References: <20220112215625.4144871-1-shy828301@gmail.com> <CAG48ez3y2YGfKRJ6ocR1GT9w9iuGfyypbE+cQgYVZhSta89WUg@mail.gmail.com>
In-Reply-To: <CAG48ez3y2YGfKRJ6ocR1GT9w9iuGfyypbE+cQgYVZhSta89WUg@mail.gmail.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Thu, 13 Jan 2022 11:02:06 -0800
Message-ID: <CAHbLzkrY0j_Wkfe6LS0pYcY97Y+SKQ4=nUADh9QR7C8Pk=_PJg@mail.gmail.com>
Subject: Re: [PATCH] fs/proc: task_mmu.c: don't read mapcount for migration entry
To:     Jann Horn <jannh@google.com>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 13, 2022 at 2:10 AM Jann Horn <jannh@google.com> wrote:
>
> On Wed, Jan 12, 2022 at 10:56 PM Yang Shi <shy828301@gmail.com> wrote:
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
> > Reported-by: syzbot+1f52b3a18d5633fa7f82@syzkaller.appspotmail.com
>
> maybe add:
>
> Fixes: b1d4d9e0cbd0 ("proc/smaps: carefully handle migration entries")

Yeah, absolutely, thanks for finding the proper fix tag. It is quite
an old commit.

>
> > Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > Cc: Jann Horn <jannh@google.com>
> > Cc: Matthew Wilcox <willy@infradead.org>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Yang Shi <shy828301@gmail.com>
