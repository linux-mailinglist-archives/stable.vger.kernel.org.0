Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C587940948A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346579AbhIMObx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:31:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347122AbhIMOaQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:30:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C98A61B98;
        Mon, 13 Sep 2021 13:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541075;
        bh=5mJ3Vh4DFqEpbhgjatt+KHU+ltW1SZdkbGGb41choXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RAyQhIrBuRi+EUp3eVsQtz8a2bjXSh+BOBT1h1LL3VEc/IPW7sUYw2cUFjkDW+RBj
         Z7TBMpJ2nxK26l8Zjsh9UYUEme9JBobHV5RHVZ05wH8VkC6WFBiq5MK4uFsy0ncnk6
         KgNxHF8jdFCpysTplgmtF2363NKKZ64E/Yy/mKJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 152/334] net/mlx5: Fix missing return value in mlx5_devlink_eswitch_inline_mode_set()
Date:   Mon, 13 Sep 2021 15:13:26 +0200
Message-Id: <20210913131118.497657167@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit bcd68c04c7692416206414dc8971730aa140eba7 ]

The return value is missing in this code scenario, add the return value
'0' to the return value 'err'.

Eliminate the follow smatch warning:

drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c:3083
mlx5_devlink_eswitch_inline_mode_set() warn: missing error code 'err'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: 8e0aa4bc959c ("net/mlx5: E-switch, Protect eswitch mode changes")
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 3bb71a186004..fc945945ae33 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3091,8 +3091,11 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 
 	switch (MLX5_CAP_ETH(dev, wqe_inline_mode)) {
 	case MLX5_CAP_INLINE_MODE_NOT_REQUIRED:
-		if (mode == DEVLINK_ESWITCH_INLINE_MODE_NONE)
+		if (mode == DEVLINK_ESWITCH_INLINE_MODE_NONE) {
+			err = 0;
 			goto out;
+		}
+
 		fallthrough;
 	case MLX5_CAP_INLINE_MODE_L2:
 		NL_SET_ERR_MSG_MOD(extack, "Inline mode can't be set");
-- 
2.30.2



