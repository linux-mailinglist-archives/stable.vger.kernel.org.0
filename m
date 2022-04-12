Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995324FD6C5
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355668AbiDLH2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351809AbiDLHM7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2466148;
        Mon, 11 Apr 2022 23:53:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1DF2B81B46;
        Tue, 12 Apr 2022 06:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24BE6C385A1;
        Tue, 12 Apr 2022 06:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746383;
        bh=ZD/EFkcltEj3oRNOMofn0Fu5/aRgslFsdd0GlSSGkgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ftoK2I7nzEgNoTytn+PnimK8FG2RUzLadaB5q+DIqcvjdBtGfF5NpOeMjpiPBobZa
         gHc5S74zPx1QB3lStcwx90rJWn8t8LoBnWIyi8p5H8DKJexHqeh1RQgmDzGW+N88E8
         va45biPefMAYIHoQBnlJFPJ6md3wD7mzq+ulRzGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, amirtz@nvidia.com,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        dann frazier <dann.frazier@canonical.com>
Subject: [PATCH 5.15 262/277] Revert "net/mlx5: Accept devlink user input after driver initialization complete"
Date:   Tue, 12 Apr 2022 08:31:05 +0200
Message-Id: <20220412062949.626572910@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: dann frazier <dann.frazier@canonical.com>

This reverts commit 9cc25e8529d567e08da98d11f092b21449763144 which is
commit 64ea2d0e7263b67d8efc93fa1baace041ed36d1e upstream.

This patch was shown to introduce a regression:

  # devlink dev param show pci/0000:24:00.0 name flow_steering_mode
  pci/0000:24:00.0:
    name flow_steering_mode type driver-specific
      values:

  (flow steering mode description is missing beneath "values:")

  # devlink dev param set pci/0000:24:00.0 name flow_steering_mode value smfs cmode runtime
  Segmentation fault (core dumped)

  and also with upstream iproute
  # ./iproute2/devlink/devlink dev param set pci/0000:24:00.0 name flow_steering_mode value smfs cmode runtime
  Configuration mode not supported

Note: Instead of reverting, we could instead also backport commit cf530217408e
("devlink: Notify users when objects are accessible"). However, that makes
changes to core devlink code that I'm not sure are suitable for a stable
backport.

Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: dann frazier <dann.frazier@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c       |   12 ++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/main.c          |    2 --
 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c |    2 --
 3 files changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -793,11 +793,14 @@ int mlx5_devlink_register(struct devlink
 {
 	int err;
 
-	err = devlink_params_register(devlink, mlx5_devlink_params,
-				      ARRAY_SIZE(mlx5_devlink_params));
+	err = devlink_register(devlink);
 	if (err)
 		return err;
 
+	err = devlink_params_register(devlink, mlx5_devlink_params,
+				      ARRAY_SIZE(mlx5_devlink_params));
+	if (err)
+		goto params_reg_err;
 	mlx5_devlink_set_params_init_values(devlink);
 
 	err = mlx5_devlink_auxdev_params_register(devlink);
@@ -808,6 +811,7 @@ int mlx5_devlink_register(struct devlink
 	if (err)
 		goto traps_reg_err;
 
+	devlink_params_publish(devlink);
 	return 0;
 
 traps_reg_err:
@@ -815,13 +819,17 @@ traps_reg_err:
 auxdev_reg_err:
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
+params_reg_err:
+	devlink_unregister(devlink);
 	return err;
 }
 
 void mlx5_devlink_unregister(struct devlink *devlink)
 {
+	devlink_params_unpublish(devlink);
 	mlx5_devlink_traps_unregister(devlink);
 	mlx5_devlink_auxdev_params_unregister(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
+	devlink_unregister(devlink);
 }
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1541,7 +1541,6 @@ static int probe_one(struct pci_dev *pde
 		dev_err(&pdev->dev, "mlx5_crdump_enable failed with error code %d\n", err);
 
 	pci_save_state(pdev);
-	devlink_register(devlink);
 	if (!mlx5_core_is_mp_slave(dev))
 		devlink_reload_enable(devlink);
 	return 0;
@@ -1564,7 +1563,6 @@ static void remove_one(struct pci_dev *p
 	struct devlink *devlink = priv_to_devlink(dev);
 
 	devlink_reload_disable(devlink);
-	devlink_unregister(devlink);
 	mlx5_crdump_disable(dev);
 	mlx5_drain_health_wq(dev);
 	mlx5_uninit_one(dev);
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -46,7 +46,6 @@ static int mlx5_sf_dev_probe(struct auxi
 		mlx5_core_warn(mdev, "mlx5_init_one err=%d\n", err);
 		goto init_one_err;
 	}
-	devlink_register(devlink);
 	devlink_reload_enable(devlink);
 	return 0;
 
@@ -66,7 +65,6 @@ static void mlx5_sf_dev_remove(struct au
 
 	devlink = priv_to_devlink(sf_dev->mdev);
 	devlink_reload_disable(devlink);
-	devlink_unregister(devlink);
 	mlx5_uninit_one(sf_dev->mdev);
 	iounmap(sf_dev->mdev->iseg);
 	mlx5_mdev_uninit(sf_dev->mdev);


