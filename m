Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31876DEF5B
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbjDLIty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbjDLItq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:49:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0B5127
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:49:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 611B16313B
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736C4C4339B;
        Wed, 12 Apr 2023 08:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289370;
        bh=8Fqan4RnnHN6eBnZoLvCTPDwJenCSwdeMA9EXfuABEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRypqjFenVqy9iUh/IBT4VwqtEF//SZLGlDX4TzgjfWAT1U90if9sWKxfD5+kURJM
         igNMhU3E6bjlJkDMewuzKkDRqLpYnX1igcv0HdkkGnGOya04dC/9mfIg0ZBcBdMOyS
         8lr2m5UlqCVWUODaHxPOiKEMLOu8e4AdN/nldBMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.2 073/173] iio: adc: qcom-spmi-adc5: Fix the channel name
Date:   Wed, 12 Apr 2023 10:33:19 +0200
Message-Id: <20230412082841.001549860@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 701c875aded880013aacac608832995c4b052257 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/qcom-spmi-adc5.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/qcom-spmi-adc5.c
+++ b/drivers/iio/adc/qcom-spmi-adc5.c
@@ -626,12 +626,20 @@ static int adc5_get_fw_channel_data(stru
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


