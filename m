Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49D8912206A
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbfLQAyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:54:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35420 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727114AbfLQAvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15L-0003Mv-Dk; Tue, 17 Dec 2019 00:51:35 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15J-0005at-DG; Tue, 17 Dec 2019 00:51:33 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <johan@kernel.org>
Date:   Tue, 17 Dec 2019 00:47:12 +0000
Message-ID: <lsq.1576543535.643931912@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 098/136] USB: ldusb: fix ring-buffer locking
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

commit d98ee2a19c3334e9343df3ce254b496f1fc428eb upstream.

The custom ring-buffer implementation was merged without any locking or
explicit memory barriers, but a spinlock was later added by commit
9d33efd9a791 ("USB: ldusb bugfix").

The lock did not cover the update of the tail index once the entry had
been processed, something which could lead to memory corruption on
weakly ordered architectures or due to compiler optimisations.

Specifically, a completion handler running on another CPU might observe
the incremented tail index and update the entry before ld_usb_read() is
done with it.

Fixes: 2824bd250f0b ("[PATCH] USB: add ldusb driver")
Fixes: 9d33efd9a791 ("USB: ldusb bugfix")
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191022143203.5260-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/misc/ldusb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/misc/ldusb.c
+++ b/drivers/usb/misc/ldusb.c
@@ -509,11 +509,11 @@ static ssize_t ld_usb_read(struct file *
 		retval = -EFAULT;
 		goto unlock_exit;
 	}
-	dev->ring_tail = (dev->ring_tail+1) % ring_buffer_size;
-
 	retval = bytes_to_read;
 
 	spin_lock_irq(&dev->rbsl);
+	dev->ring_tail = (dev->ring_tail + 1) % ring_buffer_size;
+
 	if (dev->buffer_overflow) {
 		dev->buffer_overflow = 0;
 		spin_unlock_irq(&dev->rbsl);

