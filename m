Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E03B7535CDE
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 11:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350458AbiE0JBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 05:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350821AbiE0JAn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 05:00:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A237E27A8;
        Fri, 27 May 2022 01:57:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 97B2BCE237A;
        Fri, 27 May 2022 08:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76052C385A9;
        Fri, 27 May 2022 08:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641827;
        bh=KPMtOdd2C6uBfif5cO5e6762ZC39N4t+Yxbl4AQveZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ytBJJMBpTYdU3qAGo9i8/hmMalnvwe9klVsZ44ErsF8On+gzjfrh0t0gOuISJYX5t
         FAprKoBvZF1/EwKlYddaKuvgX9ULDCa98KX8ajzncoY9PnFyce6R7W9B4XS5X2F0MW
         QFSR/hmboBxB1NjqXgS/H2+ZP1EGUymRtD2eFPs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        David Dworken <ddworken@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.10 005/163] tcp: change source port randomizarion at connect() time
Date:   Fri, 27 May 2022 10:48:05 +0200
Message-Id: <20220527084828.937394121@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 190cc82489f46f9d88e73c81a47e14f80a791e1a upstream.

RFC 6056 (Recommendations for Transport-Protocol Port Randomization)
provides good summary of why source selection needs extra care.

David Dworken reminded us that linux implements Algorithm 3
as described in RFC 6056 3.3.3

Quoting David :
   In the context of the web, this creates an interesting info leak where
   websites can count how many TCP connections a user's computer is
   establishing over time. For example, this allows a website to count
   exactly how many subresources a third party website loaded.
   This also allows:
   - Distinguishing between different users behind a VPN based on
       distinct source port ranges.
   - Tracking users over time across multiple networks.
   - Covert communication channels between different browsers/browser
       profiles running on the same computer
   - Tracking what applications are running on a computer based on
       the pattern of how fast source ports are getting incremented.

Section 3.3.4 describes an enhancement, that reduces
attackers ability to use the basic information currently
stored into the shared 'u32 hint'.

This change also decreases collision rate when
multiple applications need to connect() to
different destinations.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: David Dworken <ddworken@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_hashtables.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -722,6 +722,17 @@ void inet_unhash(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(inet_unhash);
 
+/* RFC 6056 3.3.4.  Algorithm 4: Double-Hash Port Selection Algorithm
+ * Note that we use 32bit integers (vs RFC 'short integers')
+ * because 2^16 is not a multiple of num_ephemeral and this
+ * property might be used by clever attacker.
+ * RFC claims using TABLE_LENGTH=10 buckets gives an improvement,
+ * we use 256 instead to really give more isolation and
+ * privacy, this only consumes 1 KB of kernel memory.
+ */
+#define INET_TABLE_PERTURB_SHIFT 8
+static u32 table_perturb[1 << INET_TABLE_PERTURB_SHIFT];
+
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 		struct sock *sk, u32 port_offset,
 		int (*check_established)(struct inet_timewait_death_row *,
@@ -735,8 +746,8 @@ int __inet_hash_connect(struct inet_time
 	struct inet_bind_bucket *tb;
 	u32 remaining, offset;
 	int ret, i, low, high;
-	static u32 hint;
 	int l3mdev;
+	u32 index;
 
 	if (port) {
 		head = &hinfo->bhash[inet_bhashfn(net, port,
@@ -763,7 +774,10 @@ int __inet_hash_connect(struct inet_time
 	if (likely(remaining > 1))
 		remaining &= ~1U;
 
-	offset = (hint + port_offset) % remaining;
+	net_get_random_once(table_perturb, sizeof(table_perturb));
+	index = hash_32(port_offset, INET_TABLE_PERTURB_SHIFT);
+
+	offset = (READ_ONCE(table_perturb[index]) + port_offset) % remaining;
 	/* In first pass we try ports of @low parity.
 	 * inet_csk_get_port() does the opposite choice.
 	 */
@@ -817,7 +831,7 @@ next_port:
 	return -EADDRNOTAVAIL;
 
 ok:
-	hint += i + 2;
+	WRITE_ONCE(table_perturb[index], READ_ONCE(table_perturb[index]) + i + 2);
 
 	/* Head lock still held and bh's disabled */
 	inet_bind_hash(sk, tb, port);


