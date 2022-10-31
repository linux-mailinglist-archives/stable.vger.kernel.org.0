Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8428A61302A
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 07:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiJaGJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 02:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiJaGJA (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 31 Oct 2022 02:09:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3685B25C3
        for <Stable@vger.kernel.org>; Sun, 30 Oct 2022 23:08:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6F8260FCE
        for <Stable@vger.kernel.org>; Mon, 31 Oct 2022 06:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA9FC433D6;
        Mon, 31 Oct 2022 06:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667196538;
        bh=QfvI9IHnoY1vT/Hl4iJlpSuIlTurj6BAYKzndlMsuec=;
        h=Subject:To:Cc:From:Date:From;
        b=MIJnGLByYWsQI4l16rZhEKaJB2kK68jiaqhr81D6nU+SqKsqOVZISes5ysJ8rAEgo
         7FdAvtSqq8K1OCMz6SaiuVMoxL7RFSs0aLn400DSPHs3SLzDVZt3B05MT5zHQTkfVX
         K7syeHVE9tambps3NVsDyyHyHRMyrdKKe/Kkoikk=
Subject: FAILED: patch "[PATCH] iio: adc: stm32-adc: fix channel sampling time init" failed to apply to 6.0-stable tree
To:     olivier.moysan@foss.st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andy.shevchenko@gmail.com,
        fabrice.gasnier@foss.st.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Oct 2022 07:09:54 +0100
Message-ID: <16671965943532@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

174dac5dc800 ("iio: adc: stm32-adc: fix channel sampling time init")
d7705f35448a ("iio: adc: stm32-adc: convert to device properties")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 174dac5dc800e4e2e4552baf6340846a344d01a3 Mon Sep 17 00:00:00 2001
From: Olivier Moysan <olivier.moysan@foss.st.com>
Date: Wed, 12 Oct 2022 16:21:58 +0200
Subject: [PATCH] iio: adc: stm32-adc: fix channel sampling time init

Fix channel init for ADC generic channel bindings.
In generic channel initialization, stm32_adc_smpr_init() is called to
initialize channel sampling time. The "st,min-sample-time-ns" property
is an optional property. If it is not defined, stm32_adc_smpr_init() is
currently skipped.
However stm32_adc_smpr_init() must always be called, to force a minimum
sampling time for the internal channels, as the minimum sampling time is
known. Make stm32_adc_smpr_init() call unconditional.

Fixes: 796e5d0b1e9b ("iio: adc: stm32-adc: use generic binding for sample-time")
Signed-off-by: Olivier Moysan <olivier.moysan@foss.st.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20221012142205.13041-2-olivier.moysan@foss.st.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/adc/stm32-adc.c b/drivers/iio/adc/stm32-adc.c
index 6256977eb7f7..3cda529f081d 100644
--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -2086,18 +2086,19 @@ static int stm32_adc_generic_chan_init(struct iio_dev *indio_dev,
 		stm32_adc_chan_init_one(indio_dev, &channels[scan_index], val,
 					vin[1], scan_index, differential);
 
+		val = 0;
 		ret = fwnode_property_read_u32(child, "st,min-sample-time-ns", &val);
 		/* st,min-sample-time-ns is optional */
-		if (!ret) {
-			stm32_adc_smpr_init(adc, channels[scan_index].channel, val);
-			if (differential)
-				stm32_adc_smpr_init(adc, vin[1], val);
-		} else if (ret != -EINVAL) {
+		if (ret && ret != -EINVAL) {
 			dev_err(&indio_dev->dev, "Invalid st,min-sample-time-ns property %d\n",
 				ret);
 			goto err;
 		}
 
+		stm32_adc_smpr_init(adc, channels[scan_index].channel, val);
+		if (differential)
+			stm32_adc_smpr_init(adc, vin[1], val);
+
 		scan_index++;
 	}
 

