Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A7A2E378D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 13:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbgL1M5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:57:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:53240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728286AbgL1M5H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:57:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B770E208D5;
        Mon, 28 Dec 2020 12:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160212;
        bh=4+Xwuj3IhhfZm3bvxIG3Mu+IlvJnYtLjnj4L+yuV/S0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rQM8I2zHuMvBUlp5rNdupom00oNvynHGSDjnIFehCddSK1OO5Lbt5Azyxy1KnPOXJ
         8qZrkhaimM1dDv88l1htlNbG4QGpQpJOl8FxqjtQJcCs5l5Dy8+RRqxHI4BD5Ke/3G
         K80mpo/VJTaF+EhfkqPTeA7ViRiXMhGF1pgrRX4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 089/132] net: korina: fix return value
Date:   Mon, 28 Dec 2020 13:49:33 +0100
Message-Id: <20201228124850.735518680@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Stehlé <vincent.stehle@laposte.net>

[ Upstream commit 7eb000bdbe7c7da811ef51942b356f6e819b13ba ]

The ndo_start_xmit() method must not attempt to free the skb to transmit
when returning NETDEV_TX_BUSY. Therefore, make sure the
korina_send_packet() function returns NETDEV_TX_OK when it frees a packet.

Fixes: ef11291bcd5f ("Add support the Korina (IDT RC32434) Ethernet MAC")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20201214220952.19935-1-vincent.stehle@laposte.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/korina.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index b491de946a0e6..88f5c45d9eef4 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -216,7 +216,7 @@ static int korina_send_packet(struct sk_buff *skb, struct net_device *dev)
 			dev_kfree_skb_any(skb);
 			spin_unlock_irqrestore(&lp->lock, flags);
 
-			return NETDEV_TX_BUSY;
+			return NETDEV_TX_OK;
 		}
 	}
 
-- 
2.27.0



