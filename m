Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDA12AB93B
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731286AbgKINHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:07:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:60066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731292AbgKINHV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:07:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A39720663;
        Mon,  9 Nov 2020 13:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927239;
        bh=XO+HcGUyAwPr75qxuSfndM5Oib47VRApH5qzKi8mTEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iSS7Q4QpvGIrfIvH0FQV9EmCgYF3Q/nTkJh7yTGQAfeEEOM+foLWnHw5jDZ3PlpMZ
         OcPMCCd76xQkrebu+Y7Cj5UbX1+N+dCbHvvUJ293xp58GKXiO8Fkkp52fg2v7gXqdP
         Jg1H9/3JajtxTkoJAf/Lz3gwKJC0Dnq6T9fn1kf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 41/48] USB: serial: option: add LE910Cx compositions 0x1203, 0x1230, 0x1231
Date:   Mon,  9 Nov 2020 13:55:50 +0100
Message-Id: <20201109125018.784032587@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125016.734107741@linuxfoundation.org>
References: <20201109125016.734107741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

commit 489979b4aab490b6b917c11dc02d81b4b742784a upstream.

Add following Telit LE910Cx compositions:

0x1203: rndis, tty, adb, tty, tty, tty, tty
0x1230: tty, adb, rmnet, audio, tty, tty, tty, tty
0x1231: rndis, tty, adb, audio, tty, tty, tty, tty

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Link: https://lore.kernel.org/r/20201031225458.10512-1-dnlplm@gmail.com
[ johan: add comments after entries ]
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1206,6 +1206,8 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(0) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE910),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1203, 0xff),	/* Telit LE910Cx (RNDIS) */
+	  .driver_info = NCTRL(2) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE910_USBCFG4),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE920),
@@ -1220,6 +1222,10 @@ static const struct usb_device_id option
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, TELIT_PRODUCT_LE920A4_1213, 0xff) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE920A4_1214),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) | RSVD(3) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1230, 0xff),	/* Telit LE910Cx (rmnet) */
+	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1231, 0xff),	/* Telit LE910Cx (RNDIS) */
+	  .driver_info = NCTRL(2) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x1260),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x1261),


