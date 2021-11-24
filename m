Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 662DB45BC9F
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245203AbhKXMb3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:31:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:42294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244321AbhKXM1C (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:27:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1EE26124D;
        Wed, 24 Nov 2021 12:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756189;
        bh=7DLh4txpxMQIEJZ6/SIU7QDmWoljzqIfb6aw6fP9rfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k6FwbEBfwa8+yt0NGy0PBN8PbiS2Tr55SR5R7XSuXBN7Fyv5KkRmWUODyAhQ/DTBP
         QK5e1rAFWu3eriX/QWD7XR5sD0ofLyl2jPP/7crBWwHc7Xyj2D0l1HZS47rG3OSfSB
         BriGWAfC19h7EcKp229Go4KetAbwC23GLw7h/oJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Subject: [PATCH 4.9 206/207] usb: max-3421: Use driver data instead of maintaining a list of bound devices
Date:   Wed, 24 Nov 2021 12:57:57 +0100
Message-Id: <20211124115710.620124196@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit fc153aba3ef371d0d76eb88230ed4e0dee5b38f2 upstream.

Instead of maintaining a single-linked list of devices that must be
searched linearly in .remove() just use spi_set_drvdata() to remember the
link between the spi device and the driver struct. Then the global list
and the next member can be dropped.

This simplifies the driver, reduces the memory footprint and the time to
search the list. Also it makes obvious that there is always a corresponding
driver struct for a given device in .remove(), so the error path for
!max3421_hcd can be dropped, too.

As a side effect this fixes a data inconsistency when .probe() races with
itself for a second max3421 device in manipulating max3421_hcd_list. A
similar race is fixed in .remove(), too.

Fixes: 2d53139f3162 ("Add support for using a MAX3421E chip as a host driver.")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20211018204028.2914597-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/max3421-hcd.c |   25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -121,8 +121,6 @@ struct max3421_hcd {
 
 	struct task_struct *spi_thread;
 
-	struct max3421_hcd *next;
-
 	enum max3421_rh_state rh_state;
 	/* lower 16 bits contain port status, upper 16 bits the change mask: */
 	u32 port_status;
@@ -170,8 +168,6 @@ struct max3421_ep {
 	u8 retransmit;			/* packet needs retransmission */
 };
 
-static struct max3421_hcd *max3421_hcd_list;
-
 #define MAX3421_FIFO_SIZE	64
 
 #define MAX3421_SPI_DIR_RD	0	/* read register from MAX3421 */
@@ -1835,9 +1831,8 @@ max3421_probe(struct spi_device *spi)
 	}
 	set_bit(HCD_FLAG_POLL_RH, &hcd->flags);
 	max3421_hcd = hcd_to_max3421(hcd);
-	max3421_hcd->next = max3421_hcd_list;
-	max3421_hcd_list = max3421_hcd;
 	INIT_LIST_HEAD(&max3421_hcd->ep_list);
+	spi_set_drvdata(spi, max3421_hcd);
 
 	max3421_hcd->tx = kmalloc(sizeof(*max3421_hcd->tx), GFP_KERNEL);
 	if (!max3421_hcd->tx)
@@ -1882,28 +1877,18 @@ error:
 static int
 max3421_remove(struct spi_device *spi)
 {
-	struct max3421_hcd *max3421_hcd = NULL, **prev;
-	struct usb_hcd *hcd = NULL;
+	struct max3421_hcd *max3421_hcd;
+	struct usb_hcd *hcd;
 	unsigned long flags;
 
-	for (prev = &max3421_hcd_list; *prev; prev = &(*prev)->next) {
-		max3421_hcd = *prev;
-		hcd = max3421_to_hcd(max3421_hcd);
-		if (hcd->self.controller == &spi->dev)
-			break;
-	}
-	if (!max3421_hcd) {
-		dev_err(&spi->dev, "no MAX3421 HCD found for SPI device %p\n",
-			spi);
-		return -ENODEV;
-	}
+	max3421_hcd = spi_get_drvdata(spi);
+	hcd = max3421_to_hcd(max3421_hcd);
 
 	usb_remove_hcd(hcd);
 
 	spin_lock_irqsave(&max3421_hcd->lock, flags);
 
 	kthread_stop(max3421_hcd->spi_thread);
-	*prev = max3421_hcd->next;
 
 	spin_unlock_irqrestore(&max3421_hcd->lock, flags);
 


