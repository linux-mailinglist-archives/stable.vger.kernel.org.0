Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBC981578F9
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbgBJNLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:11:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:35660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729279AbgBJMi6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:58 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF2CD2051A;
        Mon, 10 Feb 2020 12:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338337;
        bh=0Jo8HbvTbazqaZFAESbEV2UpPh4vDzbFusWlZWJSMYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGNq+vjaLLHVgX/Szwg5pE/AbJgbyv0QrnIFXnNEp1YyinQiLIG9HmeAI3UPgdchN
         KKQ3CZWqBiL8PWAHcn6cCvfZY8I4iQPcNfP2xIU1jB+Cz19pA+EUikuHG5TlzP+3kA
         fo+fBNMvRBobRTD10wWFAeP1zw1RK2aFObCrrTk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.4 286/309] net/mlx5: Deprecate usage of generic TLS HW capability bit
Date:   Mon, 10 Feb 2020 04:34:02 -0800
Message-Id: <20200210122434.135190142@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

[ Upstream commit 61c00cca41aeeaa8e5263c2f81f28534bc1efafb ]

Deprecate the generic TLS cap bit, use the new TX-specific
TLS cap bit instead.

Fixes: a12ff35e0fb7 ("net/mlx5: Introduce TLS TX offload hardware bits and structures")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h         |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c                |    2 +-
 include/linux/mlx5/mlx5_ifc.h                               |    7 ++++---
 4 files changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
@@ -45,7 +45,7 @@ void mlx5_ktls_destroy_key(struct mlx5_c
 
 static inline bool mlx5_accel_is_ktls_device(struct mlx5_core_dev *mdev)
 {
-	if (!MLX5_CAP_GEN(mdev, tls))
+	if (!MLX5_CAP_GEN(mdev, tls_tx))
 		return false;
 
 	if (!MLX5_CAP_GEN(mdev, log_max_dek))
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -269,7 +269,7 @@ struct sk_buff *mlx5e_tls_handle_tx_skb(
 	int datalen;
 	u32 skb_seq;
 
-	if (MLX5_CAP_GEN(sq->channel->mdev, tls)) {
+	if (MLX5_CAP_GEN(sq->channel->mdev, tls_tx)) {
 		skb = mlx5e_ktls_handle_tx_skb(netdev, sq, skb, wqe, pi);
 		goto out;
 	}
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -239,7 +239,7 @@ int mlx5_query_hca_caps(struct mlx5_core
 			return err;
 	}
 
-	if (MLX5_CAP_GEN(dev, tls)) {
+	if (MLX5_CAP_GEN(dev, tls_tx)) {
 		err = mlx5_core_get_caps(dev, MLX5_CAP_TLS);
 		if (err)
 			return err;
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1417,14 +1417,15 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         reserved_at_440[0x20];
 
-	u8         tls[0x1];
-	u8         reserved_at_461[0x2];
+	u8         reserved_at_460[0x3];
 	u8         log_max_uctx[0x5];
 	u8         reserved_at_468[0x3];
 	u8         log_max_umem[0x5];
 	u8         max_num_eqs[0x10];
 
-	u8         reserved_at_480[0x3];
+	u8         reserved_at_480[0x1];
+	u8         tls_tx[0x1];
+	u8         reserved_at_482[0x1];
 	u8         log_max_l2_table[0x5];
 	u8         reserved_at_488[0x8];
 	u8         log_uar_page_sz[0x10];


