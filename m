Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09CD2F178B
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbhAKNDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:03:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:50228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729877AbhAKNDd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:03:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25DBD22B49;
        Mon, 11 Jan 2021 13:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370180;
        bh=03QUWQ415jjUHIpHk/zRgS5jbP2+2GX/ofxhdKU9KSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IVOh3H2b7WJlaIGjqoHQaqp89d9fDUu/4yTJN/N5k/e0D94HjLTMLpfPTNKNGuMhP
         MnbdJiXAKxRgBkXFPFtTm33q2fTS9rfsEldeEgjOGL5I71b2V+MrrbmIWqcUvv2I0T
         QiE1YAPWdP29kB7T1RWHCl7q4zHJ4g7EU9cd8bU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roland Dreier <roland@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 13/45] CDC-NCM: remove "connected" log message
Date:   Mon, 11 Jan 2021 14:00:51 +0100
Message-Id: <20210111130034.290222470@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.676306636@linuxfoundation.org>
References: <20210111130033.676306636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roland Dreier <roland@kernel.org>

[ Upstream commit 59b4a8fa27f5a895582ada1ae5034af7c94a57b5 ]

The cdc_ncm driver passes network connection notifications up to
usbnet_link_change(), which is the right place for any logging.
Remove the netdev_info() duplicating this from the driver itself.

This stops devices such as my "TRENDnet USB 10/100/1G/2.5G LAN"
(ID 20f4:e02b) adapter from spamming the kernel log with

    cdc_ncm 2-2:2.0 enp0s2u2c2: network connection: connected

messages every 60 msec or so.

Signed-off-by: Roland Dreier <roland@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20201224032116.2453938-1-roland@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/cdc_ncm.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1602,9 +1602,6 @@ static void cdc_ncm_status(struct usbnet
 		 * USB_CDC_NOTIFY_NETWORK_CONNECTION notification shall be
 		 * sent by device after USB_CDC_NOTIFY_SPEED_CHANGE.
 		 */
-		netif_info(dev, link, dev->net,
-			   "network connection: %sconnected\n",
-			   !!event->wValue ? "" : "dis");
 		usbnet_link_change(dev, !!event->wValue, 0);
 		break;
 


