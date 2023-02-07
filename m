Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5969D68D5D4
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 12:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbjBGLmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 06:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbjBGLl7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 06:41:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C4411E9C
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 03:41:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECBB961354
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 11:41:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015AFC4339B;
        Tue,  7 Feb 2023 11:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675770109;
        bh=KKqPdcmdIy2wa610ZpSQIn7+egaX1cohdrF8NK2+JpQ=;
        h=Subject:To:Cc:From:Date:From;
        b=iliJ9E9S8kVkvRI3oxfYWwFwr72+A1Kw3m9jybZ27EUkU/aicgQVrTf2069pB6z1g
         XWcSOXONUMAWAkBJ/N2eBydmJIOLKe4CR31YCeG/IP0BGKjCpGhifoRSMdvzXOSZ09
         ACE0t6E2InPxBpJK+fkgz6yWh6ytcUzrV7Y5/03M=
Subject: FAILED: patch "[PATCH] iio:adc:twl6030: Enable measurement of VAC" failed to apply to 4.14-stable tree
To:     andreas@kemnade.info, Jonathan.Cameron@huawei.com,
        julia.lawall@lip6.fr, lkp@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Feb 2023 12:41:36 +0100
Message-ID: <1675770096156196@kroah.com>
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


The patch below does not apply to the 4.14-stable tree.
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

