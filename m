Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2ECE3FDB41
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344228AbhIAMkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245698AbhIAMhy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:37:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8050761153;
        Wed,  1 Sep 2021 12:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499665;
        bh=F0MW1db5OjgHtF2kTSOyksu1a1+W3Mq7CZ0qKIUJMMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=khbJXpM5PK7w2h8L/3kqEuFyNSkBipdSysd2kDZuyZL2cAyQpFkOdZWqQ81eCPIa1
         pUzgMo27D9VB0SjAEf97KxzoEOm88K8dYHMUb6WCCa7Ui90u6TmaFIhomdGCVcdbMO
         pHvm9+kUhs7aFwHB+qLBOzHKwIOM3wE14jNdnw/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Keyu Man <kman001@ucr.edu>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/103] ipv4: use siphash instead of Jenkins in fnhe_hashfun()
Date:   Wed,  1 Sep 2021 14:27:49 +0200
Message-Id: <20210901122301.873854687@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 6457378fe796815c973f631a1904e147d6ee33b1 ]

A group of security researchers brought to our attention
the weakness of hash function used in fnhe_hashfun().

Lets use siphash instead of Jenkins Hash, to considerably
reduce security risks.

Also remove the inline keyword, this really is distracting.

Fixes: d546c621542d ("ipv4: harden fnhe_hashfun()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Keyu Man <kman001@ucr.edu>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index e15c1d8b7c8d..3d9946fd41f3 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -624,14 +624,14 @@ static struct fib_nh_exception *fnhe_oldest(struct fnhe_hash_bucket *hash)
 	return oldest;
 }
 
-static inline u32 fnhe_hashfun(__be32 daddr)
+static u32 fnhe_hashfun(__be32 daddr)
 {
-	static u32 fnhe_hashrnd __read_mostly;
-	u32 hval;
+	static siphash_key_t fnhe_hash_key __read_mostly;
+	u64 hval;
 
-	net_get_random_once(&fnhe_hashrnd, sizeof(fnhe_hashrnd));
-	hval = jhash_1word((__force u32)daddr, fnhe_hashrnd);
-	return hash_32(hval, FNHE_HASH_SHIFT);
+	net_get_random_once(&fnhe_hash_key, sizeof(fnhe_hash_key));
+	hval = siphash_1u32((__force u32)daddr, &fnhe_hash_key);
+	return hash_64(hval, FNHE_HASH_SHIFT);
 }
 
 static void fill_route_from_fnhe(struct rtable *rt, struct fib_nh_exception *fnhe)
-- 
2.30.2



