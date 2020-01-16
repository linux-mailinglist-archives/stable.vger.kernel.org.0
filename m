Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8938913EF9B
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436469AbgAPSQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:16:24 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2275 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405344AbgAPSQX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 13:16:23 -0500
Received: from lhreml701-cah.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id EF11B2307849F84166D6;
        Thu, 16 Jan 2020 18:16:19 +0000 (GMT)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml701-cah.china.huawei.com (10.201.108.42) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 16 Jan 2020 18:16:19 +0000
Received: from localhost (10.202.226.57) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 16 Jan
 2020 18:16:19 +0000
Date:   Thu, 16 Jan 2020 18:16:18 +0000
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Chuhong Yuan <hslester96@gmail.com>,
        Brian Masney <masneyb@onstation.org>,
        <linux-iio@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.19 482/671] iio: tsl2772: Use
 devm_add_action_or_reset for tsl2772_chip_off
Message-ID: <20200116181618.000063c2@Huawei.com>
In-Reply-To: <20200116170509.12787-219-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
        <20200116170509.12787-219-sashal@kernel.org>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.57]
X-ClientProxiedBy: lhreml733-chm.china.huawei.com (10.201.108.84) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 16 Jan 2020 12:02:00 -0500
Sasha Levin <sashal@kernel.org> wrote:

> From: Chuhong Yuan <hslester96@gmail.com>
> 
> [ Upstream commit 338084135aeddb103624a6841972fb8588295cc6 ]
> 
> Use devm_add_action_or_reset to call tsl2772_chip_off
> when the device is removed.
> This also fixes the issue that the chip is turned off
> before the device is unregistered.
> 
> Not marked for stable as fairly hard to hit the bug and
> this is in the middle of a set making other cleanups
> to the driver.  Hence will probably need explicit backporting.

Guess I was wrong and it does go on cleanly.  I took a quick
look at current 4.19 driver and looks like it's fine on it's
own.

We need to be careful with this one in general though.

Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> for 4.19

> 
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> Fixes: c06c4d793584 ("staging: iio: tsl2x7x/tsl2772: move out of staging")
> Reviewed-by: Brian Masney <masneyb@onstation.org>
> Tested-by: Brian Masney <masneyb@onstation.org>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/iio/light/tsl2772.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iio/light/tsl2772.c b/drivers/iio/light/tsl2772.c
> index df5b2a0da96c..f2e308c6d6d7 100644
> --- a/drivers/iio/light/tsl2772.c
> +++ b/drivers/iio/light/tsl2772.c
> @@ -716,6 +716,13 @@ static int tsl2772_chip_off(struct iio_dev *indio_dev)
>  	return tsl2772_write_control_reg(chip, 0x00);
>  }
>  
> +static void tsl2772_chip_off_action(void *data)
> +{
> +	struct iio_dev *indio_dev = data;
> +
> +	tsl2772_chip_off(indio_dev);
> +}
> +
>  /**
>   * tsl2772_invoke_change - power cycle the device to implement the user
>   *                         parameters
> @@ -1711,9 +1718,14 @@ static int tsl2772_probe(struct i2c_client *clientp,
>  	if (ret < 0)
>  		return ret;
>  
> +	ret = devm_add_action_or_reset(&clientp->dev,
> +					tsl2772_chip_off_action,
> +					indio_dev);
> +	if (ret < 0)
> +		return ret;
> +
>  	ret = iio_device_register(indio_dev);
>  	if (ret) {
> -		tsl2772_chip_off(indio_dev);
>  		dev_err(&clientp->dev,
>  			"%s: iio registration failed\n", __func__);
>  		return ret;
> @@ -1740,8 +1752,6 @@ static int tsl2772_remove(struct i2c_client *client)
>  {
>  	struct iio_dev *indio_dev = i2c_get_clientdata(client);
>  
> -	tsl2772_chip_off(indio_dev);
> -
>  	iio_device_unregister(indio_dev);
>  
>  	return 0;


