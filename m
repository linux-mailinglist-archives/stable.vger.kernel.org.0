Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8113AB98E
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 18:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbhFQQ2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 12:28:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229741AbhFQQ2M (ORCPT <rfc822;Stable@vger.kernel.org>);
        Thu, 17 Jun 2021 12:28:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D073F61166;
        Thu, 17 Jun 2021 16:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623947163;
        bh=VyboTr2R898YuGejhfoz0AN4EzZcTJ/CJGcIxUJuPiQ=;
        h=Subject:To:From:Date:From;
        b=vnQ/hL/BLoJR4uhFIuMOMrnqi6Ou1Eop7N0Hq0JTVibqdCkPjmwSrnRwSlk/WRi8A
         LvFMMZ/YP68Hck2ogFlHyihRVqkgvlGyFbQ4gsaaFQ04+yvO++yIsH5+PMxrnS5hm6
         QeIz9OrYypgq68ZLw83TFBrBUP0lakXFvxUeOZ5M=
Subject: patch "iio: accel: bmc150: Fix bma222 scale unit" added to staging-testing
To:     stephan@gerhold.net, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, linus.walleij@linaro.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 17 Jun 2021 18:24:47 +0200
Message-ID: <162394708766126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: accel: bmc150: Fix bma222 scale unit

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 6e2a90af0b8d757e850cc023d761ee9a9492e2fe Mon Sep 17 00:00:00 2001
From: Stephan Gerhold <stephan@gerhold.net>
Date: Fri, 11 Jun 2021 10:08:54 +0200
Subject: iio: accel: bmc150: Fix bma222 scale unit

According to sysfs-bus-iio documentation the unit for accelerometer
values after applying scale/offset should be m/s^2, not g, which explains
why the scale values for the other variants in bmc150-accel do not match
exactly the values given in the datasheet.

To get the correct values, we need to multiply the BMA222 scale values
by g = 9.80665 m/s^2.

Fixes: a1a210bf29a1 ("iio: accel: bmc150-accel: Add support for BMA222")
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20210611080903.14384-2-stephan@gerhold.net
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/accel/bmc150-accel-core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/accel/bmc150-accel-core.c b/drivers/iio/accel/bmc150-accel-core.c
index a3d08d713362..a80ee0fdabc5 100644
--- a/drivers/iio/accel/bmc150-accel-core.c
+++ b/drivers/iio/accel/bmc150-accel-core.c
@@ -1145,11 +1145,12 @@ static const struct bmc150_accel_chip_info bmc150_accel_chip_info_tbl[] = {
 		/*
 		 * The datasheet page 17 says:
 		 * 15.6, 31.3, 62.5 and 125 mg per LSB.
+		 * IIO unit is m/s^2 so multiply by g = 9.80665 m/s^2.
 		 */
-		.scale_table = { {156000, BMC150_ACCEL_DEF_RANGE_2G},
-				 {313000, BMC150_ACCEL_DEF_RANGE_4G},
-				 {625000, BMC150_ACCEL_DEF_RANGE_8G},
-				 {1250000, BMC150_ACCEL_DEF_RANGE_16G} },
+		.scale_table = { {152984, BMC150_ACCEL_DEF_RANGE_2G},
+				 {306948, BMC150_ACCEL_DEF_RANGE_4G},
+				 {612916, BMC150_ACCEL_DEF_RANGE_8G},
+				 {1225831, BMC150_ACCEL_DEF_RANGE_16G} },
 	},
 	[bma222e] = {
 		.name = "BMA222E",
-- 
2.32.0


