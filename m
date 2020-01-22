Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD55F144FB1
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733178AbgAVJkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:40:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:59006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733182AbgAVJkR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:40:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3842624689;
        Wed, 22 Jan 2020 09:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686016;
        bh=uG2XbXMoGZzx8H4q1N55KBac6z4u0PS3eMFKnphQBH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g+8tza/nNiPq5bhNYa59QELKpDmWpXBJGjbGDfNcho/MMfT4XdnddUOTHivuwvoRv
         6P8OCe8lGtjqnXLHim2cMEr7uh7qJPjMFD4C3k/QDWT/jqqovRKs0NekxFPS2k75WO
         ZWTFjrECWdRnp4zsjSAvwwjVk16M+pfB+Ttej544=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Jansen <martin.jansen@opticon.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 010/103] USB: serial: opticon: fix control-message timeouts
Date:   Wed, 22 Jan 2020 10:28:26 +0100
Message-Id: <20200122092805.192201547@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 5e28055f340275a8616eee88ef19186631b4d136 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/opticon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -113,7 +113,7 @@ static int send_control_msg(struct usb_s
 	retval = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
 				requesttype,
 				USB_DIR_OUT|USB_TYPE_VENDOR|USB_RECIP_INTERFACE,
-				0, 0, buffer, 1, 0);
+				0, 0, buffer, 1, USB_CTRL_SET_TIMEOUT);
 	kfree(buffer);
 
 	if (retval < 0)


