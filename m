Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF16F56D3
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389471AbfKHTL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:11:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:43272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732476AbfKHTK4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:10:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A30B5222CB;
        Fri,  8 Nov 2019 19:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240256;
        bh=EaCQpflTUZSUJ+NfNeJT/l/Xy4jwsgfkrS/58WizykM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V+/zxxZb9yUp/iHQ/s5R/UvxdEC2H8QAOHsxn8UGTpsm+ltS5/Cl9Uph5c8fC7Ggl
         1bfpezt2p46EGEWjG7iNF/Dq5ZAwnAf76FYtlT0CiF1KHCv+n4m6cRJ15MMt8vTuKL
         xlUU46EiEiegR1sy1wdmiOoZzcRadANcposdAbDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.3 118/140] net/mlx5e: Fix ethtool self test: link speed
Date:   Fri,  8 Nov 2019 19:50:46 +0100
Message-Id: <20191108174912.221253874@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

[ Upstream commit 534e7366f41b0c689b01af4375aefcd1462adedf ]

Ethtool self test contains a test for link speed. This test reads the
PTYS register and determines whether the current speed is valid or not.
Change current implementation to use the function mlx5e_port_linkspeed()
that does the same check and fails when speed is invalid. This code
redundancy lead to a bug when mlx5e_port_linkspeed() was updated with
expended speeds and the self test was not.

Fixes: 2c81bfd5ae56 ("net/mlx5e: Move port speed code from en_ethtool.c to en/port.c")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
@@ -35,6 +35,7 @@
 #include <linux/udp.h>
 #include <net/udp.h>
 #include "en.h"
+#include "en/port.h"
 
 enum {
 	MLX5E_ST_LINK_STATE,
@@ -80,22 +81,12 @@ static int mlx5e_test_link_state(struct
 
 static int mlx5e_test_link_speed(struct mlx5e_priv *priv)
 {
-	u32 out[MLX5_ST_SZ_DW(ptys_reg)];
-	u32 eth_proto_oper;
-	int i;
+	u32 speed;
 
 	if (!netif_carrier_ok(priv->netdev))
 		return 1;
 
-	if (mlx5_query_port_ptys(priv->mdev, out, sizeof(out), MLX5_PTYS_EN, 1))
-		return 1;
-
-	eth_proto_oper = MLX5_GET(ptys_reg, out, eth_proto_oper);
-	for (i = 0; i < MLX5E_LINK_MODES_NUMBER; i++) {
-		if (eth_proto_oper & MLX5E_PROT_MASK(i))
-			return 0;
-	}
-	return 1;
+	return mlx5e_port_linkspeed(priv->mdev, &speed);
 }
 
 struct mlx5ehdr {


