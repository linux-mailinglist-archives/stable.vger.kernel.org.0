Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689CA6CBDBC
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 13:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjC1Lby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 07:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbjC1Lbr (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 28 Mar 2023 07:31:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719B655A4
        for <Stable@vger.kernel.org>; Tue, 28 Mar 2023 04:31:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F05AC616E2
        for <Stable@vger.kernel.org>; Tue, 28 Mar 2023 11:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A002C433D2;
        Tue, 28 Mar 2023 11:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680003087;
        bh=zA+w3wpZf7wOYhfHOWf+RxJd5Cq4UDLwQVk+B3JxeQ8=;
        h=Subject:To:From:Date:From;
        b=wJM7UyZyv5evwMKB22ZLZooNhdV6IhvgsHVTFxnhexc5Xm73e45Ax3qQ0K0paFh6t
         zlghXy8r6tC5PxDMIolggJjHPawZ6TMExQpPCWxvbbynOohn7lkr7ZKKrjJ9agZpdT
         NlG3e7e4IiiP2ffNWmt1pNAPpBXhwEeGD1Gs2OX8=
Subject: patch "iio: adc: qcom-spmi-adc5: Fix the channel name" added to char-misc-linus
To:     andriy.shevchenko@linux.intel.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, marijn.suijten@somainline.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 13:31:24 +0200
Message-ID: <1680003084224250@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: qcom-spmi-adc5: Fix the channel name

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 701c875aded880013aacac608832995c4b052257 Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Wed, 18 Jan 2023 12:06:23 +0200
Subject: iio: adc: qcom-spmi-adc5: Fix the channel name

The node name can contain an address part which is unused
by the driver. Moreover, this string is propagated into
the userspace label, sysfs filenames *and breaking ABI*.

Cut the address part out before assigning the channel name.

Fixes: 4f47a236a23d ("iio: adc: qcom-spmi-adc5: convert to device properties")
Reported-by: Marijn Suijten <marijn.suijten@somainline.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Link: https://lore.kernel.org/r/20230118100623.42255-1-andriy.shevchenko@linux.intel.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/qcom-spmi-adc5.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/qcom-spmi-adc5.c b/drivers/iio/adc/qcom-spmi-adc5.c
index 821fee60a765..d1b86570768a 100644
--- a/drivers/iio/adc/qcom-spmi-adc5.c
+++ b/drivers/iio/adc/qcom-spmi-adc5.c
@@ -626,12 +626,20 @@ static int adc5_get_fw_channel_data(struct adc5_chip *adc,
 				    struct fwnode_handle *fwnode,
 				    const struct adc5_data *data)
 {
-	const char *name = fwnode_get_name(fwnode), *channel_name;
+	const char *channel_name;
+	char *name;
 	u32 chan, value, varr[2];
 	u32 sid = 0;
 	int ret;
 	struct device *dev = adc->dev;
 
+	name = devm_kasprintf(dev, GFP_KERNEL, "%pfwP", fwnode);
+	if (!name)
+		return -ENOMEM;
+
+	/* Cut the address part */
+	name[strchrnul(name, '@') - name] = '\0';
+
 	ret = fwnode_property_read_u32(fwnode, "reg", &chan);
 	if (ret) {
 		dev_err(dev, "invalid channel number %s\n", name);
-- 
2.40.0


