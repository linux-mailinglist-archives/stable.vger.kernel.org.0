Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91A634F38CC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377201AbiDEL2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349742AbiDEJvM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:51:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9CED13E89;
        Tue,  5 Apr 2022 02:49:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 859FA61577;
        Tue,  5 Apr 2022 09:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D049C385A2;
        Tue,  5 Apr 2022 09:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152153;
        bh=nRRBq/Jik1ej734zd5EJafMlkLa2+n+e12Jve3Y5fDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rjOigTjRsSQB0FDQVnb/gIZPouLrf+qsCspKWvAZBiWN4Ib1YSb+5IHy9LyCwA0kx
         rnJ9IMlhcndNrlRf5etTcz4acmM4VtubYEXCJ2WZRzBuDmEBpV/CRTNuAZCCRbzWqh
         fnTw/6cwKWWHWtxnXslHXuYq4HVcbe8jJhm8dR9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        dev@openvswitch.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 675/913] net: prefer nf_ct_put instead of nf_conntrack_put
Date:   Tue,  5 Apr 2022 09:28:57 +0200
Message-Id: <20220405070400.069133533@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 408bdcfce8dfd6902f75fbcd3b99d8b24b506597 ]

Its the same as nf_conntrack_put(), but without the
need for an indirect call.  The downside is a module dependency on
nf_conntrack, but all of these already depend on conntrack anyway.

Cc: Paul Blakey <paulb@mellanox.com>
Cc: dev@openvswitch.org
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c |  4 ++--
 net/openvswitch/conntrack.c       | 14 ++++++++++----
 net/sched/act_ct.c                |  6 +++---
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7f7997460764..917e708a4561 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -989,7 +989,7 @@ static int __nf_ct_resolve_clash(struct sk_buff *skb,
 
 		nf_ct_acct_merge(ct, ctinfo, loser_ct);
 		nf_ct_add_to_dying_list(loser_ct);
-		nf_conntrack_put(&loser_ct->ct_general);
+		nf_ct_put(loser_ct);
 		nf_ct_set(skb, ct, ctinfo);
 
 		NF_CT_STAT_INC(net, clash_resolve);
@@ -1920,7 +1920,7 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 		/* Invalid: inverse of the return code tells
 		 * the netfilter core what to do */
 		pr_debug("nf_conntrack_in: Can't track with proto module\n");
-		nf_conntrack_put(&ct->ct_general);
+		nf_ct_put(ct);
 		skb->_nfct = 0;
 		/* Special case: TCP tracker reports an attempt to reopen a
 		 * closed/aborted connection. We have to go back and create a
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 8f47f4e78d32..f2b64cab9af7 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -574,7 +574,7 @@ ovs_ct_expect_find(struct net *net, const struct nf_conntrack_zone *zone,
 			struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
 
 			nf_ct_delete(ct, 0, 0);
-			nf_conntrack_put(&ct->ct_general);
+			nf_ct_put(ct);
 		}
 	}
 
@@ -723,7 +723,7 @@ static bool skb_nfct_cached(struct net *net,
 		if (nf_ct_is_confirmed(ct))
 			nf_ct_delete(ct, 0, 0);
 
-		nf_conntrack_put(&ct->ct_general);
+		nf_ct_put(ct);
 		nf_ct_set(skb, NULL, 0);
 		return false;
 	}
@@ -967,7 +967,8 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 
 		/* Associate skb with specified zone. */
 		if (tmpl) {
-			nf_conntrack_put(skb_nfct(skb));
+			ct = nf_ct_get(skb, &ctinfo);
+			nf_ct_put(ct);
 			nf_conntrack_get(&tmpl->ct_general);
 			nf_ct_set(skb, tmpl, IP_CT_NEW);
 		}
@@ -1328,7 +1329,12 @@ int ovs_ct_execute(struct net *net, struct sk_buff *skb,
 
 int ovs_ct_clear(struct sk_buff *skb, struct sw_flow_key *key)
 {
-	nf_conntrack_put(skb_nfct(skb));
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+
+	ct = nf_ct_get(skb, &ctinfo);
+
+	nf_ct_put(ct);
 	nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
 	ovs_ct_fill_key(skb, key, false);
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 4ffea1290ce1..240b3c5d2eb1 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -592,7 +592,7 @@ static bool tcf_ct_skb_nfct_cached(struct net *net, struct sk_buff *skb,
 		if (nf_ct_is_confirmed(ct))
 			nf_ct_kill(ct);
 
-		nf_conntrack_put(&ct->ct_general);
+		nf_ct_put(ct);
 		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
 
 		return false;
@@ -757,7 +757,7 @@ static void tcf_ct_params_free(struct rcu_head *head)
 	tcf_ct_flow_table_put(params);
 
 	if (params->tmpl)
-		nf_conntrack_put(&params->tmpl->ct_general);
+		nf_ct_put(params->tmpl);
 	kfree(params);
 }
 
@@ -967,7 +967,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 		tc_skb_cb(skb)->post_ct = false;
 		ct = nf_ct_get(skb, &ctinfo);
 		if (ct) {
-			nf_conntrack_put(&ct->ct_general);
+			nf_ct_put(ct);
 			nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
 		}
 
-- 
2.34.1



