Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1911CAFF9
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbgEHNW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:22:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728567AbgEHMjP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:39:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 436DB2495F;
        Fri,  8 May 2020 12:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941553;
        bh=dgN/DUqz39yavDE/8yM29cvjUKtLkthSL/wVYeaGG/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HyeWM+IjLgCMJu0KWmk8GV5dWIiU4yXCOdKNGVpwRyPLQh4LODThW31BDK+0WrI0h
         d9VoY9zuBk12Cm7DX+IJoVRQ/S8eXuEI9MBmO1UA+2JxgECWr6ci5RyTL0XIazxTJ6
         VWRL4+DLLEt3i/KhS50c4Ihwuh5PNfxez6pi2O7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Jurgens <danielj@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 061/312] net/mlx4_core: Implement pci_resume callback
Date:   Fri,  8 May 2020 14:30:52 +0200
Message-Id: <20200508123128.845255959@linuxfoundation.org>
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

From: Daniel Jurgens <danielj@mellanox.com>

commit c12833acff62cff83a8b728253e7ebbc1264d75e upstream.

Move resume related activities to a new pci_resume function instead of
performing them in mlx4_pci_slot_reset.  This change is needed to avoid
a hotplug during EEH recovery due to commit f2da4ccf8bd4 ("powerpc/eeh:
More relaxed hotplug criterion").

Fixes: 2ba5fbd62b25 ('net/mlx4_core: Handle AER flow properly')
Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx4/main.c |   39 ++++++++++++++++++------------
 1 file changed, 24 insertions(+), 15 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3854,45 +3854,53 @@ static pci_ers_result_t mlx4_pci_slot_re
 {
 	struct mlx4_dev_persistent *persist = pci_get_drvdata(pdev);
 	struct mlx4_dev	 *dev  = persist->dev;
-	struct mlx4_priv *priv = mlx4_priv(dev);
-	int               ret;
-	int nvfs[MLX4_MAX_PORTS + 1] = {0, 0, 0};
-	int total_vfs;
+	int err;
 
 	mlx4_err(dev, "mlx4_pci_slot_reset was called\n");
-	ret = pci_enable_device(pdev);
-	if (ret) {
-		mlx4_err(dev, "Can not re-enable device, ret=%d\n", ret);
+	err = pci_enable_device(pdev);
+	if (err) {
+		mlx4_err(dev, "Can not re-enable device, err=%d\n", err);
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
 	pci_set_master(pdev);
 	pci_restore_state(pdev);
 	pci_save_state(pdev);
+	return PCI_ERS_RESULT_RECOVERED;
+}
+
+static void mlx4_pci_resume(struct pci_dev *pdev)
+{
+	struct mlx4_dev_persistent *persist = pci_get_drvdata(pdev);
+	struct mlx4_dev	 *dev  = persist->dev;
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	int nvfs[MLX4_MAX_PORTS + 1] = {0, 0, 0};
+	int total_vfs;
+	int err;
 
+	mlx4_err(dev, "%s was called\n", __func__);
 	total_vfs = dev->persist->num_vfs;
 	memcpy(nvfs, dev->persist->nvfs, sizeof(dev->persist->nvfs));
 
 	mutex_lock(&persist->interface_state_mutex);
 	if (!(persist->interface_state & MLX4_INTERFACE_STATE_UP)) {
-		ret = mlx4_load_one(pdev, priv->pci_dev_data, total_vfs, nvfs,
+		err = mlx4_load_one(pdev, priv->pci_dev_data, total_vfs, nvfs,
 				    priv, 1);
-		if (ret) {
-			mlx4_err(dev, "%s: mlx4_load_one failed, ret=%d\n",
-				 __func__,  ret);
+		if (err) {
+			mlx4_err(dev, "%s: mlx4_load_one failed, err=%d\n",
+				 __func__,  err);
 			goto end;
 		}
 
-		ret = restore_current_port_types(dev, dev->persist->
+		err = restore_current_port_types(dev, dev->persist->
 						 curr_port_type, dev->persist->
 						 curr_port_poss_type);
-		if (ret)
-			mlx4_err(dev, "could not restore original port types (%d)\n", ret);
+		if (err)
+			mlx4_err(dev, "could not restore original port types (%d)\n", err);
 	}
 end:
 	mutex_unlock(&persist->interface_state_mutex);
 
-	return ret ? PCI_ERS_RESULT_DISCONNECT : PCI_ERS_RESULT_RECOVERED;
 }
 
 static void mlx4_shutdown(struct pci_dev *pdev)
@@ -3909,6 +3917,7 @@ static void mlx4_shutdown(struct pci_dev
 static const struct pci_error_handlers mlx4_err_handler = {
 	.error_detected = mlx4_pci_err_detected,
 	.slot_reset     = mlx4_pci_slot_reset,
+	.resume		= mlx4_pci_resume,
 };
 
 static struct pci_driver mlx4_driver = {


