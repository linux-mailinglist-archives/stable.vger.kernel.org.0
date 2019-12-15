Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50F0411F8B3
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 17:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfLOQBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 11:01:20 -0500
Received: from saturn.retrosnub.co.uk ([46.235.226.198]:44500 "EHLO
        saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbfLOQBU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 11:01:20 -0500
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        by saturn.retrosnub.co.uk (Postfix; Retrosnub mail submission) with ESMTPSA id B153B9E7D76;
        Sun, 15 Dec 2019 15:53:30 +0000 (GMT)
Date:   Sun, 15 Dec 2019 15:53:29 +0000
From:   Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 105/350] iio: chemical: atlas-ph-sensor: fix
 iio_triggered_buffer_predisable() position
Message-ID: <20191215155329.4c71ad53@archlinux>
In-Reply-To: <20191210210735.9077-66-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
        <20191210210735.9077-66-sashal@kernel.org>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 Dec 2019 16:03:30 -0500
Sasha Levin <sashal@kernel.org> wrote:

> From: Alexandru Ardelean <alexandru.ardelean@analog.com>
> 
> [ Upstream commit 0c8a6e72f3c04bfe92a64e5e0791bfe006aabe08 ]
> 
> The iio_triggered_buffer_{predisable,postenable} functions attach/detach
> the poll functions.
> 
> The iio_triggered_buffer_predisable() should be called last, to detach the
> poll func after the devices has been suspended.
> 
> The position of iio_triggered_buffer_postenable() is correct.
> 
> Note this is not stable material. It's a fix in the logical
> model rather fixing an actual bug.  These are being tidied up
> throughout the subsystem to allow more substantial rework that
> was blocked by variations in how things were done.

See comment.  This is not what I would consider stable material.

> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> Acked-by: Matt Ranostay <matt.ranostay@konsulko.com>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/iio/chemical/atlas-ph-sensor.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/iio/chemical/atlas-ph-sensor.c b/drivers/iio/chemical/atlas-ph-sensor.c
> index 3a20cb5d9bffc..6c175eb1c7a7f 100644
> --- a/drivers/iio/chemical/atlas-ph-sensor.c
> +++ b/drivers/iio/chemical/atlas-ph-sensor.c
> @@ -323,16 +323,16 @@ static int atlas_buffer_predisable(struct iio_dev *indio_dev)
>  	struct atlas_data *data = iio_priv(indio_dev);
>  	int ret;
>  
> -	ret = iio_triggered_buffer_predisable(indio_dev);
> +	ret = atlas_set_interrupt(data, false);
>  	if (ret)
>  		return ret;
>  
> -	ret = atlas_set_interrupt(data, false);
> +	pm_runtime_mark_last_busy(&data->client->dev);
> +	ret = pm_runtime_put_autosuspend(&data->client->dev);
>  	if (ret)
>  		return ret;
>  
> -	pm_runtime_mark_last_busy(&data->client->dev);
> -	return pm_runtime_put_autosuspend(&data->client->dev);
> +	return iio_triggered_buffer_predisable(indio_dev);
>  }
>  
>  static const struct iio_trigger_ops atlas_interrupt_trigger_ops = {

