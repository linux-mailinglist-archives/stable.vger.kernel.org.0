Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4C17F7C11
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbfKKSmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:42:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:33970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727520AbfKKSmo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:42:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C6D721655;
        Mon, 11 Nov 2019 18:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497763;
        bh=e5fGjKC5doeQl5lfiI/9I0APVgbO57C6bfP4IPd3Mrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aTYw4TCRcgKKE5JjUJd1id7AtzFWOYhN/UWBeoIGbcsFiGWPNynZtmc8LJLTmPLhv
         PtJQH5TjhN98yWApG5t/KBohkNEekYgwVvWNWp3GYWHDm0GPB8uxcx28wqsApm+b4b
         E+LjfTqMjhm4W3jDyfMeavFE7y/gCL43nwwN+0N0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+863724e7128e14b26732@syzkaller.appspotmail.com,
        Johan Hovold <johan@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.19 051/125] can: peak_usb: fix slab info leak
Date:   Mon, 11 Nov 2019 19:28:10 +0100
Message-Id: <20191111181447.158385769@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit f7a1337f0d29b98733c8824e165fca3371d7d4fd upstream.

Fix a small slab info leak due to a failure to clear the command buffer
at allocation.

The first 16 bytes of the command buffer are always sent to the device
in pcan_usb_send_cmd() even though only the first two may have been
initialised in case no argument payload is provided (e.g. when waiting
for a response).

Fixes: bb4785551f64 ("can: usb: PEAK-System Technik USB adapters driver core")
Cc: stable <stable@vger.kernel.org>     # 3.4
Reported-by: syzbot+863724e7128e14b26732@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -758,7 +758,7 @@ static int peak_usb_create_dev(const str
 	dev = netdev_priv(netdev);
 
 	/* allocate a buffer large enough to send commands */
-	dev->cmd_buf = kmalloc(PCAN_USB_MAX_CMD_LEN, GFP_KERNEL);
+	dev->cmd_buf = kzalloc(PCAN_USB_MAX_CMD_LEN, GFP_KERNEL);
 	if (!dev->cmd_buf) {
 		err = -ENOMEM;
 		goto lbl_free_candev;


