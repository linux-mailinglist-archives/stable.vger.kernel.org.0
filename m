Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9912429B08E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901165AbgJ0OUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:20:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901094AbgJ0OUr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:20:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81C0D206FA;
        Tue, 27 Oct 2020 14:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808446;
        bh=xa/nQKjTLiG7xBe9S/pJJZW3EXF4GkL5VBXNjkCiHOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mx0OV3sd0aN9N0UYCd7m2YDbFEiet1qkQS1iIapm9N9lwfnH6IpF2GUv5NiF3lJre
         DeGzmn31bfzNGZwFLgJdrrmc02ye+gVQuC3DoihySN1WXHoNiJJnlu56ALl/PdrOcq
         9Hqi7JTUGJ4RKaci+Qj2am0+N+HsdCJsvZdoiv/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 095/264] net/mlx5: Dont call timecounter cyc2time directly from 1PPS flow
Date:   Tue, 27 Oct 2020 14:52:33 +0100
Message-Id: <20201027135435.156703770@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

[ Upstream commit 0d2ffdc8d4002a62de31ff7aa3bef28c843c3cbe ]

Before calling timecounter_cyc2time(), clock->lock must be taken.
Use mlx5_timecounter_cyc2time instead which guarantees a safe access.

Fixes: afc98a0b46d8 ("net/mlx5: Update ptp_clock_event foreach PPS event")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index d359e850dbf07..0fd62510fb277 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -475,8 +475,9 @@ void mlx5_pps_event(struct mlx5_core_dev *mdev,
 	switch (clock->ptp_info.pin_config[pin].func) {
 	case PTP_PF_EXTTS:
 		ptp_event.index = pin;
-		ptp_event.timestamp = timecounter_cyc2time(&clock->tc,
-					be64_to_cpu(eqe->data.pps.time_stamp));
+		ptp_event.timestamp =
+			mlx5_timecounter_cyc2time(clock,
+						  be64_to_cpu(eqe->data.pps.time_stamp));
 		if (clock->pps_info.enabled) {
 			ptp_event.type = PTP_CLOCK_PPSUSR;
 			ptp_event.pps_times.ts_real =
-- 
2.25.1



