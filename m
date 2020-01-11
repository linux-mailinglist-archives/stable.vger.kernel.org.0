Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A178C1380CF
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731496AbgAKKeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:34:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731482AbgAKKeP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:34:15 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D985020882;
        Sat, 11 Jan 2020 10:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738854;
        bh=LwYgJs1NDSNzQSImIZbDEYdnR/Lpt2lrbiiwqlrDCbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2GXMk23j7aZDPwTGNj9W1mpmtXVOqshOGBjDJuo3kbaUECZUxDYLx+JTWzWt7WflN
         po15r1wpdmyWVUaTIMLt3jNw9aO95JImtwFOmWQTTBa9uA/vh0Yb3AQybVOGevwi+v
         hYuAtt8uiPfizpgLuNZFlkKbdr/Z133HmnK/l28E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <eli@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.4 160/165] net/mlx5e: Fix hairpin RSS table size
Date:   Sat, 11 Jan 2020 10:51:19 +0100
Message-Id: <20200111094942.748330852@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

[ Upstream commit 6412bb396a63f28de994b1480edf8e4caf4aa494 ]

Set hairpin table size to the corret size, based on the groups that
would be created in it. Groups are laid out on the table such that a
group occupies a range of entries in the table. This implies that the
group ranges should have correspondence to the table they are laid upon.

The patch cited below  made group 1's size to grow hence causing
overflow of group range laid on the table.

Fixes: a795d8db2a6d ("net/mlx5e: Support RSS for IP-in-IP and IPv6 tunneled packets")
Signed-off-by: Eli Cohen <eli@mellanox.com>
Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h |   16 ++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c |   16 ----------------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |    2 +-
 3 files changed, 17 insertions(+), 17 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -122,6 +122,22 @@ enum {
 #endif
 };
 
+#define MLX5E_TTC_NUM_GROUPS	3
+#define MLX5E_TTC_GROUP1_SIZE	(BIT(3) + MLX5E_NUM_TUNNEL_TT)
+#define MLX5E_TTC_GROUP2_SIZE	 BIT(1)
+#define MLX5E_TTC_GROUP3_SIZE	 BIT(0)
+#define MLX5E_TTC_TABLE_SIZE	(MLX5E_TTC_GROUP1_SIZE +\
+				 MLX5E_TTC_GROUP2_SIZE +\
+				 MLX5E_TTC_GROUP3_SIZE)
+
+#define MLX5E_INNER_TTC_NUM_GROUPS	3
+#define MLX5E_INNER_TTC_GROUP1_SIZE	BIT(3)
+#define MLX5E_INNER_TTC_GROUP2_SIZE	BIT(1)
+#define MLX5E_INNER_TTC_GROUP3_SIZE	BIT(0)
+#define MLX5E_INNER_TTC_TABLE_SIZE	(MLX5E_INNER_TTC_GROUP1_SIZE +\
+					 MLX5E_INNER_TTC_GROUP2_SIZE +\
+					 MLX5E_INNER_TTC_GROUP3_SIZE)
+
 #ifdef CONFIG_MLX5_EN_RXNFC
 
 struct mlx5e_ethtool_table {
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -904,22 +904,6 @@ del_rules:
 	return err;
 }
 
-#define MLX5E_TTC_NUM_GROUPS	3
-#define MLX5E_TTC_GROUP1_SIZE	(BIT(3) + MLX5E_NUM_TUNNEL_TT)
-#define MLX5E_TTC_GROUP2_SIZE	 BIT(1)
-#define MLX5E_TTC_GROUP3_SIZE	 BIT(0)
-#define MLX5E_TTC_TABLE_SIZE	(MLX5E_TTC_GROUP1_SIZE +\
-				 MLX5E_TTC_GROUP2_SIZE +\
-				 MLX5E_TTC_GROUP3_SIZE)
-
-#define MLX5E_INNER_TTC_NUM_GROUPS	3
-#define MLX5E_INNER_TTC_GROUP1_SIZE	BIT(3)
-#define MLX5E_INNER_TTC_GROUP2_SIZE	BIT(1)
-#define MLX5E_INNER_TTC_GROUP3_SIZE	BIT(0)
-#define MLX5E_INNER_TTC_TABLE_SIZE	(MLX5E_INNER_TTC_GROUP1_SIZE +\
-					 MLX5E_INNER_TTC_GROUP2_SIZE +\
-					 MLX5E_INNER_TTC_GROUP3_SIZE)
-
 static int mlx5e_create_ttc_table_groups(struct mlx5e_ttc_table *ttc,
 					 bool use_ipv)
 {
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -586,7 +586,7 @@ static void mlx5e_hairpin_set_ttc_params
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
 		ttc_params->indir_tirn[tt] = hp->indir_tirn[tt];
 
-	ft_attr->max_fte = MLX5E_NUM_TT;
+	ft_attr->max_fte = MLX5E_TTC_TABLE_SIZE;
 	ft_attr->level = MLX5E_TC_TTC_FT_LEVEL;
 	ft_attr->prio = MLX5E_TC_PRIO;
 }


