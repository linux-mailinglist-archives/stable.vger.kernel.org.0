Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36091638F31
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 18:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiKYRgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 12:36:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiKYRgH (ORCPT
        <rfc822;Stable@vger.kernel.org>); Fri, 25 Nov 2022 12:36:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26C551C24
        for <Stable@vger.kernel.org>; Fri, 25 Nov 2022 09:36:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E7C9B8129E
        for <Stable@vger.kernel.org>; Fri, 25 Nov 2022 17:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59F2C433C1;
        Fri, 25 Nov 2022 17:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669397763;
        bh=t4GCaUJ0ErppZTomgWbL+TqFlzvlvfKXhQ9rz3zsbDU=;
        h=Subject:To:From:Date:From;
        b=XbEWkVu7S1pWpJOaQYzAsTU2bjd8T/5Btx64j00jUfxMJ0J9WmZjhIsG4n6AvBnbe
         VPArlY9C/gjLu+hFMzc8LA/egQujXl3Xp4uWRWgDnLhjh9tgBcBHMlfxMVt9sCWud6
         wU+pQckvJro2+KGgamxSDLJwJtGDg9qMiC5CZnik=
Subject: patch "iio: adc: ad_sigma_delta: do not use internal iio_dev lock" added to char-misc-testing
To:     nuno.sa@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, miquel.raynal@bootlin.com
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Nov 2022 18:35:57 +0100
Message-ID: <166939775791237@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: ad_sigma_delta: do not use internal iio_dev lock

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 20228a1d5a55e7db0c6720840f2c7d2b48c55f69 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Date: Tue, 20 Sep 2022 13:28:07 +0200
Subject: iio: adc: ad_sigma_delta: do not use internal iio_dev lock
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Drop 'mlock' usage by making use of iio_device_claim_direct_mode().
This change actually makes sure we cannot do a single conversion while
buffering is enable. Note there was a potential race in the previous
code since we were only acquiring the lock after checking if the bus is
enabled.

Fixes: af3008485ea0 ("iio:adc: Add common code for ADI Sigma Delta devices")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: <Stable@vger.kernel.org> #No rush as race is very old.
Link: https://lore.kernel.org/r/20220920112821.975359-2-nuno.sa@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/ad_sigma_delta.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/adc/ad_sigma_delta.c b/drivers/iio/adc/ad_sigma_delta.c
index 261a9a6b45e1..d8570f620785 100644
--- a/drivers/iio/adc/ad_sigma_delta.c
+++ b/drivers/iio/adc/ad_sigma_delta.c
@@ -281,10 +281,10 @@ int ad_sigma_delta_single_conversion(struct iio_dev *indio_dev,
 	unsigned int data_reg;
 	int ret = 0;
 
-	if (iio_buffer_enabled(indio_dev))
-		return -EBUSY;
+	ret = iio_device_claim_direct_mode(indio_dev);
+	if (ret)
+		return ret;
 
-	mutex_lock(&indio_dev->mlock);
 	ad_sigma_delta_set_channel(sigma_delta, chan->address);
 
 	spi_bus_lock(sigma_delta->spi->master);
@@ -323,7 +323,7 @@ int ad_sigma_delta_single_conversion(struct iio_dev *indio_dev,
 	ad_sigma_delta_set_mode(sigma_delta, AD_SD_MODE_IDLE);
 	sigma_delta->bus_locked = false;
 	spi_bus_unlock(sigma_delta->spi->master);
-	mutex_unlock(&indio_dev->mlock);
+	iio_device_release_direct_mode(indio_dev);
 
 	if (ret)
 		return ret;
-- 
2.38.1


