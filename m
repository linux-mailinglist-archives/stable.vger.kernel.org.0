Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC4A414D7B
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 17:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236478AbhIVPy5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 11:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236486AbhIVPy5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 11:54:57 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E6AC061574;
        Wed, 22 Sep 2021 08:53:27 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id 24so5198078oix.0;
        Wed, 22 Sep 2021 08:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OhuxqL4ckpV0ZznstJzGkEizai+/OeV9eVNnL22Q310=;
        b=GJ9myHSsEZnB8BCnCp66jUOqFOo9KXKyhK0H1n0hHCltV3pTFleCnJmA8scKnE6eye
         ID5W+O9dXII/7cR0I04ZxEz3NTvbQ2vv06W7MrYxWK+Wlo4len3ZelmiElCh/NMzu8OJ
         Mq9PhTvnnGjLga88vrITetf9Gb2aLcnl3Ccuk039i+q1SECEyGjMYsScbu3oXNnrZHBn
         psqLbJc3J1XJbWg4VUb5/dxaU8BFWZBGT5cKqLLnfM5JPDjyRukZu5Vr43OvKYL7HSdC
         ZGK6uJagn8H/gYeUiQdulCnaQELbvmFNHocrN8/+gVflEJ8+3EKLUpCZAxgQzgIAGUuQ
         iLOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=OhuxqL4ckpV0ZznstJzGkEizai+/OeV9eVNnL22Q310=;
        b=qj3aliLHB+0H2ILyGUMNpX1ikTOD3OoexG8qsCTf5UjRGmfItjW789Bg2DUsoYu9gK
         WX9pGRLWWDensiTuTgffH7YoW5+HjBqRfd0Hd+nU+atdaZI3T2pY4oTIbmYBEcBhkg2T
         N+2iTF2qvX+eAiKQqp+eB+0iwPxrTKjVbWDlsfShvo9u2ieYXTW59ZCdiBiMlFoEj8dU
         OCD9bGHp1s+gllNDT1+JhDyMaex3QQwHl/gFGO588gDkpHxlQ8QhqGr1hffFRaZorKiC
         09siOAWxCn6+7VXhMZQ9cyS4gyUt7jJg1okXhQ8AO5+sr+GyeY4nfhQQm+2y65LdQlH8
         ed0w==
X-Gm-Message-State: AOAM532VAY3NorjZ/jODQVx/46/58+0L7OSA/5GUfcXQu9D+X5elCL6e
        R40XzehGOnE3xSf31N2mQXpHNzK9AFU=
X-Google-Smtp-Source: ABdhPJzBW7MkPKnJaZh/O2rZGCiHmKbstR5NIMX4LBftmMVFDId+vOwc9Sz2sJHYcP9Psv3OpPMK5g==
X-Received: by 2002:a05:6808:17a9:: with SMTP id bg41mr352031oib.88.1632326006544;
        Wed, 22 Sep 2021 08:53:26 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s24sm593131oic.34.2021.09.22.08.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 08:53:25 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 22 Sep 2021 08:53:23 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Paul Fertser <fercerpav@gmail.com>
Cc:     linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] hwmon: tmp421: handle I2C errors
Message-ID: <20210922155323.GA3205709@roeck-us.net>
References: <20210922134154.20766-1-fercerpav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922134154.20766-1-fercerpav@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 22, 2021 at 04:41:52PM +0300, Paul Fertser wrote:
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
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Paul Fertser <fercerpav@gmail.com>
> ---
>  drivers/hwmon/tmp421.c | 31 ++++++++++++++++++++++---------
>  1 file changed, 22 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/hwmon/tmp421.c b/drivers/hwmon/tmp421.c
> index ede66ea6a730..6175ed4b10bd 100644
> --- a/drivers/hwmon/tmp421.c
> +++ b/drivers/hwmon/tmp421.c
> @@ -93,7 +93,7 @@ struct tmp421_data {
>  	struct hwmon_channel_info temp_info;
>  	const struct hwmon_channel_info *info[2];
>  	struct hwmon_chip_info chip;
> -	char valid;
> +	int last_errno;
>  	unsigned long last_updated;
>  	unsigned long channels;
>  	u8 config;
> @@ -128,20 +128,30 @@ static struct tmp421_data *tmp421_update_device(struct device *dev)
>  	mutex_lock(&data->update_lock);
>  
>  	if (time_after(jiffies, data->last_updated + (HZ / 2)) ||
> -	    !data->valid) {
> -		data->config = i2c_smbus_read_byte_data(client,
> -			TMP421_CONFIG_REG_1);
> +	    data->last_errno) {
> +		data->last_errno = i2c_smbus_read_byte_data(client,
> +							    TMP421_CONFIG_REG_1);

No. The function should return an ERR_PTR after an error.
Something like
	int ret = 0;
	...
	ret = i2c_smbus_read_byte_data(client, TMP421_CONFIG_REG_1);
	if (ret < 0)
		goto exit;
	data->config = ret;
	...
exit:
	mutex_unlock(...);
	return ret < 0 ? ERR_PTR(ret) : data;

Or, even better, let tmp421_update_device() return an error code instead
of data, and let the caller get the data pointer.

int tmp421_update_device(struct tmp421_data *data)
{
	struct i2c_client *client = data->client;
	int ret = 0;

	...
	return ret < 0 ? ret : 0;
}
...

	struct tmp421_data *data = dev_get_drvdata(dev);

	ret = tmp421_update_device(data);
	if (ret)
		return ret;


Guenter

> +		if (data->last_errno < 0)
> +			goto exit;
> +		data->config =  data->last_errno;
>  
>  		for (i = 0; i < data->channels; i++) {
> -			data->temp[i] = i2c_smbus_read_byte_data(client,
> -				TMP421_TEMP_MSB[i]) << 8;
> -			data->temp[i] |= i2c_smbus_read_byte_data(client,
> -				TMP421_TEMP_LSB[i]);
> +			data->last_errno = i2c_smbus_read_byte_data(client,
> +								    TMP421_TEMP_MSB[i]);
> +			if (data->last_errno < 0)
> +				goto exit;
> +			data->temp[i] = data->last_errno << 8;
> +			data->last_errno = i2c_smbus_read_byte_data(client,
> +								    TMP421_TEMP_LSB[i]);
> +			if (data->last_errno < 0)
> +				goto exit;
> +			data->temp[i] |= data->last_errno;
>  		}
>  		data->last_updated = jiffies;
> -		data->valid = 1;
> +		data->last_errno = 0;
>  	}
>  
> +exit:
>  	mutex_unlock(&data->update_lock);
>  
>  	return data;
> @@ -152,6 +162,9 @@ static int tmp421_read(struct device *dev, enum hwmon_sensor_types type,
>  {
>  	struct tmp421_data *tmp421 = tmp421_update_device(dev);
>  
> +	if (tmp421->last_errno)
> +		return tmp421->last_errno;
> +
>  	switch (attr) {
>  	case hwmon_temp_input:
>  		if (tmp421->config & TMP421_CONFIG_RANGE)
> -- 
> 2.17.1
> 
