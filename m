Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9848427C6DE
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730516AbgI2Lta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:49:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731034AbgI2LtR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:49:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A65B20848;
        Tue, 29 Sep 2020 11:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380156;
        bh=i3EfHdYOohIXj+K5BmUeu31cwD+F6t02U4edood6ifg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L1huxXVaoY9mE94mPDlRGBY+dAU+QEXov/ybPp1XfMfP83xWZ4YYRGUQmxHjM3ZyN
         RZCS+RSxHmHB5Kaz6HscGXPJw+zByhTpGotgmCoUnubcWhWV6reee8XAvjxUUgsAP5
         FWW3E68klkHgcWm3E7YcHGx4Vj2iMro+/DL6Tdq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 62/99] net/mlx5e: mlx5e_fec_in_caps() returns a boolean
Date:   Tue, 29 Sep 2020 13:01:45 +0200
Message-Id: <20200929105932.783884962@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

[ Upstream commit cb39ccc5cbe1011d8d21886b75e2468070ac672c ]

Returning errno is a bug, fix that.

Also fixes smatch warnings:
drivers/net/ethernet/mellanox/mlx5/core/en/port.c:453
mlx5e_fec_in_caps() warn: signedness bug returning '(-95)'

Fixes: 2132b71f78d2 ("net/mlx5e: Advertise globaly supported FEC modes")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
index 3cf3e35053f77..98e909bf3c1ec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -487,11 +487,8 @@ bool mlx5e_fec_in_caps(struct mlx5_core_dev *dev, int fec_policy)
 	int err;
 	int i;
 
-	if (!MLX5_CAP_GEN(dev, pcam_reg))
-		return -EOPNOTSUPP;
-
-	if (!MLX5_CAP_PCAM_REG(dev, pplm))
-		return -EOPNOTSUPP;
+	if (!MLX5_CAP_GEN(dev, pcam_reg) || !MLX5_CAP_PCAM_REG(dev, pplm))
+		return false;
 
 	MLX5_SET(pplm_reg, in, local_port, 1);
 	err =  mlx5_core_access_reg(dev, in, sz, out, sz, MLX5_REG_PPLM, 0, 0);
-- 
2.25.1



