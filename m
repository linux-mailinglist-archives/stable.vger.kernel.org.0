Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6B128B837
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389888AbgJLNuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:50:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731903AbgJLNsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62C242227F;
        Mon, 12 Oct 2020 13:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510486;
        bh=Lz38F2htKW8lqyS4IEjzMtC5yF0YCQOCPlgyXQRaPeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWWnrHcS65RNgJZ7eL++67wF0irDpnXIXh4O58FrCljuOE5XjBRvi4fwMvYB0/kqc
         zjIPkeAj0lgySE9Q3NcxP3dfOjbiSGSmQDnc6KJflNMj+R+6+8EYmhHEFTIPsl4GeK
         +QfVIE9fQyfCatPXAn+fE2MA/IbjhK4+VSILl6e8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 090/124] net/mlx5e: Fix return status when setting unsupported FEC mode
Date:   Mon, 12 Oct 2020 15:31:34 +0200
Message-Id: <20201012133151.210002525@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

[ Upstream commit 2608a2f831c47dfdf18885a7289be5af97182b05 ]

Verify the configured FEC mode is supported by at least a single link
mode before applying the command. Otherwise fail the command and return
"Operation not supported".
Prior to this patch, the command was successful, yet it falsely set all
link modes to FEC auto mode - like configuring FEC mode to auto. Auto
mode is the default configuration if a link mode doesn't support the
configured FEC mode.

Fixes: b5ede32d3329 ("net/mlx5e: Add support for FEC modes based on 50G per lane links")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
index 98e909bf3c1ec..3e32264cf6131 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -566,6 +566,9 @@ int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u16 fec_policy)
 	if (fec_policy >= (1 << MLX5E_FEC_LLRS_272_257_1) && !fec_50g_per_lane)
 		return -EOPNOTSUPP;
 
+	if (fec_policy && !mlx5e_fec_in_caps(dev, fec_policy))
+		return -EOPNOTSUPP;
+
 	MLX5_SET(pplm_reg, in, local_port, 1);
 	err = mlx5_core_access_reg(dev, in, sz, out, sz, MLX5_REG_PPLM, 0, 0);
 	if (err)
-- 
2.25.1



