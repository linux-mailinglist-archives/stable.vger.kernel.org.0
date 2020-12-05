Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8832CFD94
	for <lists+stable@lfdr.de>; Sat,  5 Dec 2020 19:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgLESjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Dec 2020 13:39:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:33374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726839AbgLESj1 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sat, 5 Dec 2020 13:39:27 -0500
Subject: patch "iio:adc:ti-ads124s08: Fix buffer being too long." added to staging-next
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607183284;
        bh=58hH3tBv97I1yXdlI30/dLs2jNQi9Ax70gmtwmAD7dc=;
        h=To:From:Date:From;
        b=nmfD+ToiodkC9+aXgleWoXPLxApkJbF2WvhX5ZNJjUYO58ru5/1eqNCaiXRXrkaj6
         ZusYoMJoMCmx98M9KzibhXeUEBrleUg/cUwCpJwJRfprOMN2VNRMERdYzKCkQ1tBHR
         B8Kpw75bSq1+0OAZmx4QFaKQ3zATZlzo7hnr7u34=
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        alexandru.ardelean@analog.com, dmurphy@ti.com
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Dec 2020 16:46:05 +0100
Message-ID: <160718316577165@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:adc:ti-ads124s08: Fix buffer being too long.

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From b0bd27f02d768e3a861c4e6c27f8e369720e6c25 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Sun, 20 Sep 2020 12:27:41 +0100
Subject: iio:adc:ti-ads124s08: Fix buffer being too long.

The buffer is expressed as a u32 array, yet the extra space for
the s64 timestamp was expressed as sizeof(s64)/sizeof(u16).
This will result in 2 extra u32 elements.
Fix by dividing by sizeof(u32).

Fixes: e717f8c6dfec ("iio: adc: Add the TI ads124s08 ADC code")
Signed-off-by: Jonathan Cameron<Jonathan.Cameron@huawei.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: Dan Murphy <dmurphy@ti.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200920112742.170751-8-jic23@kernel.org
---
 drivers/iio/adc/ti-ads124s08.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ti-ads124s08.c b/drivers/iio/adc/ti-ads124s08.c
index 4b4fbe33930c..eff4f9a9898e 100644
--- a/drivers/iio/adc/ti-ads124s08.c
+++ b/drivers/iio/adc/ti-ads124s08.c
@@ -269,7 +269,7 @@ static irqreturn_t ads124s_trigger_handler(int irq, void *p)
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct ads124s_private *priv = iio_priv(indio_dev);
-	u32 buffer[ADS124S08_MAX_CHANNELS + sizeof(s64)/sizeof(u16)];
+	u32 buffer[ADS124S08_MAX_CHANNELS + sizeof(s64)/sizeof(u32)];
 	int scan_index, j = 0;
 	int ret;
 
-- 
2.29.2


