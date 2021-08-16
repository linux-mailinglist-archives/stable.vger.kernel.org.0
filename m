Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E190A3ED651
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236730AbhHPNU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239667AbhHPNQS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:16:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0F76632E6;
        Mon, 16 Aug 2021 13:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119578;
        bh=rQn+nlfPnhfgJ3O9LUqPWSl0kSekpU8G/CqbUvYPlh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OLJZl575AfjltiCiCEgm1RJeuGsWQxlPo/j0iH0Z/dtRL02aK8Z13syE35zkmE+ru
         cVo4IykMh0gcLXsTSvj5O3n9w8EPTwyjL/10rWxja4P6I5+y6UXJKVrTJhrcUgdX5Y
         9GockbdNJ0U/ybzoceLOk6ZPcZjOwgdvhSFJqC2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 080/151] net/mlx5: Dont skip subfunction cleanup in case of error in module init
Date:   Mon, 16 Aug 2021 15:01:50 +0200
Message-Id: <20210816125446.711687447@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit c633e799641cf13960bd83189b4d5b1b2adb0d4e ]

Clean SF resources if mlx5 eth failed to initialize.

Fixes: 1958fc2f0712 ("net/mlx5: SF, Add auxiliary device driver")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c      | 12 ++++--------
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h |  5 +++++
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 0d0f63a27aba..8c6d7f70e783 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1781,16 +1781,14 @@ static int __init init(void)
 	if (err)
 		goto err_sf;
 
-#ifdef CONFIG_MLX5_CORE_EN
 	err = mlx5e_init();
-	if (err) {
-		pci_unregister_driver(&mlx5_core_driver);
-		goto err_debug;
-	}
-#endif
+	if (err)
+		goto err_en;
 
 	return 0;
 
+err_en:
+	mlx5_sf_driver_unregister();
 err_sf:
 	pci_unregister_driver(&mlx5_core_driver);
 err_debug:
@@ -1800,9 +1798,7 @@ err_debug:
 
 static void __exit cleanup(void)
 {
-#ifdef CONFIG_MLX5_CORE_EN
 	mlx5e_cleanup();
-#endif
 	mlx5_sf_driver_unregister();
 	pci_unregister_driver(&mlx5_core_driver);
 	mlx5_unregister_debugfs();
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index a22b706eebd3..1824eb0b0e9a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -223,8 +223,13 @@ int mlx5_firmware_flash(struct mlx5_core_dev *dev, const struct firmware *fw,
 int mlx5_fw_version_query(struct mlx5_core_dev *dev,
 			  u32 *running_ver, u32 *stored_ver);
 
+#ifdef CONFIG_MLX5_CORE_EN
 int mlx5e_init(void);
 void mlx5e_cleanup(void);
+#else
+static inline int mlx5e_init(void){ return 0; }
+static inline void mlx5e_cleanup(void){}
+#endif
 
 static inline bool mlx5_sriov_is_enabled(struct mlx5_core_dev *dev)
 {
-- 
2.30.2



