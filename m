Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7848E1CAB11
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbgEHMjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:39:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728587AbgEHMjc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:39:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4ED921835;
        Fri,  8 May 2020 12:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941571;
        bh=NAMYrY8U/+sMLlPIxI7tyI7KtqvtjCItcWu0XkIZcq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P8MMIOPMIlHRPvwPhMv4cnIPOsg19JPeAmKabe8r5+oVkSraXGej/GPtK0/hsiTiQ
         YUL9FABr53muNJlNvZUk1QVwLpCKD/+glIvwGLB/ZrmqweXQcdb+2KIaKed7deJuvH
         VX8HDAobblFbpOFBs5iJYReegEEOnUL6/cFBmpKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mohamad Haj Yahia <mohamad@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 085/312] net/mlx5: Fix pci error recovery flow
Date:   Fri,  8 May 2020 14:31:16 +0200
Message-Id: <20200508123130.527326814@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mohamad Haj Yahia <mohamad@mellanox.com>

commit 1061c90f524963a0a90e7d2f9a6bfa666458af51 upstream.

When PCI error is detected we should save the state of the pci prior to
disabling it.

Also when receiving pci slot reset call we need to verify that the
device is responsive.

Fixes: 89d44f0a6c73 ('net/mlx5_core: Add pci error handlers to mlx5_core
driver')
Signed-off-by: Mohamad Haj Yahia <mohamad@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
 drivers/net/ethernet/mellanox/mlx5/core/main.c |   59 ++++++++++++-------------
 1 file changed, 29 insertions(+), 30 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1276,36 +1276,12 @@ static pci_ers_result_t mlx5_pci_err_det
 	dev_info(&pdev->dev, "%s was called\n", __func__);
 	mlx5_enter_error_state(dev);
 	mlx5_unload_one(dev, priv);
+	pci_save_state(pdev);
 	mlx5_pci_disable_device(dev);
 	return state == pci_channel_io_perm_failure ?
 		PCI_ERS_RESULT_DISCONNECT : PCI_ERS_RESULT_NEED_RESET;
 }
 
-static pci_ers_result_t mlx5_pci_slot_reset(struct pci_dev *pdev)
-{
-	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
-	int err = 0;
-
-	dev_info(&pdev->dev, "%s was called\n", __func__);
-
-	err = mlx5_pci_enable_device(dev);
-	if (err) {
-		dev_err(&pdev->dev, "%s: mlx5_pci_enable_device failed with error code: %d\n"
-			, __func__, err);
-		return PCI_ERS_RESULT_DISCONNECT;
-	}
-	pci_set_master(pdev);
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-
-	return err ? PCI_ERS_RESULT_DISCONNECT : PCI_ERS_RESULT_RECOVERED;
-}
-
-void mlx5_disable_device(struct mlx5_core_dev *dev)
-{
-	mlx5_pci_err_detected(dev->pdev, 0);
-}
-
 /* wait for the device to show vital signs by waiting
  * for the health counter to start counting.
  */
@@ -1333,21 +1309,44 @@ static int wait_vital(struct pci_dev *pd
 	return -ETIMEDOUT;
 }
 
-static void mlx5_pci_resume(struct pci_dev *pdev)
+static pci_ers_result_t mlx5_pci_slot_reset(struct pci_dev *pdev)
 {
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
-	struct mlx5_priv *priv = &dev->priv;
 	int err;
 
 	dev_info(&pdev->dev, "%s was called\n", __func__);
 
-	pci_save_state(pdev);
-	err = wait_vital(pdev);
+	err = mlx5_pci_enable_device(dev);
 	if (err) {
+		dev_err(&pdev->dev, "%s: mlx5_pci_enable_device failed with error code: %d\n"
+			, __func__, err);
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	pci_set_master(pdev);
+	pci_restore_state(pdev);
+
+	if (wait_vital(pdev)) {
 		dev_err(&pdev->dev, "%s: wait_vital timed out\n", __func__);
-		return;
+		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
+	return PCI_ERS_RESULT_RECOVERED;
+}
+
+void mlx5_disable_device(struct mlx5_core_dev *dev)
+{
+	mlx5_pci_err_detected(dev->pdev, 0);
+}
+
+static void mlx5_pci_resume(struct pci_dev *pdev)
+{
+	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
+	struct mlx5_priv *priv = &dev->priv;
+	int err;
+
+	dev_info(&pdev->dev, "%s was called\n", __func__);
+
 	err = mlx5_load_one(dev, priv);
 	if (err)
 		dev_err(&pdev->dev, "%s: mlx5_load_one failed with error code: %d\n"


