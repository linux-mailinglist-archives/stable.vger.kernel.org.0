Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B68C510BD83
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730759AbfK0U5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:57:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728691AbfK0U5F (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:57:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2FCB21741;
        Wed, 27 Nov 2019 20:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888225;
        bh=ymKgi5qHOMzmBfl3cxb8n0AXalZfJo1V7k2iQENLuMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bgDwBr1m6jLxUNWYF2W5rA4s2W1PBz3GZ12o7ROw4OFU/ntdYScNvjECaCsyRiTVK
         WRT9Qen0Jb9kvrS/QMTUGI0Y2POVYv+NAGw+vFI+OHHK/5pO1dtC167mELVDx+SwuP
         pW2s54DK79WdkEWqs4WFPDvrPRxBjvIpULOimGkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.19 010/306] net/mlx5: Fix auto group size calculation
Date:   Wed, 27 Nov 2019 21:27:40 +0100
Message-Id: <20191127203115.482321963@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

[ Upstream commit 97fd8da281f80e7e69e0114bc906575734d4dfaf ]

Once all the large flow groups (defined by the user when the flow table
is created - max_num_groups) were created, then all the following new
flow groups will have only one flow table entry, even though the flow table
has place to larger groups.
Fix the condition to prefer large flow group.

Fixes: f0d22d187473 ("net/mlx5_core: Introduce flow steering autogrouped flow table")
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c |   10 ++++++----
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h |    1 +
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -520,7 +520,7 @@ static void del_sw_flow_group(struct fs_
 
 	rhashtable_destroy(&fg->ftes_hash);
 	ida_destroy(&fg->fte_allocator);
-	if (ft->autogroup.active)
+	if (ft->autogroup.active && fg->max_ftes == ft->autogroup.group_size)
 		ft->autogroup.num_groups--;
 	err = rhltable_remove(&ft->fgs_hash,
 			      &fg->hash,
@@ -1065,6 +1065,8 @@ mlx5_create_auto_grouped_flow_table(stru
 
 	ft->autogroup.active = true;
 	ft->autogroup.required_groups = max_num_groups;
+	/* We save place for flow groups in addition to max types */
+	ft->autogroup.group_size = ft->max_fte / (max_num_groups + 1);
 
 	return ft;
 }
@@ -1270,8 +1272,7 @@ static struct mlx5_flow_group *alloc_aut
 		return ERR_PTR(-ENOENT);
 
 	if (ft->autogroup.num_groups < ft->autogroup.required_groups)
-		/* We save place for flow groups in addition to max types */
-		group_size = ft->max_fte / (ft->autogroup.required_groups + 1);
+		group_size = ft->autogroup.group_size;
 
 	/*  ft->max_fte == ft->autogroup.max_types */
 	if (group_size == 0)
@@ -1298,7 +1299,8 @@ static struct mlx5_flow_group *alloc_aut
 	if (IS_ERR(fg))
 		goto out;
 
-	ft->autogroup.num_groups++;
+	if (group_size == ft->autogroup.group_size)
+		ft->autogroup.num_groups++;
 
 out:
 	return fg;
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -121,6 +121,7 @@ struct mlx5_flow_table {
 	struct {
 		bool			active;
 		unsigned int		required_groups;
+		unsigned int		group_size;
 		unsigned int		num_groups;
 	} autogroup;
 	/* Protect fwd_rules */


