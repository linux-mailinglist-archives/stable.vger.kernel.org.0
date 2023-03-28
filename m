Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4836CBDC2
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 13:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjC1LcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 07:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjC1LcD (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 28 Mar 2023 07:32:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75B483DB
        for <Stable@vger.kernel.org>; Tue, 28 Mar 2023 04:31:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE513B817B1
        for <Stable@vger.kernel.org>; Tue, 28 Mar 2023 11:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E52C433EF;
        Tue, 28 Mar 2023 11:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680003098;
        bh=ZSgzedDo5MhoB5ujj7z8iSP3zGdGWXzx+o4q6vh/2tc=;
        h=Subject:To:From:Date:From;
        b=Wb370PLgUu2XQjAsdA0g3x8gB8e80uK4qYjFl/e+xn0iE2lg4I94y1VF5eGRtMtER
         +CfBx+Net8nE7goPW4ywgenE/StRbHXvSIIQ8Mwn+46ZlNfR4pbzBnSal0asts/Xhc
         8hSA9ypYCvgeNRq914/8qY2Q7pw24KL5zAW2r+H0=
Subject: patch "iio: buffer: make sure O_NONBLOCK is respected" added to char-misc-linus
To:     nuno.sa@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, lars@metafoo.de
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 13:31:27 +0200
Message-ID: <16800030871100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: buffer: make sure O_NONBLOCK is respected

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3da1814184582ed0faf039275a3f02e6f69944ee Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Date: Thu, 16 Feb 2023 11:14:51 +0100
Subject: iio: buffer: make sure O_NONBLOCK is respected
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

For output buffers, there's no guarantee that the buffer won't be full
in the first iteration of the loop in which case we would block
independently of userspace passing O_NONBLOCK or not. Fix it by always
checking the flag before going to sleep.

While at it (and as it's a bit related), refactored the loop so that the
stop condition is 'written != n', i.e, run the loop until all data has
been copied into the IIO buffers. This makes the code a bit simpler.

Fixes: 9eeee3b0bf190 ("iio: Add output buffer support")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/r/20230216101452.591805-3-nuno.sa@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/industrialio-buffer.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index 6340d8e1430b..a7a080bed180 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -203,21 +203,24 @@ static ssize_t iio_buffer_write(struct file *filp, const char __user *buf,
 				break;
 			}
 
+			if (filp->f_flags & O_NONBLOCK) {
+				if (!written)
+					ret = -EAGAIN;
+				break;
+			}
+
 			wait_woken(&wait, TASK_INTERRUPTIBLE,
 					MAX_SCHEDULE_TIMEOUT);
 			continue;
 		}
 
 		ret = rb->access->write(rb, n - written, buf + written);
-		if (ret == 0 && (filp->f_flags & O_NONBLOCK))
-			ret = -EAGAIN;
+		if (ret < 0)
+			break;
 
-		if (ret > 0) {
-			written += ret;
-			if (written != n && !(filp->f_flags & O_NONBLOCK))
-				continue;
-		}
-	} while (ret == 0);
+		written += ret;
+
+	} while (written != n);
 	remove_wait_queue(&rb->pollq, &wait);
 
 	return ret < 0 ? ret : written;
-- 
2.40.0


