Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82281FE423
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730364AbgFRCQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:16:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728947AbgFRBUV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:20:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8F0F20B1F;
        Thu, 18 Jun 2020 01:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443221;
        bh=SY8Eqoo2nu1v+0yBJH5UYzi2Ls/8iqjVxJLxfoN0Pa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WiYzvvid8mkUpQuSofVQcyjfxwPHcriyS4ANt+qmRkRAlBguBMKbyzGqgG56tYWEY
         sLMUOY+OroRjluAMaptWPoJLUZixA6lWP7oPjhsOCBKrCyFD7FpTRe2YK84eJWnhl4
         iucejFLvNbCPjDvXaQi3Hm8jwBrE8y+XAzHtBgw8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 176/266] IB/cma: Fix ports memory leak in cma_configfs
Date:   Wed, 17 Jun 2020 21:15:01 -0400
Message-Id: <20200618011631.604574-176-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 8b0b5ae22e4c..726e70b68249 100644
--- a/drivers/infiniband/core/cma_configfs.c
+++ b/drivers/infiniband/core/cma_configfs.c
@@ -322,8 +322,21 @@ static struct config_group *make_cma_dev(struct config_group *group,
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

