Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC03C6CBDC1
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 13:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjC1LcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 07:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjC1LcC (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 28 Mar 2023 07:32:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B187EFD
        for <Stable@vger.kernel.org>; Tue, 28 Mar 2023 04:31:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E554A616DE
        for <Stable@vger.kernel.org>; Tue, 28 Mar 2023 11:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E99C433D2;
        Tue, 28 Mar 2023 11:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680003101;
        bh=k1p6QlLVgnkF6iomv+3HvwjGexoQKDJ4u153c+cmXcQ=;
        h=Subject:To:From:Date:From;
        b=vgcZbm1f5GkypzoL/Gl++IU3OHejtp/UJHtJWR2kh1Tag6T6ddWygF7fxp4U53wY0
         HyN2YhZFMljoT9iyv7PNITk7lqH3GJOBvWTjU+J8cN+xQlP7EIp3LsVzDy5rqoC05/
         kDNKqM3u1OS/Q+Sdn4c8/JBWTEnupAI1Di1vv8I8=
Subject: patch "iio: buffer: correctly return bytes written in output buffers" added to char-misc-linus
To:     nuno.sa@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, lars@metafoo.de
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 13:31:27 +0200
Message-ID: <168000308763169@kroah.com>
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

    iio: buffer: correctly return bytes written in output buffers

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b5184a26a28fac1d708b0bfeeb958a9260c2924c Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Date: Thu, 16 Feb 2023 11:14:50 +0100
Subject: iio: buffer: correctly return bytes written in output buffers
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If for some reason 'rb->access->write()' does not write the full
requested data and the O_NONBLOCK is set, we would return 'n' to
userspace which is not really truth. Hence, let's return the number of
bytes we effectively wrote.

Fixes: 9eeee3b0bf190 ("iio: Add output buffer support")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/r/20230216101452.591805-2-nuno.sa@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/industrialio-buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index 80c78bd6bbef..6340d8e1430b 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -220,7 +220,7 @@ static ssize_t iio_buffer_write(struct file *filp, const char __user *buf,
 	} while (ret == 0);
 	remove_wait_queue(&rb->pollq, &wait);
 
-	return ret < 0 ? ret : n;
+	return ret < 0 ? ret : written;
 }
 
 /**
-- 
2.40.0


