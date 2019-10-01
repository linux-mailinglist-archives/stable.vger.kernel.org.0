Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE445C2F2C
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 10:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733158AbfJAItU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 04:49:20 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39461 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfJAItU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 04:49:20 -0400
Received: by mail-lf1-f68.google.com with SMTP id 72so9202519lfh.6;
        Tue, 01 Oct 2019 01:49:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GJ9elSXqU+FEADEgqKR4gEl+Ure805NrXlSWROzp6QU=;
        b=hANb21mNdt/EfTmEGyIYn4vLkIV/yHjVMC5IRDSWGV0URpn5/4YuyIEhYZWLfuBL6n
         hMAOZr/M/hFbJZneee2znlMbAT1dR07zS7t2pf0QI76RmYrc4+dp3JsLX9IBeDyp4iTD
         eLjlkFmrRFR7M3qCelWGB/1EDgFloCZFidLbtKuYtM/4q2Vnc01dJqBjaJf21F/4ci3h
         AmKMFq8aI0x3e9uK/KgNBaOhaqg2x2OzskbypX+kzBUPY60GAjjIEXirRvutsp1WzXyq
         nhNd48OGfao70wwpAINS7z+5Cjg3Yy8oHnWZFgG5UgVbOVDHJFLSQv8F9bOcZU/2+BHz
         nJIg==
X-Gm-Message-State: APjAAAWpuYWEmd1W++A5iYkpJ2ckwYJrHJcPQQP3n9RarU89+Md58iiM
        KSNH0IRWvYR6MmEUSgAMYeA=
X-Google-Smtp-Source: APXvYqzpmlHcQ1I3SMZsdyGGi8W29HLhdWsD8+Be1YOiT6bLLzFd7vWfeqqd4FprTJvF75qsnEEDtw==
X-Received: by 2002:a19:beca:: with SMTP id o193mr14591632lff.137.1569919758012;
        Tue, 01 Oct 2019 01:49:18 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id y206sm3625847lfc.6.2019.10.01.01.49.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 01:49:16 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iFDqX-0000X9-3S; Tue, 01 Oct 2019 10:49:25 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Pete Zaitcev <zaitcev@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH v2 1/4] USB: usb-skeleton: fix runtime PM after driver unbind
Date:   Tue,  1 Oct 2019 10:49:05 +0200
Message-Id: <20191001084908.2003-2-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191001084908.2003-1-johan@kernel.org>
References: <20191001084908.2003-1-johan@kernel.org>
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
index c31d17d05810..8001d6384c73 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -73,6 +73,7 @@ static void skel_delete(struct kref *kref)
 	struct usb_skel *dev = to_skel_dev(kref);
 
 	usb_free_urb(dev->bulk_in_urb);
+	usb_put_intf(dev->interface);
 	usb_put_dev(dev->udev);
 	kfree(dev->bulk_in_buffer);
 	kfree(dev);
@@ -124,10 +125,7 @@ static int skel_release(struct inode *inode, struct file *file)
 		return -ENODEV;
 
 	/* allow the device to be autosuspended */
-	mutex_lock(&dev->io_mutex);
-	if (dev->interface)
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

