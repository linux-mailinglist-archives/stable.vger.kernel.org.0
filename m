Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81B2A121923
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfLPRw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:52:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727473AbfLPRw3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:52:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0991C20733;
        Mon, 16 Dec 2019 17:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518748;
        bh=z3rTYzIuC9db465zqs7C561jd+xtDH6SGh4K3kTwM2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tXqP0sfKu+6jvh1bGB2fRzSdWolHdGPCbo7o774zgjjyZg2WJN7/JcMf0tPfBVDv1
         B3sflvnahgL8Es3CvpD2PB1GC7mJ+GXS5U1Msa/Qeyyb0kJHeJzlV/2h2brpDBXeeU
         RCCI5RJdvQcRjvQvHlwem/09v+2gyFfwH4sJZimg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xue Chaojing <xuechaojing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 049/267] net-next/hinic:fix a bug in set mac address
Date:   Mon, 16 Dec 2019 18:46:15 +0100
Message-Id: <20191216174853.970651912@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xue Chaojing <xuechaojing@huawei.com>

[ Upstream commit 9ea72dc9430306b77c73a8a21beb51437cde1d6d ]

In add_mac_addr(), if the MAC address is a muliticast address,
it will not be set, which causes the network card fail to receive
the multicast packet. This patch fixes this bug.

Signed-off-by: Xue Chaojing <xuechaojing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index a696b5b2d40e6..44c73215d0264 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -598,9 +598,6 @@ static int add_mac_addr(struct net_device *netdev, const u8 *addr)
 	u16 vid = 0;
 	int err;
 
-	if (!is_valid_ether_addr(addr))
-		return -EADDRNOTAVAIL;
-
 	netif_info(nic_dev, drv, netdev, "set mac addr = %02x %02x %02x %02x %02x %02x\n",
 		   addr[0], addr[1], addr[2], addr[3], addr[4], addr[5]);
 
@@ -724,6 +721,7 @@ static void set_rx_mode(struct work_struct *work)
 {
 	struct hinic_rx_mode_work *rx_mode_work = work_to_rx_mode_work(work);
 	struct hinic_dev *nic_dev = rx_mode_work_to_nic_dev(rx_mode_work);
+	struct netdev_hw_addr *ha;
 
 	netif_info(nic_dev, drv, nic_dev->netdev, "set rx mode work\n");
 
@@ -731,6 +729,9 @@ static void set_rx_mode(struct work_struct *work)
 
 	__dev_uc_sync(nic_dev->netdev, add_mac_addr, remove_mac_addr);
 	__dev_mc_sync(nic_dev->netdev, add_mac_addr, remove_mac_addr);
+
+	netdev_for_each_mc_addr(ha, nic_dev->netdev)
+		add_mac_addr(nic_dev->netdev, ha->addr);
 }
 
 static void hinic_set_rx_mode(struct net_device *netdev)
-- 
2.20.1



