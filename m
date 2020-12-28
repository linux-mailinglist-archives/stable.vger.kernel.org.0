Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74B32E39E0
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390058AbgL1N3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:29:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:57428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390053AbgL1N3L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:29:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AD5422A84;
        Mon, 28 Dec 2020 13:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162136;
        bh=9jxOFyCyJ5DXaq0kesIfUxzrBzma3bWM/RflylVh6ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZSnXSLLmezRz6I93b7b7+Po2BcOuIt2wUj1yVTwLsahQjgg6JBX898OBidOMgQcw
         NNnWnjA2bTRG31uVDUgWBuAPwQfqyYq46o8zfjUqhCSyLhM7vtAqO2ifLbL1TramjU
         cnFSFxJ92wiBB3iRaXyKZobuH3jRnSwwdoc6WZRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 200/346] net/mlx5: Properly convey driver version to firmware
Date:   Mon, 28 Dec 2020 13:48:39 +0100
Message-Id: <20201228124929.462367332@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index 5fac00ea62457..a2b25afa24722 100644
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
@@ -211,7 +212,10 @@ static void mlx5_set_driver_version(struct mlx5_core_dev *dev)
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



