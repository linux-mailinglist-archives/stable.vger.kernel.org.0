Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18A26F6E2
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731274AbfD3Luw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:50:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730921AbfD3Luw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:50:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65651217D9;
        Tue, 30 Apr 2019 11:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556625050;
        bh=1F6WD+cQIGJ6IX01gJv7QDsRBhXfi/8ku3R54H4moms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AB53GKY4pGqFnQlt0+Oz5JFd0fCHNg8ogLbw+QJ5c8FhBHV64ZekH5dJOuWQ/Aq2x
         F5QhfO+k4Y4FxNUlj5UDbhEHv6z/Y8sX+Ht1JUMM2fEmUpCP93/eOrW290Nzq67wQ+
         msCkY8bWMH0As5q8rharBhkfrsoU80oWU8auNXbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 72/89] ipv4: add sanity checks in ipv4_link_failure()
Date:   Tue, 30 Apr 2019 13:39:03 +0200
Message-Id: <20190430113613.121970910@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 20ff83f10f113c88d0bb74589389b05250994c16 ]

Before calling __ip_options_compile(), we need to ensure the network
header is a an IPv4 one, and that it is already pulled in skb->head.

RAW sockets going through a tunnel can end up calling ipv4_link_failure()
with total garbage in the skb, or arbitrary lengthes.

syzbot report :

BUG: KASAN: stack-out-of-bounds in memcpy include/linux/string.h:355 [inline]
BUG: KASAN: stack-out-of-bounds in __ip_options_echo+0x294/0x1120 net/ipv4/ip_options.c:123
Write of size 69 at addr ffff888096abf068 by task syz-executor.4/9204

CPU: 0 PID: 9204 Comm: syz-executor.4 Not tainted 5.1.0-rc5+ #77
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 print_address_description.cold+0x7c/0x20d mm/kasan/report.c:187
 kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
 check_memory_region_inline mm/kasan/generic.c:185 [inline]
 check_memory_region+0x123/0x190 mm/kasan/generic.c:191
 memcpy+0x38/0x50 mm/kasan/common.c:133
 memcpy include/linux/string.h:355 [inline]
 __ip_options_echo+0x294/0x1120 net/ipv4/ip_options.c:123
 __icmp_send+0x725/0x1400 net/ipv4/icmp.c:695
 ipv4_link_failure+0x29f/0x550 net/ipv4/route.c:1204
 dst_link_failure include/net/dst.h:427 [inline]
 vti6_xmit net/ipv6/ip6_vti.c:514 [inline]
 vti6_tnl_xmit+0x10d4/0x1c0c net/ipv6/ip6_vti.c:553
 __netdev_start_xmit include/linux/netdevice.h:4414 [inline]
 netdev_start_xmit include/linux/netdevice.h:4423 [inline]
 xmit_one net/core/dev.c:3292 [inline]
 dev_hard_start_xmit+0x1b2/0x980 net/core/dev.c:3308
 __dev_queue_xmit+0x271d/0x3060 net/core/dev.c:3878
 dev_queue_xmit+0x18/0x20 net/core/dev.c:3911
 neigh_direct_output+0x16/0x20 net/core/neighbour.c:1527
 neigh_output include/net/neighbour.h:508 [inline]
 ip_finish_output2+0x949/0x1740 net/ipv4/ip_output.c:229
 ip_finish_output+0x73c/0xd50 net/ipv4/ip_output.c:317
 NF_HOOK_COND include/linux/netfilter.h:278 [inline]
 ip_output+0x21f/0x670 net/ipv4/ip_output.c:405
 dst_output include/net/dst.h:444 [inline]
 NF_HOOK include/linux/netfilter.h:289 [inline]
 raw_send_hdrinc net/ipv4/raw.c:432 [inline]
 raw_sendmsg+0x1d2b/0x2f20 net/ipv4/raw.c:663
 inet_sendmsg+0x147/0x5d0 net/ipv4/af_inet.c:798
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xdd/0x130 net/socket.c:661
 sock_write_iter+0x27c/0x3e0 net/socket.c:988
 call_write_iter include/linux/fs.h:1866 [inline]
 new_sync_write+0x4c7/0x760 fs/read_write.c:474
 __vfs_write+0xe4/0x110 fs/read_write.c:487
 vfs_write+0x20c/0x580 fs/read_write.c:549
 ksys_write+0x14f/0x2d0 fs/read_write.c:599
 __do_sys_write fs/read_write.c:611 [inline]
 __se_sys_write fs/read_write.c:608 [inline]
 __x64_sys_write+0x73/0xb0 fs/read_write.c:608
 do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x458c29
Code: ad b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f293b44bc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000458c29
RDX: 0000000000000014 RSI: 00000000200002c0 RDI: 0000000000000003
RBP: 000000000073bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f293b44c6d4
R13: 00000000004c8623 R14: 00000000004ded68 R15: 00000000ffffffff

The buggy address belongs to the page:
page:ffffea00025aafc0 count:0 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0x1fffc0000000000()
raw: 01fffc0000000000 0000000000000000 ffffffff025a0101 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888096abef80: 00 00 00 f2 f2 f2 f2 f2 00 00 00 00 00 00 00 f2
 ffff888096abf000: f2 f2 f2 f2 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888096abf080: 00 00 f3 f3 f3 f3 00 00 00 00 00 00 00 00 00 00
                         ^
 ffff888096abf100: 00 00 00 00 f1 f1 f1 f1 00 00 f3 f3 00 00 00 00
 ffff888096abf180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

Fixes: ed0de45a1008 ("ipv4: recompile ip options in ipv4_link_failure")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Stephen Suryaputra <ssuryaextr@gmail.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |   34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1183,25 +1183,39 @@ static struct dst_entry *ipv4_dst_check(
 	return dst;
 }
 
-static void ipv4_link_failure(struct sk_buff *skb)
+static void ipv4_send_dest_unreach(struct sk_buff *skb)
 {
 	struct ip_options opt;
-	struct rtable *rt;
 	int res;
 
 	/* Recompile ip options since IPCB may not be valid anymore.
+	 * Also check we have a reasonable ipv4 header.
 	 */
-	memset(&opt, 0, sizeof(opt));
-	opt.optlen = ip_hdr(skb)->ihl*4 - sizeof(struct iphdr);
-
-	rcu_read_lock();
-	res = __ip_options_compile(dev_net(skb->dev), &opt, skb, NULL);
-	rcu_read_unlock();
-
-	if (res)
+	if (!pskb_network_may_pull(skb, sizeof(struct iphdr)) ||
+	    ip_hdr(skb)->version != 4 || ip_hdr(skb)->ihl < 5)
 		return;
 
+	memset(&opt, 0, sizeof(opt));
+	if (ip_hdr(skb)->ihl > 5) {
+		if (!pskb_network_may_pull(skb, ip_hdr(skb)->ihl * 4))
+			return;
+		opt.optlen = ip_hdr(skb)->ihl * 4 - sizeof(struct iphdr);
+
+		rcu_read_lock();
+		res = __ip_options_compile(dev_net(skb->dev), &opt, skb, NULL);
+		rcu_read_unlock();
+
+		if (res)
+			return;
+	}
 	__icmp_send(skb, ICMP_DEST_UNREACH, ICMP_HOST_UNREACH, 0, &opt);
+}
+
+static void ipv4_link_failure(struct sk_buff *skb)
+{
+	struct rtable *rt;
+
+	ipv4_send_dest_unreach(skb);
 
 	rt = skb_rtable(skb);
 	if (rt)


