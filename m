Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 863B6DCEC0
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 20:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436551AbfJRSyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 14:54:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbfJRSyQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 14:54:16 -0400
Received: from localhost (unknown [38.98.37.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5FA920640;
        Fri, 18 Oct 2019 18:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571424856;
        bh=MmHzR/qqTCqYdJBZROIwR3QfICG+jnyKouwESr1R/yI=;
        h=Subject:To:From:Date:From;
        b=BZWb5TI7wdeiyKsS5SzQlx8mYIWCHeRq9Qga52KZrLf1qnL3DO84TavZpFfE0Gx5o
         81Gc+A5XhIjmCC1v6yvQz7f9y+SPnCsbGv7jjgyqWmbOHRlt9HNAXEdkodFiL9ZCpo
         i6HoS+gnwWMENbYAA0NT2H2rHfOBMVFvZnWZ7uHo=
Subject: patch "USB: serial: ti_usb_3410_5052: fix port-close races" added to usb-linus
To:     johan@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Oct 2019 11:53:58 -0700
Message-ID: <1571424838185183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: ti_usb_3410_5052: fix port-close races

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 6f1d1dc8d540a9aa6e39b9cb86d3a67bbc1c8d8d Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Fri, 11 Oct 2019 11:57:35 +0200
Subject: USB: serial: ti_usb_3410_5052: fix port-close races

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


