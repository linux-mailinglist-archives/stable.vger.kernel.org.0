Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD47A14B8D0
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733305AbgA1O1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:27:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:55346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732908AbgA1O1d (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:27:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1217124685;
        Tue, 28 Jan 2020 14:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221652;
        bh=hBG4xF5eNMz+U8Ss8oyRUdpJHcycuF3yQn4gEn12EHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l6TOdPjcJV6Um2+98V4/gBdYmuttc13/Iz55+/kpnO7ome05zcvNQAvUEPH37kHHm
         zTraXMprSckLcg9fKYwK6nFox5UekpXnFJeDT/OliaHlrPI0ICJ5w0/cNASFoVMMfW
         7gqLMT3k++BrTVQTz4DVsq1bU6Yi7jUiKhDmGmR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Cambda Zhu <cambda@linux.alibaba.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 20/92] tcp: do not leave dangling pointers in tp->highest_sack
Date:   Tue, 28 Jan 2020 15:07:48 +0100
Message-Id: <20200128135811.731079041@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2bec445f9bf35e52e395b971df48d3e1e5dc704a ]

Latest commit 853697504de0 ("tcp: Fix highest_sack and highest_sack_seq")
apparently allowed syzbot to trigger various crashes in TCP stack [1]

I believe this commit only made things easier for syzbot to find
its way into triggering use-after-frees. But really the bugs
could lead to bad TCP behavior or even plain crashes even for
non malicious peers.

I have audited all calls to tcp_rtx_queue_unlink() and
tcp_rtx_queue_unlink_and_free() and made sure tp->highest_sack would be updated
if we are removing from rtx queue the skb that tp->highest_sack points to.

These updates were missing in three locations :

1) tcp_clean_rtx_queue() [This one seems quite serious,
                          I have no idea why this was not caught earlier]

2) tcp_rtx_queue_purge() [Probably not a big deal for normal operations]

3) tcp_send_synack()     [Probably not a big deal for normal operations]

[1]
BUG: KASAN: use-after-free in tcp_highest_sack_seq include/net/tcp.h:1864 [inline]
BUG: KASAN: use-after-free in tcp_highest_sack_seq include/net/tcp.h:1856 [inline]
BUG: KASAN: use-after-free in tcp_check_sack_reordering+0x33c/0x3a0 net/ipv4/tcp_input.c:891
Read of size 4 at addr ffff8880a488d068 by task ksoftirqd/1/16

CPU: 1 PID: 16 Comm: ksoftirqd/1 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
 __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:639
 __asan_report_load4_noabort+0x14/0x20 mm/kasan/generic_report.c:134
 tcp_highest_sack_seq include/net/tcp.h:1864 [inline]
 tcp_highest_sack_seq include/net/tcp.h:1856 [inline]
 tcp_check_sack_reordering+0x33c/0x3a0 net/ipv4/tcp_input.c:891
 tcp_try_undo_partial net/ipv4/tcp_input.c:2730 [inline]
 tcp_fastretrans_alert+0xf74/0x23f0 net/ipv4/tcp_input.c:2847
 tcp_ack+0x2577/0x5bf0 net/ipv4/tcp_input.c:3710
 tcp_rcv_established+0x6dd/0x1e90 net/ipv4/tcp_input.c:5706
 tcp_v4_do_rcv+0x619/0x8d0 net/ipv4/tcp_ipv4.c:1619
 tcp_v4_rcv+0x307f/0x3b40 net/ipv4/tcp_ipv4.c:2001
 ip_protocol_deliver_rcu+0x5a/0x880 net/ipv4/ip_input.c:204
 ip_local_deliver_finish+0x23b/0x380 net/ipv4/ip_input.c:231
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip_local_deliver+0x1e9/0x520 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:442 [inline]
 ip_rcv_finish+0x1db/0x2f0 net/ipv4/ip_input.c:428
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip_rcv+0xe8/0x3f0 net/ipv4/ip_input.c:538
 __netif_receive_skb_one_core+0x113/0x1a0 net/core/dev.c:5148
 __netif_receive_skb+0x2c/0x1d0 net/core/dev.c:5262
 process_backlog+0x206/0x750 net/core/dev.c:6093
 napi_poll net/core/dev.c:6530 [inline]
 net_rx_action+0x508/0x1120 net/core/dev.c:6598
 __do_softirq+0x262/0x98c kernel/softirq.c:292
 run_ksoftirqd kernel/softirq.c:603 [inline]
 run_ksoftirqd+0x8e/0x110 kernel/softirq.c:595
 smpboot_thread_fn+0x6a3/0xa40 kernel/smpboot.c:165
 kthread+0x361/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 10091:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:513 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:486
 kasan_slab_alloc+0xf/0x20 mm/kasan/common.c:521
 slab_post_alloc_hook mm/slab.h:584 [inline]
 slab_alloc_node mm/slab.c:3263 [inline]
 kmem_cache_alloc_node+0x138/0x740 mm/slab.c:3575
 __alloc_skb+0xd5/0x5e0 net/core/skbuff.c:198
 alloc_skb_fclone include/linux/skbuff.h:1099 [inline]
 sk_stream_alloc_skb net/ipv4/tcp.c:875 [inline]
 sk_stream_alloc_skb+0x113/0xc90 net/ipv4/tcp.c:852
 tcp_sendmsg_locked+0xcf9/0x3470 net/ipv4/tcp.c:1282
 tcp_sendmsg+0x30/0x50 net/ipv4/tcp.c:1432
 inet_sendmsg+0x9e/0xe0 net/ipv4/af_inet.c:807
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:672
 __sys_sendto+0x262/0x380 net/socket.c:1998
 __do_sys_sendto net/socket.c:2010 [inline]
 __se_sys_sendto net/socket.c:2006 [inline]
 __x64_sys_sendto+0xe1/0x1a0 net/socket.c:2006
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 10095:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:335 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:474
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:483
 __cache_free mm/slab.c:3426 [inline]
 kmem_cache_free+0x86/0x320 mm/slab.c:3694
 kfree_skbmem+0x178/0x1c0 net/core/skbuff.c:645
 __kfree_skb+0x1e/0x30 net/core/skbuff.c:681
 sk_eat_skb include/net/sock.h:2453 [inline]
 tcp_recvmsg+0x1252/0x2930 net/ipv4/tcp.c:2166
 inet_recvmsg+0x136/0x610 net/ipv4/af_inet.c:838
 sock_recvmsg_nosec net/socket.c:886 [inline]
 sock_recvmsg net/socket.c:904 [inline]
 sock_recvmsg+0xce/0x110 net/socket.c:900
 __sys_recvfrom+0x1ff/0x350 net/socket.c:2055
 __do_sys_recvfrom net/socket.c:2073 [inline]
 __se_sys_recvfrom net/socket.c:2069 [inline]
 __x64_sys_recvfrom+0xe1/0x1a0 net/socket.c:2069
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880a488d040
 which belongs to the cache skbuff_fclone_cache of size 456
The buggy address is located 40 bytes inside of
 456-byte region [ffff8880a488d040, ffff8880a488d208)
The buggy address belongs to the page:
page:ffffea0002922340 refcount:1 mapcount:0 mapping:ffff88821b057000 index:0x0
raw: 00fffe0000000200 ffffea00022a5788 ffffea0002624a48 ffff88821b057000
raw: 0000000000000000 ffff8880a488d040 0000000100000006 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a488cf00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880a488cf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880a488d000: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
                                                          ^
 ffff8880a488d080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a488d100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

Fixes: 853697504de0 ("tcp: Fix highest_sack and highest_sack_seq")
Fixes: 50895b9de1d3 ("tcp: highest_sack fix")
Fixes: 737ff314563c ("tcp: use sequence distance to detect reordering")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Cambda Zhu <cambda@linux.alibaba.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c        |    1 +
 net/ipv4/tcp_input.c  |    1 +
 net/ipv4/tcp_output.c |    1 +
 3 files changed, 3 insertions(+)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2507,6 +2507,7 @@ static void tcp_rtx_queue_purge(struct s
 {
 	struct rb_node *p = rb_first(&sk->tcp_rtx_queue);
 
+	tcp_sk(sk)->highest_sack = NULL;
 	while (p) {
 		struct sk_buff *skb = rb_to_skb(p);
 
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3149,6 +3149,7 @@ static int tcp_clean_rtx_queue(struct so
 			tp->retransmit_skb_hint = NULL;
 		if (unlikely(skb == tp->lost_skb_hint))
 			tp->lost_skb_hint = NULL;
+		tcp_highest_sack_replace(sk, skb, next);
 		tcp_rtx_queue_unlink_and_free(skb, sk);
 	}
 
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3165,6 +3165,7 @@ int tcp_send_synack(struct sock *sk)
 			if (!nskb)
 				return -ENOMEM;
 			INIT_LIST_HEAD(&nskb->tcp_tsorted_anchor);
+			tcp_highest_sack_replace(sk, skb, nskb);
 			tcp_rtx_queue_unlink_and_free(skb, sk);
 			__skb_header_release(nskb);
 			tcp_rbtree_insert(&sk->tcp_rtx_queue, nskb);


