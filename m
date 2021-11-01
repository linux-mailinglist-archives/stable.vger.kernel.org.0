Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCE54416C7
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbhKAJ3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:29:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232656AbhKAJ0a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:26:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72AA861177;
        Mon,  1 Nov 2021 09:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758531;
        bh=mXvQlSloKrpdhCt5IpZXTJFqKh65jakgVrGXt/ZgwW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SP2nxm37+S3Q4Tk80yJ7N9XqwPCGrqpQtxMahFtaCE+LOAhGYlcBEtNhaIfdLpWcc
         7N4m2mxg3OODSDMj64UUd7g1G9lrdhKhP1isVfcLP2LxSerDnTx2yP+ET+hCHivy3X
         Fb2l/2dXzjp+l7rIJZm/y4Nt3rAzcB9VsrtKfcB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>, Keyu Man <kman001@ucr.edu>,
        Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 13/35] ipv4: use siphash instead of Jenkins in fnhe_hashfun()
Date:   Mon,  1 Nov 2021 10:17:25 +0100
Message-Id: <20211101082454.680783711@linuxfoundation.org>
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

commit 6457378fe796815c973f631a1904e147d6ee33b1 upstream.

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
[OP: adjusted context for 4.19 stable]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -625,14 +625,14 @@ static void fnhe_remove_oldest(struct fn
 	kfree_rcu(oldest, rcu);
 }
 
-static inline u32 fnhe_hashfun(__be32 daddr)
+static u32 fnhe_hashfun(__be32 daddr)
 {
-	static u32 fnhe_hashrnd __read_mostly;
-	u32 hval;
+	static siphash_key_t fnhe_hash_key __read_mostly;
+	u64 hval;
 
-	net_get_random_once(&fnhe_hashrnd, sizeof(fnhe_hashrnd));
-	hval = jhash_1word((__force u32) daddr, fnhe_hashrnd);
-	return hash_32(hval, FNHE_HASH_SHIFT);
+	net_get_random_once(&fnhe_hash_key, sizeof(fnhe_hash_key));
+	hval = siphash_1u32((__force u32)daddr, &fnhe_hash_key);
+	return hash_64(hval, FNHE_HASH_SHIFT);
 }
 
 static void fill_route_from_fnhe(struct rtable *rt, struct fib_nh_exception *fnhe)


