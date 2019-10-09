Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B43BBD14FB
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731759AbfJIRJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:09:46 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45803 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731417AbfJIRJq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 13:09:46 -0400
Received: by mail-lf1-f68.google.com with SMTP id r134so2213456lff.12;
        Wed, 09 Oct 2019 10:09:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L4J8qTu+YF8xfX8qpydkpgib5XDtsqf13k/D3VElzdQ=;
        b=OZLl3iRP6mkjwcbVT5TlPKpIY96CbbsOooatjGasZOnYfWSxplzD7jTj3V3Ko/pOPU
         lE0m/Hfm+hUQuO54qeydzYvPM1UXUMwVH9pRLmsgukokzHZNKSrZb40aEdtK03W/CJ/i
         XNO6ZOvWNjkyDMv5oDJWrvsTuNszNMfMljZ3IFJBj2ZM2/gtXSN8t5EOzMWxf6A49eDC
         AVx0sHI9Yu47bRZaAXdfSVhNy9FSSEBUXYG2XiUL3TMzKYh2sgtxAYRB2w3tXfB0oyhT
         oemel3QJiq4ZDfGktpQKe33dEk9XmJQxXnncRGXeOetUCR/vIjKLdAkad5aBJbd1+1FO
         7Snw==
X-Gm-Message-State: APjAAAXO1IwrZFo0MHamCuYo9b8g+1HhNzyw670e28uZg/q6l+Y5uFF7
        9AE2xaJEmCc/m6isAonTH4c=
X-Google-Smtp-Source: APXvYqzCAODMuJ4k5t6hiwqZmPWzIDblLTW1E+Ap4zMw4neNCg11CRLC0IrKMA4tmk4GZ2ch3G8avQ==
X-Received: by 2002:a19:c188:: with SMTP id r130mr2878297lff.41.1570640984165;
        Wed, 09 Oct 2019 10:09:44 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id h25sm748316lfj.81.2019.10.09.10.09.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Oct 2019 10:09:42 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iIFTF-0007pq-0j; Wed, 09 Oct 2019 19:09:53 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/3] USB: usb-skeleton: fix NULL-deref on disconnect
Date:   Wed,  9 Oct 2019 19:09:42 +0200
Message-Id: <20191009170944.30057-2-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191009170944.30057-1-johan@kernel.org>
References: <20191009170944.30057-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

