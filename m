Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F40DC9FD5
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 15:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbfJCNuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 09:50:22 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39714 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbfJCNuW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 09:50:22 -0400
Received: by mail-lf1-f65.google.com with SMTP id 72so1903393lfh.6;
        Thu, 03 Oct 2019 06:50:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xOQUGD5j0sSP/q6R07ewuqh26B4gRZQR5+vNl+UIpvk=;
        b=dEmndmQDFomjWP5da9f37BnG4gdaZsO4QwsqpugKYzEximGc8XLTZJFug66zhucIw6
         9cm0UX+o/CpJOkr0YgTAPU3gV++APYw0jfs88F5dUhHnNsLe9O2ylyX0TBCLmtRf7l12
         tXw/KYcaTurae0rTL7HvvitxHycjSTvPPxji8AdJklc0Ne05XXWHWaUNT6AqAxzqKFXM
         7WZYux+TT/p2tdFfj8y3EBU/AbApGMXVTrq+koxhODhkk9v0mUuZgyDZQCQKNVTQmfBY
         fVGKYgo8gdUyVOhsch+Odi/97yqFmbQckUrwjMHl0q5dyCZwIqNt0LYTYybw/5ZCI6UI
         mf9A==
X-Gm-Message-State: APjAAAVtIDSJxlEK5tx77dhWgUD9jaHj8QrrDlApCgF/xMFkNEmsm6vp
        XdkJLH6eBd7tLAcO/eAdK/wS+i/N
X-Google-Smtp-Source: APXvYqya10ErmzjwDGsx3D3Tu1cJU1NuQMw6RM1hfbg2sofbrKHDGmM33e+6KgbV3AdR4eis6SEuZw==
X-Received: by 2002:ac2:5966:: with SMTP id h6mr6105091lfp.78.1570110619866;
        Thu, 03 Oct 2019 06:50:19 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id 81sm558409lje.70.2019.10.03.06.50.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 06:50:18 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iG1Uz-0002H1-HJ; Thu, 03 Oct 2019 15:50:29 +0200
From:   Johan Hovold <johan@kernel.org>
To:     linux-usb@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rainer Weikusat <rainer.weikusat@sncag.com>,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] USB: serial: keyspan: fix NULL-derefs on open() and write()
Date:   Thu,  3 Oct 2019 15:49:58 +0200
Message-Id: <20191003134958.8692-1-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/keyspan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index d34779fe4a8d..e66a59ef43a1 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1741,8 +1741,8 @@ static struct urb *keyspan_setup_urb(struct usb_serial *serial, int endpoint,
 
 	ep_desc = find_ep(serial, endpoint);
 	if (!ep_desc) {
-		/* leak the urb, something's wrong and the callers don't care */
-		return urb;
+		usb_free_urb(urb);
+		return NULL;
 	}
 	if (usb_endpoint_xfer_int(ep_desc)) {
 		ep_type_name = "INT";
-- 
2.23.0

