Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A8768D5D3
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 12:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjBGLl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 06:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbjBGLl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 06:41:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19072CA07
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 03:41:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99B75B81615
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 11:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC27FC433D2;
        Tue,  7 Feb 2023 11:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675770106;
        bh=4zECAcROqQyRCTNbeoomOROQrwycwav9vids/XRBzkM=;
        h=Subject:To:Cc:From:Date:From;
        b=HwGAS9h63pJSCBu5u8oUB27nsio64c0raJTu6Nn6wx8pga8A+zTBEFxW0sVycIl/G
         iNCzp0kYY7HcmpTuXnxPVtFQS3P48DYUx34dpz8FRf5usvKvJqK4a7D2XlicVttB+L
         ybUUwmzWoev+lB4hX+Qmy4/ktYd7H/DxzAQrch0E=
Subject: FAILED: patch "[PATCH] iio:adc:twl6030: Enable measurement of VAC" failed to apply to 5.4-stable tree
To:     andreas@kemnade.info, Jonathan.Cameron@huawei.com,
        julia.lawall@lip6.fr, lkp@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Feb 2023 12:41:35 +0100
Message-ID: <167577009523182@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

bffb7d9d1a3d ("iio:adc:twl6030: Enable measurement of VAC")
f804bd0dc286 ("iio:adc:twl6030: Enable measurements of VUSB, VBAT and others")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bffb7d9d1a3dbd09e083b88aefd093b3b10abbfb Mon Sep 17 00:00:00 2001
From: Andreas Kemnade <andreas@kemnade.info>
Date: Sat, 17 Dec 2022 23:13:05 +0100
Subject: [PATCH] iio:adc:twl6030: Enable measurement of VAC

VAC needs to be wired up to produce proper measurements,
without this change only near zero values are reported.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Fixes: 1696f36482e7 ("iio: twl6030-gpadc: TWL6030, TWL6032 GPADC driver")
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://lore.kernel.org/r/20221217221305.671117-1-andreas@kemnade.info
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/adc/twl6030-gpadc.c b/drivers/iio/adc/twl6030-gpadc.c
index 40438e5b4970..32873fb5f367 100644
--- a/drivers/iio/adc/twl6030-gpadc.c
+++ b/drivers/iio/adc/twl6030-gpadc.c
@@ -952,7 +952,7 @@ static int twl6030_gpadc_probe(struct platform_device *pdev)
 	}
 
 	ret = twl_i2c_write_u8(TWL6030_MODULE_ID0,
-				VBAT_MEAS | BB_MEAS | BB_MEAS,
+				VBAT_MEAS | BB_MEAS | VAC_MEAS,
 				TWL6030_MISC1);
 	if (ret < 0) {
 		dev_err(dev, "failed to wire up inputs\n");

