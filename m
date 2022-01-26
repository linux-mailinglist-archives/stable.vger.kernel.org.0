Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2998B49C8A9
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 12:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240722AbiAZL36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 06:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240724AbiAZL35 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 06:29:57 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4029CC061744
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 03:29:57 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id z20so10177313ljo.6
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 03:29:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1H4TX89ja5S3N5cue2AVcwFf2OWJSThV+YouY9Q38K8=;
        b=r80jr47FEo4Z/0ygMN7drqnf+UdyJMPl8SG3HAeDzUrdKD6dy1wfBMnugdWaTWwmmJ
         u3TWqlpKcFeKKGb3XnRrmUbay5NY8DNLkTgdslIR+h116lrvcHr6DJ6+nZfrR0VUU96X
         fz6wl0ekX6P80ym6TB81BE0gLMNLB4Mquly+KZGGRfYRaYLND74O1YowypO9AyQwgP83
         mVjiyWGJdkeCZzFnR2O6tPaCQxccJzh1rajWdeg3wO53kZ1H+dWP0Hp/acWhlZDQN1Zs
         oXULKG/Rd5hCnYSSODH4hK0IjzYxCQAsO0Emo4siMdAEG4Wz1WB90ZH0HQTmTWnGSxMY
         5IyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1H4TX89ja5S3N5cue2AVcwFf2OWJSThV+YouY9Q38K8=;
        b=FmeKamqdqywzvQqnqLX3gZ/NNy2cfJHpW/K2oWVY7CaHo1HG4sfvYyD4bTJjj/TKso
         q3pwfSYPM0opvd9CE/uO7BvudUhypGEIoP5bVllq3o+55oddpA99hk9TBKoFFckT+DPm
         HUesasBpjs9OBvEPUib2BmZEEe1woUVX+X58CC1usExYNOcKm46Cy36GUOFQxvVA540L
         UhR1HYy9CYwE7jGhm70OOA2ZsfmDINbzdKMz7DRvFYb4He+LKTbaihOOa++YBkevUvV7
         r5+ubv4HJMGpX0TYjWlA4shmV2ATZSB4xKtJKvUPeq+rW4FjMvs+sxV7R495/nD0ePL1
         VpYg==
X-Gm-Message-State: AOAM530nqFei4gC+RWCTfVb3wA8EE6dqV+rmOeVQ9MbvGG7C9DJDBrey
        hedj5srhAtclXZVqlB7S8d+3blVHtzPHX+oyQtObgQ==
X-Google-Smtp-Source: ABdhPJxjkndNpVASW0t22x5z1Tbj0oqh/6XRERVOQiF6tUtRYGL1mJ1ymX2XrixkxLew4L+OQ+i3arF061hRndVK2oI=
X-Received: by 2002:a2e:9d8b:: with SMTP id c11mr10212542ljj.47.1643196595278;
 Wed, 26 Jan 2022 03:29:55 -0800 (PST)
MIME-Version: 1.0
References: <20220120202805.3369-1-shy828301@gmail.com> <af603cbe-4a38-9947-5e6d-9a9328b473fb@redhat.com>
In-Reply-To: <af603cbe-4a38-9947-5e6d-9a9328b473fb@redhat.com>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 26 Jan 2022 12:29:27 +0100
Message-ID: <CAG48ez1xuZdELb=5ed1i0ruoFu5kAaWsf0LgRXEGhrDAcHz8fw@mail.gmail.com>
Subject: Re: [v2 PATCH] fs/proc: task_mmu.c: don't read mapcount for migration entry
To:     David Hildenbrand <david@redhat.com>
Cc:     Yang Shi <shy828301@gmail.com>, kirill.shutemov@linux.intel.com,
        willy@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 26, 2022 at 11:51 AM David Hildenbrand <david@redhat.com> wrote:
> On 20.01.22 21:28, Yang Shi wrote:
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
>
> Does this point at the bigger issue that reading the mapcount without
> having the page locked is completely unstable?

(See also https://lore.kernel.org/all/CAG48ez0M=iwJu=Q8yUQHD-+eZDg6ZF8QCF86Sb=CN1petP=Y0Q@mail.gmail.com/
for context.)

I'm not sure what you mean by "unstable". Do you mean "the result is
not guaranteed to still be valid when the call returns", "the result
might not have ever been valid", or "the call might crash because the
page's state as a compound page is unstable"?

In case you mean "the result is not guaranteed to still be valid when
the call returns":
We're just collecting stats for userspace, and by the time we return
to userspace, the numbers will be outdated anyway, so that doesn't
matter.

In case you mean "the result might not have ever been valid":
Yes, even with this patch applied, in theory concurrent THP splits
could cause us to count some page mappings twice. Arguably that's not
entirely correct.

In case you mean "the call might crash because the page's state as a
compound page could concurrently change":
As long as we have our own mapping of the page, the page can't be
split, so this patch fixes that problem.
