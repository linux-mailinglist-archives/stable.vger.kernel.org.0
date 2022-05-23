Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0FE531931
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240671AbiEWRsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244344AbiEWRsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:48:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8764A88A0;
        Mon, 23 May 2022 10:37:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 623AFB81216;
        Mon, 23 May 2022 17:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98688C385A9;
        Mon, 23 May 2022 17:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326976;
        bh=qrW7dQvs63KXSNnBwB2u/bMODuvSDa47Uo/6Hd+Twk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yJFq1CqojgQ3Vc9ykW36uDLrEd3xpIEo6TxKEukMsZovC75Fw7vNuUz0k23fDIKoL
         1APFgel4DvYvSm0sBt2evx/wDi2YTnYfsEU9l3n3TqW/dr97v01KPGhxzjZjHQeYsj
         09ZseD37rFkhrWD5jamuz8c6rKfDWfpIi9zFRmko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oz Shlomo <ozsh@nvidia.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 117/158] netfilter: flowtable: fix TCP flow teardown
Date:   Mon, 23 May 2022 19:04:34 +0200
Message-Id: <20220523165850.278677855@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit e5eaac2beb54f0a16ff851125082d9faeb475572 ]

This patch addresses three possible problems:

1. ct gc may race to undo the timeout adjustment of the packet path, leaving
   the conntrack entry in place with the internal offload timeout (one day).

2. ct gc removes the ct because the IPS_OFFLOAD_BIT is not set and the CLOSE
   timeout is reached before the flow offload del.

3. tcp ct is always set to ESTABLISHED with a very long timeout
   in flow offload teardown/delete even though the state might be already
   CLOSED. Also as a remark we cannot assume that the FIN or RST packet
   is hitting flow table teardown as the packet might get bumped to the
   slow path in nftables.

This patch resets IPS_OFFLOAD_BIT from flow_offload_teardown(), so
conntrack handles the tcp rst/fin packet which triggers the CLOSE/FIN
state transition.

Moreover, teturn the connection's ownership to conntrack upon teardown
by clearing the offload flag and fixing the established timeout value.
The flow table GC thread will asynchonrnously free the flow table and
hardware offload entries.

Before this patch, the IPS_OFFLOAD_BIT remained set for expired flows on
which is also misleading since the flow is back to classic conntrack
path.

If nf_ct_delete() removes the entry from the conntrack table, then it
calls nf_ct_put() which decrements the refcnt. This is not a problem
because the flowtable holds a reference to the conntrack object from
flow_offload_alloc() path which is released via flow_offload_free().

This patch also updates nft_flow_offload to skip packets in SYN_RECV
state. Since we might miss or bump packets to slow path, we do not know
what will happen there while we are still in SYN_RECV, this patch
postpones offload up to the next packet which also aligns to the
existing behaviour in tc-ct.

flow_offload_teardown() does not reset the existing tcp state from
flow_offload_fixup_tcp() to ESTABLISHED anymore, packets bump to slow
path might have already update the state to CLOSE/FIN.

Joint work with Oz and Sven.

Fixes: 1e5b2471bcc4 ("netfilter: nf_flow_table: teardown flow timeout race")
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_core.c | 33 +++++++-----------------------
 net/netfilter/nft_flow_offload.c   |  3 ++-
 2 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 52e7f94d2450..58f3f77b3eb2 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -173,12 +173,11 @@ EXPORT_SYMBOL_GPL(flow_offload_route_init);
 
 static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
 {
-	tcp->state = TCP_CONNTRACK_ESTABLISHED;
 	tcp->seen[0].td_maxwin = 0;
 	tcp->seen[1].td_maxwin = 0;
 }
 
-static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
+static void flow_offload_fixup_ct(struct nf_conn *ct)
 {
 	struct net *net = nf_ct_net(ct);
 	int l4num = nf_ct_protonum(ct);
@@ -187,7 +186,9 @@ static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
 	if (l4num == IPPROTO_TCP) {
 		struct nf_tcp_net *tn = nf_tcp_pernet(net);
 
-		timeout = tn->timeouts[TCP_CONNTRACK_ESTABLISHED];
+		flow_offload_fixup_tcp(&ct->proto.tcp);
+
+		timeout = tn->timeouts[ct->proto.tcp.state];
 		timeout -= tn->offload_timeout;
 	} else if (l4num == IPPROTO_UDP) {
 		struct nf_udp_net *tn = nf_udp_pernet(net);
@@ -205,18 +206,6 @@ static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
 		WRITE_ONCE(ct->timeout, nfct_time_stamp + timeout);
 }
 
-static void flow_offload_fixup_ct_state(struct nf_conn *ct)
-{
-	if (nf_ct_protonum(ct) == IPPROTO_TCP)
-		flow_offload_fixup_tcp(&ct->proto.tcp);
-}
-
-static void flow_offload_fixup_ct(struct nf_conn *ct)
-{
-	flow_offload_fixup_ct_state(ct);
-	flow_offload_fixup_ct_timeout(ct);
-}
-
 static void flow_offload_route_release(struct flow_offload *flow)
 {
 	nft_flow_dst_release(flow, FLOW_OFFLOAD_DIR_ORIGINAL);
@@ -355,22 +344,14 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 	rhashtable_remove_fast(&flow_table->rhashtable,
 			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
 			       nf_flow_offload_rhash_params);
-
-	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
-
-	if (nf_flow_has_expired(flow))
-		flow_offload_fixup_ct(flow->ct);
-	else
-		flow_offload_fixup_ct_timeout(flow->ct);
-
 	flow_offload_free(flow);
 }
 
 void flow_offload_teardown(struct flow_offload *flow)
 {
+	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
 	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
-
-	flow_offload_fixup_ct_state(flow->ct);
+	flow_offload_fixup_ct(flow->ct);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
@@ -460,7 +441,7 @@ static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
 	if (nf_flow_has_expired(flow) ||
 	    nf_ct_is_dying(flow->ct) ||
 	    nf_flow_has_stale_dst(flow))
-		set_bit(NF_FLOW_TEARDOWN, &flow->flags);
+		flow_offload_teardown(flow);
 
 	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
 		if (test_bit(NF_FLOW_HW, &flow->flags)) {
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 12145a80ef03..aac6db8680d4 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -298,7 +298,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	case IPPROTO_TCP:
 		tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt),
 					  sizeof(_tcph), &_tcph);
-		if (unlikely(!tcph || tcph->fin || tcph->rst))
+		if (unlikely(!tcph || tcph->fin || tcph->rst ||
+			     !nf_conntrack_tcp_established(ct)))
 			goto out;
 		break;
 	case IPPROTO_UDP:
-- 
2.35.1



