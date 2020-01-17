Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 490AB141101
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 19:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgAQSnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 13:43:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:35700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726897AbgAQSnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 13:43:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EF872082F;
        Fri, 17 Jan 2020 18:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579286622;
        bh=Dxi/D+Yzl4h9zID/qVqiGrTOiUzbJlVqfpgpmlYpuBI=;
        h=Subject:To:From:Date:From;
        b=Glni6kRzfr6M/q+paKTmEnZw4V3QqvdsfwYAQVBxszsY9Uzzcxlk1jWX/iEKvqZU0
         Qubwp/ty2UF9BNFlWVg2cTEe+lB1kQqusJl+f5BF3MypU135TWuS/g3hJ92hEVqS06
         NPPDObSWw0e2phTXSEcLk6NdM1vDqIR8sEa1U9rc=
Subject: patch "USB: serial: opticon: fix control-message timeouts" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        martin.jansen@opticon.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 Jan 2020 19:43:38 +0100
Message-ID: <15792866183130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: opticon: fix control-message timeouts

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5e28055f340275a8616eee88ef19186631b4d136 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Mon, 13 Jan 2020 18:22:13 +0100
Subject: USB: serial: opticon: fix control-message timeouts

The driver was issuing synchronous uninterruptible control requests
without using a timeout. This could lead to the driver hanging
on open() or tiocmset() due to a malfunctioning (or malicious) device
until the device is physically disconnected.

The USB upper limit of five seconds per request should be more than
enough.

Fixes: 309a057932ab ("USB: opticon: add rts and cts support")
Cc: stable <stable@vger.kernel.org>     # 2.6.39
Cc: Martin Jansen <martin.jansen@opticon.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/opticon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index cb7aac9cd9e7..ed2b4e6dca38 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -113,7 +113,7 @@ static int send_control_msg(struct usb_serial_port *port, u8 requesttype,
 	retval = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
 				requesttype,
 				USB_DIR_OUT|USB_TYPE_VENDOR|USB_RECIP_INTERFACE,
-				0, 0, buffer, 1, 0);
+				0, 0, buffer, 1, USB_CTRL_SET_TIMEOUT);
 	kfree(buffer);
 
 	if (retval < 0)
-- 
2.25.0


