Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76B96531967
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241958AbiEWRoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242652AbiEWRho (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:37:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559AE57160;
        Mon, 23 May 2022 10:31:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09E35B80EB0;
        Mon, 23 May 2022 17:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADDCC34115;
        Mon, 23 May 2022 17:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326947;
        bh=aQETEv3knpLMAwGuWM0fcNQn2UnC1ccPiguWubzSmgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fREopRI1wMSnLCTFfRLmZppqVpcUrqkvYNOcv18cOpOx4tPHnrUhOs1jzsIYB3SX3
         l5Vg5Ow4xwWy/RfZ7idF/dnJEPf7AcXt7C5/qJflvHLR/4h7EWEFOJHmb2LyiJI+QD
         kTxEej9UCcyNK+k8ivXOaXR9EKEPJgx267MYkBcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 109/158] net/mlx5: Drain fw_reset when removing device
Date:   Mon, 23 May 2022 19:04:26 +0200
Message-Id: <20220523165849.146262802@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 16d42d313350946f4b9a8b74a13c99f0461a6572 ]

In case fw sync reset is called in parallel to device removal, device
might stuck in the following deadlock:
         CPU 0                        CPU 1
         -----                        -----
                                  remove_one
                                   uninit_one (locks intf_state_mutex)
mlx5_sync_reset_now_event()
work in fw_reset->wq.
 mlx5_enter_error_state()
  mutex_lock (intf_state_mutex)
                                   cleanup_once
                                    fw_reset_cleanup()
                                     destroy_workqueue(fw_reset->wq)

Drain the fw_reset WQ, and make sure no new work is being queued, before
entering uninit_one().
The Drain is done before devlink_unregister() since fw_reset, in some
flows, is using devlink API devlink_remote_reload_actions_performed().

Fixes: 38b9f903f22b ("net/mlx5: Handle sync reset request event")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 25 ++++++++++++++++---
 .../ethernet/mellanox/mlx5/core/fw_reset.h    |  1 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |  4 +++
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 862f5b7cb210..1c771287bee5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -8,7 +8,8 @@
 enum {
 	MLX5_FW_RESET_FLAGS_RESET_REQUESTED,
 	MLX5_FW_RESET_FLAGS_NACK_RESET_REQUEST,
-	MLX5_FW_RESET_FLAGS_PENDING_COMP
+	MLX5_FW_RESET_FLAGS_PENDING_COMP,
+	MLX5_FW_RESET_FLAGS_DROP_NEW_REQUESTS
 };
 
 struct mlx5_fw_reset {
@@ -165,7 +166,10 @@ static void poll_sync_reset(struct timer_list *t)
 
 	if (fatal_error) {
 		mlx5_core_warn(dev, "Got Device Reset\n");
-		queue_work(fw_reset->wq, &fw_reset->reset_reload_work);
+		if (!test_bit(MLX5_FW_RESET_FLAGS_DROP_NEW_REQUESTS, &fw_reset->reset_flags))
+			queue_work(fw_reset->wq, &fw_reset->reset_reload_work);
+		else
+			mlx5_core_err(dev, "Device is being removed, Drop new reset work\n");
 		return;
 	}
 
@@ -390,9 +394,12 @@ static int fw_reset_event_notifier(struct notifier_block *nb, unsigned long acti
 	struct mlx5_fw_reset *fw_reset = mlx5_nb_cof(nb, struct mlx5_fw_reset, nb);
 	struct mlx5_eqe *eqe = data;
 
+	if (test_bit(MLX5_FW_RESET_FLAGS_DROP_NEW_REQUESTS, &fw_reset->reset_flags))
+		return NOTIFY_DONE;
+
 	switch (eqe->sub_type) {
 	case MLX5_GENERAL_SUBTYPE_FW_LIVE_PATCH_EVENT:
-			queue_work(fw_reset->wq, &fw_reset->fw_live_patch_work);
+		queue_work(fw_reset->wq, &fw_reset->fw_live_patch_work);
 		break;
 	case MLX5_GENERAL_SUBTYPE_PCI_SYNC_FOR_FW_UPDATE_EVENT:
 		mlx5_sync_reset_events_handle(fw_reset, eqe);
@@ -436,6 +443,18 @@ void mlx5_fw_reset_events_stop(struct mlx5_core_dev *dev)
 	mlx5_eq_notifier_unregister(dev, &dev->priv.fw_reset->nb);
 }
 
+void mlx5_drain_fw_reset(struct mlx5_core_dev *dev)
+{
+	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
+
+	set_bit(MLX5_FW_RESET_FLAGS_DROP_NEW_REQUESTS, &fw_reset->reset_flags);
+	cancel_work_sync(&fw_reset->fw_live_patch_work);
+	cancel_work_sync(&fw_reset->reset_request_work);
+	cancel_work_sync(&fw_reset->reset_reload_work);
+	cancel_work_sync(&fw_reset->reset_now_work);
+	cancel_work_sync(&fw_reset->reset_abort_work);
+}
+
 int mlx5_fw_reset_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_fw_reset *fw_reset = kzalloc(sizeof(*fw_reset), GFP_KERNEL);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
index 7761ee5fc7d0..372046e173e7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
@@ -15,6 +15,7 @@ int mlx5_fw_reset_set_live_patch(struct mlx5_core_dev *dev);
 int mlx5_fw_reset_wait_reset_done(struct mlx5_core_dev *dev);
 void mlx5_fw_reset_events_start(struct mlx5_core_dev *dev);
 void mlx5_fw_reset_events_stop(struct mlx5_core_dev *dev);
+void mlx5_drain_fw_reset(struct mlx5_core_dev *dev);
 int mlx5_fw_reset_init(struct mlx5_core_dev *dev);
 void mlx5_fw_reset_cleanup(struct mlx5_core_dev *dev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index f1437b6d4418..4e49dca94bc3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1628,6 +1628,10 @@ static void remove_one(struct pci_dev *pdev)
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
 	struct devlink *devlink = priv_to_devlink(dev);
 
+	/* mlx5_drain_fw_reset() is using devlink APIs. Hence, we must drain
+	 * fw_reset before unregistering the devlink.
+	 */
+	mlx5_drain_fw_reset(dev);
 	devlink_unregister(devlink);
 	mlx5_crdump_disable(dev);
 	mlx5_drain_health_wq(dev);
-- 
2.35.1



