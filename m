Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 002331480B2
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390073AbgAXLNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:13:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:49970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390066AbgAXLNi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:13:38 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 420B42075D;
        Fri, 24 Jan 2020 11:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864417;
        bh=RzcuPyVkxMQdSanrxzNVTw3dHgkRGQ3Vrq6RjZFYUco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2lzUn3YI8iId9gf7DvK1yelldsbYQIoaqGSPIvQjRxLya5d0Wee/KsJ6aFVs6OcuO
         d8HrsVe08SBCSctR9krSxoxNe5mPRtN4ORsrBUqIlvGBPvUdhosgSbkMUQNMf6fW/V
         fjp3M+3SHRZ6Kt9wHsB1XvBv2eeDk1M2Eg6iwrPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Britstein <elibr@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 259/639] net/mlx5: Fix multiple updates of steering rules in parallel
Date:   Fri, 24 Jan 2020 10:27:09 +0100
Message-Id: <20200124093119.177741446@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Britstein <elibr@mellanox.com>

[ Upstream commit 6237634d8fcc65c9e3348382910e7cdb15084c68 ]

There might be a condition where the fte found is not active yet. In
this case we should not use it, but continue to search for another, or
allocate a new one.

Fixes: bd71b08ec2ee ("net/mlx5: Support multiple updates of steering rules in parallel")
Signed-off-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 82a53317285d0..b16e0f45d28c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -469,6 +469,7 @@ static void del_hw_fte(struct fs_node *node)
 			mlx5_core_warn(dev,
 				       "flow steering can't delete fte in index %d of flow group id %d\n",
 				       fte->index, fg->id);
+		node->active = 0;
 	}
 }
 
@@ -1597,6 +1598,11 @@ lookup_fte_locked(struct mlx5_flow_group *g,
 		fte_tmp = NULL;
 		goto out;
 	}
+	if (!fte_tmp->node.active) {
+		tree_put_node(&fte_tmp->node);
+		fte_tmp = NULL;
+		goto out;
+	}
 
 	nested_down_write_ref_node(&fte_tmp->node, FS_LOCK_CHILD);
 out:
-- 
2.20.1



