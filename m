Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3CC64A10F
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbiLLNeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:34:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbiLLNeb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:34:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9648013EA8
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:34:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52495B80D4D
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E95AC433F0;
        Mon, 12 Dec 2022 13:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852068;
        bh=la/l2ByECrSfUBi7oeZsEB5vOX08PdTJSuNLsZB81gQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JDrMVeHM0pTc9lMVJqPOOl+nPtk56Il2Ip/MBAGQks/FzR+De850kw6Mz8Ccvb0vY
         0b2MZYrSLTxS2lpSZdjXjKxnRctvK82Pgtp0ok3mpogtxU7MMoUT7Ts8/I2F0D+2hz
         qKcT4mXENJbACG18CpA4Nknqt7Kt65bp4dIq1YcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Frank Jungclaus <frank.jungclaus@esd.eu>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 120/123] can: esd_usb: Allow REC and TEC to return to zero
Date:   Mon, 12 Dec 2022 14:18:06 +0100
Message-Id: <20221212130932.402569504@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Jungclaus <frank.jungclaus@esd.eu>

[ Upstream commit 918ee4911f7a41fb4505dff877c1d7f9f64eb43e ]

We don't get any further EVENT from an esd CAN USB device for changes
on REC or TEC while those counters converge to 0 (with ecc == 0). So
when handling the "Back to Error Active"-event force txerr = rxerr =
0, otherwise the berr-counters might stay on values like 95 forever.

Also, to make life easier during the ongoing development a
netdev_dbg() has been introduced to allow dumping error events send by
an esd CAN USB device.

Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
Link: https://lore.kernel.org/all/20221130202242.3998219-2-frank.jungclaus@esd.eu
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/esd_usb2.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index c6068a251fbe..9ed048cb07e6 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -227,6 +227,10 @@ static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
 		u8 rxerr = msg->msg.rx.data[2];
 		u8 txerr = msg->msg.rx.data[3];
 
+		netdev_dbg(priv->netdev,
+			   "CAN_ERR_EV_EXT: dlc=%#02x state=%02x ecc=%02x rec=%02x tec=%02x\n",
+			   msg->msg.rx.dlc, state, ecc, rxerr, txerr);
+
 		skb = alloc_can_err_skb(priv->netdev, &cf);
 		if (skb == NULL) {
 			stats->rx_dropped++;
@@ -253,6 +257,8 @@ static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
 				break;
 			default:
 				priv->can.state = CAN_STATE_ERROR_ACTIVE;
+				txerr = 0;
+				rxerr = 0;
 				break;
 			}
 		} else {
-- 
2.35.1



