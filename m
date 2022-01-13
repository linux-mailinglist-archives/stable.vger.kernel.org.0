Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B6D48D570
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 11:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiAMKKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 05:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiAMKKf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 05:10:35 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8AC1C061748
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 02:10:34 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id o12so1001239lfu.12
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 02:10:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RadJqXCNgJSuxrAQxYqXMQELWeTlrMxxcxtdQOTtr8I=;
        b=KOvWWdg4A6g44OmDCoCZvBPZQEI06nFjYj0Pw7ezvtKVkrF/I1gr5ijlDWIufHUr2v
         LH2Ehr3FvEMxB55ftrqKAiSs2ncdLIO3FRGyCoNnpE6D8CpD3Wa4aan01lDy7AC214Vm
         pZyet1QGfcz9b6tgyiWBMy15Q2n38nRXJYjZpRuYQfln/gieeGCzhaAvi0Vwmn5tOY1N
         N/hmtiy4BNsqVvpUMoyV+K+AOAv4Fn6Gy6p6Me/PEv4bPJWOjVJdwj71FKcpJ/T1y6Ii
         schqddqevKrc8eZiZAR93pqgVxItnyfWhPQnK7t/FIbLY78oJEWdg0HLh3fonHFMBpu6
         sVYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RadJqXCNgJSuxrAQxYqXMQELWeTlrMxxcxtdQOTtr8I=;
        b=meSJcOamOVprK1L+3NZVl7jT8LzzxmhtOt6C0RMUCu8Impt5kwfqYyDmHlVr/tq/Lb
         +Y6v4/XyhnfZt9hnf8v4N9ErgZPbTgrOLhd0r0pnT9T3f7NHaQtHMfYCcm/kvi+nt5A9
         ILf92G1pmhOKZci+9lppiHfgaqqdPbE8EvivLZapgRjdtnbJ8Gf5ONcjYEX3GHY1vojw
         3W6a7msZfuKqI6EVGx5KRAlpGwPZJz30Aub8pyFE36u9MlMHbHOLgmWwFoeCePqJFCBC
         VhPYUR1wmOiJafG81JLx2bHu7Z9pZiaJI6/QGzG/v3Dt/NXLQSnGaGj+2rNEFIVNY4Ls
         SN4g==
X-Gm-Message-State: AOAM533SJ2giUsyEvB2r7iGm4IwmCi5TAa+qq4fNaJr6fbC7KjWwA+LF
        JlTOAxpJZnvz0qZrfi/LD5LiFGYE8E7jtuidevD9SA==
X-Google-Smtp-Source: ABdhPJwh+EyRBzFDdoNIF6CuwmhbkxgFXBjne0410iYswXwVmwIk0qa395loxmGEQ4bdDlanGDsU9P7A1mHz/x422Ng=
X-Received: by 2002:a2e:8751:: with SMTP id q17mr920669ljj.235.1642068632823;
 Thu, 13 Jan 2022 02:10:32 -0800 (PST)
MIME-Version: 1.0
References: <20220112215625.4144871-1-shy828301@gmail.com>
In-Reply-To: <20220112215625.4144871-1-shy828301@gmail.com>
From:   Jann Horn <jannh@google.com>
Date:   Thu, 13 Jan 2022 11:10:04 +0100
Message-ID: <CAG48ez3y2YGfKRJ6ocR1GT9w9iuGfyypbE+cQgYVZhSta89WUg@mail.gmail.com>
Subject: Re: [PATCH] fs/proc: task_mmu.c: don't read mapcount for migration entry
To:     Yang Shi <shy828301@gmail.com>
Cc:     kirill.shutemov@linux.intel.com, willy@infradead.org,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 12, 2022 at 10:56 PM Yang Shi <shy828301@gmail.com> wrote:
> The syzbot reported the below BUG:
>
> kernel BUG at include/linux/page-flags.h:785!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 4392 Comm: syz-executor560 Not tainted 5.16.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:PageDoubleMap include/linux/page-flags.h:785 [inline]
> RIP: 0010:__page_mapcount+0x2d2/0x350 mm/util.c:744
> Code: e8 d3 16 d1 ff 48 c7 c6 c0 00 b6 89 48 89 ef e8 94 4e 04 00 0f 0b e8 bd 16 d1 ff 48 c7 c6 60 01 b6 89 48 89 ef e8 7e 4e 04 00 <0f> 0b e8 a7 16 d1 ff 48 c7 c6 a0 01 b6 89 4c 89 f7 e8 68 4e 04 00
> RSP: 0018:ffffc90002b6f7b8 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff888019619d00 RSI: ffffffff81a68c12 RDI: 0000000000000003
> RBP: ffffea0001bdc2c0 R08: 0000000000000029 R09: 00000000ffffffff
> R10: ffffffff8903e29f R11: 00000000ffffffff R12: 00000000ffffffff
> R13: 00000000ffffea00 R14: ffffc90002b6fb30 R15: ffffea0001bd8001
> FS:  00007faa2aefd700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fff7e663318 CR3: 0000000018c6e000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  page_mapcount include/linux/mm.h:837 [inline]
>  smaps_account+0x470/0xb10 fs/proc/task_mmu.c:466
>  smaps_pte_entry fs/proc/task_mmu.c:538 [inline]
>  smaps_pte_range+0x611/0x1250 fs/proc/task_mmu.c:601
>  walk_pmd_range mm/pagewalk.c:128 [inline]
>  walk_pud_range mm/pagewalk.c:205 [inline]
>  walk_p4d_range mm/pagewalk.c:240 [inline]
>  walk_pgd_range mm/pagewalk.c:277 [inline]
>  __walk_page_range+0xe23/0x1ea0 mm/pagewalk.c:379
>  walk_page_vma+0x277/0x350 mm/pagewalk.c:530
>  smap_gather_stats.part.0+0x148/0x260 fs/proc/task_mmu.c:768
>  smap_gather_stats fs/proc/task_mmu.c:741 [inline]
>  show_smap+0xc6/0x440 fs/proc/task_mmu.c:822
>  seq_read_iter+0xbb0/0x1240 fs/seq_file.c:272
>  seq_read+0x3e0/0x5b0 fs/seq_file.c:162
>  vfs_read+0x1b5/0x600 fs/read_write.c:479
>  ksys_read+0x12d/0x250 fs/read_write.c:619
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7faa2af6c969
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007faa2aefd288 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> RAX: ffffffffffffffda RBX: 00007faa2aff4418 RCX: 00007faa2af6c969
> RDX: 0000000000002025 RSI: 0000000020000100 RDI: 0000000000000003
> RBP: 00007faa2aff4410 R08: 00007faa2aefd700 R09: 0000000000000000
> R10: 00007faa2aefd700 R11: 0000000000000246 R12: 00007faa2afc20ac
> R13: 00007fff7e6632bf R14: 00007faa2aefd400 R15: 0000000000022000
>  </TASK>
> Modules linked in:
> ---[ end trace 24ec93ff95e4ac3d ]---
> RIP: 0010:PageDoubleMap include/linux/page-flags.h:785 [inline]
> RIP: 0010:__page_mapcount+0x2d2/0x350 mm/util.c:744
> Code: e8 d3 16 d1 ff 48 c7 c6 c0 00 b6 89 48 89 ef e8 94 4e 04 00 0f 0b e8 bd 16 d1 ff 48 c7 c6 60 01 b6 89 48 89 ef e8 7e 4e 04 00 <0f> 0b e8 a7 16 d1 ff 48 c7 c6 a0 01 b6 89 4c 89 f7 e8 68 4e 04 00
> RSP: 0018:ffffc90002b6f7b8 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff888019619d00 RSI: ffffffff81a68c12 RDI: 0000000000000003
> RBP: ffffea0001bdc2c0 R08: 0000000000000029 R09: 00000000ffffffff
> R10: ffffffff8903e29f R11: 00000000ffffffff R12: 00000000ffffffff
> R13: 00000000ffffea00 R14: ffffc90002b6fb30 R15: ffffea0001bd8001
> FS:  00007faa2aefd700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fff7e663318 CR3: 0000000018c6e000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>
> The reproducer was trying to reading /proc/$PID/smaps when calling
> MADV_FREE at the mean time.  MADV_FREE may split THPs if it is called
> for partial THP.  It may trigger the below race:
>
>          CPU A                         CPU B
>          -----                         -----
> smaps walk:                      MADV_FREE:
> page_mapcount()
>   PageCompound()
>                                  split_huge_page()
>   page = compound_head(page)
>   PageDoubleMap(page)
>
> When calling PageDoubleMap() this page is not a tail page of THP anymore
> so the BUG is triggered.
>
> This could be fixed by elevated refcount of the page before calling
> mapcount, but it prevents from counting migration entries, and it seems
> overkilling because the race just could happen when PMD is split so all
> PTE entries of tail pages are actually migration entries, and
> smaps_account() does treat migration entries as mapcount == 1 as Kirill
> pointed out.
>
> Add a new parameter for smaps_account() to tell this entry is migration
> entry then skip calling page_mapcount().  Don't skip getting mapcount for
> device private entries since they do track references with mapcount.
>
> Reported-by: syzbot+1f52b3a18d5633fa7f82@syzkaller.appspotmail.com

maybe add:

Fixes: b1d4d9e0cbd0 ("proc/smaps: carefully handle migration entries")

> Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Cc: Jann Horn <jannh@google.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Yang Shi <shy828301@gmail.com>
