Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314072B623C
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731019AbgKQN0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:26:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:34184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731219AbgKQN0h (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:26:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42A2A2078E;
        Tue, 17 Nov 2020 13:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619595;
        bh=V5iMUCoqIhEK1rY2KVqewuUcVp26OcCcV9LEKdfnF34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zcKJjpJY1dmSvXyPuhtsQyMNvv1rOik+Rpqd/WrqIx9yX4Vy9I1cL2dSrOSF2hWx1
         hkFuCbMfrIAF8kZtGSkxMoR63IEXSD9+t6HcQNOEjw+CDQjE/LzWkeJjRrVZISI62s
         aOHCnQzCNh7XgWjBYjOxKUIx2Hbavg516sAz4/tM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/151] net/mlx5: Fix deletion of duplicate rules
Date:   Tue, 17 Nov 2020 14:05:21 +0100
Message-Id: <20201117122125.836156682@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

[ Upstream commit 465e7baab6d93b399344f5868f84c177ab5cd16f ]

When a rule is duplicated, the refcount of the rule is increased so only
the second deletion of the rule should cause destruction of the FTE.
Currently, the FTE will be destroyed in the first deletion of rule since
the modify_mask will be 0.
Fix it and call to destroy FTE only if all the rules (FTE's children)
have been removed.

Fixes: 718ce4d601db ("net/mlx5: Consolidate update FTE for all removal changes")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 9ac2f52187ea4..16511f6485531 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1923,10 +1923,11 @@ void mlx5_del_flow_rules(struct mlx5_flow_handle *handle)
 	down_write_ref_node(&fte->node, false);
 	for (i = handle->num_rules - 1; i >= 0; i--)
 		tree_remove_node(&handle->rule[i]->node, true);
-	if (fte->modify_mask && fte->dests_size) {
-		modify_fte(fte);
+	if (fte->dests_size) {
+		if (fte->modify_mask)
+			modify_fte(fte);
 		up_write_ref_node(&fte->node, false);
-	} else {
+	} else if (list_empty(&fte->node.children)) {
 		del_hw_fte(&fte->node);
 		/* Avoid double call to del_hw_fte */
 		fte->node.del_hw_func = NULL;
-- 
2.27.0



