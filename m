Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A72A23A668
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgHCMZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:25:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728207AbgHCMZZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:25:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F239204EC;
        Mon,  3 Aug 2020 12:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457524;
        bh=Wt3/h1QPAQLhuPhRPshYUENEheR289Pn/aK8t45cbZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/NzVPGT2eMsl8ec8X5OWPMCNV8vxkk1X6ZbCGTmCV5hJPXFD00XZvoac8wADHayJ
         KyJZWNBUkD8DTUzOv6f7NWhbXqthCxMNUHdZbq6X0HvHynX/xxTRj7D4knDQ98keRW
         6LP8V62FYrmhjfEmwZGqZEATwrBkaOVfcwtTImME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 059/120] net/mlx5: Query PPS pin operational status before registering it
Date:   Mon,  3 Aug 2020 14:18:37 +0200
Message-Id: <20200803121905.672531946@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

[ Upstream commit ed56d749c366be269d58b29597392e4a0ae71c0a ]

In a special configuration, a ConnectX6-Dx pin pps-out might be activated
when driver is loaded. Fix the driver to always read the operational pin
mode when registering it, and advertise it accordingly.

Fixes: ee7f12205abc ("net/mlx5e: Implement 1PPS support")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 34 ++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 0267552b8a61b..1d9a5117f90b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -431,6 +431,38 @@ static const struct ptp_clock_info mlx5_ptp_clock_info = {
 	.verify		= NULL,
 };
 
+static int mlx5_query_mtpps_pin_mode(struct mlx5_core_dev *mdev, u8 pin,
+				     u32 *mtpps, u32 mtpps_size)
+{
+	u32 in[MLX5_ST_SZ_DW(mtpps_reg)] = {};
+
+	MLX5_SET(mtpps_reg, in, pin, pin);
+
+	return mlx5_core_access_reg(mdev, in, sizeof(in), mtpps,
+				    mtpps_size, MLX5_REG_MTPPS, 0, 0);
+}
+
+static int mlx5_get_pps_pin_mode(struct mlx5_clock *clock, u8 pin)
+{
+	struct mlx5_core_dev *mdev = clock->mdev;
+	u32 out[MLX5_ST_SZ_DW(mtpps_reg)] = {};
+	u8 mode;
+	int err;
+
+	err = mlx5_query_mtpps_pin_mode(mdev, pin, out, sizeof(out));
+	if (err || !MLX5_GET(mtpps_reg, out, enable))
+		return PTP_PF_NONE;
+
+	mode = MLX5_GET(mtpps_reg, out, pin_mode);
+
+	if (mode == MLX5_PIN_MODE_IN)
+		return PTP_PF_EXTTS;
+	else if (mode == MLX5_PIN_MODE_OUT)
+		return PTP_PF_PEROUT;
+
+	return PTP_PF_NONE;
+}
+
 static int mlx5_init_pin_config(struct mlx5_clock *clock)
 {
 	int i;
@@ -450,7 +482,7 @@ static int mlx5_init_pin_config(struct mlx5_clock *clock)
 			 sizeof(clock->ptp_info.pin_config[i].name),
 			 "mlx5_pps%d", i);
 		clock->ptp_info.pin_config[i].index = i;
-		clock->ptp_info.pin_config[i].func = PTP_PF_NONE;
+		clock->ptp_info.pin_config[i].func = mlx5_get_pps_pin_mode(clock, i);
 		clock->ptp_info.pin_config[i].chan = 0;
 	}
 
-- 
2.25.1



