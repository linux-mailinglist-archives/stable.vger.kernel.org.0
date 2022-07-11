Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDF756FBC0
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbiGKJey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232921AbiGKJeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:34:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135DC7B78A;
        Mon, 11 Jul 2022 02:18:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D9036122D;
        Mon, 11 Jul 2022 09:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630D7C34115;
        Mon, 11 Jul 2022 09:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531097;
        bh=Uai6T07U7SXLqWHnyoXLrxVxloyCBiKlazL3N1+IVY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fBeS8n4U8gNKvsr0+QgWOTu9Jhuhvm8ExUTuh7NenWEHeviQeDr9pgxAlvn9mqwD8
         DOSo9lFcFeLmYJ07EuQO56lRuO6RzT7juBTgFRmdZE7MFOKhLyQAEfMuZnsJumCe2Y
         buJorkG124PBQxDcGVQ631x9/ZSEaNbVCaPxqrnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 095/112] net/sched: act_api: Add extack to offload_act_setup() callback
Date:   Mon, 11 Jul 2022 11:07:35 +0200
Message-Id: <20220711090552.267058888@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit c2ccf84ecb715bb81dc7f51e69d680a95bf055ae ]

The callback is used by various actions to populate the flow action
structure prior to offload. Pass extack to this callback so that the
various actions will be able to report accurate error messages to user
space.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/act_api.h      |  3 ++-
 include/net/pkt_cls.h      |  6 ++++--
 net/sched/act_api.c        |  4 ++--
 net/sched/act_csum.c       |  3 ++-
 net/sched/act_ct.c         |  3 ++-
 net/sched/act_gact.c       |  3 ++-
 net/sched/act_gate.c       |  3 ++-
 net/sched/act_mirred.c     |  3 ++-
 net/sched/act_mpls.c       |  3 ++-
 net/sched/act_pedit.c      |  3 ++-
 net/sched/act_police.c     |  3 ++-
 net/sched/act_sample.c     |  3 ++-
 net/sched/act_skbedit.c    |  3 ++-
 net/sched/act_tunnel_key.c |  3 ++-
 net/sched/act_vlan.c       |  3 ++-
 net/sched/cls_api.c        | 16 ++++++++++------
 net/sched/cls_flower.c     |  6 ++++--
 net/sched/cls_matchall.c   |  6 ++++--
 18 files changed, 50 insertions(+), 27 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 3049cb69c025..9cf6870b526e 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -134,7 +134,8 @@ struct tc_action_ops {
 	(*get_psample_group)(const struct tc_action *a,
 			     tc_action_priv_destructor *destructor);
 	int     (*offload_act_setup)(struct tc_action *act, void *entry_data,
-				     u32 *index_inc, bool bind);
+				     u32 *index_inc, bool bind,
+				     struct netlink_ext_ack *extack);
 };
 
 struct tc_action_net {
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index a3b57a93228a..8cf001aed858 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -547,10 +547,12 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
 }
 
 int tc_setup_offload_action(struct flow_action *flow_action,
-			    const struct tcf_exts *exts);
+			    const struct tcf_exts *exts,
+			    struct netlink_ext_ack *extack);
 void tc_cleanup_offload_action(struct flow_action *flow_action);
 int tc_setup_action(struct flow_action *flow_action,
-		    struct tc_action *actions[]);
+		    struct tc_action *actions[],
+		    struct netlink_ext_ack *extack);
 
 int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
 		     void *type_data, bool err_stop, bool rtnl_held);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 6fa9e7b1406a..817065aa2833 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -195,7 +195,7 @@ static int offload_action_init(struct flow_offload_action *fl_action,
 	if (act->ops->offload_act_setup) {
 		spin_lock_bh(&act->tcfa_lock);
 		err = act->ops->offload_act_setup(act, fl_action, NULL,
-						  false);
+						  false, extack);
 		spin_unlock_bh(&act->tcfa_lock);
 		return err;
 	}
@@ -271,7 +271,7 @@ static int tcf_action_offload_add_ex(struct tc_action *action,
 	if (err)
 		goto fl_err;
 
-	err = tc_setup_action(&fl_action->action, actions);
+	err = tc_setup_action(&fl_action->action, actions, extack);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Failed to setup tc actions for offload");
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index e0f515b774ca..22847ee009ef 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -696,7 +696,8 @@ static size_t tcf_csum_get_fill_size(const struct tc_action *act)
 }
 
 static int tcf_csum_offload_act_setup(struct tc_action *act, void *entry_data,
-				      u32 *index_inc, bool bind)
+				      u32 *index_inc, bool bind,
+				      struct netlink_ext_ack *extack)
 {
 	if (bind) {
 		struct flow_action_entry *entry = entry_data;
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index b3ca837fd4e8..e013253b10d1 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1584,7 +1584,8 @@ static void tcf_stats_update(struct tc_action *a, u64 bytes, u64 packets,
 }
 
 static int tcf_ct_offload_act_setup(struct tc_action *act, void *entry_data,
-				    u32 *index_inc, bool bind)
+				    u32 *index_inc, bool bind,
+				    struct netlink_ext_ack *extack)
 {
 	if (bind) {
 		struct flow_action_entry *entry = entry_data;
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index bde6a6c01e64..db84a0473cc1 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -253,7 +253,8 @@ static size_t tcf_gact_get_fill_size(const struct tc_action *act)
 }
 
 static int tcf_gact_offload_act_setup(struct tc_action *act, void *entry_data,
-				      u32 *index_inc, bool bind)
+				      u32 *index_inc, bool bind,
+				      struct netlink_ext_ack *extack)
 {
 	if (bind) {
 		struct flow_action_entry *entry = entry_data;
diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index d56e73843a4b..fd5155274733 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -619,7 +619,8 @@ static int tcf_gate_get_entries(struct flow_action_entry *entry,
 }
 
 static int tcf_gate_offload_act_setup(struct tc_action *act, void *entry_data,
-				      u32 *index_inc, bool bind)
+				      u32 *index_inc, bool bind,
+				      struct netlink_ext_ack *extack)
 {
 	int err;
 
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 39acd1d18609..70a6a4447e6b 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -460,7 +460,8 @@ static void tcf_offload_mirred_get_dev(struct flow_action_entry *entry,
 }
 
 static int tcf_mirred_offload_act_setup(struct tc_action *act, void *entry_data,
-					u32 *index_inc, bool bind)
+					u32 *index_inc, bool bind,
+					struct netlink_ext_ack *extack)
 {
 	if (bind) {
 		struct flow_action_entry *entry = entry_data;
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index b9ff3459fdab..23fcfa5605df 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -385,7 +385,8 @@ static int tcf_mpls_search(struct net *net, struct tc_action **a, u32 index)
 }
 
 static int tcf_mpls_offload_act_setup(struct tc_action *act, void *entry_data,
-				      u32 *index_inc, bool bind)
+				      u32 *index_inc, bool bind,
+				      struct netlink_ext_ack *extack)
 {
 	if (bind) {
 		struct flow_action_entry *entry = entry_data;
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 211c757bfc3c..8fccc914f464 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -510,7 +510,8 @@ static int tcf_pedit_search(struct net *net, struct tc_action **a, u32 index)
 }
 
 static int tcf_pedit_offload_act_setup(struct tc_action *act, void *entry_data,
-				       u32 *index_inc, bool bind)
+				       u32 *index_inc, bool bind,
+				       struct netlink_ext_ack *extack)
 {
 	if (bind) {
 		struct flow_action_entry *entry = entry_data;
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index f4d917705263..77c17e9b46d1 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -442,7 +442,8 @@ static int tcf_police_act_to_flow_act(int tc_act, u32 *extval)
 }
 
 static int tcf_police_offload_act_setup(struct tc_action *act, void *entry_data,
-					u32 *index_inc, bool bind)
+					u32 *index_inc, bool bind,
+					struct netlink_ext_ack *extack)
 {
 	if (bind) {
 		struct flow_action_entry *entry = entry_data;
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 9a22cdda6bbd..2f7f5e44d28c 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -291,7 +291,8 @@ static void tcf_offload_sample_get_group(struct flow_action_entry *entry,
 }
 
 static int tcf_sample_offload_act_setup(struct tc_action *act, void *entry_data,
-					u32 *index_inc, bool bind)
+					u32 *index_inc, bool bind,
+					struct netlink_ext_ack *extack)
 {
 	if (bind) {
 		struct flow_action_entry *entry = entry_data;
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index ceba11b198bb..8cd8e506c9c9 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -328,7 +328,8 @@ static size_t tcf_skbedit_get_fill_size(const struct tc_action *act)
 }
 
 static int tcf_skbedit_offload_act_setup(struct tc_action *act, void *entry_data,
-					 u32 *index_inc, bool bind)
+					 u32 *index_inc, bool bind,
+					 struct netlink_ext_ack *extack)
 {
 	if (bind) {
 		struct flow_action_entry *entry = entry_data;
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 23aba03d26a8..3c6f40478c81 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -808,7 +808,8 @@ static int tcf_tunnel_encap_get_tunnel(struct flow_action_entry *entry,
 static int tcf_tunnel_key_offload_act_setup(struct tc_action *act,
 					    void *entry_data,
 					    u32 *index_inc,
-					    bool bind)
+					    bool bind,
+					    struct netlink_ext_ack *extack)
 {
 	int err;
 
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 883454c4f921..8c89bce99cbd 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -369,7 +369,8 @@ static size_t tcf_vlan_get_fill_size(const struct tc_action *act)
 }
 
 static int tcf_vlan_offload_act_setup(struct tc_action *act, void *entry_data,
-				      u32 *index_inc, bool bind)
+				      u32 *index_inc, bool bind,
+				      struct netlink_ext_ack *extack)
 {
 	if (bind) {
 		struct flow_action_entry *entry = entry_data;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index f0699f39afdb..2d4dc1468a9a 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3513,11 +3513,13 @@ EXPORT_SYMBOL(tc_cleanup_offload_action);
 
 static int tc_setup_offload_act(struct tc_action *act,
 				struct flow_action_entry *entry,
-				u32 *index_inc)
+				u32 *index_inc,
+				struct netlink_ext_ack *extack)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	if (act->ops->offload_act_setup)
-		return act->ops->offload_act_setup(act, entry, index_inc, true);
+		return act->ops->offload_act_setup(act, entry, index_inc, true,
+						   extack);
 	else
 		return -EOPNOTSUPP;
 #else
@@ -3526,7 +3528,8 @@ static int tc_setup_offload_act(struct tc_action *act,
 }
 
 int tc_setup_action(struct flow_action *flow_action,
-		    struct tc_action *actions[])
+		    struct tc_action *actions[],
+		    struct netlink_ext_ack *extack)
 {
 	int i, j, index, err = 0;
 	struct tc_action *act;
@@ -3551,7 +3554,7 @@ int tc_setup_action(struct flow_action *flow_action,
 		entry->hw_stats = tc_act_hw_stats(act->hw_stats);
 		entry->hw_index = act->tcfa_index;
 		index = 0;
-		err = tc_setup_offload_act(act, entry, &index);
+		err = tc_setup_offload_act(act, entry, &index, extack);
 		if (!err)
 			j += index;
 		else
@@ -3570,13 +3573,14 @@ int tc_setup_action(struct flow_action *flow_action,
 }
 
 int tc_setup_offload_action(struct flow_action *flow_action,
-			    const struct tcf_exts *exts)
+			    const struct tcf_exts *exts,
+			    struct netlink_ext_ack *extack)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	if (!exts)
 		return 0;
 
-	return tc_setup_action(flow_action, exts->actions);
+	return tc_setup_action(flow_action, exts->actions, extack);
 #else
 	return 0;
 #endif
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index ed5e6f08e74a..cddacf49f9e8 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -464,7 +464,8 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 	cls_flower.rule->match.key = &f->mkey;
 	cls_flower.classid = f->res.classid;
 
-	err = tc_setup_offload_action(&cls_flower.rule->action, &f->exts);
+	err = tc_setup_offload_action(&cls_flower.rule->action, &f->exts,
+				      cls_flower.common.extack);
 	if (err) {
 		kfree(cls_flower.rule);
 		if (skip_sw) {
@@ -2362,7 +2363,8 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 		cls_flower.rule->match.mask = &f->mask->key;
 		cls_flower.rule->match.key = &f->mkey;
 
-		err = tc_setup_offload_action(&cls_flower.rule->action, &f->exts);
+		err = tc_setup_offload_action(&cls_flower.rule->action, &f->exts,
+					      cls_flower.common.extack);
 		if (err) {
 			kfree(cls_flower.rule);
 			if (tc_skip_sw(f->flags)) {
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index ca5670fd5228..df80c6b185a0 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -97,7 +97,8 @@ static int mall_replace_hw_filter(struct tcf_proto *tp,
 	cls_mall.command = TC_CLSMATCHALL_REPLACE;
 	cls_mall.cookie = cookie;
 
-	err = tc_setup_offload_action(&cls_mall.rule->action, &head->exts);
+	err = tc_setup_offload_action(&cls_mall.rule->action, &head->exts,
+				      cls_mall.common.extack);
 	if (err) {
 		kfree(cls_mall.rule);
 		mall_destroy_hw_filter(tp, head, cookie, NULL);
@@ -302,7 +303,8 @@ static int mall_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 		TC_CLSMATCHALL_REPLACE : TC_CLSMATCHALL_DESTROY;
 	cls_mall.cookie = (unsigned long)head;
 
-	err = tc_setup_offload_action(&cls_mall.rule->action, &head->exts);
+	err = tc_setup_offload_action(&cls_mall.rule->action, &head->exts,
+				      cls_mall.common.extack);
 	if (err) {
 		kfree(cls_mall.rule);
 		if (add && tc_skip_sw(head->flags)) {
-- 
2.35.1



