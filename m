Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC9E664867
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238762AbjAJSL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239058AbjAJSKT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:10:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BB22630
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:08:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19197B81903
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F132C433EF;
        Tue, 10 Jan 2023 18:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374125;
        bh=jlOmdAKue0/3cXv6Og/LCjEuJemHzG6rE8+SpD5P36E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PMHRu+LD32RyhqnZD4pnpOag8JHPDGk38j4zkFRo0hjH111WJJmxMEBcFeh2/9uW2
         d318p503ndRgViAl4+CBZN0OsXhREQB7XxpXIso9QBJejEFb3skLJzgZG7NvMfKDR5
         8JRdTwksNfLb/02xZmnDcOm3DZcwOnh3S4BDUvJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 054/148] net/mlx5: Fix RoCE setting at HCA level
Date:   Tue, 10 Jan 2023 19:02:38 +0100
Message-Id: <20230110180018.938347997@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit c4ad5f2bdad56265b23d3635494ecdb205431807 ]

mlx5 PF can disable RoCE for its VFs and SFs. In such case RoCE is
marked as unsupported on those VFs/SFs.
The cited patch added an option for disable (and enable) RoCE at HCA
level. However, that commit didn't check whether RoCE is supported on
the HCA and enabled user to try and set RoCE to on.
Fix it by checking whether the HCA supports RoCE.

Fixes: fbfa97b4d79f ("net/mlx5: Disable roce at HCA level")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 9e4e8d551884..97e9ec44a759 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -468,7 +468,7 @@ static int mlx5_devlink_enable_roce_validate(struct devlink *devlink, u32 id,
 	bool new_state = val.vbool;
 
 	if (new_state && !MLX5_CAP_GEN(dev, roce) &&
-	    !MLX5_CAP_GEN(dev, roce_rw_supported)) {
+	    !(MLX5_CAP_GEN(dev, roce_rw_supported) && MLX5_CAP_GEN_MAX(dev, roce))) {
 		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support RoCE");
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index dcc1e1b404e3..0a2f23a7082a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -614,7 +614,7 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 		MLX5_SET(cmd_hca_cap, set_hca_cap, num_total_dynamic_vf_msix,
 			 MLX5_CAP_GEN_MAX(dev, num_total_dynamic_vf_msix));
 
-	if (MLX5_CAP_GEN(dev, roce_rw_supported))
+	if (MLX5_CAP_GEN(dev, roce_rw_supported) && MLX5_CAP_GEN_MAX(dev, roce))
 		MLX5_SET(cmd_hca_cap, set_hca_cap, roce,
 			 mlx5_is_roce_on(dev));
 
-- 
2.35.1



