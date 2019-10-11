Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8220D3CE4
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 11:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbfJKJ5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 05:57:37 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:32800 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727314AbfJKJ5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 05:57:37 -0400
Received: by mail-lj1-f193.google.com with SMTP id a22so9238770ljd.0;
        Fri, 11 Oct 2019 02:57:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dH0s3WOPr05pqAHfLs+B1HY8TrR6zssGtSYDR0ZvkL0=;
        b=gCiljLRnbrWCrLQebDE8g1w1pIjZFfLf93TIo6XBDSUcmBcLysOQuQSEtPXW1gGOkQ
         MdQiWgsBxPdMm+9eceQ4/fvU/C5CWT5qD9aE+TuZ8YEbzzlc/G9Dt9YFXnPFCUYNlHb7
         wkpgqa+WtS7f/xVCCcfRGkbf60JEk9r/ebA+kCvuG02t9l67h+jTJY6tgLdMeOjuerx6
         /tUBsp0FBSdxzsM9BZe/lSCf1eKQNbCN3H7LSVmeoSTPmW4aTviMgxhRXTR9lJe7WTUg
         Fz3bsmj4LXnr2tQWX/TO9QSy/LuEoYMja2/QkWbjoUzmj8aFiw1BFXPhWgysiwy4WYCi
         6NvQ==
X-Gm-Message-State: APjAAAWwnEhZPPFlJLbqUKPFmA4jmv6SDWAycQLXTGSnri/XUM2ckrmH
        ZzzeQPBlW3RXQVkxQNRil5HQSaPw
X-Google-Smtp-Source: APXvYqwa6hs09EiixUNhumSPAMCltdoyS47Wf0Dp+SR+kJixHm5WjHO+wNImZ8ovThi8kQRU8wByBg==
X-Received: by 2002:a2e:658f:: with SMTP id e15mr8914409ljf.254.1570787854372;
        Fri, 11 Oct 2019 02:57:34 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id z14sm1867142lfh.30.2019.10.11.02.57.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 02:57:33 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iIrg7-0005iW-B2; Fri, 11 Oct 2019 11:57:44 +0200
From:   Johan Hovold <johan@kernel.org>
To:     linux-usb@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/2] USB: serial: ti_usb_3410_5052: fix port-close races
Date:   Fri, 11 Oct 2019 11:57:35 +0200
Message-Id: <20191011095736.21934-1-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix races between closing a port and opening or closing another port on
the same device which could lead to a failure to start or stop the
shared interrupt URB. The latter could potentially cause a
use-after-free or worse in the completion handler on driver unbind.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/ti_usb_3410_5052.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index dd0ad67aa71e..9174ba2e06da 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -776,7 +776,6 @@ static void ti_close(struct usb_serial_port *port)
 	struct ti_port *tport;
 	int port_number;
 	int status;
-	int do_unlock;
 	unsigned long flags;
 
 	tdev = usb_get_serial_data(port->serial);
@@ -800,16 +799,13 @@ static void ti_close(struct usb_serial_port *port)
 			"%s - cannot send close port command, %d\n"
 							, __func__, status);
 
-	/* if mutex_lock is interrupted, continue anyway */
-	do_unlock = !mutex_lock_interruptible(&tdev->td_open_close_lock);
+	mutex_lock(&tdev->td_open_close_lock);
 	--tport->tp_tdev->td_open_port_count;
-	if (tport->tp_tdev->td_open_port_count <= 0) {
+	if (tport->tp_tdev->td_open_port_count == 0) {
 		/* last port is closed, shut down interrupt urb */
 		usb_kill_urb(port->serial->port[0]->interrupt_in_urb);
-		tport->tp_tdev->td_open_port_count = 0;
 	}
-	if (do_unlock)
-		mutex_unlock(&tdev->td_open_close_lock);
+	mutex_unlock(&tdev->td_open_close_lock);
 }
 
 
-- 
2.23.0

