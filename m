Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673223961BF
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhEaOpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:45:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233184AbhEaOnd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:43:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5243C613B9;
        Mon, 31 May 2021 13:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469257;
        bh=b6pxLm9b+aHmQ8leoDa2uMcseGzhDvHezK5XJWEJodM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DzSMAf/Na7J+8L/E5gF6sXT8GNtAJl4+Lue/dF1qIGtzWEO7wghG7EsLxAjebJPn2
         uJ7pEM8O+46sPrH0LxQ51o3Bj47cZaDBgVjYSRy14V9KyOFkpPTGuPGseBgofanLLi
         DGn74r9BqEPVcwyj3oQOf0p2/o6GkSwouKZMHt8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ariel Levkovich <lariel@nvidia.com>
Subject: [PATCH 5.12 128/296] net/mlx5: Set term table as an unmanaged flow table
Date:   Mon, 31 May 2021 15:13:03 +0200
Message-Id: <20210531130708.200759345@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

commit 6ff51ab8aa8fcbcddeeefce8ca705b575805d12b upstream.

Termination tables are restricted to have the default miss action and
cannot be set to forward to another table in case of a miss.
If the fs prio of the termination table is not the last one in the
list, fs_core will attempt to attach it to another table.

Set the unmanaged ft flag when creating the termination table ft
and select the tc offload prio for it to prevent fs_core from selecting
the forwarding to next ft miss action and use the default one.

In addition, set the flow that forwards to the termination table to
ignore ft level restrictions since the ft level is not set by fs_core
for unamanged fts.

Fixes: 249ccc3c95bd ("net/mlx5e: Add support for offloading traffic from uplink to uplink")
Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -76,10 +76,11 @@ mlx5_eswitch_termtbl_create(struct mlx5_
 	/* As this is the terminating action then the termination table is the
 	 * same prio as the slow path
 	 */
-	ft_attr.flags = MLX5_FLOW_TABLE_TERMINATION |
+	ft_attr.flags = MLX5_FLOW_TABLE_TERMINATION | MLX5_FLOW_TABLE_UNMANAGED |
 			MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
-	ft_attr.prio = FDB_SLOW_PATH;
+	ft_attr.prio = FDB_TC_OFFLOAD;
 	ft_attr.max_fte = 1;
+	ft_attr.level = 1;
 	ft_attr.autogroup.max_num_groups = 1;
 	tt->termtbl = mlx5_create_auto_grouped_flow_table(root_ns, &ft_attr);
 	if (IS_ERR(tt->termtbl)) {
@@ -216,6 +217,7 @@ mlx5_eswitch_termtbl_required(struct mlx
 	int i;
 
 	if (!MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, termination_table) ||
+	    !MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, ignore_flow_level) ||
 	    attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH ||
 	    !mlx5_eswitch_offload_is_uplink_port(esw, spec))
 		return false;
@@ -288,6 +290,7 @@ mlx5_eswitch_add_termtbl_rule(struct mlx
 	/* create the FTE */
 	flow_act->action &= ~MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
 	flow_act->pkt_reformat = NULL;
+	flow_act->flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
 	rule = mlx5_add_flow_rules(fdb, spec, flow_act, dest, num_dest);
 	if (IS_ERR(rule))
 		goto revert_changes;


