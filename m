Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43D0D177EA7
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgCCRpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:45:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:51176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730886AbgCCRpO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:45:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 582B020870;
        Tue,  3 Mar 2020 17:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257513;
        bh=SrmmSz4itM+cotM5mCLw5iWToKeU8vurv69OY/Ze4FU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V9udS5eI1WHnPOAZzfwsGsB+BflDKJrSDmBblXumBIHOh5V3UYq5se5H+nnoYVflL
         S3B5tYwM10x/0UwfACoVuLw/qXve+uaIqPDtVxuGwz9sKLdxoYEmE3wA5igILv4mjU
         in71tPDgGdkMeKYNmXeMdlfDy8OXq+wEAW6Lm0As=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@mellanox.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 024/176] net: rtnetlink: fix bugs in rtnl_alt_ifname()
Date:   Tue,  3 Mar 2020 18:41:28 +0100
Message-Id: <20200303174307.342278979@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 44bfa9c5e5f06c72540273813e4c66beb5a8c213 ]

Since IFLA_ALT_IFNAME is an NLA_STRING, we have no
guarantee it is nul terminated.

We should use nla_strdup() instead of kstrdup(), since this
helper will make sure not accessing out-of-bounds data.

BUG: KMSAN: uninit-value in strlen+0x5e/0xa0 lib/string.c:535
CPU: 1 PID: 19157 Comm: syz-executor.5 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 strlen+0x5e/0xa0 lib/string.c:535
 kstrdup+0x7f/0x1a0 mm/util.c:59
 rtnl_alt_ifname net/core/rtnetlink.c:3495 [inline]
 rtnl_linkprop+0x85d/0xc00 net/core/rtnetlink.c:3553
 rtnl_newlinkprop+0x9d/0xb0 net/core/rtnetlink.c:3568
 rtnetlink_rcv_msg+0x1153/0x1570 net/core/rtnetlink.c:5424
 netlink_rcv_skb+0x451/0x650 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x50/0x60 net/core/rtnetlink.c:5442
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0xf9e/0x1100 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x1248/0x14d0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg net/socket.c:659 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2330
 ___sys_sendmsg net/socket.c:2384 [inline]
 __sys_sendmsg+0x451/0x5f0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2424
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2424
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45b3b9
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ff1c7b1ac78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ff1c7b1b6d4 RCX: 000000000045b3b9
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000009cb R14: 00000000004cb3dd R15: 000000000075bf2c

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:82
 slab_alloc_node mm/slub.c:2774 [inline]
 __kmalloc_node_track_caller+0xb40/0x1200 mm/slub.c:4382
 __kmalloc_reserve net/core/skbuff.c:141 [inline]
 __alloc_skb+0x2fd/0xac0 net/core/skbuff.c:209
 alloc_skb include/linux/skbuff.h:1049 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1174 [inline]
 netlink_sendmsg+0x7d3/0x14d0 net/netlink/af_netlink.c:1892
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg net/socket.c:659 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2330
 ___sys_sendmsg net/socket.c:2384 [inline]
 __sys_sendmsg+0x451/0x5f0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2424
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2424
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 36fbf1e52bd3 ("net: rtnetlink: add linkprop commands to add and delete alternative ifnames")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jiri Pirko <jiri@mellanox.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/rtnetlink.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3499,27 +3499,25 @@ static int rtnl_alt_ifname(int cmd, stru
 	if (err)
 		return err;
 
-	alt_ifname = nla_data(attr);
+	alt_ifname = nla_strdup(attr, GFP_KERNEL);
+	if (!alt_ifname)
+		return -ENOMEM;
+
 	if (cmd == RTM_NEWLINKPROP) {
-		alt_ifname = kstrdup(alt_ifname, GFP_KERNEL);
-		if (!alt_ifname)
-			return -ENOMEM;
 		err = netdev_name_node_alt_create(dev, alt_ifname);
-		if (err) {
-			kfree(alt_ifname);
-			return err;
-		}
+		if (!err)
+			alt_ifname = NULL;
 	} else if (cmd == RTM_DELLINKPROP) {
 		err = netdev_name_node_alt_destroy(dev, alt_ifname);
-		if (err)
-			return err;
 	} else {
-		WARN_ON(1);
-		return 0;
+		WARN_ON_ONCE(1);
+		err = -EINVAL;
 	}
 
-	*changed = true;
-	return 0;
+	kfree(alt_ifname);
+	if (!err)
+		*changed = true;
+	return err;
 }
 
 static int rtnl_linkprop(int cmd, struct sk_buff *skb, struct nlmsghdr *nlh,


