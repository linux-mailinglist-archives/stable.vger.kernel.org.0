Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB32E451348
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348010AbhKOTtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:49:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245546AbhKOTUp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F15D96355F;
        Mon, 15 Nov 2021 18:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001412;
        bh=8eNnSlChDlm5CnbQIc66AilQ/doH9RHj91H7Ls9T8nM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Sv6KoSasH6wlanr3u8wNC7dgmfjo41MocMiDvJNgZYbEo919crpOLHocnlXZidne
         XUx642y7E3yoaOnkIsnX4bFmOuNNneum+mT7O5YVzrDrOok6h82RGUYynjrawQvL6B
         uuVIccR4WUT8HWWEKe122O3AimVLxOgTS7iI9mlY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 164/917] iio: buffer: Fix memory leak in iio_buffers_alloc_sysfs_and_mask()
Date:   Mon, 15 Nov 2021 17:54:19 +0100
Message-Id: <20211115165434.330460233@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit 486a25084155bf633768c26f022201c051d6fd95 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-buffer.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1588,8 +1588,12 @@ error_cleanup_dynamic:
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
@@ -1643,7 +1647,7 @@ int iio_buffers_alloc_sysfs_and_mask(str
 error_unwind_sysfs_and_mask:
 	for (; unwind_idx >= 0; unwind_idx--) {
 		buffer = iio_dev_opaque->attached_buffers[unwind_idx];
-		__iio_buffer_free_sysfs_and_mask(buffer);
+		__iio_buffer_free_sysfs_and_mask(buffer, indio_dev, unwind_idx);
 	}
 	return ret;
 }
@@ -1660,11 +1664,9 @@ void iio_buffers_free_sysfs_and_mask(str
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
 


