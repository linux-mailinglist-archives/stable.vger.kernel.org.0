Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD873D9FBA
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437946AbfJPV5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:57:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438035AbfJPV5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:57:45 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7531A21928;
        Wed, 16 Oct 2019 21:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263064;
        bh=jFXAIx9g4Rar81Kccj33nbuvqOQF4Z/HIzIz/pbtx48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cj8CvnKmOngp/s+KzqR6EQa0MIgTy+uKpKbOlTIgAQUOqpKlfgIsqrC0jg71hrbdh
         6CwLvYWBNMfERXEOeo3kZnhq9xsJb1gvawKDhGb2QjLv24pmlrp6/6i9YYOzJqmUf3
         E1s0XOSU9odrNT2ZAriMeiuUPYCIaNe4c8KnN0oM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 39/81] USB: legousbtower: fix use-after-free on release
Date:   Wed, 16 Oct 2019 14:50:50 -0700
Message-Id: <20191016214837.287917317@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214805.727399379@linuxfoundation.org>
References: <20191016214805.727399379@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 726b55d0e22ca72c69c947af87785c830289ddbc upstream.

The driver was accessing its struct usb_device in its release()
callback without holding a reference. This would lead to a
use-after-free whenever the device was disconnected while the character
device was still open.

Fixes: fef526cae700 ("USB: legousbtower: remove custom debug macro")
Cc: stable <stable@vger.kernel.org>     # 3.12
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191009153848.8664-5-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/legousbtower.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -296,6 +296,7 @@ static inline void tower_delete (struct
 	kfree (dev->read_buffer);
 	kfree (dev->interrupt_in_buffer);
 	kfree (dev->interrupt_out_buffer);
+	usb_put_dev(dev->udev);
 	kfree (dev);
 }
 
@@ -810,7 +811,7 @@ static int tower_probe (struct usb_inter
 
 	mutex_init(&dev->lock);
 
-	dev->udev = udev;
+	dev->udev = usb_get_dev(udev);
 	dev->open_count = 0;
 	dev->disconnected = 0;
 


