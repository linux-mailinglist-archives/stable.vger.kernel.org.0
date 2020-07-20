Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0EC226886
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733027AbgGTQGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:06:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733020AbgGTQGA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:06:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE1612065E;
        Mon, 20 Jul 2020 16:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261159;
        bh=7WlQAxklApndpVq4BnML78kRdfxNpqoNhGpz7O6ZraI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WoQu1tNgvINkV6RsOWIMFKXUKZ/3mgH3m8h0y0z0Fd7BZz+etOlJc1vfjJBxnhRvp
         t/Xu9hRaFsLuRvo6hdSpahrkKrmYBHOqR9J5YiDAMvc/1iiFJyicRud6Ue/PsgJmVz
         qTNZQ9/EAt6ORF31gRXaxwWvabkDB+IyxHsF/6ow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 007/244] llc: make sure applications use ARPHRD_ETHER
Date:   Mon, 20 Jul 2020 17:34:38 +0200
Message-Id: <20200720152826.222651012@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a9b1110162357689a34992d5c925852948e5b9fd ]

syzbot was to trigger a bug by tricking AF_LLC with
non sensible addr->sllc_arphrd

It seems clear LLC requires an Ethernet device.

Back in commit abf9d537fea2 ("llc: add support for SO_BINDTODEVICE")
Octavian Purdila added possibility for application to use a zero
value for sllc_arphrd, convert it to ARPHRD_ETHER to not cause
regressions on existing applications.

BUG: KASAN: use-after-free in __read_once_size include/linux/compiler.h:199 [inline]
BUG: KASAN: use-after-free in list_empty include/linux/list.h:268 [inline]
BUG: KASAN: use-after-free in waitqueue_active include/linux/wait.h:126 [inline]
BUG: KASAN: use-after-free in wq_has_sleeper include/linux/wait.h:160 [inline]
BUG: KASAN: use-after-free in skwq_has_sleeper include/net/sock.h:2092 [inline]
BUG: KASAN: use-after-free in sock_def_write_space+0x642/0x670 net/core/sock.c:2813
Read of size 8 at addr ffff88801e0b4078 by task ksoftirqd/3/27

CPU: 3 PID: 27 Comm: ksoftirqd/3 Not tainted 5.5.0-rc1-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
 __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:639
 __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:135
 __read_once_size include/linux/compiler.h:199 [inline]
 list_empty include/linux/list.h:268 [inline]
 waitqueue_active include/linux/wait.h:126 [inline]
 wq_has_sleeper include/linux/wait.h:160 [inline]
 skwq_has_sleeper include/net/sock.h:2092 [inline]
 sock_def_write_space+0x642/0x670 net/core/sock.c:2813
 sock_wfree+0x1e1/0x260 net/core/sock.c:1958
 skb_release_head_state+0xeb/0x260 net/core/skbuff.c:652
 skb_release_all+0x16/0x60 net/core/skbuff.c:663
 __kfree_skb net/core/skbuff.c:679 [inline]
 consume_skb net/core/skbuff.c:838 [inline]
 consume_skb+0xfb/0x410 net/core/skbuff.c:832
 __dev_kfree_skb_any+0xa4/0xd0 net/core/dev.c:2967
 dev_kfree_skb_any include/linux/netdevice.h:3650 [inline]
 e1000_unmap_and_free_tx_resource.isra.0+0x21b/0x3a0 drivers/net/ethernet/intel/e1000/e1000_main.c:1963
 e1000_clean_tx_irq drivers/net/ethernet/intel/e1000/e1000_main.c:3854 [inline]
 e1000_clean+0x4cc/0x1d10 drivers/net/ethernet/intel/e1000/e1000_main.c:3796
 napi_poll net/core/dev.c:6532 [inline]
 net_rx_action+0x508/0x1120 net/core/dev.c:6600
 __do_softirq+0x262/0x98c kernel/softirq.c:292
 run_ksoftirqd kernel/softirq.c:603 [inline]
 run_ksoftirqd+0x8e/0x110 kernel/softirq.c:595
 smpboot_thread_fn+0x6a3/0xa40 kernel/smpboot.c:165
 kthread+0x361/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 8247:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:513 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:486
 kasan_slab_alloc+0xf/0x20 mm/kasan/common.c:521
 slab_post_alloc_hook mm/slab.h:584 [inline]
 slab_alloc mm/slab.c:3320 [inline]
 kmem_cache_alloc+0x121/0x710 mm/slab.c:3484
 sock_alloc_inode+0x1c/0x1d0 net/socket.c:240
 alloc_inode+0x68/0x1e0 fs/inode.c:230
 new_inode_pseudo+0x19/0xf0 fs/inode.c:919
 sock_alloc+0x41/0x270 net/socket.c:560
 __sock_create+0xc2/0x730 net/socket.c:1384
 sock_create net/socket.c:1471 [inline]
 __sys_socket+0x103/0x220 net/socket.c:1513
 __do_sys_socket net/socket.c:1522 [inline]
 __se_sys_socket net/socket.c:1520 [inline]
 __ia32_sys_socket+0x73/0xb0 net/socket.c:1520
 do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
 do_fast_syscall_32+0x27b/0xe16 arch/x86/entry/common.c:408
 entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139

Freed by task 17:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:335 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:474
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:483
 __cache_free mm/slab.c:3426 [inline]
 kmem_cache_free+0x86/0x320 mm/slab.c:3694
 sock_free_inode+0x20/0x30 net/socket.c:261
 i_callback+0x44/0x80 fs/inode.c:219
 __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
 rcu_do_batch kernel/rcu/tree.c:2183 [inline]
 rcu_core+0x570/0x1540 kernel/rcu/tree.c:2408
 rcu_core_si+0x9/0x10 kernel/rcu/tree.c:2417
 __do_softirq+0x262/0x98c kernel/softirq.c:292

The buggy address belongs to the object at ffff88801e0b4000
 which belongs to the cache sock_inode_cache of size 1152
The buggy address is located 120 bytes inside of
 1152-byte region [ffff88801e0b4000, ffff88801e0b4480)
The buggy address belongs to the page:
page:ffffea0000782d00 refcount:1 mapcount:0 mapping:ffff88807aa59c40 index:0xffff88801e0b4ffd
raw: 00fffe0000000200 ffffea00008e6c88 ffffea0000782d48 ffff88807aa59c40
raw: ffff88801e0b4ffd ffff88801e0b4000 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88801e0b3f00: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff88801e0b3f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88801e0b4000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                                ^
 ffff88801e0b4080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801e0b4100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

Fixes: abf9d537fea2 ("llc: add support for SO_BINDTODEVICE")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/llc/af_llc.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -273,6 +273,10 @@ static int llc_ui_autobind(struct socket
 
 	if (!sock_flag(sk, SOCK_ZAPPED))
 		goto out;
+	if (!addr->sllc_arphrd)
+		addr->sllc_arphrd = ARPHRD_ETHER;
+	if (addr->sllc_arphrd != ARPHRD_ETHER)
+		goto out;
 	rc = -ENODEV;
 	if (sk->sk_bound_dev_if) {
 		llc->dev = dev_get_by_index(&init_net, sk->sk_bound_dev_if);
@@ -328,7 +332,9 @@ static int llc_ui_bind(struct socket *so
 	if (unlikely(!sock_flag(sk, SOCK_ZAPPED) || addrlen != sizeof(*addr)))
 		goto out;
 	rc = -EAFNOSUPPORT;
-	if (unlikely(addr->sllc_family != AF_LLC))
+	if (!addr->sllc_arphrd)
+		addr->sllc_arphrd = ARPHRD_ETHER;
+	if (unlikely(addr->sllc_family != AF_LLC || addr->sllc_arphrd != ARPHRD_ETHER))
 		goto out;
 	dprintk("%s: binding %02X\n", __func__, addr->sllc_sap);
 	rc = -ENODEV;
@@ -336,8 +342,6 @@ static int llc_ui_bind(struct socket *so
 	if (sk->sk_bound_dev_if) {
 		llc->dev = dev_get_by_index_rcu(&init_net, sk->sk_bound_dev_if);
 		if (llc->dev) {
-			if (!addr->sllc_arphrd)
-				addr->sllc_arphrd = llc->dev->type;
 			if (is_zero_ether_addr(addr->sllc_mac))
 				memcpy(addr->sllc_mac, llc->dev->dev_addr,
 				       IFHWADDRLEN);


