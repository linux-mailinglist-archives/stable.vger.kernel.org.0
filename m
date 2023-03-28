Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEF96CBDC6
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 13:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbjC1LcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 07:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbjC1LcJ (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 28 Mar 2023 07:32:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69AC8185
        for <Stable@vger.kernel.org>; Tue, 28 Mar 2023 04:32:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A5F6B81BDD
        for <Stable@vger.kernel.org>; Tue, 28 Mar 2023 11:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6871DC433D2;
        Tue, 28 Mar 2023 11:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680003118;
        bh=J4zKu8TT8AM3oEjW5pSdAriiKtIy/45RbTx9FIsTIHY=;
        h=Subject:To:From:Date:From;
        b=PKgwf5xsot/HiMh5KWPKGHR5WauI3n9+78m9Yb3YD5HdeSzdv9syBM9gyPwGmFt1N
         ur42CTO3zpLH4Gl3RLHeoD9vBOQ/e9PqrXvt9Lb9ZE7pw0uX17XdoZRa5M75u9Dm4y
         Mxh/RfORvGGqrIUZyDEzLzHB+dCG4Se93ZvV71is=
Subject: patch "iio: adc: max11410: fix read_poll_timeout() usage" added to char-misc-linus
To:     nuno.sa@analog.com, Ibrahim.Tilki@analog.com,
        Jonathan.Cameron@huawei.com, Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 13:31:31 +0200
Message-ID: <168000309195119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: max11410: fix read_poll_timeout() usage

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7b3825e9487d77e83bf1e27b10a74cd729b8f972 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Date: Tue, 7 Mar 2023 10:53:03 +0100
Subject: iio: adc: max11410: fix read_poll_timeout() usage
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Even though we are passing 'ret' as stop condition for
read_poll_timeout(), that return code is still being ignored. The reason
is that the poll will stop if the passed condition is true which will
happen if the passed op() returns error. However, read_poll_timeout()
returns 0 if the *complete* condition evaluates to true. Therefore, the
error code returned by op() will be ignored.

To fix this we need to check for both error codes:
 * The one returned by read_poll_timeout() which is either 0 or
ETIMEDOUT.
 * The one returned by the passed op().

Fixes: a44ef7c46097 ("iio: adc: add max11410 adc driver")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Acked-by: Ibrahim Tilki <Ibrahim.Tilki@analog.com>
Link: https://lore.kernel.org/r/20230307095303.713251-1-nuno.sa@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/max11410.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/adc/max11410.c b/drivers/iio/adc/max11410.c
index fdc9f03135b5..e64cd979688d 100644
--- a/drivers/iio/adc/max11410.c
+++ b/drivers/iio/adc/max11410.c
@@ -413,13 +413,17 @@ static int max11410_sample(struct max11410_state *st, int *sample_raw,
 		if (!ret)
 			return -ETIMEDOUT;
 	} else {
+		int ret2;
+
 		/* Wait for status register Conversion Ready flag */
-		ret = read_poll_timeout(max11410_read_reg, ret,
-					ret || (val & MAX11410_STATUS_CONV_READY_BIT),
+		ret = read_poll_timeout(max11410_read_reg, ret2,
+					ret2 || (val & MAX11410_STATUS_CONV_READY_BIT),
 					5000, MAX11410_CONVERSION_TIMEOUT_MS * 1000,
 					true, st, MAX11410_REG_STATUS, &val);
 		if (ret)
 			return ret;
+		if (ret2)
+			return ret2;
 	}
 
 	/* Read ADC Data */
@@ -850,17 +854,21 @@ static int max11410_init_vref(struct device *dev,
 
 static int max11410_calibrate(struct max11410_state *st, u32 cal_type)
 {
-	int ret, val;
+	int ret, ret2, val;
 
 	ret = max11410_write_reg(st, MAX11410_REG_CAL_START, cal_type);
 	if (ret)
 		return ret;
 
 	/* Wait for status register Calibration Ready flag */
-	return read_poll_timeout(max11410_read_reg, ret,
-				 ret || (val & MAX11410_STATUS_CAL_READY_BIT),
-				 50000, MAX11410_CALIB_TIMEOUT_MS * 1000, true,
-				 st, MAX11410_REG_STATUS, &val);
+	ret = read_poll_timeout(max11410_read_reg, ret2,
+				ret2 || (val & MAX11410_STATUS_CAL_READY_BIT),
+				50000, MAX11410_CALIB_TIMEOUT_MS * 1000, true,
+				st, MAX11410_REG_STATUS, &val);
+	if (ret)
+		return ret;
+
+	return ret2;
 }
 
 static int max11410_self_calibrate(struct max11410_state *st)
-- 
2.40.0


