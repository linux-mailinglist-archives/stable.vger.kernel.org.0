Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD5623A427
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgHCMXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:23:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727874AbgHCMXf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:23:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C569204EC;
        Mon,  3 Aug 2020 12:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457414;
        bh=Hh1DLbFjydQzfY0ESF6hsKREFsDzyERKMwVwlFnK8M8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=obQ63xZKiifhwCAm5E5t+Q+jBDxfe/7hj85zZPyFspRUHnqR5yaJV01tx/6CO9SWM
         Tfbf1r+icUw7rgoMH8fElvR9MzUG3dd7uHrcCvTWTMC+OItMrxul196YN/T7LObAGK
         EbpRG5UNwb3kMIG+JemKQOOtqjHqlEBFviFjp2Oc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 057/120] net/mlx5: Fix a bug of using ptp channel index as pin index
Date:   Mon,  3 Aug 2020 14:18:35 +0200
Message-Id: <20200803121905.571639182@linuxfoundation.org>
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

[ Upstream commit 88c8cf92db48b2e359fe3051ad8e09829c1bee5d ]

On PTP mlx5_ptp_enable(on=0) flow, driver mistakenly used channel index
as pin index.

After ptp patch marked in fixes tag was introduced, driver can freely
call ptp_find_pin() as part of the .enable() callback.

Fix driver mlx5_ptp_enable(on=0) flow to always use ptp_find_pin(). With
that, Driver will use the correct pin index in mlx5_ptp_enable(on=0) flow.

In addition, when initializing the pins, always set channel to zero. As
all pins can be attached to all channels, let ptp_set_pinfunc() to move
them between the channels.

For stable branches, this fix to be applied only on kernels that includes
both patches in fixes tag. Otherwise, mlx5_ptp_enable(on=0) will be stuck
on pincfg_mux.

Fixes: 62582a7ee783 ("ptp: Avoid deadlocks in the programmable pin code.")
Fixes: ee7f12205abc ("net/mlx5e: Implement 1PPS support")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Ariel Levkovich <lariel@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 21 +++++++++----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 43f97601b5000..b88c6456d2154 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -252,17 +252,17 @@ static int mlx5_extts_configure(struct ptp_clock_info *ptp,
 	if (rq->extts.index >= clock->ptp_info.n_pins)
 		return -EINVAL;
 
+	pin = ptp_find_pin(clock->ptp, PTP_PF_EXTTS, rq->extts.index);
+	if (pin < 0)
+		return -EBUSY;
+
 	if (on) {
-		pin = ptp_find_pin(clock->ptp, PTP_PF_EXTTS, rq->extts.index);
-		if (pin < 0)
-			return -EBUSY;
 		pin_mode = MLX5_PIN_MODE_IN;
 		pattern = !!(rq->extts.flags & PTP_FALLING_EDGE);
 		field_select = MLX5_MTPPS_FS_PIN_MODE |
 			       MLX5_MTPPS_FS_PATTERN |
 			       MLX5_MTPPS_FS_ENABLE;
 	} else {
-		pin = rq->extts.index;
 		field_select = MLX5_MTPPS_FS_ENABLE;
 	}
 
@@ -310,12 +310,12 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 	if (rq->perout.index >= clock->ptp_info.n_pins)
 		return -EINVAL;
 
-	if (on) {
-		pin = ptp_find_pin(clock->ptp, PTP_PF_PEROUT,
-				   rq->perout.index);
-		if (pin < 0)
-			return -EBUSY;
+	pin = ptp_find_pin(clock->ptp, PTP_PF_PEROUT,
+			   rq->perout.index);
+	if (pin < 0)
+		return -EBUSY;
 
+	if (on) {
 		pin_mode = MLX5_PIN_MODE_OUT;
 		pattern = MLX5_OUT_PATTERN_PERIODIC;
 		ts.tv_sec = rq->perout.period.sec;
@@ -341,7 +341,6 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
 			       MLX5_MTPPS_FS_ENABLE |
 			       MLX5_MTPPS_FS_TIME_STAMP;
 	} else {
-		pin = rq->perout.index;
 		field_select = MLX5_MTPPS_FS_ENABLE;
 	}
 
@@ -431,7 +430,7 @@ static int mlx5_init_pin_config(struct mlx5_clock *clock)
 			 "mlx5_pps%d", i);
 		clock->ptp_info.pin_config[i].index = i;
 		clock->ptp_info.pin_config[i].func = PTP_PF_NONE;
-		clock->ptp_info.pin_config[i].chan = i;
+		clock->ptp_info.pin_config[i].chan = 0;
 	}
 
 	return 0;
-- 
2.25.1



