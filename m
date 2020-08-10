Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D15B240A15
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728923AbgHJPiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:38:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727985AbgHJP0C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:26:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6613208A9;
        Mon, 10 Aug 2020 15:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073160;
        bh=VSEtM7KXc3vCmy6YGlDolpvvft5r9FlIcRKnYXIPviM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wK+H9PNPX7Fkq4S9T7lDCCw/1/q6jMsy6LYnpDg7mCHj8uBTD6afDS2Ph3N7GVyvH
         z8+bhuVQ2RN61+ojWqilvpKNAPOZaYz9GMqYXnj6CLYVmVD5oskd+zYzuS5uxxP7W0
         q6Cmmf758x9Q8cGOUJfpRmtYLrZ7AHD1hQyf+NjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Roese <sr@denx.de>,
        Reto Schneider <reto.schneider@husqvarnagroup.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 68/79] net: macb: Properly handle phylink on at91sam9x
Date:   Mon, 10 Aug 2020 17:21:27 +0200
Message-Id: <20200810151815.589057385@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Roese <sr@denx.de>

[ Upstream commit f7ba7dbf4f7af67b5936ff1cbd40a3254b409ebf ]

I just recently noticed that ethernet does not work anymore since v5.5
on the GARDENA smart Gateway, which is based on the AT91SAM9G25.
Debugging showed that the "GEM bits" in the NCFGR register are now
unconditionally accessed, which is incorrect for the !macb_is_gem()
case.

This patch adds the macb_is_gem() checks back to the code
(in macb_mac_config() & macb_mac_link_up()), so that the GEM register
bits are not accessed in this case any more.

Fixes: 7897b071ac3b ("net: macb: convert to phylink")
Signed-off-by: Stefan Roese <sr@denx.de>
Cc: Reto Schneider <reto.schneider@husqvarnagroup.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -578,7 +578,7 @@ static void macb_mac_config(struct phyli
 	if (bp->caps & MACB_CAPS_MACB_IS_EMAC) {
 		if (state->interface == PHY_INTERFACE_MODE_RMII)
 			ctrl |= MACB_BIT(RM9200_RMII);
-	} else {
+	} else if (macb_is_gem(bp)) {
 		ctrl &= ~(GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL));
 
 		if (state->interface == PHY_INTERFACE_MODE_SGMII)
@@ -639,10 +639,13 @@ static void macb_mac_link_up(struct phyl
 		ctrl |= MACB_BIT(FD);
 
 	if (!(bp->caps & MACB_CAPS_MACB_IS_EMAC)) {
-		ctrl &= ~(GEM_BIT(GBE) | MACB_BIT(PAE));
-
-		if (speed == SPEED_1000)
-			ctrl |= GEM_BIT(GBE);
+		ctrl &= ~MACB_BIT(PAE);
+		if (macb_is_gem(bp)) {
+			ctrl &= ~GEM_BIT(GBE);
+
+			if (speed == SPEED_1000)
+				ctrl |= GEM_BIT(GBE);
+		}
 
 		/* We do not support MLO_PAUSE_RX yet */
 		if (tx_pause)


