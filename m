Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B410452485
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356647AbhKPBj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:39:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:42246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241729AbhKOSbi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:31:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EF4B6127C;
        Mon, 15 Nov 2021 17:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999136;
        bh=zSG1H5efuh48JS8TgTuDkyaC1kOP05UyPn1K5cGIU8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oPjTDM92JaoFRTuNSJIKLD1asK7FOZ850zww1hhHJLY0sJ/snNzxdRwx3UgfeH5rt
         EzgOogcc96FEhDQibLcTs+pcSSappI79D15qtkoBs5fH+fLS8cBc4om7jN0aHr6yu0
         2qbUdg5eQ9UmZpvANtYDefDb7Aj3aShdH0iQJikE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.14 190/849] iio: buffer: check return value of kstrdup_const()
Date:   Mon, 15 Nov 2021 17:54:33 +0100
Message-Id: <20211115165426.615790136@linuxfoundation.org>
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

commit 2c0ad3f0cc04dec489552a21b80cd6d708bea96d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-buffer.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1311,6 +1311,11 @@ static struct attribute *iio_buffer_wrap
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


