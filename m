Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94A61D2623
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387826AbfJJJU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 05:20:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387478AbfJJJU0 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Thu, 10 Oct 2019 05:20:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEBD021D7C;
        Thu, 10 Oct 2019 09:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570699225;
        bh=6PqdvEB1ojUb4qfw4gWyWiQvsFi6wu4CSDZzFOyMbmE=;
        h=Subject:To:From:Date:From;
        b=rnKgs6oaxvQvd4FRAmThZUpIkI5yL6tWLdH6EdLXIcRmewmkyltMyE+ns9CfhLsMI
         hlfNUrnnEvnom8NnZsCWlqngZ2qsjByrUjfe6RW/1X3iEFygVOe2CtIQsAZovF78B5
         xnVE2gVah2E8UVqjnOQ7ZdVAet8jvjWfrIe9MdnI=
Subject: patch "iio: accel: adxl372: Perform a reset at start up" added to staging-linus
To:     stefan.popa@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 10 Oct 2019 11:20:05 +0200
Message-ID: <157069920522693@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: accel: adxl372: Perform a reset at start up

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d9a997bd4d762d5bd8cc548d762902f58b5e0a74 Mon Sep 17 00:00:00 2001
From: Stefan Popa <stefan.popa@analog.com>
Date: Tue, 10 Sep 2019 17:44:46 +0300
Subject: iio: accel: adxl372: Perform a reset at start up

We need to perform a reset a start up to make sure that the chip is in a
consistent state. This reset also disables all the interrupts which
should only be enabled together with the iio buffer. Not doing this, was
sometimes causing unwanted interrupts to trigger.

Signed-off-by: Stefan Popa <stefan.popa@analog.com>
Fixes: f4f55ce38e5f ("iio:adxl372: Add FIFO and interrupts support")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/accel/adxl372.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iio/accel/adxl372.c b/drivers/iio/accel/adxl372.c
index fbad4b45fe42..67b8817995c0 100644
--- a/drivers/iio/accel/adxl372.c
+++ b/drivers/iio/accel/adxl372.c
@@ -575,6 +575,14 @@ static int adxl372_setup(struct adxl372_state *st)
 		return -ENODEV;
 	}
 
+	/*
+	 * Perform a software reset to make sure the device is in a consistent
+	 * state after start up.
+	 */
+	ret = regmap_write(st->regmap, ADXL372_RESET, ADXL372_RESET_CODE);
+	if (ret < 0)
+		return ret;
+
 	ret = adxl372_set_op_mode(st, ADXL372_STANDBY);
 	if (ret < 0)
 		return ret;
-- 
2.23.0


