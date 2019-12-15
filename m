Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16CB211F8AE
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 17:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfLOQBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 11:01:21 -0500
Received: from saturn.retrosnub.co.uk ([46.235.226.198]:44510 "EHLO
        saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbfLOQBU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 11:01:20 -0500
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        by saturn.retrosnub.co.uk (Postfix; Retrosnub mail submission) with ESMTPSA id 76E989E7630;
        Sun, 15 Dec 2019 15:52:05 +0000 (GMT)
Date:   Sun, 15 Dec 2019 15:52:03 +0000
From:   Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 019/350] iio: tcs3414: fix
 iio_triggered_buffer_{pre,post}enable positions
Message-ID: <20191215155203.607cc56d@archlinux>
In-Reply-To: <20191210210402.8367-19-sashal@kernel.org>
References: <20191210210402.8367-1-sashal@kernel.org>
        <20191210210402.8367-19-sashal@kernel.org>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 Dec 2019 15:58:31 -0500
Sasha Levin <sashal@kernel.org> wrote:

> From: Alexandru Ardelean <alexandru.ardelean@analog.com>
> 
> [ Upstream commit 0fe2f2b789190661df24bb8bf62294145729a1fe ]
> 
> The iio_triggered_buffer_{predisable,postenable} functions attach/detach
> the poll functions.
> 
> For the predisable hook, the disable code should occur before detaching
> the poll func, and for the postenable hook, the poll func should be
> attached before the enable code.
> 
> The driver was slightly reworked. The preenable hook was moved to the
> postenable, to add some symmetry to the postenable/predisable part.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
I doubt this did any harm, but wouldn't consider it stable material normally.

This is part of a general rework going on to allow some core refactoring.

I should have added a note to this one like some related patches that it
is a logical fix, but we don't have an actual known bug afaik.

Sorry about that.

Jonathan

> ---
>  drivers/iio/light/tcs3414.c | 30 ++++++++++++++++++++----------
>  1 file changed, 20 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/iio/light/tcs3414.c b/drivers/iio/light/tcs3414.c
> index 7c0291c5fe76e..b542e5619ead8 100644
> --- a/drivers/iio/light/tcs3414.c
> +++ b/drivers/iio/light/tcs3414.c
> @@ -240,32 +240,42 @@ static const struct iio_info tcs3414_info = {
>  	.attrs = &tcs3414_attribute_group,
>  };
>  
> -static int tcs3414_buffer_preenable(struct iio_dev *indio_dev)
> +static int tcs3414_buffer_postenable(struct iio_dev *indio_dev)
>  {
>  	struct tcs3414_data *data = iio_priv(indio_dev);
> +	int ret;
> +
> +	ret = iio_triggered_buffer_postenable(indio_dev);
> +	if (ret)
> +		return ret;
>  
>  	data->control |= TCS3414_CONTROL_ADC_EN;
> -	return i2c_smbus_write_byte_data(data->client, TCS3414_CONTROL,
> +	ret = i2c_smbus_write_byte_data(data->client, TCS3414_CONTROL,
>  		data->control);
> +	if (ret)
> +		iio_triggered_buffer_predisable(indio_dev);
> +
> +	return ret;
>  }
>  
>  static int tcs3414_buffer_predisable(struct iio_dev *indio_dev)
>  {
>  	struct tcs3414_data *data = iio_priv(indio_dev);
> -	int ret;
> -
> -	ret = iio_triggered_buffer_predisable(indio_dev);
> -	if (ret < 0)
> -		return ret;
> +	int ret, ret2;
>  
>  	data->control &= ~TCS3414_CONTROL_ADC_EN;
> -	return i2c_smbus_write_byte_data(data->client, TCS3414_CONTROL,
> +	ret = i2c_smbus_write_byte_data(data->client, TCS3414_CONTROL,
>  		data->control);
> +
> +	ret2 = iio_triggered_buffer_predisable(indio_dev);
> +	if (!ret)
> +		ret = ret2;
> +
> +	return ret;
>  }
>  
>  static const struct iio_buffer_setup_ops tcs3414_buffer_setup_ops = {
> -	.preenable = tcs3414_buffer_preenable,
> -	.postenable = &iio_triggered_buffer_postenable,
> +	.postenable = tcs3414_buffer_postenable,
>  	.predisable = tcs3414_buffer_predisable,
>  };
>  

