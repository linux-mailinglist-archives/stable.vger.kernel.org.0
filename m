Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5271FD9F8D
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395359AbfJPVzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:55:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395354AbfJPVzq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:55:46 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 525D321925;
        Wed, 16 Oct 2019 21:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262945;
        bh=TzwPGINp8jZh+7I/f0jNrHURxZv3qP2Ghp6c2L18rAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UpVqLMdniwAMhx5hPhMLs+PYnK8Eg6BJBW3PxfmCvCT/wvFSJ9Bh431Z9bu4vfO8h
         F2HUhTN25JEXHk5PLgtkzdMyoMpUBLCS6eBzd+MSxRN9jrdbW1m4l9W1Z6W/Fw22d0
         FW7zp5wEnKpDGFpbj19SHmGPAUpAjuR2nxx7jZXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 16/65] USB: adutux: fix use-after-free on release
Date:   Wed, 16 Oct 2019 14:50:30 -0700
Message-Id: <20191016214808.231453807@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214756.457746573@linuxfoundation.org>
References: <20191016214756.457746573@linuxfoundation.org>
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
@@ -151,6 +151,7 @@ static void adu_delete(struct adu_device
 	kfree(dev->read_buffer_secondary);
 	kfree(dev->interrupt_in_buffer);
 	kfree(dev->interrupt_out_buffer);
+	usb_put_dev(dev->udev);
 	kfree(dev);
 }
 
@@ -666,7 +667,7 @@ static int adu_probe(struct usb_interfac
 
 	mutex_init(&dev->mtx);
 	spin_lock_init(&dev->buflock);
-	dev->udev = udev;
+	dev->udev = usb_get_dev(udev);
 	init_waitqueue_head(&dev->read_wait);
 	init_waitqueue_head(&dev->write_wait);
 


