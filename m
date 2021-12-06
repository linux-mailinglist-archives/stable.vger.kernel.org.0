Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0C1469F19
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391372AbhLFPpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390537AbhLFPma (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F7FC0698D3;
        Mon,  6 Dec 2021 07:28:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00F476131B;
        Mon,  6 Dec 2021 15:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9865C34900;
        Mon,  6 Dec 2021 15:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804484;
        bh=f+vxqzT73r2rlq92rOoNKxkKpasNEvIcUfmDH1B4V+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M9pScf8R2gVpNMOIUbCyczu0YuZNOzQ7jJksbfR2Kn7AA+larfBaov6BWDnoUejxh
         0oTfoB8gmIzAVwf5VANCt25d429wgEiWroX6DuQCJK7GgDqykTuZm5Zx+IoDaaClTw
         U4jCr2GM0J9GzesISJW7QDMo9F/xxMh1qWj0CpUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 163/207] net/mlx5: Move MODIFY_RQT command to ignore list in internal error state
Date:   Mon,  6 Dec 2021 15:56:57 +0100
Message-Id: <20211206145615.911060240@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit e45c0b34493c24eeeebf89f63a5293aac7728ed7 ]

When the device is in internal error state, command interface isn't
accessible and the driver decides which commands to fail and which
to ignore.

Move the MODIFY_RQT command to the ignore list in order to avoid
the following redundant warning messages in internal error state:

mlx5_core 0000:82:00.1: mlx5e_rss_disable:419:(pid 23754): Failed to redirect RQT 0x0 to drop RQ 0xc00848: err = -5
mlx5_core 0000:82:00.1: mlx5e_rx_res_channels_deactivate:598:(pid 23754): Failed to redirect direct RQT 0x1 to drop RQ 0xc00848 (channel 0): err = -5
mlx5_core 0000:82:00.1: mlx5e_rx_res_channels_deactivate:607:(pid 23754): Failed to redirect XSK RQT 0x19 to drop RQ 0xc00848 (channel 0): err = -5

Fixes: 43ec0f41fa73 ("net/mlx5e: Hide all implementation details of mlx5e_rx_res")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index c698e4b5381d7..bea35530c2d0b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -336,6 +336,7 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_DEALLOC_SF:
 	case MLX5_CMD_OP_DESTROY_UCTX:
 	case MLX5_CMD_OP_DESTROY_UMEM:
+	case MLX5_CMD_OP_MODIFY_RQT:
 		return MLX5_CMD_STAT_OK;
 
 	case MLX5_CMD_OP_QUERY_HCA_CAP:
@@ -441,7 +442,6 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_MODIFY_TIS:
 	case MLX5_CMD_OP_QUERY_TIS:
 	case MLX5_CMD_OP_CREATE_RQT:
-	case MLX5_CMD_OP_MODIFY_RQT:
 	case MLX5_CMD_OP_QUERY_RQT:
 
 	case MLX5_CMD_OP_CREATE_FLOW_TABLE:
-- 
2.33.0



