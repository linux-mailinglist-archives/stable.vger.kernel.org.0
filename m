Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFEAF1EACEA
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731231AbgFASMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:12:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729813AbgFASMh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:12:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 831772068D;
        Mon,  1 Jun 2020 18:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035157;
        bh=xgKESQlh4hz1jNDka1iAVIYlIrRIxpsYwYTMx43M5r8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8VMIQrRa3VHFuGSsAVxmus8l6fxAuGK9U6e3TXw80hWFEVcv3/nWUITqHm1I+w59
         I37tBMxLmdA+9Plu8zAc43Sz4kzx+YdyIsYzOh4NoEaYT2n5YuCfZcS34xq/1pJQQR
         eqcG/8AccIwC6cb2sis9j3F816xGeQLIqva3FxAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.6 033/177] net/mlx5: Fix cleaning unmanaged flow tables
Date:   Mon,  1 Jun 2020 19:52:51 +0200
Message-Id: <20200601174051.649274000@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

[ Upstream commit aee37f3d940ca732df71c3df49347bccaafc0b24 ]

Unmanaged flow tables doesn't have a parent and tree_put_node()
assume there is always a parent if cleaning is needed. fix that.

Fixes: 5281a0c90919 ("net/mlx5: fs_core: Introduce unmanaged flow tables")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -323,14 +323,13 @@ static void tree_put_node(struct fs_node
 		if (node->del_hw_func)
 			node->del_hw_func(node);
 		if (parent_node) {
-			/* Only root namespace doesn't have parent and we just
-			 * need to free its node.
-			 */
 			down_write_ref_node(parent_node, locked);
 			list_del_init(&node->list);
 			if (node->del_sw_func)
 				node->del_sw_func(node);
 			up_write_ref_node(parent_node, locked);
+		} else if (node->del_sw_func) {
+			node->del_sw_func(node);
 		} else {
 			kfree(node);
 		}
@@ -447,8 +446,10 @@ static void del_sw_flow_table(struct fs_
 	fs_get_obj(ft, node);
 
 	rhltable_destroy(&ft->fgs_hash);
-	fs_get_obj(prio, ft->node.parent);
-	prio->num_ft--;
+	if (ft->node.parent) {
+		fs_get_obj(prio, ft->node.parent);
+		prio->num_ft--;
+	}
 	kfree(ft);
 }
 


