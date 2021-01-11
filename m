Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5412F12D5
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbhAKNAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:00:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:48478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbhAKNAr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:00:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE0B92250F;
        Mon, 11 Jan 2021 13:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370007;
        bh=GMWVMHhoh3yECIti5hAbdNTaqBInS03q2FX2KW9vo4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DcHJUmaFuxS+czFsCGeaUEv8si/b8cjWPu4C0CL8MywLnsOikJ4uAZntXDUtnsIFQ
         e9IxQaH/8rr1z1sApJz3MLBS1xHw5GU67Lz2+rBglfPrFB7jvKiar+A1Z3aR/b5KGt
         ZNalegstwYUeiTlu6F+VgChZ0rGxtCyCxI6zj2PU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roland Dreier <roland@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 10/38] CDC-NCM: remove "connected" log message
Date:   Mon, 11 Jan 2021 14:00:42 +0100
Message-Id: <20210111130032.965314461@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130032.469630231@linuxfoundation.org>
References: <20210111130032.469630231@linuxfoundation.org>
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
@@ -1553,9 +1553,6 @@ static void cdc_ncm_status(struct usbnet
 		 * USB_CDC_NOTIFY_NETWORK_CONNECTION notification shall be
 		 * sent by device after USB_CDC_NOTIFY_SPEED_CHANGE.
 		 */
-		netif_info(dev, link, dev->net,
-			   "network connection: %sconnected\n",
-			   !!event->wValue ? "" : "dis");
 		usbnet_link_change(dev, !!event->wValue, 0);
 		break;
 


