Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A047356625
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 10:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238497AbhDGIL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 04:11:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233700AbhDGIL6 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 7 Apr 2021 04:11:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FE0A613A0;
        Wed,  7 Apr 2021 08:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617783109;
        bh=Ft82gTR0AUq8JDmHtAU+JR8P0AA2sZlH7MP1YGpKusg=;
        h=Subject:To:From:Date:From;
        b=Tzh79H97Doyt11ouZmsCmiRrGWRhAO8zfUSZRBjGI6t3LlQS6j04SoOeVTtc7wTL7
         g6TiItfRLzQNjF1AU/3+9ny4r/wPZ6XZ8ZiAU5oL24dWjQN9NFBXAFUjhqYB5lKS/g
         bfP/T1Kt0TqwGcUUrRvA1asEt08esjfvv48gMGkQ=
Subject: patch "iio: magnetometer: yas530: Fix return value on error path" added to staging-testing
To:     linus.walleij@linaro.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andy.shevchenko@gmail.com,
        dan.carpenter@oracle.com, lkp@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 07 Apr 2021 10:09:18 +0200
Message-ID: <161778295811932@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: magnetometer: yas530: Fix return value on error path

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From e64837bf9e2c063d6b5bab51c0554a60270f636d Mon Sep 17 00:00:00 2001
From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 15 Feb 2021 16:30:23 +0100
Subject: iio: magnetometer: yas530: Fix return value on error path

There was a missed return variable assignment in the
default errorpath of the switch statement in yas5xx_probe().
Fix it.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20210215153023.47899-1-linus.walleij@linaro.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/magnetometer/yamaha-yas530.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/magnetometer/yamaha-yas530.c b/drivers/iio/magnetometer/yamaha-yas530.c
index d46f23d82b3d..cee6207d8847 100644
--- a/drivers/iio/magnetometer/yamaha-yas530.c
+++ b/drivers/iio/magnetometer/yamaha-yas530.c
@@ -887,6 +887,7 @@ static int yas5xx_probe(struct i2c_client *i2c,
 		strncpy(yas5xx->name, "yas532", sizeof(yas5xx->name));
 		break;
 	default:
+		ret = -ENODEV;
 		dev_err(dev, "unhandled device ID %02x\n", yas5xx->devid);
 		goto assert_reset;
 	}
-- 
2.31.1


