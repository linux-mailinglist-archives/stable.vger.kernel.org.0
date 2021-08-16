Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDAC3ED654
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237260AbhHPNUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:20:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238912AbhHPNQg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:16:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D0AB632E3;
        Mon, 16 Aug 2021 13:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119599;
        bh=cx7F+aV8WqTN9/nWnRmi7JEc3b+OwcRuJ3a2gTllHIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+Te0aV6/vNR93lZSRg+1joYt8UX2Y6cWalyxcLgx8h/7SeWzM3leSuONLtbLczN5
         CpE5+eYYs3bR0IeLvILZgbmHeH7QkOx8cDWq2Cb+d9e74MyRPCrB4z78WG8QxXuFTN
         yBqZ+lE4qdtLK4Kfr19rnI6bnH6ksOHpwmdbjLDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 087/151] net/mlx5: Fix return value from tracer initialization
Date:   Mon, 16 Aug 2021 15:01:57 +0200
Message-Id: <20210816125446.949370489@linuxfoundation.org>
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

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit bd37c2888ccaa5ceb9895718f6909b247cc372e0 ]

Check return value of mlx5_fw_tracer_start(), set error path and fix
return value of mlx5_fw_tracer_init() accordingly.

Fixes: c71ad41ccb0c ("net/mlx5: FW tracer, events handling")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c  | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 01a1d02dcf15..3f8a98093f8c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -1019,12 +1019,19 @@ int mlx5_fw_tracer_init(struct mlx5_fw_tracer *tracer)
 	MLX5_NB_INIT(&tracer->nb, fw_tracer_event, DEVICE_TRACER);
 	mlx5_eq_notifier_register(dev, &tracer->nb);
 
-	mlx5_fw_tracer_start(tracer);
-
+	err = mlx5_fw_tracer_start(tracer);
+	if (err) {
+		mlx5_core_warn(dev, "FWTracer: Failed to start tracer %d\n", err);
+		goto err_notifier_unregister;
+	}
 	return 0;
 
+err_notifier_unregister:
+	mlx5_eq_notifier_unregister(dev, &tracer->nb);
+	mlx5_core_destroy_mkey(dev, &tracer->buff.mkey);
 err_dealloc_pd:
 	mlx5_core_dealloc_pd(dev, tracer->buff.pdn);
+	cancel_work_sync(&tracer->read_fw_strings_work);
 	return err;
 }
 
-- 
2.30.2



