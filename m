Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60F4A1F423
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfEOMU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 08:20:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbfEOK7F (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 06:59:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EF2C216F4;
        Wed, 15 May 2019 10:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557917944;
        bh=kLulZLzUhkByAZrZe2XqhPOfttVK+QVkjuEqGDQP47E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r4nyXwdJtUdZHtTkdjMQts8wYmDMUJzQSBZQgTPPHVbWukySJFCV04jBjc2K9Qh6C
         UGKKa5d3X4elwNRDT0/Gb7zLHRqgsf8U2uyLVw52JQ2DqM67fwde8mLWubO2E3975E
         /i6RuH7+SL0zTsEH9ZCF4vilyzIFeqLqNwDhFRHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Frank Pavlic <f.pavlic@kunbus.de>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 3.18 17/86] net: ks8851: Dequeue RX packets explicitly
Date:   Wed, 15 May 2019 12:54:54 +0200
Message-Id: <20190515090645.962899484@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090642.339346723@linuxfoundation.org>
References: <20190515090642.339346723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 536d3680fd2dab5c39857d62a3e084198fc74ff9 ]

The ks8851 driver lets the chip auto-dequeue received packets once they
have been read in full. It achieves that by setting the ADRFE flag in
the RXQCR register ("Auto-Dequeue RXQ Frame Enable").

However if allocation of a packet's socket buffer or retrieval of the
packet over the SPI bus fails, the packet will not have been read in
full and is not auto-dequeued. Such partial retrieval of a packet
confuses the chip's RX queue management:  On the next RX interrupt,
the first packet read from the queue will be the one left there
previously and this one can be retrieved without issues. But for any
newly received packets, the frame header status and byte count registers
(RXFHSR and RXFHBCR) contain bogus values, preventing their retrieval.

The chip allows explicitly dequeueing a packet from the RX queue by
setting the RRXEF flag in the RXQCR register ("Release RX Error Frame").
This could be used to dequeue the packet in case of an error, but if
that error is a failed SPI transfer, it is unknown if the packet was
transferred in full and was auto-dequeued or if it was only transferred
in part and requires an explicit dequeue. The safest approach is thus
to always dequeue packets explicitly and forgo auto-dequeueing.

Without this change, I've witnessed packet retrieval break completely
when an SPI DMA transfer fails, requiring a chip reset. Explicit
dequeueing magically fixes this and makes packet retrieval absolutely
robust for me.

The chip's documentation suggests auto-dequeuing and uses the RRXEF
flag only to dequeue error frames which the driver doesn't want to
retrieve. But that seems to be a fair-weather approach.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: Frank Pavlic <f.pavlic@kunbus.de>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/net/ethernet/micrel/ks8851.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 66d4ab703f45..4a29e191819f 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -547,9 +547,8 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
 		/* set dma read address */
 		ks8851_wrreg16(ks, KS_RXFDPR, RXFDPR_RXFPAI | 0x00);
 
-		/* start the packet dma process, and set auto-dequeue rx */
-		ks8851_wrreg16(ks, KS_RXQCR,
-			       ks->rc_rxqcr | RXQCR_SDA | RXQCR_ADRFE);
+		/* start DMA access */
+		ks8851_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr | RXQCR_SDA);
 
 		if (rxlen > 4) {
 			unsigned int rxalign;
@@ -580,7 +579,8 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
 			}
 		}
 
-		ks8851_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr);
+		/* end DMA access and dequeue packet */
+		ks8851_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr | RXQCR_RRXEF);
 	}
 }
 
-- 
2.19.1



