Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E1D61595E
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiKBDJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiKBDJb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:09:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231A513FBE
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:09:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B05E5B82062
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332A5C433D6;
        Wed,  2 Nov 2022 03:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358567;
        bh=8GcQh6z/qDstFcU5DRKJPoZitdkm5j7QltSlGDP6wV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bcavEo/DieX/tYU0I5peIskTOnOOoCyrWFlM8Et7TfZxqYnEEsZ2w8kaWMi/dOsXU
         fxsp9fC+u02Aw863iSoU2+W06inijT9hyGJHhwgI0o/M1znQviMZtfOopbzsA/gMEb
         HkzFwGBdJKt9rchNjc6ATut6HbzOWcNq775EAekU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 120/132] net/mlx5: Print more info on pci error handlers
Date:   Wed,  2 Nov 2022 03:33:46 +0100
Message-Id: <20221102022102.824407646@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

[ Upstream commit fad1783a6d669ac82b6ea4f2f32b4ba2b5484920 ]

In case mlx5_pci_err_detected was called with state equals to
pci_channel_io_perm_failure, the driver will never come back up.

It is nice to know why the driver went to zombie land, so print some
useful information on pci err handlers.

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Stable-dep-of: 416ef7136319 ("net/mlx5: Update fw fatal reporter state on PCI handlers successful recover")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 51 ++++++++++++++-----
 1 file changed, 37 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 740065e21181..1f0156efe255 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1576,12 +1576,28 @@ static void remove_one(struct pci_dev *pdev)
 	mlx5_devlink_free(devlink);
 }
 
+#define mlx5_pci_trace(dev, fmt, ...) ({ \
+	struct mlx5_core_dev *__dev = (dev); \
+	mlx5_core_info(__dev, "%s Device state = %d health sensors: %d pci_status: %d. " fmt, \
+		       __func__, __dev->state, mlx5_health_check_fatal_sensors(__dev), \
+		       __dev->pci_status, ##__VA_ARGS__); \
+})
+
+static const char *result2str(enum pci_ers_result result)
+{
+	return  result == PCI_ERS_RESULT_NEED_RESET ? "need reset" :
+		result == PCI_ERS_RESULT_DISCONNECT ? "disconnect" :
+		result == PCI_ERS_RESULT_RECOVERED  ? "recovered" :
+		"unknown";
+}
+
 static pci_ers_result_t mlx5_pci_err_detected(struct pci_dev *pdev,
 					      pci_channel_state_t state)
 {
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
+	enum pci_ers_result res;
 
-	mlx5_core_info(dev, "%s was called\n", __func__);
+	mlx5_pci_trace(dev, "Enter, pci channel state = %d\n", state);
 
 	mlx5_enter_error_state(dev, false);
 	mlx5_error_sw_reset(dev);
@@ -1589,8 +1605,11 @@ static pci_ers_result_t mlx5_pci_err_detected(struct pci_dev *pdev,
 	mlx5_drain_health_wq(dev);
 	mlx5_pci_disable_device(dev);
 
-	return state == pci_channel_io_perm_failure ?
+	res = state == pci_channel_io_perm_failure ?
 		PCI_ERS_RESULT_DISCONNECT : PCI_ERS_RESULT_NEED_RESET;
+
+	mlx5_pci_trace(dev, "Exit, result = %d, %s\n",  res, result2str(res));
+	return res;
 }
 
 /* wait for the device to show vital signs by waiting
@@ -1624,28 +1643,34 @@ static int wait_vital(struct pci_dev *pdev)
 
 static pci_ers_result_t mlx5_pci_slot_reset(struct pci_dev *pdev)
 {
+	enum pci_ers_result res = PCI_ERS_RESULT_DISCONNECT;
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
 	int err;
 
-	mlx5_core_info(dev, "%s was called\n", __func__);
+	mlx5_pci_trace(dev, "Enter\n");
 
 	err = mlx5_pci_enable_device(dev);
 	if (err) {
 		mlx5_core_err(dev, "%s: mlx5_pci_enable_device failed with error code: %d\n",
 			      __func__, err);
-		return PCI_ERS_RESULT_DISCONNECT;
+		goto out;
 	}
 
 	pci_set_master(pdev);
 	pci_restore_state(pdev);
 	pci_save_state(pdev);
 
-	if (wait_vital(pdev)) {
-		mlx5_core_err(dev, "%s: wait_vital timed out\n", __func__);
-		return PCI_ERS_RESULT_DISCONNECT;
+	err = wait_vital(pdev);
+	if (err) {
+		mlx5_core_err(dev, "%s: wait vital failed with error code: %d\n",
+			      __func__, err);
+		goto out;
 	}
 
-	return PCI_ERS_RESULT_RECOVERED;
+	res = PCI_ERS_RESULT_RECOVERED;
+out:
+	mlx5_pci_trace(dev, "Exit, err = %d, result = %d, %s\n", err, res, result2str(res));
+	return res;
 }
 
 static void mlx5_pci_resume(struct pci_dev *pdev)
@@ -1653,14 +1678,12 @@ static void mlx5_pci_resume(struct pci_dev *pdev)
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
 	int err;
 
-	mlx5_core_info(dev, "%s was called\n", __func__);
+	mlx5_pci_trace(dev, "Enter, loading driver..\n");
 
 	err = mlx5_load_one(dev);
-	if (err)
-		mlx5_core_err(dev, "%s: mlx5_load_one failed with error code: %d\n",
-			      __func__, err);
-	else
-		mlx5_core_info(dev, "%s: device recovered\n", __func__);
+
+	mlx5_pci_trace(dev, "Done, err = %d, device %s\n", err,
+		       !err ? "recovered" : "Failed");
 }
 
 static const struct pci_error_handlers mlx5_err_handler = {
-- 
2.35.1



