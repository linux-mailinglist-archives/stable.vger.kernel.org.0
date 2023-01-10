Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5877B664961
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239253AbjAJSUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239316AbjAJSUP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:20:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D14FE22
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:18:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C85BF6183C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:18:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8CF1C433D2;
        Tue, 10 Jan 2023 18:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374693;
        bh=2KN3YUVBDB232lLDjf4xV5nv/aSUUVYphfmH6NBFzRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oPNlzNzKEjnjwkixxw0kaQM2/vrDhMKYNoE4PZoPH4lAC3q5UVxljpnwjIq0SQXzy
         mvJ8RD7ih+ldphUCqPWI6IP4yTWurEpE9c/+HHVLXaU35BCi8Y6StbE1C8Sa8hup4J
         sSaQAw9T+VcAhoN2jaNoMNmWoMWxS7BFHmb7ZxVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Osama Abboud <osamaabb@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/159] net: ena: Fix rx_copybreak value update
Date:   Tue, 10 Jan 2023 19:03:39 +0100
Message-Id: <20230110180020.568934623@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Arinzon <darinzon@amazon.com>

[ Upstream commit c7062aaee099f2f43d6f07a71744b44b94b94b34 ]

Make the upper bound on rx_copybreak tighter, by
making sure it is smaller than the minimum of mtu and
ENA_PAGE_SIZE. With the current upper bound of mtu,
rx_copybreak can be larger than a page. Such large
rx_copybreak will not bring any performance benefit to
the user and therefore makes no sense.

In addition, the value update was only reflected in
the adapter structure, but not applied for each ring,
causing it to not take effect.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Osama Abboud <osamaabb@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David Arinzon <darinzon@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  6 +-----
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 18 ++++++++++++++++++
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  2 ++
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 98d6386b7f39..444ccef76da2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -887,11 +887,7 @@ static int ena_set_tunable(struct net_device *netdev,
 	switch (tuna->id) {
 	case ETHTOOL_RX_COPYBREAK:
 		len = *(u32 *)data;
-		if (len > adapter->netdev->mtu) {
-			ret = -EINVAL;
-			break;
-		}
-		adapter->rx_copybreak = len;
+		ret = ena_set_rx_copybreak(adapter, len);
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 821355c5db10..663f9cd3babf 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -2814,6 +2814,24 @@ int ena_update_queue_sizes(struct ena_adapter *adapter,
 	return dev_was_up ? ena_up(adapter) : 0;
 }
 
+int ena_set_rx_copybreak(struct ena_adapter *adapter, u32 rx_copybreak)
+{
+	struct ena_ring *rx_ring;
+	int i;
+
+	if (rx_copybreak > min_t(u16, adapter->netdev->mtu, ENA_PAGE_SIZE))
+		return -EINVAL;
+
+	adapter->rx_copybreak = rx_copybreak;
+
+	for (i = 0; i < adapter->num_io_queues; i++) {
+		rx_ring = &adapter->rx_ring[i];
+		rx_ring->rx_copybreak = rx_copybreak;
+	}
+
+	return 0;
+}
+
 int ena_update_queue_count(struct ena_adapter *adapter, u32 new_channel_count)
 {
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 290ae9bf47ee..f9d862b630fa 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -392,6 +392,8 @@ int ena_update_queue_sizes(struct ena_adapter *adapter,
 
 int ena_update_queue_count(struct ena_adapter *adapter, u32 new_channel_count);
 
+int ena_set_rx_copybreak(struct ena_adapter *adapter, u32 rx_copybreak);
+
 int ena_get_sset_count(struct net_device *netdev, int sset);
 
 static inline void ena_reset_device(struct ena_adapter *adapter,
-- 
2.35.1



