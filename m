Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51581CADA6
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbgEHNDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:03:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729485AbgEHMu2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:50:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7725924953;
        Fri,  8 May 2020 12:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942227;
        bh=ev1tv+6hnFkG0avYA73Iper+0UcLbZROgtinSu5hH04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zUlqCudbTpi5vJWG4gLnwinkVT2Qzmqf68PuYXGay1AWqnH9INz1wcS8LEsF/AGiB
         ux/3GPcZYS6wazEjYNGAwIdjzCdvliDsUyP/Zx5SQxiT0hNqTlPCCgesQqPectEOzG
         wi++uH9ghX7PzLkh48WX9ga+NIKdTYNR6glbKCPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 17/22] net: systemport: suppress warnings on failed Rx SKB allocations
Date:   Fri,  8 May 2020 14:35:29 +0200
Message-Id: <20200508123036.048157812@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123033.915895060@linuxfoundation.org>
References: <20200508123033.915895060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit 3554e54a46125030c534820c297ed7f6c3907e24 ]

The driver is designed to drop Rx packets and reclaim the buffers
when an allocation fails, and the network interface needs to safely
handle this packet loss. Therefore, an allocation failure of Rx
SKBs is relatively benign.

However, the output of the warning message occurs with a high
scheduling priority that can cause excessive jitter/latency for
other high priority processing.

This commit suppresses the warning messages to prevent scheduling
problems while retaining the failure count in the statistics of
the network interface.

Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -645,7 +645,8 @@ static struct sk_buff *bcm_sysport_rx_re
 	dma_addr_t mapping;
 
 	/* Allocate a new SKB for a new packet */
-	skb = netdev_alloc_skb(priv->netdev, RX_BUF_LENGTH);
+	skb = __netdev_alloc_skb(priv->netdev, RX_BUF_LENGTH,
+				 GFP_ATOMIC | __GFP_NOWARN);
 	if (!skb) {
 		priv->mib.alloc_rx_buff_failed++;
 		netif_err(priv, rx_err, ndev, "SKB alloc failed\n");


