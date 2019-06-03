Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66E0C32BA0
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbfFCJKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:10:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728057AbfFCJKK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:10:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C022C27E2A;
        Mon,  3 Jun 2019 09:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553010;
        bh=nIhh939yS6fdWsHpG0bb5FyJ1GG9hoy/+ApJ1dU19NU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SaTxVOZcnn6oObZ7BbQ9sbeRSKpphN1VbeaR3Ek5g2gcHNow2ambUIPbJCWGR5CqS
         /UiHFVg1HuZpHfrXrULiQgRvcH1llYy0t+hA4fE1582ecUjjxsBC3fg38ai5cJlnsa
         7vFXF/0HHcDtPZk1RxCHHex3kW0vZrRPRuor0eAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Daniel Jurgens <danielj@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.19 20/32] net/mlx5: Allocate root ns memory using kzalloc to match kfree
Date:   Mon,  3 Jun 2019 11:08:14 +0200
Message-Id: <20190603090313.853867511@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090308.472021390@linuxfoundation.org>
References: <20190603090308.472021390@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

[ Upstream commit 25fa506b70cadb580c1e9cbd836d6417276d4bcd ]

root ns is yet another fs core node which is freed using kfree() by
tree_put_node().
Rest of the other fs core objects are also allocated using kmalloc
variants.

However, root ns memory is allocated using kvzalloc().
Hence allocate root ns memory using kzalloc().

Fixes: 2530236303d9e ("net/mlx5_core: Flow steering tree initialization")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Daniel Jurgens <danielj@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2220,7 +2220,7 @@ static struct mlx5_flow_root_namespace
 		cmds = mlx5_fs_cmd_get_default_ipsec_fpga_cmds(table_type);
 
 	/* Create the root namespace */
-	root_ns = kvzalloc(sizeof(*root_ns), GFP_KERNEL);
+	root_ns = kzalloc(sizeof(*root_ns), GFP_KERNEL);
 	if (!root_ns)
 		return NULL;
 


