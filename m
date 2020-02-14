Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5766115E0DC
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392383AbgBNQPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:15:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392490AbgBNQPm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:15:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC8A9246E2;
        Fri, 14 Feb 2020 16:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696941;
        bh=wG5DzfXhNUiTrDFakN9BOTPux0RYW2bVFY9tNLm2jJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGw8x/GhpCxuBHR7n61Bvq6lxK/kGGZM7dkxvwu9VZcP8sORRJYkbGYONgXO8MKX3
         yxOHiv5WR7qH8HtFalmH0s4mdHCc8mPj4ySqG4R+7pkYeWTLxHpHoTPQaJSME/5AJL
         tK/5Pkb7ow9hbGLTW03mYdbL4HD3KK7lsWrjIINo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Parav Pandit <parav@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 184/252] IB/mlx4: Fix memory leak in add_gid error flow
Date:   Fri, 14 Feb 2020 11:10:39 -0500
Message-Id: <20200214161147.15842-184-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

[ Upstream commit eaad647e5cc27f7b46a27f3b85b14c4c8a64bffa ]

In procedure mlx4_ib_add_gid(), if the driver is unable to update the FW
gid table, there is a memory leak in the driver's copy of the gid table:
the gid entry's context buffer is not freed.

If such an error occurs, free the entry's context buffer, and mark the
entry as available (by setting its context pointer to NULL).

Fixes: e26be1bfef81 ("IB/mlx4: Implement ib_device callbacks")
Link: https://lore.kernel.org/r/20200115085050.73746-1-leon@kernel.org
Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/main.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 9386bb57b3d71..a19d3ad14dc37 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -246,6 +246,13 @@ static int mlx4_ib_update_gids(struct gid_entry *gids,
 	return mlx4_ib_update_gids_v1(gids, ibdev, port_num);
 }
 
+static void free_gid_entry(struct gid_entry *entry)
+{
+	memset(&entry->gid, 0, sizeof(entry->gid));
+	kfree(entry->ctx);
+	entry->ctx = NULL;
+}
+
 static int mlx4_ib_add_gid(const struct ib_gid_attr *attr, void **context)
 {
 	struct mlx4_ib_dev *ibdev = to_mdev(attr->device);
@@ -306,6 +313,8 @@ static int mlx4_ib_add_gid(const struct ib_gid_attr *attr, void **context)
 				     GFP_ATOMIC);
 		if (!gids) {
 			ret = -ENOMEM;
+			*context = NULL;
+			free_gid_entry(&port_gid_table->gids[free]);
 		} else {
 			for (i = 0; i < MLX4_MAX_PORT_GIDS; i++) {
 				memcpy(&gids[i].gid, &port_gid_table->gids[i].gid, sizeof(union ib_gid));
@@ -317,6 +326,12 @@ static int mlx4_ib_add_gid(const struct ib_gid_attr *attr, void **context)
 
 	if (!ret && hw_update) {
 		ret = mlx4_ib_update_gids(gids, ibdev, attr->port_num);
+		if (ret) {
+			spin_lock_bh(&iboe->lock);
+			*context = NULL;
+			free_gid_entry(&port_gid_table->gids[free]);
+			spin_unlock_bh(&iboe->lock);
+		}
 		kfree(gids);
 	}
 
@@ -346,10 +361,7 @@ static int mlx4_ib_del_gid(const struct ib_gid_attr *attr, void **context)
 		if (!ctx->refcount) {
 			unsigned int real_index = ctx->real_index;
 
-			memset(&port_gid_table->gids[real_index].gid, 0,
-			       sizeof(port_gid_table->gids[real_index].gid));
-			kfree(port_gid_table->gids[real_index].ctx);
-			port_gid_table->gids[real_index].ctx = NULL;
+			free_gid_entry(&port_gid_table->gids[real_index]);
 			hw_update = 1;
 		}
 	}
-- 
2.20.1

