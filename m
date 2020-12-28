Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021442E657D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390901AbgL1Nbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:31:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:59552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390597AbgL1NbK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:31:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCBA22072C;
        Mon, 28 Dec 2020 13:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162255;
        bh=Q7iuGwhXio1TWt9u6d1V9bWObd4jcJvFwHvZOEyNLO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ybDY8x6hgHNn9r/tlWsDH+BtWOg/GBGqtnFG9mCMDaHxHtISklQ4vPNZ1tF2e7KBS
         gaBeY2G5FEDinhD+d+Lg1BcN/thJZnSZk04qiILdT1/hwFeAwKrbeYzzA+8hQYzeEg
         aXPX0uR+UcjMox9qMpWcdHvWSvkCpM0DPRO3aoYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 240/346] net: korina: fix return value
Date:   Mon, 28 Dec 2020 13:49:19 +0100
Message-Id: <20201228124931.367303107@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index 993f495e2bf7b..9f804e2aba359 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -219,7 +219,7 @@ static int korina_send_packet(struct sk_buff *skb, struct net_device *dev)
 			dev_kfree_skb_any(skb);
 			spin_unlock_irqrestore(&lp->lock, flags);
 
-			return NETDEV_TX_BUSY;
+			return NETDEV_TX_OK;
 		}
 	}
 
-- 
2.27.0



