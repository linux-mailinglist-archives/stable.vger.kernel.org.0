Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8F611F8C8
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 17:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfLOQGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 11:06:20 -0500
Received: from saturn.retrosnub.co.uk ([46.235.226.198]:44530 "EHLO
        saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfLOQGT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 11:06:19 -0500
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        by saturn.retrosnub.co.uk (Postfix; Retrosnub mail submission) with ESMTPSA id EC0A59E74F7;
        Sun, 15 Dec 2019 15:57:01 +0000 (GMT)
Date:   Sun, 15 Dec 2019 15:57:00 +0000
From:   Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 137/350] iio: pressure: zpa2326: fix
 iio_triggered_buffer_postenable position
Message-ID: <20191215155700.5183d752@archlinux>
In-Reply-To: <20191210210735.9077-98-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
        <20191210210735.9077-98-sashal@kernel.org>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 Dec 2019 16:04:02 -0500
Sasha Levin <sashal@kernel.org> wrote:

> From: Alexandru Ardelean <alexandru.ardelean@analog.com>
> 
> [ Upstream commit fe2392c67db9730d46f11fc4fadfa7bffa8843fa ]
> 
> The iio_triggered_buffer_{predisable,postenable} functions attach/detach
> the poll functions.
> 
> The iio_triggered_buffer_postenable() should be called before (to attach
> the poll func) and then the
> 
> The iio_triggered_buffer_predisable() function is hooked directly without
> anything, which is probably fine, as the postenable() version seems to also
> do some reset/wake-up of the device.
> This will mean it will be easier when removing it; i.e. it just gets
> removed.

Ah. I should have added a note to this one as well.  This is more general
rework, that is a fix in the sense of bringing things towards a standard
way of doing things rather than 'fixing' a known bug.

Alex, for any more of these, lets not have fix in the title (though they
sort of do 'fix' things).

Thanks,

Jonathan

> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/iio/pressure/zpa2326.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/iio/pressure/zpa2326.c b/drivers/iio/pressure/zpa2326.c
> index 9d0d07930236e..99dfe33ee402f 100644
> --- a/drivers/iio/pressure/zpa2326.c
> +++ b/drivers/iio/pressure/zpa2326.c
> @@ -1243,6 +1243,11 @@ static int zpa2326_postenable_buffer(struct iio_dev *indio_dev)
>  	const struct zpa2326_private *priv = iio_priv(indio_dev);
>  	int                           err;
>  
> +	/* Plug our own trigger event handler. */
> +	err = iio_triggered_buffer_postenable(indio_dev);
> +	if (err)
> +		goto err;
> +
>  	if (!priv->waken) {
>  		/*
>  		 * We were already power supplied. Just clear hardware FIFO to
> @@ -1250,7 +1255,7 @@ static int zpa2326_postenable_buffer(struct iio_dev *indio_dev)
>  		 */
>  		err = zpa2326_clear_fifo(indio_dev, 0);
>  		if (err)
> -			goto err;
> +			goto err_buffer_predisable;
>  	}
>  
>  	if (!iio_trigger_using_own(indio_dev) && priv->waken) {
> @@ -1260,16 +1265,13 @@ static int zpa2326_postenable_buffer(struct iio_dev *indio_dev)
>  		 */
>  		err = zpa2326_config_oneshot(indio_dev, priv->irq);
>  		if (err)
> -			goto err;
> +			goto err_buffer_predisable;
>  	}
>  
> -	/* Plug our own trigger event handler. */
> -	err = iio_triggered_buffer_postenable(indio_dev);
> -	if (err)
> -		goto err;
> -
>  	return 0;
>  
> +err_buffer_predisable:
> +	iio_triggered_buffer_predisable(indio_dev);
>  err:
>  	zpa2326_err(indio_dev, "failed to enable buffering (%d)", err);
>  

