Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DC33AEE99
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbhFUQaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:30:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232375AbhFUQ3R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:29:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B305613BD;
        Mon, 21 Jun 2021 16:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292652;
        bh=tSl9IBjXFE7j9DzlCYTUubO7aIK65l8X2Dl3d1B5Bgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zq6MkKOkQmFY4LncPTULRaCdvq91GBX8a1mO9zVsOGf2k2pUQrQG57d+GcMF43GYI
         v2YCNHSiy3IgKUgxjL3fe6SJ1i0Q5rBkEJSDXK3Xh94YWyDjtb4A+xT+21UbAY8QVF
         Y3+kUqkGqGpUKGJ1bcLWV6r/T3j8I2VXixXN6RBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/146] net: qualcomm: rmnet: dont over-count statistics
Date:   Mon, 21 Jun 2021 18:14:37 +0200
Message-Id: <20210621154912.892468231@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 994c393bb6886d6d94d628475b274a8cb3fc67a4 ]

The purpose of the loop using u64_stats_fetch_*_irq() is to ensure
statistics on a given CPU are collected atomically. If one of the
statistics values gets updated within the begin/retry window, the
loop will run again.

Currently the statistics totals are updated inside that window.
This means that if the loop ever retries, the statistics for the
CPU will be counted more than once.

Fix this by taking a snapshot of a CPU's statistics inside the
protected window, and then updating the counters with the snapshot
values after exiting the loop.

(Also add a newline at the end of this file...)

Fixes: 192c4b5d48f2a ("net: qualcomm: rmnet: Add support for 64 bit stats")
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c    | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index 6cf46f893fb9..2adcf24848a4 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -125,24 +125,24 @@ static void rmnet_get_stats64(struct net_device *dev,
 			      struct rtnl_link_stats64 *s)
 {
 	struct rmnet_priv *priv = netdev_priv(dev);
-	struct rmnet_vnd_stats total_stats;
+	struct rmnet_vnd_stats total_stats = { };
 	struct rmnet_pcpu_stats *pcpu_ptr;
+	struct rmnet_vnd_stats snapshot;
 	unsigned int cpu, start;
 
-	memset(&total_stats, 0, sizeof(struct rmnet_vnd_stats));
-
 	for_each_possible_cpu(cpu) {
 		pcpu_ptr = per_cpu_ptr(priv->pcpu_stats, cpu);
 
 		do {
 			start = u64_stats_fetch_begin_irq(&pcpu_ptr->syncp);
-			total_stats.rx_pkts += pcpu_ptr->stats.rx_pkts;
-			total_stats.rx_bytes += pcpu_ptr->stats.rx_bytes;
-			total_stats.tx_pkts += pcpu_ptr->stats.tx_pkts;
-			total_stats.tx_bytes += pcpu_ptr->stats.tx_bytes;
+			snapshot = pcpu_ptr->stats;	/* struct assignment */
 		} while (u64_stats_fetch_retry_irq(&pcpu_ptr->syncp, start));
 
-		total_stats.tx_drops += pcpu_ptr->stats.tx_drops;
+		total_stats.rx_pkts += snapshot.rx_pkts;
+		total_stats.rx_bytes += snapshot.rx_bytes;
+		total_stats.tx_pkts += snapshot.tx_pkts;
+		total_stats.tx_bytes += snapshot.tx_bytes;
+		total_stats.tx_drops += snapshot.tx_drops;
 	}
 
 	s->rx_packets = total_stats.rx_pkts;
@@ -353,4 +353,4 @@ int rmnet_vnd_update_dev_mtu(struct rmnet_port *port,
 	}
 
 	return 0;
-}
\ No newline at end of file
+}
-- 
2.30.2



