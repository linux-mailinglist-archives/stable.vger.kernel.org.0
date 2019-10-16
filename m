Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23E17D9E04
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 23:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437827AbfJPVzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:55:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730242AbfJPVzt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:55:49 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7D57218DE;
        Wed, 16 Oct 2019 21:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262948;
        bh=AA87dV9Ddr99++5nPmhYk8F/gtNPCyGiAQiYJ12A57c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u9L/xX9GIDB7x42NX8c5ttBw92yM1gJtbyMVMWKwFWqkKezrLvSyfe+PQR8WxVLhd
         TG3VCmfB++QI5wxkqoR15tcCBDXZ3L23x7mg5G7A10DzNW4A8UcH3W7ZUgl0jx8MDV
         HcWn+6ld4U5YUmKUNZPL/ALWaqH8wHZdrYY7fS78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 18/65] USB: iowarrior: fix use-after-free on release
Date:   Wed, 16 Oct 2019 14:50:32 -0700
Message-Id: <20191016214811.992286206@linuxfoundation.org>
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

commit 80cd5479b525093a56ef768553045741af61b250 upstream.

The driver was accessing its struct usb_interface from its release()
callback without holding a reference. This would lead to a
use-after-free whenever debugging was enabled and the device was
disconnected while its character device was open.

Fixes: 549e83500b80 ("USB: iowarrior: Convert local dbg macro to dev_dbg")
Cc: stable <stable@vger.kernel.org>     # 3.16
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191009104846.5925-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/iowarrior.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -246,6 +246,7 @@ static inline void iowarrior_delete(stru
 	kfree(dev->int_in_buffer);
 	usb_free_urb(dev->int_in_urb);
 	kfree(dev->read_queue);
+	usb_put_intf(dev->interface);
 	kfree(dev);
 }
 
@@ -768,7 +769,7 @@ static int iowarrior_probe(struct usb_in
 	init_waitqueue_head(&dev->write_wait);
 
 	dev->udev = udev;
-	dev->interface = interface;
+	dev->interface = usb_get_intf(interface);
 
 	iface_desc = interface->cur_altsetting;
 	dev->product_id = le16_to_cpu(udev->descriptor.idProduct);


