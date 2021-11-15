Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429C7451331
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347921AbhKOTsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:48:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:44632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245453AbhKOTUe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0581A6353A;
        Mon, 15 Nov 2021 18:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001289;
        bh=2E11HPbnpoP3ZMBB7ZGLot/mRAJfLlj36XKRVFQtdEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L+/KEHeaKbCzjmS85ReqI9ESNaCCWGCcJyxs03Ev8DYF62GMcN0FMomimu8btTG8F
         azm+BAdylzgbmiZvUQMa8OL45UeghovRujyzb4w2pob69EVMCHq1iU9g0Rs2xFxKsE
         AU/hh7IgoGRExtcoDU4vBOVjCmqqzyc65c4H/l7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 126/917] can: peak_usb: always ask for BERR reporting for PCAN-USB devices
Date:   Mon, 15 Nov 2021 17:53:41 +0100
Message-Id: <20211115165433.030272983@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephane Grosjean <s.grosjean@peak-system.com>

commit 3f1c7aa28498e52a5e6aa2f1b89bf35c63352cfd upstream.

Since for the PCAN-USB, the management of the transition to the
ERROR_WARNING or ERROR_PASSIVE state is done according to the error
counters, these must be requested unconditionally.

Link: https://lore.kernel.org/all/20211021081505.18223-2-s.grosjean@peak-system.com
Fixes: c11dcee75830 ("can: peak_usb: pcan_usb_decode_error(): upgrade handling of bus state changes")
Cc: stable@vger.kernel.org
Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/peak_usb/pcan_usb.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -841,14 +841,14 @@ static int pcan_usb_start(struct peak_us
 	pdev->bec.rxerr = 0;
 	pdev->bec.txerr = 0;
 
-	/* be notified on error counter changes (if requested by user) */
-	if (dev->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING) {
-		err = pcan_usb_set_err_frame(dev, PCAN_USB_BERR_MASK);
-		if (err)
-			netdev_warn(dev->netdev,
-				    "Asking for BERR reporting error %u\n",
-				    err);
-	}
+	/* always ask the device for BERR reporting, to be able to switch from
+	 * WARNING to PASSIVE state
+	 */
+	err = pcan_usb_set_err_frame(dev, PCAN_USB_BERR_MASK);
+	if (err)
+		netdev_warn(dev->netdev,
+			    "Asking for BERR reporting error %u\n",
+			    err);
 
 	/* if revision greater than 3, can put silent mode on/off */
 	if (dev->device_rev > 3) {
@@ -986,7 +986,6 @@ const struct peak_usb_adapter pcan_usb =
 	.device_id = PCAN_USB_PRODUCT_ID,
 	.ctrl_count = 1,
 	.ctrlmode_supported = CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY |
-			      CAN_CTRLMODE_BERR_REPORTING |
 			      CAN_CTRLMODE_CC_LEN8_DLC,
 	.clock = {
 		.freq = PCAN_USB_CRYSTAL_HZ / 2,


