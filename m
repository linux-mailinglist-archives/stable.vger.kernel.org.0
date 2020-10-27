Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5D029B042
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900912AbgJ0OR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:17:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2900908AbgJ0OR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:17:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63668206D4;
        Tue, 27 Oct 2020 14:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808248;
        bh=2xe2IxVXNEOe5tbVNVRFe3UO2+ZWr7Ggj1Le36gQ/9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RLJLM+jdOZSBs3fvrS2GkgEXVMxWTae052Kn+ymzKqwfcnQ0aR2fkPLA+0cVNKrtd
         tX+h8pHp9DDs6JUR9NIAimb//ascXrRBiK6wMQCzHxk9MbhJL16H8606U/Zb5Excdq
         8gerU2LL7gQG3rq8IMEf4lmsFXPVij7UK8aKmccQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Xie He <xie.he.0141@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 020/264] net: hdlc_raw_eth: Clear the IFF_TX_SKB_SHARING flag after calling ether_setup
Date:   Tue, 27 Oct 2020 14:51:18 +0100
Message-Id: <20201027135431.609009179@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 5fce1e43e2d5bf2f7e3224d7b99b1c65ab2c26e2 ]

This driver calls ether_setup to set up the network device.
The ether_setup function would add the IFF_TX_SKB_SHARING flag to the
device. This flag indicates that it is safe to transmit shared skbs to
the device.

However, this is not true. This driver may pad the frame (in eth_tx)
before transmission, so the skb may be modified.

Fixes: 550fd08c2ceb ("net: Audit drivers to identify those needing IFF_TX_SKB_SHARING cleared")
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Link: https://lore.kernel.org/r/20201020063420.187497-1-xie.he.0141@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wan/hdlc_raw_eth.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wan/hdlc_raw_eth.c
+++ b/drivers/net/wan/hdlc_raw_eth.c
@@ -102,6 +102,7 @@ static int raw_eth_ioctl(struct net_devi
 		old_qlen = dev->tx_queue_len;
 		ether_setup(dev);
 		dev->tx_queue_len = old_qlen;
+		dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 		eth_hw_addr_random(dev);
 		call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE, dev);
 		netif_dormant_off(dev);


