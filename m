Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295F43A0189
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236228AbhFHSxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:53:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235312AbhFHSvw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:51:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49FF76142E;
        Tue,  8 Jun 2021 18:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177597;
        bh=Saa7yUtcScnOSYHA+UPX6fJ+T9gBQ6O+JceFWKHjKYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bT9s80KeUdox4YyvPLTMJzGk1GwFr4ayordK8fLgsiyA4Q3ZD5i3Gcy1YbUsfyWIt
         XnG59PKNWUnx1xEMSnVEaIakBIE4+2H+tdXMpWXWOflPGfYAaaWhwdGHDb5zgqtd7J
         /k1H0qQJovsgcqO0378AntG2Bbg6uZSlvQ+PJVCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/137] net/mlx5: Check firmware sync reset requested is set before trying to abort it
Date:   Tue,  8 Jun 2021 20:26:10 +0200
Message-Id: <20210608175943.436414833@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
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



