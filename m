Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D048547649
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 17:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbiFKP6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 11:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233764AbiFKP6D (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 11:58:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B111BE80;
        Sat, 11 Jun 2022 08:58:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 494E761141;
        Sat, 11 Jun 2022 15:58:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D074C34116;
        Sat, 11 Jun 2022 15:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654963079;
        bh=FhgN2vUGgOYTi+NpV56KcEfAM0fOy/Eey/UOiYEvnDo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MNI6lIczbMGZ1BFhReMFK3FY/cICVPubC4QA2vpNRvsqr/ORN3QRPdnGAthAnmu4p
         pa39+EYtDPWBN/HxD8lDyByFWRXP5Duv8On0afRXAd2HtwO2VnXOjgQOiMkginXSuY
         0cCwtD0UCDkelxg3Eml53unfJ5bUFzw0HHZhWqVFXVixBFDGfIxRaS8DI37HJDLsS5
         QsvjL13M7gOS4vOcs3AwMRgkYtLfj5Ig6ulCTHoY/6uVlLMv84JX/trDjcM/Kp+NK/
         K3TWXKaQDybxeM6qalNF1a5VR1dO8UIffNMAB6ffDaOxn//CXW0WaKpa4WdzqKng5L
         IYzB2aVMW6KyQ==
Date:   Sat, 11 Jun 2022 17:07:09 +0100
From:   Jonathan Cameron <jic23@kernel.org>
To:     Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
Cc:     linux-iio@vger.kernel.org, stable@vger.kernel.org,
        Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Subject: Re: [PATCH] iio: imu: inv_icm42600: Fix broken icm42600 (chip id 0
 value)
Message-ID: <20220611170709.19840961@jic23-huawei>
In-Reply-To: <20220609102301.4794-1-jmaneyrol@invensense.com>
References: <20220609102301.4794-1-jmaneyrol@invensense.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu,  9 Jun 2022 12:23:01 +0200
Jean-Baptiste Maneyrol <jmaneyrol@invensense.com> wrote:

> From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
> 
> The 0 value used for INV_CHIP_ICM42600 was not working since the
> match in i2c/spi was checking against NULL value.
> 
> To keep this check, add a first INV_CHIP_INVALID 0 value as safe
> guard.
> 
> Fixes: 31c24c1e93c3 ("iio: imu: inv_icm42600: add core of new inv_icm42600 driver")
> Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

Applied to the fixes-togreg branch of iio.git.

Thanks,

Jonathan

> ---
>  drivers/iio/imu/inv_icm42600/inv_icm42600.h      | 1 +
>  drivers/iio/imu/inv_icm42600/inv_icm42600_core.c | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/imu/inv_icm42600/inv_icm42600.h b/drivers/iio/imu/inv_icm42600/inv_icm42600.h
> index 62fedac54e65..3d91469beccb 100644
> --- a/drivers/iio/imu/inv_icm42600/inv_icm42600.h
> +++ b/drivers/iio/imu/inv_icm42600/inv_icm42600.h
> @@ -17,6 +17,7 @@
>  #include "inv_icm42600_buffer.h"
>  
>  enum inv_icm42600_chip {
> +	INV_CHIP_INVALID,
>  	INV_CHIP_ICM42600,
>  	INV_CHIP_ICM42602,
>  	INV_CHIP_ICM42605,
> diff --git a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
> index 86858da9cc38..ca85fccc9839 100644
> --- a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
> +++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
> @@ -565,7 +565,7 @@ int inv_icm42600_core_probe(struct regmap *regmap, int chip, int irq,
>  	bool open_drain;
>  	int ret;
>  
> -	if (chip < 0 || chip >= INV_CHIP_NB) {
> +	if (chip <= INV_CHIP_INVALID || chip >= INV_CHIP_NB) {
>  		dev_err(dev, "invalid chip = %d\n", chip);
>  		return -ENODEV;
>  	}

