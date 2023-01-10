Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01FE466491E
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239147AbjAJSSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:18:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239193AbjAJSR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:17:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BAEDD6C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:15:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 276616183C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17953C433F0;
        Tue, 10 Jan 2023 18:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374555;
        bh=wUjPSj0Y21PCsF42h/PRTsbBwKOarE0Iin+YDkUH7tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oZPTPpqEDwKXlQ9AHrepJZiaFluDHi7C4hxBRFCej666pOkIYOL0r49caxZI0fQJs
         rHBrpIqQv3cTxD79dXZwnoVNFK3OxacRcoCV6yj3ObbzobPnU9Tx7SFpZeEmKH5aFx
         QUiQBM1ZeffEJ+R81kqDn0e243oeSfC57HUHm50s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/159] net/mlx5: Avoid recovery in probe flows
Date:   Tue, 10 Jan 2023 19:03:22 +0100
Message-Id: <20230110180020.022355093@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 9078e843efec530f279a155f262793c58b0746bd ]

Currently, recovery is done without considering whether the device is
still in probe flow.
This may lead to recovery before device have finished probed
successfully. e.g.: while mlx5_init_one() is running. Recovery flow is
using functionality that is loaded only by mlx5_init_one(), and there
is no point in running recovery without mlx5_init_one() finished
successfully.

Fix it by waiting for probe flow to finish and checking whether the
device is probed before trying to perform recovery.

Fixes: 51d138c2610a ("net/mlx5: Fix health error state handling")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 86ed87d704f7..96417c5feed7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -674,6 +674,12 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
 	dev = container_of(priv, struct mlx5_core_dev, priv);
 	devlink = priv_to_devlink(dev);
 
+	mutex_lock(&dev->intf_state_mutex);
+	if (test_bit(MLX5_DROP_NEW_HEALTH_WORK, &health->flags)) {
+		mlx5_core_err(dev, "health works are not permitted at this stage\n");
+		return;
+	}
+	mutex_unlock(&dev->intf_state_mutex);
 	enter_error_state(dev, false);
 	if (IS_ERR_OR_NULL(health->fw_fatal_reporter)) {
 		devl_lock(devlink);
-- 
2.35.1



