Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB83D9FFF
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407007AbfJPWGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438143AbfJPV6X (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:58:23 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86F8920872;
        Wed, 16 Oct 2019 21:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263102;
        bh=ONS2EygcQU152NOuMAZMhNEtFoUo4KLiKujogzhpwkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OGsKmEtTHI6/7yobLzpUo5XPhGb9lFjUwTyPfDYuhoFM80QYVo+VwaAD1DA98ckuw
         iW8g7RJtHESJ+fAxN775L59SRdlCrRcAy+yoAtiwra1Wlxqp9bWv8ZTExlKzxdqFRD
         /La7iI81he6mvnuecWpPLxfvP88l4QCzQBgjobuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.3 006/112] USB: usb-skeleton: fix NULL-deref on disconnect
Date:   Wed, 16 Oct 2019 14:49:58 -0700
Message-Id: <20191016214845.594625051@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191009170944.30057-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/usb-skeleton.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -59,6 +59,7 @@ struct usb_skel {
 	spinlock_t		err_lock;		/* lock for errors */
 	struct kref		kref;
 	struct mutex		io_mutex;		/* synchronize I/O with disconnect */
+	unsigned long		disconnected:1;
 	wait_queue_head_t	bulk_in_wait;		/* to wait for an ongoing read */
 };
 #define to_skel_dev(d) container_of(d, struct usb_skel, kref)
@@ -236,7 +237,7 @@ static ssize_t skel_read(struct file *fi
 	if (rv < 0)
 		return rv;
 
-	if (!dev->interface) {		/* disconnect() was called */
+	if (dev->disconnected) {		/* disconnect() was called */
 		rv = -ENODEV;
 		goto exit;
 	}
@@ -418,7 +419,7 @@ static ssize_t skel_write(struct file *f
 
 	/* this lock makes sure we don't submit URBs to gone devices */
 	mutex_lock(&dev->io_mutex);
-	if (!dev->interface) {		/* disconnect() was called */
+	if (dev->disconnected) {		/* disconnect() was called */
 		mutex_unlock(&dev->io_mutex);
 		retval = -ENODEV;
 		goto error;
@@ -569,7 +570,7 @@ static void skel_disconnect(struct usb_i
 
 	/* prevent more I/O from starting */
 	mutex_lock(&dev->io_mutex);
-	dev->interface = NULL;
+	dev->disconnected = 1;
 	mutex_unlock(&dev->io_mutex);
 
 	usb_kill_anchored_urbs(&dev->submitted);


