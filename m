Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8894396761
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 19:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhEaRss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 13:48:48 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:36419 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232045AbhEaRr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 13:47:59 -0400
Received: by mail-il1-f197.google.com with SMTP id w10-20020a056e021c8ab02901bb7c1adfa1so8460582ill.3
        for <stable@vger.kernel.org>; Mon, 31 May 2021 10:46:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=0iVfvL7JwnuWeGdIoIJhdkwXuwKDV+Q8jVMxiC8n2pk=;
        b=ryLj457EZc4owdfSLss5j2i68LlV2YN0TM4Njz2t311QwUyXQ3zmomPI7s4FY6Kc1B
         wovakXqLewDqB/4HZ0mSL1ZjB8UlbYqMrSo2iRy0hXuZJ1FYjRvWjCaIqJuLevjo/Y7V
         KHTyIs/Y6YZu5C3izRdDLbo4NZC4ky+tv//wGrDlvGSgo8P1p1jDarznipj0YxjHcWf/
         MDBrO/hWSUxQpWVs3D+c89ODc/IRyy0F4o2uVYNW8cwzP4srNN21+pveN2c5QDkGFIY3
         e1xGMEXMkH/9xfV4mRy6A+StpmpVBiWMdpKrTCtcOOBZ9tdyC/uu4J1e/4pEvF7HoiNZ
         PeuA==
X-Gm-Message-State: AOAM530s2vKRzKdLBoFZvyeqQcmC8v53PnIYXxAdCYJ+rvkzY4KFSm71
        xeVmsOc74D590uRYQylKPtMw1LlHnO8RJfZ98+xadHkIeUQk
X-Google-Smtp-Source: ABdhPJwfjKzPTwTt7KjjWoG5YFQVziBWj34LsicO8wDWNlq7uJOcDzP74iSkRR8WhqgLiy/GDM5VDyES+OtfcjBvTxSUjbRCiOg6
MIME-Version: 1.0
X-Received: by 2002:a92:c148:: with SMTP id b8mr10165539ilh.227.1622483178605;
 Mon, 31 May 2021 10:46:18 -0700 (PDT)
Date:   Mon, 31 May 2021 10:46:18 -0700
In-Reply-To: <0000000000004c453905c30f8334@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000083d3dd05c3a3cdc6@google.com>
Subject: Re: [syzbot] WARNING in ex_handler_fprestore
From:   syzbot <syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com>
To:     bp@alien8.de, bp@suse.de, dave.hansen@intel.com,
        dave.hansen@linux.intel.com, dvyukov@google.com,
        fenghua.yu@intel.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@kernel.org, mingo@redhat.com, peterz@infradead.org,
        stable@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, tony.luck@intel.com, x86@kernel.org,
        yu-cheng.yu@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    8124c8a6 Linux 5.13-rc4
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1047c4a7d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=71698168f5f17484
dashboard link: https://syzkaller.appspot.com/bug?extid=2067e764dbcd10721e2e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1020b26bd00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12afa2a7d00000

The issue was bisected to:

commit b860eb8dce5906b14e3a7f3c771e0b3d6ef61b94
Author: Fenghua Yu <fenghua.yu@intel.com>
Date:   Tue May 12 14:54:39 2020 +0000

    x86/fpu/xstate: Define new functions for clearing fpregs and xstates

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17c2c723d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1422c723d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1022c723d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com
Fixes: b860eb8dce59 ("x86/fpu/xstate: Define new functions for clearing fpregs and xstates")

syz-executor638[9087] bad frame in rt_sigreturn frame:00007f1dcdbbdbf8 ip:445bf9 sp:7f1dcdbbe188 orax:ffffffffffffffff in syz-executor638076058[401000+9a000]
------------[ cut here ]------------
Bad FPU state detected at copy_kernel_to_xregs arch/x86/include/asm/fpu/internal.h:344 [inline], reinitializing FPU registers.
Bad FPU state detected at __copy_kernel_to_fpregs arch/x86/include/asm/fpu/internal.h:419 [inline], reinitializing FPU registers.
Bad FPU state detected at copy_kernel_to_fpregs arch/x86/include/asm/fpu/internal.h:443 [inline], reinitializing FPU registers.
Bad FPU state detected at __fpregs_load_activate arch/x86/include/asm/fpu/internal.h:514 [inline], reinitializing FPU registers.
Bad FPU state detected at copy_fpstate_to_sigframe+0x4d2/0xae0 arch/x86/kernel/fpu/signal.c:191, reinitializing FPU registers.
WARNING: CPU: 1 PID: 9087 at arch/x86/mm/extable.c:65 ex_handler_fprestore+0xf0/0x110 arch/x86/mm/extable.c:65
Modules linked in:
CPU: 1 PID: 9087 Comm: syz-executor638 Not tainted 5.13.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ex_handler_fprestore+0xf0/0x110 arch/x86/mm/extable.c:65
Code: e8 55 40 40 00 b8 01 00 00 00 5b 5d 41 5c c3 e8 46 40 40 00 48 89 de 48 c7 c7 c0 0c 69 89 c6 05 42 12 81 0c 01 e8 db 48 a1 07 <0f> 0b eb 90 48 89 df e8 94 c8 84 00 e9 3d ff ff ff e8 1a c9 84 00
RSP: 0018:ffffc9000227fa60 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffffffff812aeeb2 RCX: 0000000000000000
RDX: ffff88803031a100 RSI: ffffffff815c1805 RDI: fffff5200044ff3e
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815bb63e R11: 0000000000000000 R12: ffffffff8b23f7d8
R13: 000000000000000d R14: 0000000000000000 R15: 0000000000000000
FS:  00007f1dcdbbe700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000000 CR3: 0000000031055000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 fixup_exception+0x9a/0xd0 arch/x86/mm/extable.c:183
 __exc_general_protection arch/x86/kernel/traps.c:567 [inline]
 exc_general_protection+0xed/0x2f0 arch/x86/kernel/traps.c:531
 asm_exc_general_protection+0x1e/0x30 arch/x86/include/asm/idtentry.h:571
RIP: 0010:__fpregs_load_activate arch/x86/include/asm/fpu/internal.h:514 [inline]
RIP: 0010:copy_fpstate_to_sigframe+0x4d2/0xae0 arch/x86/kernel/fpu/signal.c:191
Code: 58 e8 d2 22 49 00 48 c7 c0 c0 29 c9 8d 0f 1f 44 00 00 e8 c1 22 49 00 e8 bc 22 49 00 b8 ff ff ff ff 4c 89 e7 89 c2 48 0f ae 2f <e8> a9 22 49 00 65 4c 89 35 d1 00 d7 7e 0f 1f 44 00 00 e8 97 22 49
RSP: 0018:ffffc9000227fc08 EFLAGS: 00010293
RAX: 00000000ffffffff RBX: ffff88803031a100 RCX: 0000000000000000
RDX: 00000000ffffffff RSI: ffffffff812aeea4 RDI: ffff88803031b900
RBP: ffff88803031a100 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff812aee3b R11: 0000000000000000 R12: ffff88803031b900
R13: ffffed10060636f2 R14: ffff88803031b8c0 R15: 00007f1dcdbbddc0
 get_sigframe.constprop.0.isra.0+0x429/0x730 arch/x86/kernel/signal.c:274
 __setup_rt_frame arch/x86/kernel/signal.c:450 [inline]
 setup_rt_frame arch/x86/kernel/signal.c:702 [inline]
 handle_signal arch/x86/kernel/signal.c:746 [inline]
 arch_do_signal_or_restart+0xd9e/0x1eb0 arch/x86/kernel/signal.c:791
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x171/0x280 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:301
 do_syscall_64+0x47/0xb0 arch/x86/entry/common.c:57
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x445bf9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1dcdbbe188 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 00000000004cb408 RCX: 0000000000445bf9
RDX: 0000000080000002 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 00000000004cb400 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004cb40c
R13: 00007ffcd24a5bdf R14: 00007f1dcdbbe300 R15: 0000000000022000

