Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D103F6612
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239353AbhHXRUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:20:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239992AbhHXRRy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:17:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AAC461ACE;
        Tue, 24 Aug 2021 17:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824528;
        bh=gb7Nvc8Im0E5aFct/Z0fYBsXJbPibN7/NUOSq3w3Y4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gnHbXAfePVcLr59kQC2LjVG6u+EPdljV6gncK27fYPCesBLjHnIEI5N23ibjp4FNC
         0yPZ009u1ApXpgf7dvTq3AH2e3Oq8YAy5Uxobljjhs47M+U+6VmuSNkxImypPv5vQy
         id5VOJMIovjEXQF6H3hx/tEAfBRHd3v+9iT2tz0eV437ch1638Wg96IfJl1sPg4XF0
         Bse3bJFe+gyY/Jd1JSM9nsEeX1U2C8v26ze4VBPo3m1dXS9467x5EFMifRlv1DWQq/
         G4ybByEzHGqcZ6D4sJHWhtvqI+L30CRPkiu7zjjG+/oau24wU33ytbZ3pRpsRY/FTk
         wqb1dkYzTJ2Iw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Marinkevich <sergey.marinkevich@eltex-co.ru>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 60/61] netfilter: nft_exthdr: fix endianness of tcp option cast
Date:   Tue, 24 Aug 2021 13:01:05 -0400
Message-Id: <20210824170106.710221-61-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
References: <20210824170106.710221-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.143-rc1
X-KernelTest-Deadline: 2021-08-26T17:01+00:00
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
index 00f4323cfeb8..faa0844c01fb 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -231,7 +231,6 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 	unsigned int i, optl, tcphdr_len, offset;
 	struct tcphdr *tcph;
 	u8 *opt;
-	u32 src;
 
 	tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff, &tcphdr_len);
 	if (!tcph)
@@ -240,7 +239,6 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 	opt = (u8 *)tcph;
 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
 		union {
-			u8 octet;
 			__be16 v16;
 			__be32 v32;
 		} old, new;
@@ -262,13 +260,13 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
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
@@ -286,7 +284,7 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 						 old.v16, new.v16, false);
 			break;
 		case 4:
-			new.v32 = src;
+			new.v32 = regs->data[priv->sreg];
 			old.v32 = get_unaligned((u32 *)(opt + offset));
 
 			if (old.v32 == new.v32)
-- 
2.30.2

