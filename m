Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6AB1DA066
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389013AbfJPWLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:11:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395445AbfJPV5F (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:57:05 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35B4921928;
        Wed, 16 Oct 2019 21:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263024;
        bh=LY9IoeQ4KDR5F+hVavxrD1Vb2SUzTkDoVSL59UYUWi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MBMC0dNUTCYoUMfbbWCAmITBcx05HU3DibtoJ1pQ3Se1ymXbtwJ3Jyt+JPWNBukjX
         DNYntigERwqRzMwCmfzawopBuessG3FrSK7k1J6lbvid+vc1wrM/H5upGR0tYWvclD
         zr4YeM0V/gbuV+mby/8viepfNQbVIDEHG0bV9f/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 25/81] USB: serial: keyspan: fix NULL-derefs on open() and write()
Date:   Wed, 16 Oct 2019 14:50:36 -0700
Message-Id: <20191016214827.671778494@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 7d7e21fafdbc7fcf0854b877bd0975b487ed2717 upstream.

Fix NULL-pointer dereferences on open() and write() which can be
triggered by a malicious USB device.

The current URB allocation helper would fail to initialise the newly
allocated URB if the device has unexpected endpoint descriptors,
something which could lead NULL-pointer dereferences in a number of
open() and write() paths when accessing the URB. For example:

	BUG: kernel NULL pointer dereference, address: 0000000000000000
	...
	RIP: 0010:usb_clear_halt+0x11/0xc0
	...
	Call Trace:
	 ? tty_port_open+0x4d/0xd0
	 keyspan_open+0x70/0x160 [keyspan]
	 serial_port_activate+0x5b/0x80 [usbserial]
	 tty_port_open+0x7b/0xd0
	 ? check_tty_count+0x43/0xa0
	 tty_open+0xf1/0x490

	BUG: kernel NULL pointer dereference, address: 0000000000000000
	...
	RIP: 0010:keyspan_write+0x14e/0x1f3 [keyspan]
	...
	Call Trace:
	 serial_write+0x43/0xa0 [usbserial]
	 n_tty_write+0x1af/0x4f0
	 ? do_wait_intr_irq+0x80/0x80
	 ? process_echoes+0x60/0x60
	 tty_write+0x13f/0x2f0

	BUG: kernel NULL pointer dereference, address: 0000000000000000
	...
	RIP: 0010:keyspan_usa26_send_setup+0x298/0x305 [keyspan]
	...
	Call Trace:
	 keyspan_open+0x10f/0x160 [keyspan]
	 serial_port_activate+0x5b/0x80 [usbserial]
	 tty_port_open+0x7b/0xd0
	 ? check_tty_count+0x43/0xa0
	 tty_open+0xf1/0x490

Fixes: fdcba53e2d58 ("fix for bugzilla #7544 (keyspan USB-to-serial converter)")
Cc: stable <stable@vger.kernel.org>	# 2.6.21
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/keyspan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1741,8 +1741,8 @@ static struct urb *keyspan_setup_urb(str
 
 	ep_desc = find_ep(serial, endpoint);
 	if (!ep_desc) {
-		/* leak the urb, something's wrong and the callers don't care */
-		return urb;
+		usb_free_urb(urb);
+		return NULL;
 	}
 	if (usb_endpoint_xfer_int(ep_desc)) {
 		ep_type_name = "INT";


