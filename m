Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B522254B2BF
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 16:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbiFNOFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 10:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235951AbiFNOFg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 10:05:36 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D063A724;
        Tue, 14 Jun 2022 07:05:34 -0700 (PDT)
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LMqt66rQzz67ZGL;
        Tue, 14 Jun 2022 22:03:58 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 14 Jun 2022 16:05:32 +0200
Received: from localhost (10.81.210.75) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 14 Jun
 2022 15:05:31 +0100
Date:   Tue, 14 Jun 2022 15:05:29 +0100
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Denis Ciocca <denis.ciocca@st.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 167/247] iio: st_sensors: Add a local lock for
 protecting odr
Message-ID: <20220614150529.00004e13@Huawei.com>
In-Reply-To: <20220613094928.023172711@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
        <20220613094928.023172711@linuxfoundation.org>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.81.210.75]
X-ClientProxiedBy: lhreml740-chm.china.huawei.com (10.201.108.190) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 13 Jun 2022 12:11:09 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> From: Miquel Raynal <miquel.raynal@bootlin.com>
> 
> [ Upstream commit 474010127e2505fc463236470908e1ff5ddb3578 ]
> 
> Right now the (framework) mlock lock is (ab)used for multiple purposes:
> 1- protecting concurrent accesses over the odr local cache
> 2- avoid changing samplig frequency whilst buffer is running
> 
> Let's start by handling situation #1 with a local lock.

This is harmless, but not a fix but rather part of a long running
effort to abstract away the use of iio_dev->mlock.

What's there before this isn't broken, but rather isn't the way
we would do it today.

Thanks,

Jonathan

> 
> Suggested-by: Jonathan Cameron <jic23@kernel.org>
> Cc: Denis Ciocca <denis.ciocca@st.com>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> Link: https://lore.kernel.org/r/20220207143840.707510-7-miquel.raynal@bootlin.com
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  .../iio/common/st_sensors/st_sensors_core.c   | 24 ++++++++++++++-----
>  include/linux/iio/common/st_sensors.h         |  3 +++
>  2 files changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/iio/common/st_sensors/st_sensors_core.c b/drivers/iio/common/st_sensors/st_sensors_core.c
> index 0bbb090b108c..aff981551617 100644
> --- a/drivers/iio/common/st_sensors/st_sensors_core.c
> +++ b/drivers/iio/common/st_sensors/st_sensors_core.c
> @@ -71,16 +71,18 @@ static int st_sensors_match_odr(struct st_sensor_settings *sensor_settings,
>  
>  int st_sensors_set_odr(struct iio_dev *indio_dev, unsigned int odr)
>  {
> -	int err;
> +	int err = 0;
>  	struct st_sensor_odr_avl odr_out = {0, 0};
>  	struct st_sensor_data *sdata = iio_priv(indio_dev);
>  
> +	mutex_lock(&sdata->odr_lock);
> +
>  	if (!sdata->sensor_settings->odr.mask)
> -		return 0;
> +		goto unlock_mutex;
>  
>  	err = st_sensors_match_odr(sdata->sensor_settings, odr, &odr_out);
>  	if (err < 0)
> -		goto st_sensors_match_odr_error;
> +		goto unlock_mutex;
>  
>  	if ((sdata->sensor_settings->odr.addr ==
>  					sdata->sensor_settings->pw.addr) &&
> @@ -103,7 +105,9 @@ int st_sensors_set_odr(struct iio_dev *indio_dev, unsigned int odr)
>  	if (err >= 0)
>  		sdata->odr = odr_out.hz;
>  
> -st_sensors_match_odr_error:
> +unlock_mutex:
> +	mutex_unlock(&sdata->odr_lock);
> +
>  	return err;
>  }
>  EXPORT_SYMBOL(st_sensors_set_odr);
> @@ -365,6 +369,8 @@ int st_sensors_init_sensor(struct iio_dev *indio_dev,
>  	struct st_sensors_platform_data *of_pdata;
>  	int err = 0;
>  
> +	mutex_init(&sdata->odr_lock);
> +
>  	/* If OF/DT pdata exists, it will take precedence of anything else */
>  	of_pdata = st_sensors_dev_probe(indio_dev->dev.parent, pdata);
>  	if (IS_ERR(of_pdata))
> @@ -558,18 +564,24 @@ int st_sensors_read_info_raw(struct iio_dev *indio_dev,
>  		err = -EBUSY;
>  		goto out;
>  	} else {
> +		mutex_lock(&sdata->odr_lock);
>  		err = st_sensors_set_enable(indio_dev, true);
> -		if (err < 0)
> +		if (err < 0) {
> +			mutex_unlock(&sdata->odr_lock);
>  			goto out;
> +		}
>  
>  		msleep((sdata->sensor_settings->bootime * 1000) / sdata->odr);
>  		err = st_sensors_read_axis_data(indio_dev, ch, val);
> -		if (err < 0)
> +		if (err < 0) {
> +			mutex_unlock(&sdata->odr_lock);
>  			goto out;
> +		}
>  
>  		*val = *val >> ch->scan_type.shift;
>  
>  		err = st_sensors_set_enable(indio_dev, false);
> +		mutex_unlock(&sdata->odr_lock);
>  	}
>  out:
>  	mutex_unlock(&indio_dev->mlock);
> diff --git a/include/linux/iio/common/st_sensors.h b/include/linux/iio/common/st_sensors.h
> index 8bdbaf3f3796..69f4a1f6b536 100644
> --- a/include/linux/iio/common/st_sensors.h
> +++ b/include/linux/iio/common/st_sensors.h
> @@ -238,6 +238,7 @@ struct st_sensor_settings {
>   * @hw_irq_trigger: if we're using the hardware interrupt on the sensor.
>   * @hw_timestamp: Latest timestamp from the interrupt handler, when in use.
>   * @buffer_data: Data used by buffer part.
> + * @odr_lock: Local lock for preventing concurrent ODR accesses/changes
>   */
>  struct st_sensor_data {
>  	struct device *dev;
> @@ -263,6 +264,8 @@ struct st_sensor_data {
>  	s64 hw_timestamp;
>  
>  	char buffer_data[ST_SENSORS_MAX_BUFFER_SIZE] ____cacheline_aligned;
> +
> +	struct mutex odr_lock;
>  };
>  
>  #ifdef CONFIG_IIO_BUFFER

