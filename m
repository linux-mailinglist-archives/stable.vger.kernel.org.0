Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8AFB44EBFA
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 18:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbhKLRb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 12:31:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:41770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232231AbhKLRb1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Nov 2021 12:31:27 -0500
Received: from jic23-huawei (cpc108967-cmbg20-2-0-cust86.5-4.cable.virginm.net [81.101.6.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 008BD60F42;
        Fri, 12 Nov 2021 17:28:33 +0000 (UTC)
Date:   Fri, 12 Nov 2021 17:33:18 +0000
From:   Jonathan Cameron <jic23@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Teng Qi <starmiku1207184332@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.15 66/82] iio: imu: st_lsm6dsx: Avoid
 potential array overflow in st_lsm6dsx_set_odr()
Message-ID: <20211112173318.4369eacb@jic23-huawei>
In-Reply-To: <20211109221641.1233217-66-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
        <20211109221641.1233217-66-sashal@kernel.org>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue,  9 Nov 2021 17:16:24 -0500
Sasha Levin <sashal@kernel.org> wrote:

> From: Teng Qi <starmiku1207184332@gmail.com>
> 
> [ Upstream commit 94be878c882d8d784ff44c639bf55f3b029f85af ]
> 
> The length of hw->settings->odr_table is 2 and ref_sensor->id is an enum
> variable whose value is between 0 and 5.
> However, the value ST_LSM6DSX_ID_MAX (i.e. 5) is not caught properly in
>  switch (sensor->id) {
> 
> If ref_sensor->id is ST_LSM6DSX_ID_MAX, an array overflow will ocurrs in
> function st_lsm6dsx_check_odr():
>   odr_table = &sensor->hw->settings->odr_table[sensor->id];
> 
> and in function st_lsm6dsx_set_odr():
>   reg = &hw->settings->odr_table[ref_sensor->id].reg;
> 
> To avoid this array overflow, handle ST_LSM6DSX_ID_GYRO explicitly and
> return -EINVAL for the default case.
> 
> The enum value ST_LSM6DSX_ID_MAX is only present as an easy way to check
> the limit and as such is never used, however this is not locally obvious.
> 
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Teng Qi <starmiku1207184332@gmail.com>
> Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Link: https://lore.kernel.org/r/20211011114003.976221-1-starmiku1207184332@gmail.com
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This is really just noise for stable.  There wasn't a bug here though
the change is doing some hardening and improving local readability by
saving anyone having to confirm it can't occur by looking at the enum
values.

I don't mind it going into stable though if others feel it's worthwhile.

Jonathan

> ---
>  drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
> index db45f1fc0b817..8dbf744c5651f 100644
> --- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
> +++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
> @@ -1279,6 +1279,8 @@ st_lsm6dsx_set_odr(struct st_lsm6dsx_sensor *sensor, u32 req_odr)
>  	int err;
>  
>  	switch (sensor->id) {
> +	case ST_LSM6DSX_ID_GYRO:
> +		break;
>  	case ST_LSM6DSX_ID_EXT0:
>  	case ST_LSM6DSX_ID_EXT1:
>  	case ST_LSM6DSX_ID_EXT2:
> @@ -1304,8 +1306,8 @@ st_lsm6dsx_set_odr(struct st_lsm6dsx_sensor *sensor, u32 req_odr)
>  		}
>  		break;
>  	}
> -	default:
> -		break;
> +	default: /* should never occur */
> +		return -EINVAL;
>  	}
>  
>  	if (req_odr > 0) {

