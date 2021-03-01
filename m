Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C662D328C80
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240671AbhCASxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:53:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:53934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240419AbhCASqp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:46:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAC23652F8;
        Mon,  1 Mar 2021 17:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620461;
        bh=rjrBaSKwO2T6eIlNO9REibMHoK2LueiCIOlW4KbwrIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ivK2UHiJMugEptbDdJ98kvjbdVrv7u/rBM6Y/LlVezdJONVtvU2xjT+OI1Zvo+5Nd
         Rrp6JlpnmdURkxoo5/YG82V1fadYv2EK+O5E8h4/JyZbU5uDd7NIJVgOvaMSy67Vv9
         cD2nD3Lf5U8YO+OX3Mt8rJTwO3c1qur8CJPNVnnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Eli Cohen <elic@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 161/775] net/mlx5e: E-switch, Fix rate calculation for overflow
Date:   Mon,  1 Mar 2021 17:05:29 +0100
Message-Id: <20210301161209.594545828@linuxfoundation.org>
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

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit 0e22bfb7c046e7c8ae339f396e78a0976633698c ]

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
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index dd0bfbacad474..717fbaa6ce736 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -5040,7 +5040,7 @@ static int apply_police_params(struct mlx5e_priv *priv, u64 rate,
 	 */
 	if (rate) {
 		rate = (rate * BITS_PER_BYTE) + 500000;
-		rate_mbps = max_t(u32, do_div(rate, 1000000), 1);
+		rate_mbps = max_t(u64, do_div(rate, 1000000), 1);
 	}
 
 	err = mlx5_esw_modify_vport_rate(esw, vport_num, rate_mbps);
-- 
2.27.0



