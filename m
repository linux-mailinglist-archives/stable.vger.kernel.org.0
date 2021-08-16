Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15B53ED634
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237986AbhHPNSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:18:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239876AbhHPNQb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:16:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9717B632E5;
        Mon, 16 Aug 2021 13:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119584;
        bh=YcVE0Oy/cmWLgozty8WMzI/97SELMO6QwLwVTGuNg1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ELlnzH6fGJjxB1W2MEWjFhkvab+T6WAflB0cOH07Emebfj9IFr+GULJKAGY46GW3O
         yxo+zvyjwisv1BLl53TB//g1PO/8yPFyaYNNABq5WrHX2KbzvFHydooOl5LUCpEshP
         Arsne3fGuaUZHN+LcKzuZC8MqBNBOP1i3TMCaP/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 082/151] net/mlx5e: Avoid creating tunnel headers for local route
Date:   Mon, 16 Aug 2021 15:01:52 +0200
Message-Id: <20210816125446.779241357@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

[ Upstream commit c623c95afa56bf4bf64e4f58742dc94616ef83db ]

It could be local and remote are on the same machine and the route
result will be a local route which will result in creating encap id
with src/dst mac address of 0.

Fixes: a54e20b4fcae ("net/mlx5e: Add basic TC tunnel set action for SRIOV offloads")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 172e0474f2e6..3980a3905084 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -124,6 +124,11 @@ static int mlx5e_route_lookup_ipv4_get(struct mlx5e_priv *priv,
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
 
+	if (rt->rt_type != RTN_UNICAST) {
+		ret = -ENETUNREACH;
+		goto err_rt_release;
+	}
+
 	if (mlx5_lag_is_multipath(mdev) && rt->rt_gw_family != AF_INET) {
 		ret = -ENETUNREACH;
 		goto err_rt_release;
-- 
2.30.2



