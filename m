Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E611FB821
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732864AbgFPPxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:53:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732283AbgFPPxd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:53:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4359A207C4;
        Tue, 16 Jun 2020 15:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322812;
        bh=1ELxeiNKC0u+xESZ8IGQ8vIZ933Fyh7SQNeFQw6Wj7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VVAsKKO8Ol0mxNoLZGyVue8G0JOoLCIu2/Q1VlEuUwaU6BhIwojnvrXqdTsS2o/aR
         6gqg6aKa0DJ9xHi92UXiRD4y0wA9Ypddo5fGcbx/R7SxIzxaAW7PWw+/cv+6tI2/YY
         eEe2R9OXi4iDqBvw/1EL8Gm/vyTOdceqjr2QHgoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.6 114/161] net/mlx5: Disable reload while removing the device
Date:   Tue, 16 Jun 2020 17:35:04 +0200
Message-Id: <20200616153111.786492956@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

[ Upstream commit 60904cd349abc98cb888fc28d1ca55a8e2cf87b3 ]

While unregistration is in progress, user might be reloading the
interface.
This can race with unregistration in below flow which uses the
resources which are getting disabled by reload flow.

Hence, disable the devlink reloading first when removing the device.

     CPU0                                   CPU1
     ----                                   ----
local_pci_remove()                  devlink_mutex
  remove_one()                       devlink_nl_cmd_reload()
    mlx5_unregister_device()           devlink_reload()
                                       ops->reload_down()
                                         mlx5_unload_one()

Fixes: 4383cfcc65e7 ("net/mlx5: Add devlink reload")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c |    2 --
 drivers/net/ethernet/mellanox/mlx5/core/main.c    |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -256,7 +256,6 @@ int mlx5_devlink_register(struct devlink
 		goto params_reg_err;
 	mlx5_devlink_set_params_init_values(devlink);
 	devlink_params_publish(devlink);
-	devlink_reload_enable(devlink);
 	return 0;
 
 params_reg_err:
@@ -266,7 +265,6 @@ params_reg_err:
 
 void mlx5_devlink_unregister(struct devlink *devlink)
 {
-	devlink_reload_disable(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
 	devlink_unregister(devlink);
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1371,6 +1371,7 @@ static int init_one(struct pci_dev *pdev
 		dev_err(&pdev->dev, "mlx5_crdump_enable failed with error code %d\n", err);
 
 	pci_save_state(pdev);
+	devlink_reload_enable(devlink);
 	return 0;
 
 err_load_one:
@@ -1388,6 +1389,7 @@ static void remove_one(struct pci_dev *p
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
 	struct devlink *devlink = priv_to_devlink(dev);
 
+	devlink_reload_disable(devlink);
 	mlx5_crdump_disable(dev);
 	mlx5_devlink_unregister(devlink);
 


