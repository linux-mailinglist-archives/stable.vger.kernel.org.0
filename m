Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107FA639B26
	for <lists+stable@lfdr.de>; Sun, 27 Nov 2022 14:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiK0NyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Nov 2022 08:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiK0NyX (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 27 Nov 2022 08:54:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20380B86E
        for <Stable@vger.kernel.org>; Sun, 27 Nov 2022 05:54:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBB17B80937
        for <Stable@vger.kernel.org>; Sun, 27 Nov 2022 13:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3348EC433C1;
        Sun, 27 Nov 2022 13:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669557259;
        bh=SBUs8MQ61Bu+Rif6c/6gEWfkJDexYEWKKYHdsLD38e8=;
        h=Subject:To:From:Date:From;
        b=KTkVbvS28wnCgtcxWZnBaSXj5wJb9UCVc+gOYgIWVWhWaszlt/0WW5mhU+nRU4zEG
         SNwplWQxQ3tutQajFQ29tj60zaBp2GsvKLWNiPUCs6842AE3DsWwniX56079JQmieJ
         BWmdydUIouHobzPcYzv7z34JzMfxvmQVU0OqRpTs=
Subject: patch "iio: adc128s052: add proper .data members in adc128_of_match table" added to char-misc-testing
To:     linux@rasmusvillemoes.dk, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andriy.shevchenko@linux.intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Nov 2022 14:45:15 +0100
Message-ID: <166955671553132@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

    iio: adc128s052: add proper .data members in adc128_of_match table

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From e2af60f5900c6ade53477b494ffb54690eee11f5 Mon Sep 17 00:00:00 2001
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date: Tue, 15 Nov 2022 14:23:23 +0100
Subject: iio: adc128s052: add proper .data members in adc128_of_match table

Prior to commit bd5d54e4d49d ("iio: adc128s052: add ACPI _HID
AANT1280"), the driver unconditionally used spi_get_device_id() to get
the index into the adc128_config array.

However, with that commit, OF-based boards now incorrectly treat all
supported sensors as if they are an adc128s052, because all the .data
members of the adc128_of_match table are implicitly 0. Our board,
which has an adc122s021, thus exposes 8 channels whereas it really
only has two.

Fixes: bd5d54e4d49d ("iio: adc128s052: add ACPI _HID AANT1280")
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20221115132324.1078169-1-linux@rasmusvillemoes.dk
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/ti-adc128s052.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/adc/ti-adc128s052.c b/drivers/iio/adc/ti-adc128s052.c
index 622fd384983c..b3d5b9b7255b 100644
--- a/drivers/iio/adc/ti-adc128s052.c
+++ b/drivers/iio/adc/ti-adc128s052.c
@@ -181,13 +181,13 @@ static int adc128_probe(struct spi_device *spi)
 }
 
 static const struct of_device_id adc128_of_match[] = {
-	{ .compatible = "ti,adc128s052", },
-	{ .compatible = "ti,adc122s021", },
-	{ .compatible = "ti,adc122s051", },
-	{ .compatible = "ti,adc122s101", },
-	{ .compatible = "ti,adc124s021", },
-	{ .compatible = "ti,adc124s051", },
-	{ .compatible = "ti,adc124s101", },
+	{ .compatible = "ti,adc128s052", .data = (void*)0L, },
+	{ .compatible = "ti,adc122s021", .data = (void*)1L, },
+	{ .compatible = "ti,adc122s051", .data = (void*)1L, },
+	{ .compatible = "ti,adc122s101", .data = (void*)1L, },
+	{ .compatible = "ti,adc124s021", .data = (void*)2L, },
+	{ .compatible = "ti,adc124s051", .data = (void*)2L, },
+	{ .compatible = "ti,adc124s101", .data = (void*)2L, },
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, adc128_of_match);
-- 
2.38.1


