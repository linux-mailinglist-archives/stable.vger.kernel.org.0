Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20703D9FC6
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406705AbfJPV6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:58:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406703AbfJPV6P (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:58:15 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EE7020872;
        Wed, 16 Oct 2019 21:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263095;
        bh=WRL3sT47+SA5WctN36UU6w5wSnvVV/ScBydEcOXw0q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0eee7CNkxiODH4JobAfPWmL28INdc7oUtchfdfp//KZ043ouaBcoB1f5618omb7oH
         yj4DZU222kzw0vQLuZQ/gpWUrVWSPktMoSEKyq4MvJFsebkSJ3bQSUstgAerAAu0JO
         IWJkGlFumQb1/HZMjrjEZWN/15BNsvraQWGi49TQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.3 017/112] USB: adutux: fix use-after-free on release
Date:   Wed, 16 Oct 2019 14:50:09 -0700
Message-Id: <20191016214848.653423627@linuxfoundation.org>
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

commit 123a0f125fa3d2104043697baa62899d9e549272 upstream.

The driver was accessing its struct usb_device in its release()
callback without holding a reference. This would lead to a
use-after-free whenever the device was disconnected while the character
device was still open.

Fixes: 66d4bc30d128 ("USB: adutux: remove custom debug macro")
Cc: stable <stable@vger.kernel.org>     # 3.12
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191009153848.8664-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/adutux.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -149,6 +149,7 @@ static void adu_delete(struct adu_device
 	kfree(dev->read_buffer_secondary);
 	kfree(dev->interrupt_in_buffer);
 	kfree(dev->interrupt_out_buffer);
+	usb_put_dev(dev->udev);
 	kfree(dev);
 }
 
@@ -664,7 +665,7 @@ static int adu_probe(struct usb_interfac
 
 	mutex_init(&dev->mtx);
 	spin_lock_init(&dev->buflock);
-	dev->udev = udev;
+	dev->udev = usb_get_dev(udev);
 	init_waitqueue_head(&dev->read_wait);
 	init_waitqueue_head(&dev->write_wait);
 


