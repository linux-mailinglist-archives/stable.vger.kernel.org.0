Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D0134C908
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbhC2I0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:26:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232736AbhC2IYX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:24:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5AFC61581;
        Mon, 29 Mar 2021 08:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006252;
        bh=7CXtOLV9GsnVvCr7BJ+Vlm1+8Y2DrCcxIorQIc2cc0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cc4UhNT8sVVU6HyY7fBEZ+NooorDWV4e85ayIviTvZxtmtObDjcSZAmx2+47GITow
         Ogn5OVczzw45Ucu5yMNe2unv6ebSBNWnAtxFmBewdIUoaCsRA2cn/WqjZtJ0Iqnv0H
         KhC3jYYuk8anAkyV61zWMRpACgG654+6nQivORJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dima Chumak <dchumak@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 172/221] net/mlx5e: Offload tuple rewrite for non-CT flows
Date:   Mon, 29 Mar 2021 09:58:23 +0200
Message-Id: <20210329075634.893922952@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dima Chumak <dchumak@nvidia.com>

[ Upstream commit 96b5b4585843e3c83fb1930e5dfbefd0fb889c55 ]

Setting connection tracking OVS flows and then setting non-CT flows that
use tuple rewrite action (e.g. mod_tp_dst), causes the latter flows not
being offloaded.

Fix by using a stricter condition in modify_header_match_supported() to
check tuple rewrite support only for flows with CT action. The check is
factored out into standalone modify_tuple_supported() function to aid
readability.

Fixes: 7e36feeb0467 ("net/mlx5e: CT: Don't offload tuple rewrites for established tuples")
Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 44 ++++++++++++++-----
 2 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 24e2c0d955b9..b42396df3111 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1182,7 +1182,8 @@ int mlx5_tc_ct_add_no_trk_match(struct mlx5_flow_spec *spec)
 
 	mlx5e_tc_match_to_reg_get_match(spec, CTSTATE_TO_REG,
 					&ctstate, &ctstate_mask);
-	if (ctstate_mask)
+
+	if ((ctstate & ctstate_mask) == MLX5_CT_STATE_TRK_BIT)
 		return -EOPNOTSUPP;
 
 	ctstate_mask |= MLX5_CT_STATE_TRK_BIT;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 77ee24d52203..930f19c598bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3210,6 +3210,37 @@ static int is_action_keys_supported(const struct flow_action_entry *act,
 	return 0;
 }
 
+static bool modify_tuple_supported(bool modify_tuple, bool ct_clear,
+				   bool ct_flow, struct netlink_ext_ack *extack,
+				   struct mlx5e_priv *priv,
+				   struct mlx5_flow_spec *spec)
+{
+	if (!modify_tuple || ct_clear)
+		return true;
+
+	if (ct_flow) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "can't offload tuple modification with non-clear ct()");
+		netdev_info(priv->netdev,
+			    "can't offload tuple modification with non-clear ct()");
+		return false;
+	}
+
+	/* Add ct_state=-trk match so it will be offloaded for non ct flows
+	 * (or after clear action), as otherwise, since the tuple is changed,
+	 * we can't restore ct state
+	 */
+	if (mlx5_tc_ct_add_no_trk_match(spec)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "can't offload tuple modification with ct matches and no ct(clear) action");
+		netdev_info(priv->netdev,
+			    "can't offload tuple modification with ct matches and no ct(clear) action");
+		return false;
+	}
+
+	return true;
+}
+
 static bool modify_header_match_supported(struct mlx5e_priv *priv,
 					  struct mlx5_flow_spec *spec,
 					  struct flow_action *flow_action,
@@ -3248,18 +3279,9 @@ static bool modify_header_match_supported(struct mlx5e_priv *priv,
 			return err;
 	}
 
-	/* Add ct_state=-trk match so it will be offloaded for non ct flows
-	 * (or after clear action), as otherwise, since the tuple is changed,
-	 *  we can't restore ct state
-	 */
-	if (!ct_clear && modify_tuple &&
-	    mlx5_tc_ct_add_no_trk_match(spec)) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "can't offload tuple modify header with ct matches");
-		netdev_info(priv->netdev,
-			    "can't offload tuple modify header with ct matches");
+	if (!modify_tuple_supported(modify_tuple, ct_clear, ct_flow, extack,
+				    priv, spec))
 		return false;
-	}
 
 	ip_proto = MLX5_GET(fte_match_set_lyr_2_4, headers_v, ip_protocol);
 	if (modify_ip_header && ip_proto != IPPROTO_TCP &&
-- 
2.30.1



