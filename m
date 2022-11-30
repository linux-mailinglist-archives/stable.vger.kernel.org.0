Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0067663DE83
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiK3Shy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbiK3Shr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:37:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4945793A6C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:37:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC3D661D74
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8CADC433C1;
        Wed, 30 Nov 2022 18:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833450;
        bh=wL1xaC113PvE2J5w+3W6BPgUrjjX3ocirXkapXJrH38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vDgTPxI7MIKJSZWlkr9yAEFUs9dzOVqY+OQ6XhyJuPwjF4EiOyIPJzgW1d6FrgNwW
         9fDp5/8xH/chuRd9Td1kFhEx3FKZ0i4YSa14/vCl0u1foorVq8PnRxvBCsQOw2nnEs
         koNSSVB394yRX0r2UfWTa+BTSTtLKJ253tj2DqR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daniel Xu <dxu@dxuuu.xyz>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/206] netfilter: conntrack: Fix data-races around ct mark
Date:   Wed, 30 Nov 2022 19:22:14 +0100
Message-Id: <20221130180535.088144105@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Xu <dxu@dxuuu.xyz>

[ Upstream commit 52d1aa8b8249ff477aaa38b6f74a8ced780d079c ]

nf_conn:mark can be read from and written to in parallel. Use
READ_ONCE()/WRITE_ONCE() for reads and writes to prevent unwanted
compiler optimizations.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c               |  2 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c      |  4 ++--
 net/netfilter/nf_conntrack_core.c       |  2 +-
 net/netfilter/nf_conntrack_netlink.c    | 24 ++++++++++++++----------
 net/netfilter/nf_conntrack_standalone.c |  2 +-
 net/netfilter/nft_ct.c                  |  6 +++---
 net/netfilter/xt_connmark.c             | 18 ++++++++++--------
 net/openvswitch/conntrack.c             |  8 ++++----
 net/sched/act_connmark.c                |  4 ++--
 net/sched/act_ct.c                      |  8 ++++----
 net/sched/act_ctinfo.c                  |  6 +++---
 11 files changed, 45 insertions(+), 39 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 1c34e2266578..1d230f041386 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -270,7 +270,7 @@ skb_flow_dissect_ct(const struct sk_buff *skb,
 	key->ct_zone = ct->zone.id;
 #endif
 #if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
-	key->ct_mark = ct->mark;
+	key->ct_mark = READ_ONCE(ct->mark);
 #endif
 
 	cl = nf_ct_labels_find(ct);
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index b518f20c9a24..34737b1d6526 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -435,7 +435,7 @@ clusterip_tg(struct sk_buff *skb, const struct xt_action_param *par)
 
 	switch (ctinfo) {
 	case IP_CT_NEW:
-		ct->mark = hash;
+		WRITE_ONCE(ct->mark, hash);
 		break;
 	case IP_CT_RELATED:
 	case IP_CT_RELATED_REPLY:
@@ -452,7 +452,7 @@ clusterip_tg(struct sk_buff *skb, const struct xt_action_param *par)
 #ifdef DEBUG
 	nf_ct_dump_tuple_ip(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 #endif
-	pr_debug("hash=%u ct_hash=%u ", hash, ct->mark);
+	pr_debug("hash=%u ct_hash=%u ", hash, READ_ONCE(ct->mark));
 	if (!clusterip_responsible(cipinfo->config, hash)) {
 		pr_debug("not responsible\n");
 		return NF_DROP;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 9da5ee6c50cd..43ea8cfd374b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1735,7 +1735,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 			}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-			ct->mark = exp->master->mark;
+			ct->mark = READ_ONCE(exp->master->mark);
 #endif
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
 			ct->secmark = exp->master->secmark;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index ef0a78aa9ba9..1727a4c4764f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -322,9 +322,9 @@ ctnetlink_dump_timestamp(struct sk_buff *skb, const struct nf_conn *ct)
 }
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
+static int ctnetlink_dump_mark(struct sk_buff *skb, u32 mark)
 {
-	if (nla_put_be32(skb, CTA_MARK, htonl(ct->mark)))
+	if (nla_put_be32(skb, CTA_MARK, htonl(mark)))
 		goto nla_put_failure;
 	return 0;
 
@@ -537,7 +537,7 @@ static int ctnetlink_dump_extinfo(struct sk_buff *skb,
 static int ctnetlink_dump_info(struct sk_buff *skb, struct nf_conn *ct)
 {
 	if (ctnetlink_dump_status(skb, ct) < 0 ||
-	    ctnetlink_dump_mark(skb, ct) < 0 ||
+	    ctnetlink_dump_mark(skb, READ_ONCE(ct->mark)) < 0 ||
 	    ctnetlink_dump_secctx(skb, ct) < 0 ||
 	    ctnetlink_dump_id(skb, ct) < 0 ||
 	    ctnetlink_dump_use(skb, ct) < 0 ||
@@ -716,6 +716,7 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
 	struct sk_buff *skb;
 	unsigned int type;
 	unsigned int flags = 0, group;
+	u32 mark;
 	int err;
 
 	if (events & (1 << IPCT_DESTROY)) {
@@ -820,8 +821,9 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
 	}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if ((events & (1 << IPCT_MARK) || ct->mark)
-	    && ctnetlink_dump_mark(skb, ct) < 0)
+	mark = READ_ONCE(ct->mark);
+	if ((events & (1 << IPCT_MARK) || mark) &&
+	    ctnetlink_dump_mark(skb, mark) < 0)
 		goto nla_put_failure;
 #endif
 	nlmsg_end(skb, nlh);
@@ -1148,7 +1150,7 @@ static int ctnetlink_filter_match(struct nf_conn *ct, void *data)
 	}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if ((ct->mark & filter->mark.mask) != filter->mark.val)
+	if ((READ_ONCE(ct->mark) & filter->mark.mask) != filter->mark.val)
 		goto ignore_entry;
 #endif
 	status = (u32)READ_ONCE(ct->status);
@@ -2016,9 +2018,9 @@ static void ctnetlink_change_mark(struct nf_conn *ct,
 		mask = ~ntohl(nla_get_be32(cda[CTA_MARK_MASK]));
 
 	mark = ntohl(nla_get_be32(cda[CTA_MARK]));
-	newmark = (ct->mark & mask) ^ mark;
-	if (newmark != ct->mark)
-		ct->mark = newmark;
+	newmark = (READ_ONCE(ct->mark) & mask) ^ mark;
+	if (newmark != READ_ONCE(ct->mark))
+		WRITE_ONCE(ct->mark, newmark);
 }
 #endif
 
@@ -2690,6 +2692,7 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 {
 	const struct nf_conntrack_zone *zone;
 	struct nlattr *nest_parms;
+	u32 mark;
 
 	zone = nf_ct_zone(ct);
 
@@ -2751,7 +2754,8 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 		goto nla_put_failure;
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if (ct->mark && ctnetlink_dump_mark(skb, ct) < 0)
+	mark = READ_ONCE(ct->mark);
+	if (mark && ctnetlink_dump_mark(skb, mark) < 0)
 		goto nla_put_failure;
 #endif
 	if (ctnetlink_dump_labels(skb, ct) < 0)
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 55aa55b252b2..4d85368203e0 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -363,7 +363,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 		goto release;
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
-	seq_printf(s, "mark=%u ", ct->mark);
+	seq_printf(s, "mark=%u ", READ_ONCE(ct->mark));
 #endif
 
 	ct_show_secctx(s, ct);
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 9c7472af9e4a..bd468e955a21 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -97,7 +97,7 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 		return;
 #ifdef CONFIG_NF_CONNTRACK_MARK
 	case NFT_CT_MARK:
-		*dest = ct->mark;
+		*dest = READ_ONCE(ct->mark);
 		return;
 #endif
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
@@ -296,8 +296,8 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
 	switch (priv->key) {
 #ifdef CONFIG_NF_CONNTRACK_MARK
 	case NFT_CT_MARK:
-		if (ct->mark != value) {
-			ct->mark = value;
+		if (READ_ONCE(ct->mark) != value) {
+			WRITE_ONCE(ct->mark, value);
 			nf_conntrack_event_cache(IPCT_MARK, ct);
 		}
 		break;
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index e5ebc0810675..ad3c033db64e 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -30,6 +30,7 @@ connmark_tg_shift(struct sk_buff *skb, const struct xt_connmark_tginfo2 *info)
 	u_int32_t new_targetmark;
 	struct nf_conn *ct;
 	u_int32_t newmark;
+	u_int32_t oldmark;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (ct == NULL)
@@ -37,14 +38,15 @@ connmark_tg_shift(struct sk_buff *skb, const struct xt_connmark_tginfo2 *info)
 
 	switch (info->mode) {
 	case XT_CONNMARK_SET:
-		newmark = (ct->mark & ~info->ctmask) ^ info->ctmark;
+		oldmark = READ_ONCE(ct->mark);
+		newmark = (oldmark & ~info->ctmask) ^ info->ctmark;
 		if (info->shift_dir == D_SHIFT_RIGHT)
 			newmark >>= info->shift_bits;
 		else
 			newmark <<= info->shift_bits;
 
-		if (ct->mark != newmark) {
-			ct->mark = newmark;
+		if (READ_ONCE(ct->mark) != newmark) {
+			WRITE_ONCE(ct->mark, newmark);
 			nf_conntrack_event_cache(IPCT_MARK, ct);
 		}
 		break;
@@ -55,15 +57,15 @@ connmark_tg_shift(struct sk_buff *skb, const struct xt_connmark_tginfo2 *info)
 		else
 			new_targetmark <<= info->shift_bits;
 
-		newmark = (ct->mark & ~info->ctmask) ^
+		newmark = (READ_ONCE(ct->mark) & ~info->ctmask) ^
 			  new_targetmark;
-		if (ct->mark != newmark) {
-			ct->mark = newmark;
+		if (READ_ONCE(ct->mark) != newmark) {
+			WRITE_ONCE(ct->mark, newmark);
 			nf_conntrack_event_cache(IPCT_MARK, ct);
 		}
 		break;
 	case XT_CONNMARK_RESTORE:
-		new_targetmark = (ct->mark & info->ctmask);
+		new_targetmark = (READ_ONCE(ct->mark) & info->ctmask);
 		if (info->shift_dir == D_SHIFT_RIGHT)
 			new_targetmark >>= info->shift_bits;
 		else
@@ -126,7 +128,7 @@ connmark_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	if (ct == NULL)
 		return false;
 
-	return ((ct->mark & info->mask) == info->mark) ^ info->invert;
+	return ((READ_ONCE(ct->mark) & info->mask) == info->mark) ^ info->invert;
 }
 
 static int connmark_mt_check(const struct xt_mtchk_param *par)
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index dc86f03309c1..7106ce231a2d 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -150,7 +150,7 @@ static u8 ovs_ct_get_state(enum ip_conntrack_info ctinfo)
 static u32 ovs_ct_get_mark(const struct nf_conn *ct)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
-	return ct ? ct->mark : 0;
+	return ct ? READ_ONCE(ct->mark) : 0;
 #else
 	return 0;
 #endif
@@ -338,9 +338,9 @@ static int ovs_ct_set_mark(struct nf_conn *ct, struct sw_flow_key *key,
 #if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
 	u32 new_mark;
 
-	new_mark = ct_mark | (ct->mark & ~(mask));
-	if (ct->mark != new_mark) {
-		ct->mark = new_mark;
+	new_mark = ct_mark | (READ_ONCE(ct->mark) & ~(mask));
+	if (READ_ONCE(ct->mark) != new_mark) {
+		WRITE_ONCE(ct->mark, new_mark);
 		if (nf_ct_is_confirmed(ct))
 			nf_conntrack_event_cache(IPCT_MARK, ct);
 		key->ct.mark = new_mark;
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 94e78ac7a748..032ef927d0eb 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -62,7 +62,7 @@ static int tcf_connmark_act(struct sk_buff *skb, const struct tc_action *a,
 
 	c = nf_ct_get(skb, &ctinfo);
 	if (c) {
-		skb->mark = c->mark;
+		skb->mark = READ_ONCE(c->mark);
 		/* using overlimits stats to count how many packets marked */
 		ca->tcf_qstats.overlimits++;
 		goto out;
@@ -82,7 +82,7 @@ static int tcf_connmark_act(struct sk_buff *skb, const struct tc_action *a,
 	c = nf_ct_tuplehash_to_ctrack(thash);
 	/* using overlimits stats to count how many packets marked */
 	ca->tcf_qstats.overlimits++;
-	skb->mark = c->mark;
+	skb->mark = READ_ONCE(c->mark);
 	nf_ct_put(c);
 
 out:
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index d85fdefe5730..81a2d6cbfb44 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -177,7 +177,7 @@ static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
 	entry = tcf_ct_flow_table_flow_action_get_next(action);
 	entry->id = FLOW_ACTION_CT_METADATA;
 #if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
-	entry->ct_metadata.mark = ct->mark;
+	entry->ct_metadata.mark = READ_ONCE(ct->mark);
 #endif
 	ctinfo = dir == IP_CT_DIR_ORIGINAL ? IP_CT_ESTABLISHED :
 					     IP_CT_ESTABLISHED_REPLY;
@@ -856,9 +856,9 @@ static void tcf_ct_act_set_mark(struct nf_conn *ct, u32 mark, u32 mask)
 	if (!mask)
 		return;
 
-	new_mark = mark | (ct->mark & ~(mask));
-	if (ct->mark != new_mark) {
-		ct->mark = new_mark;
+	new_mark = mark | (READ_ONCE(ct->mark) & ~(mask));
+	if (READ_ONCE(ct->mark) != new_mark) {
+		WRITE_ONCE(ct->mark, new_mark);
 		if (nf_ct_is_confirmed(ct))
 			nf_conntrack_event_cache(IPCT_MARK, ct);
 	}
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 549374a2d008..2d75fe1223ac 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -33,7 +33,7 @@ static void tcf_ctinfo_dscp_set(struct nf_conn *ct, struct tcf_ctinfo *ca,
 {
 	u8 dscp, newdscp;
 
-	newdscp = (((ct->mark & cp->dscpmask) >> cp->dscpmaskshift) << 2) &
+	newdscp = (((READ_ONCE(ct->mark) & cp->dscpmask) >> cp->dscpmaskshift) << 2) &
 		     ~INET_ECN_MASK;
 
 	switch (proto) {
@@ -73,7 +73,7 @@ static void tcf_ctinfo_cpmark_set(struct nf_conn *ct, struct tcf_ctinfo *ca,
 				  struct sk_buff *skb)
 {
 	ca->stats_cpmark_set++;
-	skb->mark = ct->mark & cp->cpmarkmask;
+	skb->mark = READ_ONCE(ct->mark) & cp->cpmarkmask;
 }
 
 static int tcf_ctinfo_act(struct sk_buff *skb, const struct tc_action *a,
@@ -131,7 +131,7 @@ static int tcf_ctinfo_act(struct sk_buff *skb, const struct tc_action *a,
 	}
 
 	if (cp->mode & CTINFO_MODE_DSCP)
-		if (!cp->dscpstatemask || (ct->mark & cp->dscpstatemask))
+		if (!cp->dscpstatemask || (READ_ONCE(ct->mark) & cp->dscpstatemask))
 			tcf_ctinfo_dscp_set(ct, ca, cp, skb, wlen, proto);
 
 	if (cp->mode & CTINFO_MODE_CPMARK)
-- 
2.35.1



