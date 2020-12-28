Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D480C2E6719
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732385AbgL1NOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:14:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:42214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732382AbgL1NOE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:14:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED5DA208BA;
        Mon, 28 Dec 2020 13:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161203;
        bh=sxK1OPT0/O2hOVRIPuksVqKHu0D+wcbjUwnwMnkF/40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jaUcr9e5lrpryOM+keGGbofA9mxVTiR1SApIqxJ472UbUyjkn39FiX6dwupAPSJp6
         4IXLhcieJM4XkpF5jZPAormg+0rXE1Y3HGA9HNpB6/PGAf4+ehyPAJ1GLwrSRpzEkU
         CUXceK4BiSKxIhUheXsv4R42vfo/SnqFr+uNKF5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 135/242] net/mlx5: Properly convey driver version to firmware
Date:   Mon, 28 Dec 2020 13:49:00 +0100
Message-Id: <20201228124911.353183171@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 907af0f0cab4ee5d5604f182ecec2c5b5119d294 ]

mlx5 firmware expects driver version in specific format X.X.X, so
make it always correct and based on real kernel version aligned with
the driver.

Fixes: 012e50e109fd ("net/mlx5: Set driver version into firmware")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 1ac0e173da12c..049d9d19c66d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -51,6 +51,7 @@
 #ifdef CONFIG_RFS_ACCEL
 #include <linux/cpu_rmap.h>
 #endif
+#include <linux/version.h>
 #include <net/devlink.h>
 #include "mlx5_core.h"
 #include "fs_core.h"
@@ -204,7 +205,10 @@ static void mlx5_set_driver_version(struct mlx5_core_dev *dev)
 	strncat(string, ",", remaining_size);
 
 	remaining_size = max_t(int, 0, driver_ver_sz - strlen(string));
-	strncat(string, DRIVER_VERSION, remaining_size);
+
+	snprintf(string + strlen(string), remaining_size, "%u.%u.%u",
+		 (u8)((LINUX_VERSION_CODE >> 16) & 0xff), (u8)((LINUX_VERSION_CODE >> 8) & 0xff),
+		 (u16)(LINUX_VERSION_CODE & 0xffff));
 
 	/*Send the command*/
 	MLX5_SET(set_driver_version_in, in, opcode,
-- 
2.27.0



