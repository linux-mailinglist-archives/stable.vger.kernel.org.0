Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4FB323A6D0
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbgHCMyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:54:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgHCMXN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:23:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C615520738;
        Mon,  3 Aug 2020 12:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457392;
        bh=CylSTeR6WY93qwCZ3HgKRbaRXSvDJOwC8juTa6sLDrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1AbMw9xLyRaDCIPB2UARlroSj1O2A5DOjhlp51VLd7hRWZTvMJtzTIaD+Leg2i+rw
         E1MuBr1m1vB2Nepp7CHBF9kZoUBQxDMCK0n02BhgkX/w0hgCEhjHOgOEsCZF6hBmw7
         YuoH6uUEaxMELLK2tBow8APL9gWJagEthxPfw/gs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 050/120] net: hns3: fix a TX timeout issue
Date:   Mon,  3 Aug 2020 14:18:28 +0200
Message-Id: <20200803121905.240001572@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit a7e90ee5965fafc53d36e8b3205f08c88d7bc11f ]

When the queue depth and queue parameters are modified, there is
a low probability that TX timeout occurs. The two operations cause
the link to be down or up when the watchdog is still working. All
queues are stopped when the link is down. After the carrier is on,
all queues are woken up. If the watchdog detects the link between
the carrier on and wakeup queues, a false TX timeout occurs.

So fix this issue by modifying the sequence of carrier on and queue
wakeup, which is symmetrical to the link down action.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 0b12425fa2845..6e186aea7a2f2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4170,8 +4170,8 @@ static void hns3_link_status_change(struct hnae3_handle *handle, bool linkup)
 		return;
 
 	if (linkup) {
-		netif_carrier_on(netdev);
 		netif_tx_wake_all_queues(netdev);
+		netif_carrier_on(netdev);
 		if (netif_msg_link(handle))
 			netdev_info(netdev, "link up\n");
 	} else {
-- 
2.25.1



