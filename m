Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A434D3A02A1
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbhFHTHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:07:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237794AbhFHTFZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:05:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C54061449;
        Tue,  8 Jun 2021 18:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177988;
        bh=Saa7yUtcScnOSYHA+UPX6fJ+T9gBQ6O+JceFWKHjKYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P2T6ikE/00WnSAtjnffd++Wuw/6BGiD2VBs/JjgAgVjiB6/EE4lw7EF7wytP9SoYH
         uGd1ucH0uHbJoAcFFvW9SagaXXGBIlBi3ki/gxMTKyGTRNJPGzUpbDHGOpL79xRV7D
         ngiEfm+uuv3tPGgZ8Dz+Ee0kjRIQOC/SAJbZ/B/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 035/161] net/mlx5: Check firmware sync reset requested is set before trying to abort it
Date:   Tue,  8 Jun 2021 20:26:05 +0200
Message-Id: <20210608175946.642052789@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit 5940e64281c09976ce2b560244217e610bf9d029 ]

In case driver sent NACK to firmware on sync reset request, it will get
sync reset abort event while it didn't set sync reset requested mode.
Thus, on abort sync reset event handler, driver should check reset
requested is set before trying to stop sync reset poll.

Fixes: 7dd6df329d4c ("net/mlx5: Handle sync reset abort event")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index f9042e147c7f..ee710ce00795 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -354,6 +354,9 @@ static void mlx5_sync_reset_abort_event(struct work_struct *work)
 						      reset_abort_work);
 	struct mlx5_core_dev *dev = fw_reset->dev;
 
+	if (!test_bit(MLX5_FW_RESET_FLAGS_RESET_REQUESTED, &fw_reset->reset_flags))
+		return;
+
 	mlx5_sync_reset_clear_reset_requested(dev, true);
 	mlx5_core_warn(dev, "PCI Sync FW Update Reset Aborted.\n");
 }
-- 
2.30.2



