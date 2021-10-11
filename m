Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D5842903C
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238221AbhJKOGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:06:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241064AbhJKOE2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:04:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3198C61164;
        Mon, 11 Oct 2021 13:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960742;
        bh=q+sfB1iaSFSvPAOeOhB99Q/nKyTz8OQeFTN+K0q5wDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H35qr85uNCiseGEksW4KbisbnMIPfMdDnCWC1Mqq5ZlKB07H16jqlBNQCMN969506
         tUVM8RhNIc/Wt4/vgL25roVycOIifM1eWdxYWjHMZs+qFf1o4uh+6XgGaoGaA37e9k
         AsK9mx7n84rMd+NLF1Plp1kfRh5r5aFX9OYvG4zM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 062/151] net/mlx5: Avoid generating event after PPS out in Real time mode
Date:   Mon, 11 Oct 2021 15:45:34 +0200
Message-Id: <20211011134519.846868319@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit 99b9a678b2e474756770900595cb09c94498bfca ]

When in Real-time mode, HW clock is synced with the PTP daemon. Hence
driver should not re-calibrate the next pulse (via MTPPSE repetitive
events mechanism).

This patch arms repetitive events only in free-running mode.

Fixes: 432119de33d9 ("net/mlx5: Add cyc2time HW translation mode support")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index a8c6450637da..c009ccc88df4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -472,6 +472,7 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 			container_of(ptp, struct mlx5_clock, ptp_info);
 	struct mlx5_core_dev *mdev =
 			container_of(clock, struct mlx5_core_dev, clock);
+	bool rt_mode = mlx5_real_time_mode(mdev);
 	u32 in[MLX5_ST_SZ_DW(mtpps_reg)] = {0};
 	struct timespec64 ts;
 	u32 field_select = 0;
@@ -535,6 +536,9 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 	if (err)
 		return err;
 
+	if (rt_mode)
+		return 0;
+
 	return mlx5_set_mtppse(mdev, pin, 0,
 			       MLX5_EVENT_MODE_REPETETIVE & on);
 }
@@ -702,20 +706,14 @@ static void ts_next_sec(struct timespec64 *ts)
 static u64 perout_conf_next_event_timer(struct mlx5_core_dev *mdev,
 					struct mlx5_clock *clock)
 {
-	bool rt_mode = mlx5_real_time_mode(mdev);
 	struct timespec64 ts;
 	s64 target_ns;
 
-	if (rt_mode)
-		ts = mlx5_ptp_gettimex_real_time(mdev, NULL);
-	else
-		mlx5_ptp_gettimex(&clock->ptp_info, &ts, NULL);
-
+	mlx5_ptp_gettimex(&clock->ptp_info, &ts, NULL);
 	ts_next_sec(&ts);
 	target_ns = timespec64_to_ns(&ts);
 
-	return rt_mode ? perout_conf_real_time(ts.tv_sec) :
-			 find_target_cycles(mdev, target_ns);
+	return find_target_cycles(mdev, target_ns);
 }
 
 static int mlx5_pps_event(struct notifier_block *nb,
-- 
2.33.0



