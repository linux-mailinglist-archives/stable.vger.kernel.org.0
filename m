Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1564169F3
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 04:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243883AbhIXCVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 22:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243886AbhIXCVy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Sep 2021 22:21:54 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0988C061574;
        Thu, 23 Sep 2021 19:20:22 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id l7-20020a0568302b0700b0051c0181deebso11159879otv.12;
        Thu, 23 Sep 2021 19:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Jdsethjb96VrfX0B8dehAWdCPM+BLbxwVqJO37f21O4=;
        b=CdHeE7DbKhH90unyBajR8RYDCas0BKr+ukS7IRiAh0QNdTY19x3wmyEb1mSweX5aQf
         o6aVTMATdrLPjyh6y8aZnCfowJq8F8KVyRCpwgbL6UFpJyr9jniKjVqXO/c2aQh0slQH
         /E7Yy9BVEE03IIQxFBEKq31IeK1dICAtOJufnRKNxigVXPrjG+xuxBU+Jp3o1jc8BH4t
         T2fMSNHgemvOBXn9xRpxU4LfkBzY/wM49y7hwWzgjz0AXoG7kew8OZoCaZKyp/OvPCUD
         VaAK5INmJDqjEbYUcIogQzlxhcTNX4MV10u1Y2/bqhrHDB0z2gS2/e2bWDZBCQd/SGF6
         cY7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Jdsethjb96VrfX0B8dehAWdCPM+BLbxwVqJO37f21O4=;
        b=NEJ+YjuNJfDHlgmdAIY8FoOBGIT9ZCjByPylR8RIcuVzYQ98gM5108a7xTpfN8Dy9X
         xadfJzGRUsreS8f7ujlzht/+MnZpcI/+XCJmAUWe/r/DnBLnZ7+rxyF5ePetBfzXJcQJ
         S6UfbkQpPbSYYhxdr4sSEzsomvz5s24BXcfDAhueq9LC8k3LdJ/7342RojrUHwZ70z91
         Sinqz2pFwebzlMOTe2LMO2/GeLu05ToAZaxnRFPWig9rCtvaqOQx+AHHaRAV1tWkm53V
         tozSU36W9mzIW94FLMtoSUyaIEXN1AoQqRLUbz3f7pjJ5IOwwBEchybM4G5G3B/iqVIy
         WsRg==
X-Gm-Message-State: AOAM531lERzkSX0Nx4ugwlgfzTTzOut8yzf2yXwlCQbga/qxpSAzHBsE
        oA1Ielf4NZO+poBWWgbRzyU=
X-Google-Smtp-Source: ABdhPJzvvNlbmcgykXlN6tKEe/SE9It58iC/kHENu4A0IXC7t+OXk1kEHsRn7zsgPlR+AF3xeBhTRQ==
X-Received: by 2002:a05:6830:452:: with SMTP id d18mr1804351otc.364.1632450021975;
        Thu, 23 Sep 2021 19:20:21 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n33sm1749388ota.8.2021.09.23.19.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 19:20:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 23 Sep 2021 19:20:20 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Paul Fertser <fercerpav@gmail.com>
Cc:     linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] hwmon: tmp421: handle I2C errors
Message-ID: <20210924022020.GA3032273@roeck-us.net>
References: <20210922155323.GA3205709@roeck-us.net>
 <20210923094801.23332-1-fercerpav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923094801.23332-1-fercerpav@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 23, 2021 at 12:47:59PM +0300, Paul Fertser wrote:
> Function i2c_smbus_read_byte_data() can return a negative error number
> instead of the data read if I2C transaction failed for whatever reason.
> 
> I consider this fix to be stable material as lack of error checking here
> leads to serious issues on production hardware. Errors treated as
> temperatures produce spurious critical temperature-crossed-threshold
> errors in BMC logs for OCP server hardware. The patch was tested with
> Mellanox OCP Mezzanine card emulating TMP421 protocol for temperature
> sensing which sometimes leads to I2C protocol error during early boot up
> stage.

Possibly, but this doesn't belong into the commit log but after --- as
written. I'd suggest to leave the "I consider this fix to be stable
material" off, rephrase to "Lack of error checking can lead to serious..."
which does belong in the commit description, and add a Fixes: tag which
marks the patch for stable releases. Also, drop the char -> bool change
from the bug fix; it is unrelated and should be a separate cleanup patch.

> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Paul Fertser <fercerpav@gmail.com>
> ---
> 
> Changes from v1:
>  - Reorganise code following excellent suggestion by Guenter Roeck
>    to use tagged errors consistently
> 
>  drivers/hwmon/tmp421.c | 45 +++++++++++++++++++++++++++++++-----------
>  1 file changed, 33 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/hwmon/tmp421.c b/drivers/hwmon/tmp421.c
> index ede66ea6a730..63cb6badb478 100644
> --- a/drivers/hwmon/tmp421.c
> +++ b/drivers/hwmon/tmp421.c
> @@ -93,7 +93,7 @@ struct tmp421_data {
>  	struct hwmon_channel_info temp_info;
>  	const struct hwmon_channel_info *info[2];
>  	struct hwmon_chip_info chip;
> -	char valid;
> +	bool valid;

This is a cleanup, not a bug fix, and it isn't even mentioned
in the patch description.

>  	unsigned long last_updated;
>  	unsigned long channels;
>  	u8 config;
> @@ -119,38 +119,59 @@ static int temp_from_u16(u16 reg)
>  	return (temp * 1000 + 128) / 256;
>  }
>  
> -static struct tmp421_data *tmp421_update_device(struct device *dev)
> +static int tmp421_update_device(struct tmp421_data *data)
>  {
> -	struct tmp421_data *data = dev_get_drvdata(dev);
>  	struct i2c_client *client = data->client;
> +	int ret = 0;
>  	int i;
>  
>  	mutex_lock(&data->update_lock);
>  
>  	if (time_after(jiffies, data->last_updated + (HZ / 2)) ||
>  	    !data->valid) {
> -		data->config = i2c_smbus_read_byte_data(client,
> -			TMP421_CONFIG_REG_1);
> +		ret = i2c_smbus_read_byte_data(client,
> +					       TMP421_CONFIG_REG_1);
> +		if (ret < 0)
> +			goto exit;
> +		data->config = ret;
>  
>  		for (i = 0; i < data->channels; i++) {
> -			data->temp[i] = i2c_smbus_read_byte_data(client,
> -				TMP421_TEMP_MSB[i]) << 8;
> -			data->temp[i] |= i2c_smbus_read_byte_data(client,
> -				TMP421_TEMP_LSB[i]);
> +			ret = i2c_smbus_read_byte_data(client,
> +						       TMP421_TEMP_MSB[i]);
> +			if (ret < 0)
> +				goto exit;
> +			data->temp[i] = ret << 8;
> +
> +			ret = i2c_smbus_read_byte_data(client,
> +						       TMP421_TEMP_LSB[i]);
> +			if (ret < 0)
> +				goto exit;
> +			data->temp[i] |= ret;
>  		}
>  		data->last_updated = jiffies;
> -		data->valid = 1;
> +		data->valid = true;
>  	}
>  
> +exit:
>  	mutex_unlock(&data->update_lock);
>  
> -	return data;
> +	if (ret < 0) {
> +		data->valid = false;
> +		return ret;
> +	}
> +
> +	return 0;
>  }
>  
>  static int tmp421_read(struct device *dev, enum hwmon_sensor_types type,
>  		       u32 attr, int channel, long *val)
>  {
> -	struct tmp421_data *tmp421 = tmp421_update_device(dev);
> +	struct tmp421_data *tmp421 = dev_get_drvdata(dev);
> +	int ret = 0;
> +
> +	ret = tmp421_update_device(tmp421);
> +	if (ret)
> +		return ret;
>  
>  	switch (attr) {
>  	case hwmon_temp_input:
