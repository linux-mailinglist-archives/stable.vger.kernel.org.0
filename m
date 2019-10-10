Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7323D261F
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387722AbfJJJUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 05:20:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387561AbfJJJUO (ORCPT <rfc822;Stable@vger.kernel.org>);
        Thu, 10 Oct 2019 05:20:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D39C121A4A;
        Thu, 10 Oct 2019 09:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570699214;
        bh=S2v80/QbJDBZTDSWp8kvZOUObJYj855rIGzzdfaqDoo=;
        h=Subject:To:From:Date:From;
        b=fzpIEyAfQMj9pHZyQW6ODNNoxLeGxVpIyafSlK1ZG+0YUblHKRNjFVXQtraTj8S1W
         pclXCdmj9XBfNB6fjUwzgsxwPhDoz+NRnIrDi9shaXqcZBpC9P3CSnYmt9m4JR7ND0
         okZNGOQnDe1BL3c3ICecrdMS2bY3kpUVC0n05xiU=
Subject: patch "iio: accel: adxl372: Fix/remove limitation for FIFO samples" added to staging-linus
To:     stefan.popa@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 10 Oct 2019 11:20:04 +0200
Message-ID: <1570699204135195@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: accel: adxl372: Fix/remove limitation for FIFO samples

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d202ce4787e446556c6b9d01f84734c3f8174ba3 Mon Sep 17 00:00:00 2001
From: Stefan Popa <stefan.popa@analog.com>
Date: Tue, 10 Sep 2019 17:43:32 +0300
Subject: iio: accel: adxl372: Fix/remove limitation for FIFO samples

Currently, the driver sets the FIFO_SAMPLES register with the number of
sample sets (maximum of 170 for 3 axis data, 256 for 2-axis and 512 for
single axis). However, the FIFO_SAMPLES register should store the number
of samples, regardless of how the FIFO format is configured.

Signed-off-by: Stefan Popa <stefan.popa@analog.com>
Fixes: f4f55ce38e5f ("iio:adxl372: Add FIFO and interrupts support")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/accel/adxl372.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/accel/adxl372.c b/drivers/iio/accel/adxl372.c
index 055227cb3d43..863fe61a371f 100644
--- a/drivers/iio/accel/adxl372.c
+++ b/drivers/iio/accel/adxl372.c
@@ -474,12 +474,17 @@ static int adxl372_configure_fifo(struct adxl372_state *st)
 	if (ret < 0)
 		return ret;
 
-	fifo_samples = st->watermark & 0xFF;
+	/*
+	 * watermark stores the number of sets; we need to write the FIFO
+	 * registers with the number of samples
+	 */
+	fifo_samples = (st->watermark * st->fifo_set_size);
 	fifo_ctl = ADXL372_FIFO_CTL_FORMAT_MODE(st->fifo_format) |
 		   ADXL372_FIFO_CTL_MODE_MODE(st->fifo_mode) |
-		   ADXL372_FIFO_CTL_SAMPLES_MODE(st->watermark);
+		   ADXL372_FIFO_CTL_SAMPLES_MODE(fifo_samples);
 
-	ret = regmap_write(st->regmap, ADXL372_FIFO_SAMPLES, fifo_samples);
+	ret = regmap_write(st->regmap,
+			   ADXL372_FIFO_SAMPLES, fifo_samples & 0xFF);
 	if (ret < 0)
 		return ret;
 
-- 
2.23.0


