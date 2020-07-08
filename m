Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88EA42180FB
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 09:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730056AbgGHHVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 03:21:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729340AbgGHHVd (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 8 Jul 2020 03:21:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 406DD20739;
        Wed,  8 Jul 2020 07:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594192892;
        bh=2pShBzqjZ82Yjy963fb4xKaVF40B8guoH9p7e51i8ow=;
        h=Subject:To:From:Date:From;
        b=Z/6euvl175cnPRSTitDObqk35D+opVYbirmOLZc038YMiVeClf0NBiGIyhsshOsNG
         u8mFvRrkxE2WLT89W8MIiGCbwKRHr1sSU9vz7v8GkQqjSxfKe+2OI0BTEpsatKVKrN
         9+gv85ZsEZNPGSc5H5PPsRPOChw7A9bj7EVbNRYs=
Subject: patch "iio: mma8452: Add missed iio_device_unregister() call in" added to staging-linus
To:     hslester96@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 08 Jul 2020 09:21:27 +0200
Message-ID: <159419288718859@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: mma8452: Add missed iio_device_unregister() call in

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d7369ae1f4d7cffa7574d15e1f787dcca184c49d Mon Sep 17 00:00:00 2001
From: Chuhong Yuan <hslester96@gmail.com>
Date: Thu, 28 May 2020 14:41:21 +0800
Subject: iio: mma8452: Add missed iio_device_unregister() call in
 mma8452_probe()

The function iio_device_register() was called in mma8452_probe().
But the function iio_device_unregister() was not called after
a call of the function mma8452_set_freefall_mode() failed.
Thus add the missed function call for one error case.

Fixes: 1a965d405fc6 ("drivers:iio:accel:mma8452: added cleanup provision in case of failure.")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/accel/mma8452.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/accel/mma8452.c b/drivers/iio/accel/mma8452.c
index 00e100fc845a..813bca7cfc3e 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -1685,10 +1685,13 @@ static int mma8452_probe(struct i2c_client *client,
 
 	ret = mma8452_set_freefall_mode(data, false);
 	if (ret < 0)
-		goto buffer_cleanup;
+		goto unregister_device;
 
 	return 0;
 
+unregister_device:
+	iio_device_unregister(indio_dev);
+
 buffer_cleanup:
 	iio_triggered_buffer_cleanup(indio_dev);
 
-- 
2.27.0


