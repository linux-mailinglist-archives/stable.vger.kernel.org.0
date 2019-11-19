Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDA010181A
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbfKSFf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:35:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:56326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729802AbfKSFfZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:35:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB549206EC;
        Tue, 19 Nov 2019 05:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141724;
        bh=LthHNK7NLU//nPk0VbPBWYGPgKRhhbxZ34wx4xWUD1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0n4NjOm022sxhv/99OcsXRP44UujDUMtT5lWhQJ431eUukElHfNcw2gk4z9TgVudB
         +Q1LOjEJsWR+sZfSorJMTAlJHWvqGUoTHpjmtwoQGsn8HC+hziHuKsN/eybTYad4xP
         CQDlCas712i12bk77fBnokkpQ1qgkIuK8/QyO1MM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 258/422] net: cavium: fix return type of ndo_start_xmit function
Date:   Tue, 19 Nov 2019 06:17:35 +0100
Message-Id: <20191119051415.705616949@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit ac1172dea10b6ba51de9346d3130db688b5196c5 ]

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, so make sure the implementation in
this driver has returns 'netdev_tx_t' value, and change the function
return type to netdev_tx_t.

Found by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/lio_main.c    | 2 +-
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c | 2 +-
 drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c  | 5 +++--
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c   | 5 +++--
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 6fb13fa73b271..304e4b9436276 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -2324,7 +2324,7 @@ static inline int send_nic_timestamp_pkt(struct octeon_device *oct,
  * @returns whether the packet was transmitted to the device okay or not
  *             (NETDEV_TX_OK or NETDEV_TX_BUSY)
  */
-static int liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
+static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct lio *lio;
 	struct octnet_buf_free_info *finfo;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index b77835724dc84..d83773bc0dd7f 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -1390,7 +1390,7 @@ static int send_nic_timestamp_pkt(struct octeon_device *oct,
  * @returns whether the packet was transmitted to the device okay or not
  *             (NETDEV_TX_OK or NETDEV_TX_BUSY)
  */
-static int liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
+static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct octnet_buf_free_info *finfo;
 	union octnic_cmd_setup cmdsetup;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
index c99b59fe4c8fb..a1bda1683ebfc 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
@@ -31,7 +31,8 @@
 
 static int lio_vf_rep_open(struct net_device *ndev);
 static int lio_vf_rep_stop(struct net_device *ndev);
-static int lio_vf_rep_pkt_xmit(struct sk_buff *skb, struct net_device *ndev);
+static netdev_tx_t lio_vf_rep_pkt_xmit(struct sk_buff *skb,
+				       struct net_device *ndev);
 static void lio_vf_rep_tx_timeout(struct net_device *netdev);
 static int lio_vf_rep_phys_port_name(struct net_device *dev,
 				     char *buf, size_t len);
@@ -382,7 +383,7 @@ lio_vf_rep_packet_sent_callback(struct octeon_device *oct,
 		netif_wake_queue(ndev);
 }
 
-static int
+static netdev_tx_t
 lio_vf_rep_pkt_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct lio_vf_rep_desc *vf_rep = netdev_priv(ndev);
diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
index 592fb9e847b95..0957e735cdc4d 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -1268,12 +1268,13 @@ static int octeon_mgmt_stop(struct net_device *netdev)
 	return 0;
 }
 
-static int octeon_mgmt_xmit(struct sk_buff *skb, struct net_device *netdev)
+static netdev_tx_t
+octeon_mgmt_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct octeon_mgmt *p = netdev_priv(netdev);
 	union mgmt_port_ring_entry re;
 	unsigned long flags;
-	int rv = NETDEV_TX_BUSY;
+	netdev_tx_t rv = NETDEV_TX_BUSY;
 
 	re.d64 = 0;
 	re.s.tstamp = ((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) != 0);
-- 
2.20.1



