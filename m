Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9DEA11F8AC
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 17:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfLOQBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 11:01:20 -0500
Received: from saturn.retrosnub.co.uk ([46.235.226.198]:44506 "EHLO
        saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfLOQBU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 11:01:20 -0500
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Dec 2019 11:01:19 EST
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        by saturn.retrosnub.co.uk (Postfix; Retrosnub mail submission) with ESMTPSA id C746B9E7C73;
        Sun, 15 Dec 2019 15:52:48 +0000 (GMT)
Date:   Sun, 15 Dec 2019 15:52:47 +0000
From:   Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 074/350] iio: proximity: sx9500: fix
 iio_triggered_buffer_{predisable,postenable} positions
Message-ID: <20191215155247.66ea5412@archlinux>
In-Reply-To: <20191210210735.9077-35-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
        <20191210210735.9077-35-sashal@kernel.org>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 Dec 2019 16:02:59 -0500
Sasha Levin <sashal@kernel.org> wrote:

> From: Alexandru Ardelean <alexandru.ardelean@analog.com>
> 
> [ Upstream commit 3cfd6464fe23deb45bb688df66184b3f32fefc16 ]
> 
> The iio_triggered_buffer_predisable() should be called last, to detach the
> poll func after the devices has been suspended.
> 
> This change re-organizes things a bit so that the postenable & predisable
> are symmetrical. It also converts the preenable() to a postenable().
> 
> Not stable material as there is no known problem with the current
> code, it's just not consistent with the form we would like all the
> IIO drivers to adopt so as to allow subsystem wide changes.

See comment.

Jonathan

> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/iio/proximity/sx9500.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/iio/proximity/sx9500.c b/drivers/iio/proximity/sx9500.c
> index 612f79c53cfc6..287d288e40c27 100644
> --- a/drivers/iio/proximity/sx9500.c
> +++ b/drivers/iio/proximity/sx9500.c
> @@ -675,11 +675,15 @@ static irqreturn_t sx9500_trigger_handler(int irq, void *private)
>  	return IRQ_HANDLED;
>  }
>  
> -static int sx9500_buffer_preenable(struct iio_dev *indio_dev)
> +static int sx9500_buffer_postenable(struct iio_dev *indio_dev)
>  {
>  	struct sx9500_data *data = iio_priv(indio_dev);
>  	int ret = 0, i;
>  
> +	ret = iio_triggered_buffer_postenable(indio_dev);
> +	if (ret)
> +		return ret;
> +
>  	mutex_lock(&data->mutex);
>  
>  	for (i = 0; i < SX9500_NUM_CHANNELS; i++)
> @@ -696,6 +700,9 @@ static int sx9500_buffer_preenable(struct iio_dev *indio_dev)
>  
>  	mutex_unlock(&data->mutex);
>  
> +	if (ret)
> +		iio_triggered_buffer_predisable(indio_dev);
> +
>  	return ret;
>  }
>  
> @@ -704,8 +711,6 @@ static int sx9500_buffer_predisable(struct iio_dev *indio_dev)
>  	struct sx9500_data *data = iio_priv(indio_dev);
>  	int ret = 0, i;
>  
> -	iio_triggered_buffer_predisable(indio_dev);
> -
>  	mutex_lock(&data->mutex);
>  
>  	for (i = 0; i < SX9500_NUM_CHANNELS; i++)
> @@ -722,12 +727,13 @@ static int sx9500_buffer_predisable(struct iio_dev *indio_dev)
>  
>  	mutex_unlock(&data->mutex);
>  
> +	iio_triggered_buffer_predisable(indio_dev);
> +
>  	return ret;
>  }
>  
>  static const struct iio_buffer_setup_ops sx9500_buffer_setup_ops = {
> -	.preenable = sx9500_buffer_preenable,
> -	.postenable = iio_triggered_buffer_postenable,
> +	.postenable = sx9500_buffer_postenable,
>  	.predisable = sx9500_buffer_predisable,
>  };
>  

