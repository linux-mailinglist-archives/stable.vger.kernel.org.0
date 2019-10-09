Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14648D0D25
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 12:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731107AbfJIKtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 06:49:20 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37177 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729471AbfJIKtC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 06:49:02 -0400
Received: by mail-lf1-f66.google.com with SMTP id w67so1285834lff.4;
        Wed, 09 Oct 2019 03:49:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I9S1LZhS7NXOvlyQeuNp2uC2+n7oyPIPQVWvy8JnR8k=;
        b=CqsD9cPOjWJGiC45LdabQhInhRSG6/SFcVmMlQ2sjeM9J7/EvoJiBJsuQOjlTugI5F
         7ewWKeHW474+fJh/+1pVt/vyDROT7MMzuf/TQtBpgUcD1k6qjcEfopCZ2UW0d43m5fwc
         c7GkwLuK+YGxj+3h3vu1L95fDpUT32DHoccRV0mzTLbsUhmcUAgzbxsWxLCIQAAa4nJN
         v7GbGI6QxTHacOtqkh5hHW5asm/IAQxLkb06VoVsnPtEOyZi4c01XT9HHBNNZCblWcCr
         HljxAcxQwE2P2ay9uoShZ8RnFhY9ZnO/pskPNdkkqPYFtCRy+kQ2TdZlaMJ9SHJt+ssD
         87Gg==
X-Gm-Message-State: APjAAAVtPY4Km4EZruSsSkxS3oPu+s3wfQSDbZ/gqBZ1jA9QsUsUQxmK
        Y8sOHX9oUA1SCgCzIiSuNYA=
X-Google-Smtp-Source: APXvYqwu9JjQAwNijJ26sxj1ucuo52qILAxSWiZWCaWhta33rkytYVZHMjkH/dtdQ2WwWBplYiUilA==
X-Received: by 2002:a19:2394:: with SMTP id j142mr1619262lfj.13.1570618139808;
        Wed, 09 Oct 2019 03:48:59 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id b6sm440699lfi.72.2019.10.09.03.48.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Oct 2019 03:48:57 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iI9Wk-0001Ym-UO; Wed, 09 Oct 2019 12:49:06 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Oliver Neukum <oneukum@suse.com>,
        Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 2/6] USB: iowarrior: fix use-after-free on release
Date:   Wed,  9 Oct 2019 12:48:42 +0200
Message-Id: <20191009104846.5925-3-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191009104846.5925-1-johan@kernel.org>
References: <20191009104846.5925-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver was accessing its struct usb_interface from its release()
callback without holding a reference. This would lead to a
use-after-free whenever debugging was enabled and the device was
disconnected while its character device was open.

Fixes: 549e83500b80 ("USB: iowarrior: Convert local dbg macro to dev_dbg")
Cc: stable <stable@vger.kernel.org>     # 3.16
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/misc/iowarrior.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index 4fe1d3267b3c..6841267820c6 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -243,6 +243,7 @@ static inline void iowarrior_delete(struct iowarrior *dev)
 	kfree(dev->int_in_buffer);
 	usb_free_urb(dev->int_in_urb);
 	kfree(dev->read_queue);
+	usb_put_intf(dev->interface);
 	kfree(dev);
 }
 
@@ -764,7 +765,7 @@ static int iowarrior_probe(struct usb_interface *interface,
 	init_waitqueue_head(&dev->write_wait);
 
 	dev->udev = udev;
-	dev->interface = interface;
+	dev->interface = usb_get_intf(interface);
 
 	iface_desc = interface->cur_altsetting;
 	dev->product_id = le16_to_cpu(udev->descriptor.idProduct);
-- 
2.23.0

