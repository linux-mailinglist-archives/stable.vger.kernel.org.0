Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40FFC2F4FC
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388737AbfE3EnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:43:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728850AbfE3DML (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:11 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4672324481;
        Thu, 30 May 2019 03:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185930;
        bh=R2Pm0lh1S4kcKVJ7TuXWf1uzzXQl8k7TdBH/FmCHNy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ecwq2rxkjAl2N60yrzwxoJItImbCS7f9UsP/a0XCrpEm4qykwe/uWm4wTVy+yTx0O
         0dKbku2pWDQTc+Ye4xE1eYo/fw5xEt3tQlxg0hFg/i6OmdvcmuwvBf4HASuhLHI8pF
         BHcr//NDOTcBcVnv8/Q2z0K16d/0xFrqGtTt+uMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 323/405] net/mlx5e: Fix compilation warning in en_tc.c
Date:   Wed, 29 May 2019 20:05:21 -0700
Message-Id: <20190530030557.091826033@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ee576ec1c1c66ec1cd0c4735bb12bc08f675f530 ]

Amazingly a mlx5e_tc function is being called from the eswitch layer,
which is by itself very terrible! The function was declared locally in
eswitch_offloads.c so it could be used there, which caused the following
compilation warning, fix that.

drivers/.../mlx5/core/en_tc.c:3242:6: [-Werror=missing-prototypes]
error: no previous prototype for ‘mlx5e_tc_clean_fdb_peer_flows’

Fixes: 04de7dda7394 ("net/mlx5e: Infrastructure for duplicated offloading of TC flows")
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h          | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 3f3cd32ae60a2..e0ba59b5296f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -431,6 +431,9 @@ static inline int mlx5_eswitch_index_to_vport_num(struct mlx5_eswitch *esw,
 	return index;
 }
 
+/* TODO: This mlx5e_tc function shouldn't be called by eswitch */
+void mlx5e_tc_clean_fdb_peer_flows(struct mlx5_eswitch *esw);
+
 #else  /* CONFIG_MLX5_ESWITCH */
 /* eswitch API stubs */
 static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index d2d8da133082c..a97ffd0dbf014 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1521,8 +1521,6 @@ static int mlx5_esw_offloads_pair(struct mlx5_eswitch *esw,
 	return 0;
 }
 
-void mlx5e_tc_clean_fdb_peer_flows(struct mlx5_eswitch *esw);
-
 static void mlx5_esw_offloads_unpair(struct mlx5_eswitch *esw)
 {
 	mlx5e_tc_clean_fdb_peer_flows(esw);
-- 
2.20.1



