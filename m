Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364DC49ECE0
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 21:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233171AbiA0UwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 15:52:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240545AbiA0UwH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 15:52:07 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE1BC061714;
        Thu, 27 Jan 2022 12:52:06 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id jx6so8864056ejb.0;
        Thu, 27 Jan 2022 12:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WefaG2bZ0HfgJlKTLmXL/u7dspC9BEptghWa9TWCUFU=;
        b=nJ8DgQZuk1HkU7Go352DihCrB5BbXAWG/CzBlrL6kGx3Cm+anntQpEQry/spExuq/I
         ZPT4rHs4GdSBFv6Pbyz8sftMRAUmty24FTz/nRkBwGuQVZOEnywGueq5zEcj7ATXc1kq
         NmwniWMQcoGTUx8pWtPkmt1MefmU3hdCFJAKx25fzuPxwOtSvWtbOrU8EXvtMjdzeWJ4
         SczEdYpeJPhLEr0083WOfpjlGn8Z1JpHESa6uHAuJtwLmcCIpwYLnyftLS40pt5LN28I
         ZhPbuPnuT+LysXII2+MAKCDu2Y4RIqH5SaJGNXJVd3SmMAPBuPNOBUlyjmQZADhqblJr
         kqVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WefaG2bZ0HfgJlKTLmXL/u7dspC9BEptghWa9TWCUFU=;
        b=mIXmPhWPdYIKw4d2umgLfXDTVhNhEyhEPVNNaU2UIEYT+n/wFGxeJcebqzhYv2uUJY
         Cqn1ZZq1HGjJU2q5YUx5nKeaEk0So4E0E5ALY0myC0Z7PLVHtk0T8uNj2pbZqOdhsTZm
         euxirGKMH1yTNImRRuBXWYGsbO33ZXDA32ND46sxYYPJrZD6c4mOkd3Xy1LK6P+nUPj1
         22I8nUS7Y2idSaixPj+q8SpGM3b07h6QmKC0teFCFFPdELDuZ6S5G1AU6OT/Gn2baURC
         e195xscGA9xqOzOio6sgfXAFGVQUEANUPn68UF8Xz206ZgdLda86pN/39xnpl0S8Wde8
         P7CQ==
X-Gm-Message-State: AOAM53147sfeQhudtCA8BBEyOXX/4lEj+SUlTS1Hwb1VEtOvvrE7VRjl
        PufiAkHnbiwpg+o+oyKbyqnZPaly3S1GFADcK7EQuuvwBzNEWA==
X-Google-Smtp-Source: ABdhPJzAyG2YkQzSpeO+u6eaArLRq/UaVirSQbN6erle/oyEmdFKjVoUtfT/SbprDv/63oA7PQa0I0eFBmnbBnAetgw=
X-Received: by 2002:a17:907:3d94:: with SMTP id he20mr4344300ejc.637.1643316725323;
 Thu, 27 Jan 2022 12:52:05 -0800 (PST)
MIME-Version: 1.0
References: <20220120202805.3369-1-shy828301@gmail.com> <af603cbe-4a38-9947-5e6d-9a9328b473fb@redhat.com>
 <CAG48ez1xuZdELb=5ed1i0ruoFu5kAaWsf0LgRXEGhrDAcHz8fw@mail.gmail.com>
In-Reply-To: <CAG48ez1xuZdELb=5ed1i0ruoFu5kAaWsf0LgRXEGhrDAcHz8fw@mail.gmail.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Thu, 27 Jan 2022 12:51:53 -0800
Message-ID: <CAHbLzkqFRXuu95t1n-POn7Je_XVFZEJ3AAc_Cz9KzcDG05DBng@mail.gmail.com>
Subject: Re: [v2 PATCH] fs/proc: task_mmu.c: don't read mapcount for migration entry
To:     Jann Horn <jannh@google.com>
Cc:     David Hildenbrand <david@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 26, 2022 at 3:29 AM Jann Horn <jannh@google.com> wrote:
>
> On Wed, Jan 26, 2022 at 11:51 AM David Hildenbrand <david@redhat.com> wrote:
> > On 20.01.22 21:28, Yang Shi wrote:
> > > The syzbot reported the below BUG:
> > >
> > > kernel BUG at include/linux/page-flags.h:785!
> > > invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> > > CPU: 1 PID: 4392 Comm: syz-executor560 Not tainted 5.16.0-rc6-syzkaller #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > > RIP: 0010:PageDoubleMap include/linux/page-flags.h:785 [inline]
> > > RIP: 0010:__page_mapcount+0x2d2/0x350 mm/util.c:744
> > > Code: e8 d3 16 d1 ff 48 c7 c6 c0 00 b6 89 48 89 ef e8 94 4e 04 00 0f 0b e8 bd 16 d1 ff 48 c7 c6 60 01 b6 89 48 89 ef e8 7e 4e 04 00 <0f> 0b e8 a7 16 d1 ff 48 c7 c6 a0 01 b6 89 4c 89 f7 e8 68 4e 04 00
> > > RSP: 0018:ffffc90002b6f7b8 EFLAGS: 00010293
> > > RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> > > RDX: ffff888019619d00 RSI: ffffffff81a68c12 RDI: 0000000000000003
> > > RBP: ffffea0001bdc2c0 R08: 0000000000000029 R09: 00000000ffffffff
> > > R10: ffffffff8903e29f R11: 00000000ffffffff R12: 00000000ffffffff
> > > R13: 00000000ffffea00 R14: ffffc90002b6fb30 R15: ffffea0001bd8001
> > > FS:  00007faa2aefd700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 00007fff7e663318 CR3: 0000000018c6e000 CR4: 00000000003506e0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > Call Trace:
> > >  <TASK>
> > >  page_mapcount include/linux/mm.h:837 [inline]
> > >  smaps_account+0x470/0xb10 fs/proc/task_mmu.c:466
> > >  smaps_pte_entry fs/proc/task_mmu.c:538 [inline]
> > >  smaps_pte_range+0x611/0x1250 fs/proc/task_mmu.c:601
> > >  walk_pmd_range mm/pagewalk.c:128 [inline]
> > >  walk_pud_range mm/pagewalk.c:205 [inline]
> > >  walk_p4d_range mm/pagewalk.c:240 [inline]
> > >  walk_pgd_range mm/pagewalk.c:277 [inline]
> > >  __walk_page_range+0xe23/0x1ea0 mm/pagewalk.c:379
> > >  walk_page_vma+0x277/0x350 mm/pagewalk.c:530
> > >  smap_gather_stats.part.0+0x148/0x260 fs/proc/task_mmu.c:768
> > >  smap_gather_stats fs/proc/task_mmu.c:741 [inline]
> > >  show_smap+0xc6/0x440 fs/proc/task_mmu.c:822
> > >  seq_read_iter+0xbb0/0x1240 fs/seq_file.c:272
> > >  seq_read+0x3e0/0x5b0 fs/seq_file.c:162
> > >  vfs_read+0x1b5/0x600 fs/read_write.c:479
> > >  ksys_read+0x12d/0x250 fs/read_write.c:619
> > >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > >  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> > >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > > RIP: 0033:0x7faa2af6c969
> > > Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> > > RSP: 002b:00007faa2aefd288 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> > > RAX: ffffffffffffffda RBX: 00007faa2aff4418 RCX: 00007faa2af6c969
> > > RDX: 0000000000002025 RSI: 0000000020000100 RDI: 0000000000000003
> > > RBP: 00007faa2aff4410 R08: 00007faa2aefd700 R09: 0000000000000000
> > > R10: 00007faa2aefd700 R11: 0000000000000246 R12: 00007faa2afc20ac
> > > R13: 00007fff7e6632bf R14: 00007faa2aefd400 R15: 0000000000022000
> > >  </TASK>
> > > Modules linked in:
> > > ---[ end trace 24ec93ff95e4ac3d ]---
> > > RIP: 0010:PageDoubleMap include/linux/page-flags.h:785 [inline]
> > > RIP: 0010:__page_mapcount+0x2d2/0x350 mm/util.c:744
> > > Code: e8 d3 16 d1 ff 48 c7 c6 c0 00 b6 89 48 89 ef e8 94 4e 04 00 0f 0b e8 bd 16 d1 ff 48 c7 c6 60 01 b6 89 48 89 ef e8 7e 4e 04 00 <0f> 0b e8 a7 16 d1 ff 48 c7 c6 a0 01 b6 89 4c 89 f7 e8 68 4e 04 00
> > > RSP: 0018:ffffc90002b6f7b8 EFLAGS: 00010293
> > > RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> > > RDX: ffff888019619d00 RSI: ffffffff81a68c12 RDI: 0000000000000003
> > > RBP: ffffea0001bdc2c0 R08: 0000000000000029 R09: 00000000ffffffff
> > > R10: ffffffff8903e29f R11: 00000000ffffffff R12: 00000000ffffffff
> > > R13: 00000000ffffea00 R14: ffffc90002b6fb30 R15: ffffea0001bd8001
> > > FS:  00007faa2aefd700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 00007fff7e663318 CR3: 0000000018c6e000 CR4: 00000000003506e0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > >
> >
> > Does this point at the bigger issue that reading the mapcount without
> > having the page locked is completely unstable?
>
> (See also https://lore.kernel.org/all/CAG48ez0M=iwJu=Q8yUQHD-+eZDg6ZF8QCF86Sb=CN1petP=Y0Q@mail.gmail.com/
> for context.)

Thanks for the link. I saw you mentioned that pagemap code may have
the same issue. I think so too by inspecting the code visually even
though I didn't see any bug report. I think it could be fixed with the
same solution by just specializing the migration entry without calling
page_mapcount().

>
> I'm not sure what you mean by "unstable". Do you mean "the result is
> not guaranteed to still be valid when the call returns", "the result
> might not have ever been valid", or "the call might crash because the
> page's state as a compound page is unstable"?
>
> In case you mean "the result is not guaranteed to still be valid when
> the call returns":
> We're just collecting stats for userspace, and by the time we return
> to userspace, the numbers will be outdated anyway, so that doesn't
> matter.
>
> In case you mean "the result might not have ever been valid":
> Yes, even with this patch applied, in theory concurrent THP splits
> could cause us to count some page mappings twice. Arguably that's not
> entirely correct.
>
> In case you mean "the call might crash because the page's state as a
> compound page could concurrently change":
> As long as we have our own mapping of the page, the page can't be
> split, so this patch fixes that problem.
