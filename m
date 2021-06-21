Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9311F3AEE49
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbhFUQ1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:27:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231906AbhFUQZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:25:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16CEC6138C;
        Mon, 21 Jun 2021 16:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292526;
        bh=NDZNwh+bBldmUqE49BIqZcrIJBNlkcvI8m9AxcYqJTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wNU0EJomx5sdRAHget7RFECux/9/gBSFhJXJciOQJJt+3+wJITvlpbjmbJvQTWopV
         cUDO18IC8Ki9lQcZu+8V4x1W+RKNP3DeoWhE9v6+TkqJZOmqrwfanXi+EUQ2KgR9PT
         dAlSTUwXt5EqvB0JljiUjJotVgY7Zx6BdxKYibDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/146] net/mlx5: DR, Dont use SW steering when RoCE is not supported
Date:   Mon, 21 Jun 2021 18:14:22 +0200
Message-Id: <20210621154912.380403140@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

[ Upstream commit 4aaf96ac8b45d8e2e019b6b53cce65a73c4ace2c ]

SW steering uses RC QP to write/read to/from ICM, hence it's not
supported when RoCE is not supported as well.

Fixes: 70605ea545e8 ("net/mlx5: DR, Expose APIs for direct rule managing")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h    | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index 6f3db8dc896c..454968ba6831 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -124,10 +124,11 @@ int mlx5dr_action_destroy(struct mlx5dr_action *action);
 static inline bool
 mlx5dr_is_supported(struct mlx5_core_dev *dev)
 {
-	return MLX5_CAP_ESW_FLOWTABLE_FDB(dev, sw_owner) ||
-	       (MLX5_CAP_ESW_FLOWTABLE_FDB(dev, sw_owner_v2) &&
-		(MLX5_CAP_GEN(dev, steering_format_version) <=
-		 MLX5_STEERING_FORMAT_CONNECTX_6DX));
+	return MLX5_CAP_GEN(dev, roce) &&
+	       (MLX5_CAP_ESW_FLOWTABLE_FDB(dev, sw_owner) ||
+		(MLX5_CAP_ESW_FLOWTABLE_FDB(dev, sw_owner_v2) &&
+		 (MLX5_CAP_GEN(dev, steering_format_version) <=
+		  MLX5_STEERING_FORMAT_CONNECTX_6DX)));
 }
 
 #endif /* _MLX5DR_H_ */
-- 
2.30.2



