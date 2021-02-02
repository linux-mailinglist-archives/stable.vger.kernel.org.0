Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9E530C081
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbhBBN7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:59:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233361AbhBBN5t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:57:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3210C64FEA;
        Tue,  2 Feb 2021 13:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273546;
        bh=NSrbssA9N5mouLo0H74iiWH8EjvtzwTJ54NEysIocvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SYGc47s4jDEzrusJjZof2GEB2PKDVE3/vl68ASsBgAI+O32/bFVlt4Z/FuYQFcz3t
         dULdkzMFQz3zQfLZqRk1to1Jk5Kit2LgSAIwXt50Xqsf9k/CSEkp8KEgC/eaZL2mhB
         sijcSk93PXsoQ20klOUfkH2LlZZSbrgtVFDqBw1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Eli Cohen <elic@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 115/142] net/mlx5e: E-switch, Fix rate calculation for overflow
Date:   Tue,  2 Feb 2021 14:37:58 +0100
Message-Id: <20210202133002.454474982@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit 1fe3e3166b35240615ab7f8276af2bbf2e51f559 ]

rate_bytes_ps is a 64-bit field. It passed as 32-bit field to
apply_police_params(). Due to this when police rate is higher
than 4Gbps, 32-bit calculation ignores the carry. This results
in incorrect rate configurationn the device.

Fix it by performing 64-bit calculation.

Fixes: fcb64c0f5640 ("net/mlx5: E-Switch, add ingress rate support")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index ce710f22b1fff..98cd5d8b0cd8b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -67,6 +67,7 @@
 #include "lib/geneve.h"
 #include "lib/fs_chains.h"
 #include "diag/en_tc_tracepoint.h"
+#include <asm/div64.h>
 
 #define nic_chains(priv) ((priv)->fs.tc.chains)
 #define MLX5_MH_ACT_SZ MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)
@@ -5009,13 +5010,13 @@ errout:
 	return err;
 }
 
-static int apply_police_params(struct mlx5e_priv *priv, u32 rate,
+static int apply_police_params(struct mlx5e_priv *priv, u64 rate,
 			       struct netlink_ext_ack *extack)
 {
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	struct mlx5_eswitch *esw;
+	u32 rate_mbps = 0;
 	u16 vport_num;
-	u32 rate_mbps;
 	int err;
 
 	vport_num = rpriv->rep->vport;
@@ -5032,7 +5033,11 @@ static int apply_police_params(struct mlx5e_priv *priv, u32 rate,
 	 * Moreover, if rate is non zero we choose to configure to a minimum of
 	 * 1 mbit/sec.
 	 */
-	rate_mbps = rate ? max_t(u32, (rate * 8 + 500000) / 1000000, 1) : 0;
+	if (rate) {
+		rate = (rate * BITS_PER_BYTE) + 500000;
+		rate_mbps = max_t(u32, do_div(rate, 1000000), 1);
+	}
+
 	err = mlx5_esw_modify_vport_rate(esw, vport_num, rate_mbps);
 	if (err)
 		NL_SET_ERR_MSG_MOD(extack, "failed applying action to hardware");
-- 
2.27.0



