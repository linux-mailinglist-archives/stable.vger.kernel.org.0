Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD58259E3C7
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241824AbiHWMdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348860AbiHWMbf (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 23 Aug 2022 08:31:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FA1101D04
        for <Stable@vger.kernel.org>; Tue, 23 Aug 2022 02:45:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09CA7B81CA0
        for <Stable@vger.kernel.org>; Tue, 23 Aug 2022 09:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62584C433D6;
        Tue, 23 Aug 2022 09:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247864;
        bh=6kd0s8jjXvZ1q9PVaDxVrTGPdQ1f6UvkAm1vFhO5Rw8=;
        h=Subject:To:From:Date:From;
        b=GhMf0YIAs6yoy/sQxamnw6vXZ5aAq7H0y3X/zBZNXClj0quQfjbsShmR6n9I1gOH5
         8xrsPidq2fb4iWbOj+fLPjhGH8VhNmfMj57bxFWioEMJ+/RbbNgdCGEdZGBX+aQ6nf
         AeTnnTnvOsZYhRZUUMfsTCrQPxNPsBIOL1s5ri0k=
Subject: patch "iio: adc: mcp3911: use correct formula for AD conversion" added to char-misc-linus
To:     marcus.folkesson@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andy.shevchenko@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Aug 2022 10:42:58 +0200
Message-ID: <166124417857138@kroah.com>
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

    iio: adc: mcp3911: use correct formula for AD conversion

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9e2238e3ae40d371a1130226e0e740aa1601efa6 Mon Sep 17 00:00:00 2001
From: Marcus Folkesson <marcus.folkesson@gmail.com>
Date: Fri, 22 Jul 2022 15:07:20 +0200
Subject: iio: adc: mcp3911: use correct formula for AD conversion

The ADC conversion is actually not rail-to-rail but with a factor 1.5.
Make use of this factor when calculating actual voltage.

Fixes: 3a89b289df5d ("iio: adc: add support for mcp3911")
Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220722130726.7627-4-marcus.folkesson@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/mcp3911.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/adc/mcp3911.c b/drivers/iio/adc/mcp3911.c
index f8875076ae80..890af7dca62d 100644
--- a/drivers/iio/adc/mcp3911.c
+++ b/drivers/iio/adc/mcp3911.c
@@ -40,8 +40,8 @@
 #define MCP3911_CHANNEL(x)		(MCP3911_REG_CHANNEL0 + x * 3)
 #define MCP3911_OFFCAL(x)		(MCP3911_REG_OFFCAL_CH0 + x * 6)
 
-/* Internal voltage reference in uV */
-#define MCP3911_INT_VREF_UV		1200000
+/* Internal voltage reference in mV */
+#define MCP3911_INT_VREF_MV		1200
 
 #define MCP3911_REG_READ(reg, id)	((((reg) << 1) | ((id) << 5) | (1 << 0)) & 0xff)
 #define MCP3911_REG_WRITE(reg, id)	((((reg) << 1) | ((id) << 5) | (0 << 0)) & 0xff)
@@ -139,11 +139,18 @@ static int mcp3911_read_raw(struct iio_dev *indio_dev,
 
 			*val = ret / 1000;
 		} else {
-			*val = MCP3911_INT_VREF_UV;
+			*val = MCP3911_INT_VREF_MV;
 		}
 
-		*val2 = 24;
-		ret = IIO_VAL_FRACTIONAL_LOG2;
+		/*
+		 * For 24bit Conversion
+		 * Raw = ((Voltage)/(Vref) * 2^23 * Gain * 1.5
+		 * Voltage = Raw * (Vref)/(2^23 * Gain * 1.5)
+		 */
+
+		/* val2 = (2^23 * 1.5) */
+		*val2 = 12582912;
+		ret = IIO_VAL_FRACTIONAL;
 		break;
 	}
 
-- 
2.37.2


