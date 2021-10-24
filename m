Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF5F438887
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 13:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbhJXLSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 07:18:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231394AbhJXLSD (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sun, 24 Oct 2021 07:18:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59C3760FED;
        Sun, 24 Oct 2021 11:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635074142;
        bh=dR6FtMwMV+c+pRjHwiP4EG+FzsJFYXkdKnO/jXwyd0A=;
        h=Subject:To:From:Date:From;
        b=KV9RSjiDVkkLjW2f8cU5xY/IR32+I2hKFPO0y1oSD72s6c08BgesGFwamm0gyx3+n
         G8f9+6CzHTJqF+Ai8H7ctJsmztYhNLYqWmH/lIyNKTHdKptCO/1Lj1xd373oE3eDHg
         xT6gaTMoWy3Ph6OXosaaZkK8iLN+TpngpNnP8DKk=
Subject: patch "iio: core: fix double free in iio_device_unregister_sysfs()" added to char-misc-next
To:     yangyingliang@huawei.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, ardeleanalex@gmail.com, hulkci@huawei.com
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Oct 2021 13:15:10 +0200
Message-ID: <16350741100230@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: core: fix double free in iio_device_unregister_sysfs()

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 19833c40d0415d6fe4340b5b9c46239abbf718f6 Mon Sep 17 00:00:00 2001
From: Yang Yingliang <yangyingliang@huawei.com>
Date: Wed, 13 Oct 2021 11:05:32 +0800
Subject: iio: core: fix double free in iio_device_unregister_sysfs()

I got the double free report:

BUG: KASAN: double-free or invalid-free in kfree+0xce/0x390
 iio_device_unregister_sysfs+0x108/0x13b [industrialio]
 iio_dev_release+0x9e/0x10e [industrialio]
 device_release+0xa5/0x240

If __iio_device_register() fails, iio_dev_opaque->groups will be freed
in error path in iio_device_unregister_sysfs(), then iio_dev_release()
will call iio_device_unregister_sysfs() again, it causes double free.
Set iio_dev_opaque->groups to NULL when it's freed to fix this double free.

Not this is a local work around for a more general mess around life time
management that will get cleaned up and should make this handling
unnecesarry.

Fixes: 32f171724e5c ("iio: core: rework iio device group creation")
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Alexandru Ardelean <ardeleanalex@gmail.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20211013030532.956133-1-yangyingliang@huawei.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/industrialio-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 48fda6a79076..3e1e86d987cc 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1600,6 +1600,7 @@ static void iio_device_unregister_sysfs(struct iio_dev *indio_dev)
 	kfree(iio_dev_opaque->chan_attr_group.attrs);
 	iio_dev_opaque->chan_attr_group.attrs = NULL;
 	kfree(iio_dev_opaque->groups);
+	iio_dev_opaque->groups = NULL;
 }
 
 static void iio_dev_release(struct device *device)
-- 
2.33.1


