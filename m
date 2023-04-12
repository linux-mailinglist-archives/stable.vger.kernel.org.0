Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F736DEE9E
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbjDLInz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbjDLInj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:43:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A9C7AAF
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:43:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9CC46309B
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F0DC433D2;
        Wed, 12 Apr 2023 08:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288935;
        bh=AaZnGgDqsWDGLy+0hDLUeAk3IV+nja+M/w+5G3rRoSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gvYqKhQL1k5NlkBMqhHihNtS1MnYsHTTjegua+NEO+A9vDopfUz16+IsnCkGZb81s
         JyOvx3M72XEbb0dwH242+QwHQXSq93MCPwldq76dHNF/B0LOQaDH+ewq2rmt1WoXS/
         hs7m0iwZwR2wzLgP2QY7j7NVVlMg9NgtxbVRJA/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 073/164] iio: adc: qcom-spmi-adc5: Fix the channel name
Date:   Wed, 12 Apr 2023 10:33:15 +0200
Message-Id: <20230412082839.863803113@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
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



