Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C06959E3CC
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242411AbiHWMda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347509AbiHWMbT (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 23 Aug 2022 08:31:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DF3101C73
        for <Stable@vger.kernel.org>; Tue, 23 Aug 2022 02:45:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B994614E3
        for <Stable@vger.kernel.org>; Tue, 23 Aug 2022 09:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66054C433D6;
        Tue, 23 Aug 2022 09:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247867;
        bh=LF1V0gpf+HBFRuxsyC+3ST3jGW8YZAol/820ExVQRr0=;
        h=Subject:To:From:Date:From;
        b=M+jvT9KUu5W14e8bw1/BeJg6PElQ+9qvWwfToX7JmCWlD63Y845CNgzQj8fvDwhRj
         j1qFM0NEjiok/0fAzQ++o9XivzYxVuMj4hXzCAJubDuxpIdIdtQAMmyRMFnMkc1Ikj
         zCZ/8KHc2JmogRiWCMJ742nAt9ybUJqVudBQBiH8=
Subject: patch "iio: light: cm3605: Fix an error handling path in cm3605_probe()" added to char-misc-linus
To:     christophe.jaillet@wanadoo.fr, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Aug 2022 10:42:58 +0200
Message-ID: <166124417811418@kroah.com>
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

    iio: light: cm3605: Fix an error handling path in cm3605_probe()

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 160905549e663019e26395ed9d66c24ee2cf5187 Mon Sep 17 00:00:00 2001
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sun, 7 Aug 2022 08:37:43 +0200
Subject: iio: light: cm3605: Fix an error handling path in cm3605_probe()

The commit in Fixes also introduced a new error handling path which should
goto the existing error handling path.
Otherwise some resources leak.

Fixes: 0d31d91e6145 ("iio: light: cm3605: Make use of the helper function dev_err_probe()")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/0e186de2c125b3e17476ebf9c54eae4a5d66f994.1659854238.git.christophe.jaillet@wanadoo.fr
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/light/cm3605.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/light/cm3605.c b/drivers/iio/light/cm3605.c
index c721b69d5095..0b30db77f78b 100644
--- a/drivers/iio/light/cm3605.c
+++ b/drivers/iio/light/cm3605.c
@@ -226,8 +226,10 @@ static int cm3605_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return dev_err_probe(dev, irq, "failed to get irq\n");
+	if (irq < 0) {
+		ret = dev_err_probe(dev, irq, "failed to get irq\n");
+		goto out_disable_aset;
+	}
 
 	ret = devm_request_threaded_irq(dev, irq, cm3605_prox_irq,
 					NULL, 0, "cm3605", indio_dev);
-- 
2.37.2


