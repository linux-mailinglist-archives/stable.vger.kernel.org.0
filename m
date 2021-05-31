Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DC73960B8
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbhEaObD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:31:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:54450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232757AbhEaO1U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:27:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61A7B61C1D;
        Mon, 31 May 2021 13:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468840;
        bh=Djkmej6t9239FeJByM1Gz+iloEPMHMs4iUz1dVvLAkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nAGzp9q+udLzvT+Cv6Rc6dwBXP94J+jKeQZNJAgsUQXq1vVfZ+OPIzC6kuVALkx/t
         7zas/fG6tRvyYNedCGdJIW36BPc7yWiLtYwwKSiuVkuQxJqm957OphuDWOR3YGKqto
         /b3bHxLNlqykUtOH7D4k6+fIikbFPd/nQkVxkCbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 148/177] net: hso: check for allocation failure in hso_create_bulk_serial_device()
Date:   Mon, 31 May 2021 15:15:05 +0200
Message-Id: <20210531130653.042459928@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 31db0dbd72444abe645d90c20ecb84d668f5af5e ]

In current kernels, small allocations never actually fail so this
patch shouldn't affect runtime.

Originally this error handling code written with the idea that if
the "serial->tiocmget" allocation failed, then we would continue
operating instead of bailing out early.  But in later years we added
an unchecked dereference on the next line.

	serial->tiocmget->serial_state_notification = kzalloc();
        ^^^^^^^^^^^^^^^^^^

Since these allocations are never going fail in real life, this is
mostly a philosophical debate, but I think bailing out early is the
correct behavior that the user would want.  And generally it's safer to
bail as soon an error happens.

Fixes: af0de1303c4e ("usb: hso: obey DMA rules in tiocmget")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/hso.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 8c2c6d7921f4..0436e1661096 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2619,29 +2619,28 @@ static struct hso_device *hso_create_bulk_serial_device(
 		num_urbs = 2;
 		serial->tiocmget = kzalloc(sizeof(struct hso_tiocmget),
 					   GFP_KERNEL);
+		if (!serial->tiocmget)
+			goto exit;
 		serial->tiocmget->serial_state_notification
 			= kzalloc(sizeof(struct hso_serial_state_notification),
 					   GFP_KERNEL);
-		/* it isn't going to break our heart if serial->tiocmget
-		 *  allocation fails don't bother checking this.
-		 */
-		if (serial->tiocmget && serial->tiocmget->serial_state_notification) {
-			tiocmget = serial->tiocmget;
-			tiocmget->endp = hso_get_ep(interface,
-						    USB_ENDPOINT_XFER_INT,
-						    USB_DIR_IN);
-			if (!tiocmget->endp) {
-				dev_err(&interface->dev, "Failed to find INT IN ep\n");
-				goto exit;
-			}
-
-			tiocmget->urb = usb_alloc_urb(0, GFP_KERNEL);
-			if (tiocmget->urb) {
-				mutex_init(&tiocmget->mutex);
-				init_waitqueue_head(&tiocmget->waitq);
-			} else
-				hso_free_tiomget(serial);
+		if (!serial->tiocmget->serial_state_notification)
+			goto exit;
+		tiocmget = serial->tiocmget;
+		tiocmget->endp = hso_get_ep(interface,
+					    USB_ENDPOINT_XFER_INT,
+					    USB_DIR_IN);
+		if (!tiocmget->endp) {
+			dev_err(&interface->dev, "Failed to find INT IN ep\n");
+			goto exit;
 		}
+
+		tiocmget->urb = usb_alloc_urb(0, GFP_KERNEL);
+		if (tiocmget->urb) {
+			mutex_init(&tiocmget->mutex);
+			init_waitqueue_head(&tiocmget->waitq);
+		} else
+			hso_free_tiomget(serial);
 	}
 	else
 		num_urbs = 1;
-- 
2.30.2



