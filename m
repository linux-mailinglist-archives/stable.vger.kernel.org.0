Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 909A62F1437
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732726AbhAKNSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:18:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:37244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727177AbhAKNSv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:18:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E44E92250F;
        Mon, 11 Jan 2021 13:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371090;
        bh=dTw/4c7vdboY41bKzNKv8RRdtWYMYkKxufFm7M1CimA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LtBf1Dck5WOor4nK5R1Bm3m/ZH3si4mBMof8h6Nb6A0DAAKdhfj+CiAIwSx0RqEvj
         eK50xc3R2jc2Sk3W8uWcOStOwPi0cjEZrFUCZ9+xNGck0zbLMozVNbcQNXboIFcOko
         8ug7epVfUaWOIrooqZAWU4F/oqU1ahysLxVuZWZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d66bfadebca46cf61a2b@syzkaller.appspotmail.com,
        Vasily Averin <vvs@virtuozzo.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 138/145] netfilter: ipset: fix shift-out-of-bounds in htable_bits()
Date:   Mon, 11 Jan 2021 14:02:42 +0100
Message-Id: <20210111130055.141286686@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

commit 5c8193f568ae16f3242abad6518dc2ca6c8eef86 upstream.

htable_bits() can call jhash_size(32) and trigger shift-out-of-bounds

UBSAN: shift-out-of-bounds in net/netfilter/ipset/ip_set_hash_gen.h:151:6
shift exponent 32 is too large for 32-bit type 'unsigned int'
CPU: 0 PID: 8498 Comm: syz-executor519
 Not tainted 5.10.0-rc7-next-20201208-syzkaller #0
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
 htable_bits net/netfilter/ipset/ip_set_hash_gen.h:151 [inline]
 hash_mac_create.cold+0x58/0x9b net/netfilter/ipset/ip_set_hash_gen.h:1524
 ip_set_create+0x610/0x1380 net/netfilter/ipset/ip_set_core.c:1115
 nfnetlink_rcv_msg+0xecc/0x1180 net/netfilter/nfnetlink.c:252
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 nfnetlink_rcv+0x1ac/0x420 net/netfilter/nfnetlink.c:600
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x907/0xe40 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2345
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2432
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

This patch replaces htable_bits() by simple fls(hashsize - 1) call:
it alone returns valid nbits both for round and non-round hashsizes.
It is normal to set any nbits here because it is validated inside
following htable_size() call which returns 0 for nbits>31.

Fixes: 1feab10d7e6d("netfilter: ipset: Unified hash type generation")
Reported-by: syzbot+d66bfadebca46cf61a2b@syzkaller.appspotmail.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/ipset/ip_set_hash_gen.h |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -143,20 +143,6 @@ htable_size(u8 hbits)
 	return hsize * sizeof(struct hbucket *) + sizeof(struct htable);
 }
 
-/* Compute htable_bits from the user input parameter hashsize */
-static u8
-htable_bits(u32 hashsize)
-{
-	/* Assume that hashsize == 2^htable_bits */
-	u8 bits = fls(hashsize - 1);
-
-	if (jhash_size(bits) != hashsize)
-		/* Round up to the first 2^n value */
-		bits = fls(hashsize);
-
-	return bits;
-}
-
 #ifdef IP_SET_HASH_WITH_NETS
 #if IPSET_NET_COUNT > 1
 #define __CIDR(cidr, i)		(cidr[i])
@@ -1520,7 +1506,11 @@ IPSET_TOKEN(HTYPE, _create)(struct net *
 	if (!h)
 		return -ENOMEM;
 
-	hbits = htable_bits(hashsize);
+	/* Compute htable_bits from the user input parameter hashsize.
+	 * Assume that hashsize == 2^htable_bits,
+	 * otherwise round up to the first 2^n value.
+	 */
+	hbits = fls(hashsize - 1);
 	hsize = htable_size(hbits);
 	if (hsize == 0) {
 		kfree(h);


