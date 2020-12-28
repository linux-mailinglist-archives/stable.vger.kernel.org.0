Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061432E3BDC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405275AbgL1Nzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:55:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:57338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405291AbgL1Nzk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:55:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8738D20731;
        Mon, 28 Dec 2020 13:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163700;
        bh=ZVH6mPmmfFa3nYou8QGvUJ84cqwMDtba7EMR8XuKack=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HSmaXsRuVX3piHxnFn02XnBYp3a9gCCCgH/nlXrW8Vgoye/PwHNISAy/HJSUm++XQ
         ejCJv0AQLPdIKFHPxOiUzcYAaB5Y5X+4cNznNMFxDYUQrJ2yR+n2Nmtr3VI/U+baId
         JDcNcWVV6X6bFEMDADef5qFAfzG6ZuXVZWOvENdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 370/453] USB: serial: keyspan_pda: fix tx-unthrottle use-after-free
Date:   Mon, 28 Dec 2020 13:50:06 +0100
Message-Id: <20201228124955.016539993@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 49fbb8e37a961396a5b6c82937c70df91de45e9d upstream.

The driver's transmit-unthrottle work was never flushed on disconnect,
something which could lead to the driver port data being freed while the
unthrottle work is still scheduled.

Fix this by cancelling the unthrottle work when shutting down the port.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/keyspan_pda.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -647,8 +647,12 @@ error:
 }
 static void keyspan_pda_close(struct usb_serial_port *port)
 {
+	struct keyspan_pda_private *priv = usb_get_serial_port_data(port);
+
 	usb_kill_urb(port->write_urb);
 	usb_kill_urb(port->interrupt_in_urb);
+
+	cancel_work_sync(&priv->unthrottle_work);
 }
 
 


