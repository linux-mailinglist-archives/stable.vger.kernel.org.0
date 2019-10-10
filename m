Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5307AD2620
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387634AbfJJJUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 05:20:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387786AbfJJJUR (ORCPT <rfc822;Stable@vger.kernel.org>);
        Thu, 10 Oct 2019 05:20:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82BF521D6C;
        Thu, 10 Oct 2019 09:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570699217;
        bh=KOSerhjE7BfL8Bq0oa13cFDygrHW3X8eLStfarCSF20=;
        h=Subject:To:From:Date:From;
        b=mhGzllBcpC3FDlfFwWFWKe//IiXJcTsIO4www7f5g7hdf4Y0uA/Cd0MkwMlOveIG8
         zRonqDIgryiGe3GaRNQnpfBOMlcniDOywcklyGNYqnlv5RjKpZTdYUH6RdopL9EMqa
         4ZArqzqAYx5SCutLvPepBAG8w5ooyKGjqjBHX3vM=
Subject: patch "iio: accel: adxl372: Fix push to buffers lost samples" added to staging-linus
To:     stefan.popa@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 10 Oct 2019 11:20:04 +0200
Message-ID: <157069920469209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: accel: adxl372: Fix push to buffers lost samples

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 62df81b74393079debf04961c48cb22268fc5fab Mon Sep 17 00:00:00 2001
From: Stefan Popa <stefan.popa@analog.com>
Date: Tue, 10 Sep 2019 17:44:21 +0300
Subject: iio: accel: adxl372: Fix push to buffers lost samples

One in two sample sets was lost by multiplying fifo_set_size with
sizeof(u16). Also, the double number of available samples were pushed to
the iio buffers.

Signed-off-by: Stefan Popa <stefan.popa@analog.com>
Fixes: f4f55ce38e5f ("iio:adxl372: Add FIFO and interrupts support")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/accel/adxl372.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iio/accel/adxl372.c b/drivers/iio/accel/adxl372.c
index 863fe61a371f..fbad4b45fe42 100644
--- a/drivers/iio/accel/adxl372.c
+++ b/drivers/iio/accel/adxl372.c
@@ -553,8 +553,7 @@ static irqreturn_t adxl372_trigger_handler(int irq, void  *p)
 			goto err;
 
 		/* Each sample is 2 bytes */
-		for (i = 0; i < fifo_entries * sizeof(u16);
-		     i += st->fifo_set_size * sizeof(u16))
+		for (i = 0; i < fifo_entries; i += st->fifo_set_size)
 			iio_push_to_buffers(indio_dev, &st->fifo_buf[i]);
 	}
 err:
-- 
2.23.0


