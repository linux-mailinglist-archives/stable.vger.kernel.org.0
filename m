Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7ED536F1B
	for <lists+stable@lfdr.de>; Sun, 29 May 2022 04:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbiE2CHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 May 2022 22:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiE2CHW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 May 2022 22:07:22 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744F8C0E18
        for <stable@vger.kernel.org>; Sat, 28 May 2022 19:07:20 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id g8-20020a92cda8000000b002d15f63967eso5644366ild.21
        for <stable@vger.kernel.org>; Sat, 28 May 2022 19:07:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=pyoFaJGGHQmOy56c5cHvee6a0sMVUgJXvqet7QBvb7g=;
        b=u8WYtV9Ajpqj283itYE0nFA5N8Ry0srn1s+yFxp6MOCILltGZi6FnQg5UDzVyiikpm
         NgNWOx7iQcqawjAjuTF+MMk5c9Y0UC+qK6Y7Wizb7PbDLlW7kehn+MeVoZG3pvNPcEgN
         SEH3lpbTX34ZSwjVeIgBiCa50qdax0zcEZKW5AVjTNHDzLSN+mz7S8h7N70Kp1d8ZRYS
         nz3bFdg4dQo4U+uMyfFTTyzJ7w4/JB99gkL072IYdco1xwlx+2eNdW65VGk47QOv9ben
         8IrWePbqgLgc99qM3q2bGryZeM+PQ7J4RRxKL1xcRkrmxV0+h2qsUcR1z3/wfU1auMcE
         hkQw==
X-Gm-Message-State: AOAM532YyctnVnTMzaP5+KI7vta0A0xTz6w4sYGjVw4y9XwAKjmuNS1e
        BEC4MSrL0rBMTuW4ihUnJdpqlKIs25HONU3kUmzM9Dbl3PLN
X-Google-Smtp-Source: ABdhPJya/qR/QjJqCapciT/6WYEqyxH+uKPn0diDNB4qBUzUoVdo1AC5ezYLg0sFt4Wz2pZs4PlanXjP1YOG1UB5w3FlPp8POPaw
MIME-Version: 1.0
X-Received: by 2002:a02:c48b:0:b0:330:fc34:7412 with SMTP id
 t11-20020a02c48b000000b00330fc347412mr4235771jam.116.1653790039813; Sat, 28
 May 2022 19:07:19 -0700 (PDT)
Date:   Sat, 28 May 2022 19:07:19 -0700
In-Reply-To: <000000000000e66c2805de55b15a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000db349d05e01cffa8@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in driver_register
From:   syzbot <syzbot+dc7c3ca638e773db07f6@syzkaller.appspotmail.com>
To:     Julia.Lawall@inria.fr, andreyknvl@gmail.com, balbi@kernel.org,
        gregkh@linuxfoundation.org, jannh@google.com,
        jj251510319013@gmail.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, rafael@kernel.org, sashal@kernel.org,
        schspa@gmail.com, stable@vger.kernel.org,
        stern@rowland.harvard.edu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    d3fde8ff50ab Add linux-next specific files for 20220527
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=154faf23f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ccb8d66fc9489ef
dashboard link: https://syzkaller.appspot.com/bug?extid=dc7c3ca638e773db07f6
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17315ad6f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12087513f00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dc7c3ca638e773db07f6@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in driver_find drivers/base/driver.c:293 [inline]
BUG: KASAN: use-after-free in driver_register+0x352/0x3a0 drivers/base/driver.c:233
Read of size 8 at addr ffff88807813bec8 by task syz-executor372/10628

CPU: 1 PID: 10628 Comm: syz-executor372 Not tainted 5.18.0-next-20220527-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xeb/0x495 mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 driver_find drivers/base/driver.c:293 [inline]
 driver_register+0x352/0x3a0 drivers/base/driver.c:233
 usb_gadget_register_driver_owner+0xfb/0x1e0 drivers/usb/gadget/udc/core.c:1558
 raw_ioctl_run drivers/usb/gadget/legacy/raw_gadget.c:515 [inline]
 raw_ioctl+0x188d/0x2730 drivers/usb/gadget/legacy/raw_gadget.c:1222
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7fddef18d7d7
Code: 3c 1c 48 f7 d8 49 39 c4 72 b8 e8 14 59 02 00 85 c0 78 bd 48 83 c4 08 4c 89 e0 5b 41 5c c3 0f 1f 44 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fddef12b258 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fddef12c2d0 RCX: 00007fddef18d7d7
RDX: 0000000000000000 RSI: 0000000000005501 RDI: 0000000000000007
RBP: 0000000000000000 R08: 000000000000ffff R09: 000000000000000b
R10: 00007fddef12b300 R11: 0000000000000246 R12: 00007fddef211360
R13: 00007fddef12b2a0 R14: 00007fddef12d400 R15: 0000000000000007
 </TASK>

Allocated by task 10078:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:524
 kmalloc include/linux/slab.h:600 [inline]
 kzalloc include/linux/slab.h:733 [inline]
 bus_add_driver+0xd4/0x640 drivers/base/bus.c:602
 driver_register+0x220/0x3a0 drivers/base/driver.c:240
 usb_gadget_register_driver_owner+0xfb/0x1e0 drivers/usb/gadget/udc/core.c:1558
 raw_ioctl_run drivers/usb/gadget/legacy/raw_gadget.c:515 [inline]
 raw_ioctl+0x188d/0x2730 drivers/usb/gadget/legacy/raw_gadget.c:1222
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Freed by task 10628:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0x166/0x1a0 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1727 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1753
 slab_free mm/slub.c:3507 [inline]
 kfree+0xd6/0x4d0 mm/slub.c:4555
 kobject_cleanup lib/kobject.c:673 [inline]
 kobject_release lib/kobject.c:704 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c8/0x540 lib/kobject.c:721
 driver_find drivers/base/driver.c:291 [inline]
 driver_register+0x1e3/0x3a0 drivers/base/driver.c:233
 usb_gadget_register_driver_owner+0xfb/0x1e0 drivers/usb/gadget/udc/core.c:1558
 raw_ioctl_run drivers/usb/gadget/legacy/raw_gadget.c:515 [inline]
 raw_ioctl+0x188d/0x2730 drivers/usb/gadget/legacy/raw_gadget.c:1222
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Last potentially related work creation:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 __kasan_record_aux_stack+0xbe/0xd0 mm/kasan/generic.c:348
 kvfree_call_rcu+0x74/0x990 kernel/rcu/tree.c:3647
 drop_sysctl_table+0x3c0/0x4e0 fs/proc/proc_sysctl.c:1716
 unregister_sysctl_table fs/proc/proc_sysctl.c:1754 [inline]
 unregister_sysctl_table+0xc0/0x190 fs/proc/proc_sysctl.c:1729
 __addrconf_sysctl_unregister net/ipv6/addrconf.c:7108 [inline]
 addrconf_sysctl_unregister+0xee/0x1c0 net/ipv6/addrconf.c:7136
 addrconf_notify+0x7f6/0x1ba0 net/ipv6/addrconf.c:3679
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1943
 call_netdevice_notifiers_extack net/core/dev.c:1981 [inline]
 call_netdevice_notifiers net/core/dev.c:1995 [inline]
 dev_change_name+0x571/0x820 net/core/dev.c:1224
 do_setlink+0x19a9/0x3bb0 net/core/rtnetlink.c:2760
 __rtnl_newlink+0xd6a/0x17e0 net/core/rtnetlink.c:3546
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3593
 rtnetlink_rcv_msg+0x43a/0xc90 net/core/rtnetlink.c:6089
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 __sys_sendto+0x21a/0x320 net/socket.c:2119
 __do_sys_sendto net/socket.c:2131 [inline]
 __se_sys_sendto net/socket.c:2127 [inline]
 __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2127
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

The buggy address belongs to the object at ffff88807813be00
 which belongs to the cache kmalloc-256 of size 256
The buggy address is located 200 bytes inside of
 256-byte region [ffff88807813be00, ffff88807813bf00)

The buggy address belongs to the physical page:
page:ffffea0001e04e80 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88807813ba00 pfn:0x7813a
head:ffffea0001e04e80 order:1 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 dead000000000100 dead000000000122 ffff888010c41b40
raw: ffff88807813ba00 000000008010000f 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 1, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 3682, tgid 3682 (syz-executor372), ts 1120620374205, free_ts 1120617564582
 prep_new_page mm/page_alloc.c:2464 [inline]
 get_page_from_freelist+0xa64/0x3d10 mm/page_alloc.c:4283
 __alloc_pages+0x1c7/0x510 mm/page_alloc.c:5507
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2272
 alloc_slab_page mm/slub.c:1797 [inline]
 allocate_slab+0x26c/0x3c0 mm/slub.c:1942
 new_slab mm/slub.c:2002 [inline]
 ___slab_alloc+0x985/0xd90 mm/slub.c:3002
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3089
 slab_alloc_node mm/slub.c:3180 [inline]
 slab_alloc mm/slub.c:3222 [inline]
 __kmalloc+0x318/0x350 mm/slub.c:4413
 kmalloc include/linux/slab.h:605 [inline]
 kzalloc include/linux/slab.h:733 [inline]
 fib_create_info+0xdbe/0x4ac0 net/ipv4/fib_semantics.c:1448
 fib_table_insert+0x19a/0x1bd0 net/ipv4/fib_trie.c:1233
 fib_magic+0x455/0x540 net/ipv4/fib_frontend.c:1098
 fib_add_ifaddr+0x16b/0x540 net/ipv4/fib_frontend.c:1120
 fib_inetaddr_event+0x162/0x2a0 net/ipv4/fib_frontend.c:1434
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 blocking_notifier_call_chain kernel/notifier.c:382 [inline]
 blocking_notifier_call_chain+0x67/0x90 kernel/notifier.c:370
 __inet_insert_ifa+0x919/0xbd0 net/ipv4/devinet.c:554
 inet_rtm_newaddr+0x54d/0x980 net/ipv4/devinet.c:960
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1379 [inline]
 free_pcp_prepare+0x549/0xd20 mm/page_alloc.c:1429
 free_unref_page_prepare mm/page_alloc.c:3315 [inline]
 free_unref_page+0x19/0x7b0 mm/page_alloc.c:3430
 qlink_free mm/kasan/quarantine.c:168 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:294
 __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:446
 kasan_slab_alloc include/linux/kasan.h:224 [inline]
 slab_post_alloc_hook mm/slab.h:750 [inline]
 slab_alloc_node mm/slub.c:3214 [inline]
 kmem_cache_alloc_node+0x255/0x3f0 mm/slub.c:3264
 __alloc_skb+0x215/0x340 net/core/skbuff.c:414
 alloc_skb include/linux/skbuff.h:1426 [inline]
 nlmsg_new include/net/netlink.h:953 [inline]
 netlink_ack+0x1f0/0xa80 net/netlink/af_netlink.c:2436
 netlink_rcv_skb+0x33d/0x420 net/netlink/af_netlink.c:2507
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 __sys_sendto+0x21a/0x320 net/socket.c:2119
 __do_sys_sendto net/socket.c:2131 [inline]
 __se_sys_sendto net/socket.c:2127 [inline]
 __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2127
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Memory state around the buggy address:
 ffff88807813bd80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88807813be00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88807813be80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                              ^
 ffff88807813bf00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88807813bf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================

