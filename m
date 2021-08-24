Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFF23F66D5
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236251AbhHXR2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:28:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240592AbhHXR0C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:26:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB03D613AD;
        Tue, 24 Aug 2021 17:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824651;
        bh=iauMXiN2QXGlJCo8KiLq0bBjy3KVosZgnepAHACd2GY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e0YDMKmwJc33a2YlacsLAvy4gRa9Rryjg6WCVs8/MV0Bt9q0eQwkCUgtcKnMaylsa
         pgphQTJJYnSkSlq2sdglm4vwPk1/517vwZci+30dZbbCAgIC6HW7yWKkS8yZCsXbqb
         oMiMDm+ozLOFPkQwrAxU499imfYf5E16Ep685Ed2ncibukLoYicPoDyjX+qctE6G86
         boUzLyvZJ4ERRdRzc7qM8j95lWf0obFVAYuMEfHzzpjLmiPhknVT2/FEbmpkZ50H/a
         gDO1W8Jxyv0bkRvSOfA3zHvxK/4j9htBE6ul6b+J86z9ZI/eKhjYJ2LX2AtzNI+QCM
         LMxerMBhs+ssw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Marinkevich <sergey.marinkevich@eltex-co.ru>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 83/84] netfilter: nft_exthdr: fix endianness of tcp option cast
Date:   Tue, 24 Aug 2021 13:02:49 -0400
Message-Id: <20210824170250.710392-84-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Marinkevich <sergey.marinkevich@eltex-co.ru>

[ Upstream commit 2e34328b396a69b73661ba38d47d92b7cf21c2c4 ]

I got a problem on MIPS with Big-Endian is turned on: every time when
NF trying to change TCP MSS it returns because of new.v16 was greater
than old.v16. But real MSS was 1460 and my rule was like this:

	add rule table chain tcp option maxseg size set 1400

And 1400 is lesser that 1460, not greater.

Later I founded that main causer is cast from u32 to __be16.

Debugging:

In example MSS = 1400(HEX: 0x578). Here is representation of each byte
like it is in memory by addresses from left to right(e.g. [0x0 0x1 0x2
0x3]). LE — Little-Endian system, BE — Big-Endian, left column is type.

	     LE               BE
	u32: [78 05 00 00]    [00 00 05 78]

As you can see, u32 representation will be casted to u16 from different
half of 4-byte address range. But actually nf_tables uses registers and
store data of various size. Actually TCP MSS stored in 2 bytes. But
registers are still u32 in definition:

	struct nft_regs {
		union {
			u32			data[20];
			struct nft_verdict	verdict;
		};
	};

So, access like regs->data[priv->sreg] exactly u32. So, according to
table presents above, per-byte representation of stored TCP MSS in
register will be:

	                     LE               BE
	(u32)regs->data[]:   [78 05 00 00]    [05 78 00 00]
	                                       ^^ ^^

We see that register uses just half of u32 and other 2 bytes may be
used for some another data. But in nft_exthdr_tcp_set_eval() it casted
just like u32 -> __be16:

	new.v16 = src

But u32 overfill __be16, so it get 2 low bytes. For clarity draw
one more table(<xx xx> means that bytes will be used for cast).

	                     LE                 BE
	u32:                 [<78 05> 00 00]    [00 00 <05 78>]
	(u32)regs->data[]:   [<78 05> 00 00]    [05 78 <00 00>]

As you can see, for Little-Endian nothing changes, but for Big-endian we
take the wrong half. In my case there is some other data instead of
zeros, so new MSS was wrongly greater.

For shooting this bug I used solution for ports ranges. Applying of this
patch does not affect Little-Endian systems.

Signed-off-by: Sergey Marinkevich <sergey.marinkevich@eltex-co.ru>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_exthdr.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 64e69d6683ca..93fee4106019 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -137,7 +137,6 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 	unsigned int i, optl, tcphdr_len, offset;
 	struct tcphdr *tcph;
 	u8 *opt;
-	u32 src;
 
 	tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff, &tcphdr_len);
 	if (!tcph)
@@ -146,7 +145,6 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 	opt = (u8 *)tcph;
 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
 		union {
-			u8 octet;
 			__be16 v16;
 			__be32 v32;
 		} old, new;
@@ -167,13 +165,13 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 		if (!tcph)
 			return;
 
-		src = regs->data[priv->sreg];
 		offset = i + priv->offset;
 
 		switch (priv->len) {
 		case 2:
 			old.v16 = get_unaligned((u16 *)(opt + offset));
-			new.v16 = src;
+			new.v16 = (__force __be16)nft_reg_load16(
+				&regs->data[priv->sreg]);
 
 			switch (priv->type) {
 			case TCPOPT_MSS:
@@ -191,7 +189,7 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 						 old.v16, new.v16, false);
 			break;
 		case 4:
-			new.v32 = src;
+			new.v32 = regs->data[priv->sreg];
 			old.v32 = get_unaligned((u32 *)(opt + offset));
 
 			if (old.v32 == new.v32)
-- 
2.30.2

