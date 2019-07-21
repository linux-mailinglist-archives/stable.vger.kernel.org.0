Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3F96F451
	for <lists+stable@lfdr.de>; Sun, 21 Jul 2019 19:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfGURX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 13:23:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbfGURX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Jul 2019 13:23:26 -0400
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2F0F20578;
        Sun, 21 Jul 2019 17:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563729804;
        bh=cL+FxSXOE8Wyo9AZIWlhVoZLYHfAKQoCpJqz846ftLw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Kt1Uj4kKS0quqR6xY++eL9upPn8uUkmJSCq/9DUuosUZBhAYaD+U8wuWzLAOUE4NI
         G+lO1/g358izkaTh7hxddwu+lxTIZ40sCcfgv/dImL5Ze5bJI1fZIkRWMl510GiwU+
         qwYqqyxfGLaHtj6XvJ2yYXtt/wAWOsJI4XFsG/Gg=
Date:   Sun, 21 Jul 2019 18:23:12 +0100
From:   Jonathan Cameron <jic23@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Denis Ciocca <denis.ciocca@st.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.4 17/35] iio: st_accel: fix
 iio_triggered_buffer_{pre,post}enable positions
Message-ID: <20190721182256.70ab6692@archlinux>
In-Reply-To: <20190719041423.19322-17-sashal@kernel.org>
References: <20190719041423.19322-1-sashal@kernel.org>
        <20190719041423.19322-17-sashal@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 19 Jul 2019 00:14:05 -0400
Sasha Levin <sashal@kernel.org> wrote:

> From: Alexandru Ardelean <alexandru.ardelean@analog.com>
> 
> [ Upstream commit 05b8bcc96278c9ef927a6f25a98e233e55de42e1 ]
> 
> The iio_triggered_buffer_{predisable,postenable} functions attach/detach
> the poll functions.
> 
> For the predisable hook, the disable code should occur before detaching
> the poll func, and for the postenable hook, the poll func should be
> attached before the enable code.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> Acked-by: Denis Ciocca <denis.ciocca@st.com>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
Hi Sasha,

This should do any harm, but I deliberately didn't cc stable on
this one.

Alex, my assumption on this one is that it was fixing a logical
ordering problem, but one that had no visible impact.
Whilst the pollfunc will be attached too early, the trigger
will be disabled for the whole of this function anyway so
it shouldn't cause any visible problem.  Is that a correct interpretation?
There are going to be a few more similar fixes in the near future
as Alex is trying to tidy up various paths so we can do a general
bit of refactoring.

If I'm too late for this, then not a problem, just noise
in the stable release.

Jonathan


> ---
>  drivers/iio/accel/st_accel_buffer.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/iio/accel/st_accel_buffer.c b/drivers/iio/accel/st_accel_buffer.c
> index a1e642ee13d6..4f838277184a 100644
> --- a/drivers/iio/accel/st_accel_buffer.c
> +++ b/drivers/iio/accel/st_accel_buffer.c
> @@ -46,17 +46,19 @@ static int st_accel_buffer_postenable(struct iio_dev *indio_dev)
>  		goto allocate_memory_error;
>  	}
>  
> -	err = st_sensors_set_axis_enable(indio_dev,
> -					(u8)indio_dev->active_scan_mask[0]);
> +	err = iio_triggered_buffer_postenable(indio_dev);
>  	if (err < 0)
>  		goto st_accel_buffer_postenable_error;
>  
> -	err = iio_triggered_buffer_postenable(indio_dev);
> +	err = st_sensors_set_axis_enable(indio_dev,
> +					(u8)indio_dev->active_scan_mask[0]);
>  	if (err < 0)
> -		goto st_accel_buffer_postenable_error;
> +		goto st_sensors_set_axis_enable_error;
>  
>  	return err;
>  
> +st_sensors_set_axis_enable_error:
> +	iio_triggered_buffer_predisable(indio_dev);
>  st_accel_buffer_postenable_error:
>  	kfree(adata->buffer_data);
>  allocate_memory_error:
> @@ -65,20 +67,22 @@ static int st_accel_buffer_postenable(struct iio_dev *indio_dev)
>  
>  static int st_accel_buffer_predisable(struct iio_dev *indio_dev)
>  {
> -	int err;
> +	int err, err2;
>  	struct st_sensor_data *adata = iio_priv(indio_dev);
>  
> -	err = iio_triggered_buffer_predisable(indio_dev);
> -	if (err < 0)
> -		goto st_accel_buffer_predisable_error;
> -
>  	err = st_sensors_set_axis_enable(indio_dev, ST_SENSORS_ENABLE_ALL_AXIS);
>  	if (err < 0)
>  		goto st_accel_buffer_predisable_error;
>  
>  	err = st_sensors_set_enable(indio_dev, false);
> +	if (err < 0)
> +		goto st_accel_buffer_predisable_error;
>  
>  st_accel_buffer_predisable_error:
> +	err2 = iio_triggered_buffer_predisable(indio_dev);
> +	if (!err)
> +		err = err2;
> +
>  	kfree(adata->buffer_data);
>  	return err;
>  }

