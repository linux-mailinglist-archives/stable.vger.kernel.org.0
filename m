Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31DB538D44B
	for <lists+stable@lfdr.de>; Sat, 22 May 2021 09:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhEVHvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 May 2021 03:51:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230114AbhEVHvt (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sat, 22 May 2021 03:51:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2FF7613CB;
        Sat, 22 May 2021 07:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621669825;
        bh=KGWROm5S3CXHnypNo8OoP8P7z6l/VbgN9XFMrYKpijQ=;
        h=Subject:To:From:Date:From;
        b=Qymt/F2GfNfAJkYZO3OucwyJzSo5PiZfhLuYC7+KfzmqiEpK+g1BQxPqFcIURfGy6
         ZKN+pltdR8AV7DAAPE/LYUatHIxUDDHKuPgd7GaRrrN/AjXZ7GkHNSJSpe8hx/OXaQ
         MPOz7kGO2UjsqAZAYHj1WUnAp6rHIGWUbleEZaTg=
Subject: patch "iio: adc: ad7192: Avoid disabling a clock that was never enabled." added to staging-linus
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        aardelean@deviqon.com, alexandru.tachici@analog.com,
        ardeleanalex@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 22 May 2021 09:50:18 +0200
Message-ID: <162166981816157@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: ad7192: Avoid disabling a clock that was never enabled.

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e32fe6d90f44922ccbb94016cfc3c238359e3e39 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Thu, 13 May 2021 15:07:43 +0300
Subject: iio: adc: ad7192: Avoid disabling a clock that was never enabled.

Found by inspection.

If the internal clock source is being used, the driver doesn't
call clk_prepare_enable() and as such we should not call
clk_disable_unprepare()

Use the same condition to protect the disable path as is used
on the enable one.  Note this will all get simplified when
the driver moves over to a full devm_ flow, but that would make
backporting the fix harder.

Fix obviously predates move out of staging, but backporting will
become more complex (and is unlikely to happen), hence that patch
is given in the fixes tag.

Alexandru's sign off is here because he added this patch into
a larger series that Jonathan then applied.

Fixes: b581f748cce0 ("staging: iio: adc: ad7192: move out of staging")
Cc: Alexandru Tachici <alexandru.tachici@analog.com>
Reviewed-by: Alexandru Ardelean <ardeleanalex@gmail.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Alexandru Ardelean <aardelean@deviqon.com>
Cc: <Stable@vger.kernel.org>
---
 drivers/iio/adc/ad7192.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ad7192.c b/drivers/iio/adc/ad7192.c
index 2ed580521d81..d3be67aa0522 100644
--- a/drivers/iio/adc/ad7192.c
+++ b/drivers/iio/adc/ad7192.c
@@ -1014,7 +1014,9 @@ static int ad7192_probe(struct spi_device *spi)
 	return 0;
 
 error_disable_clk:
-	clk_disable_unprepare(st->mclk);
+	if (st->clock_sel == AD7192_CLK_EXT_MCLK1_2 ||
+	    st->clock_sel == AD7192_CLK_EXT_MCLK2)
+		clk_disable_unprepare(st->mclk);
 error_remove_trigger:
 	ad_sd_cleanup_buffer_and_trigger(indio_dev);
 error_disable_dvdd:
@@ -1031,7 +1033,9 @@ static int ad7192_remove(struct spi_device *spi)
 	struct ad7192_state *st = iio_priv(indio_dev);
 
 	iio_device_unregister(indio_dev);
-	clk_disable_unprepare(st->mclk);
+	if (st->clock_sel == AD7192_CLK_EXT_MCLK1_2 ||
+	    st->clock_sel == AD7192_CLK_EXT_MCLK2)
+		clk_disable_unprepare(st->mclk);
 	ad_sd_cleanup_buffer_and_trigger(indio_dev);
 
 	regulator_disable(st->dvdd);
-- 
2.31.1


