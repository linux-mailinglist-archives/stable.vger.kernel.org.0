Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D440B34C8FE
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbhC2IZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:25:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234230AbhC2IYL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:24:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 038C16191F;
        Mon, 29 Mar 2021 08:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006249;
        bh=rftRmCZ/mMag9PPX3a0bi48psi9unyOes1jdQE4RAPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QBxNLy5M7zJHVFJ2v2+NkpFW9oaElBHjsuzilpaFEewRgr1LSBFmD5Li7yl84o4US
         94baUXlTHlq2Cy6y3vNbIQTx3W/KszxHP1CTHEoSaQLS2L7hQWBBA+nYBW88DtmfLY
         DtbququTXHW1s0K25TwF9RZVF1evVShiRTnuvtBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alaa Hleihel <alaa@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 171/221] net/mlx5e: Allow to match on MPLS parameters only for MPLS over UDP
Date:   Mon, 29 Mar 2021 09:58:22 +0200
Message-Id: <20210329075634.856847361@linuxfoundation.org>
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
index 4b8a442f09cd..77ee24d52203 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2597,6 +2597,16 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
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



