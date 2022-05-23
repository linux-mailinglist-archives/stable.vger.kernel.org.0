Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678385316BA
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241019AbiEWR31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242794AbiEWR2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:28:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F3D8BD1B;
        Mon, 23 May 2022 10:24:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE87DB81205;
        Mon, 23 May 2022 17:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16633C385A9;
        Mon, 23 May 2022 17:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326612;
        bh=avndaQch640ZfRGocl3/Glaq1ZfFlwbRC5EyDnOyZQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AXlr4IY8uAdmzfcuuw9ilT9ksg8sZPF+KFdz+PqU1382uwLxq3ozUYtHpQ3sSEquN
         0EzsV0YgyTVA/53ed3xbvxHmzhoALsHltdqyxMONVVp/NbE/znROt1IFcVq3N67ga2
         E2LCAPwJPbVdMdFi5/tyIVRzBUKyON/Qdm4V6m68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ritaro Takenaka <ritarot634@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/132] netfilter: flowtable: move dst_check to packet path
Date:   Mon, 23 May 2022 19:05:12 +0200
Message-Id: <20220523165840.521396953@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
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

From: Ritaro Takenaka <ritarot634@gmail.com>

[ Upstream commit 2738d9d963bd1f06d5114c2b4fa5771a95703991 ]

Fixes sporadic IPv6 packet loss when flow offloading is enabled.

IPv6 route GC and flowtable GC are not synchronized.
When dst_cache becomes stale and a packet passes through the flow before
the flowtable GC teardowns it, the packet can be dropped.
So, it is necessary to check dst every time in packet path.

Fixes: 227e1e4d0d6c ("netfilter: nf_flowtable: skip device lookup from interface index")
Signed-off-by: Ritaro Takenaka <ritarot634@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_core.c | 23 +----------------------
 net/netfilter/nf_flow_table_ip.c   | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index de783c9094d7..9fb407084c50 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -415,32 +415,11 @@ nf_flow_table_iterate(struct nf_flowtable *flow_table,
 	return err;
 }
 
-static bool flow_offload_stale_dst(struct flow_offload_tuple *tuple)
-{
-	struct dst_entry *dst;
-
-	if (tuple->xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
-	    tuple->xmit_type == FLOW_OFFLOAD_XMIT_XFRM) {
-		dst = tuple->dst_cache;
-		if (!dst_check(dst, tuple->dst_cookie))
-			return true;
-	}
-
-	return false;
-}
-
-static bool nf_flow_has_stale_dst(struct flow_offload *flow)
-{
-	return flow_offload_stale_dst(&flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple) ||
-	       flow_offload_stale_dst(&flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple);
-}
-
 static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 				    struct flow_offload *flow, void *data)
 {
 	if (nf_flow_has_expired(flow) ||
-	    nf_ct_is_dying(flow->ct) ||
-	    nf_flow_has_stale_dst(flow))
+	    nf_ct_is_dying(flow->ct))
 		flow_offload_teardown(flow);
 
 	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 6257d87c3a56..28026467b54c 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -227,6 +227,15 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 	return true;
 }
 
+static inline bool nf_flow_dst_check(struct flow_offload_tuple *tuple)
+{
+	if (tuple->xmit_type != FLOW_OFFLOAD_XMIT_NEIGH &&
+	    tuple->xmit_type != FLOW_OFFLOAD_XMIT_XFRM)
+		return true;
+
+	return dst_check(tuple->dst_cache, tuple->dst_cookie);
+}
+
 static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 				      const struct nf_hook_state *state,
 				      struct dst_entry *dst)
@@ -346,6 +355,11 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_state_check(flow, iph->protocol, skb, thoff))
 		return NF_ACCEPT;
 
+	if (!nf_flow_dst_check(&tuplehash->tuple)) {
+		flow_offload_teardown(flow);
+		return NF_ACCEPT;
+	}
+
 	if (skb_try_make_writable(skb, thoff + hdrsize))
 		return NF_DROP;
 
@@ -582,6 +596,11 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, thoff))
 		return NF_ACCEPT;
 
+	if (!nf_flow_dst_check(&tuplehash->tuple)) {
+		flow_offload_teardown(flow);
+		return NF_ACCEPT;
+	}
+
 	if (skb_try_make_writable(skb, thoff + hdrsize))
 		return NF_DROP;
 
-- 
2.35.1



