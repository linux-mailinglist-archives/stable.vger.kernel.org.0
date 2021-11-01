Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991FB441600
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbhKAJVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:21:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231882AbhKAJVP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:21:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E22C5610A8;
        Mon,  1 Nov 2021 09:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758322;
        bh=51ta6WGyBpUJSQvS01ISrVRQRPfj46ODhDABFHt73Hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zpt0/YoiRnmprrJixMCIbo/MwltwP5Ku393pmiwFzoIR0uW3eqhrpkt+EnAm1UFqP
         TNUbkdNzSxZDPA9nt2T8udJQVpX3e/guL7hjWSlePw7tOLjXVeLU3/HUe4+hiIcSXC
         /Bdyvm28qfkyO8/SGpWXoRR82hN2a8Him8Oi0qk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Woojung.Huh@microchip.com" <Woojung.Huh@microchip.com>,
        Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 13/17] net: lan78xx: fix division by zero in send path
Date:   Mon,  1 Nov 2021 10:17:16 +0100
Message-Id: <20211101082443.660446060@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082440.664392327@linuxfoundation.org>
References: <20211101082440.664392327@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit db6c3c064f5d55fa9969f33eafca3cdbefbb3541 upstream.

Add the missing endpoint max-packet sanity check to probe() to avoid
division by zero in lan78xx_tx_bh() in case a malicious device has
broken descriptors (or when doing descriptor fuzz testing).

Note that USB core will reject URBs submitted for endpoints with zero
wMaxPacketSize but that drivers doing packet-size calculations still
need to handle this (cf. commit 2548288b4fb0 ("USB: Fix: Don't skip
endpoint descriptors with maxpacket=0")).

Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
Cc: stable@vger.kernel.org      # 4.3
Cc: Woojung.Huh@microchip.com <Woojung.Huh@microchip.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/lan78xx.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2956,6 +2956,12 @@ static int lan78xx_probe(struct usb_inte
 
 	dev->maxpacket = usb_maxpacket(dev->udev, dev->pipe_out, 1);
 
+	/* Reject broken descriptors. */
+	if (dev->maxpacket == 0) {
+		ret = -ENODEV;
+		goto out3;
+	}
+
 	/* driver requires remote-wakeup capability during autosuspend. */
 	intf->needs_remote_wakeup = 1;
 


