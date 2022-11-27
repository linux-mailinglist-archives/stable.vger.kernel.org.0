Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA0D639B3F
	for <lists+stable@lfdr.de>; Sun, 27 Nov 2022 15:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiK0OJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Nov 2022 09:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiK0OJS (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 27 Nov 2022 09:09:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA92CBF53
        for <Stable@vger.kernel.org>; Sun, 27 Nov 2022 06:09:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61DDE60D28
        for <Stable@vger.kernel.org>; Sun, 27 Nov 2022 14:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54152C433D6;
        Sun, 27 Nov 2022 14:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669558156;
        bh=QykoJ/4GscIqabKWDSW1uzTrsYg3is7s2o+2WE7IHwM=;
        h=Subject:To:From:Date:From;
        b=VLo+9QDkgAh11136VXncHJHCQg6fx37RhZ3GtjQ8MJr5TrOQ6qWP+4qtkpwxGut9e
         mQUECS5KD7SeBuDMa2wJBnu01Tuq5SxU31/fg+aMpV2xD4ZWyLRW7wgx++MgREwO7C
         E4RR9APVtQUcmrwct4S7c+qxhxQkZHmIOkar7f9Y=
Subject: patch "iio: adc128s052: add proper .data members in adc128_of_match table" added to char-misc-next
To:     linux@rasmusvillemoes.dk, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andriy.shevchenko@linux.intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Nov 2022 14:49:35 +0100
Message-ID: <166955697518270@kroah.com>
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
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


