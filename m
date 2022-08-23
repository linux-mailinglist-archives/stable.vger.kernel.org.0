Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6D759D601
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240362AbiHWJAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241411AbiHWI7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:59:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A123872861;
        Tue, 23 Aug 2022 01:26:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0726761326;
        Tue, 23 Aug 2022 08:19:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE79AC433C1;
        Tue, 23 Aug 2022 08:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242752;
        bh=Y6ANw5KX4DbdM59Da3Kv2+eYubJ10ZRx8yC/Z07q1iU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CdXpHORVMWKYER3eghs0Z/SK8NAHKYdx+TOy6RzTBpMbQ2hVa8eLVeGPOM06fNley
         LAxE/3gu8nL8X5Ee7+1st6gar3PxhN9ZbA6lc/uFxPbrOmekU2AnDGFhnuvQc7pCUK
         +AU4SHk8Z6/rka9tHqlqjlRC7nepfJ0FjKvEzSrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.19 189/365] netfilter: nf_tables: use READ_ONCE and WRITE_ONCE for shared generation id access
Date:   Tue, 23 Aug 2022 10:01:30 +0200
Message-Id: <20220823080126.128862257@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 3400278328285a8c2f121904496aff5e7b610a01 upstream.

The generation ID is bumped from the commit path while holding the
mutex, however, netlink dump operations rely on RCU.

This patch also adds missing cb->base_eq initialization in
nf_tables_dump_set().

Fixes: 38e029f14a97 ("netfilter: nf_tables: set NLM_F_DUMP_INTR if netlink dumping is stale")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -889,7 +889,7 @@ static int nf_tables_dump_tables(struct
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = nft_net->base_seq;
+	cb->seq = READ_ONCE(nft_net->base_seq);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
@@ -1705,7 +1705,7 @@ static int nf_tables_dump_chains(struct
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = nft_net->base_seq;
+	cb->seq = READ_ONCE(nft_net->base_seq);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
@@ -3149,7 +3149,7 @@ static int nf_tables_dump_rules(struct s
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = nft_net->base_seq;
+	cb->seq = READ_ONCE(nft_net->base_seq);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
@@ -4133,7 +4133,7 @@ static int nf_tables_dump_sets(struct sk
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = nft_net->base_seq;
+	cb->seq = READ_ONCE(nft_net->base_seq);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (ctx->family != NFPROTO_UNSPEC &&
@@ -5061,6 +5061,8 @@ static int nf_tables_dump_set(struct sk_
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
+	cb->seq = READ_ONCE(nft_net->base_seq);
+
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (dump_ctx->ctx.family != NFPROTO_UNSPEC &&
 		    dump_ctx->ctx.family != table->family)
@@ -6887,7 +6889,7 @@ static int nf_tables_dump_obj(struct sk_
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = nft_net->base_seq;
+	cb->seq = READ_ONCE(nft_net->base_seq);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
@@ -7819,7 +7821,7 @@ static int nf_tables_dump_flowtable(stru
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = nft_net->base_seq;
+	cb->seq = READ_ONCE(nft_net->base_seq);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
@@ -8752,6 +8754,7 @@ static int nf_tables_commit(struct net *
 	struct nft_trans_elem *te;
 	struct nft_chain *chain;
 	struct nft_table *table;
+	unsigned int base_seq;
 	LIST_HEAD(adl);
 	int err;
 
@@ -8801,9 +8804,12 @@ static int nf_tables_commit(struct net *
 	 * Bump generation counter, invalidate any dump in progress.
 	 * Cannot fail after this point.
 	 */
-	while (++nft_net->base_seq == 0)
+	base_seq = READ_ONCE(nft_net->base_seq);
+	while (++base_seq == 0)
 		;
 
+	WRITE_ONCE(nft_net->base_seq, base_seq);
+
 	/* step 3. Start new generation, rules_gen_X now in use. */
 	net->nft.gencursor = nft_gencursor_next(net);
 


