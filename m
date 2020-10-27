Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A23B29B432
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1773155AbgJ0O7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:59:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1784389AbgJ0O7H (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:59:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0146720714;
        Tue, 27 Oct 2020 14:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810747;
        bh=O87+XfpZ5i2uWQkUtxNP+ISVBsLYB03oZkYU5gowM4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w+yjiWlgRCcOTvHRu+tklqknNgFzTAbhJ77jgNSZZBMDcRD0zZf2s++icceQdS07u
         Yk/M6qN3DOe7lCgv5iSXEjsoq/PyavmE16Zc8yRG2LcVlZDLc1h0s1Q8f9s+YwfJ8h
         xoEZS52WepsSTXaw3t+snF9DgjmAlN8IFR2rQtc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 218/633] net/mlx5: Dont call timecounter cyc2time directly from 1PPS flow
Date:   Tue, 27 Oct 2020 14:49:21 +0100
Message-Id: <20201027135532.911456396@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
index 2d55b7c22c034..4e7cfa22b3d2f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -550,8 +550,9 @@ static int mlx5_pps_event(struct notifier_block *nb,
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



