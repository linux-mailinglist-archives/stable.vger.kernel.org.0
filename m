Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F124643391
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbiLEThj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234506AbiLEThQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:37:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5881E28E14
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:34:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 168B9B81157
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:34:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B501C433D6;
        Mon,  5 Dec 2022 19:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268851;
        bh=KfifV/m9vLyzh1d5g8rMvThbXUT27g6VgEmsDcBkYpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hvChW5a2D5lGyTpQYusaD/eP1dlINeEYfbPr3043OKYmmi5adrslUHOnXIF1yKFfD
         iLOTSX7M9DAtR2tyl7urfS/oOXAoPS3CPi7WPTO+WSEpzlnPqpcZLVOf/Vxc9nBVt8
         vH9w1r6l8wRsrc5BBetK8hlGSshdQFJllWwP2sdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/120] net/mlx5: DR, Rename list field in matcher struct to list_node
Date:   Mon,  5 Dec 2022 20:09:34 +0100
Message-Id: <20221205190807.577696681@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit 08fac109f7bb5e12ae14def56b3ad57ce67cd9fe ]

In dr_types structs, some list fields are list heads, and some
are just list nodes that are stored on the other structs' lists.
Rename the appropriate list field to reflect this distinction.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Stable-dep-of: 52f7cf70eb8f ("net/mlx5: DR, Fix uninitialized var warning")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/steering/dr_matcher.c  | 26 +++++++++----------
 .../mellanox/mlx5/core/steering/dr_table.c    |  2 +-
 .../mellanox/mlx5/core/steering/dr_types.h    |  2 +-
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index a19e8157c100..0f99d3612f89 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -709,7 +709,7 @@ static int dr_matcher_add_to_tbl(struct mlx5dr_matcher *matcher)
 	int ret;
 
 	next_matcher = NULL;
-	list_for_each_entry(tmp_matcher, &tbl->matcher_list, matcher_list) {
+	list_for_each_entry(tmp_matcher, &tbl->matcher_list, list_node) {
 		if (tmp_matcher->prio >= matcher->prio) {
 			next_matcher = tmp_matcher;
 			break;
@@ -719,11 +719,11 @@ static int dr_matcher_add_to_tbl(struct mlx5dr_matcher *matcher)
 
 	prev_matcher = NULL;
 	if (next_matcher && !first)
-		prev_matcher = list_prev_entry(next_matcher, matcher_list);
+		prev_matcher = list_prev_entry(next_matcher, list_node);
 	else if (!first)
 		prev_matcher = list_last_entry(&tbl->matcher_list,
 					       struct mlx5dr_matcher,
-					       matcher_list);
+					       list_node);
 
 	if (dmn->type == MLX5DR_DOMAIN_TYPE_FDB ||
 	    dmn->type == MLX5DR_DOMAIN_TYPE_NIC_RX) {
@@ -744,12 +744,12 @@ static int dr_matcher_add_to_tbl(struct mlx5dr_matcher *matcher)
 	}
 
 	if (prev_matcher)
-		list_add(&matcher->matcher_list, &prev_matcher->matcher_list);
+		list_add(&matcher->list_node, &prev_matcher->list_node);
 	else if (next_matcher)
-		list_add_tail(&matcher->matcher_list,
-			      &next_matcher->matcher_list);
+		list_add_tail(&matcher->list_node,
+			      &next_matcher->list_node);
 	else
-		list_add(&matcher->matcher_list, &tbl->matcher_list);
+		list_add(&matcher->list_node, &tbl->matcher_list);
 
 	return 0;
 }
@@ -922,7 +922,7 @@ mlx5dr_matcher_create(struct mlx5dr_table *tbl,
 	matcher->prio = priority;
 	matcher->match_criteria = match_criteria_enable;
 	refcount_set(&matcher->refcount, 1);
-	INIT_LIST_HEAD(&matcher->matcher_list);
+	INIT_LIST_HEAD(&matcher->list_node);
 
 	mlx5dr_domain_lock(tbl->dmn);
 
@@ -985,15 +985,15 @@ static int dr_matcher_remove_from_tbl(struct mlx5dr_matcher *matcher)
 	struct mlx5dr_domain *dmn = tbl->dmn;
 	int ret = 0;
 
-	if (list_is_last(&matcher->matcher_list, &tbl->matcher_list))
+	if (list_is_last(&matcher->list_node, &tbl->matcher_list))
 		next_matcher = NULL;
 	else
-		next_matcher = list_next_entry(matcher, matcher_list);
+		next_matcher = list_next_entry(matcher, list_node);
 
-	if (matcher->matcher_list.prev == &tbl->matcher_list)
+	if (matcher->list_node.prev == &tbl->matcher_list)
 		prev_matcher = NULL;
 	else
-		prev_matcher = list_prev_entry(matcher, matcher_list);
+		prev_matcher = list_prev_entry(matcher, list_node);
 
 	if (dmn->type == MLX5DR_DOMAIN_TYPE_FDB ||
 	    dmn->type == MLX5DR_DOMAIN_TYPE_NIC_RX) {
@@ -1013,7 +1013,7 @@ static int dr_matcher_remove_from_tbl(struct mlx5dr_matcher *matcher)
 			return ret;
 	}
 
-	list_del(&matcher->matcher_list);
+	list_del(&matcher->list_node);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
index 30ae3cda6d2e..4c40178e7d1e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
@@ -19,7 +19,7 @@ int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
 	if (!list_empty(&tbl->matcher_list))
 		last_matcher = list_last_entry(&tbl->matcher_list,
 					       struct mlx5dr_matcher,
-					       matcher_list);
+					       list_node);
 
 	if (tbl->dmn->type == MLX5DR_DOMAIN_TYPE_NIC_RX ||
 	    tbl->dmn->type == MLX5DR_DOMAIN_TYPE_FDB) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index bc206836af6a..9e2102f8bed1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -891,7 +891,7 @@ struct mlx5dr_matcher {
 	struct mlx5dr_table *tbl;
 	struct mlx5dr_matcher_rx_tx rx;
 	struct mlx5dr_matcher_rx_tx tx;
-	struct list_head matcher_list;
+	struct list_head list_node;
 	u32 prio;
 	struct mlx5dr_match_param mask;
 	u8 match_criteria;
-- 
2.35.1



