Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801A12C07A6
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732984AbgKWMmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:42:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:55896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732981AbgKWMmw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:42:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B7202076E;
        Mon, 23 Nov 2020 12:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135371;
        bh=9EXvbru8UBafmb7o//2zRdHllDLkAe9s/iBZpOtflt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hI7XEAP57jhsRsO/CxlDyG/P5KuyalwpYxb0m5NWVb7X/p2Ldbz80le/vI/ezpKlc
         oQh3YwcsxWaqoG9iDw+blo/MU9lIpNt+b0gTfI+G2ADXNS1O1QlZTXa3Ox2o+zQ9ck
         kCwd02RaT5GmwYTa5hd1kXoNBnF4QFG+EbMs19aE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.9 043/252] net/mlx5e: Fix check if netdev is bond slave
Date:   Mon, 23 Nov 2020 13:19:53 +0100
Message-Id: <20201123121837.662041164@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit 219b3267ca102a35092f5998921a9e6f99074af2 ]

Bond events handler uses bond_slave_get_rtnl to check if net device
is bond slave. bond_slave_get_rtnl return the rcu rx_handler pointer
from the netdev which exists for bond slaves but also exists for
devices that are attached to linux bridge so using it as indication
for bond slave is wrong.

Fix by using netif_is_lag_port instead.

Fixes: 7e51891a237f ("net/mlx5e: Use netdev events to set/del egress acl forward-to-vport rule")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
@@ -187,7 +187,7 @@ static bool mlx5e_rep_is_lag_netdev(stru
 	struct mlx5e_priv *priv;
 
 	/* A given netdev is not a representor or not a slave of LAG configuration */
-	if (!mlx5e_eswitch_rep(netdev) || !bond_slave_get_rtnl(netdev))
+	if (!mlx5e_eswitch_rep(netdev) || !netif_is_lag_port(netdev))
 		return false;
 
 	priv = netdev_priv(netdev);


