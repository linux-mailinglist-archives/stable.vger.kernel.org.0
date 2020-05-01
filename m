Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34061C1611
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730847AbgEANjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:39:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731149AbgEANjJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:39:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2E5020757;
        Fri,  1 May 2020 13:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340349;
        bh=yTT390lyjwwzD5CBhf82//qAZZ7tcQVKRbZio/u8Swc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lP7bHyJTs0nL+ZLYzyf2Q5ksGu4zKwnwrPbqBzfwXaZJnerVLWlw8lP5HdxbImkwG
         qycDhhkz0HjzLdq2+DuMUX/Js78CJHoCEoqc1AIPDHI679PzGbmskfRJ1Bo+UaAglW
         JaYjYwikHI3fdCVjDyO6/Nzp2XVs7thcIomGFzVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhu Yanjun <yanjunz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.4 29/83] net/mlx5e: Get the latest values from counters in switchdev mode
Date:   Fri,  1 May 2020 15:23:08 +0200
Message-Id: <20200501131531.298194265@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131524.004332640@linuxfoundation.org>
References: <20200501131524.004332640@linuxfoundation.org>
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
@@ -3579,7 +3579,12 @@ mlx5e_get_stats(struct net_device *dev,
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


