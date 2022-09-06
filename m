Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46CD35AED46
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbiIFO36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241905AbiIFO2V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:28:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A6B40BC9;
        Tue,  6 Sep 2022 06:54:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7812ECE1770;
        Tue,  6 Sep 2022 13:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4BDC433D6;
        Tue,  6 Sep 2022 13:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471476;
        bh=mobJGZFcfs84x6ygQFCoWpjPrj+Z9cYKBuqWlUjkdtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxgdSNHY46mk8Qmr7EBeVhdbS7TpTcPR4ycI2oIz5QjBrjny/WViwjxaJqAJdhLTR
         r6Ol1rNpMZcqmMjYbrAkqGCqx/EBWp7VLUHzgVHJNIVaek0No/IXhGW+oWY0W6r2FJ
         lbmuDKK1m1xwHKN7HPlR+w3gC6cnwYbHZuJ4sQys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 040/107] iio: adc: mcp3911: use correct formula for AD conversion
Date:   Tue,  6 Sep 2022 15:30:21 +0200
Message-Id: <20220906132823.508070326@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Marcus Folkesson <marcus.folkesson@gmail.com>

commit 9e2238e3ae40d371a1130226e0e740aa1601efa6 upstream.

The ADC conversion is actually not rail-to-rail but with a factor 1.5.
Make use of this factor when calculating actual voltage.

Fixes: 3a89b289df5d ("iio: adc: add support for mcp3911")
Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220722130726.7627-4-marcus.folkesson@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/mcp3911.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/iio/adc/mcp3911.c
+++ b/drivers/iio/adc/mcp3911.c
@@ -38,8 +38,8 @@
 #define MCP3911_CHANNEL(x)		(MCP3911_REG_CHANNEL0 + x * 3)
 #define MCP3911_OFFCAL(x)		(MCP3911_REG_OFFCAL_CH0 + x * 6)
 
-/* Internal voltage reference in uV */
-#define MCP3911_INT_VREF_UV		1200000
+/* Internal voltage reference in mV */
+#define MCP3911_INT_VREF_MV		1200
 
 #define MCP3911_REG_READ(reg, id)	((((reg) << 1) | ((id) << 5) | (1 << 0)) & 0xff)
 #define MCP3911_REG_WRITE(reg, id)	((((reg) << 1) | ((id) << 5) | (0 << 0)) & 0xff)
@@ -137,11 +137,18 @@ static int mcp3911_read_raw(struct iio_d
 
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
 


