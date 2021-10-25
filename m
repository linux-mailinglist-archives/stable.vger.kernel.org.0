Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D93E4395E6
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 14:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233136AbhJYMTr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 08:19:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233066AbhJYMTn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 08:19:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC02A61027;
        Mon, 25 Oct 2021 12:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635164239;
        bh=YFwLRyGwAZtnL++iA+D5m4TYup42zCL/qnKUOAkiau0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tcAem/Oa4ouXbgBwyvGsBAbDs3XORSwVwDp0O8C6aTMznlsQ1v+foKJw/G2kZhKx3
         FT8hIhkgnWxgufgCUYXNdUQk598fw9axFjVbAbXjlR9lgeQPRdHt5LlvRrN4xjwG/s
         MBH2IxZtoM5CjIXsRhaA3OQbanNwgjGgTCfGj04yBeeoAq5l7NlvzUxkEbi4zxXdbB
         iUHB8Np6mH+yEnNU7R3u5/bcAkCiJW/hIPuQkOMnODnjFWY/+sog0Lmb4NqdBI4lLQ
         gXQfObHDDwx+wLwuqRJdkA+8N97b+7S8cjIVR21SwdksArZmu40r7r7hX40UKmHlf+
         2FnNUZDwkff9w==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meyuU-0001mF-Eu; Mon, 25 Oct 2021 14:17:02 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Mike Isely <isely@pobox.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/8] media: mceusb: fix control-message timeouts
Date:   Mon, 25 Oct 2021 14:16:34 +0200
Message-Id: <20211025121641.6759-2-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211025121641.6759-1-johan@kernel.org>
References: <20211025121641.6759-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: 66e89522aff7 ("V4L/DVB: IR: add mceusb IR receiver driver")
Cc: stable@vger.kernel.org      # 2.6.36
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/rc/mceusb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index e03dd1f0144f..7a8a889d54a2 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1429,7 +1429,7 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
 	 */
 	ret = usb_control_msg(ir->usbdev, usb_rcvctrlpipe(ir->usbdev, 0),
 			      USB_REQ_SET_ADDRESS, USB_TYPE_VENDOR, 0, 0,
-			      data, USB_CTRL_MSG_SZ, HZ * 3);
+			      data, USB_CTRL_MSG_SZ, 3000);
 	dev_dbg(dev, "set address - ret = %d", ret);
 	dev_dbg(dev, "set address - data[0] = %d, data[1] = %d",
 						data[0], data[1]);
@@ -1437,20 +1437,20 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
 	/* set feature: bit rate 38400 bps */
 	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
 			      USB_REQ_SET_FEATURE, USB_TYPE_VENDOR,
-			      0xc04e, 0x0000, NULL, 0, HZ * 3);
+			      0xc04e, 0x0000, NULL, 0, 3000);
 
 	dev_dbg(dev, "set feature - ret = %d", ret);
 
 	/* bRequest 4: set char length to 8 bits */
 	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
 			      4, USB_TYPE_VENDOR,
-			      0x0808, 0x0000, NULL, 0, HZ * 3);
+			      0x0808, 0x0000, NULL, 0, 3000);
 	dev_dbg(dev, "set char length - retB = %d", ret);
 
 	/* bRequest 2: set handshaking to use DTR/DSR */
 	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
 			      2, USB_TYPE_VENDOR,
-			      0x0000, 0x0100, NULL, 0, HZ * 3);
+			      0x0000, 0x0100, NULL, 0, 3000);
 	dev_dbg(dev, "set handshake  - retC = %d", ret);
 
 	/* device resume */
-- 
2.32.0

