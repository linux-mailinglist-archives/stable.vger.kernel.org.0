Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A889911E29
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbfEBP0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:26:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727781AbfEBP0k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:26:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DF4D208C4;
        Thu,  2 May 2019 15:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810799;
        bh=n6TmpvV7ZyMKI+KcjMHX070YR43loG/ifxmOyCgMVwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2abZBkqTOBeT40j2qtviSanRmxc7OOhuWo/PA8vzjf2EV/v+KoQL4LRBHEULYumjq
         rsKBGiX4A6Vdc5cdYU9bjePF8LAvzH9uya74guB9Bhogi12/CrvkL7h6Dm16rD4EsI
         6z96aQ0RqA7Ee2dCmvwqNskc3/oZ2SUta6BaFXbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Frank Pavlic <f.pavlic@kunbus.de>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.19 33/72] net: ks8851: Dequeue RX packets explicitly
Date:   Thu,  2 May 2019 17:20:55 +0200
Message-Id: <20190502143336.146825791@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143333.437607839@linuxfoundation.org>
References: <20190502143333.437607839@linuxfoundation.org>
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
index bd6e9014bc74..a93f8e842c07 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -535,9 +535,8 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
 		/* set dma read address */
 		ks8851_wrreg16(ks, KS_RXFDPR, RXFDPR_RXFPAI | 0x00);
 
-		/* start the packet dma process, and set auto-dequeue rx */
-		ks8851_wrreg16(ks, KS_RXQCR,
-			       ks->rc_rxqcr | RXQCR_SDA | RXQCR_ADRFE);
+		/* start DMA access */
+		ks8851_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr | RXQCR_SDA);
 
 		if (rxlen > 4) {
 			unsigned int rxalign;
@@ -568,7 +567,8 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
 			}
 		}
 
-		ks8851_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr);
+		/* end DMA access and dequeue packet */
+		ks8851_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr | RXQCR_RRXEF);
 	}
 }
 
-- 
2.19.1



