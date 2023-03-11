Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20CB6B5BCB
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 13:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbjCKMfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 07:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjCKMfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 07:35:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A7F1EFF9;
        Sat, 11 Mar 2023 04:35:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53FFF60B85;
        Sat, 11 Mar 2023 12:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96336C433EF;
        Sat, 11 Mar 2023 12:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678538142;
        bh=6JfXxe3XoATFDgJFsxCEos+aZos+Ru8vw/oGDup9HKk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JWdfk00EUqvo5zT5I59OWFNwMcCTIAFvkvB4js5BKAAuQ+aiPhO7ct/9ngNZ9Yoac
         CBd9gFT1AfLMPxWFqojIJbsgSBlBzEfrVZEoMml0j0ciAbP3LzWAUICRMN7zw75Nhk
         2pczrMLdQ00vG5vS5EKSzvBEC63qpyVCXT68UImN7fUpB5mWY4JUFBSYuwaXlIxX8Y
         AOFWjY/hNXAueUCJX4TbD870IW4hFHKJpM7b8I4DgDqyytzw8ZUCYMzrR9ek8Wu/yf
         75lz4SZOLhIyvkznYZ1vLEuKrELEe1gcEM6CmMeD+YkFtcqft47SFv6lQhIv+l7quN
         HWsLN/bm2peUg==
Date:   Sat, 11 Mar 2023 12:35:47 +0000
From:   Jonathan Cameron <jic23@kernel.org>
To:     William Breathitt Gray <william.gray@linaro.org>
Cc:     lars@metafoo.de, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] iio: dac: cio-dac: Fix max DAC write value check for
 12-bit
Message-ID: <20230311123547.66adc751@jic23-huawei>
In-Reply-To: <20230311002248.8548-1-william.gray@linaro.org>
References: <20230311002248.8548-1-william.gray@linaro.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 10 Mar 2023 19:22:48 -0500
William Breathitt Gray <william.gray@linaro.org> wrote:

> The CIO-DAC series of devices only supports DAC values up to 12-bit
> rather than 16-bit. Trying to write a 16-bit value results in only the
> lower 12 bits affecting the DAC output which is not what the user
> expects. Instead, adjust the DAC write value check to reject values
> larger than 12-bit so that they fail explicitly as invalid for the user.
> 
> Fixes: 3b8df5fd526e ("iio: Add IIO support for the Measurement Computing CIO-DAC family")
> Cc: stable@vger.kernel.org
> Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Applied to the fixes-togreg branch of iio.git.

Thanks,

Jonathan

> ---
>  drivers/iio/dac/cio-dac.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iio/dac/cio-dac.c b/drivers/iio/dac/cio-dac.c
> index 791dd999cf29..18a64f72fc18 100644
> --- a/drivers/iio/dac/cio-dac.c
> +++ b/drivers/iio/dac/cio-dac.c
> @@ -66,8 +66,8 @@ static int cio_dac_write_raw(struct iio_dev *indio_dev,
>  	if (mask != IIO_CHAN_INFO_RAW)
>  		return -EINVAL;
>  
> -	/* DAC can only accept up to a 16-bit value */
> -	if ((unsigned int)val > 65535)
> +	/* DAC can only accept up to a 12-bit value */
> +	if ((unsigned int)val > 4095)
>  		return -EINVAL;
>  
>  	priv->chan_out_states[chan->channel] = val;
> 
> base-commit: fe15c26ee26efa11741a7b632e9f23b01aca4cc6

