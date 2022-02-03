Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEC4E4A83E0
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 13:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350553AbiBCMeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 07:34:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiBCMeJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 07:34:09 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6788DC06173B;
        Thu,  3 Feb 2022 04:34:09 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nFbJP-0000UM-VX; Thu, 03 Feb 2022 13:34:08 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <stable@vger.kernel.org>
Cc:     <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.9.y 2/2] netfilter: nat: limit port clash resolution attempts
Date:   Thu,  3 Feb 2022 13:32:55 +0100
Message-Id: <20220203123255.18974-3-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203123255.18974-1-fw@strlen.de>
References: <20220203123255.18974-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a504b703bb1da526a01593da0e4be2af9d9f5fa8 upstream.

In case almost or all available ports are taken, clash resolution can
take a very long time, resulting in soft lockup.

This can happen when many to-be-natted hosts connect to same
destination:port (e.g. a proxy) and all connections pass the same SNAT.

Pick a random offset in the acceptable range, then try ever smaller
number of adjacent port numbers, until either the limit is reached or a
useable port was found.  This results in at most 248 attempts
(128 + 64 + 32 + 16 + 8, i.e. 4 restarts with new search offset)
instead of 64000+,

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_proto_common.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_nat_proto_common.c b/net/netfilter/nf_nat_proto_common.c
index ac57e47aded2..a4f709a3cbac 100644
--- a/net/netfilter/nf_nat_proto_common.c
+++ b/net/netfilter/nf_nat_proto_common.c
@@ -40,9 +40,10 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 				 enum nf_nat_manip_type maniptype,
 				 const struct nf_conn *ct)
 {
-	unsigned int range_size, min, max, i;
+	unsigned int range_size, min, max, i, attempts;
 	__be16 *portptr;
-	u_int16_t off;
+	u16 off;
+	static const unsigned int max_attempts = 128;
 
 	if (maniptype == NF_NAT_MANIP_SRC)
 		portptr = &tuple->src.u.all;
@@ -86,12 +87,28 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		off = prandom_u32();
 	}
 
-	for (i = 0; ; ++off) {
+	attempts = range_size;
+	if (attempts > max_attempts)
+		attempts = max_attempts;
+
+	/* We are in softirq; doing a search of the entire range risks
+	 * soft lockup when all tuples are already used.
+	 *
+	 * If we can't find any free port from first offset, pick a new
+	 * one and try again, with ever smaller search window.
+	 */
+another_round:
+	for (i = 0; i < attempts; i++, off++) {
 		*portptr = htons(min + off % range_size);
-		if (++i != range_size && nf_nat_used_tuple(tuple, ct))
-			continue;
-		return;
+		if (!nf_nat_used_tuple(tuple, ct))
+			return;
 	}
+
+	if (attempts >= range_size || attempts < 16)
+		return;
+	attempts /= 2;
+	off = prandom_u32();
+	goto another_round;
 }
 EXPORT_SYMBOL_GPL(nf_nat_l4proto_unique_tuple);
 
-- 
2.34.1

