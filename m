Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51D0A73C47
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405667AbfGXUDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:03:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405671AbfGXUDO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:03:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4015421855;
        Wed, 24 Jul 2019 20:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998593;
        bh=CUFy3C9Z/A2fczkvATMxwxsaOE2qdkjLu551AQQj3pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ron5FtvYL8zSCRxY1E5VKwaX4r2CFCD/VhqGoj6fa3EFLMDJhoIUfRmSMEh1VYgsf
         sdjLZKLRYcUfjkbLrcj2QE8MmZfYigbY9EXGS/7Mo6GIP8jqurWq+RQU8ZtD35dRaI
         qh4a9cT0C/jYmAFNKMesYhGZoEKRFvYIeNJTq848=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 048/271] net: fec: Do not use netdev messages too early
Date:   Wed, 24 Jul 2019 21:18:37 +0200
Message-Id: <20190724191659.279669709@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a19a0582363b9a5f8ba812f34f1b8df394898780 ]

When a valid MAC address is not found the current messages
are shown:

fec 2188000.ethernet (unnamed net_device) (uninitialized): Invalid MAC address: 00:00:00:00:00:00
fec 2188000.ethernet (unnamed net_device) (uninitialized): Using random MAC address: aa:9f:25:eb:7e:aa

Since the network device has not been registered at this point, it is better
to use dev_err()/dev_info() instead, which will provide cleaner log
messages like these:

fec 2188000.ethernet: Invalid MAC address: 00:00:00:00:00:00
fec 2188000.ethernet: Using random MAC address: aa:9f:25:eb:7e:aa

Tested on a imx6dl-pico-pi board.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index bf715a367273..4cf80de4c471 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1689,10 +1689,10 @@ static void fec_get_mac(struct net_device *ndev)
 	 */
 	if (!is_valid_ether_addr(iap)) {
 		/* Report it and use a random ethernet address instead */
-		netdev_err(ndev, "Invalid MAC address: %pM\n", iap);
+		dev_err(&fep->pdev->dev, "Invalid MAC address: %pM\n", iap);
 		eth_hw_addr_random(ndev);
-		netdev_info(ndev, "Using random MAC address: %pM\n",
-			    ndev->dev_addr);
+		dev_info(&fep->pdev->dev, "Using random MAC address: %pM\n",
+			 ndev->dev_addr);
 		return;
 	}
 
-- 
2.20.1



