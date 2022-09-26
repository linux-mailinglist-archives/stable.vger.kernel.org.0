Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFABA5EA0FA
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbiIZKoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236201AbiIZKm5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:42:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491FB18E24;
        Mon, 26 Sep 2022 03:24:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C2F8B80915;
        Mon, 26 Sep 2022 10:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FBC7C433C1;
        Mon, 26 Sep 2022 10:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187833;
        bh=vSdOEAMstmSmfi3lFpIiRMp77RLfuMXmUwhvpHUwSLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1FJf31N8W013+wnJtBFSTrwuML3r9kwchZefiWuredUO2uFA7MVdeeUab10oBD2C
         lnoXwbrxrbi+6zBQY+9j5zQ4UCFIWRMBELXqMCHhPeXoVsHkVgRcjCChtZABYluKlF
         stp9XIKVouK+gebxC7n6b7xmiLGj6Lj2Uuf6bs74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Kent Gustavsson <kent@minoris.se>,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 042/120] iio:adc:mcp3911: Switch to generic firmware properties.
Date:   Mon, 26 Sep 2022 12:11:15 +0200
Message-Id: <20220926100752.250813953@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 4efc1c614d334883cce09c38aa3fe74d3fb0bbf0 ]

This allows use of the driver with other types of firmware such as ACPI
PRP0001 based probing.

Also part of a general attempt to remove direct use of of_ specific
accessors from IIO.

Added an include for mod_devicetable.h whilst here to cover the
struct of_device_id definition.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Kent Gustavsson <kent@minoris.se>
Reviewed-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Stable-dep-of: cfbd76d5c9c4 ("iio: adc: mcp3911: correct "microchip,device-addr" property")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/mcp3911.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/mcp3911.c b/drivers/iio/adc/mcp3911.c
index 4e2e8e819b1e..cd8b1bab9cf0 100644
--- a/drivers/iio/adc/mcp3911.c
+++ b/drivers/iio/adc/mcp3911.c
@@ -10,6 +10,8 @@
 #include <linux/err.h>
 #include <linux/iio/iio.h>
 #include <linux/module.h>
+#include <linux/mod_devicetable.h>
+#include <linux/property.h>
 #include <linux/regulator/consumer.h>
 #include <linux/spi/spi.h>
 
@@ -209,12 +211,13 @@ static const struct iio_info mcp3911_info = {
 	.write_raw = mcp3911_write_raw,
 };
 
-static int mcp3911_config(struct mcp3911 *adc, struct device_node *of_node)
+static int mcp3911_config(struct mcp3911 *adc)
 {
+	struct device *dev = &adc->spi->dev;
 	u32 configreg;
 	int ret;
 
-	of_property_read_u32(of_node, "device-addr", &adc->dev_addr);
+	device_property_read_u32(dev, "device-addr", &adc->dev_addr);
 	if (adc->dev_addr > 3) {
 		dev_err(&adc->spi->dev,
 			"invalid device address (%i). Must be in range 0-3.\n",
@@ -298,7 +301,7 @@ static int mcp3911_probe(struct spi_device *spi)
 		}
 	}
 
-	ret = mcp3911_config(adc, spi->dev.of_node);
+	ret = mcp3911_config(adc);
 	if (ret)
 		goto clk_disable;
 
-- 
2.35.1



