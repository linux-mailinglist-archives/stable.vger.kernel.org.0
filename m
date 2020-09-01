Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A950259B29
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730621AbgIAQ63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:58:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729566AbgIAPWd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:22:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF248206FA;
        Tue,  1 Sep 2020 15:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973753;
        bh=Rt0xE89x9whGsdU3+Kog2t5CBCq2HWb2QWVTPNjdFGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fl6HcZGR+5KeGZIJG8PC+NLCOSfoNs9m2XOVNEn87uL2Kxg8Wowojogl8k5uArf3R
         KeGxobiWm9uz9VwJCHDjcmRqGIy2Z05A7CN2Z8XA6kN0NpW6EaelP4vplY1gb91pji
         g3J4jVALbiN2/8fUEnS7tno8PThXMVZob9JcrXkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Agroskin <shayagr@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 007/125] net: ena: Make missed_tx stat incremental
Date:   Tue,  1 Sep 2020 17:09:22 +0200
Message-Id: <20200901150934.954808692@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150934.576210879@linuxfoundation.org>
References: <20200901150934.576210879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shay Agroskin <shayagr@amazon.com>

[ Upstream commit ccd143e5150f24b9ba15145c7221b61dd9e41021 ]

Most statistics in ena driver are incremented, meaning that a stat's
value is a sum of all increases done to it since driver/queue
initialization.

This patch makes all statistics this way, effectively making missed_tx
statistic incremental.
Also added a comment regarding rx_drops and tx_drops to make it
clearer how these counters are calculated.

Fixes: 11095fdb712b ("net: ena: add statistics for missed tx packets")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -2736,7 +2736,7 @@ static int check_missing_comp_in_tx_queu
 	}
 
 	u64_stats_update_begin(&tx_ring->syncp);
-	tx_ring->tx_stats.missed_tx = missed_tx;
+	tx_ring->tx_stats.missed_tx += missed_tx;
 	u64_stats_update_end(&tx_ring->syncp);
 
 	return rc;
@@ -3544,6 +3544,9 @@ static void ena_keep_alive_wd(void *adap
 	rx_drops = ((u64)desc->rx_drops_high << 32) | desc->rx_drops_low;
 
 	u64_stats_update_begin(&adapter->syncp);
+	/* These stats are accumulated by the device, so the counters indicate
+	 * all drops since last reset.
+	 */
 	adapter->dev_stats.rx_drops = rx_drops;
 	u64_stats_update_end(&adapter->syncp);
 }


