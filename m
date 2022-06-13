Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6775497DB
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383471AbiFMObl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384809AbiFMOaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:30:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCCCA7755;
        Mon, 13 Jun 2022 04:48:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17DC8B80D31;
        Mon, 13 Jun 2022 11:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74967C34114;
        Mon, 13 Jun 2022 11:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120864;
        bh=vH6J/gK8G6z+u99kYZ1JFN+T2rfxlLFZB+g73Zj+g+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aQzJLHIk5ll+IpJOap794dMPKbVA1Iz3BNLY0SVLpqRqrBc2ZowZ0+GHlSM/XuEKL
         VoWPqgoHtsuMvLhjF6RiZgQqswaj8xkVf8lbDN0t9Vmd9mwOljBM7GsfkSv0iWfNfh
         yD9xOFmSdejBAwsZY284WBnzNirTB2aJ6rYW3TR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 185/298] net/mlx5: Lag, filter non compatible devices
Date:   Mon, 13 Jun 2022 12:11:19 +0200
Message-Id: <20220613094930.540239083@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

[ Upstream commit bc4c2f2e017949646b43fdcad005a03462d437c6 ]

When search for a peer lag device we can filter based on that
device's capabilities.

Downstream patch will be less strict when filtering compatible devices
and remove the limitation where we require exact MLX5_MAX_PORTS and
change it to a range.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 48 +++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 12 ++---
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  1 +
 3 files changed, 47 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index ba6dad97e308..3e750b827a19 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -555,12 +555,9 @@ static u32 mlx5_gen_pci_id(const struct mlx5_core_dev *dev)
 		     PCI_SLOT(dev->pdev->devfn));
 }
 
-static int next_phys_dev(struct device *dev, const void *data)
+static int _next_phys_dev(struct mlx5_core_dev *mdev,
+			  const struct mlx5_core_dev *curr)
 {
-	struct mlx5_adev *madev = container_of(dev, struct mlx5_adev, adev.dev);
-	struct mlx5_core_dev *mdev = madev->mdev;
-	const struct mlx5_core_dev *curr = data;
-
 	if (!mlx5_core_is_pf(mdev))
 		return 0;
 
@@ -574,8 +571,29 @@ static int next_phys_dev(struct device *dev, const void *data)
 	return 1;
 }
 
-/* Must be called with intf_mutex held */
-struct mlx5_core_dev *mlx5_get_next_phys_dev(struct mlx5_core_dev *dev)
+static int next_phys_dev(struct device *dev, const void *data)
+{
+	struct mlx5_adev *madev = container_of(dev, struct mlx5_adev, adev.dev);
+	struct mlx5_core_dev *mdev = madev->mdev;
+
+	return _next_phys_dev(mdev, data);
+}
+
+static int next_phys_dev_lag(struct device *dev, const void *data)
+{
+	struct mlx5_adev *madev = container_of(dev, struct mlx5_adev, adev.dev);
+	struct mlx5_core_dev *mdev = madev->mdev;
+
+	if (!MLX5_CAP_GEN(mdev, vport_group_manager) ||
+	    !MLX5_CAP_GEN(mdev, lag_master) ||
+	    MLX5_CAP_GEN(mdev, num_lag_ports) != MLX5_MAX_PORTS)
+		return 0;
+
+	return _next_phys_dev(mdev, data);
+}
+
+static struct mlx5_core_dev *mlx5_get_next_dev(struct mlx5_core_dev *dev,
+					       int (*match)(struct device *dev, const void *data))
 {
 	struct auxiliary_device *adev;
 	struct mlx5_adev *madev;
@@ -583,7 +601,7 @@ struct mlx5_core_dev *mlx5_get_next_phys_dev(struct mlx5_core_dev *dev)
 	if (!mlx5_core_is_pf(dev))
 		return NULL;
 
-	adev = auxiliary_find_device(NULL, dev, &next_phys_dev);
+	adev = auxiliary_find_device(NULL, dev, match);
 	if (!adev)
 		return NULL;
 
@@ -592,6 +610,20 @@ struct mlx5_core_dev *mlx5_get_next_phys_dev(struct mlx5_core_dev *dev)
 	return madev->mdev;
 }
 
+/* Must be called with intf_mutex held */
+struct mlx5_core_dev *mlx5_get_next_phys_dev(struct mlx5_core_dev *dev)
+{
+	lockdep_assert_held(&mlx5_intf_mutex);
+	return mlx5_get_next_dev(dev, &next_phys_dev);
+}
+
+/* Must be called with intf_mutex held */
+struct mlx5_core_dev *mlx5_get_next_phys_dev_lag(struct mlx5_core_dev *dev)
+{
+	lockdep_assert_held(&mlx5_intf_mutex);
+	return mlx5_get_next_dev(dev, &next_phys_dev_lag);
+}
+
 void mlx5_dev_list_lock(void)
 {
 	mutex_lock(&mlx5_intf_mutex);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 4ddf6b330a44..d4629f9bdab1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -804,12 +804,7 @@ static int __mlx5_lag_dev_add_mdev(struct mlx5_core_dev *dev)
 	struct mlx5_lag *ldev = NULL;
 	struct mlx5_core_dev *tmp_dev;
 
-	if (!MLX5_CAP_GEN(dev, vport_group_manager) ||
-	    !MLX5_CAP_GEN(dev, lag_master) ||
-	    MLX5_CAP_GEN(dev, num_lag_ports) != MLX5_MAX_PORTS)
-		return 0;
-
-	tmp_dev = mlx5_get_next_phys_dev(dev);
+	tmp_dev = mlx5_get_next_phys_dev_lag(dev);
 	if (tmp_dev)
 		ldev = tmp_dev->priv.lag;
 
@@ -854,6 +849,11 @@ void mlx5_lag_add_mdev(struct mlx5_core_dev *dev)
 {
 	int err;
 
+	if (!MLX5_CAP_GEN(dev, vport_group_manager) ||
+	    !MLX5_CAP_GEN(dev, lag_master) ||
+	    MLX5_CAP_GEN(dev, num_lag_ports) != MLX5_MAX_PORTS)
+		return;
+
 recheck:
 	mlx5_dev_list_lock();
 	err = __mlx5_lag_dev_add_mdev(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 2d2150fc7a0f..49c94acd75de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -210,6 +210,7 @@ void mlx5_detach_device(struct mlx5_core_dev *dev);
 int mlx5_register_device(struct mlx5_core_dev *dev);
 void mlx5_unregister_device(struct mlx5_core_dev *dev);
 struct mlx5_core_dev *mlx5_get_next_phys_dev(struct mlx5_core_dev *dev);
+struct mlx5_core_dev *mlx5_get_next_phys_dev_lag(struct mlx5_core_dev *dev);
 void mlx5_dev_list_lock(void);
 void mlx5_dev_list_unlock(void);
 int mlx5_dev_list_trylock(void);
-- 
2.35.1



