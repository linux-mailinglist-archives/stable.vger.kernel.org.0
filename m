Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5818751370C
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 16:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234650AbiD1OlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 10:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiD1OlQ (ORCPT
        <rfc822;Stable@vger.kernel.org>); Thu, 28 Apr 2022 10:41:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BECAC902
        for <Stable@vger.kernel.org>; Thu, 28 Apr 2022 07:38:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 197AEB82DA7
        for <Stable@vger.kernel.org>; Thu, 28 Apr 2022 14:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77174C385A0;
        Thu, 28 Apr 2022 14:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651156678;
        bh=h75j73STBsFYPHbGJNrDiZNadZpeS16Od6EdrybywZs=;
        h=Subject:To:From:Date:From;
        b=bIu20C0arHAziPTbjEIPU+ykbvVhr9+JLXZDTo5BM/a8C1uqCpzPtT37JPEKDKTjq
         nkGVsf+7rH241i7ugpElFTt3sZHOi0XswXl6Kh3VGucE5G/JU45XJWrA4D4/fD8x52
         Ows146pfCRO20VNqu1i2V6de1+WHNkGZfd06IvoI=
Subject: patch "iio: scd4x: check return of scd4x_write_and_fetch" added to char-misc-linus
To:     trix@redhat.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 28 Apr 2022 16:37:50 +0200
Message-ID: <165115667044174@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: scd4x: check return of scd4x_write_and_fetch

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f50232193e61cf89a73130b5e843fef30763c428 Mon Sep 17 00:00:00 2001
From: Tom Rix <trix@redhat.com>
Date: Mon, 28 Feb 2022 18:52:23 -0800
Subject: iio: scd4x: check return of scd4x_write_and_fetch

Clang static analysis reports this problem
scd4x.c:474:10: warning: The left operand of '==' is a
  garbage value
  if (val == 0xff) {
      ~~~ ^
val is only set from a successful call to scd4x_write_and_fetch()
So check it's return.

Fixes: 49d22b695cbb ("drivers: iio: chemical: Add support for Sensirion SCD4x CO2 sensor")
Signed-off-by: Tom Rix <trix@redhat.com>
Link: https://lore.kernel.org/r/20220301025223.223223-1-trix@redhat.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/chemical/scd4x.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/chemical/scd4x.c b/drivers/iio/chemical/scd4x.c
index 20d4e7584e92..37143b5526ee 100644
--- a/drivers/iio/chemical/scd4x.c
+++ b/drivers/iio/chemical/scd4x.c
@@ -471,12 +471,15 @@ static ssize_t calibration_forced_value_store(struct device *dev,
 	ret = scd4x_write_and_fetch(state, CMD_FRC, arg, &val, sizeof(val));
 	mutex_unlock(&state->lock);
 
+	if (ret)
+		return ret;
+
 	if (val == 0xff) {
 		dev_err(dev, "forced calibration has failed");
 		return -EINVAL;
 	}
 
-	return ret ?: len;
+	return len;
 }
 
 static IIO_DEVICE_ATTR_RW(calibration_auto_enable, 0);
-- 
2.36.0


