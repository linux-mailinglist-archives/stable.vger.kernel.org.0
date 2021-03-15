Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3EAB33C015
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 16:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbhCOPgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 11:36:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231463AbhCOPf7 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 15 Mar 2021 11:35:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0351164E22;
        Mon, 15 Mar 2021 15:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615822559;
        bh=1dFLB9iFMPwgkyPkgtAQ80BUuAVmkU5gItnNG/Bp2yY=;
        h=Subject:To:From:Date:From;
        b=n8SO3Y18+vKzaDaZNqvWflhMec77YEBXXYRuWpX4qUUmvLPXV6vEjRggoWX/PJ5hJ
         cwG8fy/Th4ck8m6rPBxjNDYj2MjnoBW+SDUDGmjO5Rb5Kgs/Z4lpYEn2oYa/Z9Su4W
         99oNTHkezFQHHv3COZJKdYWd8tx1I8sEBTR7zAHA=
Subject: patch "iio: gyro: mpu3050: Fix error handling in mpu3050_trigger_handler" added to staging-linus
To:     dinghao.liu@zju.edu.cn, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, linus.walleij@linaro.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Mar 2021 16:35:27 +0100
Message-ID: <1615822527232108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: gyro: mpu3050: Fix error handling in mpu3050_trigger_handler

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 6dbbbe4cfd398704b72b21c1d4a5d3807e909d60 Mon Sep 17 00:00:00 2001
From: Dinghao Liu <dinghao.liu@zju.edu.cn>
Date: Mon, 1 Mar 2021 16:04:21 +0800
Subject: iio: gyro: mpu3050: Fix error handling in mpu3050_trigger_handler

There is one regmap_bulk_read() call in mpu3050_trigger_handler
that we have caught its return value bug lack further handling.
Check and terminate the execution flow just like the other three
regmap_bulk_read() calls in this function.

Fixes: 3904b28efb2c7 ("iio: gyro: Add driver for the MPU-3050 gyroscope")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20210301080421.13436-1-dinghao.liu@zju.edu.cn
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/gyro/mpu3050-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/gyro/mpu3050-core.c b/drivers/iio/gyro/mpu3050-core.c
index dfa31a23500f..ac90be03332a 100644
--- a/drivers/iio/gyro/mpu3050-core.c
+++ b/drivers/iio/gyro/mpu3050-core.c
@@ -551,6 +551,8 @@ static irqreturn_t mpu3050_trigger_handler(int irq, void *p)
 					       MPU3050_FIFO_R,
 					       &fifo_values[offset],
 					       toread);
+			if (ret)
+				goto out_trigger_unlock;
 
 			dev_dbg(mpu3050->dev,
 				"%04x %04x %04x %04x %04x\n",
-- 
2.30.2


