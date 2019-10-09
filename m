Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79B23D0D1B
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 12:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730946AbfJIKtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 06:49:03 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44995 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729566AbfJIKtC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 06:49:02 -0400
Received: by mail-lj1-f194.google.com with SMTP id m13so1946397ljj.11;
        Wed, 09 Oct 2019 03:49:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jp5IpW7NDkKcMKs+niRmVs2OZnWMfVPMeRAFv9dDYyE=;
        b=Ery8xEzAbcVqBP5me3PpRWNrFpfsWujNiiw/9gemzaHA/NjPDLJ8ZEv4ZkA61e99tm
         BUGmuWL5bFB8fHG1yjOuvumDL+TOcSqOSLd97RHCzeAAppcfYn/83FVitzTs+OeWT2nW
         PT8H36mwi8HTGaWmYeIzX9LpR0DdGIGcF0KbVRlpJNy2A4OEoeLJ6bKcd4bWF52WcXTo
         bD7IJrfhe85fuZGEKJr537qE8RdnPPHw8/31HtB4mv+KEP7qLuc5eNf91ILUHfJywV4e
         ashUSRyQtylZjO2KxjFdSHk6Rb3okVrblnTm5Cc4yRi8+a1xRLDn6uG2qDwJfoOSe209
         twUQ==
X-Gm-Message-State: APjAAAXs2a/vK9NK/sayij7tyoYOc2Oc53rD80KqQDfkOjNBm150EYAt
        8+t91/+7kedeJfQWD3Nh1iU=
X-Google-Smtp-Source: APXvYqzd+qokTRJTa8cKwVnJ2B2rU2tK2l5aGtYh0HbnGAeCN7FwrKcVwXSrfB/fNHMfgjfbljnyPQ==
X-Received: by 2002:a2e:8e87:: with SMTP id z7mr1638949ljk.207.1570618140222;
        Wed, 09 Oct 2019 03:49:00 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id c69sm368259ljf.32.2019.10.09.03.48.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Oct 2019 03:48:57 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iI9Wl-0001Yr-0d; Wed, 09 Oct 2019 12:49:07 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Oliver Neukum <oneukum@suse.com>,
        Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 3/6] USB: iowarrior: fix use-after-free after driver unbind
Date:   Wed,  9 Oct 2019 12:48:43 +0200
Message-Id: <20191009104846.5925-4-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191009104846.5925-1-johan@kernel.org>
References: <20191009104846.5925-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to stop also the asynchronous write URBs on disconnect() to
avoid use-after-free in the completion handler after driver unbind.

Fixes: 946b960d13c1 ("USB: add driver for iowarrior devices.")
Cc: stable <stable@vger.kernel.org>	# 2.6.21: 51a2f077c44e ("USB: introduce usb_anchor")
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/misc/iowarrior.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index 6841267820c6..f405fa734bcc 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -87,6 +87,7 @@ struct iowarrior {
 	char chip_serial[9];		/* the serial number string of the chip connected */
 	int report_size;		/* number of bytes in a report */
 	u16 product_id;
+	struct usb_anchor submitted;
 };
 
 /*--------------*/
@@ -425,11 +426,13 @@ static ssize_t iowarrior_write(struct file *file,
 			retval = -EFAULT;
 			goto error;
 		}
+		usb_anchor_urb(int_out_urb, &dev->submitted);
 		retval = usb_submit_urb(int_out_urb, GFP_KERNEL);
 		if (retval) {
 			dev_dbg(&dev->interface->dev,
 				"submit error %d for urb nr.%d\n",
 				retval, atomic_read(&dev->write_busy));
+			usb_unanchor_urb(int_out_urb);
 			goto error;
 		}
 		/* submit was ok */
@@ -770,6 +773,8 @@ static int iowarrior_probe(struct usb_interface *interface,
 	iface_desc = interface->cur_altsetting;
 	dev->product_id = le16_to_cpu(udev->descriptor.idProduct);
 
+	init_usb_anchor(&dev->submitted);
+
 	res = usb_find_last_int_in_endpoint(iface_desc, &dev->int_in_endpoint);
 	if (res) {
 		dev_err(&interface->dev, "no interrupt-in endpoint found\n");
@@ -885,6 +890,7 @@ static void iowarrior_disconnect(struct usb_interface *interface)
 		   Deleting the device is postponed until close() was called.
 		 */
 		usb_kill_urb(dev->int_in_urb);
+		usb_kill_anchored_urbs(&dev->submitted);
 		wake_up_interruptible(&dev->read_wait);
 		wake_up_interruptible(&dev->write_wait);
 		mutex_unlock(&dev->mutex);
-- 
2.23.0

