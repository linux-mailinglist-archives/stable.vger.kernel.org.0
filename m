Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B88611F8B1
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 17:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfLOQB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 11:01:27 -0500
Received: from saturn.retrosnub.co.uk ([46.235.226.198]:44502 "EHLO
        saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbfLOQBU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 11:01:20 -0500
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        by saturn.retrosnub.co.uk (Postfix; Retrosnub mail submission) with ESMTPSA id B7B3B9E76A6;
        Sun, 15 Dec 2019 15:55:08 +0000 (GMT)
Date:   Sun, 15 Dec 2019 15:55:07 +0000
From:   Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 117/350] iio: dac: ad7303: replace mlock
 with own lock
Message-ID: <20191215155507.08026268@archlinux>
In-Reply-To: <20191210210735.9077-78-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
        <20191210210735.9077-78-sashal@kernel.org>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 Dec 2019 16:03:42 -0500
Sasha Levin <sashal@kernel.org> wrote:

> From: Alexandru Ardelean <alexandru.ardelean@analog.com>
> 
> [ Upstream commit c991bf9b650f39481cf3c1137092d4754a2c75de ]
> 
> This change replaces indio_dev's mlock with the driver's own lock. The lock
> is mostly needed to protect state when changing the `dac_cache` info.
> The lock has been extended to `ad7303_read_raw()`, to make sure that the
> cache is updated if an SPI-write is already in progress.
This is not a fix.  It's undoing some slightly nasty layer violations
that we are trying to drive out of IIO, but as far as I know there
is no actual bug with what was there before.

I won't do any harm though other than adding noise.

Jonathan

> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/iio/dac/ad7303.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/iio/dac/ad7303.c b/drivers/iio/dac/ad7303.c
> index 8de9f40226e62..14bbac6bee982 100644
> --- a/drivers/iio/dac/ad7303.c
> +++ b/drivers/iio/dac/ad7303.c
> @@ -41,6 +41,7 @@ struct ad7303_state {
>  	struct regulator *vdd_reg;
>  	struct regulator *vref_reg;
>  
> +	struct mutex lock;
>  	/*
>  	 * DMA (thus cache coherency maintenance) requires the
>  	 * transfer buffers to live in their own cache lines.
> @@ -79,7 +80,7 @@ static ssize_t ad7303_write_dac_powerdown(struct iio_dev *indio_dev,
>  	if (ret)
>  		return ret;
>  
> -	mutex_lock(&indio_dev->mlock);
> +	mutex_lock(&st->lock);
>  
>  	if (pwr_down)
>  		st->config |= AD7303_CFG_POWER_DOWN(chan->channel);
> @@ -90,7 +91,7 @@ static ssize_t ad7303_write_dac_powerdown(struct iio_dev *indio_dev,
>  	 * mode, so just write one of the DAC channels again */
>  	ad7303_write(st, chan->channel, st->dac_cache[chan->channel]);
>  
> -	mutex_unlock(&indio_dev->mlock);
> +	mutex_unlock(&st->lock);
>  	return len;
>  }
>  
> @@ -116,7 +117,9 @@ static int ad7303_read_raw(struct iio_dev *indio_dev,
>  
>  	switch (info) {
>  	case IIO_CHAN_INFO_RAW:
> +		mutex_lock(&st->lock);
>  		*val = st->dac_cache[chan->channel];
> +		mutex_unlock(&st->lock);
>  		return IIO_VAL_INT;
>  	case IIO_CHAN_INFO_SCALE:
>  		vref_uv = ad7303_get_vref(st, chan);
> @@ -144,11 +147,11 @@ static int ad7303_write_raw(struct iio_dev *indio_dev,
>  		if (val >= (1 << chan->scan_type.realbits) || val < 0)
>  			return -EINVAL;
>  
> -		mutex_lock(&indio_dev->mlock);
> +		mutex_lock(&st->lock);
>  		ret = ad7303_write(st, chan->address, val);
>  		if (ret == 0)
>  			st->dac_cache[chan->channel] = val;
> -		mutex_unlock(&indio_dev->mlock);
> +		mutex_unlock(&st->lock);
>  		break;
>  	default:
>  		ret = -EINVAL;
> @@ -211,6 +214,8 @@ static int ad7303_probe(struct spi_device *spi)
>  
>  	st->spi = spi;
>  
> +	mutex_init(&st->lock);
> +
>  	st->vdd_reg = devm_regulator_get(&spi->dev, "Vdd");
>  	if (IS_ERR(st->vdd_reg))
>  		return PTR_ERR(st->vdd_reg);

