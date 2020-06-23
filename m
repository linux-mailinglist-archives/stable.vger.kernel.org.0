Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC06205D4B
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388899AbgFWULh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388263AbgFWULf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:11:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64A062145D;
        Tue, 23 Jun 2020 20:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943094;
        bh=JgjUESSXUvoIPKEgQTpPOVMjT7iC93tMeDR0v7X4iME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vwce7lg5BtRp+z4lnuPkB6ujdTAeVZ/MRMe+cdwJpR6MtHM01w7Xu6BUu7594X5IB
         DyT9qrP/lWpbcseM7uPpziCNb60zQauOYfrC5hxzLTckVBfj0+dP+8CD0m8F/Quw8t
         I0H7vg52x5fMHz6CCW7PELhUxrElrUtIackQbmYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 257/477] IB/cma: Fix ports memory leak in cma_configfs
Date:   Tue, 23 Jun 2020 21:54:14 +0200
Message-Id: <20200623195419.719690565@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

[ Upstream commit 63a3345c2d42a9b29e1ce2d3a4043689b3995cea ]

The allocated ports structure in never freed. The free function should be
called by release_cma_ports_group, but the group is never released since
we don't remove its default group.

Remove default groups when device group is deleted.

Fixes: 045959db65c6 ("IB/cma: Add configfs for rdma_cm")
Link: https://lore.kernel.org/r/20200521072650.567908-1-leon@kernel.org
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma_configfs.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/infiniband/core/cma_configfs.c b/drivers/infiniband/core/cma_configfs.c
index c672a4978bfde..3c1e2ca564fea 100644
--- a/drivers/infiniband/core/cma_configfs.c
+++ b/drivers/infiniband/core/cma_configfs.c
@@ -322,8 +322,21 @@ fail:
 	return ERR_PTR(err);
 }
 
+static void drop_cma_dev(struct config_group *cgroup, struct config_item *item)
+{
+	struct config_group *group =
+		container_of(item, struct config_group, cg_item);
+	struct cma_dev_group *cma_dev_group =
+		container_of(group, struct cma_dev_group, device_group);
+
+	configfs_remove_default_groups(&cma_dev_group->ports_group);
+	configfs_remove_default_groups(&cma_dev_group->device_group);
+	config_item_put(item);
+}
+
 static struct configfs_group_operations cma_subsys_group_ops = {
 	.make_group	= make_cma_dev,
+	.drop_item	= drop_cma_dev,
 };
 
 static const struct config_item_type cma_subsys_type = {
-- 
2.25.1



