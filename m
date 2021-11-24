Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF0F45C568
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347479AbhKXN5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:57:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:46150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345442AbhKXNzh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:55:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAF3963288;
        Wed, 24 Nov 2021 13:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759197;
        bh=svtmji3nmn/5IbK8hMOAl/sZdVQLHghcuAYqas3IcWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SJGJlanBSL9wGYsdI8dZ8ueHq6tTh+VCJoAAifJCQ23/SJYrQRZGERT/QfZf9Xs1s
         8yVhJSSo3dq6mo5NbF3LxutFyFCFM9viXcgbJtFpo5jCltBzBP8Z3lcMLAdt3wqpb8
         OhvJhkoVbGN7Zr1RnNJRZlK7KUIQRe07tfkGwDbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 164/279] RDMA/mlx4: Do not fail the registration on port stats
Date:   Wed, 24 Nov 2021 12:57:31 +0100
Message-Id: <20211124115724.429271450@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@ionos.com>

[ Upstream commit 378c67413de18b69fb3bb78d8c4f0f1192cfa973 ]

If the FW doesn't support MLX4_DEV_CAP_FLAG2_DIAG_PER_PORT, mlx4 driver
will fail the ib_setup_port_attrs, which is called from
ib_register_device()/enable_device_and_get(), in the end leads to device
not detected[1][2]

To fix it, add a new mlx4_ib_hw_stats_ops1, w/o alloc_hw_port_stats if FW
does not support MLX4_DEV_CAP_FLAG2_DIAG_PER_PORT.

[1] https://bugzilla.redhat.com/show_bug.cgi?id=2014094
[2] https://lore.kernel.org/linux-rdma/CAMGffEn2wvEnmzc0xe=xYiCLqpphiHDBxCxqAELrBofbUAMQxw@mail.gmail.com

Fixes: 4b5f4d3fb408 ("RDMA: Split the alloc_hw_stats() ops to port and device variants")
Link: https://lore.kernel.org/r/20211115101519.27210-1-jinpu.wang@ionos.com
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/main.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index f367f4a4abffc..aec2e1851fa70 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2217,6 +2217,11 @@ static const struct ib_device_ops mlx4_ib_hw_stats_ops = {
 	.get_hw_stats = mlx4_ib_get_hw_stats,
 };
 
+static const struct ib_device_ops mlx4_ib_hw_stats_ops1 = {
+	.alloc_hw_device_stats = mlx4_ib_alloc_hw_device_stats,
+	.get_hw_stats = mlx4_ib_get_hw_stats,
+};
+
 static int mlx4_ib_alloc_diag_counters(struct mlx4_ib_dev *ibdev)
 {
 	struct mlx4_ib_diag_counters *diag = ibdev->diag_counters;
@@ -2229,9 +2234,16 @@ static int mlx4_ib_alloc_diag_counters(struct mlx4_ib_dev *ibdev)
 		return 0;
 
 	for (i = 0; i < MLX4_DIAG_COUNTERS_TYPES; i++) {
-		/* i == 1 means we are building port counters */
-		if (i && !per_port)
-			continue;
+		/*
+		 * i == 1 means we are building port counters, set a different
+		 * stats ops without port stats callback.
+		 */
+		if (i && !per_port) {
+			ib_set_device_ops(&ibdev->ib_dev,
+					  &mlx4_ib_hw_stats_ops1);
+
+			return 0;
+		}
 
 		ret = __mlx4_ib_alloc_diag_counters(ibdev, &diag[i].name,
 						    &diag[i].offset,
-- 
2.33.0



