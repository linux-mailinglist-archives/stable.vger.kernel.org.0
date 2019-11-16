Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A443BFEC93
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 15:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbfKPOIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 09:08:49 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:38195 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727551AbfKPOIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Nov 2019 09:08:49 -0500
Received: from webmail.gandi.net (webmail15.sd4.0x35.net [10.200.201.15])
        (Authenticated sender: contact@artur-rojek.eu)
        by relay12.mail.gandi.net (Postfix) with ESMTPA id 58C58200002;
        Sat, 16 Nov 2019 14:08:46 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 16 Nov 2019 15:08:46 +0100
From:   Artur Rojek <contact@artur-rojek.eu>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, od@zcrc.me, stable@vger.kernel.org
Subject: Re: [PATCH v3] power/supply: ingenic-battery: Don't change scale if
 there's only one
In-Reply-To: <20191116135619.9545-1-paul@crapouillou.net>
References: <20191116135619.9545-1-paul@crapouillou.net>
Message-ID: <d5d13a62c1652ce109136dcb3b2e1e51@artur-rojek.eu>
X-Sender: contact@artur-rojek.eu
User-Agent: Roundcube Webmail/1.3.8
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-11-16 14:56, Paul Cercueil wrote:
> The ADC in the JZ4740 can work either in high-precision mode with a 
> 2.5V
> range, or in low-precision mode with a 7.5V range. The code in place in
> this driver will select the proper scale according to the maximum
> voltage of the battery.
> 
> The JZ4770 however only has one mode, with a 6.6V range. If only one
> scale is available, there's no need to change it (and nothing to change
> it to), and trying to do so will fail with -EINVAL.
> 
> Fixes: fb24ccfbe1e0 ("power: supply: add Ingenic JZ47xx battery 
> driver.")
> 
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> Cc: stable@vger.kernel.org

Looks good to me!

Acked-by: Artur Rojek <contact@artur-rojek.eu>

> ---
> 
> Notes:
>     v2: Rebased on v5.4-rc7
>     v3: Move code after check for max scale voltage
> 
>  drivers/power/supply/ingenic-battery.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/power/supply/ingenic-battery.c
> b/drivers/power/supply/ingenic-battery.c
> index 35816d4b3012..2748715c4c75 100644
> --- a/drivers/power/supply/ingenic-battery.c
> +++ b/drivers/power/supply/ingenic-battery.c
> @@ -100,10 +100,17 @@ static int ingenic_battery_set_scale(struct
> ingenic_battery *bat)
>  		return -EINVAL;
>  	}
> 
> -	return iio_write_channel_attribute(bat->channel,
> -					   scale_raw[best_idx],
> -					   scale_raw[best_idx + 1],
> -					   IIO_CHAN_INFO_SCALE);
> +	/* Only set scale if there is more than one (fractional) entry */
> +	if (scale_len > 2) {
> +		ret = iio_write_channel_attribute(bat->channel,
> +						  scale_raw[best_idx],
> +						  scale_raw[best_idx + 1],
> +						  IIO_CHAN_INFO_SCALE);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
>  }
> 
>  static enum power_supply_property ingenic_battery_properties[] = {
