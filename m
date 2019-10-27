Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E99CAE6614
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbfJ0VIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:08:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728276AbfJ0VIO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:08:14 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74475208C0;
        Sun, 27 Oct 2019 21:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210494;
        bh=R75jvK/rAUJFvG4NdWNYu+VzJ33Hjcib2wLKMgrtC/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gcV3FyTWkyYcL6XJmIyhIxCpKQIUMA+CmKnDj44LfzRY9ikDl8lZyD6HmuvrB5rWw
         j7yoEiKjz4OAz/PFB/67y26d4cVY2SvjGwu3zzimF3XwaAP+yTNUNm1CfOYoDFLyp5
         /Uc4QZyGU/oEjG7sZlZSYKoDD4fB9MXOvrMGYej4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 033/119] USB: serial: ti_usb_3410_5052: fix port-close races
Date:   Sun, 27 Oct 2019 22:00:10 +0100
Message-Id: <20191027203310.533510467@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 6f1d1dc8d540a9aa6e39b9cb86d3a67bbc1c8d8d upstream.

Fix races between closing a port and opening or closing another port on
the same device which could lead to a failure to start or stop the
shared interrupt URB. The latter could potentially cause a
use-after-free or worse in the completion handler on driver unbind.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ti_usb_3410_5052.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -780,7 +780,6 @@ static void ti_close(struct usb_serial_p
 	struct ti_port *tport;
 	int port_number;
 	int status;
-	int do_unlock;
 	unsigned long flags;
 
 	tdev = usb_get_serial_data(port->serial);
@@ -804,16 +803,13 @@ static void ti_close(struct usb_serial_p
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
 
 


