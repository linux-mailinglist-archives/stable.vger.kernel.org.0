Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9DA201686
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395061AbgFSQbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:31:53 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2346 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2395042AbgFSQbv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 12:31:51 -0400
Received: from lhreml710-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 8C2554A4460EE215B62C;
        Fri, 19 Jun 2020 17:31:50 +0100 (IST)
Received: from localhost (10.52.127.178) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Fri, 19 Jun
 2020 17:31:50 +0100
Date:   Fri, 19 Jun 2020 17:31:01 +0100
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        "Alexandru Ardelean" <alexandru.ardelean@analog.com>,
        <linux-iio@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.4 03/60] iio: light: isl29125: fix
 iio_triggered_buffer_{predisable,postenable} positions
Message-ID: <20200619173101.000045a2@Huawei.com>
In-Reply-To: <20200618013004.610532-3-sashal@kernel.org>
References: <20200618013004.610532-1-sashal@kernel.org>
        <20200618013004.610532-3-sashal@kernel.org>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.127.178]
X-ClientProxiedBy: lhreml725-chm.china.huawei.com (10.201.108.76) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 17 Jun 2020 21:29:07 -0400
Sasha Levin <sashal@kernel.org> wrote:

> From: Alexandru Ardelean <alexandru.ardelean@analog.com>
> 
> [ Upstream commit 9b7a12c3e090cf3fba6f66f1f23abbc6e0e86021 ]
> 
> The iio_triggered_buffer_{predisable,postenable} functions attach/detach
> the poll functions.
> 
> For the predisable hook, the disable code should occur before detaching
> the poll func, and for the postenable hook, the poll func should be
> attached before the enable code.
> 
> This change reworks the predisable/postenable hooks so that the pollfunc is
> attached/detached in the correct position.
> It also balances the calls a bit, by grouping the preenable and the
> iio_triggered_buffer_postenable() into a single
> isl29125_buffer_postenable() function.
> 

This is really part of some rework.  It doesn't 'fix' a bug
as such (I think), but rather a bit of logical inconsistency.

Shouldn't do any harm though beyond adding noise to stable.
I added notes to some of these to mark them as not stable material,
but clearly missed this one. Sorry about that.

Jonathan

> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/iio/light/isl29125.c | 28 +++++++++++++++++++---------
>  1 file changed, 19 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/iio/light/isl29125.c b/drivers/iio/light/isl29125.c
> index e2945a20e5f6..60388a41ec8c 100644
> --- a/drivers/iio/light/isl29125.c
> +++ b/drivers/iio/light/isl29125.c
> @@ -215,13 +215,24 @@ static const struct iio_info isl29125_info = {
>  	.driver_module = THIS_MODULE,
>  };
>  
> -static int isl29125_buffer_preenable(struct iio_dev *indio_dev)
> +static int isl29125_buffer_postenable(struct iio_dev *indio_dev)
>  {
>  	struct isl29125_data *data = iio_priv(indio_dev);
> +	int err;
> +
> +	err = iio_triggered_buffer_postenable(indio_dev);
> +	if (err)
> +		return err;
>  
>  	data->conf1 |= ISL29125_MODE_RGB;
> -	return i2c_smbus_write_byte_data(data->client, ISL29125_CONF1,
> +	err = i2c_smbus_write_byte_data(data->client, ISL29125_CONF1,
>  		data->conf1);
> +	if (err) {
> +		iio_triggered_buffer_predisable(indio_dev);
> +		return err;
> +	}
> +
> +	return 0;
>  }
>  
>  static int isl29125_buffer_predisable(struct iio_dev *indio_dev)
> @@ -229,19 +240,18 @@ static int isl29125_buffer_predisable(struct iio_dev *indio_dev)
>  	struct isl29125_data *data = iio_priv(indio_dev);
>  	int ret;
>  
> -	ret = iio_triggered_buffer_predisable(indio_dev);
> -	if (ret < 0)
> -		return ret;
> -
>  	data->conf1 &= ~ISL29125_MODE_MASK;
>  	data->conf1 |= ISL29125_MODE_PD;
> -	return i2c_smbus_write_byte_data(data->client, ISL29125_CONF1,
> +	ret = i2c_smbus_write_byte_data(data->client, ISL29125_CONF1,
>  		data->conf1);
> +
> +	iio_triggered_buffer_predisable(indio_dev);
> +
> +	return ret;
>  }
>  
>  static const struct iio_buffer_setup_ops isl29125_buffer_setup_ops = {
> -	.preenable = isl29125_buffer_preenable,
> -	.postenable = &iio_triggered_buffer_postenable,
> +	.postenable = isl29125_buffer_postenable,
>  	.predisable = isl29125_buffer_predisable,
>  };
>  


