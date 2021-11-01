Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73C5441690
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbhKAJ0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:26:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232750AbhKAJYg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:24:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0EDD6117A;
        Mon,  1 Nov 2021 09:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758492;
        bh=AqQ5rZjyolrUl4JA3+1evplUvtoPWm5ptKZ75xjZgKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eD+thv4PtXNUCru2mKEWBTi0miaK2AVP5ZnGzQLQm2yeYccmmQEdRWlYCe2vnMnop
         9diUwpyiyL2bjTYH00KPlQwpolnbVpsRZQ6p1AN0lqRpkWxPSfkYZfKTk8BYMsnrUP
         qb2KBuYjMGF/YzyZlc1KUcYMe8soVYitwHspF9iM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Woojung.Huh@microchip.com" <Woojung.Huh@microchip.com>,
        Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 21/35] net: lan78xx: fix division by zero in send path
Date:   Mon,  1 Nov 2021 10:17:33 +0100
Message-Id: <20211101082456.593817281@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082451.430720900@linuxfoundation.org>
References: <20211101082451.430720900@linuxfoundation.org>
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
@@ -3772,6 +3772,12 @@ static int lan78xx_probe(struct usb_inte
 
 	dev->maxpacket = usb_maxpacket(dev->udev, dev->pipe_out, 1);
 
+	/* Reject broken descriptors. */
+	if (dev->maxpacket == 0) {
+		ret = -ENODEV;
+		goto out4;
+	}
+
 	/* driver requires remote-wakeup capability during autosuspend. */
 	intf->needs_remote_wakeup = 1;
 


