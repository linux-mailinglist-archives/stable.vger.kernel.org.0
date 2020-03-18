Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A101618993C
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 11:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbgCRKYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 06:24:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgCRKYg (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 18 Mar 2020 06:24:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E85920776;
        Wed, 18 Mar 2020 10:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584527075;
        bh=ZWsY9vjgD81jlskDkJUrqlAbFlYDddBMnB7tb9NgWTE=;
        h=Subject:To:From:Date:From;
        b=RHr2WG1c+vTX+MgRhlEGXwi6tUTxN14iNziFpdFPQ3FjE2iusybxio442hYGJ1udF
         SPj1Ov0/rUCGwPIQUE5eWR7hBup9SAf5a+mroXiUYQT/fFlaxJrKlUXK6zGIO23N5V
         aNbTg9tpIE/w7+FhKjNJk+klIE3nEdZxRjd99LXg=
Subject: patch "iio: light: vcnl4000: update sampling periods for vcnl4040" added to staging-linus
To:     tomas@novotny.cz, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, agx@sigxcpu.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 18 Mar 2020 11:24:20 +0100
Message-ID: <1584527060234140@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: light: vcnl4000: update sampling periods for vcnl4040

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 2ca5a8792d617b4035aacd0a8be527f667fbf912 Mon Sep 17 00:00:00 2001
From: Tomas Novotny <tomas@novotny.cz>
Date: Tue, 18 Feb 2020 16:44:51 +0100
Subject: iio: light: vcnl4000: update sampling periods for vcnl4040
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Vishay has published a new version of "Designing the VCNL4200 Into an
Application" application note in October 2019. The new version specifies
that there is +-20% of part to part tolerance. Although the application
note is related to vcnl4200, according to support the vcnl4040's "ASIC
is quite similar to that one for the VCNL4200".

So update the sampling periods (and comment), including the correct
sampling period for proximity. Both sampling periods are lower. Users
relying on the blocking behaviour of reading will get proximity
measurements much earlier.

Fixes: 5a441aade5b3 ("iio: light: vcnl4000 add support for the VCNL4040 proximity and light sensor")
Reviewed-by: Guido Günther <agx@sigxcpu.org>
Tested-by: Guido Günther <agx@sigxcpu.org>
Signed-off-by: Tomas Novotny <tomas@novotny.cz>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/light/vcnl4000.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/light/vcnl4000.c b/drivers/iio/light/vcnl4000.c
index 98428bf430bd..e5b00a6611ac 100644
--- a/drivers/iio/light/vcnl4000.c
+++ b/drivers/iio/light/vcnl4000.c
@@ -174,9 +174,10 @@ static int vcnl4200_init(struct vcnl4000_data *data)
 		data->al_scale = 24000;
 		break;
 	case VCNL4040_PROD_ID:
-		/* Integration time is 80ms, add 10ms. */
-		data->vcnl4200_al.sampling_rate = ktime_set(0, 100000 * 1000);
-		data->vcnl4200_ps.sampling_rate = ktime_set(0, 100000 * 1000);
+		/* Default wait time is 80ms, add 20% tolerance. */
+		data->vcnl4200_al.sampling_rate = ktime_set(0, 96000 * 1000);
+		/* Default wait time is 5ms, add 20% tolerance. */
+		data->vcnl4200_ps.sampling_rate = ktime_set(0, 6000 * 1000);
 		data->al_scale = 120000;
 		break;
 	}
-- 
2.25.1


