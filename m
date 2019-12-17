Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7E2D1220B7
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfLQA5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:57:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34958 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726852AbfLQAvk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:40 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15I-0003Lc-QA; Tue, 17 Dec 2019 00:51:32 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15H-0005Vh-E6; Tue, 17 Dec 2019 00:51:31 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Johan Hovold" <johan@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Tue, 17 Dec 2019 00:46:29 +0000
Message-ID: <lsq.1576543535.197919099@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 055/136] USB: adutux: fix use-after-free on release
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 123a0f125fa3d2104043697baa62899d9e549272 upstream.

The driver was accessing its struct usb_device in its release()
callback without holding a reference. This would lead to a
use-after-free whenever the device was disconnected while the character
device was still open.

Fixes: 66d4bc30d128 ("USB: adutux: remove custom debug macro")
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191009153848.8664-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/misc/adutux.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -152,6 +152,7 @@ static void adu_delete(struct adu_device
 	kfree(dev->read_buffer_secondary);
 	kfree(dev->interrupt_in_buffer);
 	kfree(dev->interrupt_out_buffer);
+	usb_put_dev(dev->udev);
 	kfree(dev);
 }
 
@@ -677,7 +678,7 @@ static int adu_probe(struct usb_interfac
 
 	mutex_init(&dev->mtx);
 	spin_lock_init(&dev->buflock);
-	dev->udev = udev;
+	dev->udev = usb_get_dev(udev);
 	init_waitqueue_head(&dev->read_wait);
 	init_waitqueue_head(&dev->write_wait);
 

