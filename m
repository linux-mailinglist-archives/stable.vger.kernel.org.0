Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB64522A70A
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 07:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725822AbgGWFq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 01:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbgGWFq3 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Thu, 23 Jul 2020 01:46:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCC4520771;
        Thu, 23 Jul 2020 05:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595483188;
        bh=TJ/3e7KSWE5FVpePLa3+N8jFH2qT2rqQMHN4519XNk8=;
        h=Subject:To:From:Date:From;
        b=ehfjFjlrApsUQ5VpJco8rKgnnUuML2fKrIGi3HJ6nAgw1I3XJFdZyvLolX1AABeGl
         YUuj5yOwVT2gIrdjXdKjOLGMftfl+yjgAYSHc2oHkYw/+P/AH2YuglBdmGxwaxBiuo
         MtfJpWdT82ioRZ+71HTl0RWi+0uhFCRAdrs3jsY4=
Subject: patch "iio: dac: ad5592r: fix unbalanced mutex unlocks in ad5592r_read_raw()" added to staging-next
To:     alexandru.ardelean@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, charles.stanhope@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 Jul 2020 07:44:00 +0200
Message-ID: <159548304093168@kroah.com>
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
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


