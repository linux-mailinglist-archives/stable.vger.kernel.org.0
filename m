Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFD374845
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 09:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388171AbfGYHhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 03:37:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388161AbfGYHhG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 03:37:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B9D222CBC;
        Thu, 25 Jul 2019 07:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564040224;
        bh=E52RkBMTOjMJmxAT8C/pHEX166iX+FWpvhrLFiL4Xwo=;
        h=Subject:To:From:Date:From;
        b=wW9NgtVu1s+RoJU7iTHf5nR7BWCo0grH6jW64aL5X+fj+rIHROeSBKhZy2DuNac+y
         0SKjbu0OqPOZj5Yy+3zB6ft0opxcdy3BVfCkcP+OdAa21vdsV4gZhl7suE2bWZU+3v
         EzLP+YEOhvuLoLTq0FhrlLmSM3lsN+6a07EqE2XU=
Subject: patch "Staging: fbtft: Fix probing of gpio descriptor" added to staging-linus
To:     preid@electromag.com.au, gregkh@linuxfoundation.org,
        linux@jaseg.net, nsaenzjulienne@suse.de, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 25 Jul 2019 09:37:02 +0200
Message-ID: <1564040222147242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Staging: fbtft: Fix probing of gpio descriptor

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From dbc4f989c878fe101fb7920e9609e8ec44e097cd Mon Sep 17 00:00:00 2001
From: Phil Reid <preid@electromag.com.au>
Date: Tue, 16 Jul 2019 08:24:36 +0800
Subject: Staging: fbtft: Fix probing of gpio descriptor
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Conversion to use gpio descriptors broke all gpio lookups as
devm_gpiod_get_index was converted to use dev->driver->name for
the gpio name lookup. Fix this by using the name param. In
addition gpiod_get post-fixes the -gpios to the name so that
shouldn't be included in the call. However this then breaks the
of_find_property call to see if the gpio entry exists as all
fbtft treats all gpios as optional. So use devm_gpiod_get_index_optional
instead which achieves the same thing and is simpler.

Nishad confirmed the changes where only ever compile tested.

Fixes: c440eee1a7a1 ("Staging: fbtft: Switch to the gpio descriptor interface")
Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Tested-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Tested-by: Jan Sebastian Götte <linux@jaseg.net>
Signed-off-by: Phil Reid <preid@electromag.com.au>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1563236677-5045-2-git-send-email-preid@electromag.com.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/fbtft/fbtft-core.c | 39 ++++++++++++++----------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/fbtft/fbtft-core.c b/drivers/staging/fbtft/fbtft-core.c
index 7cbc1bdd2d8a..b963cccdc3f6 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -76,21 +76,18 @@ static int fbtft_request_one_gpio(struct fbtft_par *par,
 				  struct gpio_desc **gpiop)
 {
 	struct device *dev = par->info->device;
-	struct device_node *node = dev->of_node;
 	int ret = 0;
 
-	if (of_find_property(node, name, NULL)) {
-		*gpiop = devm_gpiod_get_index(dev, dev->driver->name, index,
-					      GPIOD_OUT_HIGH);
-		if (IS_ERR(*gpiop)) {
-			ret = PTR_ERR(*gpiop);
-			dev_err(dev,
-				"Failed to request %s GPIO:%d\n", name, ret);
-			return ret;
-		}
-		fbtft_par_dbg(DEBUG_REQUEST_GPIOS, par, "%s: '%s' GPIO\n",
-			      __func__, name);
+	*gpiop = devm_gpiod_get_index_optional(dev, name, index,
+					       GPIOD_OUT_HIGH);
+	if (IS_ERR(*gpiop)) {
+		ret = PTR_ERR(*gpiop);
+		dev_err(dev,
+			"Failed to request %s GPIO: %d\n", name, ret);
+		return ret;
 	}
+	fbtft_par_dbg(DEBUG_REQUEST_GPIOS, par, "%s: '%s' GPIO\n",
+		      __func__, name);
 
 	return ret;
 }
@@ -103,34 +100,34 @@ static int fbtft_request_gpios_dt(struct fbtft_par *par)
 	if (!par->info->device->of_node)
 		return -EINVAL;
 
-	ret = fbtft_request_one_gpio(par, "reset-gpios", 0, &par->gpio.reset);
+	ret = fbtft_request_one_gpio(par, "reset", 0, &par->gpio.reset);
 	if (ret)
 		return ret;
-	ret = fbtft_request_one_gpio(par, "dc-gpios", 0, &par->gpio.dc);
+	ret = fbtft_request_one_gpio(par, "dc", 0, &par->gpio.dc);
 	if (ret)
 		return ret;
-	ret = fbtft_request_one_gpio(par, "rd-gpios", 0, &par->gpio.rd);
+	ret = fbtft_request_one_gpio(par, "rd", 0, &par->gpio.rd);
 	if (ret)
 		return ret;
-	ret = fbtft_request_one_gpio(par, "wr-gpios", 0, &par->gpio.wr);
+	ret = fbtft_request_one_gpio(par, "wr", 0, &par->gpio.wr);
 	if (ret)
 		return ret;
-	ret = fbtft_request_one_gpio(par, "cs-gpios", 0, &par->gpio.cs);
+	ret = fbtft_request_one_gpio(par, "cs", 0, &par->gpio.cs);
 	if (ret)
 		return ret;
-	ret = fbtft_request_one_gpio(par, "latch-gpios", 0, &par->gpio.latch);
+	ret = fbtft_request_one_gpio(par, "latch", 0, &par->gpio.latch);
 	if (ret)
 		return ret;
 	for (i = 0; i < 16; i++) {
-		ret = fbtft_request_one_gpio(par, "db-gpios", i,
+		ret = fbtft_request_one_gpio(par, "db", i,
 					     &par->gpio.db[i]);
 		if (ret)
 			return ret;
-		ret = fbtft_request_one_gpio(par, "led-gpios", i,
+		ret = fbtft_request_one_gpio(par, "led", i,
 					     &par->gpio.led[i]);
 		if (ret)
 			return ret;
-		ret = fbtft_request_one_gpio(par, "aux-gpios", i,
+		ret = fbtft_request_one_gpio(par, "aux", i,
 					     &par->gpio.aux[i]);
 		if (ret)
 			return ret;
-- 
2.22.0


