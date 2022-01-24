Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630D349997C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455525AbiAXVfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:35:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43504 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389446AbiAXV2g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:28:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E33E0B815F0;
        Mon, 24 Jan 2022 21:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134E1C340E4;
        Mon, 24 Jan 2022 21:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059713;
        bh=znjJmoVJnraVGpkGuprtqsLw4qdshBWPmmtBakZY010=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YGtjB4CJcfIIqsFP+5alGYs7ELiRoit3CiGMSoZmjFY0ydlDEdEt9B2mHqvp0YPo+
         LMDgysfJbIZdMiDlaBDb8EL53g6G4SiOLpeFFra9l6Rv/fr1Hu1CbPTL0NeKTI1csa
         EoCsQqE072lLKUXpI5KnF7X+9bMz4nl6baorv0i8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0708/1039] net/mlx5: DR, Fix error flow in creating matcher
Date:   Mon, 24 Jan 2022 19:41:37 +0100
Message-Id: <20220124184149.132953758@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit 84dfac39c61fde04126e23723138128b50cd036f ]

The error code of nic matcher init functions wasn't checked.
This patch improves the matcher init function and fix error flow bug:
the handling of match parameter is moved into a separate function
and error flow is simplified.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/steering/dr_matcher.c  | 53 +++++++++++--------
 1 file changed, 32 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 793365242e852..3d0cdc36a91ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -872,13 +872,12 @@ uninit_nic_rx:
 	return ret;
 }
 
-static int dr_matcher_init(struct mlx5dr_matcher *matcher,
-			   struct mlx5dr_match_parameters *mask)
+static int dr_matcher_copy_param(struct mlx5dr_matcher *matcher,
+				 struct mlx5dr_match_parameters *mask)
 {
+	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
 	struct mlx5dr_match_parameters consumed_mask;
-	struct mlx5dr_table *tbl = matcher->tbl;
-	struct mlx5dr_domain *dmn = tbl->dmn;
-	int i, ret;
+	int i, ret = 0;
 
 	if (matcher->match_criteria >= DR_MATCHER_CRITERIA_MAX) {
 		mlx5dr_err(dmn, "Invalid match criteria attribute\n");
@@ -898,10 +897,36 @@ static int dr_matcher_init(struct mlx5dr_matcher *matcher,
 		consumed_mask.match_sz = mask->match_sz;
 		memcpy(consumed_mask.match_buf, mask->match_buf, mask->match_sz);
 		mlx5dr_ste_copy_param(matcher->match_criteria,
-				      &matcher->mask, &consumed_mask,
-				      true);
+				      &matcher->mask, &consumed_mask, true);
+
+		/* Check that all mask data was consumed */
+		for (i = 0; i < consumed_mask.match_sz; i++) {
+			if (!((u8 *)consumed_mask.match_buf)[i])
+				continue;
+
+			mlx5dr_dbg(dmn,
+				   "Match param mask contains unsupported parameters\n");
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
+		kfree(consumed_mask.match_buf);
 	}
 
+	return ret;
+}
+
+static int dr_matcher_init(struct mlx5dr_matcher *matcher,
+			   struct mlx5dr_match_parameters *mask)
+{
+	struct mlx5dr_table *tbl = matcher->tbl;
+	struct mlx5dr_domain *dmn = tbl->dmn;
+	int ret;
+
+	ret = dr_matcher_copy_param(matcher, mask);
+	if (ret)
+		return ret;
+
 	switch (dmn->type) {
 	case MLX5DR_DOMAIN_TYPE_NIC_RX:
 		matcher->rx.nic_tbl = &tbl->rx;
@@ -919,22 +944,8 @@ static int dr_matcher_init(struct mlx5dr_matcher *matcher,
 	default:
 		WARN_ON(true);
 		ret = -EINVAL;
-		goto free_consumed_mask;
-	}
-
-	/* Check that all mask data was consumed */
-	for (i = 0; i < consumed_mask.match_sz; i++) {
-		if (!((u8 *)consumed_mask.match_buf)[i])
-			continue;
-
-		mlx5dr_dbg(dmn, "Match param mask contains unsupported parameters\n");
-		ret = -EOPNOTSUPP;
-		goto free_consumed_mask;
 	}
 
-	ret =  0;
-free_consumed_mask:
-	kfree(consumed_mask.match_buf);
 	return ret;
 }
 
-- 
2.34.1



