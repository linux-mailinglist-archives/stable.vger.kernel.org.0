Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 459B019B357
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388611AbgDAQkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:40:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388112AbgDAQkI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:40:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 477B720658;
        Wed,  1 Apr 2020 16:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759206;
        bh=DF2vG2JENOKeJQt1F4AhXFxKkI4NDkRA7YESUG6WUw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wSO7Kul3tLOUEoVigp29kKvxaunZu062oEofrNnbv4LX32YFbtjz/Rcvawg2O0z89
         uT3ocBe2gEtIi6h1M7aTfttew3XL4FHFAssYGlIddFk7ESKZhDofxRIp0UZbGnfubM
         UBl6ZPrG6wJn7bvraRohlAIPzgTRwEzSmD7sj2hQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.9 080/102] media: flexcop-usb: fix endpoint sanity check
Date:   Wed,  1 Apr 2020 18:18:23 +0200
Message-Id: <20200401161545.984703461@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161530.451355388@linuxfoundation.org>
References: <20200401161530.451355388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit bca243b1ce0e46be26f7c63b5591dfbb41f558e5 upstream.

commit 1b976fc6d684 ("media: b2c2-flexcop-usb: add sanity checking") added
an endpoint sanity check to address a NULL-pointer dereference on probe.
Unfortunately the check was done on the current altsetting which was later
changed.

Fix this by moving the sanity check to after the altsetting is changed.

Fixes: 1b976fc6d684 ("media: b2c2-flexcop-usb: add sanity checking")
Cc: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/b2c2/flexcop-usb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -511,6 +511,9 @@ static int flexcop_usb_init(struct flexc
 		return ret;
 	}
 
+	if (fc_usb->uintf->cur_altsetting->desc.bNumEndpoints < 1)
+		return -ENODEV;
+
 	switch (fc_usb->udev->speed) {
 	case USB_SPEED_LOW:
 		err("cannot handle USB speed because it is too slow.");
@@ -544,9 +547,6 @@ static int flexcop_usb_probe(struct usb_
 	struct flexcop_device *fc = NULL;
 	int ret;
 
-	if (intf->cur_altsetting->desc.bNumEndpoints < 1)
-		return -ENODEV;
-
 	if ((fc = flexcop_device_kmalloc(sizeof(struct flexcop_usb))) == NULL) {
 		err("out of memory\n");
 		return -ENOMEM;


