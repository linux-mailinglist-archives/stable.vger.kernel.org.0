Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970064416C5
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbhKAJ3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:29:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232996AbhKAJ0h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:26:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 266D3611C1;
        Mon,  1 Nov 2021 09:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758536;
        bh=ykljXRY80sLg1sF+0dIm8Lcob+czv2Dt683jmkUv/J8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=At4hjNpGejwBiLqAokhmWiYCjLojecvUJNw8YydznyvKtz5MxLIuswzlWZGy7OcIo
         FQ0bp6YkuZbG3xdWGz3lZ1Y7N9UZioOhgOnqgn6iWPSDBn6ussmIRnkL4T0o2JNaRU
         ouhD9nP5PzNTbm86ixz0bGYBu5c1QBNmf3duoRaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Keyu Man <kman001@ucr.edu>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 15/35] ipv6: make exception cache less predictible
Date:   Mon,  1 Nov 2021 10:17:27 +0100
Message-Id: <20211101082455.124162667@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082451.430720900@linuxfoundation.org>
References: <20211101082451.430720900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit a00df2caffed3883c341d5685f830434312e4a43 upstream.

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
[OP: adjusted context for 4.19 stable]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1454,6 +1454,7 @@ static int rt6_insert_exception(struct r
 	struct rt6_exception_bucket *bucket;
 	struct in6_addr *src_key = NULL;
 	struct rt6_exception *rt6_ex;
+	int max_depth;
 	int err = 0;
 
 	spin_lock_bh(&rt6_exception_lock);
@@ -1515,7 +1516,9 @@ static int rt6_insert_exception(struct r
 	bucket->depth++;
 	net->ipv6.rt6_stats->fib_rt_cache++;
 
-	if (bucket->depth > FIB6_MAX_DEPTH)
+	/* Randomize max depth to avoid some side channels attacks. */
+	max_depth = FIB6_MAX_DEPTH + prandom_u32_max(FIB6_MAX_DEPTH);
+	while (bucket->depth > max_depth)
 		rt6_exception_remove_oldest(bucket);
 
 out:


