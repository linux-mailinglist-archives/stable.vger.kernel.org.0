Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89595521946
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbiEJNn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244876AbiEJNmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:42:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CB4E31;
        Tue, 10 May 2022 06:30:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5D58B81DA8;
        Tue, 10 May 2022 13:30:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BFEC385C2;
        Tue, 10 May 2022 13:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189439;
        bh=jVFazhQi8/W8+rEyYNcN7Ki5gek2t4YTsrbnXKN4TvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJ+7BSKt6uG1SuWORXOhhPWmt43SjOH/EHPCzjvUmzb1wJc9wZqzO/VNAceI9GyRE
         pB9DZTpHlYEOswby/agGQITv5gajXCaa7/pWeAxhWZOQpeZxat3/5fbJXVUztDnlXp
         IDPMfNni5PQtuOtU8x7oNI0FoAtr6DgG16ymWFd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Maher Sanalla <msanalla@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.15 052/135] net/mlx5: Avoid double clear or set of sync reset requested
Date:   Tue, 10 May 2022 15:07:14 +0200
Message-Id: <20220510130741.892975198@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

commit fc3d3db07b35885f238e1fa06b9f04a8fa7a62d0 upstream.

Double clear of reset requested state can lead to NULL pointer as it
will try to delete the timer twice. This can happen for example on a
race between abort from FW and pci error or reset. Avoid such case using
test_and_clear_bit() to verify only one time reset requested state clear
flow. Similarly use test_and_set_bit() to verify only one time reset
requested state set flow.

Fixes: 7dd6df329d4c ("net/mlx5: Handle sync reset abort event")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |   28 ++++++++++++++-------
 1 file changed, 19 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -134,14 +134,19 @@ static void mlx5_stop_sync_reset_poll(st
 	del_timer_sync(&fw_reset->timer);
 }
 
-static void mlx5_sync_reset_clear_reset_requested(struct mlx5_core_dev *dev, bool poll_health)
+static int mlx5_sync_reset_clear_reset_requested(struct mlx5_core_dev *dev, bool poll_health)
 {
 	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
 
+	if (!test_and_clear_bit(MLX5_FW_RESET_FLAGS_RESET_REQUESTED, &fw_reset->reset_flags)) {
+		mlx5_core_warn(dev, "Reset request was already cleared\n");
+		return -EALREADY;
+	}
+
 	mlx5_stop_sync_reset_poll(dev);
-	clear_bit(MLX5_FW_RESET_FLAGS_RESET_REQUESTED, &fw_reset->reset_flags);
 	if (poll_health)
 		mlx5_start_health_poll(dev);
+	return 0;
 }
 
 #define MLX5_RESET_POLL_INTERVAL	(HZ / 10)
@@ -185,13 +190,17 @@ static int mlx5_fw_reset_set_reset_sync_
 	return mlx5_reg_mfrl_set(dev, MLX5_MFRL_REG_RESET_LEVEL3, 0, 2, false);
 }
 
-static void mlx5_sync_reset_set_reset_requested(struct mlx5_core_dev *dev)
+static int mlx5_sync_reset_set_reset_requested(struct mlx5_core_dev *dev)
 {
 	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
 
+	if (test_and_set_bit(MLX5_FW_RESET_FLAGS_RESET_REQUESTED, &fw_reset->reset_flags)) {
+		mlx5_core_warn(dev, "Reset request was already set\n");
+		return -EALREADY;
+	}
 	mlx5_stop_health_poll(dev, true);
-	set_bit(MLX5_FW_RESET_FLAGS_RESET_REQUESTED, &fw_reset->reset_flags);
 	mlx5_start_sync_reset_poll(dev);
+	return 0;
 }
 
 static void mlx5_fw_live_patch_event(struct work_struct *work)
@@ -220,7 +229,9 @@ static void mlx5_sync_reset_request_even
 			       err ? "Failed" : "Sent");
 		return;
 	}
-	mlx5_sync_reset_set_reset_requested(dev);
+	if (mlx5_sync_reset_set_reset_requested(dev))
+		return;
+
 	err = mlx5_fw_reset_set_reset_sync_ack(dev);
 	if (err)
 		mlx5_core_warn(dev, "PCI Sync FW Update Reset Ack Failed. Error code: %d\n", err);
@@ -320,7 +331,8 @@ static void mlx5_sync_reset_now_event(st
 	struct mlx5_core_dev *dev = fw_reset->dev;
 	int err;
 
-	mlx5_sync_reset_clear_reset_requested(dev, false);
+	if (mlx5_sync_reset_clear_reset_requested(dev, false))
+		return;
 
 	mlx5_core_warn(dev, "Sync Reset now. Device is going to reset.\n");
 
@@ -349,10 +361,8 @@ static void mlx5_sync_reset_abort_event(
 						      reset_abort_work);
 	struct mlx5_core_dev *dev = fw_reset->dev;
 
-	if (!test_bit(MLX5_FW_RESET_FLAGS_RESET_REQUESTED, &fw_reset->reset_flags))
+	if (mlx5_sync_reset_clear_reset_requested(dev, true))
 		return;
-
-	mlx5_sync_reset_clear_reset_requested(dev, true);
 	mlx5_core_warn(dev, "PCI Sync FW Update Reset Aborted.\n");
 }
 


