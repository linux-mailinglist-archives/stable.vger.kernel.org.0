Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1FBF68074
	for <lists+stable@lfdr.de>; Sun, 14 Jul 2019 19:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbfGNRUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jul 2019 13:20:32 -0400
Received: from saturn.retrosnub.co.uk ([46.235.226.198]:42028 "EHLO
        saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728065AbfGNRUc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Jul 2019 13:20:32 -0400
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        by saturn.retrosnub.co.uk (Postfix; Retrosnub mail submission) with ESMTPSA id A8A0A9E75A2;
        Sun, 14 Jul 2019 18:20:29 +0100 (BST)
Date:   Sun, 14 Jul 2019 18:20:26 +0100
From:   Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
To:     Jean-Baptiste Maneyrol <JManeyrol@invensense.com>
Cc:     "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] iio: imu: mpu6050: add missing available scan masks
Message-ID: <20190714182026.5edebf23@archlinux>
In-Reply-To: <20190627131918.19619-1-jmaneyrol@invensense.com>
References: <20190627131918.19619-1-jmaneyrol@invensense.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Jun 2019 13:19:53 +0000
Jean-Baptiste Maneyrol <JManeyrol@invensense.com> wrote:

> Driver only supports 3-axis gyro and/or 3-axis accel.
> For icm20602, temp data is mandatory for all configurations.
> 
> Fix all single and double axis configurations (almost never used) and more
> importantly fix 3-axis gyro and 6-axis accel+gyro buffer on icm20602 when
> temp data is not enabled.
> 
> Signed-off-by: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
> Fixes: 1615fe41a195 ("iio: imu: mpu6050: Fix FIFO layout for ICM20602")
Something odd happened in this email that meant my client saved it as garbage.
Oh well, cut and pasted worked ;)

Applied to the fixes-togreg branch of iio.git and marked for stable.

Thanks,

Jonathan

> ---
> Changes in v2:
>   - Use more explicit scan defines for masks
> 
>  drivers/iio/imu/inv_mpu6050/inv_mpu_core.c | 43 ++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
> 
> diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
> index 385f14a4d5a7..66629c3adc21 100644
> --- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
> +++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
> @@ -851,6 +851,25 @@ static const struct iio_chan_spec inv_mpu_channels[] = {
>  	INV_MPU6050_CHAN(IIO_ACCEL, IIO_MOD_Z, INV_MPU6050_SCAN_ACCL_Z),
>  };
>  
> +static const unsigned long inv_mpu_scan_masks[] = {
> +	/* 3-axis accel */
> +	BIT(INV_MPU6050_SCAN_ACCL_X)
> +		| BIT(INV_MPU6050_SCAN_ACCL_Y)
> +		| BIT(INV_MPU6050_SCAN_ACCL_Z),
> +	/* 3-axis gyro */
> +	BIT(INV_MPU6050_SCAN_GYRO_X)
> +		| BIT(INV_MPU6050_SCAN_GYRO_Y)
> +		| BIT(INV_MPU6050_SCAN_GYRO_Z),
> +	/* 6-axis accel + gyro */
> +	BIT(INV_MPU6050_SCAN_ACCL_X)
> +		| BIT(INV_MPU6050_SCAN_ACCL_Y)
> +		| BIT(INV_MPU6050_SCAN_ACCL_Z)
> +		| BIT(INV_MPU6050_SCAN_GYRO_X)
> +		| BIT(INV_MPU6050_SCAN_GYRO_Y)
> +		| BIT(INV_MPU6050_SCAN_GYRO_Z),
> +	0,
> +};
> +
>  static const struct iio_chan_spec inv_icm20602_channels[] = {
>  	IIO_CHAN_SOFT_TIMESTAMP(INV_ICM20602_SCAN_TIMESTAMP),
>  	{
> @@ -877,6 +896,28 @@ static const struct iio_chan_spec inv_icm20602_channels[] = {
>  	INV_MPU6050_CHAN(IIO_ACCEL, IIO_MOD_Z, INV_ICM20602_SCAN_ACCL_Z),
>  };
>  
> +static const unsigned long inv_icm20602_scan_masks[] = {
> +	/* 3-axis accel + temp (mandatory) */
> +	BIT(INV_ICM20602_SCAN_ACCL_X)
> +		| BIT(INV_ICM20602_SCAN_ACCL_Y)
> +		| BIT(INV_ICM20602_SCAN_ACCL_Z)
> +		| BIT(INV_ICM20602_SCAN_TEMP),
> +	/* 3-axis gyro + temp (mandatory) */
> +	BIT(INV_ICM20602_SCAN_GYRO_X)
> +		| BIT(INV_ICM20602_SCAN_GYRO_Y)
> +		| BIT(INV_ICM20602_SCAN_GYRO_Z)
> +		| BIT(INV_ICM20602_SCAN_TEMP),
> +	/* 6-axis accel + gyro + temp (mandatory) */
> +	BIT(INV_ICM20602_SCAN_ACCL_X)
> +		| BIT(INV_ICM20602_SCAN_ACCL_Y)
> +		| BIT(INV_ICM20602_SCAN_ACCL_Z)
> +		| BIT(INV_ICM20602_SCAN_GYRO_X)
> +		| BIT(INV_ICM20602_SCAN_GYRO_Y)
> +		| BIT(INV_ICM20602_SCAN_GYRO_Z)
> +		| BIT(INV_ICM20602_SCAN_TEMP),
> +	0,
> +};
> +
>  /*
>   * The user can choose any frequency between INV_MPU6050_MIN_FIFO_RATE and
>   * INV_MPU6050_MAX_FIFO_RATE, but only these frequencies are matched by the
> @@ -1136,9 +1177,11 @@ int inv_mpu_core_probe(struct regmap *regmap, int irq, const char *name,
>  	if (chip_type == INV_ICM20602) {
>  		indio_dev->channels = inv_icm20602_channels;
>  		indio_dev->num_channels = ARRAY_SIZE(inv_icm20602_channels);
> +		indio_dev->available_scan_masks = inv_icm20602_scan_masks;
>  	} else {
>  		indio_dev->channels = inv_mpu_channels;
>  		indio_dev->num_channels = ARRAY_SIZE(inv_mpu_channels);
> +		indio_dev->available_scan_masks = inv_mpu_scan_masks;
>  	}
>  
>  	indio_dev->info = &mpu_info;

