Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0B938A4F5
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235452AbhETKK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:10:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235824AbhETKJ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:09:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B34C76194F;
        Thu, 20 May 2021 09:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503747;
        bh=E778L534wD3KUAmC2pqfT/0eSct3f2+T/4smWnjQ4jU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XdfWqhkIJn7PCBOhgwzK3GpdXAOqR01z+TbSjQGuobSfnYToghCIgfjnyzZhYhNlv
         miSDMZUKDa+zqtRpVHW95JY4k9kLdqMxmqBMKIql0DRRpqwX33A269GNt+CJZp3h6X
         QGWCT97o+PModfBgoS+JxoXVxcIoCJZDbUFDfMM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 360/425] netfilter: nftables: avoid overflows in nft_hash_buckets()
Date:   Thu, 20 May 2021 11:22:09 +0200
Message-Id: <20210520092143.235443511@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a54754ec9891830ba548e2010c889e3c8146e449 ]

Number of buckets being stored in 32bit variables, we have to
ensure that no overflows occur in nft_hash_buckets()

syzbot injected a size == 0x40000000 and reported:

UBSAN: shift-out-of-bounds in ./include/linux/log2.h:57:13
shift exponent 64 is too large for 64-bit type 'long unsigned int'
CPU: 1 PID: 29539 Comm: syz-executor.4 Not tainted 5.12.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:327
 __roundup_pow_of_two include/linux/log2.h:57 [inline]
 nft_hash_buckets net/netfilter/nft_set_hash.c:411 [inline]
 nft_hash_estimate.cold+0x19/0x1e net/netfilter/nft_set_hash.c:652
 nft_select_set_ops net/netfilter/nf_tables_api.c:3586 [inline]
 nf_tables_newset+0xe62/0x3110 net/netfilter/nf_tables_api.c:4322
 nfnetlink_rcv_batch+0xa09/0x24b0 net/netfilter/nfnetlink.c:488
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:612 [inline]
 nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:630
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46

Fixes: 0ed6389c483d ("netfilter: nf_tables: rename set implementations")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_hash.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 05118e03c3e4..dbc4ed643b4b 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -392,9 +392,17 @@ static void nft_rhash_destroy(const struct nft_set *set)
 				    (void *)set);
 }
 
+/* Number of buckets is stored in u32, so cap our result to 1U<<31 */
+#define NFT_MAX_BUCKETS (1U << 31)
+
 static u32 nft_hash_buckets(u32 size)
 {
-	return roundup_pow_of_two(size * 4 / 3);
+	u64 val = div_u64((u64)size * 4, 3);
+
+	if (val >= NFT_MAX_BUCKETS)
+		return NFT_MAX_BUCKETS;
+
+	return roundup_pow_of_two(val);
 }
 
 static bool nft_rhash_estimate(const struct nft_set_desc *desc, u32 features,
-- 
2.30.2



