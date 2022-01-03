Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BCB483313
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234527AbiACOdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:33:16 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60718 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234558AbiACObP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:31:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B851461073;
        Mon,  3 Jan 2022 14:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F978C36AEB;
        Mon,  3 Jan 2022 14:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220274;
        bh=Foai4sLAMDdhPCoXa828rM1d8oaNt8Fvd2wVnhbSfQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D+Fvfml6lBHsPy/VorLFBZZ87Ssj3tJ0ruXAStTQ2g8zklqsk6fwEW8efGy1M4Ckz
         cgh1x5KQ93FCN4fqTTzTH3LUMEn8g9YoeIOz7f69cs7uUiyMbtbvJtdsBRCzYKFt2W
         FIGVRXPb7ugyW/qx30tUXnG6rbUNLQqhuI+A9pks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 18/73] net/mlx5: Fix error print in case of IRQ request failed
Date:   Mon,  3 Jan 2022 15:23:39 +0100
Message-Id: <20220103142057.508680336@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit aa968f922039706f6d13e8870b49e424d0a8d9ad ]

In case IRQ layer failed to find or to request irq, the driver is
printing the first cpu of the provided affinity as part of the error
print. Empty affinity is a valid input for the IRQ layer, and it is
an error to call cpumask_first() on empty affinity.

Remove the first cpu print from the error message.

Fixes: c36326d38d93 ("net/mlx5: Round-Robin EQs over IRQs")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 763c83a023809..11f3649fdaab1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -346,8 +346,8 @@ static struct mlx5_irq *irq_pool_request_affinity(struct mlx5_irq_pool *pool,
 	new_irq = irq_pool_create_irq(pool, affinity);
 	if (IS_ERR(new_irq)) {
 		if (!least_loaded_irq) {
-			mlx5_core_err(pool->dev, "Didn't find IRQ for cpu = %u\n",
-				      cpumask_first(affinity));
+			mlx5_core_err(pool->dev, "Didn't find a matching IRQ. err = %ld\n",
+				      PTR_ERR(new_irq));
 			mutex_unlock(&pool->lock);
 			return new_irq;
 		}
-- 
2.34.1



