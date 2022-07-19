Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E38579DFC
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242233AbiGSM4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242229AbiGSM4R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:56:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820175B787;
        Tue, 19 Jul 2022 05:22:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B507C6177D;
        Tue, 19 Jul 2022 12:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972B1C341C6;
        Tue, 19 Jul 2022 12:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233342;
        bh=Nf4t3W8Y5OtNITd3bs5jprA180YUIhX2K1C40cMbr3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xTB8Kay1aRumf4+nFjgQL5iu1Im54GbVl89vmgmWX5hFDHBEvuXYZ0p+bqjNjoMvJ
         uhc/sxMMUDBDSv20oaAC8iAFkDycdgT0c73Wxq/8spEPqq7kj9xbjEcqzS1Km7O2qv
         howOQ3C3i1ji+q8yhCIavB4LcR7SB8qyfICLJvV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 063/231] netfilter: conntrack: include ecache dying list in dumps
Date:   Tue, 19 Jul 2022 13:52:28 +0200
Message-Id: <20220719114719.478483842@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 0d3cc504ba9cdcff76346306c37eb1ea01e60a86 ]

The new pernet dying list includes conntrack entries that await
delivery of the 'destroy' event via ctnetlink.

The old percpu dying list will be removed soon.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_conntrack_ecache.h |  2 +
 net/netfilter/nf_conntrack_ecache.c         | 10 +++++
 net/netfilter/nf_conntrack_netlink.c        | 43 +++++++++++++++++++++
 3 files changed, 55 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index a6135b5030dd..b57d73785e4d 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -164,6 +164,8 @@ void nf_conntrack_ecache_work(struct net *net, enum nf_ct_ecache_state state);
 void nf_conntrack_ecache_pernet_init(struct net *net);
 void nf_conntrack_ecache_pernet_fini(struct net *net);
 
+struct nf_conntrack_net_ecache *nf_conn_pernet_ecache(const struct net *net);
+
 static inline bool nf_conntrack_ecache_dwork_pending(const struct net *net)
 {
 	return net->ct.ecache_dwork_pending;
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 2752859479b2..334b2b4e5e8b 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -38,6 +38,16 @@ enum retry_state {
 	STATE_DONE,
 };
 
+struct nf_conntrack_net_ecache *nf_conn_pernet_ecache(const struct net *net)
+{
+	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
+
+	return &cnet->ecache;
+}
+#if IS_MODULE(CONFIG_NF_CT_NETLINK)
+EXPORT_SYMBOL_GPL(nf_conn_pernet_ecache);
+#endif
+
 static enum retry_state ecache_work_evict_list(struct nf_conntrack_net *cnet)
 {
 	unsigned long stop = jiffies + ECACHE_MAX_JIFFIES;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 924d766e6c53..a4ec2aad2187 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -62,6 +62,7 @@ struct ctnetlink_list_dump_ctx {
 	struct nf_conn *last;
 	unsigned int cpu;
 	bool done;
+	bool retrans_done;
 };
 
 static int ctnetlink_dump_tuples_proto(struct sk_buff *skb,
@@ -1802,6 +1803,48 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 static int
 ctnetlink_dump_dying(struct sk_buff *skb, struct netlink_callback *cb)
 {
+	struct ctnetlink_list_dump_ctx *ctx = (void *)cb->ctx;
+	struct nf_conn *last = ctx->last;
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	const struct net *net = sock_net(skb->sk);
+	struct nf_conntrack_net_ecache *ecache_net;
+	struct nf_conntrack_tuple_hash *h;
+	struct hlist_nulls_node *n;
+#endif
+
+	if (ctx->retrans_done)
+		return ctnetlink_dump_list(skb, cb, true);
+
+	ctx->last = NULL;
+
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	ecache_net = nf_conn_pernet_ecache(net);
+	spin_lock_bh(&ecache_net->dying_lock);
+
+	hlist_nulls_for_each_entry(h, n, &ecache_net->dying_list, hnnode) {
+		struct nf_conn *ct;
+		int res;
+
+		ct = nf_ct_tuplehash_to_ctrack(h);
+		if (last && last != ct)
+			continue;
+
+		res = ctnetlink_dump_one_entry(skb, cb, ct, true);
+		if (res < 0) {
+			spin_unlock_bh(&ecache_net->dying_lock);
+			nf_ct_put(last);
+			return skb->len;
+		}
+
+		nf_ct_put(last);
+		last = NULL;
+	}
+
+	spin_unlock_bh(&ecache_net->dying_lock);
+#endif
+	nf_ct_put(last);
+	ctx->retrans_done = true;
+
 	return ctnetlink_dump_list(skb, cb, true);
 }
 
-- 
2.35.1



