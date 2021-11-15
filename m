Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDCC45248A
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243055AbhKPBja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:39:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:42398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241956AbhKOSbm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:31:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29AF161B4D;
        Mon, 15 Nov 2021 17:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999141;
        bh=LkYfg4L3LlekFMzrw5zp9RACoXWSx2mMTavoInyQRiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxzoNhqudxapQn/Gsioqk4fL22pq1RjvKxpOGVdLSu2ABX6GZv+6xn3N/3cVTnlhy
         jElcAqA6kJzaTK2PmtZ79CnHktyy/JT+1v5aWHb0E4Afi1L7i3tGzf+ym/Y+46A3G+
         pPnYbCdNEYsgsAYxHuUpbXrk7i1pHOlh7JQR8nkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.14 192/849] iio: buffer: Fix memory leak in __iio_buffer_alloc_sysfs_and_mask()
Date:   Mon, 15 Nov 2021 17:54:35 +0100
Message-Id: <20211115165426.686481248@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit 9a2ff8009e53296e47de72d5af0bc31cd53274ff upstream.

When iio_buffer_wrap_attr() returns NULL or buffer->buffer_group.name alloc
fails, the 'attr' which is allocated in __iio_buffer_alloc_sysfs_and_mask()
is not freed, and cause memory leak.

unreferenced object 0xffff888014882a00 (size 64):
  comm "i2c-adjd_s311-8", pid 424, jiffies 4294907737 (age 44.396s)
  hex dump (first 32 bytes):
    00 0f 8a 15 80 88 ff ff 00 0e 8a 15 80 88 ff ff  ................
    80 04 8a 15 80 88 ff ff 80 05 8a 15 80 88 ff ff  ................
  backtrace:
    [<0000000021752e67>] __kmalloc+0x1af/0x3c0
    [<0000000043e8305c>] iio_buffers_alloc_sysfs_and_mask+0xe73/0x1570 [industrialio]
    [<00000000b7aa5a17>] __iio_device_register+0x483/0x1a30 [industrialio]
    [<000000003fa0fb2f>] __devm_iio_device_register+0x23/0x90 [industrialio]
    [<000000003ab040cf>] adjd_s311_probe+0x19c/0x200 [adjd_s311]
    [<0000000080458969>] i2c_device_probe+0xa31/0xbe0
    [<00000000e20678ad>] really_probe+0x299/0xc30
    [<000000006bea9b27>] __driver_probe_device+0x357/0x500
    [<00000000e1df10d4>] driver_probe_device+0x4e/0x140
    [<0000000003661beb>] __device_attach_driver+0x257/0x340
    [<000000005bb4aa26>] bus_for_each_drv+0x166/0x1e0
    [<00000000272c5236>] __device_attach+0x272/0x420
    [<00000000d52a96ae>] bus_probe_device+0x1eb/0x2a0
    [<00000000129f7737>] device_add+0xbf0/0x1f90
    [<000000005eed4e52>] i2c_new_client_device+0x622/0xb20
    [<00000000b85a9c43>] new_device_store+0x1fa/0x420

This patch fix to free it before the error return.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 15097c7a1adc ("iio: buffer: wrap all buffer attributes into iio_dev_attr")
Fixes: d9a625744ed0 ("iio: core: merge buffer/ & scan_elements/ attributes")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20211013094343.315275-1-yangyingliang@huawei.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-buffer.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1535,6 +1535,7 @@ static int __iio_buffer_alloc_sysfs_and_
 		       sizeof(struct attribute *) * buffer_attrcount);
 
 	buffer_attrcount += ARRAY_SIZE(iio_buffer_attrs);
+	buffer->buffer_group.attrs = attr;
 
 	for (i = 0; i < buffer_attrcount; i++) {
 		struct attribute *wrapped;
@@ -1542,7 +1543,7 @@ static int __iio_buffer_alloc_sysfs_and_
 		wrapped = iio_buffer_wrap_attr(buffer, attr[i]);
 		if (!wrapped) {
 			ret = -ENOMEM;
-			goto error_free_scan_mask;
+			goto error_free_buffer_attrs;
 		}
 		attr[i] = wrapped;
 	}
@@ -1557,8 +1558,6 @@ static int __iio_buffer_alloc_sysfs_and_
 		goto error_free_buffer_attrs;
 	}
 
-	buffer->buffer_group.attrs = attr;
-
 	ret = iio_device_register_sysfs_group(indio_dev, &buffer->buffer_group);
 	if (ret)
 		goto error_free_buffer_attr_group_name;


