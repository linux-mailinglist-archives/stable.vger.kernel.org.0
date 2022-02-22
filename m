Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8894BFA66
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 15:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiBVOJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 09:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbiBVOJN (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 22 Feb 2022 09:09:13 -0500
X-Greylist: delayed 423 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Feb 2022 06:08:45 PST
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C9315B9B7
        for <Stable@vger.kernel.org>; Tue, 22 Feb 2022 06:08:45 -0800 (PST)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout02.posteo.de (Postfix) with ESMTPS id 4D693240101
        for <Stable@vger.kernel.org>; Tue, 22 Feb 2022 15:01:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1645538499; bh=/PWrKJ8pvmVC8hFJap2gdTYjiDPZUf29z5W/Zw+Ylas=;
        h=Subject:From:To:Cc:Date:From;
        b=mBikYIgHgTNEZz7VJQy2BUZubTJL9CwZubpcYEGzr8J8Dv5u+/JvNPuhdp1q9zCyc
         HyIq5komSVYf/6czh6KaocbeXduehja0OV2czW2zJZYY/V+qK1UjnXhzz3Ktd/LBWA
         D/AJ1yOpZVaTdE8jOgRVqkTLAURQS0vcISe1LJRE2R74w9t2LwLZOKii1jUQtwmum7
         xY5A7t3TA3/KLw6DQoKg7sAL07rGC8aLqBBYS85KJQmoCcDcBogbXN64mdHF0/ihC1
         cJcQ/whKdVdAWR3b/1bRfiNrY/K2TCL5p6OfVB8YQ4lQ+CjzAaLMb+gf5hRfrHB9WA
         oH/gbLQhsSmOQ==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4K31756PhVz9rxX;
        Tue, 22 Feb 2022 15:01:37 +0100 (CET)
Message-ID: <9bcd1b17f2d1b8829de94f37fbe1e84250f8716d.camel@posteo.de>
Subject: Re: [PATCH] iio: mma8452: use the correct logic to get mma8452_data
From:   Martin Kepplinger <martink@posteo.de>
To:     haibo.chen@nxp.com, jic23@kernel.org, lars@metafoo.de,
        linux-iio@vger.kernel.org, pmeerw@pmeerw.net
Cc:     Stable@vger.kernel.org, linux-imx@nxp.com
Date:   Tue, 22 Feb 2022 14:01:36 +0000
In-Reply-To: <1645497741-5402-1-git-send-email-haibo.chen@nxp.com>
References: <1645497741-5402-1-git-send-email-haibo.chen@nxp.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Dienstag, dem 22.02.2022 um 10:42 +0800 schrieb haibo.chen@nxp.com:
> From: Haibo Chen <haibo.chen@nxp.com>
> 
> The original logic to get mma8452_data is wrong, the *dev point to
> the device belong to iio_dev. we can't use this dev to find the
> correct i2c_client. The original logic happen to work because it
> finally use dev->driver_data to get iio_dev. Here use the API
> to_i2c_client() is wrong and make reader confuse. To correct the
> logic, it should be like this
> 
>   struct mma8452_data *data = iio_priv(dev_get_drvdata(dev));
> 
> But after commit 8b7651f25962 ("iio: iio_device_alloc(): Remove
> unnecessary self drvdata"), the upper logic also can't work.
> When try to show the avialable scale in userspace, will meet kernel
> dump, kernel handle NULL pointer dereference.
> 
> So use dev_to_iio_dev() to correct the logic.
> 
> Fixes: c3cdd6e48e35 ("iio: mma8452: refactor for seperating chip
> specific data")
> Cc: <Stable@vger.kernel.org>
> Signed-off-by: Haibo Chen <haibo.chen@nxp.com>

Reviewed-by: Martin Kepplinger <martink@posteo.de>

thank you for this fix!

> ---
>  drivers/iio/accel/mma8452.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iio/accel/mma8452.c
> b/drivers/iio/accel/mma8452.c
> index 64b82b4503ad..0016bb947c10 100644
> --- a/drivers/iio/accel/mma8452.c
> +++ b/drivers/iio/accel/mma8452.c
> @@ -379,8 +379,8 @@ static ssize_t mma8452_show_scale_avail(struct
> device *dev,
>                                         struct device_attribute
> *attr,
>                                         char *buf)
>  {
> -       struct mma8452_data *data = iio_priv(i2c_get_clientdata(
> -                                            to_i2c_client(dev)));
> +       struct iio_dev *indio_dev = dev_to_iio_dev(dev);
> +       struct mma8452_data *data = iio_priv(indio_dev);
>  
>         return mma8452_show_int_plus_micros(buf, data->chip_info-
> >mma_scales,
>                 ARRAY_SIZE(data->chip_info->mma_scales));


