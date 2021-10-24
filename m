Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 163EA438884
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 13:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhJXLR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 07:17:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231285AbhJXLR4 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sun, 24 Oct 2021 07:17:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5499B60FE8;
        Sun, 24 Oct 2021 11:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635074135;
        bh=b9D0f8R0CmoLoHLzQ7isEKqU0WNHDCjy8pjsfxJ+g6o=;
        h=Subject:To:From:Date:From;
        b=rxuhVRBsYqpCA4VYMU5EWGfoxico8LtOM8OKBeK7O6Jmzz2eShKAs2uPVHyywdjDC
         Yg3NLq+o/xgtRn4doJNcD/Ckr4HVqFxyno0G7JMLBXk8KNhJdDJTLyJ0IFMeAHsw91
         c98vAri8rFu0h3ijWn3/XNycuw3y3oLOfMfEIJDM=
Subject: patch "iio: core: check return value when calling dev_set_name()" added to char-misc-next
To:     yangyingliang@huawei.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, hulkci@huawei.com
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Oct 2021 13:15:09 +0200
Message-ID: <1635074109188153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: core: check return value when calling dev_set_name()

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From fe6f45f6ba22d625a8500cbad0237c60dd3117ee Mon Sep 17 00:00:00 2001
From: Yang Yingliang <yangyingliang@huawei.com>
Date: Tue, 12 Oct 2021 14:36:24 +0800
Subject: iio: core: check return value when calling dev_set_name()

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
---
 drivers/iio/industrialio-core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

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
 
-- 
2.33.1


