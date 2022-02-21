Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA0264BE258
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344442AbiBUQ7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 11:59:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbiBUQ7K (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 21 Feb 2022 11:59:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A796422BE2
        for <Stable@vger.kernel.org>; Mon, 21 Feb 2022 08:58:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4052461386
        for <Stable@vger.kernel.org>; Mon, 21 Feb 2022 16:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2591FC340E9;
        Mon, 21 Feb 2022 16:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645462725;
        bh=E25Bva7QurhL/omE3YWXjyA0eJbezY7ybuWxmbNZJRs=;
        h=Subject:To:From:Date:From;
        b=newg+l5OU3dfymeOTCdhR6iiAF2MrEk8gDxuqYSbMZB29pw7t5yS/XmZKdsTyBN/7
         QoLWJ/I6pB2snwSYVCcQoEyoswdo7xqpE2eHcimiW2mRN4gMp52L5y4TADo0qkVZ92
         9pRVbsOO07ESHG4Hu6D6O2v/fOMrzbuQk59Odc6o=
Subject: patch "iio: adc: ad7124: fix mask used for setting AIN_BUFP & AIN_BUFM bits" added to char-misc-linus
To:     demonsingur@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, cosmin.tanislav@analog.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Feb 2022 17:58:40 +0100
Message-ID: <164546272012041@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: ad7124: fix mask used for setting AIN_BUFP & AIN_BUFM bits

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0e33d15f1dce9e3a80a970ea7f0b27837168aeca Mon Sep 17 00:00:00 2001
From: Cosmin Tanislav <demonsingur@gmail.com>
Date: Wed, 12 Jan 2022 22:00:36 +0200
Subject: iio: adc: ad7124: fix mask used for setting AIN_BUFP & AIN_BUFM bits

According to page 90 of the datasheet [1], AIN_BUFP is bit 6 and
AIN_BUFM is bit 5 of the CONFIG_0 -> CONFIG_7 registers.

Fix the mask used for setting these bits.

[1]: https://www.analog.com/media/en/technical-documentation/data-sheets/ad7124-8.pdf

Fixes: 0eaecea6e487 ("iio: adc: ad7124: Add buffered input support")
Signed-off-by: Cosmin Tanislav <cosmin.tanislav@analog.com>
Link: https://lore.kernel.org/r/20220112200036.694490-1-cosmin.tanislav@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/ad7124.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad7124.c b/drivers/iio/adc/ad7124.c
index bc2cfa5f9592..b400bbe291aa 100644
--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -76,7 +76,7 @@
 #define AD7124_CONFIG_REF_SEL(x)	FIELD_PREP(AD7124_CONFIG_REF_SEL_MSK, x)
 #define AD7124_CONFIG_PGA_MSK		GENMASK(2, 0)
 #define AD7124_CONFIG_PGA(x)		FIELD_PREP(AD7124_CONFIG_PGA_MSK, x)
-#define AD7124_CONFIG_IN_BUFF_MSK	GENMASK(7, 6)
+#define AD7124_CONFIG_IN_BUFF_MSK	GENMASK(6, 5)
 #define AD7124_CONFIG_IN_BUFF(x)	FIELD_PREP(AD7124_CONFIG_IN_BUFF_MSK, x)
 
 /* AD7124_FILTER_X */
-- 
2.35.1


