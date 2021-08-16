Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D92A3ED638
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238684AbhHPNSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:18:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239888AbhHPNQd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:16:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC950632E9;
        Mon, 16 Aug 2021 13:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119589;
        bh=1T/M60qVtl9gUtEk+WyO7Jn76PhYbF9Hn3mSPpZtimc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J6ziek8p+DeQfQ7IQSAacm6Jw7rzT4bX081LWBUICsl8MBaoCXvAPDQQEuoafe7nE
         IHHFA7htVjS5kHfz0K3hsG8aN9pPeWHWrQY4X6+thdRAh4gT/MdNBgJOYUZYaWqfOS
         A0eqm+E/nM2gtf8a4MXyDld3NI2gMOv3iRGSVLpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 084/151] net/mlx5: Block switchdev mode while devlink traps are active
Date:   Mon, 16 Aug 2021 15:01:54 +0200
Message-Id: <20210816125446.841830343@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit c85a6b8feb16c0cdbbc8d9f581c7861c4a9ac351 ]

Since switchdev mode can't support  devlink traps, verify there are
no active devlink traps before moving eswitch to switchdev mode. If
there are active traps, prevent the switchdev mode configuration.

Fixes: eb3862a0525d ("net/mlx5e: Enable traps according to link state")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index b66e12753f37..d0e4daa55a4a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -48,6 +48,7 @@
 #include "lib/fs_chains.h"
 #include "en_tc.h"
 #include "en/mapping.h"
+#include "devlink.h"
 
 #define mlx5_esw_for_each_rep(esw, i, rep) \
 	xa_for_each(&((esw)->offloads.vport_reps), i, rep)
@@ -2984,12 +2985,19 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	if (cur_mlx5_mode == mlx5_mode)
 		goto unlock;
 
-	if (mode == DEVLINK_ESWITCH_MODE_SWITCHDEV)
+	if (mode == DEVLINK_ESWITCH_MODE_SWITCHDEV) {
+		if (mlx5_devlink_trap_get_num_active(esw->dev)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Can't change mode while devlink traps are active");
+			err = -EOPNOTSUPP;
+			goto unlock;
+		}
 		err = esw_offloads_start(esw, extack);
-	else if (mode == DEVLINK_ESWITCH_MODE_LEGACY)
+	} else if (mode == DEVLINK_ESWITCH_MODE_LEGACY) {
 		err = esw_offloads_stop(esw, extack);
-	else
+	} else {
 		err = -EINVAL;
+	}
 
 unlock:
 	mlx5_esw_unlock(esw);
-- 
2.30.2



