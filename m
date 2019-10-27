Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD0B6E6436
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 17:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfJ0QYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 12:24:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbfJ0QYs (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sun, 27 Oct 2019 12:24:48 -0400
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C5B9214AF;
        Sun, 27 Oct 2019 16:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572193486;
        bh=7CxSVaCmpBSmJBldFUW1mN06d37PpbyhFpePM6EfMao=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DabJdPOL1eH6HQgeocxByhYlH11DzUmJ3W6l4Ygc8PAWgd3sU0wUg0Bkk/5LbVUCo
         o+GPiF9k9PrilwFXXPpsSf3deK0DBu9S5GPZDJi7B56aQ5595480ByXH6m2HnJkUg0
         EZEfvpgV5nGgUlWwxMjVu4MTgeBh+DKOBZSLQk8E=
Date:   Sun, 27 Oct 2019 16:24:40 +0000
From:   Jonathan Cameron <jic23@kernel.org>
To:     Nuno =?UTF-8?B?U8Oh?= <nuno.sa@analog.com>
Cc:     <linux-iio@vger.kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        <Stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] iio: adis16480: Fix scales factors
Message-ID: <20191027162440.1fadebfe@archlinux>
In-Reply-To: <20191025124508.166648-1-nuno.sa@analog.com>
References: <20191025124508.166648-1-nuno.sa@analog.com>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Oct 2019 14:45:07 +0200
Nuno S=C3=A1 <nuno.sa@analog.com> wrote:

> This patch fixes the scales for the gyroscope, accelerometer and
> barometer. The pressure scale was just wrong. For the others, the scale
> factors were not taking into account that a 32bit word is being read
> from the device.
>=20
> Fixes: 7abad1063deb ("iio: adis16480: Fix scale factors")
> Fixes: 9fe09f1337ee ("iio: imu: adis16480: Add support for ADIS1649x fami=
ly of devices")
> Fixes: 49c4a18357c8 ("iio: imu: adis16480: Add support for ADIS16490")
> Cc: <Stable@vger.kernel.org>
>=20
> Signed-off-by: Nuno S=C3=A1 <nuno.sa@analog.com>

I can see why this was wrong.  The adis16375 data sheet presents what looks
like a nice easy to understand table with the values stated (Table 14) but
that only covers the upper 16 bits.

Anyhow, fix seems correct to me. The snag is going to be that backporting
is going to be tricky.

Also, that second fixes tag appears to be non existent in my tree or
mainline.  Could you fix that and resend.

Thanks,

Jonathan


> ---
>  drivers/iio/imu/adis16480.c | 77 ++++++++++++++++++++-----------------
>  1 file changed, 41 insertions(+), 36 deletions(-)
>=20
> diff --git a/drivers/iio/imu/adis16480.c b/drivers/iio/imu/adis16480.c
> index b99d73887c9f..3b53bbb11bfb 100644
> --- a/drivers/iio/imu/adis16480.c
> +++ b/drivers/iio/imu/adis16480.c
> @@ -620,9 +620,13 @@ static int adis16480_read_raw(struct iio_dev *indio_=
dev,
>  			*val2 =3D (st->chip_info->temp_scale % 1000) * 1000;
>  			return IIO_VAL_INT_PLUS_MICRO;
>  		case IIO_PRESSURE:
> -			*val =3D 0;
> -			*val2 =3D 4000; /* 40ubar =3D 0.004 kPa */
> -			return IIO_VAL_INT_PLUS_MICRO;
> +			/*
> +			 * max scale is 1310 mbar
> +			 * max raw value is 32767 shifted for 32bits
> +			 */
> +			*val =3D 131; /* 1310mbar =3D 131 kPa */
> +			*val2 =3D 32767 << 16;
> +			return IIO_VAL_FRACTIONAL;
>  		default:
>  			return -EINVAL;
>  		}
> @@ -783,13 +787,14 @@ static const struct adis16480_chip_info adis16480_c=
hip_info[] =3D {
>  		.channels =3D adis16485_channels,
>  		.num_channels =3D ARRAY_SIZE(adis16485_channels),
>  		/*
> -		 * storing the value in rad/degree and the scale in degree
> -		 * gives us the result in rad and better precession than
> -		 * storing the scale directly in rad.
> +		 * Typically we do IIO_RAD_TO_DEGREE in the denominator, which
> +		 * is exactly the same as IIO_DEGREE_TO_RAD in numerator, since
> +		 * it gives better approximation. However, in this case we
> +		 * cannot do it since it would not fit in a 32bit variable.
>  		 */
> -		.gyro_max_val =3D IIO_RAD_TO_DEGREE(22887),
> -		.gyro_max_scale =3D 300,
> -		.accel_max_val =3D IIO_M_S_2_TO_G(21973),
> +		.gyro_max_val =3D 22887 << 16,
> +		.gyro_max_scale =3D IIO_DEGREE_TO_RAD(300),
> +		.accel_max_val =3D IIO_M_S_2_TO_G(21973 << 16),
>  		.accel_max_scale =3D 18,
>  		.temp_scale =3D 5650, /* 5.65 milli degree Celsius */
>  		.int_clk =3D 2460000,
> @@ -799,9 +804,9 @@ static const struct adis16480_chip_info adis16480_chi=
p_info[] =3D {
>  	[ADIS16480] =3D {
>  		.channels =3D adis16480_channels,
>  		.num_channels =3D ARRAY_SIZE(adis16480_channels),
> -		.gyro_max_val =3D IIO_RAD_TO_DEGREE(22500),
> -		.gyro_max_scale =3D 450,
> -		.accel_max_val =3D IIO_M_S_2_TO_G(12500),
> +		.gyro_max_val =3D 22500 << 16,
> +		.gyro_max_scale =3D IIO_DEGREE_TO_RAD(450),
> +		.accel_max_val =3D IIO_M_S_2_TO_G(12500 << 16),
>  		.accel_max_scale =3D 10,
>  		.temp_scale =3D 5650, /* 5.65 milli degree Celsius */
>  		.int_clk =3D 2460000,
> @@ -811,9 +816,9 @@ static const struct adis16480_chip_info adis16480_chi=
p_info[] =3D {
>  	[ADIS16485] =3D {
>  		.channels =3D adis16485_channels,
>  		.num_channels =3D ARRAY_SIZE(adis16485_channels),
> -		.gyro_max_val =3D IIO_RAD_TO_DEGREE(22500),
> -		.gyro_max_scale =3D 450,
> -		.accel_max_val =3D IIO_M_S_2_TO_G(20000),
> +		.gyro_max_val =3D 22500 << 16,
> +		.gyro_max_scale =3D IIO_DEGREE_TO_RAD(450),
> +		.accel_max_val =3D IIO_M_S_2_TO_G(20000 << 16),
>  		.accel_max_scale =3D 5,
>  		.temp_scale =3D 5650, /* 5.65 milli degree Celsius */
>  		.int_clk =3D 2460000,
> @@ -823,9 +828,9 @@ static const struct adis16480_chip_info adis16480_chi=
p_info[] =3D {
>  	[ADIS16488] =3D {
>  		.channels =3D adis16480_channels,
>  		.num_channels =3D ARRAY_SIZE(adis16480_channels),
> -		.gyro_max_val =3D IIO_RAD_TO_DEGREE(22500),
> -		.gyro_max_scale =3D 450,
> -		.accel_max_val =3D IIO_M_S_2_TO_G(22500),
> +		.gyro_max_val =3D 22500 << 16,
> +		.gyro_max_scale =3D IIO_DEGREE_TO_RAD(450),
> +		.accel_max_val =3D IIO_M_S_2_TO_G(22500 << 16),
>  		.accel_max_scale =3D 18,
>  		.temp_scale =3D 5650, /* 5.65 milli degree Celsius */
>  		.int_clk =3D 2460000,
> @@ -835,9 +840,9 @@ static const struct adis16480_chip_info adis16480_chi=
p_info[] =3D {
>  	[ADIS16495_1] =3D {
>  		.channels =3D adis16485_channels,
>  		.num_channels =3D ARRAY_SIZE(adis16485_channels),
> -		.gyro_max_val =3D IIO_RAD_TO_DEGREE(20000),
> -		.gyro_max_scale =3D 125,
> -		.accel_max_val =3D IIO_M_S_2_TO_G(32000),
> +		.gyro_max_val =3D 20000 << 16,
> +		.gyro_max_scale =3D IIO_DEGREE_TO_RAD(125),
> +		.accel_max_val =3D IIO_M_S_2_TO_G(32000 << 16),
>  		.accel_max_scale =3D 8,
>  		.temp_scale =3D 12500, /* 12.5 milli degree Celsius */
>  		.int_clk =3D 4250000,
> @@ -848,9 +853,9 @@ static const struct adis16480_chip_info adis16480_chi=
p_info[] =3D {
>  	[ADIS16495_2] =3D {
>  		.channels =3D adis16485_channels,
>  		.num_channels =3D ARRAY_SIZE(adis16485_channels),
> -		.gyro_max_val =3D IIO_RAD_TO_DEGREE(18000),
> -		.gyro_max_scale =3D 450,
> -		.accel_max_val =3D IIO_M_S_2_TO_G(32000),
> +		.gyro_max_val =3D 18000 << 16,
> +		.gyro_max_scale =3D IIO_DEGREE_TO_RAD(450),
> +		.accel_max_val =3D IIO_M_S_2_TO_G(32000 << 16),
>  		.accel_max_scale =3D 8,
>  		.temp_scale =3D 12500, /* 12.5 milli degree Celsius */
>  		.int_clk =3D 4250000,
> @@ -861,9 +866,9 @@ static const struct adis16480_chip_info adis16480_chi=
p_info[] =3D {
>  	[ADIS16495_3] =3D {
>  		.channels =3D adis16485_channels,
>  		.num_channels =3D ARRAY_SIZE(adis16485_channels),
> -		.gyro_max_val =3D IIO_RAD_TO_DEGREE(20000),
> -		.gyro_max_scale =3D 2000,
> -		.accel_max_val =3D IIO_M_S_2_TO_G(32000),
> +		.gyro_max_val =3D 20000 << 16,
> +		.gyro_max_scale =3D IIO_DEGREE_TO_RAD(2000),
> +		.accel_max_val =3D IIO_M_S_2_TO_G(32000 << 16),
>  		.accel_max_scale =3D 8,
>  		.temp_scale =3D 12500, /* 12.5 milli degree Celsius */
>  		.int_clk =3D 4250000,
> @@ -874,9 +879,9 @@ static const struct adis16480_chip_info adis16480_chi=
p_info[] =3D {
>  	[ADIS16497_1] =3D {
>  		.channels =3D adis16485_channels,
>  		.num_channels =3D ARRAY_SIZE(adis16485_channels),
> -		.gyro_max_val =3D IIO_RAD_TO_DEGREE(20000),
> -		.gyro_max_scale =3D 125,
> -		.accel_max_val =3D IIO_M_S_2_TO_G(32000),
> +		.gyro_max_val =3D 20000 << 16,
> +		.gyro_max_scale =3D IIO_DEGREE_TO_RAD(125),
> +		.accel_max_val =3D IIO_M_S_2_TO_G(32000 << 16),
>  		.accel_max_scale =3D 40,
>  		.temp_scale =3D 12500, /* 12.5 milli degree Celsius */
>  		.int_clk =3D 4250000,
> @@ -887,9 +892,9 @@ static const struct adis16480_chip_info adis16480_chi=
p_info[] =3D {
>  	[ADIS16497_2] =3D {
>  		.channels =3D adis16485_channels,
>  		.num_channels =3D ARRAY_SIZE(adis16485_channels),
> -		.gyro_max_val =3D IIO_RAD_TO_DEGREE(18000),
> -		.gyro_max_scale =3D 450,
> -		.accel_max_val =3D IIO_M_S_2_TO_G(32000),
> +		.gyro_max_val =3D 18000 << 16,
> +		.gyro_max_scale =3D IIO_DEGREE_TO_RAD(450),
> +		.accel_max_val =3D IIO_M_S_2_TO_G(32000 << 16),
>  		.accel_max_scale =3D 40,
>  		.temp_scale =3D 12500, /* 12.5 milli degree Celsius */
>  		.int_clk =3D 4250000,
> @@ -900,9 +905,9 @@ static const struct adis16480_chip_info adis16480_chi=
p_info[] =3D {
>  	[ADIS16497_3] =3D {
>  		.channels =3D adis16485_channels,
>  		.num_channels =3D ARRAY_SIZE(adis16485_channels),
> -		.gyro_max_val =3D IIO_RAD_TO_DEGREE(20000),
> -		.gyro_max_scale =3D 2000,
> -		.accel_max_val =3D IIO_M_S_2_TO_G(32000),
> +		.gyro_max_val =3D 20000 << 16,
> +		.gyro_max_scale =3D IIO_DEGREE_TO_RAD(2000),
> +		.accel_max_val =3D IIO_M_S_2_TO_G(32000 << 16),
>  		.accel_max_scale =3D 40,
>  		.temp_scale =3D 12500, /* 12.5 milli degree Celsius */
>  		.int_clk =3D 4250000,

