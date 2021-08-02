Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81973DDA1E
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235481AbhHBOGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:06:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235889AbhHBODY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:03:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94A8B611C9;
        Mon,  2 Aug 2021 13:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912638;
        bh=kcNwIMLCok4Keu6K3yAZ4tah5NV29iWPQkyULL8T57A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vsbV90N+QIU+Vs1UZ0w1hVU0x5jgBhjDUwmfa/2OGNSyrPEVku3dMJaXB1Xh0CF+l
         2SeLExwRrkIGculQ7kFpwIz+U5fBoG/HSChE/h4z44s/QIXCUKSWOJKn6Fn4ws8l6K
         I8RX8+1KoKJPk/eLb6fKIPl3u+oM4CRdwY/rI9ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 082/104] net/mlx5e: Fix page allocation failure for ptp-RQ over SF
Date:   Mon,  2 Aug 2021 15:45:19 +0200
Message-Id: <20210802134346.706307544@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit 678b1ae1af4aef488fcc42baa663e737b9a531ba ]

Set the correct pci-device pointer to the ptp-RQ. This allows access to
dma_mask and avoids allocation request with wrong pci-device.

Fixes: a099da8ffcf6 ("net/mlx5e: Add RQ to PTP channel")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 778e229310a9..0f6b3231ca1d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -494,7 +494,7 @@ static int mlx5e_init_ptp_rq(struct mlx5e_ptp *c, struct mlx5e_params *params,
 	int err;
 
 	rq->wq_type      = params->rq_wq_type;
-	rq->pdev         = mdev->device;
+	rq->pdev         = c->pdev;
 	rq->netdev       = priv->netdev;
 	rq->priv         = priv;
 	rq->clock        = &mdev->clock;
-- 
2.30.2



