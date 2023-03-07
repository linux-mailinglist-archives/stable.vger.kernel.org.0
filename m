Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB606AE9C1
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbjCGR1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbjCGR1C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:27:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2130695BF7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:22:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACCCC614FF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0D0C433D2;
        Tue,  7 Mar 2023 17:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209726;
        bh=r9bSOHdz2R6gaN2oBXmC8gpiJCZyz0yodePAWg2McYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FuiymdPWhOg3YD/NRK2uk0KGVVN/M+P8YmUnTJB7D5x1wUja7UvittTvCaoiryFYT
         UoUJGqUJeAa1rE6gKx7jzdf1ZIICdKG91v0Gzdn6bv6/5hDIJX/XYErvYymdwyT3/e
         hD1llAbUWuLnW2HML5JXhlS/0AFpK3YyGgFEMKAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Frank Jungclaus <frank.jungclaus@esd.eu>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0311/1001] can: esd_usb: Make use of can_change_state() and relocate checking skb for NULL
Date:   Tue,  7 Mar 2023 17:51:23 +0100
Message-Id: <20230307170035.046831925@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Jungclaus <frank.jungclaus@esd.eu>

[ Upstream commit 9684b000a86299b5968fef8ffbf1484def37452a ]

Start a rework initiated by Vincents remarks "You should not report
the greatest of txerr and rxerr but the one which actually increased."
[1] and "As far as I understand, those flags should be set only when
the threshold is reached" [2] .

Therefore make use of can_change_state() to (among others) set the
flags CAN_ERR_CRTL_[RT]X_WARNING and CAN_ERR_CRTL_[RT]X_PASSIVE,
maintain CAN statistic counters for error_warning, error_passive and
bus_off.

Relocate testing alloc_can_err_skb() for NULL to the end of
esd_usb_rx_event(), to have things like can_bus_off(),
can_change_state() working even in out of memory conditions.

Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
Link: [1] https://lore.kernel.org/all/CAMZ6RqKGBWe15aMkf8-QLf-cOQg99GQBebSm+1wEzTqHgvmNuw@mail.gmail.com/
Link: [2] https://lore.kernel.org/all/CAMZ6Rq+QBO1yTX_o6GV0yhdBj-RzZSRGWDZBS0fs7zbSTy4hmA@mail.gmail.com/
Link: https://lore.kernel.org/all/20230216190450.3901254-3-frank.jungclaus@esd.eu
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/esd_usb.c | 50 +++++++++++++++++------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 5e182fadd875e..578b25f873e58 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -239,41 +239,42 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 			   msg->msg.rx.dlc, state, ecc, rxerr, txerr);
 
 		skb = alloc_can_err_skb(priv->netdev, &cf);
-		if (skb == NULL) {
-			stats->rx_dropped++;
-			return;
-		}
 
 		if (state != priv->old_state) {
+			enum can_state tx_state, rx_state;
+			enum can_state new_state = CAN_STATE_ERROR_ACTIVE;
+
 			priv->old_state = state;
 
 			switch (state & ESD_BUSSTATE_MASK) {
 			case ESD_BUSSTATE_BUSOFF:
-				priv->can.state = CAN_STATE_BUS_OFF;
-				cf->can_id |= CAN_ERR_BUSOFF;
-				priv->can.can_stats.bus_off++;
+				new_state = CAN_STATE_BUS_OFF;
 				can_bus_off(priv->netdev);
 				break;
 			case ESD_BUSSTATE_WARN:
-				priv->can.state = CAN_STATE_ERROR_WARNING;
-				priv->can.can_stats.error_warning++;
+				new_state = CAN_STATE_ERROR_WARNING;
 				break;
 			case ESD_BUSSTATE_ERRPASSIVE:
-				priv->can.state = CAN_STATE_ERROR_PASSIVE;
-				priv->can.can_stats.error_passive++;
+				new_state = CAN_STATE_ERROR_PASSIVE;
 				break;
 			default:
-				priv->can.state = CAN_STATE_ERROR_ACTIVE;
+				new_state = CAN_STATE_ERROR_ACTIVE;
 				txerr = 0;
 				rxerr = 0;
 				break;
 			}
-		} else {
+
+			if (new_state != priv->can.state) {
+				tx_state = (txerr >= rxerr) ? new_state : 0;
+				rx_state = (txerr <= rxerr) ? new_state : 0;
+				can_change_state(priv->netdev, cf,
+						 tx_state, rx_state);
+			}
+		} else if (skb) {
 			priv->can.can_stats.bus_error++;
 			stats->rx_errors++;
 
-			cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR |
-				      CAN_ERR_CNT;
+			cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
 
 			switch (ecc & SJA1000_ECC_MASK) {
 			case SJA1000_ECC_BIT:
@@ -295,21 +296,20 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 
 			/* Bit stream position in CAN frame as the error was detected */
 			cf->data[3] = ecc & SJA1000_ECC_SEG;
-
-			if (priv->can.state == CAN_STATE_ERROR_WARNING ||
-			    priv->can.state == CAN_STATE_ERROR_PASSIVE) {
-				cf->data[1] = (txerr > rxerr) ?
-					CAN_ERR_CRTL_TX_PASSIVE :
-					CAN_ERR_CRTL_RX_PASSIVE;
-			}
-			cf->data[6] = txerr;
-			cf->data[7] = rxerr;
 		}
 
 		priv->bec.txerr = txerr;
 		priv->bec.rxerr = rxerr;
 
-		netif_rx(skb);
+		if (skb) {
+			cf->can_id |= CAN_ERR_CNT;
+			cf->data[6] = txerr;
+			cf->data[7] = rxerr;
+
+			netif_rx(skb);
+		} else {
+			stats->rx_dropped++;
+		}
 	}
 }
 
-- 
2.39.2



