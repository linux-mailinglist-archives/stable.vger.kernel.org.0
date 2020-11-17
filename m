Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF032B5C3C
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 10:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725355AbgKQJwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 04:52:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:35668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727443AbgKQJwg (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 17 Nov 2020 04:52:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15427222EC;
        Tue, 17 Nov 2020 09:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605606755;
        bh=oyq6APOIpp1/Y5p7HL9no9+6a/QQOq6JFMUrEp0sx/I=;
        h=Subject:To:From:Date:From;
        b=ikBu5lQtN3LfweYjL0ekqqF05OR8dzxJgkfcUay0yFKVOFpkOq49bt7vcQXIeEaM5
         7Xzn6NATA4sitZYRP2A62RAJYB0tnWLXxj5rsunfBgtZvsaxYt1U4I7Cd0hygyes7c
         SMI47yvIg+0Js6GA80QV4WvQRZvRiQKUFDc1R3kI=
Subject: patch "iio: adc: mediatek: fix unset field" added to staging-linus
To:     fparent@baylibre.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, matthias.bgg@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 17 Nov 2020 10:53:21 +0100
Message-ID: <1605606801896@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: mediatek: fix unset field

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 15207a92e019803d62687455d8aa2ff9eb3dc82c Mon Sep 17 00:00:00 2001
From: Fabien Parent <fparent@baylibre.com>
Date: Sun, 18 Oct 2020 21:46:44 +0200
Subject: iio: adc: mediatek: fix unset field

dev_comp field is used in a couple of places but it is never set. This
results in kernel oops when dereferencing a NULL pointer. Set the
`dev_comp` field correctly in the probe function.

Fixes: 6d97024dce23 ("iio: adc: mediatek: mt6577-auxadc, add mt6765 support")
Signed-off-by: Fabien Parent <fparent@baylibre.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201018194644.3366846-1-fparent@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/mt6577_auxadc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/mt6577_auxadc.c b/drivers/iio/adc/mt6577_auxadc.c
index ac415cb089cd..79c1dd68b909 100644
--- a/drivers/iio/adc/mt6577_auxadc.c
+++ b/drivers/iio/adc/mt6577_auxadc.c
@@ -9,9 +9,9 @@
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/of.h>
-#include <linux/of_device.h>
+#include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
+#include <linux/property.h>
 #include <linux/iopoll.h>
 #include <linux/io.h>
 #include <linux/iio/iio.h>
@@ -276,6 +276,8 @@ static int mt6577_auxadc_probe(struct platform_device *pdev)
 		goto err_disable_clk;
 	}
 
+	adc_dev->dev_comp = device_get_match_data(&pdev->dev);
+
 	mutex_init(&adc_dev->lock);
 
 	mt6577_auxadc_mod_reg(adc_dev->reg_base + MT6577_AUXADC_MISC,
-- 
2.29.2


