Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87411CAFF6
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbgEHNWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:22:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:58242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728568AbgEHMjT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:39:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B27920731;
        Fri,  8 May 2020 12:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941558;
        bh=5Pudbi8qJflYMeIBj1kNopKnTQBWaHl/pyGP+TIt3ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mK7OupDp2dIhWxOr/KzN+3a2mogoyQm3IkXcpnO3EC1MZooIbYL+79r8hBWsxEOYu
         3a4+XFfwad4OXW7TH/MFmv5Nn9uaSu1uQzJKXa47+/OpW+Z3Klzo2JyVfsmDRbUj31
         I13T6SpVbilLME3KW3BVYMy8Tk7NYjXjk1dMSjuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Sheng-Hui <shhuiw@foxmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 080/312] net/mlx5: use mlx5_buf_alloc_node instead of mlx5_buf_alloc in mlx5_wq_ll_create
Date:   Fri,  8 May 2020 14:31:11 +0200
Message-Id: <20200508123130.152545342@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Sheng-Hui <shhuiw@foxmail.com>

commit f299a02d5f13c4deb52c1a7ddf2b42630fe6294a upstream.

Commit 311c7c71c9bb ("net/mlx5e: Allocate DMA coherent memory on
reader NUMA node") introduced mlx5_*_alloc_node() but missed changing
some calling and warn messages. This patch introduces 2 changes:
	* Use mlx5_buf_alloc_node() instead of mlx5_buf_alloc() in
	  mlx5_wq_ll_create()
	* Update the failure warn messages with _node postfix for
	  mlx5_*_alloc function names

Fixes: 311c7c71c9bb ("net/mlx5e: Allocate DMA coherent memory on reader NUMA node")
Signed-off-by: Wang Sheng-Hui <shhuiw@foxmail.com>
Acked-By: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/wq.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/wq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wq.c
@@ -75,14 +75,14 @@ int mlx5_wq_cyc_create(struct mlx5_core_
 
 	err = mlx5_db_alloc_node(mdev, &wq_ctrl->db, param->db_numa_node);
 	if (err) {
-		mlx5_core_warn(mdev, "mlx5_db_alloc() failed, %d\n", err);
+		mlx5_core_warn(mdev, "mlx5_db_alloc_node() failed, %d\n", err);
 		return err;
 	}
 
 	err = mlx5_buf_alloc_node(mdev, mlx5_wq_cyc_get_byte_size(wq),
 				  &wq_ctrl->buf, param->buf_numa_node);
 	if (err) {
-		mlx5_core_warn(mdev, "mlx5_buf_alloc() failed, %d\n", err);
+		mlx5_core_warn(mdev, "mlx5_buf_alloc_node() failed, %d\n", err);
 		goto err_db_free;
 	}
 
@@ -111,14 +111,14 @@ int mlx5_cqwq_create(struct mlx5_core_de
 
 	err = mlx5_db_alloc_node(mdev, &wq_ctrl->db, param->db_numa_node);
 	if (err) {
-		mlx5_core_warn(mdev, "mlx5_db_alloc() failed, %d\n", err);
+		mlx5_core_warn(mdev, "mlx5_db_alloc_node() failed, %d\n", err);
 		return err;
 	}
 
 	err = mlx5_buf_alloc_node(mdev, mlx5_cqwq_get_byte_size(wq),
 				  &wq_ctrl->buf, param->buf_numa_node);
 	if (err) {
-		mlx5_core_warn(mdev, "mlx5_buf_alloc() failed, %d\n", err);
+		mlx5_core_warn(mdev, "mlx5_buf_alloc_node() failed, %d\n", err);
 		goto err_db_free;
 	}
 
@@ -148,13 +148,14 @@ int mlx5_wq_ll_create(struct mlx5_core_d
 
 	err = mlx5_db_alloc_node(mdev, &wq_ctrl->db, param->db_numa_node);
 	if (err) {
-		mlx5_core_warn(mdev, "mlx5_db_alloc() failed, %d\n", err);
+		mlx5_core_warn(mdev, "mlx5_db_alloc_node() failed, %d\n", err);
 		return err;
 	}
 
-	err = mlx5_buf_alloc(mdev, mlx5_wq_ll_get_byte_size(wq), &wq_ctrl->buf);
+	err = mlx5_buf_alloc_node(mdev, mlx5_wq_ll_get_byte_size(wq),
+				  &wq_ctrl->buf, param->buf_numa_node);
 	if (err) {
-		mlx5_core_warn(mdev, "mlx5_buf_alloc() failed, %d\n", err);
+		mlx5_core_warn(mdev, "mlx5_buf_alloc_node() failed, %d\n", err);
 		goto err_db_free;
 	}
 


