Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A582E66E1
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732733AbgL1NPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:15:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:43926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732723AbgL1NPk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:15:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86175208BA;
        Mon, 28 Dec 2020 13:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161299;
        bh=ztMcmLP2ndXdqPR+hukrhRnfY7xl5Qigjm84IOAIvwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FZr91lxrALg2jBIflJfUL3/sYTFM/O6V3eVUsuc8mmzmE3kGOtXt0Cit3Jy6fl7pX
         AjkxzlihabgeoAzMOvB9dON+3+W7pj7lPZi7c0FSFW+nNdMMwt0meMyN0SLRm2h5eO
         JnfOiKsxgZkEONZQTMxSAUIRXWTel7hLYXECNS08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 167/242] net: korina: fix return value
Date:   Mon, 28 Dec 2020 13:49:32 +0100
Message-Id: <20201228124912.916528298@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
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
index 1eccdbaa9a515..ec1c14e3eace6 100644
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



