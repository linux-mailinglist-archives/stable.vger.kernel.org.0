Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81426C24EA
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 18:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732210AbfI3QM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 12:12:59 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39211 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731967AbfI3QM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Sep 2019 12:12:58 -0400
Received: by mail-lj1-f195.google.com with SMTP id y3so10117554ljj.6;
        Mon, 30 Sep 2019 09:12:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+DoZWEhn4m4mbnXlcooHkZDNyGpeymNebsUFenCg8nY=;
        b=bJ//A9B7gRYgkD/y6dlzfF470TqJqe1HYJgyAWMC1JHwBuMa20SxDkMyNtgAimxCpl
         cPHTnMzzlpNkEeK5qfLxjFwrUadgviGGH6RVMLIjKp0ezteBFThZbspaUzX1fRunTWce
         VAfv8hj/3EgP2XSXDA+GVNzifJgOpflCwilNh9DPicpP+eGcl5C3iW6tbxjqaP7DN6yc
         rlH6KBzJg1hhnwG7ljJy84zzzYMp44zS0MYk/kZZ4WAcX/h6L1VXK8He4ygTuLgN8Yks
         nHilWgXO96BgEVN5m2sek8pAvIRP+X12ULii5ComAnFt4jYTDDqW9OvyUnf/i4RGQxxN
         9Rnw==
X-Gm-Message-State: APjAAAVJJq1A2H9rD3TAwEoun5/7u33zomoimdNlDyNKFithyq29Yp7P
        tWnazZ+x7Ybe9ShjcIBkUj3ZSLSn
X-Google-Smtp-Source: APXvYqwPqTg0nXl80m6KpqMU5ibiF5xslTyhQgpT+xvaF9gdJN16Loa4YWLcxlnzCiV/KQraRuRTlQ==
X-Received: by 2002:a2e:87cb:: with SMTP id v11mr12777943ljj.31.1569859975176;
        Mon, 30 Sep 2019 09:12:55 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id i6sm3208417lfc.37.2019.09.30.09.12.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 09:12:53 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iEyIG-0004uP-5Y; Mon, 30 Sep 2019 18:13:00 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Pete Zaitcev <zaitcev@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/4] USB: usb-skeleton: fix runtime PM after driver unbind
Date:   Mon, 30 Sep 2019 18:12:02 +0200
Message-Id: <20190930161205.18803-2-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190930161205.18803-1-johan@kernel.org>
References: <20190930161205.18803-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit c2b71462d294 ("USB: core: Fix bug caused by duplicate
interface PM usage counter") USB drivers must always balance their
runtime PM gets and puts, including when the driver has already been
unbound from the interface.

Leaving the interface with a positive PM usage counter would prevent a
later bound driver from suspending the device.

Fixes: c2b71462d294 ("USB: core: Fix bug caused by duplicate interface PM usage counter")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/usb-skeleton.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index f1a5861a0586..93c3fbc2ab1f 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -74,6 +74,7 @@ static void skel_delete(struct kref *kref)
 	struct usb_skel *dev = to_skel_dev(kref);
 
 	usb_free_urb(dev->bulk_in_urb);
+	usb_put_intf(dev->interface);
 	usb_put_dev(dev->udev);
 	kfree(dev->bulk_in_buffer);
 	kfree(dev);
@@ -125,10 +126,7 @@ static int skel_release(struct inode *inode, struct file *file)
 		return -ENODEV;
 
 	/* allow the device to be autosuspended */
-	mutex_lock(&dev->io_mutex);
-	if (!dev->disconnected)
-		usb_autopm_put_interface(dev->interface);
-	mutex_unlock(&dev->io_mutex);
+	usb_autopm_put_interface(dev->interface);
 
 	/* decrement the count on our device */
 	kref_put(&dev->kref, skel_delete);
@@ -507,7 +505,7 @@ static int skel_probe(struct usb_interface *interface,
 	init_waitqueue_head(&dev->bulk_in_wait);
 
 	dev->udev = usb_get_dev(interface_to_usbdev(interface));
-	dev->interface = interface;
+	dev->interface = usb_get_intf(interface);
 
 	/* set up the endpoint information */
 	/* use only the first bulk-in and bulk-out endpoints */
-- 
2.23.0

