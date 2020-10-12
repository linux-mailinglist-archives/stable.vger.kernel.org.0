Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3DE828B904
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390345AbgJLN44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:56:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389377AbgJLNnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:43:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C3592074F;
        Mon, 12 Oct 2020 13:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510222;
        bh=KozX3iQxwBsvpN3Lpv8XlZgsZ34Ah1+Yg9zMhjVo/Rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YBfPvrfPg4HWzJw1aq47rhTSCmCH2UqxUmZKDerJUQG6rhXWMVs9dVLA54npQj2HO
         MLSLRbCPtu3TSvrSKmRoK1CfYcxO+nOvZ4Zqa9Bu44DF0NyAtXfnvgFoDNoNV+eHd9
         94QLqNp7si1a7+CiQqPCQpdXjaLpbQApw+bJtaSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 84/85] net_sched: defer tcf_idr_insert() in tcf_action_init_1()
Date:   Mon, 12 Oct 2020 15:27:47 +0200
Message-Id: <20201012132636.868277335@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

commit e49d8c22f1261c43a986a7fdbf677ac309682a07 upstream.

All TC actions call tcf_idr_insert() for new action at the end
of their ->init(), so we can actually move it to a central place
in tcf_action_init_1().

And once the action is inserted into the global IDR, other parallel
process could free it immediately as its refcnt is still 1, so we can
not fail after this, we need to move it after the goto action
validation to avoid handling the failure case after insertion.

This is found during code review, is not directly triggered by syzbot.
And this prepares for the next patch.

Cc: Vlad Buslov <vladbu@mellanox.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/act_api.h      |    2 --
 net/sched/act_api.c        |   38 ++++++++++++++++++++------------------
 net/sched/act_bpf.c        |    4 +---
 net/sched/act_connmark.c   |    1 -
 net/sched/act_csum.c       |    3 ---
 net/sched/act_ct.c         |    2 --
 net/sched/act_ctinfo.c     |    3 ---
 net/sched/act_gact.c       |    2 --
 net/sched/act_ife.c        |    3 ---
 net/sched/act_ipt.c        |    2 --
 net/sched/act_mirred.c     |    2 --
 net/sched/act_mpls.c       |    2 --
 net/sched/act_nat.c        |    3 ---
 net/sched/act_pedit.c      |    2 --
 net/sched/act_police.c     |    2 --
 net/sched/act_sample.c     |    2 --
 net/sched/act_simple.c     |    2 --
 net/sched/act_skbedit.c    |    2 --
 net/sched/act_skbmod.c     |    2 --
 net/sched/act_tunnel_key.c |    3 ---
 net/sched/act_vlan.c       |    2 --
 21 files changed, 21 insertions(+), 63 deletions(-)

--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -156,8 +156,6 @@ int tcf_idr_search(struct tc_action_net
 int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
 		   struct tc_action **a, const struct tc_action_ops *ops,
 		   int bind, bool cpustats);
-void tcf_idr_insert(struct tc_action_net *tn, struct tc_action *a);
-
 void tcf_idr_cleanup(struct tc_action_net *tn, u32 index);
 int tcf_idr_check_alloc(struct tc_action_net *tn, u32 *index,
 			struct tc_action **a, int bind);
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -451,17 +451,6 @@ err1:
 }
 EXPORT_SYMBOL(tcf_idr_create);
 
-void tcf_idr_insert(struct tc_action_net *tn, struct tc_action *a)
-{
-	struct tcf_idrinfo *idrinfo = tn->idrinfo;
-
-	mutex_lock(&idrinfo->lock);
-	/* Replace ERR_PTR(-EBUSY) allocated by tcf_idr_check_alloc */
-	WARN_ON(!IS_ERR(idr_replace(&idrinfo->action_idr, a, a->tcfa_index)));
-	mutex_unlock(&idrinfo->lock);
-}
-EXPORT_SYMBOL(tcf_idr_insert);
-
 /* Cleanup idr index that was allocated but not initialized. */
 
 void tcf_idr_cleanup(struct tc_action_net *tn, u32 index)
@@ -839,6 +828,16 @@ static const struct nla_policy tcf_actio
 	[TCA_ACT_OPTIONS]	= { .type = NLA_NESTED },
 };
 
+static void tcf_idr_insert(struct tc_action *a)
+{
+	struct tcf_idrinfo *idrinfo = a->idrinfo;
+
+	mutex_lock(&idrinfo->lock);
+	/* Replace ERR_PTR(-EBUSY) allocated by tcf_idr_check_alloc */
+	WARN_ON(!IS_ERR(idr_replace(&idrinfo->action_idr, a, a->tcfa_index)));
+	mutex_unlock(&idrinfo->lock);
+}
+
 struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				    struct nlattr *nla, struct nlattr *est,
 				    char *name, int ovr, int bind,
@@ -921,6 +920,16 @@ struct tc_action *tcf_action_init_1(stru
 	if (err < 0)
 		goto err_mod;
 
+	if (TC_ACT_EXT_CMP(a->tcfa_action, TC_ACT_GOTO_CHAIN) &&
+	    !rcu_access_pointer(a->goto_chain)) {
+		tcf_action_destroy_1(a, bind);
+		NL_SET_ERR_MSG(extack, "can't use goto chain with NULL chain");
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (err == ACT_P_CREATED)
+		tcf_idr_insert(a);
+
 	if (!name && tb[TCA_ACT_COOKIE])
 		tcf_set_action_cookie(&a->act_cookie, cookie);
 
@@ -931,13 +940,6 @@ struct tc_action *tcf_action_init_1(stru
 	if (err != ACT_P_CREATED)
 		module_put(a_o->owner);
 
-	if (TC_ACT_EXT_CMP(a->tcfa_action, TC_ACT_GOTO_CHAIN) &&
-	    !rcu_access_pointer(a->goto_chain)) {
-		tcf_action_destroy_1(a, bind);
-		NL_SET_ERR_MSG(extack, "can't use goto chain with NULL chain");
-		return ERR_PTR(-EINVAL);
-	}
-
 	return a;
 
 err_mod:
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -361,9 +361,7 @@ static int tcf_bpf_init(struct net *net,
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 
-	if (res == ACT_P_CREATED) {
-		tcf_idr_insert(tn, *act);
-	} else {
+	if (res != ACT_P_CREATED) {
 		/* make sure the program being replaced is no longer executing */
 		synchronize_rcu();
 		tcf_bpf_cfg_cleanup(&old);
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -139,7 +139,6 @@ static int tcf_connmark_init(struct net
 		ci->net = net;
 		ci->zone = parm->zone;
 
-		tcf_idr_insert(tn, *a);
 		ret = ACT_P_CREATED;
 	} else if (ret > 0) {
 		ci = to_connmark(*a);
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -110,9 +110,6 @@ static int tcf_csum_init(struct net *net
 	if (params_new)
 		kfree_rcu(params_new, rcu);
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
-
 	return ret;
 put_chain:
 	if (goto_ch)
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -740,8 +740,6 @@ static int tcf_ct_init(struct net *net,
 		tcf_chain_put_by_act(goto_ch);
 	if (params)
 		call_rcu(&params->rcu, tcf_ct_params_free);
-	if (res == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
 
 	return res;
 
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -269,9 +269,6 @@ static int tcf_ctinfo_init(struct net *n
 	if (cp_new)
 		kfree_rcu(cp_new, rcu);
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
-
 	return ret;
 
 put_chain:
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -139,8 +139,6 @@ static int tcf_gact_init(struct net *net
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
 	return ret;
 release_idr:
 	tcf_idr_release(*a, bind);
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -626,9 +626,6 @@ static int tcf_ife_init(struct net *net,
 	if (p)
 		kfree_rcu(p, rcu);
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
-
 	return ret;
 metadata_parse_err:
 	if (goto_ch)
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -189,8 +189,6 @@ static int __tcf_ipt_init(struct net *ne
 	ipt->tcfi_t     = t;
 	ipt->tcfi_hook  = hook;
 	spin_unlock_bh(&ipt->tcf_lock);
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
 	return ret;
 
 err3:
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -194,8 +194,6 @@ static int tcf_mirred_init(struct net *n
 		spin_lock(&mirred_list_lock);
 		list_add(&m->tcfm_list, &mirred_list);
 		spin_unlock(&mirred_list_lock);
-
-		tcf_idr_insert(tn, *a);
 	}
 
 	return ret;
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -273,8 +273,6 @@ static int tcf_mpls_init(struct net *net
 	if (p)
 		kfree_rcu(p, rcu);
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
 	return ret;
 put_chain:
 	if (goto_ch)
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -93,9 +93,6 @@ static int tcf_nat_init(struct net *net,
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
-
 	return ret;
 release_idr:
 	tcf_idr_release(*a, bind);
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -237,8 +237,6 @@ static int tcf_pedit_init(struct net *ne
 	spin_unlock_bh(&p->tcf_lock);
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
 	return ret;
 
 put_chain:
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -201,8 +201,6 @@ static int tcf_police_init(struct net *n
 	if (new)
 		kfree_rcu(new, rcu);
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
 	return ret;
 
 failure:
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -116,8 +116,6 @@ static int tcf_sample_init(struct net *n
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
 	return ret;
 put_chain:
 	if (goto_ch)
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -156,8 +156,6 @@ static int tcf_simp_init(struct net *net
 			goto release_idr;
 	}
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
 	return ret;
 put_chain:
 	if (goto_ch)
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -214,8 +214,6 @@ static int tcf_skbedit_init(struct net *
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
 	return ret;
 put_chain:
 	if (goto_ch)
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -190,8 +190,6 @@ static int tcf_skbmod_init(struct net *n
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
 	return ret;
 put_chain:
 	if (goto_ch)
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -392,9 +392,6 @@ static int tunnel_key_init(struct net *n
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
-
 	return ret;
 
 put_chain:
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -228,8 +228,6 @@ static int tcf_vlan_init(struct net *net
 	if (p)
 		kfree_rcu(p, rcu);
 
-	if (ret == ACT_P_CREATED)
-		tcf_idr_insert(tn, *a);
 	return ret;
 put_chain:
 	if (goto_ch)


