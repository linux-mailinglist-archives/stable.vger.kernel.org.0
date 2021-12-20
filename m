Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B11C47ACF6
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236741AbhLTOsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:48:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53326 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235204AbhLTOqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:46:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D868B80EE8;
        Mon, 20 Dec 2021 14:45:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805A6C36AE7;
        Mon, 20 Dec 2021 14:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011558;
        bh=UxQ/CmF8545P3Gojcq7AmIXW11oGKsJZlnlaxb4E0Gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UewiDQ6YuQRR9EoEQXsOCDMJde/xwNd0V2GuAENG4x1NZs5bfm+5VWzodg9T2wFlJ
         T10IF4P++FLb0iZXRjOzYjW0sJXz/wLKKU/uBZO8pRct+XFy/WfkG2GjLRsJQxtcUw
         XFR5XtDEgeAxICExjcxpjX4bPVQkvWhMv9OyE23Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 31/71] net: sched: lock action when translating it to flow_action infra
Date:   Mon, 20 Dec 2021 15:34:20 +0100
Message-Id: <20211220143026.734482779@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

[ Upstream commit 7a47281439ba00b11fc098f36695522184ce5a82 ]

In order to remove dependency on rtnl lock, take action's tcfa_lock when
constructing its representation as flow_action_entry structure.

Refactor tcf_sample_get_group() to assume that caller holds tcf_lock and
don't take it manually. This callback is only called from flow_action infra
representation translator which now calls it with tcf_lock held, so this
refactoring is necessary to prevent deadlock.

Allocate memory with GFP_ATOMIC flag for ip_tunnel_info copy because
tcf_tunnel_info_copy() is only called from flow_action representation infra
code with tcf_lock spinlock taken.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tc_act/tc_tunnel_key.h |  2 +-
 net/sched/act_sample.c             |  2 --
 net/sched/cls_api.c                | 17 +++++++++++------
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/include/net/tc_act/tc_tunnel_key.h b/include/net/tc_act/tc_tunnel_key.h
index 0689d9bcdf841..2b3df076e5b62 100644
--- a/include/net/tc_act/tc_tunnel_key.h
+++ b/include/net/tc_act/tc_tunnel_key.h
@@ -69,7 +69,7 @@ tcf_tunnel_info_copy(const struct tc_action *a)
 	if (tun) {
 		size_t tun_size = sizeof(*tun) + tun->options_len;
 		struct ip_tunnel_info *tun_copy = kmemdup(tun, tun_size,
-							  GFP_KERNEL);
+							  GFP_ATOMIC);
 
 		return tun_copy;
 	}
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 74450b0f69fc5..214f4efdd9920 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -265,14 +265,12 @@ tcf_sample_get_group(const struct tc_action *a,
 	struct tcf_sample *s = to_sample(a);
 	struct psample_group *group;
 
-	spin_lock_bh(&s->tcf_lock);
 	group = rcu_dereference_protected(s->psample_group,
 					  lockdep_is_held(&s->tcf_lock));
 	if (group) {
 		psample_group_take(group);
 		*destructor = tcf_psample_group_put;
 	}
-	spin_unlock_bh(&s->tcf_lock);
 
 	return group;
 }
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 7f20fd37e01e0..61aa63cc170b4 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3436,7 +3436,7 @@ static void tcf_sample_get_group(struct flow_action_entry *entry,
 int tc_setup_flow_action(struct flow_action *flow_action,
 			 const struct tcf_exts *exts, bool rtnl_held)
 {
-	const struct tc_action *act;
+	struct tc_action *act;
 	int i, j, k, err = 0;
 
 	if (!exts)
@@ -3450,6 +3450,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 		struct flow_action_entry *entry;
 
 		entry = &flow_action->entries[j];
+		spin_lock_bh(&act->tcfa_lock);
 		if (is_tcf_gact_ok(act)) {
 			entry->id = FLOW_ACTION_ACCEPT;
 		} else if (is_tcf_gact_shot(act)) {
@@ -3490,13 +3491,13 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 				break;
 			default:
 				err = -EOPNOTSUPP;
-				goto err_out;
+				goto err_out_locked;
 			}
 		} else if (is_tcf_tunnel_set(act)) {
 			entry->id = FLOW_ACTION_TUNNEL_ENCAP;
 			err = tcf_tunnel_encap_get_tunnel(entry, act);
 			if (err)
-				goto err_out;
+				goto err_out_locked;
 		} else if (is_tcf_tunnel_release(act)) {
 			entry->id = FLOW_ACTION_TUNNEL_DECAP;
 		} else if (is_tcf_pedit(act)) {
@@ -3510,7 +3511,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 					break;
 				default:
 					err = -EOPNOTSUPP;
-					goto err_out;
+					goto err_out_locked;
 				}
 				entry->mangle.htype = tcf_pedit_htype(act, k);
 				entry->mangle.mask = tcf_pedit_mask(act, k);
@@ -3561,15 +3562,16 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 				entry->mpls_mangle.ttl = tcf_mpls_ttl(act);
 				break;
 			default:
-				goto err_out;
+				goto err_out_locked;
 			}
 		} else if (is_tcf_skbedit_ptype(act)) {
 			entry->id = FLOW_ACTION_PTYPE;
 			entry->ptype = tcf_skbedit_ptype(act);
 		} else {
 			err = -EOPNOTSUPP;
-			goto err_out;
+			goto err_out_locked;
 		}
+		spin_unlock_bh(&act->tcfa_lock);
 
 		if (!is_tcf_pedit(act))
 			j++;
@@ -3583,6 +3585,9 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 		tc_cleanup_flow_action(flow_action);
 
 	return err;
+err_out_locked:
+	spin_unlock_bh(&act->tcfa_lock);
+	goto err_out;
 }
 EXPORT_SYMBOL(tc_setup_flow_action);
 
-- 
2.33.0



