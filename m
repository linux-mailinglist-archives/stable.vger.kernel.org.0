Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2D91C14DA
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731639AbgEANnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:43:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731622AbgEANna (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:43:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAE5120757;
        Fri,  1 May 2020 13:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340610;
        bh=hk0WlGJZ3FM21rY1vHjVkvu11UIxCb9M8FMJ1iwQL5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWaVnc782immaCoARWmDb7T+3GvPSXNmRMnexaTMT0atgHk5iv0jP9CQMNZ/xY0DC
         ynzlc7yZSEcOO0qvyxAV/8dld45x5GEyDAJM1fsq8rsU+1KYH5zfmiWl/V0DrIOK72
         q2pVQimbLd2maMqPXDU4GWYxmBUOsKNfZHirjsN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhu Yanjun <yanjunz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.6 042/106] net/mlx5e: Get the latest values from counters in switchdev mode
Date:   Fri,  1 May 2020 15:23:15 +0200
Message-Id: <20200501131548.781414143@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhu Yanjun <yanjunz@mellanox.com>

commit dcdf4ce0ff4ba206fc362e149c8ae81d6a2f849c upstream.

In the switchdev mode, when running "cat
/sys/class/net/NIC/statistics/tx_packets", the ppcnt register is
accessed to get the latest values. But currently this command can
not get the correct values from ppcnt.

>From firmware manual, before getting the 802_3 counters, the 802_3
data layout should be set to the ppcnt register.

When the command "cat /sys/class/net/NIC/statistics/tx_packets" is
run, before updating 802_3 data layout with ppcnt register, the
monitor counters are tested. The test result will decide the
802_3 data layout is updated or not.

Actually the monitor counters do not support to monitor rx/tx
stats of 802_3 in switchdev mode. So the rx/tx counters change
will not trigger monitor counters. So the 802_3 data layout will
not be updated in ppcnt register. Finally this command can not get
the latest values from ppcnt register with 802_3 data layout.

Fixes: 5c7e8bbb0257 ("net/mlx5e: Use monitor counters for update stats")
Signed-off-by: Zhu Yanjun <yanjunz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3568,7 +3568,12 @@ mlx5e_get_stats(struct net_device *dev,
 	struct mlx5e_vport_stats *vstats = &priv->stats.vport;
 	struct mlx5e_pport_stats *pstats = &priv->stats.pport;
 
-	if (!mlx5e_monitor_counter_supported(priv)) {
+	/* In switchdev mode, monitor counters doesn't monitor
+	 * rx/tx stats of 802_3. The update stats mechanism
+	 * should keep the 802_3 layout counters updated
+	 */
+	if (!mlx5e_monitor_counter_supported(priv) ||
+	    mlx5e_is_uplink_rep(priv)) {
 		/* update HW stats in background for next time */
 		mlx5e_queue_update_stats(priv);
 	}


