Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0700634257
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 18:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233174AbiKVRTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 12:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbiKVRTc (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 22 Nov 2022 12:19:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB246E57C
        for <Stable@vger.kernel.org>; Tue, 22 Nov 2022 09:19:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48094617F0
        for <Stable@vger.kernel.org>; Tue, 22 Nov 2022 17:19:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361CBC433D6;
        Tue, 22 Nov 2022 17:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669137570;
        bh=c8ZeAvX/Q8kphUHhj6otflYnbgEiv0w3YzYHcsgmzHU=;
        h=Subject:To:From:Date:From;
        b=tqM7VXkroJSHyV2prZNzCwNkgyg8CDtnNXvHHKAMraTXezZD2s/08BW3yQ52znStv
         uS+gd4hSLgH4lnlPRDC3tABO8jKraaiF72OkugqPmNWGeFtIb7p/EUDXi0w5mB6F39
         UtC/M6PrEx25/lKEfkjTkeRH/7EkB4d6bu89f0tM=
Subject: patch "iio: adc: aspeed: Remove the trim valid dts property." added to char-misc-linus
To:     billy_tsai@aspeedtech.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 22 Nov 2022 18:19:06 +0100
Message-ID: <1669137546151223@kroah.com>
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

    iio: adc: aspeed: Remove the trim valid dts property.

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From fdd0d6b2eb35c83d6b1226ad20b346a4b45ddfb8 Mon Sep 17 00:00:00 2001
From: Billy Tsai <billy_tsai@aspeedtech.com>
Date: Mon, 14 Nov 2022 10:50:56 +0800
Subject: iio: adc: aspeed: Remove the trim valid dts property.

The dts property "aspeed,trim-data-valid" is currently used to determine
whether to read trimming data from the OTP register. If this is set on
a device without valid trimming data in the OTP the ADC will not function
correctly. This patch drops the use of this property and instead uses the
default (unprogrammed) OTP value of 0 to detect when a fallback value of
0x8 should be used rather then the value read from the OTP.

Fixes: d0a4c17b4073 ("iio: adc: aspeed: Get and set trimming data.")
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Link: https://lore.kernel.org/r/20221114025057.10843-1-billy_tsai@aspeedtech.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/aspeed_adc.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/adc/aspeed_adc.c b/drivers/iio/adc/aspeed_adc.c
index 9341e0e0eb55..998e8bcc06e1 100644
--- a/drivers/iio/adc/aspeed_adc.c
+++ b/drivers/iio/adc/aspeed_adc.c
@@ -202,6 +202,8 @@ static int aspeed_adc_set_trim_data(struct iio_dev *indio_dev)
 				((scu_otp) &
 				 (data->model_data->trim_locate->field)) >>
 				__ffs(data->model_data->trim_locate->field);
+			if (!trimming_val)
+				trimming_val = 0x8;
 		}
 		dev_dbg(data->dev,
 			"trimming val = %d, offset = %08x, fields = %08x\n",
@@ -563,12 +565,9 @@ static int aspeed_adc_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	if (of_find_property(data->dev->of_node, "aspeed,trim-data-valid",
-			     NULL)) {
-		ret = aspeed_adc_set_trim_data(indio_dev);
-		if (ret)
-			return ret;
-	}
+	ret = aspeed_adc_set_trim_data(indio_dev);
+	if (ret)
+		return ret;
 
 	if (of_find_property(data->dev->of_node, "aspeed,battery-sensing",
 			     NULL)) {
-- 
2.38.1


