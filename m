Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2733AEFAE
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbhFUQlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:41:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233090AbhFUQjS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:39:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52CCE6142C;
        Mon, 21 Jun 2021 16:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292986;
        bh=hSTdOlQt8ax+4Aja3rCVbTqTIvD2N8XmRgqSRxE6WKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hplWNz87ce6v5tEIMcryJeT7vfyJi1rUlVURmRw2v1pXc+s4oePS+QYT3uV5rdCLc
         TDFg3Yd7GsLM7MafPpi6dxdA8SAFba/j9u81hH7lx7phaHeHokv17jTpTcNiALZDYR
         3Ux9dP6T2+eijoGt7pNKip7bgiF/fQrmJdvRL9O4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 055/178] net: qualcomm: rmnet: dont over-count statistics
Date:   Mon, 21 Jun 2021 18:14:29 +0200
Message-Id: <20210621154924.300920608@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
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
index 41fbd2ceeede..ab1e0fcccabb 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -126,24 +126,24 @@ static void rmnet_get_stats64(struct net_device *dev,
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
@@ -354,4 +354,4 @@ int rmnet_vnd_update_dev_mtu(struct rmnet_port *port,
 	}
 
 	return 0;
-}
\ No newline at end of file
+}
-- 
2.30.2



