Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF28483315
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbiACOdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:33:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33044 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234586AbiACObT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:31:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 475ADB80EBB;
        Mon,  3 Jan 2022 14:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB32C36AEB;
        Mon,  3 Jan 2022 14:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220277;
        bh=pQNluav7OGra4BWuktIEjCo49zh4QQCGB5iI8pV1pmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KxE26es+zkr8mslM0jel6qmPe/4nLxpFfYNospgkqiquepDXoRCNFUtNYHXlB8lZa
         8XaNFoGwvdxxo0t8SeB7vTysV2TZ/Rk1OKCAP78FnrRaMMoDEmhQER+/WO6/xP+pQw
         OC6hagAv0vsI9+iK3T/7aHtHEMU2foNOokMwK/Bs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 19/73] net/mlx5: Fix SF health recovery flow
Date:   Mon,  3 Jan 2022 15:23:40 +0100
Message-Id: <20220103142057.540343942@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit 33de865f7bce3968676e43b0182af0a2dd359dae ]

SF do not directly control the PCI device. During recovery flow SF
should not be allowed to do pci disable or pci reset, its PF will do it.

It fixes the following kernel trace:
mlx5_core.sf mlx5_core.sf.25: mlx5_health_try_recover:387:(pid 40948): starting health recovery flow
mlx5_core 0000:03:00.0: mlx5_pci_slot_reset was called
mlx5_core 0000:03:00.0: wait vital counter value 0xab175 after 1 iterations
mlx5_core.sf mlx5_core.sf.25: firmware version: 24.32.532
mlx5_core.sf mlx5_core.sf.23: mlx5_health_try_recover:387:(pid 40946): starting health recovery flow
mlx5_core 0000:03:00.0: mlx5_pci_slot_reset was called
mlx5_core 0000:03:00.0: wait vital counter value 0xab193 after 1 iterations
mlx5_core.sf mlx5_core.sf.23: firmware version: 24.32.532
mlx5_core.sf mlx5_core.sf.25: mlx5_cmd_check:813:(pid 40948): ENABLE_HCA(0x104) op_mod(0x0) failed,
status bad resource state(0x9), syndrome (0x658908)
mlx5_core.sf mlx5_core.sf.25: mlx5_function_setup:1292:(pid 40948): enable hca failed
mlx5_core.sf mlx5_core.sf.25: mlx5_health_try_recover:389:(pid 40948): health recovery failed

Fixes: 1958fc2f0712 ("net/mlx5: SF, Add auxiliary device driver")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 92b08fa07efae..92b01858d7f3e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1775,12 +1775,13 @@ void mlx5_disable_device(struct mlx5_core_dev *dev)
 
 int mlx5_recover_device(struct mlx5_core_dev *dev)
 {
-	int ret = -EIO;
+	if (!mlx5_core_is_sf(dev)) {
+		mlx5_pci_disable_device(dev);
+		if (mlx5_pci_slot_reset(dev->pdev) != PCI_ERS_RESULT_RECOVERED)
+			return -EIO;
+	}
 
-	mlx5_pci_disable_device(dev);
-	if (mlx5_pci_slot_reset(dev->pdev) == PCI_ERS_RESULT_RECOVERED)
-		ret = mlx5_load_one(dev);
-	return ret;
+	return mlx5_load_one(dev);
 }
 
 static struct pci_driver mlx5_core_driver = {
-- 
2.34.1



