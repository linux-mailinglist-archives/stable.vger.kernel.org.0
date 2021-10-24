Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7FC43886C
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 13:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbhJXLLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 07:11:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231563AbhJXLLk (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sun, 24 Oct 2021 07:11:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB4B860F22;
        Sun, 24 Oct 2021 11:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635073760;
        bh=oswHiB/s9Y8J+sXUopl9WLoN91JzXLrMDHZx59tALfM=;
        h=Subject:To:From:Date:From;
        b=RowDYze/Cr+GUVn8E/WmWyOzANX78z6MI+4SCVymAaq/xhuetMuM4JGCsEvQjJBm/
         UY83uCzbn5y8cH0k9WQmsbglClEBtxr/mQ1a+9VRfNeoTmF8a8CjrLpIRGZHGnOLRW
         +prvy6fvKpmWr0qvWNAg+AjDg8nCcpSAmwBQjnVE=
Subject: patch "iio: buffer: check return value of kstrdup_const()" added to char-misc-testing
To:     yangyingliang@huawei.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, hulkci@huawei.com
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Oct 2021 13:09:10 +0200
Message-ID: <1635073750209153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: buffer: check return value of kstrdup_const()

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 2c0ad3f0cc04dec489552a21b80cd6d708bea96d Mon Sep 17 00:00:00 2001
From: Yang Yingliang <yangyingliang@huawei.com>
Date: Wed, 13 Oct 2021 12:04:38 +0800
Subject: iio: buffer: check return value of kstrdup_const()

Check return value of kstrdup_const() in iio_buffer_wrap_attr(),
or it will cause null-ptr-deref in kernfs_name_hash() when calling
device_add() as follows:

BUG: kernel NULL pointer dereference, address: 0000000000000000
RIP: 0010:strlen+0x0/0x20
Call Trace:
 kernfs_name_hash+0x22/0x110
 kernfs_find_ns+0x11d/0x390
 kernfs_remove_by_name_ns+0x3b/0xb0
 remove_files.isra.1+0x7b/0x190
 internal_create_group+0x7f1/0xbb0
 internal_create_groups+0xa3/0x150
 device_add+0x8f0/0x2020
 cdev_device_add+0xc3/0x160
 __iio_device_register+0x1427/0x1b40 [industrialio]
 __devm_iio_device_register+0x22/0x80 [industrialio]
 adjd_s311_probe+0x195/0x200 [adjd_s311]
 i2c_device_probe+0xa07/0xbb0

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 15097c7a1adc ("iio: buffer: wrap all buffer attributes into iio_dev_attr")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20211013040438.1689277-1-yangyingliang@huawei.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/industrialio-buffer.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index a95cc2da56be..55802da1deee 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1312,6 +1312,11 @@ static struct attribute *iio_buffer_wrap_attr(struct iio_buffer *buffer,
 	iio_attr->buffer = buffer;
 	memcpy(&iio_attr->dev_attr, dattr, sizeof(iio_attr->dev_attr));
 	iio_attr->dev_attr.attr.name = kstrdup_const(attr->name, GFP_KERNEL);
+	if (!iio_attr->dev_attr.attr.name) {
+		kfree(iio_attr);
+		return NULL;
+	}
+
 	sysfs_attr_init(&iio_attr->dev_attr.attr);
 
 	list_add(&iio_attr->l, &buffer->buffer_attr_list);
-- 
2.33.1


