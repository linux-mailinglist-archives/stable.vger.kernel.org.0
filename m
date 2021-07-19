Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CBC3CD9F7
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244960AbhGSOcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:32:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243863AbhGSOah (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:30:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D6F261002;
        Mon, 19 Jul 2021 15:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707475;
        bh=1N49bbMHVi60qH2SwZUdfq5ibqi1/BbLdVyMTBqsI3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cotOvtHijtAkwpGlkjIJtB/qgdnO+MvZPyOYB4BWf1fGNneK06lZ/uqmZvXATrvm8
         B5iJ4N35nZpaLMxj6AnPdA1FEMnh3Gsc1JKHjwyu4oVXOltC6MZIKk2CDjB7VOMz9j
         Tv4tSBjeG/8gTlahgzcykNfleKjKoqoP5c9/Pt80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Klein <aksecurity@gmail.com>,
        Willy Tarreau <w@1wt.eu>, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 135/245] ipv6: use prandom_u32() for ID generation
Date:   Mon, 19 Jul 2021 16:51:17 +0200
Message-Id: <20210719144944.771560634@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

[ Upstream commit 62f20e068ccc50d6ab66fdb72ba90da2b9418c99 ]

This is a complement to commit aa6dd211e4b1 ("inet: use bigger hash
table for IP ID generation"), but focusing on some specific aspects
of IPv6.

Contary to IPv4, IPv6 only uses packet IDs with fragments, and with a
minimum MTU of 1280, it's much less easy to force a remote peer to
produce many fragments to explore its ID sequence. In addition packet
IDs are 32-bit in IPv6, which further complicates their analysis. On
the other hand, it is often easier to choose among plenty of possible
source addresses and partially work around the bigger hash table the
commit above permits, which leaves IPv6 partially exposed to some
possibilities of remote analysis at the risk of weakening some
protocols like DNS if some IDs can be predicted with a good enough
probability.

Given the wide range of permitted IDs, the risk of collision is extremely
low so there's no need to rely on the positive increment algorithm that
is shared with the IPv4 code via ip_idents_reserve(). We have a fast
PRNG, so let's simply call prandom_u32() and be done with it.

Performance measurements at 10 Gbps couldn't show any difference with
the previous code, even when using a single core, because due to the
large fragments, we're limited to only ~930 kpps at 10 Gbps and the cost
of the random generation is completely offset by other operations and by
the network transfer time. In addition, this change removes the need to
update a shared entry in the idents table so it may even end up being
slightly faster on large scale systems where this matters.

The risk of at least one collision here is about 1/80 million among
10 IDs, 1/850k among 100 IDs, and still only 1/8.5k among 1000 IDs,
which remains very low compared to IPv4 where all IDs are reused
every 4 to 80ms on a 10 Gbps flow depending on packet sizes.

Reported-by: Amit Klein <aksecurity@gmail.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20210529110746.6796-1-w@1wt.eu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/output_core.c | 28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff --git a/net/ipv6/output_core.c b/net/ipv6/output_core.c
index 6a6d01cb1ace..9c25e8b09306 100644
--- a/net/ipv6/output_core.c
+++ b/net/ipv6/output_core.c
@@ -14,29 +14,11 @@ static u32 __ipv6_select_ident(struct net *net,
 			       const struct in6_addr *dst,
 			       const struct in6_addr *src)
 {
-	const struct {
-		struct in6_addr dst;
-		struct in6_addr src;
-	} __aligned(SIPHASH_ALIGNMENT) combined = {
-		.dst = *dst,
-		.src = *src,
-	};
-	u32 hash, id;
-
-	/* Note the following code is not safe, but this is okay. */
-	if (unlikely(siphash_key_is_zero(&net->ipv4.ip_id_key)))
-		get_random_bytes(&net->ipv4.ip_id_key,
-				 sizeof(net->ipv4.ip_id_key));
-
-	hash = siphash(&combined, sizeof(combined), &net->ipv4.ip_id_key);
-
-	/* Treat id of 0 as unset and if we get 0 back from ip_idents_reserve,
-	 * set the hight order instead thus minimizing possible future
-	 * collisions.
-	 */
-	id = ip_idents_reserve(hash, 1);
-	if (unlikely(!id))
-		id = 1 << 31;
+	u32 id;
+
+	do {
+		id = prandom_u32();
+	} while (!id);
 
 	return id;
 }
-- 
2.30.2



