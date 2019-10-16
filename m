Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 802EBD9FA8
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406657AbfJPV5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:57:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404041AbfJPV5G (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:57:06 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BD6F21928;
        Wed, 16 Oct 2019 21:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263026;
        bh=EMbqtE2zg7VLZV7/JH86HwvEMiPQGYyvT2ZI5le8H20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GV9N4Myg5IKjEQPSzUoDz8aqyg+jm1ZjTLgx3orcqIArEZ7acuIeUeeuHyo+oRZXB
         ocG8mIlSUH97XHG43O/WnX1BWapuj5s8FrdIWA1DgjTFdg88bR1rMtSXH4dMUsRd6z
         o2k6x/1KFVjQ3aP77VUynQcX/hGT9iaspcrFOpJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 27/81] USB: serial: option: add Telit FN980 compositions
Date:   Wed, 16 Oct 2019 14:50:38 -0700
Message-Id: <20191016214829.379128622@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214805.727399379@linuxfoundation.org>
References: <20191016214805.727399379@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

commit 5eb3f4b87a0e7e949c976f32f296176a06d1a93b upstream.

This patch adds the following Telit FN980 compositions:

0x1050: tty, adb, rmnet, tty, tty, tty, tty
0x1051: tty, adb, mbim, tty, tty, tty, tty
0x1052: rndis, tty, adb, tty, tty, tty, tty
0x1053: tty, adb, ecm, tty, tty, tty, tty

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1154,6 +1154,14 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) | RSVD(3) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, TELIT_PRODUCT_LE922_USBCFG5, 0xff),
 	  .driver_info = RSVD(0) | RSVD(1) | NCTRL(2) | RSVD(3) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1050, 0xff),	/* Telit FN980 (rmnet) */
+	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1051, 0xff),	/* Telit FN980 (MBIM) */
+	  .driver_info = NCTRL(0) | RSVD(1) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1052, 0xff),	/* Telit FN980 (RNDIS) */
+	  .driver_info = NCTRL(2) | RSVD(3) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1053, 0xff),	/* Telit FN980 (ECM) */
+	  .driver_info = NCTRL(0) | RSVD(1) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910_DUAL_MODEM),


