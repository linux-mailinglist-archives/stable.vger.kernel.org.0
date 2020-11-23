Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E5A2C0B11
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731893AbgKWMhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:37:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:49290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731865AbgKWMhL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:37:11 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5F4420888;
        Mon, 23 Nov 2020 12:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135031;
        bh=uAl/Hj/W/wcK0yBx/8xKCDgjvvm9J8Ad/jZllIuEMww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZAx2+BVKvdqGU38wDChYU18546RA1B65r7fdw7icZR8X3USbjuxTXcaBxQ6qxyB4p
         1Al2yRgZv7ipu4FgKdOfyL/fTj5dha9BoZ6gA55039H5TkJMLoWL37oSZHNRMbtvYi
         d1l+DgM/ynvMpHRHc7xXmBkwwIbkWBKG6W4QafXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Remigiusz=20Ko=C5=82=C5=82=C4=85taj?= 
        <remigiusz.kollataj@mobica.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/158] can: mcba_usb: mcba_usb_start_xmit(): first fill skb, then pass to can_put_echo_skb()
Date:   Mon, 23 Nov 2020 13:21:47 +0100
Message-Id: <20201123121823.750193611@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 81c9c8e0adef3285336b942f93287c554c89e6c6 ]

The driver has to first fill the skb with data and then handle it to
can_put_echo_skb(). This patch moves the can_put_echo_skb() down, right before
sending the skb out via USB.

Fixes: 51f3baad7de9 ("can: mcba_usb: Add support for Microchip CAN BUS Analyzer")
Cc: Remigiusz Kołłątaj <remigiusz.kollataj@mobica.com>
Link: https://lore.kernel.org/r/20201111221204.1639007-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/mcba_usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 21faa2ec46327..8f785c199e220 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -326,8 +326,6 @@ static netdev_tx_t mcba_usb_start_xmit(struct sk_buff *skb,
 	if (!ctx)
 		return NETDEV_TX_BUSY;
 
-	can_put_echo_skb(skb, priv->netdev, ctx->ndx);
-
 	if (cf->can_id & CAN_EFF_FLAG) {
 		/* SIDH    | SIDL                 | EIDH   | EIDL
 		 * 28 - 21 | 20 19 18 x x x 17 16 | 15 - 8 | 7 - 0
@@ -357,6 +355,8 @@ static netdev_tx_t mcba_usb_start_xmit(struct sk_buff *skb,
 	if (cf->can_id & CAN_RTR_FLAG)
 		usb_msg.dlc |= MCBA_DLC_RTR_MASK;
 
+	can_put_echo_skb(skb, priv->netdev, ctx->ndx);
+
 	err = mcba_usb_xmit(priv, (struct mcba_usb_msg *)&usb_msg, ctx);
 	if (err)
 		goto xmit_failed;
-- 
2.27.0



