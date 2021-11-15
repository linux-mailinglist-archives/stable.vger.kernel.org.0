Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C00C94521BE
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352313AbhKPBGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:06:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245418AbhKOTUc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76DB9632DD;
        Mon, 15 Nov 2021 18:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001257;
        bh=2EB5byPxcAuX5c/jOnmo+iZb51flVzpcuOiBYf9dOA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yAMwMuj085Q2rhyM6EMth/mpXmskVu/s/rxAtSjWTv6ocwJO54ma0E4oXfFUHMFUn
         EOm79lv5UOsMzmsh0B983xQLYbiuITGYW63dOja9bfWNyeFmFGuy6/4vwgSlP1tkV0
         pnjuEbgeoCPtaCaUO97Q652YI0w3P2hSN6F5LyRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 120/917] iio: core: check return value when calling dev_set_name()
Date:   Mon, 15 Nov 2021 17:53:35 +0100
Message-Id: <20211115165432.812076670@linuxfoundation.org>
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

commit fe6f45f6ba22d625a8500cbad0237c60dd3117ee upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-core.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1665,7 +1665,13 @@ struct iio_dev *iio_device_alloc(struct
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
 


