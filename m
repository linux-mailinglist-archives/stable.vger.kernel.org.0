Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBAD3A01B7
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236943AbhFHSz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:55:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235857AbhFHSvw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:51:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB7026145F;
        Tue,  8 Jun 2021 18:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177600;
        bh=vhKXmRy8EHtl+bFeSlZPerbRoRyfhByHOIPq3L0KbY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BPogH+S5hMzd4otlgfEKWmbOTp2Cxpz2nFvNRdlGF2dgKE2IoXWQ8ZCq6Bn+HyzGq
         jHREBopwU/lqksKkVzA3cUVcJ3mbYgLMqAzRF0NszrWwas2kKsgVnmvmSnprsmvu39
         Qk4Hef58ZjcJ4K7jC/QiEhwl7shPIV6WxN3EhEog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/137] net/mlx5e: Check for needed capability for cvlan matching
Date:   Tue,  8 Jun 2021 20:26:11 +0200
Message-Id: <20210608175943.467646556@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

[ Upstream commit afe93f71b5d3cdae7209213ec8ef25210b837b93 ]

If not supported show an error and return instead of trying to offload
to the hardware and fail.

Fixes: 699e96ddf47f ("net/mlx5e: Support offloading tc double vlan headers match")
Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 1bdeb948f56d..80abdb0b47d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2253,11 +2253,13 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 				    misc_parameters);
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector *dissector = rule->match.dissector;
+	enum fs_flow_table_type fs_type;
 	u16 addr_type = 0;
 	u8 ip_proto = 0;
 	u8 *match_level;
 	int err;
 
+	fs_type = mlx5e_is_eswitch_flow(flow) ? FS_FT_FDB : FS_FT_NIC_RX;
 	match_level = outer_match_level;
 
 	if (dissector->used_keys &
@@ -2382,6 +2384,13 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 		if (match.mask->vlan_id ||
 		    match.mask->vlan_priority ||
 		    match.mask->vlan_tpid) {
+			if (!MLX5_CAP_FLOWTABLE_TYPE(priv->mdev, ft_field_support.outer_second_vid,
+						     fs_type)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Matching on CVLAN is not supported");
+				return -EOPNOTSUPP;
+			}
+
 			if (match.key->vlan_tpid == htons(ETH_P_8021AD)) {
 				MLX5_SET(fte_match_set_misc, misc_c,
 					 outer_second_svlan_tag, 1);
-- 
2.30.2



