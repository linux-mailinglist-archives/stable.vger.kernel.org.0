Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42ACF3A02A3
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234961AbhFHTHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:07:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237795AbhFHTFZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:05:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E25E26192C;
        Tue,  8 Jun 2021 18:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177991;
        bh=H9xI8GuPPQQvHzR2oM0KukBYfXD2JlmmHwYADkAuQGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vv/m8xlRhU0w2hpxQiPL6jJlPIjmYceHuyTucE6sRSggRGbipQzsdfB6a+JdxWLmh
         GW2SNrPZAW3ty7jwZTnAMJX42cpG8UY/KCrc7UiErHMnmTY/urRKi/blfNkdYrq9WB
         iAvGsQxVnxIMWu83+LQLmpxxVSZbpRMRfvHJWyTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 036/161] net/mlx5e: Check for needed capability for cvlan matching
Date:   Tue,  8 Jun 2021 20:26:06 +0200
Message-Id: <20210608175946.680308559@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
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
index 78a1403c9802..b633f669ea57 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1964,11 +1964,13 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
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
@@ -2093,6 +2095,13 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
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



