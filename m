Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96372639B49
	for <lists+stable@lfdr.de>; Sun, 27 Nov 2022 15:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiK0ON0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Nov 2022 09:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiK0ONZ (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 27 Nov 2022 09:13:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62689114F
        for <Stable@vger.kernel.org>; Sun, 27 Nov 2022 06:13:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8CFF60DCC
        for <Stable@vger.kernel.org>; Sun, 27 Nov 2022 14:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C796AC433D6;
        Sun, 27 Nov 2022 14:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669558403;
        bh=FvDy1S9vJHy9Vth0ZFjJ6buKP9r9xEdXCJC9o5nwPgs=;
        h=Subject:To:From:Date:From;
        b=VirOKILOhDPgsSv9o91u5GSSfAKjWaMFcITfELWP5XfdY7n7z0aAmhSctWV8cFaWR
         U1VF10e71D42mk3wZa6SvgbKusq072w137Zx665r8P0RVvFQXbz8+UVahWErdzLTR6
         7BCf4vHwLV0bgsOcQl4omf1eXNV3KW58QPNxpU+Y=
Subject: patch "iio: adc: aspeed: Remove the trim valid dts property." added to char-misc-next
To:     billy_tsai@aspeedtech.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Nov 2022 15:06:10 +0100
Message-ID: <166955797015183@kroah.com>
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
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


