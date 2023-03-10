Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664816B42F4
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbjCJOJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbjCJOIq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:08:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640555FEB1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:08:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5558B822DD
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E19C433D2;
        Fri, 10 Mar 2023 14:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457291;
        bh=hZ8YZx3Rf3OBelyY6fYcZ/atUZ0qlzVso/YVt1FOXnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8PTv/dyo04hre0qpvbNMjpIs5yvffci41p2+J8ZHO5nnrdmUplF0o5QMnG8mjOkb
         1a43vyVVxKG1tVG9SKAOxXp0icrtWeAMwpsArMiF2NlRo/JhsBP+sk+NDcop5lWPVN
         DOUgZyWdUUCJNLzfhblT6h/hIUsdZSmivIws0ubE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jamal Hadi Salim <jhs@mojatatu.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/200] net/sched: transition act_pedit to rcu and percpu stats
Date:   Fri, 10 Mar 2023 14:38:13 +0100
Message-Id: <20230310133719.742732900@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit 52cf89f78c01bf39973f3e70d366921d70faff7a ]

The software pedit action didn't get the same love as some of the
other actions and it's still using spinlocks and shared stats in the
datapath.
Transition the action to rcu and percpu stats as this improves the
action's performance dramatically on multiple cpu deployments.

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: e9e42292ea76 ("net/sched: act_pedit: fix action bind logic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tc_act/tc_pedit.h |  81 +++++++++++++++----
 net/sched/act_pedit.c         | 148 ++++++++++++++++++++--------------
 2 files changed, 153 insertions(+), 76 deletions(-)

diff --git a/include/net/tc_act/tc_pedit.h b/include/net/tc_act/tc_pedit.h
index 3e02709a1df65..83fe399317818 100644
--- a/include/net/tc_act/tc_pedit.h
+++ b/include/net/tc_act/tc_pedit.h
@@ -4,22 +4,29 @@
 
 #include <net/act_api.h>
 #include <linux/tc_act/tc_pedit.h>
+#include <linux/types.h>
 
 struct tcf_pedit_key_ex {
 	enum pedit_header_type htype;
 	enum pedit_cmd cmd;
 };
 
-struct tcf_pedit {
-	struct tc_action	common;
-	unsigned char		tcfp_nkeys;
-	unsigned char		tcfp_flags;
-	u32			tcfp_off_max_hint;
+struct tcf_pedit_parms {
 	struct tc_pedit_key	*tcfp_keys;
 	struct tcf_pedit_key_ex	*tcfp_keys_ex;
+	u32 tcfp_off_max_hint;
+	unsigned char tcfp_nkeys;
+	unsigned char tcfp_flags;
+	struct rcu_head rcu;
+};
+
+struct tcf_pedit {
+	struct tc_action common;
+	struct tcf_pedit_parms __rcu *parms;
 };
 
 #define to_pedit(a) ((struct tcf_pedit *)a)
+#define to_pedit_parms(a) (rcu_dereference(to_pedit(a)->parms))
 
 static inline bool is_tcf_pedit(const struct tc_action *a)
 {
@@ -32,37 +39,81 @@ static inline bool is_tcf_pedit(const struct tc_action *a)
 
 static inline int tcf_pedit_nkeys(const struct tc_action *a)
 {
-	return to_pedit(a)->tcfp_nkeys;
+	struct tcf_pedit_parms *parms;
+	int nkeys;
+
+	rcu_read_lock();
+	parms = to_pedit_parms(a);
+	nkeys = parms->tcfp_nkeys;
+	rcu_read_unlock();
+
+	return nkeys;
 }
 
 static inline u32 tcf_pedit_htype(const struct tc_action *a, int index)
 {
-	if (to_pedit(a)->tcfp_keys_ex)
-		return to_pedit(a)->tcfp_keys_ex[index].htype;
+	u32 htype = TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK;
+	struct tcf_pedit_parms *parms;
+
+	rcu_read_lock();
+	parms = to_pedit_parms(a);
+	if (parms->tcfp_keys_ex)
+		htype = parms->tcfp_keys_ex[index].htype;
+	rcu_read_unlock();
 
-	return TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK;
+	return htype;
 }
 
 static inline u32 tcf_pedit_cmd(const struct tc_action *a, int index)
 {
-	if (to_pedit(a)->tcfp_keys_ex)
-		return to_pedit(a)->tcfp_keys_ex[index].cmd;
+	struct tcf_pedit_parms *parms;
+	u32 cmd = __PEDIT_CMD_MAX;
 
-	return __PEDIT_CMD_MAX;
+	rcu_read_lock();
+	parms = to_pedit_parms(a);
+	if (parms->tcfp_keys_ex)
+		cmd = parms->tcfp_keys_ex[index].cmd;
+	rcu_read_unlock();
+
+	return cmd;
 }
 
 static inline u32 tcf_pedit_mask(const struct tc_action *a, int index)
 {
-	return to_pedit(a)->tcfp_keys[index].mask;
+	struct tcf_pedit_parms *parms;
+	u32 mask;
+
+	rcu_read_lock();
+	parms = to_pedit_parms(a);
+	mask = parms->tcfp_keys[index].mask;
+	rcu_read_unlock();
+
+	return mask;
 }
 
 static inline u32 tcf_pedit_val(const struct tc_action *a, int index)
 {
-	return to_pedit(a)->tcfp_keys[index].val;
+	struct tcf_pedit_parms *parms;
+	u32 val;
+
+	rcu_read_lock();
+	parms = to_pedit_parms(a);
+	val = parms->tcfp_keys[index].val;
+	rcu_read_unlock();
+
+	return val;
 }
 
 static inline u32 tcf_pedit_offset(const struct tc_action *a, int index)
 {
-	return to_pedit(a)->tcfp_keys[index].off;
+	struct tcf_pedit_parms *parms;
+	u32 off;
+
+	rcu_read_lock();
+	parms = to_pedit_parms(a);
+	off = parms->tcfp_keys[index].off;
+	rcu_read_unlock();
+
+	return off;
 }
 #endif /* __NET_TC_PED_H */
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 94ed5857ce678..655addb31b7f3 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -133,6 +133,17 @@ static int tcf_pedit_key_ex_dump(struct sk_buff *skb,
 	return -EINVAL;
 }
 
+static void tcf_pedit_cleanup_rcu(struct rcu_head *head)
+{
+	struct tcf_pedit_parms *parms =
+		container_of(head, struct tcf_pedit_parms, rcu);
+
+	kfree(parms->tcfp_keys_ex);
+	kfree(parms->tcfp_keys);
+
+	kfree(parms);
+}
+
 static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 			  struct nlattr *est, struct tc_action **a,
 			  struct tcf_proto *tp, u32 flags,
@@ -140,10 +151,9 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 {
 	struct tc_action_net *tn = net_generic(net, act_pedit_ops.net_id);
 	bool bind = flags & TCA_ACT_FLAGS_BIND;
-	struct nlattr *tb[TCA_PEDIT_MAX + 1];
 	struct tcf_chain *goto_ch = NULL;
-	struct tc_pedit_key *keys = NULL;
-	struct tcf_pedit_key_ex *keys_ex;
+	struct tcf_pedit_parms *oparms, *nparms;
+	struct nlattr *tb[TCA_PEDIT_MAX + 1];
 	struct tc_pedit *parm;
 	struct nlattr *pattr;
 	struct tcf_pedit *p;
@@ -180,18 +190,25 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 		return -EINVAL;
 	}
 
-	keys_ex = tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys);
-	if (IS_ERR(keys_ex))
-		return PTR_ERR(keys_ex);
+	nparms = kzalloc(sizeof(*nparms), GFP_KERNEL);
+	if (!nparms)
+		return -ENOMEM;
+
+	nparms->tcfp_keys_ex =
+		tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys);
+	if (IS_ERR(nparms->tcfp_keys_ex)) {
+		ret = PTR_ERR(nparms->tcfp_keys_ex);
+		goto out_free;
+	}
 
 	index = parm->index;
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
-		ret = tcf_idr_create(tn, index, est, a,
-				     &act_pedit_ops, bind, false, flags);
+		ret = tcf_idr_create_from_flags(tn, index, est, a,
+						&act_pedit_ops, bind, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
-			goto out_free;
+			goto out_free_ex;
 		}
 		ret = ACT_P_CREATED;
 	} else if (err > 0) {
@@ -203,7 +220,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 		}
 	} else {
 		ret = err;
-		goto out_free;
+		goto out_free_ex;
 	}
 
 	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
@@ -211,48 +228,50 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 		ret = err;
 		goto out_release;
 	}
-	p = to_pedit(*a);
-	spin_lock_bh(&p->tcf_lock);
 
-	if (ret == ACT_P_CREATED ||
-	    (p->tcfp_nkeys && p->tcfp_nkeys != parm->nkeys)) {
-		keys = kmalloc(ksize, GFP_ATOMIC);
-		if (!keys) {
-			spin_unlock_bh(&p->tcf_lock);
-			ret = -ENOMEM;
-			goto put_chain;
-		}
-		kfree(p->tcfp_keys);
-		p->tcfp_keys = keys;
-		p->tcfp_nkeys = parm->nkeys;
+	nparms->tcfp_off_max_hint = 0;
+	nparms->tcfp_flags = parm->flags;
+	nparms->tcfp_nkeys = parm->nkeys;
+
+	nparms->tcfp_keys = kmalloc(ksize, GFP_KERNEL);
+	if (!nparms->tcfp_keys) {
+		ret = -ENOMEM;
+		goto put_chain;
 	}
-	memcpy(p->tcfp_keys, parm->keys, ksize);
-	p->tcfp_off_max_hint = 0;
-	for (i = 0; i < p->tcfp_nkeys; ++i) {
-		u32 cur = p->tcfp_keys[i].off;
+
+	memcpy(nparms->tcfp_keys, parm->keys, ksize);
+
+	for (i = 0; i < nparms->tcfp_nkeys; ++i) {
+		u32 cur = nparms->tcfp_keys[i].off;
 
 		/* sanitize the shift value for any later use */
-		p->tcfp_keys[i].shift = min_t(size_t, BITS_PER_TYPE(int) - 1,
-					      p->tcfp_keys[i].shift);
+		nparms->tcfp_keys[i].shift = min_t(size_t,
+						   BITS_PER_TYPE(int) - 1,
+						   nparms->tcfp_keys[i].shift);
 
 		/* The AT option can read a single byte, we can bound the actual
 		 * value with uchar max.
 		 */
-		cur += (0xff & p->tcfp_keys[i].offmask) >> p->tcfp_keys[i].shift;
+		cur += (0xff & nparms->tcfp_keys[i].offmask) >> nparms->tcfp_keys[i].shift;
 
 		/* Each key touches 4 bytes starting from the computed offset */
-		p->tcfp_off_max_hint = max(p->tcfp_off_max_hint, cur + 4);
+		nparms->tcfp_off_max_hint =
+			max(nparms->tcfp_off_max_hint, cur + 4);
 	}
 
-	p->tcfp_flags = parm->flags;
+	p = to_pedit(*a);
+
+	spin_lock_bh(&p->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
+	oparms = rcu_replace_pointer(p->parms, nparms, 1);
+	spin_unlock_bh(&p->tcf_lock);
 
-	kfree(p->tcfp_keys_ex);
-	p->tcfp_keys_ex = keys_ex;
+	if (oparms)
+		call_rcu(&oparms->rcu, tcf_pedit_cleanup_rcu);
 
-	spin_unlock_bh(&p->tcf_lock);
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
+
 	return ret;
 
 put_chain:
@@ -260,19 +279,22 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 		tcf_chain_put_by_act(goto_ch);
 out_release:
 	tcf_idr_release(*a, bind);
+out_free_ex:
+	kfree(nparms->tcfp_keys_ex);
 out_free:
-	kfree(keys_ex);
+	kfree(nparms);
 	return ret;
-
 }
 
 static void tcf_pedit_cleanup(struct tc_action *a)
 {
 	struct tcf_pedit *p = to_pedit(a);
-	struct tc_pedit_key *keys = p->tcfp_keys;
+	struct tcf_pedit_parms *parms;
 
-	kfree(keys);
-	kfree(p->tcfp_keys_ex);
+	parms = rcu_dereference_protected(p->parms, 1);
+
+	if (parms)
+		call_rcu(&parms->rcu, tcf_pedit_cleanup_rcu);
 }
 
 static bool offset_valid(struct sk_buff *skb, int offset)
@@ -323,28 +345,30 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
 			 struct tcf_result *res)
 {
 	struct tcf_pedit *p = to_pedit(a);
+	struct tcf_pedit_parms *parms;
 	u32 max_offset;
 	int i;
 
-	spin_lock(&p->tcf_lock);
+	parms = rcu_dereference_bh(p->parms);
 
 	max_offset = (skb_transport_header_was_set(skb) ?
 		      skb_transport_offset(skb) :
 		      skb_network_offset(skb)) +
-		     p->tcfp_off_max_hint;
+		     parms->tcfp_off_max_hint;
 	if (skb_ensure_writable(skb, min(skb->len, max_offset)))
-		goto unlock;
+		goto done;
 
 	tcf_lastuse_update(&p->tcf_tm);
+	tcf_action_update_bstats(&p->common, skb);
 
-	if (p->tcfp_nkeys > 0) {
-		struct tc_pedit_key *tkey = p->tcfp_keys;
-		struct tcf_pedit_key_ex *tkey_ex = p->tcfp_keys_ex;
+	if (parms->tcfp_nkeys > 0) {
+		struct tc_pedit_key *tkey = parms->tcfp_keys;
+		struct tcf_pedit_key_ex *tkey_ex = parms->tcfp_keys_ex;
 		enum pedit_header_type htype =
 			TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK;
 		enum pedit_cmd cmd = TCA_PEDIT_KEY_EX_CMD_SET;
 
-		for (i = p->tcfp_nkeys; i > 0; i--, tkey++) {
+		for (i = parms->tcfp_nkeys; i > 0; i--, tkey++) {
 			u32 *ptr, hdata;
 			int offset = tkey->off;
 			int hoffset;
@@ -420,11 +444,10 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
 	}
 
 bad:
+	spin_lock(&p->tcf_lock);
 	p->tcf_qstats.overlimits++;
-done:
-	bstats_update(&p->tcf_bstats, skb);
-unlock:
 	spin_unlock(&p->tcf_lock);
+done:
 	return p->tcf_action;
 }
 
@@ -443,30 +466,33 @@ static int tcf_pedit_dump(struct sk_buff *skb, struct tc_action *a,
 {
 	unsigned char *b = skb_tail_pointer(skb);
 	struct tcf_pedit *p = to_pedit(a);
+	struct tcf_pedit_parms *parms;
 	struct tc_pedit *opt;
 	struct tcf_t t;
 	int s;
 
-	s = struct_size(opt, keys, p->tcfp_nkeys);
+	spin_lock_bh(&p->tcf_lock);
+	parms = rcu_dereference_protected(p->parms, 1);
+	s = struct_size(opt, keys, parms->tcfp_nkeys);
 
-	/* netlink spinlocks held above us - must use ATOMIC */
 	opt = kzalloc(s, GFP_ATOMIC);
-	if (unlikely(!opt))
+	if (unlikely(!opt)) {
+		spin_unlock_bh(&p->tcf_lock);
 		return -ENOBUFS;
+	}
 
-	spin_lock_bh(&p->tcf_lock);
-	memcpy(opt->keys, p->tcfp_keys, flex_array_size(opt, keys, p->tcfp_nkeys));
+	memcpy(opt->keys, parms->tcfp_keys,
+	       flex_array_size(opt, keys, parms->tcfp_nkeys));
 	opt->index = p->tcf_index;
-	opt->nkeys = p->tcfp_nkeys;
-	opt->flags = p->tcfp_flags;
+	opt->nkeys = parms->tcfp_nkeys;
+	opt->flags = parms->tcfp_flags;
 	opt->action = p->tcf_action;
 	opt->refcnt = refcount_read(&p->tcf_refcnt) - ref;
 	opt->bindcnt = atomic_read(&p->tcf_bindcnt) - bind;
 
-	if (p->tcfp_keys_ex) {
-		if (tcf_pedit_key_ex_dump(skb,
-					  p->tcfp_keys_ex,
-					  p->tcfp_nkeys))
+	if (parms->tcfp_keys_ex) {
+		if (tcf_pedit_key_ex_dump(skb, parms->tcfp_keys_ex,
+					  parms->tcfp_nkeys))
 			goto nla_put_failure;
 
 		if (nla_put(skb, TCA_PEDIT_PARMS_EX, s, opt))
-- 
2.39.2



