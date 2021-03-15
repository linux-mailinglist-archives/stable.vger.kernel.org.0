Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C1833B9EF
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235077AbhCOOHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:07:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233666AbhCOOCR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:02:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2976364F16;
        Mon, 15 Mar 2021 14:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816928;
        bh=dsjSFKzKR3YF5jmpTtzlvZTNpdzIkImLzudkGKV3LFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dNLGzex10qIf7Ujrc2HNLnbYQueX9I5lzgx5wmkopr7XjLm592UhuhZ/mdXvohyFR
         43GnokNpF90d3rr4T6UjkaUZRsMjQuLNhYYn61PHz5TExOdqfPFnrwDW6LBkbUXoXE
         rp8TZpiD/KibNWTUldNO/+DN23Z0WDHJ1N7DPAKk=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+59f777bdcbdd7eea5305@syzkaller.appspotmail.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.11 208/306] USB: serial: io_edgeport: fix memory leak in edge_startup
Date:   Mon, 15 Mar 2021 14:54:31 +0100
Message-Id: <20210315135514.660111757@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Pavel Skripkin <paskripkin@gmail.com>

commit cfdc67acc785e01a8719eeb7012709d245564701 upstream.

sysbot found memory leak in edge_startup().
The problem was that when an error was received from the usb_submit_urb(),
nothing was cleaned up.

Reported-by: syzbot+59f777bdcbdd7eea5305@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Fixes: 6e8cf7751f9f ("USB: add EPIC support to the io_edgeport driver")
Cc: stable@vger.kernel.org	# 2.6.21: c5c0c55598ce
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/io_edgeport.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -3003,26 +3003,32 @@ static int edge_startup(struct usb_seria
 				response = -ENODEV;
 			}
 
-			usb_free_urb(edge_serial->interrupt_read_urb);
-			kfree(edge_serial->interrupt_in_buffer);
-
-			usb_free_urb(edge_serial->read_urb);
-			kfree(edge_serial->bulk_in_buffer);
-
-			kfree(edge_serial);
-
-			return response;
+			goto error;
 		}
 
 		/* start interrupt read for this edgeport this interrupt will
 		 * continue as long as the edgeport is connected */
 		response = usb_submit_urb(edge_serial->interrupt_read_urb,
 								GFP_KERNEL);
-		if (response)
+		if (response) {
 			dev_err(ddev, "%s - Error %d submitting control urb\n",
 				__func__, response);
+
+			goto error;
+		}
 	}
 	return response;
+
+error:
+	usb_free_urb(edge_serial->interrupt_read_urb);
+	kfree(edge_serial->interrupt_in_buffer);
+
+	usb_free_urb(edge_serial->read_urb);
+	kfree(edge_serial->bulk_in_buffer);
+
+	kfree(edge_serial);
+
+	return response;
 }
 
 


