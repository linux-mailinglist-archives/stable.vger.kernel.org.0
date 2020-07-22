Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A6B229AC2
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 16:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732784AbgGVO4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 10:56:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730465AbgGVO4L (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 22 Jul 2020 10:56:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5B7C20717;
        Wed, 22 Jul 2020 14:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595429771;
        bh=t5HnbZRpmNzFVzZWYAFrCQdU678h6GorLK7nRtN2ci8=;
        h=Subject:To:From:Date:From;
        b=j2x3j5+HHynhZdS6kzBIWTnd0gmiaeHqn8NSYSnXAV722Jkc820JCjh9nU6LyyNhn
         xOI8lNrmBT9vcgwdNSgGPNdLb2HlS7lI7Q7rEghAFpTPVmZVT/LASqjg733W+uMlF8
         YeaxL9IxrdRPBJVmw5S0XnbdTyNRyF97uRqLq41E=
Subject: patch "iio: dac: ad5592r: fix unbalanced mutex unlocks in ad5592r_read_raw()" added to staging-testing
To:     alexandru.ardelean@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, charles.stanhope@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 22 Jul 2020 16:54:25 +0200
Message-ID: <1595429665165219@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: dac: ad5592r: fix unbalanced mutex unlocks in ad5592r_read_raw()

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 65afb0932a81c1de719ceee0db0b276094b10ac8 Mon Sep 17 00:00:00 2001
From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Date: Mon, 6 Jul 2020 14:02:57 +0300
Subject: iio: dac: ad5592r: fix unbalanced mutex unlocks in ad5592r_read_raw()

There are 2 exit paths where the lock isn't held, but try to unlock the
mutex when exiting. In these places we should just return from the
function.

A neater approach would be to cleanup the ad5592r_read_raw(), but that
would make this patch more difficult to backport to stable versions.

Fixes 56ca9db862bf3: ("iio: dac: Add support for the AD5592R/AD5593R ADCs/DACs")
Reported-by: Charles Stanhope <charles.stanhope@gmail.com>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/dac/ad5592r-base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/dac/ad5592r-base.c b/drivers/iio/dac/ad5592r-base.c
index 5c4e5ff70380..cc4875660a69 100644
--- a/drivers/iio/dac/ad5592r-base.c
+++ b/drivers/iio/dac/ad5592r-base.c
@@ -413,7 +413,7 @@ static int ad5592r_read_raw(struct iio_dev *iio_dev,
 			s64 tmp = *val * (3767897513LL / 25LL);
 			*val = div_s64_rem(tmp, 1000000000LL, val2);
 
-			ret = IIO_VAL_INT_PLUS_MICRO;
+			return IIO_VAL_INT_PLUS_MICRO;
 		} else {
 			int mult;
 
@@ -444,7 +444,7 @@ static int ad5592r_read_raw(struct iio_dev *iio_dev,
 		ret =  IIO_VAL_INT;
 		break;
 	default:
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 
 unlock:
-- 
2.27.0


