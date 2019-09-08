Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C82AACE56
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbfIHM5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:57:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730833AbfIHMr5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:47:57 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A460218AC;
        Sun,  8 Sep 2019 12:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946876;
        bh=hhJZjnhO0gbZWh267gIF1j2JqtZxTdXiaBXe+D+oK1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6av6M2dHlFIfBqsExYhiF+yjovin6W2/0VmqvdxH+qEFVMS/Af/HHF+qIKPlOJdd
         Hr+p/OrUfFLB4DfJGNGHKgg0lzY/Stz+PWr5iPYGmYssXPXZqOd/TwlKy/hqegrXJV
         DbnY4rTcJtabSWSouNH55g+v/v2u525CehzQexAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, itugrok@yahoo.com
Subject: [PATCH 4.19 04/57] net_sched: fix a NULL pointer deref in ipt action
Date:   Sun,  8 Sep 2019 13:41:28 +0100
Message-Id: <20190908121127.430691416@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121125.608195329@linuxfoundation.org>
References: <20190908121125.608195329@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 981471bd3abf4d572097645d765391533aac327d ]

The net pointer in struct xt_tgdtor_param is not explicitly
initialized therefore is still NULL when dereferencing it.
So we have to find a way to pass the correct net pointer to
ipt_destroy_target().

The best way I find is just saving the net pointer inside the per
netns struct tcf_idrinfo, which could make this patch smaller.

Fixes: 0c66dc1ea3f0 ("netfilter: conntrack: register hooks in netns when needed by ruleset")
Reported-and-tested-by: itugrok@yahoo.com
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/act_api.h      |    4 +++-
 net/sched/act_bpf.c        |    2 +-
 net/sched/act_connmark.c   |    2 +-
 net/sched/act_csum.c       |    2 +-
 net/sched/act_gact.c       |    2 +-
 net/sched/act_ife.c        |    2 +-
 net/sched/act_ipt.c        |   11 ++++++-----
 net/sched/act_mirred.c     |    2 +-
 net/sched/act_nat.c        |    2 +-
 net/sched/act_pedit.c      |    2 +-
 net/sched/act_police.c     |    2 +-
 net/sched/act_sample.c     |    2 +-
 net/sched/act_simple.c     |    2 +-
 net/sched/act_skbedit.c    |    2 +-
 net/sched/act_skbmod.c     |    2 +-
 net/sched/act_tunnel_key.c |    2 +-
 net/sched/act_vlan.c       |    2 +-
 17 files changed, 24 insertions(+), 21 deletions(-)

--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -15,6 +15,7 @@
 struct tcf_idrinfo {
 	spinlock_t	lock;
 	struct idr	action_idr;
+	struct net	*net;
 };
 
 struct tc_action_ops;
@@ -107,7 +108,7 @@ struct tc_action_net {
 };
 
 static inline
-int tc_action_net_init(struct tc_action_net *tn,
+int tc_action_net_init(struct net *net, struct tc_action_net *tn,
 		       const struct tc_action_ops *ops)
 {
 	int err = 0;
@@ -116,6 +117,7 @@ int tc_action_net_init(struct tc_action_
 	if (!tn->idrinfo)
 		return -ENOMEM;
 	tn->ops = ops;
+	tn->idrinfo->net = net;
 	spin_lock_init(&tn->idrinfo->lock);
 	idr_init(&tn->idrinfo->action_idr);
 	return err;
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -413,7 +413,7 @@ static __net_init int bpf_init_net(struc
 {
 	struct tc_action_net *tn = net_generic(net, bpf_net_id);
 
-	return tc_action_net_init(tn, &act_bpf_ops);
+	return tc_action_net_init(net, tn, &act_bpf_ops);
 }
 
 static void __net_exit bpf_exit_net(struct list_head *net_list)
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -215,7 +215,7 @@ static __net_init int connmark_init_net(
 {
 	struct tc_action_net *tn = net_generic(net, connmark_net_id);
 
-	return tc_action_net_init(tn, &act_connmark_ops);
+	return tc_action_net_init(net, tn, &act_connmark_ops);
 }
 
 static void __net_exit connmark_exit_net(struct list_head *net_list)
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -678,7 +678,7 @@ static __net_init int csum_init_net(stru
 {
 	struct tc_action_net *tn = net_generic(net, csum_net_id);
 
-	return tc_action_net_init(tn, &act_csum_ops);
+	return tc_action_net_init(net, tn, &act_csum_ops);
 }
 
 static void __net_exit csum_exit_net(struct list_head *net_list)
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -263,7 +263,7 @@ static __net_init int gact_init_net(stru
 {
 	struct tc_action_net *tn = net_generic(net, gact_net_id);
 
-	return tc_action_net_init(tn, &act_gact_ops);
+	return tc_action_net_init(net, tn, &act_gact_ops);
 }
 
 static void __net_exit gact_exit_net(struct list_head *net_list)
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -887,7 +887,7 @@ static __net_init int ife_init_net(struc
 {
 	struct tc_action_net *tn = net_generic(net, ife_net_id);
 
-	return tc_action_net_init(tn, &act_ife_ops);
+	return tc_action_net_init(net, tn, &act_ife_ops);
 }
 
 static void __net_exit ife_exit_net(struct list_head *net_list)
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -65,12 +65,13 @@ static int ipt_init_target(struct net *n
 	return 0;
 }
 
-static void ipt_destroy_target(struct xt_entry_target *t)
+static void ipt_destroy_target(struct xt_entry_target *t, struct net *net)
 {
 	struct xt_tgdtor_param par = {
 		.target   = t->u.kernel.target,
 		.targinfo = t->data,
 		.family   = NFPROTO_IPV4,
+		.net      = net,
 	};
 	if (par.target->destroy != NULL)
 		par.target->destroy(&par);
@@ -82,7 +83,7 @@ static void tcf_ipt_release(struct tc_ac
 	struct tcf_ipt *ipt = to_ipt(a);
 
 	if (ipt->tcfi_t) {
-		ipt_destroy_target(ipt->tcfi_t);
+		ipt_destroy_target(ipt->tcfi_t, a->idrinfo->net);
 		kfree(ipt->tcfi_t);
 	}
 	kfree(ipt->tcfi_tname);
@@ -182,7 +183,7 @@ static int __tcf_ipt_init(struct net *ne
 
 	spin_lock_bh(&ipt->tcf_lock);
 	if (ret != ACT_P_CREATED) {
-		ipt_destroy_target(ipt->tcfi_t);
+		ipt_destroy_target(ipt->tcfi_t, net);
 		kfree(ipt->tcfi_tname);
 		kfree(ipt->tcfi_t);
 	}
@@ -353,7 +354,7 @@ static __net_init int ipt_init_net(struc
 {
 	struct tc_action_net *tn = net_generic(net, ipt_net_id);
 
-	return tc_action_net_init(tn, &act_ipt_ops);
+	return tc_action_net_init(net, tn, &act_ipt_ops);
 }
 
 static void __net_exit ipt_exit_net(struct list_head *net_list)
@@ -403,7 +404,7 @@ static __net_init int xt_init_net(struct
 {
 	struct tc_action_net *tn = net_generic(net, xt_net_id);
 
-	return tc_action_net_init(tn, &act_xt_ops);
+	return tc_action_net_init(net, tn, &act_xt_ops);
 }
 
 static void __net_exit xt_exit_net(struct list_head *net_list)
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -419,7 +419,7 @@ static __net_init int mirred_init_net(st
 {
 	struct tc_action_net *tn = net_generic(net, mirred_net_id);
 
-	return tc_action_net_init(tn, &act_mirred_ops);
+	return tc_action_net_init(net, tn, &act_mirred_ops);
 }
 
 static void __net_exit mirred_exit_net(struct list_head *net_list)
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -317,7 +317,7 @@ static __net_init int nat_init_net(struc
 {
 	struct tc_action_net *tn = net_generic(net, nat_net_id);
 
-	return tc_action_net_init(tn, &act_nat_ops);
+	return tc_action_net_init(net, tn, &act_nat_ops);
 }
 
 static void __net_exit nat_exit_net(struct list_head *net_list)
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -488,7 +488,7 @@ static __net_init int pedit_init_net(str
 {
 	struct tc_action_net *tn = net_generic(net, pedit_net_id);
 
-	return tc_action_net_init(tn, &act_pedit_ops);
+	return tc_action_net_init(net, tn, &act_pedit_ops);
 }
 
 static void __net_exit pedit_exit_net(struct list_head *net_list)
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -342,7 +342,7 @@ static __net_init int police_init_net(st
 {
 	struct tc_action_net *tn = net_generic(net, police_net_id);
 
-	return tc_action_net_init(tn, &act_police_ops);
+	return tc_action_net_init(net, tn, &act_police_ops);
 }
 
 static void __net_exit police_exit_net(struct list_head *net_list)
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -258,7 +258,7 @@ static __net_init int sample_init_net(st
 {
 	struct tc_action_net *tn = net_generic(net, sample_net_id);
 
-	return tc_action_net_init(tn, &act_sample_ops);
+	return tc_action_net_init(net, tn, &act_sample_ops);
 }
 
 static void __net_exit sample_exit_net(struct list_head *net_list)
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -215,7 +215,7 @@ static __net_init int simp_init_net(stru
 {
 	struct tc_action_net *tn = net_generic(net, simp_net_id);
 
-	return tc_action_net_init(tn, &act_simp_ops);
+	return tc_action_net_init(net, tn, &act_simp_ops);
 }
 
 static void __net_exit simp_exit_net(struct list_head *net_list)
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -316,7 +316,7 @@ static __net_init int skbedit_init_net(s
 {
 	struct tc_action_net *tn = net_generic(net, skbedit_net_id);
 
-	return tc_action_net_init(tn, &act_skbedit_ops);
+	return tc_action_net_init(net, tn, &act_skbedit_ops);
 }
 
 static void __net_exit skbedit_exit_net(struct list_head *net_list)
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -277,7 +277,7 @@ static __net_init int skbmod_init_net(st
 {
 	struct tc_action_net *tn = net_generic(net, skbmod_net_id);
 
-	return tc_action_net_init(tn, &act_skbmod_ops);
+	return tc_action_net_init(net, tn, &act_skbmod_ops);
 }
 
 static void __net_exit skbmod_exit_net(struct list_head *net_list)
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -579,7 +579,7 @@ static __net_init int tunnel_key_init_ne
 {
 	struct tc_action_net *tn = net_generic(net, tunnel_key_net_id);
 
-	return tc_action_net_init(tn, &act_tunnel_key_ops);
+	return tc_action_net_init(net, tn, &act_tunnel_key_ops);
 }
 
 static void __net_exit tunnel_key_exit_net(struct list_head *net_list)
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -324,7 +324,7 @@ static __net_init int vlan_init_net(stru
 {
 	struct tc_action_net *tn = net_generic(net, vlan_net_id);
 
-	return tc_action_net_init(tn, &act_vlan_ops);
+	return tc_action_net_init(net, tn, &act_vlan_ops);
 }
 
 static void __net_exit vlan_exit_net(struct list_head *net_list)


