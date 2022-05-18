Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225CD52C029
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 19:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240490AbiERQuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 12:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240543AbiERQuH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 12:50:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A7E1FE3D0;
        Wed, 18 May 2022 09:50:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FA82B82179;
        Wed, 18 May 2022 16:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902FBC385A5;
        Wed, 18 May 2022 16:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652892598;
        bh=mrwR53rk1gF++vSi+4MuE/+dV8/gsRzcQaeT5Lt+8/o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sd63ooA3nYJWj54vRYmrp660PnlQL7uAEUKtYSSuCiwy1897dtPhR2kGRvtrmh9iT
         szFvtz+OtvebmbBQF7DS7kgHHxNRL0JaVz459t1E4GCB0+zfct6Hmazqn+tJUziK2u
         yHOpJdScb0Cwgj432JZ2yIQuoFmpQRZYQdy+zCaM=
Date:   Wed, 18 May 2022 18:49:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marek Vasut <marex@denx.de>
Cc:     linux-input@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] Input: ili210x - Fix reset timing
Message-ID: <YoUjs5LHo4IAheSC@kroah.com>
References: <20220518163430.41192-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518163430.41192-1-marex@denx.de>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 18, 2022 at 06:34:30PM +0200, Marek Vasut wrote:
> According to Ilitek "231x & ILI251x Programming Guide" Version: 2.30
> "2.1. Power Sequence", "T4 Chip Reset and discharge time" is minimum
> 10ms and "T2 Chip initial time" is maximum 150ms. Adjust the reset
> timings such that T4 is 15ms and T2 is 160ms to fit those figures.
> 
> This prevents sporadic touch controller start up failures when some
> systems with at least ILI251x controller boot, without this patch
> the systems sometimes fail to communicate with the touch controller.
> 
> Fixes: 201f3c803544c ("Input: ili210x - add reset GPIO support")
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/input/touchscreen/ili210x.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/ili210x.c b/drivers/input/touchscreen/ili210x.c
> index 2bd407d86bae5..131cb648a82ae 100644
> --- a/drivers/input/touchscreen/ili210x.c
> +++ b/drivers/input/touchscreen/ili210x.c
> @@ -951,9 +951,9 @@ static int ili210x_i2c_probe(struct i2c_client *client,
>  		if (error)
>  			return error;
>  
> -		usleep_range(50, 100);
> +		msleep(15);
>  		gpiod_set_value_cansleep(reset_gpio, 0);
> -		msleep(100);
> +		msleep(160);
>  	}
>  
>  	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> -- 
> 2.35.1
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
