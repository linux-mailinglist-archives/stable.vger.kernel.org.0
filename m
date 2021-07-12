Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AACF3C47E7
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236208AbhGLGfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:35:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237181AbhGLGeL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:34:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C9D561165;
        Mon, 12 Jul 2021 06:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071434;
        bh=t8CF6AnxG7tUuWlwhPOj6Ne/EDnYrz8D0efICY2thcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WBcZDUzduIzruYTwfEDLH2tENfh37Jt0IxpechBPmY1RgLpNEixuqjNplBJw3z46m
         Imk47blhW4ywoHvkfmIIWX2y/Qr5W10WCAt9TqyE8E3ZeNxd8mJ6SvUkqG/G6LSI92
         6DFHo3Utm/A5ysFAoVas0hzoSgancfd5/XJPWIZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 020/593] net: can: ems_usb: fix use-after-free in ems_usb_disconnect()
Date:   Mon, 12 Jul 2021 08:03:00 +0200
Message-Id: <20210712060845.425566581@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit ab4a0b8fcb9a95c02909b62049811bd2e586aaa4 upstream.

In ems_usb_disconnect() dev pointer, which is netdev private data, is
used after free_candev() call:
| 	if (dev) {
| 		unregister_netdev(dev->netdev);
| 		free_candev(dev->netdev);
|
| 		unlink_all_urbs(dev);
|
| 		usb_free_urb(dev->intr_urb);
|
| 		kfree(dev->intr_in_buffer);
| 		kfree(dev->tx_msg_buffer);
| 	}

Fix it by simply moving free_candev() at the end of the block.

Fail log:
| BUG: KASAN: use-after-free in ems_usb_disconnect
| Read of size 8 at addr ffff88804e041008 by task kworker/1:2/2895
|
| CPU: 1 PID: 2895 Comm: kworker/1:2 Not tainted 5.13.0-rc5+ #164
| Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a-rebuilt.opensuse.4
| Workqueue: usb_hub_wq hub_event
| Call Trace:
|     dump_stack (lib/dump_stack.c:122)
|     print_address_description.constprop.0.cold (mm/kasan/report.c:234)
|     kasan_report.cold (mm/kasan/report.c:420 mm/kasan/report.c:436)
|     ems_usb_disconnect (drivers/net/can/usb/ems_usb.c:683 drivers/net/can/usb/ems_usb.c:1058)

Fixes: 702171adeed3 ("ems_usb: Added support for EMS CPC-USB/ARM7 CAN/USB interface")
Link: https://lore.kernel.org/r/20210617185130.5834-1-paskripkin@gmail.com
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/usb/ems_usb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -1053,7 +1053,6 @@ static void ems_usb_disconnect(struct us
 
 	if (dev) {
 		unregister_netdev(dev->netdev);
-		free_candev(dev->netdev);
 
 		unlink_all_urbs(dev);
 
@@ -1061,6 +1060,8 @@ static void ems_usb_disconnect(struct us
 
 		kfree(dev->intr_in_buffer);
 		kfree(dev->tx_msg_buffer);
+
+		free_candev(dev->netdev);
 	}
 }
 


