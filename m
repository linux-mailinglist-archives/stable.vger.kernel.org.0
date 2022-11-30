Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CECCF63DF8F
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbiK3Ssj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiK3SsT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:48:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDCE99F7A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:48:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18F4961D59
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A481C433C1;
        Wed, 30 Nov 2022 18:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834096;
        bh=O412ofarK3CvQdJ8OrdghLE4xpBqQrJ9bMNUgQb295A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rIeRfvWeGen+tMfxswOKvJe/9gxIiOSVkhdc6JxCrmR/q5e8H/HfgcyTV1t33oxfX
         V86mSAx+VkHTph0ZBIFy43+2G42d0Yhfj5/s0x+bM91690ZP22/TN7uRkYYmDPnP6K
         NCg3iqfpO2UQlEBu89OcsGkNV8GR35jdBxOoYSok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Moshe Shemesh <moshe@nvidia.com>,
        Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 110/289] net/mlx5: Fix sync reset event handler error flow
Date:   Wed, 30 Nov 2022 19:21:35 +0100
Message-Id: <20221130180546.634648189@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit e1ad07b9227f9cbaf4bd2b6ec00b84c303657593 ]

When sync reset now event handling fails on mlx5_pci_link_toggle() then
no reset was done. However, since mlx5_cmd_fast_teardown_hca() was
already done, the firmware function is closed and the driver is left
without firmware functionality.

Fix it by setting device error state and reopen the firmware resources.
Reopening is done by the thread that was called for devlink reload
fw_activate as it already holds the devlink lock.

Fixes: 5ec697446f46 ("net/mlx5: Add support for devlink reload action fw activate")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 9d908a0ccfef..1e46f9afa40e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -9,7 +9,8 @@ enum {
 	MLX5_FW_RESET_FLAGS_RESET_REQUESTED,
 	MLX5_FW_RESET_FLAGS_NACK_RESET_REQUEST,
 	MLX5_FW_RESET_FLAGS_PENDING_COMP,
-	MLX5_FW_RESET_FLAGS_DROP_NEW_REQUESTS
+	MLX5_FW_RESET_FLAGS_DROP_NEW_REQUESTS,
+	MLX5_FW_RESET_FLAGS_RELOAD_REQUIRED
 };
 
 struct mlx5_fw_reset {
@@ -406,7 +407,7 @@ static void mlx5_sync_reset_now_event(struct work_struct *work)
 	err = mlx5_pci_link_toggle(dev);
 	if (err) {
 		mlx5_core_warn(dev, "mlx5_pci_link_toggle failed, no reset done, err %d\n", err);
-		goto done;
+		set_bit(MLX5_FW_RESET_FLAGS_RELOAD_REQUIRED, &fw_reset->reset_flags);
 	}
 
 	mlx5_enter_error_state(dev, true);
@@ -482,6 +483,10 @@ int mlx5_fw_reset_wait_reset_done(struct mlx5_core_dev *dev)
 		goto out;
 	}
 	err = fw_reset->ret;
+	if (test_and_clear_bit(MLX5_FW_RESET_FLAGS_RELOAD_REQUIRED, &fw_reset->reset_flags)) {
+		mlx5_unload_one_devl_locked(dev);
+		mlx5_load_one_devl_locked(dev, false);
+	}
 out:
 	clear_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags);
 	return err;
-- 
2.35.1



