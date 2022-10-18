Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92412602690
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 10:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiJRIOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 04:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiJRIN5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 04:13:57 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0FA915D6;
        Tue, 18 Oct 2022 01:13:55 -0700 (PDT)
Received: (Authenticated sender: kamel.bouhara@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4709260007;
        Tue, 18 Oct 2022 08:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666080834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mJzeUW1UFkFqsunmmvpSAnfHIknWqTroU2tIgfKPq7E=;
        b=hRFHIWENzLdUlQmeCeIVuh+Klv8gGYW653bkCunGb5bIleKb0ftuEsgHmhxkqESIISTLRL
        s2XCluw8LBa4Ql2g2/izTNWrh7TG7xfcU1kGmgUL+r/9L8c6XPoo6Qzjxn+9+oA2+SQSd+
        RpdYJdE0bhqcIuhBkll84l5aMGU6uBhcs2/n/pL7JMMcaI9tyl0X+boM8YNkVlCLHwN+Gm
        fdMIfpIfZQ+JUMhx7JRWAU0Hl65f0MdkHFMQTfg/TyrRTzngz3vcxN8/xefnomCsuGq8Pi
        aDN298Ftdy3WjNjzeqxqwrgjAE0lqGYyWtULExb/gXVLR9zE/0YrgP53Ghgk9w==
Date:   Tue, 18 Oct 2022 10:13:51 +0200
From:   Kamel Bouhara <kamel.bouhara@bootlin.com>
To:     William Breathitt Gray <william.gray@linaro.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        stable@kernel.org
Subject: Re: [PATCH] counter: microchip-tcb-capture: Handle Signal1 read and
 Synapse
Message-ID: <Y05gPzkIciwVuUdB@kb-xps>
References: <20221017225404.67127-1-william.gray@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017225404.67127-1-william.gray@linaro.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 17, 2022 at 06:54:04PM -0400, William Breathitt Gray wrote:
> The signal_read(), action_read(), and action_write() callbacks have been
> assuming Signal0 is requested without checking. This results in requests
> for Signal1 returning data for Signal0. This patch fixes these
> oversights by properly checking for the Signal's id in the respective
> callbacks and handling accordingly based on the particular Signal
> requested. The trig_inverted member of the mchp_tc_data is removed as
> superfluous.
>
> Fixes: 106b104137fd ("counter: Add microchip TCB capture counter")
> Cc: stable@kernel.org
> Cc: Kamel Bouhara <kamel.bouhara@bootlin.com>
> Signed-off-by: William Breathitt Gray <william.gray@linaro.org>

Looks ok to me, thanks.

Reviewed-by: Kamel Bouhara <kamel.bouhara@bootlin.com>

> ---
>  drivers/counter/microchip-tcb-capture.c | 57 ++++++++++++++++---------
>  1 file changed, 38 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/counter/microchip-tcb-capture.c b/drivers/counter/microchip-tcb-capture.c
> index f9dee15d9777..438f82b07a03 100644
> --- a/drivers/counter/microchip-tcb-capture.c
> +++ b/drivers/counter/microchip-tcb-capture.c
> @@ -28,7 +28,6 @@ struct mchp_tc_data {
>  	int qdec_mode;
>  	int num_channels;
>  	int channel[2];
> -	bool trig_inverted;
>  };
>
>  static const enum counter_function mchp_tc_count_functions[] = {
> @@ -153,7 +152,7 @@ static int mchp_tc_count_signal_read(struct counter_device *counter,
>
>  	regmap_read(priv->regmap, ATMEL_TC_REG(priv->channel[0], SR), &sr);
>
> -	if (priv->trig_inverted)
> +	if (signal->id == 1)
>  		sigstatus = (sr & ATMEL_TC_MTIOB);
>  	else
>  		sigstatus = (sr & ATMEL_TC_MTIOA);
> @@ -169,26 +168,46 @@ static int mchp_tc_count_action_read(struct counter_device *counter,
>  				     enum counter_synapse_action *action)
>  {
>  	struct mchp_tc_data *const priv = counter_priv(counter);
> +	const unsigned int cmr_reg = ATMEL_TC_REG(priv->channel[0], CMR);
> +	enum counter_function function;
> +	int err;
>  	u32 cmr;
>
> -	regmap_read(priv->regmap, ATMEL_TC_REG(priv->channel[0], CMR), &cmr);
> +	err = mchp_tc_count_function_read(counter, count, &function);
> +	if (err)
> +		return err;
>
> -	switch (cmr & ATMEL_TC_ETRGEDG) {
> -	default:
> -		*action = COUNTER_SYNAPSE_ACTION_NONE;
> -		break;
> -	case ATMEL_TC_ETRGEDG_RISING:
> -		*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
> -		break;
> -	case ATMEL_TC_ETRGEDG_FALLING:
> -		*action = COUNTER_SYNAPSE_ACTION_FALLING_EDGE;
> -		break;
> -	case ATMEL_TC_ETRGEDG_BOTH:
> +	/* Default action mode */
> +	*action = COUNTER_SYNAPSE_ACTION_NONE;
> +
> +	switch (function) {
> +	case COUNTER_FUNCTION_INCREASE:
> +		/* TIOB signal is ignored */
> +		if (synapse->signal->id == 1)
> +			return 0;
> +
> +		regmap_read(priv->regmap, cmr_reg, &cmr);
> +
> +		switch (cmr & ATMEL_TC_ETRGEDG) {
> +		case ATMEL_TC_ETRGEDG_RISING:
> +			*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
> +			return 0;
> +		case ATMEL_TC_ETRGEDG_FALLING:
> +			*action = COUNTER_SYNAPSE_ACTION_FALLING_EDGE;
> +			return 0;
> +		case ATMEL_TC_ETRGEDG_BOTH:
> +			*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
> +			return 0;
> +		default:
> +			return 0;
> +		}
> +	case COUNTER_FUNCTION_QUADRATURE_X4:
>  		*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
> -		break;
> +		return 0;
> +	default:
> +		/* should never reach this path */
> +		return -EINVAL;
>  	}
> -
> -	return 0;
>  }
>
>  static int mchp_tc_count_action_write(struct counter_device *counter,
> @@ -199,8 +218,8 @@ static int mchp_tc_count_action_write(struct counter_device *counter,
>  	struct mchp_tc_data *const priv = counter_priv(counter);
>  	u32 edge = ATMEL_TC_ETRGEDG_NONE;
>
> -	/* QDEC mode is rising edge only */
> -	if (priv->qdec_mode)
> +	/* QDEC mode is rising edge only; only TIOA handled in non-QDEC mode */
> +	if (priv->qdec_mode || synapse->signal->id != 0)
>  		return -EINVAL;
>
>  	switch (action) {
> --
> 2.37.3
>

--
Kamel Bouhara, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com
