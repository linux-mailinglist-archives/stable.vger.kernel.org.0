Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22E112060DE
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404061AbgFWUrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:47:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404057AbgFWUre (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:47:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A036820781;
        Tue, 23 Jun 2020 20:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945255;
        bh=8fU3l5yIMm0+QfOPOLk1KC+nutzhw3BIfXEgK1zhcjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cEXeKNNpxU4LUZTbnxj1fBrV7sq/+yN4IEnywdX5XhP5xPJ5/Kbsylh+eoffUoKW5
         8TVCEETaHDNwuxFym1qjcYAGP5QLww6lnaTWCTT+4R6mkmXXM0YedEucnihmhtiHQ2
         aDbOjh9xo4pJQURdzgtfb43YM1xvpto/pjP8Htj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 069/136] IB/cma: Fix ports memory leak in cma_configfs
Date:   Tue, 23 Jun 2020 21:58:45 +0200
Message-Id: <20200623195307.152650592@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
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
index 54076a3e80076..ac47e8a1dfbf4 100644
--- a/drivers/infiniband/core/cma_configfs.c
+++ b/drivers/infiniband/core/cma_configfs.c
@@ -319,8 +319,21 @@ fail:
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
 
 static struct config_item_type cma_subsys_type = {
-- 
2.25.1



