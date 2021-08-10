Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44CC3DD8F2
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235247AbhHBN4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:56:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235471AbhHBNx2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:53:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F27061167;
        Mon,  2 Aug 2021 13:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912336;
        bh=bxJ8tGCXaqtCch2tzQcZ2uv/t86rYWidShSEfUuHCcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=do+vMeC9nfl28P21oC6liU5v0X3br9FzWRvz7ThQJS5+CCtuImm6B4Rn8OwrfsNhA
         8pNWR+UlDc4yWHqXMTYgCqTzGe1U9pwAApzSuv2mQdiU7MtjbN+z33AuP5M2C/jTB0
         Kaap90lVqnpEr25vTFlZcSdiM6tdYL77MRc2z7XQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 14/67] can: peak_usb: pcan_usb_handle_bus_evt(): fix reading rxerr/txerr values
Date:   Mon,  2 Aug 2021 15:44:37 +0200
Message-Id: <20210802134339.501924102@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephane Grosjean <s.grosjean@peak-system.com>

commit 590eb2b7d8cfafb27e8108d52d4bf4850626d31d upstream.

This patch fixes an incorrect way of reading error counters in messages
received for this purpose from the PCAN-USB interface. These messages
inform about the increase or decrease of the error counters, whose values
are placed in bytes 1 and 2 of the message data (not 0 and 1).

Fixes: ea8b33bde76c ("can: pcan_usb: add support of rxerr/txerr counters")
Link: https://lore.kernel.org/r/20210625130931.27438-4-s.grosjean@peak-system.com
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/peak_usb/pcan_usb.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -117,7 +117,8 @@ MODULE_SUPPORTED_DEVICE("PEAK-System PCA
 #define PCAN_USB_BERR_MASK	(PCAN_USB_ERR_RXERR | PCAN_USB_ERR_TXERR)
 
 /* identify bus event packets with rx/tx error counters */
-#define PCAN_USB_ERR_CNT		0x80
+#define PCAN_USB_ERR_CNT_DEC		0x00	/* counters are decreasing */
+#define PCAN_USB_ERR_CNT_INC		0x80	/* counters are increasing */
 
 /* private to PCAN-USB adapter */
 struct pcan_usb {
@@ -611,11 +612,12 @@ static int pcan_usb_handle_bus_evt(struc
 
 	/* acccording to the content of the packet */
 	switch (ir) {
-	case PCAN_USB_ERR_CNT:
+	case PCAN_USB_ERR_CNT_DEC:
+	case PCAN_USB_ERR_CNT_INC:
 
 		/* save rx/tx error counters from in the device context */
-		pdev->bec.rxerr = mc->ptr[0];
-		pdev->bec.txerr = mc->ptr[1];
+		pdev->bec.rxerr = mc->ptr[1];
+		pdev->bec.txerr = mc->ptr[2];
 		break;
 
 	default:


