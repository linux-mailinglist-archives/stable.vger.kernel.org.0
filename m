Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4399ED130C
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 17:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729865AbfJIPi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 11:38:56 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41591 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730256AbfJIPiz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 11:38:55 -0400
Received: by mail-lf1-f65.google.com with SMTP id r2so2004554lfn.8;
        Wed, 09 Oct 2019 08:38:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=szNiykfatwwBWyT1R8vEp0SHm+VURe3hz2h1YW3Ai0o=;
        b=Y4gigpI6sTHCy0X9/oX4WcCrwjpjpECH6UWgR1HEcd5gbqskbvuj1T6teRraRbqkLs
         Id9MD/ZMjvwufOvErqMfz8BdQZJas4dEe5gNGvh5KJoJAHFeoTLVSXSh8nzqjmUUMSHz
         HIEROUoYdfIVpglDa3bxZzpv3fCs+nBWA/T6vlB2bFvuqWVeAjtEFNg0g1lekJR10ji7
         h08iZciLkzsADDLqTBRavQhExb3/RGOEJOJkpgNyofqhW/2ZP98kqX6rYf9Ccp7DMSKP
         vhhKlCHcvvPWae4wbmfLAFWtgMbZ21DwgEPIoernP+pQbIjvu1uFFcCFx3crnOAusC5S
         bKGg==
X-Gm-Message-State: APjAAAVlq5c0qqTZChAMfRU9XjZSkaLqRMTA0uYziun2XeKlHMCyC8xV
        jkLFyLnZSf51h2fW08napiNSo89m
X-Google-Smtp-Source: APXvYqwLWPUUg67a1JhQhorAQnETs8oOcbXIYEf2iIftkXz+iKY5XRY3Xh+rnvRQZWZpiCAiY/N3NA==
X-Received: by 2002:ac2:5924:: with SMTP id v4mr2521416lfi.29.1570635532016;
        Wed, 09 Oct 2019 08:38:52 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id m15sm596554ljg.97.2019.10.09.08.38.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Oct 2019 08:38:51 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iIE3J-0002Gr-Ai; Wed, 09 Oct 2019 17:39:01 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Keith Packard <keithp@keithp.com>,
        Juergen Stuber <starblue@users.sourceforge.net>,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/5] USB: adutux: fix use-after-free on release
Date:   Wed,  9 Oct 2019 17:38:44 +0200
Message-Id: <20191009153848.8664-2-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191009153848.8664-1-johan@kernel.org>
References: <20191009153848.8664-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver was accessing its struct usb_device in its release()
callback without holding a reference. This would lead to a
use-after-free whenever the device was disconnected while the character
device was still open.

Fixes: 66d4bc30d128 ("USB: adutux: remove custom debug macro")
Cc: stable <stable@vger.kernel.org>     # 3.12
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/misc/adutux.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/misc/adutux.c b/drivers/usb/misc/adutux.c
index f9efec719359..6f5edb9fc61e 100644
--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -149,6 +149,7 @@ static void adu_delete(struct adu_device *dev)
 	kfree(dev->read_buffer_secondary);
 	kfree(dev->interrupt_in_buffer);
 	kfree(dev->interrupt_out_buffer);
+	usb_put_dev(dev->udev);
 	kfree(dev);
 }
 
@@ -664,7 +665,7 @@ static int adu_probe(struct usb_interface *interface,
 
 	mutex_init(&dev->mtx);
 	spin_lock_init(&dev->buflock);
-	dev->udev = udev;
+	dev->udev = usb_get_dev(udev);
 	init_waitqueue_head(&dev->read_wait);
 	init_waitqueue_head(&dev->write_wait);
 
-- 
2.23.0

