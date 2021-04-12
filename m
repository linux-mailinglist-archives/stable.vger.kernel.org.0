Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E01135C083
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240081AbhDLJOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:14:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240659AbhDLJKu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:10:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F20CE61350;
        Mon, 12 Apr 2021 09:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218371;
        bh=uev2WLtcFgkpCq/ziVOGc/fO0uDbJp084ipDKVJkvas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cH19IIHXdmZwNyPnUOio0FIoQYUN6jFuoL7Y8fW0lwmeutzMclfHV5EbI70Z7F2bV
         Pq906w57xnOQfmi7gB4PF0AyzC1m+PSyDYWM1vvZ4xGmAcctFMrq73SwWLA6aOHFSQ
         CCMX0xWKlPEvtyLbxDcNM8/wZ2870QfCg73GwjBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 165/210] net: macb: restore cmp registers on resume path
Date:   Mon, 12 Apr 2021 10:41:10 +0200
Message-Id: <20210412084021.527085751@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit a14d273ba15968495896a38b7b3399dba66d0270 ]

Restore CMP screener registers on resume path.

Fixes: c1e85c6ce57ef ("net: macb: save/restore the remaining registers and features")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 07cdb38e7d11..fbedbceef2d1 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3235,6 +3235,9 @@ static void gem_prog_cmp_regs(struct macb *bp, struct ethtool_rx_flow_spec *fs)
 	bool cmp_b = false;
 	bool cmp_c = false;
 
+	if (!macb_is_gem(bp))
+		return;
+
 	tp4sp_v = &(fs->h_u.tcp_ip4_spec);
 	tp4sp_m = &(fs->m_u.tcp_ip4_spec);
 
@@ -3603,6 +3606,7 @@ static void macb_restore_features(struct macb *bp)
 {
 	struct net_device *netdev = bp->dev;
 	netdev_features_t features = netdev->features;
+	struct ethtool_rx_fs_item *item;
 
 	/* TX checksum offload */
 	macb_set_txcsum_feature(bp, features);
@@ -3611,6 +3615,9 @@ static void macb_restore_features(struct macb *bp)
 	macb_set_rxcsum_feature(bp, features);
 
 	/* RX Flow Filters */
+	list_for_each_entry(item, &bp->rx_fs_list.list, list)
+		gem_prog_cmp_regs(bp, &item->fs);
+
 	macb_set_rxflow_feature(bp, features);
 }
 
-- 
2.30.2



