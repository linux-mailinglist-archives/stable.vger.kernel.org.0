Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF4AC189939
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 11:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbgCRKY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 06:24:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgCRKY3 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 18 Mar 2020 06:24:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB7A72077A;
        Wed, 18 Mar 2020 10:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584527067;
        bh=NAOx7zywSmrP1/EJwkl9jwJjdP0pn+5v7HQWkOes+80=;
        h=Subject:To:From:Date:From;
        b=ZNL1nCSeuGwUdbyZwnHZDuBgpuKA6RDbAM4E5Tp7HS/7VkU1+gvP0/vqog0s/CmoJ
         7Ghm3dKOPojbDVI6UlGLz8waMKU47WNbG1UYmMjZ72ECa6/9UoSV6PZFDkipfLmlJo
         JEFCTcZR3v7irxkrcI+0H0G9mNQ0h3yWRMYDYXxU=
Subject: patch "iio: magnetometer: ak8974: Fix negative raw values in sysfs" added to staging-linus
To:     stephan@gerhold.net, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, linus.walleij@linaro.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 18 Mar 2020 11:24:19 +0100
Message-ID: <158452705991232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: magnetometer: ak8974: Fix negative raw values in sysfs

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b500c086e4110829a308c23e83a7cdc65b26228a Mon Sep 17 00:00:00 2001
From: Stephan Gerhold <stephan@gerhold.net>
Date: Fri, 14 Feb 2020 12:03:24 +0100
Subject: iio: magnetometer: ak8974: Fix negative raw values in sysfs
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

At the moment, reading from in_magn_*_raw in sysfs tends to return
large values around 65000, even though the output of ak8974 is actually
limited to ±32768. This happens because the value is never converted
to the signed 16-bit integer variant.

Add an explicit cast to s16 to fix this.

Fixes: 7c94a8b2ee8c ("iio: magn: add a driver for AK8974")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Linus Waleij <linus.walleij@linaro.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/magnetometer/ak8974.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/magnetometer/ak8974.c b/drivers/iio/magnetometer/ak8974.c
index fc7e910f8e8b..d32996702110 100644
--- a/drivers/iio/magnetometer/ak8974.c
+++ b/drivers/iio/magnetometer/ak8974.c
@@ -564,7 +564,7 @@ static int ak8974_read_raw(struct iio_dev *indio_dev,
 		 * We read all axes and discard all but one, for optimized
 		 * reading, use the triggered buffer.
 		 */
-		*val = le16_to_cpu(hw_values[chan->address]);
+		*val = (s16)le16_to_cpu(hw_values[chan->address]);
 
 		ret = IIO_VAL_INT;
 	}
-- 
2.25.1


