Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDDFE409046
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244965AbhIMNvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:51:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244522AbhIMNtd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:49:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0476D615E1;
        Mon, 13 Sep 2021 13:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539987;
        bh=+AISKgyH32nmGVrLl3k0AJKomFgzEsafT0z1jIBQIp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ZaiCSK16kKM4u+MQ7bEpSvN5pEjjF+W3bN4C2v9pHx7BQIQlKRspTGXsH4Q4oN9e
         7Zg4lb2Dtjp50hjS1ClDAVud4MxMKa4I9jx7RRdMOFHz1GJLG9gjIeGfBVAzepuyTI
         SRjvaPVMb3EuuuGFW3DqKuqESZqmYnHjBiUm7ohg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Heimpold <michael.heimpold@in-tech.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 210/236] net: qualcomm: fix QCA7000 checksum handling
Date:   Mon, 13 Sep 2021 15:15:15 +0200
Message-Id: <20210913131107.520498423@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit 429205da6c834447a57279af128bdd56ccd5225e ]

Based on tests the QCA7000 doesn't support checksum offloading. So assume
ip_summed is CHECKSUM_NONE and let the kernel take care of the checksum
handling. This fixes data transfer issues in noisy environments.

Reported-by: Michael Heimpold <michael.heimpold@in-tech.com>
Fixes: 291ab06ecf67 ("net: qualcomm: new Ethernet over SPI driver for QCA7000")
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qualcomm/qca_spi.c  | 2 +-
 drivers/net/ethernet/qualcomm/qca_uart.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethernet/qualcomm/qca_spi.c
index 5a3b65a6eb4f..36bcb5db3be9 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -434,7 +434,7 @@ qcaspi_receive(struct qcaspi *qca)
 				skb_put(qca->rx_skb, retcode);
 				qca->rx_skb->protocol = eth_type_trans(
 					qca->rx_skb, qca->rx_skb->dev);
-				qca->rx_skb->ip_summed = CHECKSUM_UNNECESSARY;
+				skb_checksum_none_assert(qca->rx_skb);
 				netif_rx_ni(qca->rx_skb);
 				qca->rx_skb = netdev_alloc_skb_ip_align(net_dev,
 					net_dev->mtu + VLAN_ETH_HLEN);
diff --git a/drivers/net/ethernet/qualcomm/qca_uart.c b/drivers/net/ethernet/qualcomm/qca_uart.c
index 362b4f5c162c..0b7301db20ed 100644
--- a/drivers/net/ethernet/qualcomm/qca_uart.c
+++ b/drivers/net/ethernet/qualcomm/qca_uart.c
@@ -107,7 +107,7 @@ qca_tty_receive(struct serdev_device *serdev, const unsigned char *data,
 			skb_put(qca->rx_skb, retcode);
 			qca->rx_skb->protocol = eth_type_trans(
 						qca->rx_skb, qca->rx_skb->dev);
-			qca->rx_skb->ip_summed = CHECKSUM_UNNECESSARY;
+			skb_checksum_none_assert(qca->rx_skb);
 			netif_rx_ni(qca->rx_skb);
 			qca->rx_skb = netdev_alloc_skb_ip_align(netdev,
 								netdev->mtu +
-- 
2.30.2



