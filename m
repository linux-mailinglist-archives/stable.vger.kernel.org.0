Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9ED14BBB5
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgA1OCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:02:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727550AbgA1OCF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:02:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5799205F4;
        Tue, 28 Jan 2020 14:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220124;
        bh=4mTqcUWHS9yCc82Xc+8HHbgzuyY5H1RUR/J6Ui0wbis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQWoWFWijj/UeosxLR44J09fesGE7Yf9WSRFWdvmzj9RIrQL0/EkM/USPcOgbsu4Q
         d9FtbqXpRkEmjUjaWmu2q2XcrOiL5rQUYCnQwee5HXa4EAqIWjp/3vMpgmdIcK9uz8
         +nL/Z3wIj8kqPXIlet2ehW7d+F3gMRqmlIWFUFSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hamdan Igbaria <hamdani@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.4 026/104] net/mlx5: DR, Enable counter on non-fwd-dest objects
Date:   Tue, 28 Jan 2020 14:59:47 +0100
Message-Id: <20200128135820.878204926@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erez Shitrit <erezsh@mellanox.com>

commmit b850a82114df9b0ec1d191dc64eed1f20a772e0f upstream.

The current code handles only counters that attached to dest, we still
have the cases where we have counter on non-dest, like over drop etc.

Fixes: 6a48faeeca10 ("net/mlx5: Add direct rule fs_cmd implementation")
Signed-off-by: Hamdan Igbaria <hamdani@mellanox.com>
Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c |   42 ++++++++++-----
 1 file changed, 29 insertions(+), 13 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -352,26 +352,16 @@ static int mlx5_cmd_dr_create_fte(struct
 	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
 		list_for_each_entry(dst, &fte->node.children, node.list) {
 			enum mlx5_flow_destination_type type = dst->dest_attr.type;
-			u32 id;
 
 			if (num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX) {
 				err = -ENOSPC;
 				goto free_actions;
 			}
 
-			switch (type) {
-			case MLX5_FLOW_DESTINATION_TYPE_COUNTER:
-				id = dst->dest_attr.counter_id;
+			if (type == MLX5_FLOW_DESTINATION_TYPE_COUNTER)
+				continue;
 
-				tmp_action =
-					mlx5dr_action_create_flow_counter(id);
-				if (!tmp_action) {
-					err = -ENOMEM;
-					goto free_actions;
-				}
-				fs_dr_actions[fs_dr_num_actions++] = tmp_action;
-				actions[num_actions++] = tmp_action;
-				break;
+			switch (type) {
 			case MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE:
 				tmp_action = create_ft_action(dev, dst);
 				if (!tmp_action) {
@@ -397,6 +387,32 @@ static int mlx5_cmd_dr_create_fte(struct
 		}
 	}
 
+	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_COUNT) {
+		list_for_each_entry(dst, &fte->node.children, node.list) {
+			u32 id;
+
+			if (dst->dest_attr.type !=
+			    MLX5_FLOW_DESTINATION_TYPE_COUNTER)
+				continue;
+
+			if (num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX) {
+				err = -ENOSPC;
+				goto free_actions;
+			}
+
+			id = dst->dest_attr.counter_id;
+			tmp_action =
+				mlx5dr_action_create_flow_counter(id);
+			if (!tmp_action) {
+				err = -ENOMEM;
+				goto free_actions;
+			}
+
+			fs_dr_actions[fs_dr_num_actions++] = tmp_action;
+			actions[num_actions++] = tmp_action;
+		}
+	}
+
 	params.match_sz = match_sz;
 	params.match_buf = (u64 *)fte->val;
 


