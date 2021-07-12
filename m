Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEDE43C457C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbhGLGZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:25:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235365AbhGLGYu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:24:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BA34610A6;
        Mon, 12 Jul 2021 06:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070917;
        bh=MgPnsPjdTfVyMkYWXex4q/jwfVh6KATbFtUfDlFpSsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a0FmotFVbNbKKxzVTDea0oNsyEvW1MJG1np3kxDZytmHZyLgi4wwpiXcZmRk/7Ks9
         86Kneo/zNT2ENNK9EWZRQ+7t9FpxkpbR+uRlun/gPR+RxMTXPV3N69AuCp6X4pOniH
         /Bm9BkUutE/+7JeGvcU4ssJntHxjXT1tip0XR92s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Sukholitko <boris.sukholitko@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 195/348] net/sched: act_vlan: Fix modify to allow 0
Date:   Mon, 12 Jul 2021 08:09:39 +0200
Message-Id: <20210712060727.055709682@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Sukholitko <boris.sukholitko@broadcom.com>

[ Upstream commit 9c5eee0afca09cbde6bd00f77876754aaa552970 ]

Currently vlan modification action checks existence of vlan priority by
comparing it to 0. Therefore it is impossible to modify existing vlan
tag to have priority 0.

For example, the following tc command will change the vlan id but will
not affect vlan priority:

tc filter add dev eth1 ingress matchall action vlan modify id 300 \
        priority 0 pipe mirred egress redirect dev eth2

The incoming packet on eth1:

ethertype 802.1Q (0x8100), vlan 200, p 4, ethertype IPv4

will be changed to:

ethertype 802.1Q (0x8100), vlan 300, p 4, ethertype IPv4

although the user has intended to have p == 0.

The fix is to add tcfv_push_prio_exists flag to struct tcf_vlan_params
and rely on it when deciding to set the priority.

Fixes: 45a497f2d149a4a8061c (net/sched: act_vlan: Introduce TCA_VLAN_ACT_MODIFY vlan action)
Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tc_act/tc_vlan.h | 1 +
 net/sched/act_vlan.c         | 7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/net/tc_act/tc_vlan.h b/include/net/tc_act/tc_vlan.h
index 4e2502408c31..add6fb50dd33 100644
--- a/include/net/tc_act/tc_vlan.h
+++ b/include/net/tc_act/tc_vlan.h
@@ -14,6 +14,7 @@ struct tcf_vlan_params {
 	u16               tcfv_push_vid;
 	__be16            tcfv_push_proto;
 	u8                tcfv_push_prio;
+	bool              tcfv_push_prio_exists;
 	struct rcu_head   rcu;
 };
 
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 3c26042f4ea6..7dc76c68ec52 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -70,7 +70,7 @@ static int tcf_vlan_act(struct sk_buff *skb, const struct tc_action *a,
 		/* replace the vid */
 		tci = (tci & ~VLAN_VID_MASK) | p->tcfv_push_vid;
 		/* replace prio bits, if tcfv_push_prio specified */
-		if (p->tcfv_push_prio) {
+		if (p->tcfv_push_prio_exists) {
 			tci &= ~VLAN_PRIO_MASK;
 			tci |= p->tcfv_push_prio << VLAN_PRIO_SHIFT;
 		}
@@ -107,6 +107,7 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 	struct tc_action_net *tn = net_generic(net, vlan_net_id);
 	struct nlattr *tb[TCA_VLAN_MAX + 1];
 	struct tcf_chain *goto_ch = NULL;
+	bool push_prio_exists = false;
 	struct tcf_vlan_params *p;
 	struct tc_vlan *parm;
 	struct tcf_vlan *v;
@@ -175,7 +176,8 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 			push_proto = htons(ETH_P_8021Q);
 		}
 
-		if (tb[TCA_VLAN_PUSH_VLAN_PRIORITY])
+		push_prio_exists = !!tb[TCA_VLAN_PUSH_VLAN_PRIORITY];
+		if (push_prio_exists)
 			push_prio = nla_get_u8(tb[TCA_VLAN_PUSH_VLAN_PRIORITY]);
 		break;
 	default:
@@ -216,6 +218,7 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 	p->tcfv_action = action;
 	p->tcfv_push_vid = push_vid;
 	p->tcfv_push_prio = push_prio;
+	p->tcfv_push_prio_exists = push_prio_exists || action == TCA_VLAN_ACT_PUSH;
 	p->tcfv_push_proto = push_proto;
 
 	spin_lock_bh(&v->tcf_lock);
-- 
2.30.2



