Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D2037A766
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 15:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbhEKNTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 09:19:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230483AbhEKNTt (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 11 May 2021 09:19:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46BD3613CD;
        Tue, 11 May 2021 13:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620739122;
        bh=lqTgSgss4xmc03Y3rVSFgKThv9O5t6kKAVwzIA1AX6A=;
        h=Subject:To:From:Date:From;
        b=vjX0pNrLyz32YTI2PIvfK+jVOehonQlI8+Lg7JRCLu4Pk0CCHlzKpYHrLAgDUuTgS
         Q55TTzKsoe50sF2C4RMC/SwfygI9Nf3Des96AEidPdGDhmtpzhZz3Wa1PJ5snCs2C+
         OTSzdeVz89CDI34VB1rs7CbL8VuOuCiWCyv4beok=
Subject: patch "iio: core: fix ioctl handlers removal" added to staging-linus
To:     tomasz.duszynski@octakon.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, ardeleanalex@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 11 May 2021 15:18:23 +0200
Message-ID: <162073910315876@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: core: fix ioctl handlers removal

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 901f84de0e16bde10a72d7eb2f2eb73fcde8fa1a Mon Sep 17 00:00:00 2001
From: Tomasz Duszynski <tomasz.duszynski@octakon.com>
Date: Fri, 23 Apr 2021 10:02:44 +0200
Subject: iio: core: fix ioctl handlers removal

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
---
 drivers/iio/industrialio-core.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index d92c58a94fe4..9e59f5da3d28 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1926,9 +1926,6 @@ EXPORT_SYMBOL(__iio_device_register);
  **/
 void iio_device_unregister(struct iio_dev *indio_dev)
 {
-	struct iio_dev_opaque *iio_dev_opaque = to_iio_dev_opaque(indio_dev);
-	struct iio_ioctl_handler *h, *t;
-
 	cdev_device_del(&indio_dev->chrdev, &indio_dev->dev);
 
 	mutex_lock(&indio_dev->info_exist_lock);
@@ -1939,9 +1936,6 @@ void iio_device_unregister(struct iio_dev *indio_dev)
 
 	indio_dev->info = NULL;
 
-	list_for_each_entry_safe(h, t, &iio_dev_opaque->ioctl_handlers, entry)
-		list_del(&h->entry);
-
 	iio_device_wakeup_eventset(indio_dev);
 	iio_buffer_wakeup_poll(indio_dev);
 
-- 
2.31.1


