Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB1E3DD9EA
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234423AbhHBOFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:05:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236591AbhHBODc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:03:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0A0461211;
        Mon,  2 Aug 2021 13:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912640;
        bh=PpLBshF79vpConzbkrHRkjI2D8Qk/JOWna+XLDYDzTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oobBpshVb5dTyYmbBOsXfVLAXjoi8bckrV09eKckOE9F+esWZ5j+aFwHgED/EcDmG
         hzBKYOtWnWv85OewuE8QDiroJwiR/JhjDeqyOkn4W8djuyayOEvYNBVxLkn2d+isae
         PwMl4xMUMmuMkzk73imc/Pfb7Gf0yksoH3yZ9XHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 083/104] net/mlx5: Unload device upon firmware fatal error
Date:   Mon,  2 Aug 2021 15:45:20 +0200
Message-Id: <20210802134346.743470990@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit 7f331bf0f060c2727e36d64f9b098b4ee5f3dfad ]

When fw_fatal reporter reports an error, the firmware in not responding.
Unload the device to ensure that the driver closes all its resources,
even if recovery is not due (user disabled auto-recovery or reporter is
in grace period). On successful recovery the device is loaded back up.

Fixes: b3bd076f7501 ("net/mlx5: Report devlink health on FW fatal issues")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 9ff163c5bcde..9abeb80ffa31 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -626,8 +626,16 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
 	}
 	fw_reporter_ctx.err_synd = health->synd;
 	fw_reporter_ctx.miss_counter = health->miss_counter;
-	devlink_health_report(health->fw_fatal_reporter,
-			      "FW fatal error reported", &fw_reporter_ctx);
+	if (devlink_health_report(health->fw_fatal_reporter,
+				  "FW fatal error reported", &fw_reporter_ctx) == -ECANCELED) {
+		/* If recovery wasn't performed, due to grace period,
+		 * unload the driver. This ensures that the driver
+		 * closes all its resources and it is not subjected to
+		 * requests from the kernel.
+		 */
+		mlx5_core_err(dev, "Driver is in error state. Unloading\n");
+		mlx5_unload_one(dev);
+	}
 }
 
 static const struct devlink_health_reporter_ops mlx5_fw_fatal_reporter_ops = {
-- 
2.30.2



