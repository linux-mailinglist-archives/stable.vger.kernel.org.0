Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63EB81236DD
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfLQUQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:16:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:40640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727241AbfLQUQ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:16:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0A5521775;
        Tue, 17 Dec 2019 20:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576613787;
        bh=FkhkgZ/WTDLVDYpriaY8Jjlr11qzvYJdYxfreFJq73s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WP1gR630yS5gBHNvDr1RO5SRh7bi1hEwOvmn7NvWfHjvpu67HAEC1aSYUXzFi45wZ
         mbjmUjdPeFrnnmO+8dPhrUzfOgi9lJTHSc4qvOlu3evoxthE8bbKOY9kebwNsJVxL0
         qcGZsgIdRd6Pearlqf9IvmJBIaUB+9Gzd2tjGwq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 01/25] inet: protect against too small mtu values.
Date:   Tue, 17 Dec 2019 21:16:00 +0100
Message-Id: <20191217200903.723962970@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217200903.179327435@linuxfoundation.org>
References: <20191217200903.179327435@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 501a90c945103e8627406763dac418f20f3837b2 ]

syzbot was once again able to crash a host by setting a very small mtu
on loopback device.

Let's make inetdev_valid_mtu() available in include/net/ip.h,
and use it in ip_setup_cork(), so that we protect both ip_append_page()
and __ip_append_data()

Also add a READ_ONCE() when the device mtu is read.

Pairs this lockless read with one WRITE_ONCE() in __dev_set_mtu(),
even if other code paths might write over this field.

Add a big comment in include/linux/netdevice.h about dev->mtu
needing READ_ONCE()/WRITE_ONCE() annotations.

Hopefully we will add the missing ones in followup patches.

[1]

refcount_t: saturated; leaking memory.
WARNING: CPU: 0 PID: 9464 at lib/refcount.c:22 refcount_warn_saturate+0x138/0x1f0 lib/refcount.c:22
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 9464 Comm: syz-executor850 Not tainted 5.4.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x3e kernel/panic.c:582
 report_bug+0x289/0x300 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 fixup_bug arch/x86/kernel/traps.c:169 [inline]
 do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
 do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:refcount_warn_saturate+0x138/0x1f0 lib/refcount.c:22
Code: 06 31 ff 89 de e8 c8 f5 e6 fd 84 db 0f 85 6f ff ff ff e8 7b f4 e6 fd 48 c7 c7 e0 71 4f 88 c6 05 56 a6 a4 06 01 e8 c7 a8 b7 fd <0f> 0b e9 50 ff ff ff e8 5c f4 e6 fd 0f b6 1d 3d a6 a4 06 31 ff 89
RSP: 0018:ffff88809689f550 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815e4336 RDI: ffffed1012d13e9c
RBP: ffff88809689f560 R08: ffff88809c50a3c0 R09: fffffbfff15d31b1
R10: fffffbfff15d31b0 R11: ffffffff8ae98d87 R12: 0000000000000001
R13: 0000000000040100 R14: ffff888099041104 R15: ffff888218d96e40
 refcount_add include/linux/refcount.h:193 [inline]
 skb_set_owner_w+0x2b6/0x410 net/core/sock.c:1999
 sock_wmalloc+0xf1/0x120 net/core/sock.c:2096
 ip_append_page+0x7ef/0x1190 net/ipv4/ip_output.c:1383
 udp_sendpage+0x1c7/0x480 net/ipv4/udp.c:1276
 inet_sendpage+0xdb/0x150 net/ipv4/af_inet.c:821
 kernel_sendpage+0x92/0xf0 net/socket.c:3794
 sock_sendpage+0x8b/0xc0 net/socket.c:936
 pipe_to_sendpage+0x2da/0x3c0 fs/splice.c:458
 splice_from_pipe_feed fs/splice.c:512 [inline]
 __splice_from_pipe+0x3ee/0x7c0 fs/splice.c:636
 splice_from_pipe+0x108/0x170 fs/splice.c:671
 generic_splice_sendpage+0x3c/0x50 fs/splice.c:842
 do_splice_from fs/splice.c:861 [inline]
 direct_splice_actor+0x123/0x190 fs/splice.c:1035
 splice_direct_to_actor+0x3b4/0xa30 fs/splice.c:990
 do_splice_direct+0x1da/0x2a0 fs/splice.c:1078
 do_sendfile+0x597/0xd00 fs/read_write.c:1464
 __do_sys_sendfile64 fs/read_write.c:1525 [inline]
 __se_sys_sendfile64 fs/read_write.c:1511 [inline]
 __x64_sys_sendfile64+0x1dd/0x220 fs/read_write.c:1511
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441409
Code: e8 ac e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 eb 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fffb64c4f78 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441409
RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000000000005
RBP: 0000000000073b8a R08: 0000000000000010 R09: 0000000000000010
R10: 0000000000010001 R11: 0000000000000246 R12: 0000000000402180
R13: 0000000000402210 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..

Fixes: 1470ddf7f8ce ("inet: Remove explicit write references to sk/inet in ip_append_data")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h |    5 +++++
 include/net/ip.h          |    5 +++++
 net/core/dev.c            |    3 ++-
 net/ipv4/devinet.c        |    5 -----
 net/ipv4/ip_output.c      |   13 ++++++++-----
 5 files changed, 20 insertions(+), 11 deletions(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1848,6 +1848,11 @@ struct net_device {
 	unsigned char		if_port;
 	unsigned char		dma;
 
+	/* Note : dev->mtu is often read without holding a lock.
+	 * Writers usually hold RTNL.
+	 * It is recommended to use READ_ONCE() to annotate the reads,
+	 * and to use WRITE_ONCE() to annotate the writes.
+	 */
 	unsigned int		mtu;
 	unsigned int		min_mtu;
 	unsigned int		max_mtu;
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -759,4 +759,9 @@ int ip_misc_proc_init(void);
 int rtm_getroute_parse_ip_proto(struct nlattr *attr, u8 *ip_proto, u8 family,
 				struct netlink_ext_ack *extack);
 
+static inline bool inetdev_valid_mtu(unsigned int mtu)
+{
+	return likely(mtu >= IPV4_MIN_MTU);
+}
+
 #endif	/* _IP_H */
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7662,7 +7662,8 @@ int __dev_set_mtu(struct net_device *dev
 	if (ops->ndo_change_mtu)
 		return ops->ndo_change_mtu(dev, new_mtu);
 
-	dev->mtu = new_mtu;
+	/* Pairs with all the lockless reads of dev->mtu in the stack */
+	WRITE_ONCE(dev->mtu, new_mtu);
 	return 0;
 }
 EXPORT_SYMBOL(__dev_set_mtu);
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1496,11 +1496,6 @@ skip:
 	}
 }
 
-static bool inetdev_valid_mtu(unsigned int mtu)
-{
-	return mtu >= IPV4_MIN_MTU;
-}
-
 static void inetdev_send_gratuitous_arp(struct net_device *dev,
 					struct in_device *in_dev)
 
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1258,15 +1258,18 @@ static int ip_setup_cork(struct sock *sk
 		cork->addr = ipc->addr;
 	}
 
-	/*
-	 * We steal reference to this route, caller should not release it
-	 */
-	*rtp = NULL;
 	cork->fragsize = ip_sk_use_pmtu(sk) ?
-			 dst_mtu(&rt->dst) : rt->dst.dev->mtu;
+			 dst_mtu(&rt->dst) : READ_ONCE(rt->dst.dev->mtu);
+
+	if (!inetdev_valid_mtu(cork->fragsize))
+		return -ENETUNREACH;
 
 	cork->gso_size = ipc->gso_size;
+
 	cork->dst = &rt->dst;
+	/* We stole this route, caller should not release it. */
+	*rtp = NULL;
+
 	cork->length = 0;
 	cork->ttl = ipc->ttl;
 	cork->tos = ipc->tos;


