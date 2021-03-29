Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C568934CA31
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234429AbhC2Ifs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233848AbhC2IeT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:34:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAD7861581;
        Mon, 29 Mar 2021 08:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006857;
        bh=HXxFCLh2hjF3+l+5onHlVjICg7eGsqXjours8iywO+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zZmRW8qEwvGocTAqur8kBjNXqPEtHnoH/D56/O6wrG5Nz6dh6edRDvrRaiZ6t5YpW
         3dCdDi5aNZWtld5+GjTCR23P5ALO2hN0O/jhjRI5FeEiX2aAatKfdo+bNsMuv6MGWq
         jajfbXDzul7E6dRGmmmn2COfoB7bdREqGre13UmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 119/254] net/mlx5e: E-switch, Fix rate calculation division
Date:   Mon, 29 Mar 2021 09:57:15 +0200
Message-Id: <20210329075637.128614467@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit 8b90d897823b28a51811931f3bdc79f8df79407e ]

do_div() returns reminder, while cited patch wanted to use
quotient.
Fix it by using quotient.

Fixes: 0e22bfb7c046 ("net/mlx5e: E-switch, Fix rate calculation for overflow")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 717fbaa6ce73..e9b7da05f14a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -5040,7 +5040,8 @@ static int apply_police_params(struct mlx5e_priv *priv, u64 rate,
 	 */
 	if (rate) {
 		rate = (rate * BITS_PER_BYTE) + 500000;
-		rate_mbps = max_t(u64, do_div(rate, 1000000), 1);
+		do_div(rate, 1000000);
+		rate_mbps = max_t(u32, rate, 1);
 	}
 
 	err = mlx5_esw_modify_vport_rate(esw, vport_num, rate_mbps);
-- 
2.30.1



