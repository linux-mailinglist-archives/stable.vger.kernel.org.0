Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC00E438885
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 13:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhJXLSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 07:18:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231394AbhJXLR6 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sun, 24 Oct 2021 07:17:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A940160FED;
        Sun, 24 Oct 2021 11:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635074138;
        bh=NMl+2961sEHE/7x2cFKxTAuW/bHoTbDUueZxywiHckw=;
        h=Subject:To:From:Date:From;
        b=HzMxJEkDpHoY05RliqkzHk+j8itElYtsv1RgUgc3csRlyc6CzFdpGLCu+jPmgOkg/
         hCcqWUIz/8AL6qGOFnrDNP78XqjQZlMBswjEJ7CPvXUnj7zGZbt/5eoqfYheMZh0Y1
         v72rgpCE4FpKhT6JN62ctChqHKpI0RgktdBRxjIA=
Subject: patch "iio: buffer: Fix memory leak in" added to char-misc-next
To:     yangyingliang@huawei.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, hulkci@huawei.com
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Oct 2021 13:15:09 +0200
Message-ID: <163507410921167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: buffer: Fix memory leak in

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 604faf9a2ecd1addcc0c10a47e5aaef3c4d4fd6b Mon Sep 17 00:00:00 2001
From: Yang Yingliang <yangyingliang@huawei.com>
Date: Wed, 13 Oct 2021 22:42:42 +0800
Subject: iio: buffer: Fix memory leak in
 iio_buffer_register_legacy_sysfs_groups()

If the second iio_device_register_sysfs_group() fails,
'legacy_buffer_group.attrs' need be freed too or it will
cause memory leak:

unreferenced object 0xffff888003618280 (size 64):
  comm "xrun", pid 357, jiffies 4294907259 (age 22.296s)
  hex dump (first 32 bytes):
    80 f6 8c 03 80 88 ff ff 80 fb 8c 03 80 88 ff ff  ................
    00 f9 8c 03 80 88 ff ff 80 fc 8c 03 80 88 ff ff  ................
  backtrace:
    [<00000000076bfd43>] __kmalloc+0x1a3/0x2f0
    [<00000000c32e4886>] iio_buffers_alloc_sysfs_and_mask+0xc31/0x1290 [industrialio]

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: d9a625744ed0 ("iio: core: merge buffer/ & scan_elements/ attributes")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20211013144242.1685060-1-yangyingliang@huawei.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/industrialio-buffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index ae0912a14578..1c3972150ab4 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1367,10 +1367,10 @@ static int iio_buffer_register_legacy_sysfs_groups(struct iio_dev *indio_dev,
 
 	return 0;
 
-error_free_buffer_attrs:
-	kfree(iio_dev_opaque->legacy_buffer_group.attrs);
 error_free_scan_el_attrs:
 	kfree(iio_dev_opaque->legacy_scan_el_group.attrs);
+error_free_buffer_attrs:
+	kfree(iio_dev_opaque->legacy_buffer_group.attrs);
 
 	return ret;
 }
-- 
2.33.1


