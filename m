Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD8DE56FAF6
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbiGKJY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbiGKJYg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:24:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0C22983B;
        Mon, 11 Jul 2022 02:14:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF1316122D;
        Mon, 11 Jul 2022 09:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC11BC34115;
        Mon, 11 Jul 2022 09:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530892;
        bh=IGjaSXXz+F58VMvnjySoD6f9kLwkf6beF4+9SB1lVBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yDQsW1Pc8vmFR1DGEA1dpHfNFFIYGvPwZxXVKpjRGlT6oYA+bm/RD/BC8LTL85HnE
         5+2FS8bzVlJmc9+dcYZ0P69ZT+5IzZJ2h9mS2amqvXrp9jZj1i/+CUVc6QoQkdkN/f
         iMlc4I365Z5XkdYm7W+nUhtOsulyR0oR+/GM3DFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.18 021/112] netfilter: nft_set_pipapo: release elements in clone from abort path
Date:   Mon, 11 Jul 2022 11:06:21 +0200
Message-Id: <20220711090550.161213436@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 9827a0e6e23bf43003cd3d5b7fb11baf59a35e1e upstream.

New elements that reside in the clone are not released in case that the
transaction is aborted.

[16302.231754] ------------[ cut here ]------------
[16302.231756] WARNING: CPU: 0 PID: 100509 at net/netfilter/nf_tables_api.c:1864 nf_tables_chain_destroy+0x26/0x127 [nf_tables]
[...]
[16302.231882] CPU: 0 PID: 100509 Comm: nft Tainted: G        W         5.19.0-rc3+ #155
[...]
[16302.231887] RIP: 0010:nf_tables_chain_destroy+0x26/0x127 [nf_tables]
[16302.231899] Code: f3 fe ff ff 41 55 41 54 55 53 48 8b 6f 10 48 89 fb 48 c7 c7 82 96 d9 a0 8b 55 50 48 8b 75 58 e8 de f5 92 e0 83 7d 50 00 74 09 <0f> 0b 5b 5d 41 5c 41 5d c3 4c 8b 65 00 48 8b 7d 08 49 39 fc 74 05
[...]
[16302.231917] Call Trace:
[16302.231919]  <TASK>
[16302.231921]  __nf_tables_abort.cold+0x23/0x28 [nf_tables]
[16302.231934]  nf_tables_abort+0x30/0x50 [nf_tables]
[16302.231946]  nfnetlink_rcv_batch+0x41a/0x840 [nfnetlink]
[16302.231952]  ? __nla_validate_parse+0x48/0x190
[16302.231959]  nfnetlink_rcv+0x110/0x129 [nfnetlink]
[16302.231963]  netlink_unicast+0x211/0x340
[16302.231969]  netlink_sendmsg+0x21e/0x460

Add nft_set_pipapo_match_destroy() helper function to release the
elements in the lookup tables.

Stefano Brivio says: "We additionally look for elements pointers in the
cloned matching data if priv->dirty is set, because that means that
cloned data might point to additional elements we did not commit to the
working copy yet (such as the abort path case, but perhaps not limited
to it)."

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_pipapo.c |   48 ++++++++++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 15 deletions(-)

--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2125,6 +2125,32 @@ out_scratch:
 }
 
 /**
+ * nft_set_pipapo_match_destroy() - Destroy elements from key mapping array
+ * @set:	nftables API set representation
+ * @m:		matching data pointing to key mapping array
+ */
+static void nft_set_pipapo_match_destroy(const struct nft_set *set,
+					 struct nft_pipapo_match *m)
+{
+	struct nft_pipapo_field *f;
+	int i, r;
+
+	for (i = 0, f = m->f; i < m->field_count - 1; i++, f++)
+		;
+
+	for (r = 0; r < f->rules; r++) {
+		struct nft_pipapo_elem *e;
+
+		if (r < f->rules - 1 && f->mt[r + 1].e == f->mt[r].e)
+			continue;
+
+		e = f->mt[r].e;
+
+		nft_set_elem_destroy(set, e, true);
+	}
+}
+
+/**
  * nft_pipapo_destroy() - Free private data for set and all committed elements
  * @set:	nftables API set representation
  */
@@ -2132,26 +2158,13 @@ static void nft_pipapo_destroy(const str
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct nft_pipapo_match *m;
-	struct nft_pipapo_field *f;
-	int i, r, cpu;
+	int cpu;
 
 	m = rcu_dereference_protected(priv->match, true);
 	if (m) {
 		rcu_barrier();
 
-		for (i = 0, f = m->f; i < m->field_count - 1; i++, f++)
-			;
-
-		for (r = 0; r < f->rules; r++) {
-			struct nft_pipapo_elem *e;
-
-			if (r < f->rules - 1 && f->mt[r + 1].e == f->mt[r].e)
-				continue;
-
-			e = f->mt[r].e;
-
-			nft_set_elem_destroy(set, e, true);
-		}
+		nft_set_pipapo_match_destroy(set, m);
 
 #ifdef NFT_PIPAPO_ALIGN
 		free_percpu(m->scratch_aligned);
@@ -2165,6 +2178,11 @@ static void nft_pipapo_destroy(const str
 	}
 
 	if (priv->clone) {
+		m = priv->clone;
+
+		if (priv->dirty)
+			nft_set_pipapo_match_destroy(set, m);
+
 #ifdef NFT_PIPAPO_ALIGN
 		free_percpu(priv->clone->scratch_aligned);
 #endif


