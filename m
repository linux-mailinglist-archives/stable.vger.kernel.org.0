Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2383834C89D
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233528AbhC2IXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:23:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233641AbhC2IWC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:22:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 783F661554;
        Mon, 29 Mar 2021 08:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006112;
        bh=eJhow2aP8frR5raHpDke8z2xQSi9zRhdkkcFupAdxFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ok58Y9wXiNeKcpFNNFvHHxQ9FuOPN5xXLNVOTKzc8UZhyGAfER8jFcfT+YMTOAR+7
         vPGwf6cxkAA3PrrAyBQpmrGldlHRH7ZnLyBTFV8pdjtPlYWJglYF2bAw+9c63JfFKF
         JVs+TiZwXVoHCeJIyvgNZl3EBrKmjxDFrVcX85ck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Tuong Lien <tuong.t.lien@dektech.com.au>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/221] tipc: better validate user input in tipc_nl_retrieve_key()
Date:   Mon, 29 Mar 2021 09:57:33 +0200
Message-Id: <20210329075633.287856111@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0217ed2848e8538bcf9172d97ed2eeb4a26041bb ]

Before calling tipc_aead_key_size(ptr), we need to ensure
we have enough data to dereference ptr->keylen.

We probably also want to make sure tipc_aead_key_size()
wont overflow with malicious ptr->keylen values.

Syzbot reported:

BUG: KMSAN: uninit-value in __tipc_nl_node_set_key net/tipc/node.c:2971 [inline]
BUG: KMSAN: uninit-value in tipc_nl_node_set_key+0x9bf/0x13b0 net/tipc/node.c:3023
CPU: 0 PID: 21060 Comm: syz-executor.5 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 __tipc_nl_node_set_key net/tipc/node.c:2971 [inline]
 tipc_nl_node_set_key+0x9bf/0x13b0 net/tipc/node.c:3023
 genl_family_rcv_msg_doit net/netlink/genetlink.c:739 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x1319/0x1610 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x6fa/0x810 net/netlink/af_netlink.c:2494
 genl_rcv+0x63/0x80 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x11d6/0x14a0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x1740/0x1840 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2345
 ___sys_sendmsg net/socket.c:2399 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2432
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg+0xa7/0xc0 net/compat.c:351
 __ia32_compat_sys_sendmsg+0x4a/0x70 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:79 [inline]
 __do_fast_syscall_32+0x102/0x160 arch/x86/entry/common.c:141
 do_fast_syscall_32+0x6a/0xc0 arch/x86/entry/common.c:166
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:209
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f60549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f555a5fc EFLAGS: 00000296 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000020000200
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1176 [inline]
 netlink_sendmsg+0xdbc/0x1840 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2345
 ___sys_sendmsg net/socket.c:2399 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2432
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg+0xa7/0xc0 net/compat.c:351
 __ia32_compat_sys_sendmsg+0x4a/0x70 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:79 [inline]
 __do_fast_syscall_32+0x102/0x160 arch/x86/entry/common.c:141
 do_fast_syscall_32+0x6a/0xc0 arch/x86/entry/common.c:166
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:209
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

Fixes: e1f32190cf7d ("tipc: add support for AEAD key setting via netlink")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Tuong Lien <tuong.t.lien@dektech.com.au>
Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/node.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index 83978d5dae59..e4452d55851f 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -2855,17 +2855,22 @@ int tipc_nl_node_dump_monitor_peer(struct sk_buff *skb,
 
 #ifdef CONFIG_TIPC_CRYPTO
 static int tipc_nl_retrieve_key(struct nlattr **attrs,
-				struct tipc_aead_key **key)
+				struct tipc_aead_key **pkey)
 {
 	struct nlattr *attr = attrs[TIPC_NLA_NODE_KEY];
+	struct tipc_aead_key *key;
 
 	if (!attr)
 		return -ENODATA;
 
-	*key = (struct tipc_aead_key *)nla_data(attr);
-	if (nla_len(attr) < tipc_aead_key_size(*key))
+	if (nla_len(attr) < sizeof(*key))
+		return -EINVAL;
+	key = (struct tipc_aead_key *)nla_data(attr);
+	if (key->keylen > TIPC_AEAD_KEYLEN_MAX ||
+	    nla_len(attr) < tipc_aead_key_size(key))
 		return -EINVAL;
 
+	*pkey = key;
 	return 0;
 }
 
-- 
2.30.1



