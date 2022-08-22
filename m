Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C85F59BD81
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 12:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234636AbiHVKTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 06:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234657AbiHVKTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 06:19:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088811EAC7
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 03:18:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77F38B81011
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 10:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BADE8C433C1;
        Mon, 22 Aug 2022 10:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661163532;
        bh=OGkTWGey3WPaUwAyOyLSOBOGilzBkHm2Yxy2GWIJ12o=;
        h=Subject:To:Cc:From:Date:From;
        b=QWG9jritP1PZeIfmAL7p8PXDiWdbO2gIo39Q5GmV++ew5zG+2ER1lIBjYBbIMlqsI
         lILcAVofRqrxyHcnfMwJiuucto9HvIKIdv+HJHrdrar4GlGvzb8upadMdiFjvmV4k8
         hFu6SqwanKBUlZo4pRX1QS4KMApuFoX4abIJoReE=
Subject: FAILED: patch "[PATCH] netfilter: nf_tables: use READ_ONCE and WRITE_ONCE for shared" failed to apply to 4.19-stable tree
To:     pablo@netfilter.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 12:18:36 +0200
Message-ID: <166116351627179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3400278328285a8c2f121904496aff5e7b610a01 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 9 Aug 2022 13:22:01 +0200
Subject: [PATCH] netfilter: nf_tables: use READ_ONCE and WRITE_ONCE for shared
 generation id access

The generation ID is bumped from the commit path while holding the
mutex, however, netlink dump operations rely on RCU.

This patch also adds missing cb->base_eq initialization in
nf_tables_dump_set().

Fixes: 38e029f14a97 ("netfilter: nf_tables: set NLM_F_DUMP_INTR if netlink dumping is stale")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3cc88998b879..8b084cd669ab 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -889,7 +889,7 @@ static int nf_tables_dump_tables(struct sk_buff *skb,
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = nft_net->base_seq;
+	cb->seq = READ_ONCE(nft_net->base_seq);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
@@ -1705,7 +1705,7 @@ static int nf_tables_dump_chains(struct sk_buff *skb,
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = nft_net->base_seq;
+	cb->seq = READ_ONCE(nft_net->base_seq);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
@@ -3149,7 +3149,7 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = nft_net->base_seq;
+	cb->seq = READ_ONCE(nft_net->base_seq);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
@@ -4133,7 +4133,7 @@ static int nf_tables_dump_sets(struct sk_buff *skb, struct netlink_callback *cb)
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = nft_net->base_seq;
+	cb->seq = READ_ONCE(nft_net->base_seq);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (ctx->family != NFPROTO_UNSPEC &&
@@ -5061,6 +5061,8 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
+	cb->seq = READ_ONCE(nft_net->base_seq);
+
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (dump_ctx->ctx.family != NFPROTO_UNSPEC &&
 		    dump_ctx->ctx.family != table->family)
@@ -6941,7 +6943,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = nft_net->base_seq;
+	cb->seq = READ_ONCE(nft_net->base_seq);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
@@ -7873,7 +7875,7 @@ static int nf_tables_dump_flowtable(struct sk_buff *skb,
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = nft_net->base_seq;
+	cb->seq = READ_ONCE(nft_net->base_seq);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
@@ -8806,6 +8808,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	struct nft_trans_elem *te;
 	struct nft_chain *chain;
 	struct nft_table *table;
+	unsigned int base_seq;
 	LIST_HEAD(adl);
 	int err;
 
@@ -8855,9 +8858,12 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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
 

