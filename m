Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0FC12CCE2
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 06:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfL3F3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 00:29:49 -0500
Received: from mout-p-101.mailbox.org ([80.241.56.151]:26186 "EHLO
        mout-p-101.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbfL3F3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 00:29:49 -0500
X-Greylist: delayed 503 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Dec 2019 00:29:45 EST
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 47mQl45RZtzKmVC;
        Mon, 30 Dec 2019 06:21:20 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id JO1h7h5dQFhF; Mon, 30 Dec 2019 06:21:17 +0100 (CET)
From:   Aleksa Sarai <cyphar@cyphar.com>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Aleksa Sarai <cyphar@cyphar.com>, stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC 0/1] mount: universally disallow mounting over symlinks
Date:   Mon, 30 Dec 2019 16:20:35 +1100
Message-Id: <20191230052036.8765-1-cyphar@cyphar.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

An undocumented feature of the mount interface was that it was possible
to mount over a symlink (even with the old mount API) by mounting over
/proc/self/fd/$n -- where the corresponding file descrpitor was opened
with (O_PATH|O_NOFOLLOW). This didn't work with traditional "new" mounts
(for a variety of reasons), but MS_BIND worked without issue. With the
new mount API it was even easier.

A reasonably detailed explanation of the issues is provided in the patch
itself, but the full traces produced by both the oopses and deadlocks is
included below (it makes little sense to include them in the commit since we
are disabling this feature, not directly fixing the bugs themselves).

I've posted this as an RFC on whether this feature should be allowed at
all (and if anyone knows of legitimate uses for it), or if we should
work on fixing these other kernel bugs that it exposes.

Oops on NULL dereference:
    BUG: kernel NULL pointer dereference, address: 0000000000000000
    #PF: supervisor instruction fetch in kernel mode
    #PF: error_code(0x0010) - not-present page
    PGD 8000000181b1f067 P4D 8000000181b1f067 PUD 24829c067 PMD 0
    Oops: 0010 [#1] SMP PTI
    CPU: 6 PID: 20796 Comm: mount_to_symlin Tainted: G           OE     5.5.0-rc1+openat2~v18+ #123
    Hardware name: LENOVO 20KHCTO1WW/20KHCTO1WW, BIOS N23ET55W (1.30 ) 08/31/2018
    RIP: 0010:0x0
    Code: Bad RIP value.
    RSP: 0018:ffffbc7d87e1bcb0 EFLAGS: 00010206
    RAX: 0000000000000000 RBX: ffffa0c28cb633c0 RCX: 000000000000ae5a
    RDX: 0000000000000089 RSI: ffffa0c0eece8840 RDI: ffffa0c0eb8843b0
    RBP: ffffa0c0eb8843b0 R08: ffffdc7d7fbbb770 R09: ffffa0c0ca333000
    R10: 0000000000000000 R11: 808080807fffffff R12: ffffa0c0eece8840
    R13: 0000000000000089 R14: ffffbc7d87e1bdb0 R15: 0000000000000080
    FS:  00007fd921508540(0000) GS:ffffa0c3cf580000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: ffffffffffffffd6 CR3: 000000018878a003 CR4: 00000000003606e0
    Call Trace:
     __lookup_slow+0x94/0x160
     lookup_slow+0x36/0x50
     path_mountpoint+0x1be/0x350
     filename_mountpoint+0xa5/0x150
     ? __lookup_hash+0xa0/0xa0
     ksys_umount+0x78/0x490
     __x64_sys_umount+0x12/0x20
     do_syscall_64+0x64/0x240
     entry_SYSCALL_64_after_hwframe+0x49/0xbe
    RIP: 0033:0x7fd92143f4e7
    Code: 09 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 31 f6 e9 09
          00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 01
          f0 ff ff 73 01 c3 48 8b 0d 69 09 0c 00 f7 d8 64 89 01 48
    RSP: 002b:00007ffe98c89cc8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a6
    RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fd92143f4e7
    RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000000167a330
    RBP: 00007ffe98c89da0 R08: 0000000000000000 R09: 000000000000000f
    R10: 00000000004004c6 R11: 0000000000000202 R12: 00000000004010c0
    R13: 00007ffe98c89e80 R14: 0000000000000000 R15: 0000000000000000
    CR2: 0000000000000000

Oops on kernel address:
    BUG: unable to handle page fault for address: ffffbc7d87e1bcc0
    #PF: supervisor write access in kernel mode
    #PF: error_code(0x0002) - not-present page
    PGD 107d4a067 P4D 107d4a067 PUD 107d4b067 PMD 46d753067 PTE 0
    Oops: 0002 [#2] SMP PTI
    CPU: 4 PID: 20975 Comm: mount_to_symlin Tainted: G      D    OE     5.5.0-rc1+openat2~v18+ #123
    Hardware name: LENOVO 20KHCTO1WW/20KHCTO1WW, BIOS N23ET55W (1.30 ) 08/31/2018
    RIP: 0010:_raw_spin_lock_irqsave+0x28/0x50
    Code: 00 00 0f 1f 44 00 00 41 54 53 48 89 fb 9c 58 0f 1f 44 00 00 49 89 c4
          fa 66 0f 1f 44 00 00 e8 3f 55 82 ff 31 c0 ba 01 00 00 00 <f0> 0f b1
          13 75 07 4c 89 e0 5b 41 5c c3 89 c6 48 89 df e8 01 52 77
    RSP: 0018:ffffbc7d90067bd8 EFLAGS: 00010046
    RAX: 0000000000000000 RBX: ffffbc7d87e1bcc0 RCX: 0000000200000000
    RDX: 0000000000000001 RSI: ffffbc7d90067c50 RDI: ffffbc7d87e1bcc0
    RBP: ffffbc7d87e1bcc0 R08: 0000000000000001 R09: 0000000000000003
    R10: 0000000000000000 R11: 808080807fffffff R12: 0000000000000246
    R13: ffffa0c28cb633c0 R14: ffffbc7d90067db0 R15: ffffa0c0eece8898
    FS:  00007f4b80214540(0000) GS:ffffa0c3cf500000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: ffffbc7d87e1bcc0 CR3: 000000026d4d0002 CR4: 00000000003606e0
    Call Trace:
     add_wait_queue+0x15/0x40
     d_alloc_parallel+0x36d/0x480
     ? get_acl+0x1a/0x160
     ? wake_up_q+0xa0/0xa0
     __lookup_slow+0x6b/0x160
     lookup_slow+0x36/0x50
     path_mountpoint+0x1be/0x350
     filename_mountpoint+0xa5/0x150
     ? __lookup_hash+0xa0/0xa0
     ksys_umount+0x78/0x490
     __x64_sys_umount+0x12/0x20
     do_syscall_64+0x64/0x240
     entry_SYSCALL_64_after_hwframe+0x49/0xbe
    RIP: 0033:0x7f4b8014b4e7
    Code: 09 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 31 f6 e9 09
          00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 01
          f0 ff ff 73 01 c3 48 8b 0d 69 09 0c 00 f7 d8 64 89 01 48
    RSP: 002b:00007ffee8041b28 EFLAGS: 00000206 ORIG_RAX: 00000000000000a6
    RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f4b8014b4e7
    RDX: 0000000000000000 RSI: 0000000000000002 RDI: 00000000019c8330
    RBP: 00007ffee8041c00 R08: 0000000000000000 R09: 000000000000000f
    R10: 00000000004004c6 R11: 0000000000000206 R12: 00000000004010c0
    R13: 00007ffee8041ce0 R14: 0000000000000000 R15: 0000000000000000
    CR2: ffffbc7d87e1bcc0

Apparent deadlock in d_alloc_parallel:
    watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [mount_to_symlin:21285]
    CPU: 0 PID: 21285 Comm: mount_to_symlin Tainted: G      D    OE     5.5.0-rc1+openat2~v18+ #123
    Hardware name: LENOVO 20KHCTO1WW/20KHCTO1WW, BIOS N23ET55W (1.30 ) 08/31/2018
    RIP: 0010:native_queued_spin_lock_slowpath+0x5b/0x1d0
    Code: 6d f0 0f ba 2f 08 0f 92 c0 0f b6 c0 c1 e0 08 89 c2 8b 07 30 e4 09 d0
          a9 00 01 ff ff 75 47 85 c0 74 0e 8b 07 84 c0 74 08 f3 90 <8b> 07 84
          c0 75 f8 b8 01 00 00 00 66 89 07 c3 8b 37 81 fe 00 01 00
    RSP: 0018:ffffbc7d90547be8 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
    RAX: 0000000000000101 RBX: ffffffffbac7ac60 RCX: 0000000000000018
    RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffa0c0eece8898
    RBP: ffffa0c0eece8898 R08: 00000000006f6f66 R09: 0000000000000003
    R10: 0000000000000000 R11: 808080807fffffff R12: 00000000e25b3c73
    R13: ffffa0c28cb633c0 R14: ffffbc7d90547db0 R15: ffffa0c0eece8898
    FS:  00007fbb1fd30540(0000) GS:ffffa0c3cf400000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 00007fbb1fbd25a0 CR3: 0000000181ace005 CR4: 00000000003606f0
    Call Trace:
     _raw_spin_lock+0x1a/0x20
     lockref_get_not_dead+0x4f/0x90
     d_alloc_parallel+0x1a8/0x480
     ? get_acl+0x1a/0x160
     __lookup_slow+0x6b/0x160
     lookup_slow+0x36/0x50
     path_mountpoint+0x1be/0x350
     filename_mountpoint+0xa5/0x150
     ? __lookup_hash+0xa0/0xa0
     ksys_umount+0x78/0x490
     __x64_sys_umount+0x12/0x20
     do_syscall_64+0x64/0x240
     entry_SYSCALL_64_after_hwframe+0x49/0xbe
    RIP: 0033:0x7fbb1fc674e7
    Code: 09 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 31 f6 e9 09
          00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 01
          f0 ff ff 73 01 c3 48 8b 0d 69 09 0c 00 f7 d8 64 89 01 48
    RSP: 002b:00007ffd75fcb858 EFLAGS: 00000202 ORIG_RAX: 00000000000000a6
    RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fbb1fc674e7
    RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000f6c330
    RBP: 00007ffd75fcb930 R08: 0000000000000000 R09: 000000000000000f
    R10: 00000000004004a6 R11: 0000000000000202 R12: 00000000004010b0
    R13: 00007ffd75fcba10 R14: 0000000000000000 R15: 0000000000000000

RCU stall when trying to grab /proc/$pid/stack for the stuck process:
    rcu: INFO: rcu_sched self-detected stall on CPU
    rcu:         0-....: (15000 ticks this GP) idle=2c6/1/0x4000000000000002 softirq=1172554/1172554 fqs=6849
            (t=15001 jiffies g=1935177 q=25734)
    NMI backtrace for cpu 0
    CPU: 0 PID: 21285 Comm: mount_to_symlin Tainted: G      D    OEL    5.5.0-rc1+openat2~v18+ #123
    Hardware name: LENOVO 20KHCTO1WW/20KHCTO1WW, BIOS N23ET55W (1.30 ) 08/31/2018
    Call Trace:
     <IRQ>
     dump_stack+0x8f/0xd0
     ? lapic_can_unplug_cpu.cold+0x3e/0x3e
     nmi_cpu_backtrace.cold+0x14/0x52
     nmi_trigger_cpumask_backtrace+0xf6/0xf8
     rcu_dump_cpu_stacks+0x8f/0xbd
     rcu_sched_clock_irq.cold+0x1b2/0x39f
     update_process_times+0x24/0x50
     tick_sched_handle+0x22/0x60
     tick_sched_timer+0x38/0x80
     ? tick_sched_do_timer+0x60/0x60
     __hrtimer_run_queues+0xf6/0x270
     hrtimer_interrupt+0x10e/0x240
     smp_apic_timer_interrupt+0x6c/0x130
     apic_timer_interrupt+0xf/0x20
     </IRQ>
    RIP: 0010:native_queued_spin_lock_slowpath+0x5b/0x1d0
    Code: 6d f0 0f ba 2f 08 0f 92 c0 0f b6 c0 c1 e0 08 89 c2 8b 07 30 e4 09 d0
         a9 00 01 ff ff 75 47 85 c0 74 0e 8b 07 84 c0 74 08 f3 90 <8b> 07 84 c0
         75 f8 b8 01 00 00 00 66 89 07 c3 8b 37 81 fe 00 01 00
    RSP: 0018:ffffbc7d90547be8 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
    RAX: 0000000000000101 RBX: ffffffffbac7ac60 RCX: 0000000000000018
    RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffa0c0eece8898
    RBP: ffffa0c0eece8898 R08: 00000000006f6f66 R09: 0000000000000003
    R10: 0000000000000000 R11: 808080807fffffff R12: 00000000e25b3c73
    R13: ffffa0c28cb633c0 R14: ffffbc7d90547db0 R15: ffffa0c0eece8898
     _raw_spin_lock+0x1a/0x20
     lockref_get_not_dead+0x4f/0x90
     d_alloc_parallel+0x1a8/0x480
     ? get_acl+0x1a/0x160
     __lookup_slow+0x6b/0x160
     lookup_slow+0x36/0x50
     path_mountpoint+0x1be/0x350
     filename_mountpoint+0xa5/0x150
     ? __lookup_hash+0xa0/0xa0
     ksys_umount+0x78/0x490
     __x64_sys_umount+0x12/0x20
     do_syscall_64+0x64/0x240
     entry_SYSCALL_64_after_hwframe+0x49/0xbe
    RIP: 0033:0x7fbb1fc674e7
    Code: 09 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 31 f6 e9 09
          00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 01
          f0 ff ff 73 01 c3 48 8b 0d 69 09 0c 00 f7 d8 64 89 01 48
    RSP: 002b:00007ffd75fcb858 EFLAGS: 00000202 ORIG_RAX: 00000000000000a6
    RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fbb1fc674e7
    RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000f6c330
    RBP: 00007ffd75fcb930 R08: 0000000000000000 R09: 000000000000000f
    R10: 00000000004004a6 R11: 0000000000000202 R12: 00000000004010b0
    R13: 00007ffd75fcba10 R14: 0000000000000000 R15: 0000000000000000

Deadlock on lock_mount after a successful umount(). The watchdog does trigger,
but I could only find this stall when trying to suspend the system in my logs:
    Freezing of tasks failed after 20.010 seconds (2 tasks refusing to freeze, wq_busy=0):
    mount_to_symlin D    0  5850   5849 0x00000004
    Call Trace:
     ? __schedule+0x2dd/0x770
     schedule+0x4a/0xb0
     rwsem_down_write_slowpath+0x256/0x500
     lock_mount+0x22/0xf0
     do_mount+0x4b7/0x9f0
     ksys_mount+0x7e/0xc0
     __x64_sys_mount+0x21/0x30
     do_syscall_64+0x64/0x240
     entry_SYSCALL_64_after_hwframe+0x49/0xbe
    RIP: 0033:0x7f86e6355fda
    Code: Bad RIP value.
    RSP: 002b:00007ffc36f952d8 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
    RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f86e6355fda
    RDX: 0000000000402099 RSI: 00000000019a5310 RDI: 00007ffc36f96ee1
    RBP: 00007ffc36f953b0 R08: 0000000000402099 R09: 000000000000000f
    R10: 0000000000001000 R11: 0000000000000206 R12: 00000000004010c0
    R13: 00007ffc36f95490 R14: 0000000000000000 R15: 0000000000000000

Cc: stable@vger.kernel.org # pre-git
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>

Aleksa Sarai (1):
  mount: universally disallow mounting over symlinks

 fs/namespace.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)


base-commit: fd6988496e79a6a4bdb514a4655d2920209eb85d
-- 
2.24.1

