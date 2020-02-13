Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C457315C473
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbgBMPr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:47:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:48512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728988AbgBMP1D (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:03 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 904BB24670;
        Thu, 13 Feb 2020 15:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607622;
        bh=asWoLacKFH1KxfF3Gmpm1l70KlWV8YA0bQ4Byui+Vio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eQKZN9NCxKuOaud+gcJ1kHcYEfap+AiecH4TFy2YqbhcAPlIjZxzQpl6LbMGTA6fs
         bL4O0bDLHEZo8PBRnUIM0XfEC3i6ma9ZVg6xCMI3Mc3+Us2IGDNnPkoEhiPmOL2gUf
         rTjMew9EjcwliYUDfl6Z39M69ThZNNSbLLpl4BwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Parav Pandit <parav@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 03/96] IB/mlx4: Fix memory leak in add_gid error flow
Date:   Thu, 13 Feb 2020 07:20:10 -0800
Message-Id: <20200213151840.200355439@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

commit eaad647e5cc27f7b46a27f3b85b14c4c8a64bffa upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx4/main.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -246,6 +246,13 @@ static int mlx4_ib_update_gids(struct gi
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
@@ -306,6 +313,8 @@ static int mlx4_ib_add_gid(const struct
 				     GFP_ATOMIC);
 		if (!gids) {
 			ret = -ENOMEM;
+			*context = NULL;
+			free_gid_entry(&port_gid_table->gids[free]);
 		} else {
 			for (i = 0; i < MLX4_MAX_PORT_GIDS; i++) {
 				memcpy(&gids[i].gid, &port_gid_table->gids[i].gid, sizeof(union ib_gid));
@@ -317,6 +326,12 @@ static int mlx4_ib_add_gid(const struct
 
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
 
@@ -346,10 +361,7 @@ static int mlx4_ib_del_gid(const struct
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


