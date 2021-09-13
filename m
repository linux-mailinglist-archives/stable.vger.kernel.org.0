Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE23240903B
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244891AbhIMNu4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:50:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243604AbhIMNsx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:48:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86915615A3;
        Mon, 13 Sep 2021 13:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539980;
        bh=YGuuKEorXXXCOtl6ApTDFfVYenI2YK5ibSFWqQGCn/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q+1K5GJZlr2BLIOjxStZ2cKxr+a2V8dUGSdLmdz6B7bzN5l1lP/JERexAit5ZWo1S
         KU0Mh0WMzadPWggHaZVOHHIkxuCgcaB8fhvLjbG7aPLfvUth0cdLCUEj1TxuzLLwaY
         CZjGjCEoy5+Z/KY08/i10v0PTmi3yYrqVVRcAdHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Keyu Man <kman001@ucr.edu>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 207/236] ipv6: make exception cache less predictible
Date:   Mon, 13 Sep 2021 15:15:12 +0200
Message-Id: <20210913131107.420156415@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a00df2caffed3883c341d5685f830434312e4a43 ]

Even after commit 4785305c05b2 ("ipv6: use siphash in rt6_exception_hash()"),
an attacker can still use brute force to learn some secrets from a victim
linux host.

One way to defeat these attacks is to make the max depth of the hash
table bucket a random value.

Before this patch, each bucket of the hash table used to store exceptions
could contain 6 items under attack.

After the patch, each bucket would contains a random number of items,
between 6 and 10. The attacker can no longer infer secrets.

This is slightly increasing memory size used by the hash table,
we do not expect this to be a problem.

Following patch is dealing with the same issue in IPv4.

Fixes: 35732d01fe31 ("ipv6: introduce a hash table to store dst cache")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Keyu Man <kman001@ucr.edu>
Cc: Wei Wang <weiwan@google.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index bcf4fae83a9b..168a7b4d957a 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1655,6 +1655,7 @@ static int rt6_insert_exception(struct rt6_info *nrt,
 	struct in6_addr *src_key = NULL;
 	struct rt6_exception *rt6_ex;
 	struct fib6_nh *nh = res->nh;
+	int max_depth;
 	int err = 0;
 
 	spin_lock_bh(&rt6_exception_lock);
@@ -1709,7 +1710,9 @@ static int rt6_insert_exception(struct rt6_info *nrt,
 	bucket->depth++;
 	net->ipv6.rt6_stats->fib_rt_cache++;
 
-	if (bucket->depth > FIB6_MAX_DEPTH)
+	/* Randomize max depth to avoid some side channels attacks. */
+	max_depth = FIB6_MAX_DEPTH + prandom_u32_max(FIB6_MAX_DEPTH);
+	while (bucket->depth > max_depth)
 		rt6_exception_remove_oldest(bucket);
 
 out:
-- 
2.30.2



