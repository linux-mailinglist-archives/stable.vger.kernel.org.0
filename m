Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A328F38D44F
	for <lists+stable@lfdr.de>; Sat, 22 May 2021 09:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhEVHv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 May 2021 03:51:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230114AbhEVHv7 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sat, 22 May 2021 03:51:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51179611CB;
        Sat, 22 May 2021 07:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621669834;
        bh=cOi1Bu0tpX/E6jNHqRqpWOJ/2k7X8ksP+zuaU4qmjNs=;
        h=Subject:To:From:Date:From;
        b=GzDZXQFye89ZjLlUWhxY6irjN+sZEnHx8ellIkSe1FTXxhXmjdZm/C5KAohkJu1Gy
         ocXjGzxUZF2DW5O8WHkMgGbIevofnNpvPyXdjbI1N2zazUyzoZdSG1mEm9GRxzjhyd
         KsHOTJdE0sb7JXIYZEpfghVz7ffykX9nMt0qsYes=
Subject: patch "iio: dac: ad5770r: Put fwnode in error case during ->probe()" added to staging-linus
To:     andy.shevchenko@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, alexandru.tachici@analog.com,
        ardeleanalex@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 22 May 2021 09:50:20 +0200
Message-ID: <16216698203987@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: dac: ad5770r: Put fwnode in error case during ->probe()

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 98b7b0ca0828907dbb706387c11356a45463e2ea Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Mon, 10 May 2021 12:56:49 +0300
Subject: iio: dac: ad5770r: Put fwnode in error case during ->probe()

device_for_each_child_node() bumps a reference counting of a returned variable.
We have to balance it whenever we return to the caller.

Fixes: cbbb819837f6 ("iio: dac: ad5770r: Add AD5770R support")
Cc: Alexandru Tachici <alexandru.tachici@analog.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Alexandru Ardelean <ardeleanalex@gmail.com>
Link: https://lore.kernel.org/r/20210510095649.3302835-1-andy.shevchenko@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/dac/ad5770r.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/dac/ad5770r.c b/drivers/iio/dac/ad5770r.c
index 7ab2ccf90863..8107f7bbbe3c 100644
--- a/drivers/iio/dac/ad5770r.c
+++ b/drivers/iio/dac/ad5770r.c
@@ -524,23 +524,29 @@ static int ad5770r_channel_config(struct ad5770r_state *st)
 	device_for_each_child_node(&st->spi->dev, child) {
 		ret = fwnode_property_read_u32(child, "num", &num);
 		if (ret)
-			return ret;
-		if (num >= AD5770R_MAX_CHANNELS)
-			return -EINVAL;
+			goto err_child_out;
+		if (num >= AD5770R_MAX_CHANNELS) {
+			ret = -EINVAL;
+			goto err_child_out;
+		}
 
 		ret = fwnode_property_read_u32_array(child,
 						     "adi,range-microamp",
 						     tmp, 2);
 		if (ret)
-			return ret;
+			goto err_child_out;
 
 		min = tmp[0] / 1000;
 		max = tmp[1] / 1000;
 		ret = ad5770r_store_output_range(st, min, max, num);
 		if (ret)
-			return ret;
+			goto err_child_out;
 	}
 
+	return 0;
+
+err_child_out:
+	fwnode_handle_put(child);
 	return ret;
 }
 
-- 
2.31.1


