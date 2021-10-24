Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1CF43888A
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 13:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbhJXLTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 07:19:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231400AbhJXLTO (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sun, 24 Oct 2021 07:19:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E45C61056;
        Sun, 24 Oct 2021 11:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635074213;
        bh=9LwZGIKuVfheKkl+A+sZSprWaMw6cFi/Pup8KgRtR4A=;
        h=Subject:To:From:Date:From;
        b=sd3XuaymRtPDPY7Te03DdVbl1UFMN3uem2fqWSepsUwCTESWKeJkrhyZgyqFmKQ4N
         V73n19F2GO+Jouv0KsRu7Zs18LTrGx8eQ8bMQv2FKEiDSB9RZb07dJMyJJhZJqofkr
         B8r3E4Xsuse9C/Ti74CS6VDiNlyStPfiQ39jRje4=
Subject: patch "iio: buffer: Fix memory leak in iio_buffers_alloc_sysfs_and_mask()" added to char-misc-next
To:     yangyingliang@huawei.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, hulkci@huawei.com
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Oct 2021 13:15:23 +0200
Message-ID: <163507412317989@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: buffer: Fix memory leak in iio_buffers_alloc_sysfs_and_mask()

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 486a25084155bf633768c26f022201c051d6fd95 Mon Sep 17 00:00:00 2001
From: Yang Yingliang <yangyingliang@huawei.com>
Date: Mon, 18 Oct 2021 14:37:18 +0800
Subject: iio: buffer: Fix memory leak in iio_buffers_alloc_sysfs_and_mask()

When 'iio_dev_opaque->buffer_ioctl_handler' alloc fails in
iio_buffers_alloc_sysfs_and_mask(), the 'attrs' allocated in
iio_buffer_register_legacy_sysfs_groups() will be leaked:

unreferenced object 0xffff888108568d00 (size 128):
  comm "88", pid 2014, jiffies 4294963294 (age 26.920s)
  hex dump (first 32 bytes):
    80 3e da 02 80 88 ff ff 00 3a da 02 80 88 ff ff  .>.......:......
    00 35 da 02 80 88 ff ff 00 38 da 02 80 88 ff ff  .5.......8......
  backtrace:
    [<0000000095a9e51e>] __kmalloc+0x1a3/0x2f0
    [<00000000faa3735e>] iio_buffers_alloc_sysfs_and_mask+0xfa3/0x1480 [industrialio]
    [<00000000a46384dc>] __iio_device_register+0x52e/0x1b40 [industrialio]
    [<00000000210af05e>] __devm_iio_device_register+0x22/0x80 [industrialio]
    [<00000000730d7b41>] adjd_s311_probe+0x195/0x200 [adjd_s311]
    [<00000000c0f70eb9>] i2c_device_probe+0xa07/0xbb0

The iio_buffer_register_legacy_sysfs_groups() is
called in __iio_buffer_alloc_sysfs_and_mask(),
so move the iio_buffer_unregister_legacy_sysfs_groups()
into __iio_buffer_free_sysfs_and_mask(), then the memory
will be freed.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: d9a625744ed0 ("iio: core: merge buffer/ & scan_elements/ attributes")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20211018063718.1971240-1-yangyingliang@huawei.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/industrialio-buffer.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index 1c3972150ab4..2f98ba70e3d7 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1587,8 +1587,12 @@ static int __iio_buffer_alloc_sysfs_and_mask(struct iio_buffer *buffer,
 	return ret;
 }
 
-static void __iio_buffer_free_sysfs_and_mask(struct iio_buffer *buffer)
+static void __iio_buffer_free_sysfs_and_mask(struct iio_buffer *buffer,
+					     struct iio_dev *indio_dev,
+					     int index)
 {
+	if (index == 0)
+		iio_buffer_unregister_legacy_sysfs_groups(indio_dev);
 	bitmap_free(buffer->scan_mask);
 	kfree(buffer->buffer_group.name);
 	kfree(buffer->buffer_group.attrs);
@@ -1642,7 +1646,7 @@ int iio_buffers_alloc_sysfs_and_mask(struct iio_dev *indio_dev)
 error_unwind_sysfs_and_mask:
 	for (; unwind_idx >= 0; unwind_idx--) {
 		buffer = iio_dev_opaque->attached_buffers[unwind_idx];
-		__iio_buffer_free_sysfs_and_mask(buffer);
+		__iio_buffer_free_sysfs_and_mask(buffer, indio_dev, unwind_idx);
 	}
 	return ret;
 }
@@ -1659,11 +1663,9 @@ void iio_buffers_free_sysfs_and_mask(struct iio_dev *indio_dev)
 	iio_device_ioctl_handler_unregister(iio_dev_opaque->buffer_ioctl_handler);
 	kfree(iio_dev_opaque->buffer_ioctl_handler);
 
-	iio_buffer_unregister_legacy_sysfs_groups(indio_dev);
-
 	for (i = iio_dev_opaque->attached_buffers_cnt - 1; i >= 0; i--) {
 		buffer = iio_dev_opaque->attached_buffers[i];
-		__iio_buffer_free_sysfs_and_mask(buffer);
+		__iio_buffer_free_sysfs_and_mask(buffer, indio_dev, i);
 	}
 }
 
-- 
2.33.1


