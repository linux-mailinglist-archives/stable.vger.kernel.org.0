Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08ED74C5ABC
	for <lists+stable@lfdr.de>; Sun, 27 Feb 2022 12:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiB0Lwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Feb 2022 06:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiB0Lwz (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 27 Feb 2022 06:52:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D5D38DBF;
        Sun, 27 Feb 2022 03:52:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6733B80BA5;
        Sun, 27 Feb 2022 11:52:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B628C340E9;
        Sun, 27 Feb 2022 11:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645962736;
        bh=G6BSH2vwDpxNglA2J2PAEmoCdlAJh2l5DgipC3+5/HI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n41q8HXbRYCmulIVa4FU6KkzGpWehBVvHvmCQXf9JSFT3G6dn/Rm9wZzB/IEtMoKj
         8wjcOLyFtjo3BzxoT3BMA5TiIm37rkCGh378DB9IFJwMnokAD3a++A7fjmTVph46RS
         bd/qis16i6f4TwybjNptVywoZR2xF/fpz8VyAtgmjSwzDgDQ341mbCo8RzdgCgrYqY
         rthKC89tAyBoA0JF8LFuioXBIUfB2r3M7FGrybxaCWsBNrzAJSoHkG4zwl6mL7JTEt
         3RoWAY8qQ6VTOarhdewIC97oq9Apu2qo4Rf/2PDNAmQjsmg7/qtiepU3DLAu3pGPPB
         2A/+GguZBEhkg==
Date:   Sun, 27 Feb 2022 11:59:19 +0000
From:   Jonathan Cameron <jic23@kernel.org>
To:     haibo.chen@nxp.com
Cc:     lars@metafoo.de, linux-iio@vger.kernel.org, pmeerw@pmeerw.net,
        martink@posteo.de, Stable@vger.kernel.org, linux-imx@nxp.com
Subject: Re: [PATCH] iio: mma8452: use the correct logic to get mma8452_data
Message-ID: <20220227115919.159b9b79@jic23-huawei>
In-Reply-To: <1645497741-5402-1-git-send-email-haibo.chen@nxp.com>
References: <1645497741-5402-1-git-send-email-haibo.chen@nxp.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 22 Feb 2022 10:42:21 +0800
haibo.chen@nxp.com wrote:

> From: Haibo Chen <haibo.chen@nxp.com>
> 
> The original logic to get mma8452_data is wrong, the *dev point to
> the device belong to iio_dev. we can't use this dev to find the
> correct i2c_client. The original logic happen to work because it
> finally use dev->driver_data to get iio_dev. Here use the API
> to_i2c_client() is wrong and make reader confuse. To correct the
> logic, it should be like this
> 
>   struct mma8452_data *data = iio_priv(dev_get_drvdata(dev));
> 
> But after commit 8b7651f25962 ("iio: iio_device_alloc(): Remove
> unnecessary self drvdata"), the upper logic also can't work.

I've added as second fixes tag and some explanation of why there
are two.  We should backport the fix all the way to the earlier one
but the bug isn't (by luck) exposed until the patch you mention here.

> When try to show the avialable scale in userspace, will meet kernel
> dump, kernel handle NULL pointer dereference.
> 
> So use dev_to_iio_dev() to correct the logic.
> 
> Fixes: c3cdd6e48e35 ("iio: mma8452: refactor for seperating chip specific data")
> Cc: <Stable@vger.kernel.org>
> Signed-off-by: Haibo Chen <haibo.chen@nxp.com>

Applied to the fixes-togreg branch of iio.git.

> ---
>  drivers/iio/accel/mma8452.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iio/accel/mma8452.c b/drivers/iio/accel/mma8452.c
> index 64b82b4503ad..0016bb947c10 100644
> --- a/drivers/iio/accel/mma8452.c
> +++ b/drivers/iio/accel/mma8452.c
> @@ -379,8 +379,8 @@ static ssize_t mma8452_show_scale_avail(struct device *dev,
>  					struct device_attribute *attr,
>  					char *buf)
>  {
> -	struct mma8452_data *data = iio_priv(i2c_get_clientdata(
> -					     to_i2c_client(dev)));
> +	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
> +	struct mma8452_data *data = iio_priv(indio_dev);
>  
>  	return mma8452_show_int_plus_micros(buf, data->chip_info->mma_scales,
>  		ARRAY_SIZE(data->chip_info->mma_scales));

