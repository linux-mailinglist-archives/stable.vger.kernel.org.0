Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D01336AE25
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbhDZHls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233401AbhDZHj1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:39:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6E50613B4;
        Mon, 26 Apr 2021 07:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422648;
        bh=/8UoeH+MZy6H1J45Kd5YEoVeCuR1QdR21CuuMzDvqCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=utsqu87O1niAZE2zdDIeRkspo6oVARKFKeLND/1kootW79Nmua+zw2M9Zd8ttQGNV
         W4gMNLFse86pchFlOYEaMbSoFpTOXmwWsWE5an+cLZI3YXaAAc6SCiT4ST3g1eQMpG
         kJu/UIoIqfZrBMxX4bl7SosYJj3d8YaoslpWAf1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Luigi Rizzo <lrizzo@google.com>
Subject: [PATCH 4.19 32/57] netfilter: nft_limit: avoid possible divide error in nft_limit_init
Date:   Mon, 26 Apr 2021 09:29:29 +0200
Message-Id: <20210426072821.672101571@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072820.568997499@linuxfoundation.org>
References: <20210426072820.568997499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit b895bdf5d643b6feb7c60856326dd4feb6981560 upstream.

div_u64() divides u64 by u32.

nft_limit_init() wants to divide u64 by u64, use the appropriate
math function (div64_u64)

divide error: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8390 Comm: syz-executor188 Not tainted 5.12.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:div_u64_rem include/linux/math64.h:28 [inline]
RIP: 0010:div_u64 include/linux/math64.h:127 [inline]
RIP: 0010:nft_limit_init+0x2a2/0x5e0 net/netfilter/nft_limit.c:85
Code: ef 4c 01 eb 41 0f 92 c7 48 89 de e8 38 a5 22 fa 4d 85 ff 0f 85 97 02 00 00 e8 ea 9e 22 fa 4c 0f af f3 45 89 ed 31 d2 4c 89 f0 <49> f7 f5 49 89 c6 e8 d3 9e 22 fa 48 8d 7d 48 48 b8 00 00 00 00 00
RSP: 0018:ffffc90009447198 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000200000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff875152e6 RDI: 0000000000000003
RBP: ffff888020f80908 R08: 0000200000000000 R09: 0000000000000000
R10: ffffffff875152d8 R11: 0000000000000000 R12: ffffc90009447270
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  000000000097a300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200001c4 CR3: 0000000026a52000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 nf_tables_newexpr net/netfilter/nf_tables_api.c:2675 [inline]
 nft_expr_init+0x145/0x2d0 net/netfilter/nf_tables_api.c:2713
 nft_set_elem_expr_alloc+0x27/0x280 net/netfilter/nf_tables_api.c:5160
 nf_tables_newset+0x1997/0x3150 net/netfilter/nf_tables_api.c:4321
 nfnetlink_rcv_batch+0x85a/0x21b0 net/netfilter/nfnetlink.c:456
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:580 [inline]
 nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:598
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: c26844eda9d4 ("netfilter: nf_tables: Fix nft limit burst handling")
Fixes: 3e0f64b7dd31 ("netfilter: nft_limit: fix packet ratelimiting")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Diagnosed-by: Luigi Rizzo <lrizzo@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_limit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -79,13 +79,13 @@ static int nft_limit_init(struct nft_lim
 		return -EOVERFLOW;
 
 	if (pkts) {
-		tokens = div_u64(limit->nsecs, limit->rate) * limit->burst;
+		tokens = div64_u64(limit->nsecs, limit->rate) * limit->burst;
 	} else {
 		/* The token bucket size limits the number of tokens can be
 		 * accumulated. tokens_max specifies the bucket size.
 		 * tokens_max = unit * (rate + burst) / rate.
 		 */
-		tokens = div_u64(limit->nsecs * (limit->rate + limit->burst),
+		tokens = div64_u64(limit->nsecs * (limit->rate + limit->burst),
 				 limit->rate);
 	}
 


