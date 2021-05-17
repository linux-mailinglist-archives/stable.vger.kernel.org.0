Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0462383727
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244711AbhEQPki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:40:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244102AbhEQPih (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:38:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D06F61D10;
        Mon, 17 May 2021 14:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262448;
        bh=2JWOO0nh13YmWzLG2VTpumpq0eEZ77ksqcT5BxbVjQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xFvg8MHlO/CLpJV9hgikPcrw6/Y+XbhIRMSvhryxWE5dzR2Tlw4iA6z47pFQOta0E
         u4AXucWHv5EpxFGE2bM6aT0orRKF5SWQGy6TrDjDx9GnuFdnMAQdQPTaFyJf/KuRlp
         KlnOsp7S8EunNSwSiuMgmkOdc/h92A5T3yFxRuZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tomasz Duszynski <tomasz.duszynski@octakon.com>,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.11 293/329] iio: core: fix ioctl handlers removal
Date:   Mon, 17 May 2021 16:03:24 +0200
Message-Id: <20210517140312.013646863@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomasz Duszynski <tomasz.duszynski@octakon.com>

commit 901f84de0e16bde10a72d7eb2f2eb73fcde8fa1a upstream.

Currently ioctl handlers are removed twice. For the first time during
iio_device_unregister() then later on inside
iio_device_unregister_eventset() and iio_buffers_free_sysfs_and_mask().
Double free leads to kernel panic.

Fix this by not touching ioctl handlers list directly but rather
letting code responsible for registration call the matching cleanup
routine itself.

Fixes: 8dedcc3eee3ac ("iio: core: centralize ioctl() calls to the main chardev")
Signed-off-by: Tomasz Duszynski <tomasz.duszynski@octakon.com>
Acked-by: Alexandru Ardelean <ardeleanalex@gmail.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210423080244.2790-1-tomasz.duszynski@octakon.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-core.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1827,9 +1827,6 @@ EXPORT_SYMBOL(__iio_device_register);
  **/
 void iio_device_unregister(struct iio_dev *indio_dev)
 {
-	struct iio_dev_opaque *iio_dev_opaque = to_iio_dev_opaque(indio_dev);
-	struct iio_ioctl_handler *h, *t;
-
 	cdev_device_del(&indio_dev->chrdev, &indio_dev->dev);
 
 	mutex_lock(&indio_dev->info_exist_lock);
@@ -1840,9 +1837,6 @@ void iio_device_unregister(struct iio_de
 
 	indio_dev->info = NULL;
 
-	list_for_each_entry_safe(h, t, &iio_dev_opaque->ioctl_handlers, entry)
-		list_del(&h->entry);
-
 	iio_device_wakeup_eventset(indio_dev);
 	iio_buffer_wakeup_poll(indio_dev);
 


