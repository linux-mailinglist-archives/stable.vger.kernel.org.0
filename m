Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E4734CACF
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbhC2Ij6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:39:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232058AbhC2Ii6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:38:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D7B561581;
        Mon, 29 Mar 2021 08:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007137;
        bh=LatsfoIWkuAEW3l1DdWNftvFA8jWNeJrMMS4hSV3nMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r1IjJsqRBavDs6Q2ZmZU5ZOMc3jc2jdSfsOv3uiPErxs86L7lgmdxSRNuXu7sU7u4
         JNQSE6Y9UYcX0HRvHBueXXq+1+hxDNh2wm8rlN8e270/baNVUPHGuaufI6iePgaH3E
         rCCSVWCIvbUZVp4c/Ra+eE4Fc/s5leMfxrK1Z7uY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alaa Hleihel <alaa@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 200/254] net/mlx5e: Allow to match on MPLS parameters only for MPLS over UDP
Date:   Mon, 29 Mar 2021 09:58:36 +0200
Message-Id: <20210329075639.671172004@linuxfoundation.org>
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

From: Alaa Hleihel <alaa@nvidia.com>

[ Upstream commit 7d6c86e3ccb5ceea767df5c7a9a17cdfccd3df9a ]

Currently, we support hardware offload only for MPLS over UDP.
However, rules matching on MPLS parameters are now wrongly offloaded
for regular MPLS, without actually taking the parameters into
consideration when doing the offload.
Fix it by rejecting such unsupported rules.

Fixes: 72046a91d134 ("net/mlx5e: Allow to match on mpls parameters")
Signed-off-by: Alaa Hleihel <alaa@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index e9b7da05f14a..95cbefed1b32 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2595,6 +2595,16 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 			*match_level = MLX5_MATCH_L4;
 	}
 
+	/* Currenlty supported only for MPLS over UDP */
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_MPLS) &&
+	    !netif_is_bareudp(filter_dev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Matching on MPLS is supported only for MPLS over UDP");
+		netdev_err(priv->netdev,
+			   "Matching on MPLS is supported only for MPLS over UDP\n");
+		return -EOPNOTSUPP;
+	}
+
 	return 0;
 }
 
-- 
2.30.1



