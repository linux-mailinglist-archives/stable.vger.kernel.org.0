Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31FF714FD18
	for <lists+stable@lfdr.de>; Sun,  2 Feb 2020 13:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgBBM4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Feb 2020 07:56:11 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:46844 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgBBM4L (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Feb 2020 07:56:11 -0500
Received: by mail-io1-f72.google.com with SMTP id r74so7530930iod.13
        for <stable@vger.kernel.org>; Sun, 02 Feb 2020 04:56:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=sePf426ABt6fcfW2msbuyQb20FjZbY8UnbS/9wl19Js=;
        b=rg4SZaqZC50BfEypVi7w0aRsD4vfY6FBSpj+/OQNfFWhXvpRN3/oDCblDSytfpvrWJ
         tKgfbv6NSy8QUBV4GL3ytj3DItKpVr/OiM+TDgZwFFfzRZ5RrwkBwidnpXP7NEHeUOMO
         mEnk9jY3kvjGp6XWUJuc6HmFraQ195YFoQ1v4ThwHKKvHywumEq0fqyjiml0kngW8TDD
         +3IpL5Zl+FXxBVbi7lvMQX6C4buUf5paqd8/vYDv4PlphWOWYiZSG/ysRgXpCeyawhHu
         T2/7T8J7bA1cAgdUR2t/5peP0/65m2qOqnNpOqweC5ydFSv3Mwu77gzEMcYiyIBOebEQ
         Oepg==
X-Gm-Message-State: APjAAAXit5sqCKzVAUYkAfmweLNWuDsvPDZ8nwoZlu59YZX3MtMLfhTc
        //p3oIhMBQnxIQSG6KCpju3SudNoJ26xqKRfuLz0UIANBYfe
X-Google-Smtp-Source: APXvYqy8VV3RncJn8Jm0k2KOgfBpYPIkjpHi0oXQcFF20WQB2AgJX5sLyq/vbRVZhP3msfaLP4/botoBnFUJ0k3g+eS+HaUHZXJi
MIME-Version: 1.0
X-Received: by 2002:a6b:bf06:: with SMTP id p6mr16156143iof.255.1580648170848;
 Sun, 02 Feb 2020 04:56:10 -0800 (PST)
Date:   Sun, 02 Feb 2020 04:56:10 -0800
In-Reply-To: <000000000000729d74059c30ddff@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bd0524059d975403@google.com>
Subject: Re: KASAN: use-after-free Read in snd_timer_resolution
From:   syzbot <syzbot+2b2ef983f973e5c40943@syzkaller.appspotmail.com>
To:     20200115203733.26530-1-tiwai@suse.de,
        alsa-devel-owner@alsa-project.org, alsa-devel@alsa-project.org,
        arnd@arndb.de, baolin.wang@linaro.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, perex@perex.cz,
        stable-commits@vger.kernel.org, stable@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tiwai@suse.com, tiwai@suse.de
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    2747d5fd Add linux-next specific files for 20200116
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1147e101e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=22f506e7a3a37fe2
dashboard link: https://syzkaller.appspot.com/bug?extid=2b2ef983f973e5c40943
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10c0864ee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14738df1e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2b2ef983f973e5c40943@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in snd_timer_resolution+0xf1/0x110 sound/core/timer.c:487
Read of size 8 at addr ffff88809e0f5a00 by task syz-executor911/9849

CPU: 1 PID: 9849 Comm: syz-executor911 Not tainted 5.5.0-rc6-next-20200116-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
 __kasan_report.cold+0x1b/0x32 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:641
 __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:135
 snd_timer_resolution+0xf1/0x110 sound/core/timer.c:487
 snd_seq_info_timer_read+0x95/0x2f1 sound/core/seq/seq_timer.c:480
 snd_info_seq_show+0xcb/0x120 sound/core/info.c:362
 seq_read+0x4ca/0x1170 fs/seq_file.c:229
 proc_reg_read+0x1f8/0x2b0 fs/proc/inode.c:223
 do_loop_readv_writev fs/read_write.c:714 [inline]
 do_loop_readv_writev fs/read_write.c:701 [inline]
 do_iter_read+0x4a4/0x660 fs/read_write.c:935
 vfs_readv+0xf0/0x160 fs/read_write.c:997
 do_preadv+0x1c4/0x280 fs/read_write.c:1089
 __do_sys_preadv fs/read_write.c:1139 [inline]
 __se_sys_preadv fs/read_write.c:1134 [inline]
 __x64_sys_preadv+0x9a/0xf0 fs/read_write.c:1134
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441389
Code: e8 ac e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 eb 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc8aa7ce38 EFLAGS: 00000246 ORIG_RAX: 0000000000000127
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441389
RDX: 0000000000000227 RSI: 00000000200017c0 RDI: 0000000000000004
RBP: 00007ffc8aa7ce50 R08: 000000000000000f R09: 00000000000000c2
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402100
R13: 0000000000402190 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 9852:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:515 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:488
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:529
 kmem_cache_alloc_trace+0x158/0x790 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 snd_timer_instance_new+0x4a/0x300 sound/core/timer.c:142
 snd_seq_timer_open+0x1c0/0x590 sound/core/seq/seq_timer.c:275
 queue_use+0xf1/0x270 sound/core/seq/seq_queue.c:489
 snd_seq_queue_alloc+0x2c5/0x4d0 sound/core/seq/seq_queue.c:176
 snd_seq_ioctl_create_queue+0xb0/0x330 sound/core/seq/seq_clientmgr.c:1548
 snd_seq_kernel_client_ctl+0xf8/0x140 sound/core/seq/seq_clientmgr.c:2353
 alloc_seq_queue.isra.0+0xdc/0x180 sound/core/seq/oss/seq_oss_init.c:357
 snd_seq_oss_open+0x2ff/0x960 sound/core/seq/oss/seq_oss_init.c:215
 odev_open+0x70/0x90 sound/core/seq/oss/seq_oss.c:125
 soundcore_open+0x453/0x610 sound/sound_core.c:593
 chrdev_open+0x245/0x6b0 fs/char_dev.c:414
 do_dentry_open+0x4ca/0x1350 fs/open.c:797
 vfs_open+0xa0/0xd0 fs/open.c:914
 do_last fs/namei.c:3487 [inline]
 path_openat+0x12fd/0x34d0 fs/namei.c:3604
 do_filp_open+0x192/0x260 fs/namei.c:3634
 do_sys_openat2+0x633/0x840 fs/open.c:1151
 do_sys_open+0xfc/0x190 fs/open.c:1167
 __do_sys_openat fs/open.c:1181 [inline]
 __se_sys_openat fs/open.c:1176 [inline]
 __x64_sys_openat+0x9d/0x100 fs/open.c:1176
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 9852:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:337 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:476
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:485
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x2c0 mm/slab.c:3757
 snd_timer_instance_free sound/core/timer.c:166 [inline]
 snd_timer_instance_free+0x7c/0xa0 sound/core/timer.c:160
 snd_seq_timer_close+0x99/0xe0 sound/core/seq/seq_timer.c:319
 queue_delete+0x52/0xb0 sound/core/seq/seq_queue.c:134
 snd_seq_queue_delete+0x4e/0x70 sound/core/seq/seq_queue.c:196
 snd_seq_ioctl_delete_queue+0x6a/0x90 sound/core/seq/seq_clientmgr.c:1570
 snd_seq_kernel_client_ctl+0xf8/0x140 sound/core/seq/seq_clientmgr.c:2353
 delete_seq_queue.part.0+0xb6/0x120 sound/core/seq/oss/seq_oss_init.c:376
 delete_seq_queue sound/core/seq/oss/seq_oss_init.c:372 [inline]
 snd_seq_oss_release+0x116/0x150 sound/core/seq/oss/seq_oss_init.c:421
 odev_release+0x54/0x80 sound/core/seq/oss/seq_oss.c:140
 __fput+0x2ff/0x890 fs/file_table.c:280
 ____fput+0x16/0x20 fs/file_table.c:313
 task_work_run+0x145/0x1c0 kernel/task_work.c:113
 exit_task_work include/linux/task_work.h:22 [inline]
 do_exit+0xbcb/0x2f80 kernel/exit.c:801
 do_group_exit+0x135/0x360 kernel/exit.c:899
 __do_sys_exit_group kernel/exit.c:910 [inline]
 __se_sys_exit_group kernel/exit.c:908 [inline]
 __x64_sys_exit_group+0x44/0x50 kernel/exit.c:908
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff88809e0f5a00
 which belongs to the cache kmalloc-256 of size 256
The buggy address is located 0 bytes inside of
 256-byte region [ffff88809e0f5a00, ffff88809e0f5b00)
The buggy address belongs to the page:
page:ffffea0002783d40 refcount:1 mapcount:0 mapping:ffff8880aa4008c0 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0002783948 ffffea00027872c8 ffff8880aa4008c0
raw: 0000000000000000 ffff88809e0f5000 0000000100000008 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88809e0f5900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88809e0f5980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88809e0f5a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88809e0f5a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88809e0f5b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================

