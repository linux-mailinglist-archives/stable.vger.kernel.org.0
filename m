Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8179235BEB2
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239925AbhDLJBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:01:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238651AbhDLI5E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:57:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 008B861245;
        Mon, 12 Apr 2021 08:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217785;
        bh=5jq/VTupzktWayWACX7ynJJ/NNjWONeR96Jdv0AxFcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pv20c4LEsj5f76hr8J7VD/6VfiZfD0LkNpq+D5xE+/nodsDdpRGzPqvf/V/5/A5/H
         vyWcyIJznfNrAB6Pgv5179cQim9+6DYfPlzdjQOOndsaFXHfLYou22tdTFVZRvile2
         v4f+KCI3pRF2NZieP+NBkx9Pjap4pte3qGbhpFmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 145/188] net: macb: restore cmp registers on resume path
Date:   Mon, 12 Apr 2021 10:40:59 +0200
Message-Id: <20210412084018.448791369@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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
index 286f0341bdf8..48a6bda2a8cc 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3111,6 +3111,9 @@ static void gem_prog_cmp_regs(struct macb *bp, struct ethtool_rx_flow_spec *fs)
 	bool cmp_b = false;
 	bool cmp_c = false;
 
+	if (!macb_is_gem(bp))
+		return;
+
 	tp4sp_v = &(fs->h_u.tcp_ip4_spec);
 	tp4sp_m = &(fs->m_u.tcp_ip4_spec);
 
@@ -3479,6 +3482,7 @@ static void macb_restore_features(struct macb *bp)
 {
 	struct net_device *netdev = bp->dev;
 	netdev_features_t features = netdev->features;
+	struct ethtool_rx_fs_item *item;
 
 	/* TX checksum offload */
 	macb_set_txcsum_feature(bp, features);
@@ -3487,6 +3491,9 @@ static void macb_restore_features(struct macb *bp)
 	macb_set_rxcsum_feature(bp, features);
 
 	/* RX Flow Filters */
+	list_for_each_entry(item, &bp->rx_fs_list.list, list)
+		gem_prog_cmp_regs(bp, &item->fs);
+
 	macb_set_rxflow_feature(bp, features);
 }
 
-- 
2.30.2



