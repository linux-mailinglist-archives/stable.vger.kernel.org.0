Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D127429038
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237938AbhJKOGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:06:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241068AbhJKOE2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:04:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C181611ED;
        Mon, 11 Oct 2021 13:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960739;
        bh=BJII131/smQoRbkChTA32KeRK8Cxh2rqXlywDf3OvGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MMe3BTFyunHX45jWaDCH5nEyJMqsuxOIJRgtxyyeAmNNVBD0AXufsMj9fHMRXDRGM
         FTZsjnXzKXm7jnCpS6ebts6EuwLnS0rkRb1owWPEC6QWtqvy1dNKSMt2HobtbTwi7z
         jp2o0GzM7/wLdVHnl46mhIzaXZiamtqTlTdtpMwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 061/151] net/mlx5: Force round second at 1PPS out start time
Date:   Mon, 11 Oct 2021 15:45:33 +0200
Message-Id: <20211011134519.815860900@linuxfoundation.org>
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

[ Upstream commit 64728294703e77827cc31a1b164ca867400067f5 ]

Allow configuration of 1PPS start time only with time-stamp representing
a round second. Prior to this patch driver allowed setting of a
non-round-second which is not supported by the device. Avoid unexpected
behavior by restricting start-time configuration to a round-second.

Fixes: 4272f9b88db9 ("net/mlx5e: Change 1PPS out scheme")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 25 ++++++++-----------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index ce696d523493..a8c6450637da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -448,22 +448,20 @@ static u64 find_target_cycles(struct mlx5_core_dev *mdev, s64 target_ns)
 	return cycles_now + cycles_delta;
 }
 
-static u64 perout_conf_internal_timer(struct mlx5_core_dev *mdev,
-				      s64 sec, u32 nsec)
+static u64 perout_conf_internal_timer(struct mlx5_core_dev *mdev, s64 sec)
 {
-	struct timespec64 ts;
+	struct timespec64 ts = {};
 	s64 target_ns;
 
 	ts.tv_sec = sec;
-	ts.tv_nsec = nsec;
 	target_ns = timespec64_to_ns(&ts);
 
 	return find_target_cycles(mdev, target_ns);
 }
 
-static u64 perout_conf_real_time(s64 sec, u32 nsec)
+static u64 perout_conf_real_time(s64 sec)
 {
-	return (u64)nsec | (u64)sec << 32;
+	return (u64)sec << 32;
 }
 
 static int mlx5_perout_configure(struct ptp_clock_info *ptp,
@@ -501,8 +499,10 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 
 	if (on) {
 		bool rt_mode = mlx5_real_time_mode(mdev);
-		u32 nsec;
-		s64 sec;
+		s64 sec = rq->perout.start.sec;
+
+		if (rq->perout.start.nsec)
+			return -EINVAL;
 
 		pin_mode = MLX5_PIN_MODE_OUT;
 		pattern = MLX5_OUT_PATTERN_PERIODIC;
@@ -513,14 +513,11 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 		if ((ns >> 1) != 500000000LL)
 			return -EINVAL;
 
-		nsec = rq->perout.start.nsec;
-		sec = rq->perout.start.sec;
-
 		if (rt_mode && sec > U32_MAX)
 			return -EINVAL;
 
-		time_stamp = rt_mode ? perout_conf_real_time(sec, nsec) :
-				       perout_conf_internal_timer(mdev, sec, nsec);
+		time_stamp = rt_mode ? perout_conf_real_time(sec) :
+				       perout_conf_internal_timer(mdev, sec);
 
 		field_select |= MLX5_MTPPS_FS_PIN_MODE |
 				MLX5_MTPPS_FS_PATTERN |
@@ -717,7 +714,7 @@ static u64 perout_conf_next_event_timer(struct mlx5_core_dev *mdev,
 	ts_next_sec(&ts);
 	target_ns = timespec64_to_ns(&ts);
 
-	return rt_mode ? perout_conf_real_time(ts.tv_sec, ts.tv_nsec) :
+	return rt_mode ? perout_conf_real_time(ts.tv_sec) :
 			 find_target_cycles(mdev, target_ns);
 }
 
-- 
2.33.0



