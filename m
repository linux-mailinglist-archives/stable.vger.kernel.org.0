Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9FF30CBF6
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239884AbhBBTky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:40:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:41654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233172AbhBBNzG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:55:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 175CE64FD8;
        Tue,  2 Feb 2021 13:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273482;
        bh=b5Od0b+hCiTlDBKviMD46lVjlMg/CPQbkBzOOWWXE8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RPk3TU3o78ijlK6mU2LcFxeUoE6pPNvrINMmYgVzxjBaMlNf1LTobh3LyryhO8sRg
         U00+gs2gDJxBYe8HrFOmL06UDH1/x5MjFn2vNJIDOgyf5G2Ui4+nIfMTdszuuWLL9S
         JtCyw0vTcjUgSZrTivf4er7mn7u5wjNM5oV1KvVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/142] net/mlx5: CT: Fix incorrect removal of tuple_nat_node from nat rhashtable
Date:   Tue,  2 Feb 2021 14:38:07 +0100
Message-Id: <20210202133002.816976385@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

[ Upstream commit e2194a1744e8594e82a861687808c1adca419b85 ]

If a non nat tuple entry is inserted just to the regular tuples
rhashtable (ct_tuples_ht) and not to natted tuples rhashtable
(ct_nat_tuples_ht). Commit bc562be9674b ("net/mlx5e: CT: Save ct entries
tuples in hashtables") mixed up the return labels and names sot that on
cleanup or failure we still try to remove for the natted tuples rhashtable.

Fix that by correctly checking if a natted tuples insertion
before removing it. While here make it more readable.

Fixes: bc562be9674b ("net/mlx5e: CT: Save ct entries tuples in hashtables")
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 20 ++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 072363e73f1ce..6bc6b48a56dc7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -167,6 +167,12 @@ static const struct rhashtable_params tuples_nat_ht_params = {
 	.min_size = 16 * 1024,
 };
 
+static bool
+mlx5_tc_ct_entry_has_nat(struct mlx5_ct_entry *entry)
+{
+	return !!(entry->tuple_nat_node.next);
+}
+
 static int
 mlx5_tc_ct_rule_to_tuple(struct mlx5_ct_tuple *tuple, struct flow_rule *rule)
 {
@@ -911,13 +917,13 @@ mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
 err_insert:
 	mlx5_tc_ct_entry_del_rules(ct_priv, entry);
 err_rules:
-	rhashtable_remove_fast(&ct_priv->ct_tuples_nat_ht,
-			       &entry->tuple_nat_node, tuples_nat_ht_params);
+	if (mlx5_tc_ct_entry_has_nat(entry))
+		rhashtable_remove_fast(&ct_priv->ct_tuples_nat_ht,
+				       &entry->tuple_nat_node, tuples_nat_ht_params);
 err_tuple_nat:
-	if (entry->tuple_node.next)
-		rhashtable_remove_fast(&ct_priv->ct_tuples_ht,
-				       &entry->tuple_node,
-				       tuples_ht_params);
+	rhashtable_remove_fast(&ct_priv->ct_tuples_ht,
+			       &entry->tuple_node,
+			       tuples_ht_params);
 err_tuple:
 err_set:
 	kfree(entry);
@@ -932,7 +938,7 @@ mlx5_tc_ct_del_ft_entry(struct mlx5_tc_ct_priv *ct_priv,
 {
 	mlx5_tc_ct_entry_del_rules(ct_priv, entry);
 	mutex_lock(&ct_priv->shared_counter_lock);
-	if (entry->tuple_node.next)
+	if (mlx5_tc_ct_entry_has_nat(entry))
 		rhashtable_remove_fast(&ct_priv->ct_tuples_nat_ht,
 				       &entry->tuple_nat_node,
 				       tuples_nat_ht_params);
-- 
2.27.0



