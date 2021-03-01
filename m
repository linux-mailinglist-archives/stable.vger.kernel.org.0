Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D863289B1
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239180AbhCASD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:03:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:49630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238827AbhCAR4Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:56:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FD82652EE;
        Mon,  1 Mar 2021 17:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620389;
        bh=PQNb0neKdTeAQzMPuKCnPI7CBBSU881esS1RmOcuQ+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FfzC6CJrKEV6zVjSL4pYr7R31QbtXOTFQB6iSgqgrMqoMLhDFBUTQ65vKtrwDSJ4i
         tpXtJ1vG8c7AenNlELVZxvmE4KbWkYRxx85cZ/sHG8k1husgGLpAJbIgnIM+riFtK7
         ufq28RtjjbOCMWDJP2YpXBJUZwsM+alMEqWKeJL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Alaa Hleihel <alaa@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 105/775] net/mlx5e: Enable XDP for Connect-X IPsec capable devices
Date:   Mon,  1 Mar 2021 17:04:33 +0100
Message-Id: <20210301161206.849524976@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

[ Upstream commit e33f9f5f2d3a5fa97728a43708f41da2d4faae65 ]

This limitation was inherited by previous Innova (FPGA) IPsec
implementation, it uses its private set of RQ handlers which
does not support XDP, for Connect-X this is no longer true.

Fix by keeping this limitation only for Innova IPsec supporting devices,
as otherwise this limitation effectively wrongly blocks XDP for all
future Connect-X devices for all flows even if IPsec offload is not
used.

Fixes: 2d64663cd559 ("net/mlx5: IPsec: Add HW crypto offload support")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Alaa Hleihel <alaa@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3fc7d18ac868b..92436569ce86b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4455,8 +4455,9 @@ static int mlx5e_xdp_allowed(struct mlx5e_priv *priv, struct bpf_prog *prog)
 		return -EINVAL;
 	}
 
-	if (MLX5_IPSEC_DEV(priv->mdev)) {
-		netdev_warn(netdev, "can't set XDP with IPSec offload\n");
+	if (mlx5_fpga_is_ipsec_device(priv->mdev)) {
+		netdev_warn(netdev,
+			    "XDP is not available on Innova cards with IPsec support\n");
 		return -EINVAL;
 	}
 
-- 
2.27.0



