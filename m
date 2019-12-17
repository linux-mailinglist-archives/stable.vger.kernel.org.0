Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8425C1220C1
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfLQA5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:57:43 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34936 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726802AbfLQAvk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:40 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15I-0003LY-GG; Tue, 17 Dec 2019 00:51:32 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15H-0005VS-Ax; Tue, 17 Dec 2019 00:51:31 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <johan@kernel.org>
Date:   Tue, 17 Dec 2019 00:46:26 +0000
Message-ID: <lsq.1576543535.323777449@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 052/136] USB: usb-skeleton: fix NULL-deref on disconnect
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

commit bed5ef230943863b9abf5eae226a20fad9a8ff71 upstream.

The driver was using its struct usb_interface pointer as an inverted
disconnected flag and was setting it to NULL before making sure all
completion handlers had run. This could lead to NULL-pointer
dereferences in the dev_err() statements in the completion handlers
which relies on said pointer.

Fix this by using a dedicated disconnected flag.

Note that this is also addresses a NULL-pointer dereference at release()
and a struct usb_interface reference leak introduced by a recent runtime
PM fix, which depends on and should have been submitted together with
this patch.

Fixes: 4212cd74ca6f ("USB: usb-skeleton.c: remove err() usage")
Fixes: 5c290a5e42c3 ("USB: usb-skeleton: fix runtime PM after driver unbind")
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191009170944.30057-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/usb-skeleton.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -63,6 +63,7 @@ struct usb_skel {
 	spinlock_t		err_lock;		/* lock for errors */
 	struct kref		kref;
 	struct mutex		io_mutex;		/* synchronize I/O with disconnect */
+	unsigned long		disconnected:1;
 	wait_queue_head_t	bulk_in_wait;		/* to wait for an ongoing read */
 };
 #define to_skel_dev(d) container_of(d, struct usb_skel, kref)
@@ -239,7 +240,7 @@ static ssize_t skel_read(struct file *fi
 	if (rv < 0)
 		return rv;
 
-	if (!dev->interface) {		/* disconnect() was called */
+	if (dev->disconnected) {		/* disconnect() was called */
 		rv = -ENODEV;
 		goto exit;
 	}
@@ -420,7 +421,7 @@ static ssize_t skel_write(struct file *f
 
 	/* this lock makes sure we don't submit URBs to gone devices */
 	mutex_lock(&dev->io_mutex);
-	if (!dev->interface) {		/* disconnect() was called */
+	if (dev->disconnected) {		/* disconnect() was called */
 		mutex_unlock(&dev->io_mutex);
 		retval = -ENODEV;
 		goto error;
@@ -588,7 +589,7 @@ static void skel_disconnect(struct usb_i
 
 	/* prevent more I/O from starting */
 	mutex_lock(&dev->io_mutex);
-	dev->interface = NULL;
+	dev->disconnected = 1;
 	mutex_unlock(&dev->io_mutex);
 
 	usb_kill_anchored_urbs(&dev->submitted);

