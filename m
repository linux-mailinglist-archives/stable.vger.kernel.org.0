Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 931ED11F8A6
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 16:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfLOP6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 10:58:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:36858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbfLOP6v (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Dec 2019 10:58:51 -0500
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54FE520726;
        Sun, 15 Dec 2019 15:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576425530;
        bh=Lb6bRogCAQv2A8z1QGFmErVearjfTXEt+fi8X/hIV3U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eeOosFvPk/n7icpTEC8v9UXeXmYfrIU23xsFDE6TAH62kVouNipzAT0CIXqvbCrGB
         MxgQ71NI47mD4qeVTTUujc1rUfP0YcO2jIqUuaBNu+g4VmFb3iC/jVmSNjTlHy9E3r
         ueGwASHh83GfvPqGbxJKOqejw+O02ao7O00Lr/zU=
Date:   Sun, 15 Dec 2019 15:58:46 +0000
From:   Jonathan Cameron <jic23@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 192/350] iio: dln2-adc: fix
 iio_triggered_buffer_postenable() position
Message-ID: <20191215155846.37c85c2e@archlinux>
In-Reply-To: <20191210210735.9077-153-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
        <20191210210735.9077-153-sashal@kernel.org>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 Dec 2019 16:04:57 -0500
Sasha Levin <sashal@kernel.org> wrote:

> From: Alexandru Ardelean <alexandru.ardelean@analog.com>
> 
> [ Upstream commit a7bddfe2dfce1d8859422124abe1964e0ecd386e ]
> 
> The iio_triggered_buffer_postenable() hook should be called first to
> attach the poll function. The iio_triggered_buffer_predisable() hook is
> called last (as is it should).
> 
> This change moves iio_triggered_buffer_postenable() to be called first. It
> adds iio_triggered_buffer_predisable() on the error paths of the postenable
> hook.
> For the predisable hook, some code-paths have been changed to make sure
> that the iio_triggered_buffer_predisable() hook gets called in case there
> is an error before it.

Again, fixing logic to allow a more generic rework rather than actual bug.

I didn't do a very good job of adding notes to all of these to indicate
they weren't stable material. Sorry about that.

Note I am fairly careful about tagging fixes that should go to stable...

Jonathan

> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/iio/adc/dln2-adc.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/iio/adc/dln2-adc.c b/drivers/iio/adc/dln2-adc.c
> index 5fa78c273a258..65c7c9329b1c3 100644
> --- a/drivers/iio/adc/dln2-adc.c
> +++ b/drivers/iio/adc/dln2-adc.c
> @@ -524,6 +524,10 @@ static int dln2_adc_triggered_buffer_postenable(struct iio_dev *indio_dev)
>  	u16 conflict;
>  	unsigned int trigger_chan;
>  
> +	ret = iio_triggered_buffer_postenable(indio_dev);
> +	if (ret)
> +		return ret;
> +
>  	mutex_lock(&dln2->mutex);
>  
>  	/* Enable ADC */
> @@ -537,6 +541,7 @@ static int dln2_adc_triggered_buffer_postenable(struct iio_dev *indio_dev)
>  				(int)conflict);
>  			ret = -EBUSY;
>  		}
> +		iio_triggered_buffer_predisable(indio_dev);
>  		return ret;
>  	}
>  
> @@ -550,6 +555,7 @@ static int dln2_adc_triggered_buffer_postenable(struct iio_dev *indio_dev)
>  		mutex_unlock(&dln2->mutex);
>  		if (ret < 0) {
>  			dev_dbg(&dln2->pdev->dev, "Problem in %s\n", __func__);
> +			iio_triggered_buffer_predisable(indio_dev);
>  			return ret;
>  		}
>  	} else {
> @@ -557,12 +563,12 @@ static int dln2_adc_triggered_buffer_postenable(struct iio_dev *indio_dev)
>  		mutex_unlock(&dln2->mutex);
>  	}
>  
> -	return iio_triggered_buffer_postenable(indio_dev);
> +	return 0;
>  }
>  
>  static int dln2_adc_triggered_buffer_predisable(struct iio_dev *indio_dev)
>  {
> -	int ret;
> +	int ret, ret2;
>  	struct dln2_adc *dln2 = iio_priv(indio_dev);
>  
>  	mutex_lock(&dln2->mutex);
> @@ -577,12 +583,14 @@ static int dln2_adc_triggered_buffer_predisable(struct iio_dev *indio_dev)
>  	ret = dln2_adc_set_port_enabled(dln2, false, NULL);
>  
>  	mutex_unlock(&dln2->mutex);
> -	if (ret < 0) {
> +	if (ret < 0)
>  		dev_dbg(&dln2->pdev->dev, "Problem in %s\n", __func__);
> -		return ret;
> -	}
>  
> -	return iio_triggered_buffer_predisable(indio_dev);
> +	ret2 = iio_triggered_buffer_predisable(indio_dev);
> +	if (ret == 0)
> +		ret = ret2;
> +
> +	return ret;
>  }
>  
>  static const struct iio_buffer_setup_ops dln2_adc_buffer_setup_ops = {

