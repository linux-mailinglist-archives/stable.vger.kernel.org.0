Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD27869A4
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404514AbfHHTJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:09:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404670AbfHHTJV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:09:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5126321874;
        Thu,  8 Aug 2019 19:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291359;
        bh=ilvKKxKL7Cm2Zc9zsp/EPLvBxp+r61MY/fUXLqbT1Us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l8p/u9nLN6MCms1TwrryGrEvwmAGCVat5XNvh/1tkC/qEUXjWddvv6zmp8W4rC+wM
         QhBTHD1Cude/fHKmu4ytaLfi6P2H3yw0pu/xJxqxaBxB6Uzuz3dFju//fYQHTqaQdn
         WgcW/5hlbVp6chQMCzzrw3eTv55GbbJGpK3tIQsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmytro Linkin <dmitrolin@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 30/45] net: sched: use temporary variable for actions indexes
Date:   Thu,  8 Aug 2019 21:05:16 +0200
Message-Id: <20190808190455.440274706@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.827571908@linuxfoundation.org>
References: <20190808190453.827571908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmytro Linkin <dmitrolin@mellanox.com>

[ Upstream commit 7be8ef2cdbfe41a2e524b7c6cc3f8e6cfaa906e4 ]

Currently init call of all actions (except ipt) init their 'parm'
structure as a direct pointer to nla data in skb. This leads to race
condition when some of the filter actions were initialized successfully
(and were assigned with idr action index that was written directly
into nla data), but then were deleted and retried (due to following
action module missing or classifier-initiated retry), in which case
action init code tries to insert action to idr with index that was
assigned on previous iteration. During retry the index can be reused
by another action that was inserted concurrently, which causes
unintended action sharing between filters.
To fix described race condition, save action idr index to temporary
stack-allocated variable instead on nla data.

Fixes: 0190c1d452a9 ("net: sched: atomically check-allocate action")
Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_bpf.c        |    9 +++++----
 net/sched/act_connmark.c   |    9 +++++----
 net/sched/act_csum.c       |    9 +++++----
 net/sched/act_gact.c       |    8 +++++---
 net/sched/act_ife.c        |    8 +++++---
 net/sched/act_mirred.c     |   13 +++++++------
 net/sched/act_nat.c        |    9 +++++----
 net/sched/act_pedit.c      |   10 ++++++----
 net/sched/act_police.c     |    8 +++++---
 net/sched/act_sample.c     |   10 +++++-----
 net/sched/act_simple.c     |   10 ++++++----
 net/sched/act_skbedit.c    |   11 ++++++-----
 net/sched/act_skbmod.c     |   11 ++++++-----
 net/sched/act_tunnel_key.c |    8 +++++---
 net/sched/act_vlan.c       |   16 +++++++++-------
 15 files changed, 85 insertions(+), 64 deletions(-)

--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -287,6 +287,7 @@ static int tcf_bpf_init(struct net *net,
 	struct tcf_bpf *prog;
 	bool is_bpf, is_ebpf;
 	int ret, res = 0;
+	u32 index;
 
 	if (!nla)
 		return -EINVAL;
@@ -299,13 +300,13 @@ static int tcf_bpf_init(struct net *net,
 		return -EINVAL;
 
 	parm = nla_data(tb[TCA_ACT_BPF_PARMS]);
-
-	ret = tcf_idr_check_alloc(tn, &parm->index, act, bind);
+	index = parm->index;
+	ret = tcf_idr_check_alloc(tn, &index, act, bind);
 	if (!ret) {
-		ret = tcf_idr_create(tn, parm->index, est, act,
+		ret = tcf_idr_create(tn, index, est, act,
 				     &act_bpf_ops, bind, true);
 		if (ret < 0) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -104,6 +104,7 @@ static int tcf_connmark_init(struct net
 	struct tcf_connmark_info *ci;
 	struct tc_connmark *parm;
 	int ret = 0;
+	u32 index;
 
 	if (!nla)
 		return -EINVAL;
@@ -117,13 +118,13 @@ static int tcf_connmark_init(struct net
 		return -EINVAL;
 
 	parm = nla_data(tb[TCA_CONNMARK_PARMS]);
-
-	ret = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	index = parm->index;
+	ret = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!ret) {
-		ret = tcf_idr_create(tn, parm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_connmark_ops, bind, false);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -55,6 +55,7 @@ static int tcf_csum_init(struct net *net
 	struct tc_csum *parm;
 	struct tcf_csum *p;
 	int ret = 0, err;
+	u32 index;
 
 	if (nla == NULL)
 		return -EINVAL;
@@ -66,13 +67,13 @@ static int tcf_csum_init(struct net *net
 	if (tb[TCA_CSUM_PARMS] == NULL)
 		return -EINVAL;
 	parm = nla_data(tb[TCA_CSUM_PARMS]);
-
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
-		ret = tcf_idr_create(tn, parm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_csum_ops, bind, true);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 		ret = ACT_P_CREATED;
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -64,6 +64,7 @@ static int tcf_gact_init(struct net *net
 	struct tc_gact *parm;
 	struct tcf_gact *gact;
 	int ret = 0;
+	u32 index;
 	int err;
 #ifdef CONFIG_GACT_PROB
 	struct tc_gact_p *p_parm = NULL;
@@ -79,6 +80,7 @@ static int tcf_gact_init(struct net *net
 	if (tb[TCA_GACT_PARMS] == NULL)
 		return -EINVAL;
 	parm = nla_data(tb[TCA_GACT_PARMS]);
+	index = parm->index;
 
 #ifndef CONFIG_GACT_PROB
 	if (tb[TCA_GACT_PROB] != NULL)
@@ -91,12 +93,12 @@ static int tcf_gact_init(struct net *net
 	}
 #endif
 
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
-		ret = tcf_idr_create(tn, parm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_gact_ops, bind, true);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 		ret = ACT_P_CREATED;
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -482,6 +482,7 @@ static int tcf_ife_init(struct net *net,
 	u8 *saddr = NULL;
 	bool exists = false;
 	int ret = 0;
+	u32 index;
 	int err;
 
 	if (!nla) {
@@ -509,7 +510,8 @@ static int tcf_ife_init(struct net *net,
 	if (!p)
 		return -ENOMEM;
 
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (err < 0) {
 		kfree(p);
 		return err;
@@ -521,10 +523,10 @@ static int tcf_ife_init(struct net *net,
 	}
 
 	if (!exists) {
-		ret = tcf_idr_create(tn, parm->index, est, a, &act_ife_ops,
+		ret = tcf_idr_create(tn, index, est, a, &act_ife_ops,
 				     bind, true);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			kfree(p);
 			return ret;
 		}
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -104,6 +104,7 @@ static int tcf_mirred_init(struct net *n
 	struct net_device *dev;
 	bool exists = false;
 	int ret, err;
+	u32 index;
 
 	if (!nla) {
 		NL_SET_ERR_MSG_MOD(extack, "Mirred requires attributes to be passed");
@@ -117,8 +118,8 @@ static int tcf_mirred_init(struct net *n
 		return -EINVAL;
 	}
 	parm = nla_data(tb[TCA_MIRRED_PARMS]);
-
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (err < 0)
 		return err;
 	exists = err;
@@ -135,21 +136,21 @@ static int tcf_mirred_init(struct net *n
 		if (exists)
 			tcf_idr_release(*a, bind);
 		else
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 		NL_SET_ERR_MSG_MOD(extack, "Unknown mirred option");
 		return -EINVAL;
 	}
 
 	if (!exists) {
 		if (!parm->ifindex) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			NL_SET_ERR_MSG_MOD(extack, "Specified device does not exist");
 			return -EINVAL;
 		}
-		ret = tcf_idr_create(tn, parm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_mirred_ops, bind, true);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 		ret = ACT_P_CREATED;
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -45,6 +45,7 @@ static int tcf_nat_init(struct net *net,
 	struct tc_nat *parm;
 	int ret = 0, err;
 	struct tcf_nat *p;
+	u32 index;
 
 	if (nla == NULL)
 		return -EINVAL;
@@ -56,13 +57,13 @@ static int tcf_nat_init(struct net *net,
 	if (tb[TCA_NAT_PARMS] == NULL)
 		return -EINVAL;
 	parm = nla_data(tb[TCA_NAT_PARMS]);
-
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
-		ret = tcf_idr_create(tn, parm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_nat_ops, bind, false);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 		ret = ACT_P_CREATED;
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -149,6 +149,7 @@ static int tcf_pedit_init(struct net *ne
 	struct tcf_pedit *p;
 	int ret = 0, err;
 	int ksize;
+	u32 index;
 
 	if (!nla) {
 		NL_SET_ERR_MSG_MOD(extack, "Pedit requires attributes to be passed");
@@ -178,18 +179,19 @@ static int tcf_pedit_init(struct net *ne
 	if (IS_ERR(keys_ex))
 		return PTR_ERR(keys_ex);
 
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
 		if (!parm->nkeys) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			NL_SET_ERR_MSG_MOD(extack, "Pedit requires keys to be passed");
 			ret = -EINVAL;
 			goto out_free;
 		}
-		ret = tcf_idr_create(tn, parm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_pedit_ops, bind, false);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			goto out_free;
 		}
 		ret = ACT_P_CREATED;
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -85,6 +85,7 @@ static int tcf_police_init(struct net *n
 	struct qdisc_rate_table *R_tab = NULL, *P_tab = NULL;
 	struct tc_action_net *tn = net_generic(net, police_net_id);
 	bool exists = false;
+	u32 index;
 	int size;
 
 	if (nla == NULL)
@@ -101,7 +102,8 @@ static int tcf_police_init(struct net *n
 		return -EINVAL;
 
 	parm = nla_data(tb[TCA_POLICE_TBF]);
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (err < 0)
 		return err;
 	exists = err;
@@ -109,10 +111,10 @@ static int tcf_police_init(struct net *n
 		return 0;
 
 	if (!exists) {
-		ret = tcf_idr_create(tn, parm->index, NULL, a,
+		ret = tcf_idr_create(tn, index, NULL, a,
 				     &act_police_ops, bind, false);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 		ret = ACT_P_CREATED;
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -43,7 +43,7 @@ static int tcf_sample_init(struct net *n
 	struct tc_action_net *tn = net_generic(net, sample_net_id);
 	struct nlattr *tb[TCA_SAMPLE_MAX + 1];
 	struct psample_group *psample_group;
-	u32 psample_group_num, rate;
+	u32 psample_group_num, rate, index;
 	struct tc_sample *parm;
 	struct tcf_sample *s;
 	bool exists = false;
@@ -59,8 +59,8 @@ static int tcf_sample_init(struct net *n
 		return -EINVAL;
 
 	parm = nla_data(tb[TCA_SAMPLE_PARMS]);
-
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (err < 0)
 		return err;
 	exists = err;
@@ -68,10 +68,10 @@ static int tcf_sample_init(struct net *n
 		return 0;
 
 	if (!exists) {
-		ret = tcf_idr_create(tn, parm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_sample_ops, bind, true);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 		ret = ACT_P_CREATED;
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -88,6 +88,7 @@ static int tcf_simp_init(struct net *net
 	struct tcf_defact *d;
 	bool exists = false;
 	int ret = 0, err;
+	u32 index;
 
 	if (nla == NULL)
 		return -EINVAL;
@@ -100,7 +101,8 @@ static int tcf_simp_init(struct net *net
 		return -EINVAL;
 
 	parm = nla_data(tb[TCA_DEF_PARMS]);
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (err < 0)
 		return err;
 	exists = err;
@@ -111,15 +113,15 @@ static int tcf_simp_init(struct net *net
 		if (exists)
 			tcf_idr_release(*a, bind);
 		else
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 		return -EINVAL;
 	}
 
 	if (!exists) {
-		ret = tcf_idr_create(tn, parm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_simp_ops, bind, false);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -107,6 +107,7 @@ static int tcf_skbedit_init(struct net *
 	u16 *queue_mapping = NULL, *ptype = NULL;
 	bool exists = false;
 	int ret = 0, err;
+	u32 index;
 
 	if (nla == NULL)
 		return -EINVAL;
@@ -153,8 +154,8 @@ static int tcf_skbedit_init(struct net *
 	}
 
 	parm = nla_data(tb[TCA_SKBEDIT_PARMS]);
-
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (err < 0)
 		return err;
 	exists = err;
@@ -165,15 +166,15 @@ static int tcf_skbedit_init(struct net *
 		if (exists)
 			tcf_idr_release(*a, bind);
 		else
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 		return -EINVAL;
 	}
 
 	if (!exists) {
-		ret = tcf_idr_create(tn, parm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_skbedit_ops, bind, true);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -88,12 +88,12 @@ static int tcf_skbmod_init(struct net *n
 	struct nlattr *tb[TCA_SKBMOD_MAX + 1];
 	struct tcf_skbmod_params *p, *p_old;
 	struct tc_skbmod *parm;
+	u32 lflags = 0, index;
 	struct tcf_skbmod *d;
 	bool exists = false;
 	u8 *daddr = NULL;
 	u8 *saddr = NULL;
 	u16 eth_type = 0;
-	u32 lflags = 0;
 	int ret = 0, err;
 
 	if (!nla)
@@ -122,10 +122,11 @@ static int tcf_skbmod_init(struct net *n
 	}
 
 	parm = nla_data(tb[TCA_SKBMOD_PARMS]);
+	index = parm->index;
 	if (parm->flags & SKBMOD_F_SWAPMAC)
 		lflags = SKBMOD_F_SWAPMAC;
 
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (err < 0)
 		return err;
 	exists = err;
@@ -136,15 +137,15 @@ static int tcf_skbmod_init(struct net *n
 		if (exists)
 			tcf_idr_release(*a, bind);
 		else
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 		return -EINVAL;
 	}
 
 	if (!exists) {
-		ret = tcf_idr_create(tn, parm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_skbmod_ops, bind, true);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -224,6 +224,7 @@ static int tunnel_key_init(struct net *n
 	__be16 flags;
 	u8 tos, ttl;
 	int ret = 0;
+	u32 index;
 	int err;
 
 	if (!nla) {
@@ -244,7 +245,8 @@ static int tunnel_key_init(struct net *n
 	}
 
 	parm = nla_data(tb[TCA_TUNNEL_KEY_PARMS]);
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (err < 0)
 		return err;
 	exists = err;
@@ -338,7 +340,7 @@ static int tunnel_key_init(struct net *n
 	}
 
 	if (!exists) {
-		ret = tcf_idr_create(tn, parm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_tunnel_key_ops, bind, true);
 		if (ret) {
 			NL_SET_ERR_MSG(extack, "Cannot create TC IDR");
@@ -384,7 +386,7 @@ err_out:
 	if (exists)
 		tcf_idr_release(*a, bind);
 	else
-		tcf_idr_cleanup(tn, parm->index);
+		tcf_idr_cleanup(tn, index);
 	return ret;
 }
 
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -118,6 +118,7 @@ static int tcf_vlan_init(struct net *net
 	u8 push_prio = 0;
 	bool exists = false;
 	int ret = 0, err;
+	u32 index;
 
 	if (!nla)
 		return -EINVAL;
@@ -129,7 +130,8 @@ static int tcf_vlan_init(struct net *net
 	if (!tb[TCA_VLAN_PARMS])
 		return -EINVAL;
 	parm = nla_data(tb[TCA_VLAN_PARMS]);
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (err < 0)
 		return err;
 	exists = err;
@@ -145,7 +147,7 @@ static int tcf_vlan_init(struct net *net
 			if (exists)
 				tcf_idr_release(*a, bind);
 			else
-				tcf_idr_cleanup(tn, parm->index);
+				tcf_idr_cleanup(tn, index);
 			return -EINVAL;
 		}
 		push_vid = nla_get_u16(tb[TCA_VLAN_PUSH_VLAN_ID]);
@@ -153,7 +155,7 @@ static int tcf_vlan_init(struct net *net
 			if (exists)
 				tcf_idr_release(*a, bind);
 			else
-				tcf_idr_cleanup(tn, parm->index);
+				tcf_idr_cleanup(tn, index);
 			return -ERANGE;
 		}
 
@@ -167,7 +169,7 @@ static int tcf_vlan_init(struct net *net
 				if (exists)
 					tcf_idr_release(*a, bind);
 				else
-					tcf_idr_cleanup(tn, parm->index);
+					tcf_idr_cleanup(tn, index);
 				return -EPROTONOSUPPORT;
 			}
 		} else {
@@ -181,16 +183,16 @@ static int tcf_vlan_init(struct net *net
 		if (exists)
 			tcf_idr_release(*a, bind);
 		else
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 		return -EINVAL;
 	}
 	action = parm->v_action;
 
 	if (!exists) {
-		ret = tcf_idr_create(tn, parm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_vlan_ops, bind, true);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 


