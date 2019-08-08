Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9FBC86A44
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404749AbfHHTHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:07:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404745AbfHHTHs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:07:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A837F2189D;
        Thu,  8 Aug 2019 19:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291267;
        bh=lutUNzudd+MrrM6q2H0wlI3WP4J0VQAy2GIXonk9nd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2JWuwSObNVrKCQiwPsjMD1Y92GO3N2hgY1y1dRj+pM3KhJGQs3GBXq8oi/wqw8MVR
         3n9psb0ylSPQRr5BEk/NMvFwFLezyV66/a2UfD2j2lcp0r++0EQnw1rgjpKOKhBabj
         NaZfr3njX0INEVx9iaQLtw3GwTt515iH4Wtz0VUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.2 51/56] net/mlx5: Add missing RDMA_RX capabilities
Date:   Thu,  8 Aug 2019 21:05:17 +0200
Message-Id: <20190808190455.296063658@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

[ Upstream commit 987f6c69dd923069d443f6a37225f5b1630a30f2 ]

New flow table type RDMA_RX was added but the MLX5_CAP_FLOW_TABLE_TYPE
didn't handle this new flow table type.
This means that MLX5_CAP_FLOW_TABLE_TYPE returns an empty capability to
this flow table type.

Update both the macro and the maximum supported flow table type to
RDMA_RX.

Fixes: d83eb50e29de ("net/mlx5: Add support in RDMA RX steering")
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -68,7 +68,7 @@ enum fs_flow_table_type {
 	FS_FT_SNIFFER_RX	= 0X5,
 	FS_FT_SNIFFER_TX	= 0X6,
 	FS_FT_RDMA_RX		= 0X7,
-	FS_FT_MAX_TYPE = FS_FT_SNIFFER_TX,
+	FS_FT_MAX_TYPE = FS_FT_RDMA_RX,
 };
 
 enum fs_flow_table_op_mod {
@@ -274,7 +274,8 @@ void mlx5_cleanup_fs(struct mlx5_core_de
 	(type == FS_FT_FDB) ? MLX5_CAP_ESW_FLOWTABLE_FDB(mdev, cap) :		\
 	(type == FS_FT_SNIFFER_RX) ? MLX5_CAP_FLOWTABLE_SNIFFER_RX(mdev, cap) :		\
 	(type == FS_FT_SNIFFER_TX) ? MLX5_CAP_FLOWTABLE_SNIFFER_TX(mdev, cap) :		\
-	(BUILD_BUG_ON_ZERO(FS_FT_SNIFFER_TX != FS_FT_MAX_TYPE))\
+	(type == FS_FT_RDMA_RX) ? MLX5_CAP_FLOWTABLE_RDMA_RX(mdev, cap) :		\
+	(BUILD_BUG_ON_ZERO(FS_FT_RDMA_RX != FS_FT_MAX_TYPE))\
 	)
 
 #endif


