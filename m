Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E763FDB40
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344176AbhIAMkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:40:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245691AbhIAMhx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:37:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F05EF6113D;
        Wed,  1 Sep 2021 12:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499662;
        bh=p7UtEXnDzeICHHCrbJzo0vhGMNCeEPqeo8eCNoNmNiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nPZ2gfYZ4IWFjLPkCvmjXyd3UqocdfX3dl/Pbmmrk1hzFVbZIx+vbcBEzj9BYxeYz
         ZnoRW6SWzJ/lauf3G30uSIYddshV7+FfTntZbwCpU1m25XNM9q9zQEaXq2ah+0bM0V
         ucJb4TKH3eb5svj9tbQGGu6Xoc218Z+85OsCQyg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Keyu Man <kman001@ucr.edu>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/103] ipv6: use siphash in rt6_exception_hash()
Date:   Wed,  1 Sep 2021 14:27:48 +0200
Message-Id: <20210901122301.844223210@linuxfoundation.org>
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

[ Upstream commit 4785305c05b25a242e5314cc821f54ade4c18810 ]

A group of security researchers brought to our attention
the weakness of hash function used in rt6_exception_hash()

Lets use siphash instead of Jenkins Hash, to considerably
reduce security risks.

Following patch deals with IPv4.

Fixes: 35732d01fe31 ("ipv6: introduce a hash table to store dst cache")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Keyu Man <kman001@ucr.edu>
Cc: Wei Wang <weiwan@google.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Acked-by: Wei Wang <weiwan@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 62db3c98424b..bcf4fae83a9b 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -41,6 +41,7 @@
 #include <linux/nsproxy.h>
 #include <linux/slab.h>
 #include <linux/jhash.h>
+#include <linux/siphash.h>
 #include <net/net_namespace.h>
 #include <net/snmp.h>
 #include <net/ipv6.h>
@@ -1482,17 +1483,24 @@ static void rt6_exception_remove_oldest(struct rt6_exception_bucket *bucket)
 static u32 rt6_exception_hash(const struct in6_addr *dst,
 			      const struct in6_addr *src)
 {
-	static u32 seed __read_mostly;
-	u32 val;
+	static siphash_key_t rt6_exception_key __read_mostly;
+	struct {
+		struct in6_addr dst;
+		struct in6_addr src;
+	} __aligned(SIPHASH_ALIGNMENT) combined = {
+		.dst = *dst,
+	};
+	u64 val;
 
-	net_get_random_once(&seed, sizeof(seed));
-	val = jhash2((const u32 *)dst, sizeof(*dst)/sizeof(u32), seed);
+	net_get_random_once(&rt6_exception_key, sizeof(rt6_exception_key));
 
 #ifdef CONFIG_IPV6_SUBTREES
 	if (src)
-		val = jhash2((const u32 *)src, sizeof(*src)/sizeof(u32), val);
+		combined.src = *src;
 #endif
-	return hash_32(val, FIB6_EXCEPTION_BUCKET_SIZE_SHIFT);
+	val = siphash(&combined, sizeof(combined), &rt6_exception_key);
+
+	return hash_64(val, FIB6_EXCEPTION_BUCKET_SIZE_SHIFT);
 }
 
 /* Helper function to find the cached rt in the hash table
-- 
2.30.2



