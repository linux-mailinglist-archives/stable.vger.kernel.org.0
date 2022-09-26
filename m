Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAC15EA7A7
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 15:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235787AbiIZNwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 09:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235409AbiIZNvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 09:51:39 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC587115468;
        Mon, 26 Sep 2022 05:07:48 -0700 (PDT)
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MbgyQ5Krsz67Mvl;
        Mon, 26 Sep 2022 19:49:02 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 13:50:13 +0200
Received: from localhost (10.202.226.42) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 26 Sep
 2022 12:50:13 +0100
Date:   Mon, 26 Sep 2022 12:50:12 +0100
From:   Jonathan Cameron <Jonathan.Cameron@huawei.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Kent Gustavsson <kent@minoris.se>,
        "Marcus Folkesson" <marcus.folkesson@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 042/120] iio:adc:mcp3911: Switch to generic firmware
 properties.
Message-ID: <20220926125012.00001f86@huawei.com>
In-Reply-To: <20220926100752.250813953@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
        <20220926100752.250813953@linuxfoundation.org>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.42]
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Sep 2022 12:11:15 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> [ Upstream commit 4efc1c614d334883cce09c38aa3fe74d3fb0bbf0 ]
> 
> This allows use of the driver with other types of firmware such as ACPI
> PRP0001 based probing.
> 
> Also part of a general attempt to remove direct use of of_ specific
> accessors from IIO.
> 
> Added an include for mod_devicetable.h whilst here to cover the
> struct of_device_id definition.

I'd treat this a feature enabling rather than a fix.
It's small however, so if someone has a sent a backport request I'm fine
with it going in stable. If not, probably just unnecessary noise for stable.

Jonathan

> 
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Kent Gustavsson <kent@minoris.se>
> Reviewed-by: Marcus Folkesson <marcus.folkesson@gmail.com>
> Stable-dep-of: cfbd76d5c9c4 ("iio: adc: mcp3911: correct "microchip,device-addr" property")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/iio/adc/mcp3911.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iio/adc/mcp3911.c b/drivers/iio/adc/mcp3911.c
> index 4e2e8e819b1e..cd8b1bab9cf0 100644
> --- a/drivers/iio/adc/mcp3911.c
> +++ b/drivers/iio/adc/mcp3911.c
> @@ -10,6 +10,8 @@
>  #include <linux/err.h>
>  #include <linux/iio/iio.h>
>  #include <linux/module.h>
> +#include <linux/mod_devicetable.h>
> +#include <linux/property.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/spi/spi.h>
>  
> @@ -209,12 +211,13 @@ static const struct iio_info mcp3911_info = {
>  	.write_raw = mcp3911_write_raw,
>  };
>  
> -static int mcp3911_config(struct mcp3911 *adc, struct device_node *of_node)
> +static int mcp3911_config(struct mcp3911 *adc)
>  {
> +	struct device *dev = &adc->spi->dev;
>  	u32 configreg;
>  	int ret;
>  
> -	of_property_read_u32(of_node, "device-addr", &adc->dev_addr);
> +	device_property_read_u32(dev, "device-addr", &adc->dev_addr);
>  	if (adc->dev_addr > 3) {
>  		dev_err(&adc->spi->dev,
>  			"invalid device address (%i). Must be in range 0-3.\n",
> @@ -298,7 +301,7 @@ static int mcp3911_probe(struct spi_device *spi)
>  		}
>  	}
>  
> -	ret = mcp3911_config(adc, spi->dev.of_node);
> +	ret = mcp3911_config(adc);
>  	if (ret)
>  		goto clk_disable;
>  

