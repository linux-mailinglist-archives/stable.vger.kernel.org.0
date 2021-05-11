Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71AF137A768
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 15:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhEKNTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 09:19:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230483AbhEKNTy (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 11 May 2021 09:19:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5ABC613DE;
        Tue, 11 May 2021 13:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620739128;
        bh=CbTBs7lZxN2vepN7C/tNbSJkBHsX6zJUWnSNrGbaLJk=;
        h=Subject:To:From:Date:From;
        b=VxHjmbh5CfzKKCeSfxgFDHE1h9dzRSKs0uhClo34zfy3snAdbrf78Q1p2LXqAcJ8T
         gxvxUaB4ejX95z8Ehu6Yqb6Kq2AGeIuXCcMJ9g6M3X2QcDXT+J8LTYquzigDCNH0ez
         Bj52YtThrY43g45YLE23WeVNFYinfHKbf49H+iSA=
Subject: patch "iio: tsl2583: Fix division by a zero lux_val" added to staging-linus
To:     colin.king@canonical.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 11 May 2021 15:18:24 +0200
Message-ID: <1620739104010@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: tsl2583: Fix division by a zero lux_val

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From af0e1871d79cfbb91f732d2c6fa7558e45c31038 Mon Sep 17 00:00:00 2001
From: Colin Ian King <colin.king@canonical.com>
Date: Fri, 7 May 2021 19:30:41 +0100
Subject: iio: tsl2583: Fix division by a zero lux_val

The lux_val returned from tsl2583_get_lux can potentially be zero,
so check for this to avoid a division by zero and an overflowed
gain_trim_val.

Fixes clang scan-build warning:

drivers/iio/light/tsl2583.c:345:40: warning: Either the
condition 'lux_val<0' is redundant or there is division
by zero at line 345. [zerodivcond]

Fixes: ac4f6eee8fe8 ("staging: iio: TAOS tsl258x: Device driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/light/tsl2583.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iio/light/tsl2583.c b/drivers/iio/light/tsl2583.c
index 0f787bfc88fc..c9d8f07a6fcd 100644
--- a/drivers/iio/light/tsl2583.c
+++ b/drivers/iio/light/tsl2583.c
@@ -341,6 +341,14 @@ static int tsl2583_als_calibrate(struct iio_dev *indio_dev)
 		return lux_val;
 	}
 
+	/* Avoid division by zero of lux_value later on */
+	if (lux_val == 0) {
+		dev_err(&chip->client->dev,
+			"%s: lux_val of 0 will produce out of range trim_value\n",
+			__func__);
+		return -ENODATA;
+	}
+
 	gain_trim_val = (unsigned int)(((chip->als_settings.als_cal_target)
 			* chip->als_settings.als_gain_trim) / lux_val);
 	if ((gain_trim_val < 250) || (gain_trim_val > 4000)) {
-- 
2.31.1


