Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD4154905D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355497AbiFMLk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355620AbiFMLjU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:39:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CE3DFA1;
        Mon, 13 Jun 2022 03:49:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DECC61260;
        Mon, 13 Jun 2022 10:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0B8C34114;
        Mon, 13 Jun 2022 10:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117355;
        bh=nArZdsnwotAu8g4xr9MWXCPE0GiiH9M5SBA+KyiJvrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mELDoljNL5hMzGO+ylntJg5rwV+/bZMGkhyWa1I7TWmNeOivRxKy5yveNOdfNnTLi
         hSxZP/+IqOCklLzs7CtUXX37QNR0/a+aTurGnd9Io1a0xWK/X8ZUdmLLCrB9yjYBjy
         y830FrVMzKP9jNjucDcb6DnAENn21lnh4X6RM/vM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 361/411] net/mlx5: fs, fail conflicting actions
Date:   Mon, 13 Jun 2022 12:10:34 +0200
Message-Id: <20220613094939.517130002@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

[ Upstream commit 8fa5e7b20e01042b14f8cd684d2da9b638460c74 ]

When combining two steering rules into one check
not only do they share the same actions but those
actions are also the same. This resolves an issue where
when creating two different rules with the same match
the actions are overwritten and one of the rules is deleted
a FW syndrome can be seen in dmesg.

mlx5_core 0000:03:00.0: mlx5_cmd_check:819:(pid 2105): DEALLOC_MODIFY_HEADER_CONTEXT(0x941) op_mod(0x0) failed, status bad resource state(0x9), syndrome (0x1ab444)

Fixes: 0d235c3fabb7 ("net/mlx5: Add hash table to search FTEs in a flow-group")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 35 +++++++++++++++++--
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 8c8b68e7abb4..41087c0618c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1450,9 +1450,22 @@ static struct mlx5_flow_rule *find_flow_rule(struct fs_fte *fte,
 	return NULL;
 }
 
-static bool check_conflicting_actions(u32 action1, u32 action2)
+static bool check_conflicting_actions_vlan(const struct mlx5_fs_vlan *vlan0,
+					   const struct mlx5_fs_vlan *vlan1)
 {
-	u32 xored_actions = action1 ^ action2;
+	return vlan0->ethtype != vlan1->ethtype ||
+	       vlan0->vid != vlan1->vid ||
+	       vlan0->prio != vlan1->prio;
+}
+
+static bool check_conflicting_actions(const struct mlx5_flow_act *act1,
+				      const struct mlx5_flow_act *act2)
+{
+	u32 action1 = act1->action;
+	u32 action2 = act2->action;
+	u32 xored_actions;
+
+	xored_actions = action1 ^ action2;
 
 	/* if one rule only wants to count, it's ok */
 	if (action1 == MLX5_FLOW_CONTEXT_ACTION_COUNT ||
@@ -1469,6 +1482,22 @@ static bool check_conflicting_actions(u32 action1, u32 action2)
 			     MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2))
 		return true;
 
+	if (action1 & MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT &&
+	    act1->pkt_reformat != act2->pkt_reformat)
+		return true;
+
+	if (action1 & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
+	    act1->modify_hdr != act2->modify_hdr)
+		return true;
+
+	if (action1 & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH &&
+	    check_conflicting_actions_vlan(&act1->vlan[0], &act2->vlan[0]))
+		return true;
+
+	if (action1 & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2 &&
+	    check_conflicting_actions_vlan(&act1->vlan[1], &act2->vlan[1]))
+		return true;
+
 	return false;
 }
 
@@ -1476,7 +1505,7 @@ static int check_conflicting_ftes(struct fs_fte *fte,
 				  const struct mlx5_flow_context *flow_context,
 				  const struct mlx5_flow_act *flow_act)
 {
-	if (check_conflicting_actions(flow_act->action, fte->action.action)) {
+	if (check_conflicting_actions(flow_act, &fte->action)) {
 		mlx5_core_warn(get_dev(&fte->node),
 			       "Found two FTEs with conflicting actions\n");
 		return -EEXIST;
-- 
2.35.1



