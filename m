Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E05A64BE538
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351464AbiBUQ7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 11:59:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350922AbiBUQ7V (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 21 Feb 2022 11:59:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8B422BC6
        for <Stable@vger.kernel.org>; Mon, 21 Feb 2022 08:58:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E13CC612A3
        for <Stable@vger.kernel.org>; Mon, 21 Feb 2022 16:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0DFC340E9;
        Mon, 21 Feb 2022 16:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645462737;
        bh=RyyxlxVK9vOfACA0ss78p5ixcKal7JokuLX8d6VHmA8=;
        h=Subject:To:From:Date:From;
        b=UqAK/hRjByzA2Z/xRS5ujsZMOQ6Oq4Zpx94UCC9urdmSfoaM30xF3WirXsmcSKFhh
         UAolF+gOisbf/ZgVa5ZOI0ZFgoUGNJoNHAwcdcp8jqv9M8CJW8JX9hde/ZQqB5aqpU
         NxlVuXF9GyULVPNHuJMckAirqI8FuyQrMjGDJM4M=
Subject: patch "iio: adc: men_z188_adc: Fix a resource leak in an error handling path" added to char-misc-linus
To:     christophe.jaillet@wanadoo.fr, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Feb 2022 17:58:42 +0100
Message-ID: <1645462722135148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: men_z188_adc: Fix a resource leak in an error handling path

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e0a2e37f303828d030a83f33ffe14b36cb88d563 Mon Sep 17 00:00:00 2001
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sat, 29 Jan 2022 09:32:47 +0100
Subject: iio: adc: men_z188_adc: Fix a resource leak in an error handling path

If iio_device_register() fails, a previous ioremap() is left unbalanced.

Update the error handling path and add the missing iounmap() call, as
already done in the remove function.

Fixes: 74aeac4da66f ("iio: adc: Add MEN 16z188 ADC driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/320fc777863880247c2aff4a9d1a54ba69abf080.1643445149.git.christophe.jaillet@wanadoo.fr
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/men_z188_adc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/men_z188_adc.c b/drivers/iio/adc/men_z188_adc.c
index 42ea8bc7e780..adc5ceaef8c9 100644
--- a/drivers/iio/adc/men_z188_adc.c
+++ b/drivers/iio/adc/men_z188_adc.c
@@ -103,6 +103,7 @@ static int men_z188_probe(struct mcb_device *dev,
 	struct z188_adc *adc;
 	struct iio_dev *indio_dev;
 	struct resource *mem;
+	int ret;
 
 	indio_dev = devm_iio_device_alloc(&dev->dev, sizeof(struct z188_adc));
 	if (!indio_dev)
@@ -128,8 +129,14 @@ static int men_z188_probe(struct mcb_device *dev,
 	adc->mem = mem;
 	mcb_set_drvdata(dev, indio_dev);
 
-	return iio_device_register(indio_dev);
+	ret = iio_device_register(indio_dev);
+	if (ret)
+		goto err_unmap;
+
+	return 0;
 
+err_unmap:
+	iounmap(adc->base);
 err:
 	mcb_release_mem(mem);
 	return -ENXIO;
-- 
2.35.1


