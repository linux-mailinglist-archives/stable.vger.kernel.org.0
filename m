Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166C6411FA0
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349014AbhITRnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:43:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245538AbhITRlN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:41:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3E00615E6;
        Mon, 20 Sep 2021 17:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157698;
        bh=5XOdhEQSCGjFJgd0LO1xGVU/90AYG3budewRQKU3TMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NbyedollJiZwv25eTHvA605tonYGAS1n6/AzpcGUGNTzoJCaZGysyozRVOxpwEz0p
         BT7Qk1/5yk/Tsb20U+rSi41ViP0TEX9zXEWQnaU35LvBbtapXCmdEWGTJgqYKSD2kB
         pW9VH+CVGKGT2fbGPEfohT9fyVFiXg3RKsL+6c+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Heimpold <michael.heimpold@in-tech.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 103/293] net: qualcomm: fix QCA7000 checksum handling
Date:   Mon, 20 Sep 2021 18:41:05 +0200
Message-Id: <20210920163936.785752063@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
index 9d188931bc09..afd49c7fd87f 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -413,7 +413,7 @@ qcaspi_receive(struct qcaspi *qca)
 				skb_put(qca->rx_skb, retcode);
 				qca->rx_skb->protocol = eth_type_trans(
 					qca->rx_skb, qca->rx_skb->dev);
-				qca->rx_skb->ip_summed = CHECKSUM_UNNECESSARY;
+				skb_checksum_none_assert(qca->rx_skb);
 				netif_rx_ni(qca->rx_skb);
 				qca->rx_skb = netdev_alloc_skb_ip_align(net_dev,
 					net_dev->mtu + VLAN_ETH_HLEN);
diff --git a/drivers/net/ethernet/qualcomm/qca_uart.c b/drivers/net/ethernet/qualcomm/qca_uart.c
index db6068cd7a1f..466e9d07697a 100644
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



