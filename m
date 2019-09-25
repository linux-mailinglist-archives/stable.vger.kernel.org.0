Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3562BDAF5
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 11:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfIYJ3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 05:29:25 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35102 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731569AbfIYJ3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Sep 2019 05:29:24 -0400
Received: by mail-lf1-f68.google.com with SMTP id w6so3674264lfl.2;
        Wed, 25 Sep 2019 02:29:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3A//nQ4U0ch//9NRjZkGVGrLiOj9F1zd5dYhN2nB9J0=;
        b=bOuoov9amIJClorT7w/Mt1UYfrquhlserOOWvVpzztMaXTV6aaOHc/Mp1yXcFaP0rG
         zFfyI6/NtNYM64JDo5TsKVKP4qx9JnnU3T4k85kJR6JQkzQmAwraG3H2I/aCIgIlXTiP
         Vf4Ecm/FmIpmUTWMbgswT1VrXRgpgz87/Nq0jVNztFiBK3Py+/2nWW2hszPcQWXFjTfj
         AdFiXkegQU6XlEq1i12cxkFKohca5cf576XaOAXDfNd4KXoiwlyUcG3D2ZAlJyr95bWC
         5JlhKzzY7L367VVQ+EWxuxR4vCN0/xvKjiBv7q+jMsIPZJXpN8xJAnIuEirorAYdJYJL
         5k7w==
X-Gm-Message-State: APjAAAVFlqBSmhYIsRn7RockvubPzaL/+gUCkGcgYNbscBOtA08RcKgr
        /Adz5Ar1JcZ1BQ+RGciFyH4=
X-Google-Smtp-Source: APXvYqzhIOrwZ5xeA83zTwMncUhIL9gjkSxGjou7BjEKHVXBSk8cG52Z3Fz5DChZNYIXrIPwyVmiaQ==
X-Received: by 2002:a19:4f5a:: with SMTP id a26mr5079832lfk.116.1569403763000;
        Wed, 25 Sep 2019 02:29:23 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id r6sm1069401ljr.77.2019.09.25.02.29.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Sep 2019 02:29:21 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iD3bz-0002Fa-7g; Wed, 25 Sep 2019 11:29:27 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        syzbot+0243cb250a51eeefb8cc@syzkaller.appspotmail.com
Subject: [PATCH 1/2] USB: adutux: fix use-after-free on disconnect
Date:   Wed, 25 Sep 2019 11:29:12 +0200
Message-Id: <20190925092913.8608-1-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver was clearing its struct usb_device pointer, which it used as
an inverted disconnected flag, before deregistering the character device
and without serialising against racing release().

This could lead to a use-after-free if a racing release() callback
observes the cleared pointer and frees the driver data before
disconnect() is finished with it.

This could also lead to NULL-pointer dereferences in a racing open().

Fixes: f08812d5eb8f ("USB: FIx locks and urb->status in adutux (updated)")
Cc: stable <stable@vger.kernel.org>     # 2.6.24
Reported-by: syzbot+0243cb250a51eeefb8cc@syzkaller.appspotmail.com
Tested-by: syzbot+0243cb250a51eeefb8cc@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/misc/adutux.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/misc/adutux.c b/drivers/usb/misc/adutux.c
index 344d523b0502..bcc138990e2f 100644
--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -762,14 +762,15 @@ static void adu_disconnect(struct usb_interface *interface)
 
 	dev = usb_get_intfdata(interface);
 
-	mutex_lock(&dev->mtx);	/* not interruptible */
-	dev->udev = NULL;	/* poison */
 	usb_deregister_dev(interface, &adu_class);
-	mutex_unlock(&dev->mtx);
 
 	mutex_lock(&adutux_mutex);
 	usb_set_intfdata(interface, NULL);
 
+	mutex_lock(&dev->mtx);	/* not interruptible */
+	dev->udev = NULL;	/* poison */
+	mutex_unlock(&dev->mtx);
+
 	/* if the device is not opened, then we clean up right now */
 	if (!dev->open_count)
 		adu_delete(dev);
-- 
2.23.0

