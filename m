Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7BED2761
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 12:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfJJKlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 06:41:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726869AbfJJKle (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 06:41:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47DC320B7C;
        Thu, 10 Oct 2019 10:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570704093;
        bh=FbcBicpYAwMlbdqwYI6mNySxT4HO2vznlIQYL0wLTx4=;
        h=Subject:To:From:Date:From;
        b=HoG2sOh+P0xsofRcNNejfuiC+k7D1b4RL2QwcR7rWvIuM6s0oiAIx+4vqqqGCVi/J
         93bMnbDrxxyNGBQvq95/6ZJQkPrDIW2nmj9qtzjfu5WpO/ARPl2YYGLu23kzIYzOCx
         dv+SWHrbYJ3+1R8BYAejOYzWH4iTlnGl7Xk43iEk=
Subject: patch "USB: usb-skeleton: fix NULL-deref on disconnect" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 10 Oct 2019 12:41:31 +0200
Message-ID: <157070409171113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: usb-skeleton: fix NULL-deref on disconnect

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From bed5ef230943863b9abf5eae226a20fad9a8ff71 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 9 Oct 2019 19:09:42 +0200
Subject: USB: usb-skeleton: fix NULL-deref on disconnect

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
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191009170944.30057-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usb-skeleton.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index 8001d6384c73..c2843fcfa52d 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -61,6 +61,7 @@ struct usb_skel {
 	spinlock_t		err_lock;		/* lock for errors */
 	struct kref		kref;
 	struct mutex		io_mutex;		/* synchronize I/O with disconnect */
+	unsigned long		disconnected:1;
 	wait_queue_head_t	bulk_in_wait;		/* to wait for an ongoing read */
 };
 #define to_skel_dev(d) container_of(d, struct usb_skel, kref)
@@ -238,7 +239,7 @@ static ssize_t skel_read(struct file *file, char *buffer, size_t count,
 	if (rv < 0)
 		return rv;
 
-	if (!dev->interface) {		/* disconnect() was called */
+	if (dev->disconnected) {		/* disconnect() was called */
 		rv = -ENODEV;
 		goto exit;
 	}
@@ -420,7 +421,7 @@ static ssize_t skel_write(struct file *file, const char *user_buffer,
 
 	/* this lock makes sure we don't submit URBs to gone devices */
 	mutex_lock(&dev->io_mutex);
-	if (!dev->interface) {		/* disconnect() was called */
+	if (dev->disconnected) {		/* disconnect() was called */
 		mutex_unlock(&dev->io_mutex);
 		retval = -ENODEV;
 		goto error;
@@ -571,7 +572,7 @@ static void skel_disconnect(struct usb_interface *interface)
 
 	/* prevent more I/O from starting */
 	mutex_lock(&dev->io_mutex);
-	dev->interface = NULL;
+	dev->disconnected = 1;
 	mutex_unlock(&dev->io_mutex);
 
 	usb_kill_anchored_urbs(&dev->submitted);
-- 
2.23.0


