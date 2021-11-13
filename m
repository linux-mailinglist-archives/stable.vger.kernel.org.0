Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79F844F3E2
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 16:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235913AbhKMPZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 10:25:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:43292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231791AbhKMPZ2 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sat, 13 Nov 2021 10:25:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71A6860D43;
        Sat, 13 Nov 2021 15:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636816956;
        bh=zYV92jijA9AVjvnTd2oayng+twlyGMn25mnDnB5NkLQ=;
        h=Subject:To:Cc:From:Date:From;
        b=a1T3iiv7s4SuL9Qtdjzc95+hSR8isM5EkBouDjCb2abaPAwQPPi7xdeTrkk/JkRR2
         lyIoJ1OcegAU8jurlJga7lKQh4/yKmsk+uT+KZacltlehq3S7koRzGScJi6fEk2KeO
         TweZH4lmFT4Wyl0Q97+i4ZbAoLRtWoOn2sIdRnYc=
Subject: FAILED: patch "[PATCH] iio: core: check return value when calling dev_set_name()" failed to apply to 5.10-stable tree
To:     yangyingliang@huawei.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, hulkci@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Nov 2021 16:22:15 +0100
Message-ID: <163681693561156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fe6f45f6ba22d625a8500cbad0237c60dd3117ee Mon Sep 17 00:00:00 2001
From: Yang Yingliang <yangyingliang@huawei.com>
Date: Tue, 12 Oct 2021 14:36:24 +0800
Subject: [PATCH] iio: core: check return value when calling dev_set_name()

I got a null-ptr-deref report when doing fault injection test:

BUG: kernel NULL pointer dereference, address: 0000000000000000
RIP: 0010:strlen+0x0/0x20
Call Trace:
 start_creating+0x199/0x2f0
 debugfs_create_dir+0x25/0x430
 __iio_device_register+0x4da/0x1b40 [industrialio]
 __devm_iio_device_register+0x22/0x80 [industrialio]
 max1027_probe+0x639/0x860 [max1027]
 spi_probe+0x183/0x210
 really_probe+0x285/0xc30

If dev_set_name() fails, the dev_name() is null, check the return
value of dev_set_name() to avoid the null-ptr-deref.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: e553f182d55b ("staging: iio: core: Introduce debugfs support...")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211012063624.3167460-1-yangyingliang@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 2dbb37e09b8c..48fda6a79076 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1664,7 +1664,13 @@ struct iio_dev *iio_device_alloc(struct device *parent, int sizeof_priv)
 		kfree(iio_dev_opaque);
 		return NULL;
 	}
-	dev_set_name(&indio_dev->dev, "iio:device%d", iio_dev_opaque->id);
+
+	if (dev_set_name(&indio_dev->dev, "iio:device%d", iio_dev_opaque->id)) {
+		ida_simple_remove(&iio_ida, iio_dev_opaque->id);
+		kfree(iio_dev_opaque);
+		return NULL;
+	}
+
 	INIT_LIST_HEAD(&iio_dev_opaque->buffer_list);
 	INIT_LIST_HEAD(&iio_dev_opaque->ioctl_handlers);
 

