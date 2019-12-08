Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C46AA1161E1
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbfLHNzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:55:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60502 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726903AbfLHNyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:46 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1H-0007iu-HN; Sun, 08 Dec 2019 13:54:43 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1G-0002QJ-7I; Sun, 08 Dec 2019 13:54:42 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        syzbot+863724e7128e14b26732@syzkaller.appspotmail.com,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "Johan Hovold" <johan@kernel.org>
Date:   Sun, 08 Dec 2019 13:53:56 +0000
Message-ID: <lsq.1575813165.369617906@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 72/72] can: peak_usb: fix slab info leak
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit f7a1337f0d29b98733c8824e165fca3371d7d4fd upstream.

Fix a small slab info leak due to a failure to clear the command buffer
at allocation.

The first 16 bytes of the command buffer are always sent to the device
in pcan_usb_send_cmd() even though only the first two may have been
initialised in case no argument payload is provided (e.g. when waiting
for a response).

Fixes: bb4785551f64 ("can: usb: PEAK-System Technik USB adapters driver core")
Reported-by: syzbot+863724e7128e14b26732@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -732,7 +732,7 @@ static int peak_usb_create_dev(struct pe
 	dev = netdev_priv(netdev);
 
 	/* allocate a buffer large enough to send commands */
-	dev->cmd_buf = kmalloc(PCAN_USB_MAX_CMD_LEN, GFP_KERNEL);
+	dev->cmd_buf = kzalloc(PCAN_USB_MAX_CMD_LEN, GFP_KERNEL);
 	if (!dev->cmd_buf) {
 		err = -ENOMEM;
 		goto lbl_free_candev;

