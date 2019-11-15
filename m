Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7077FFE431
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 18:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfKORjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 12:39:43 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:54401 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbfKORjn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 12:39:43 -0500
Received: from webmail.gandi.net (webmail15.sd4.0x35.net [10.200.201.15])
        (Authenticated sender: contact@artur-rojek.eu)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPA id 57CC0240002;
        Fri, 15 Nov 2019 17:39:40 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 15 Nov 2019 18:39:40 +0100
From:   Artur Rojek <contact@artur-rojek.eu>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] power/supply: ingenic-battery: Don't change scale if
 there's only one
In-Reply-To: <20191114163500.57384-1-paul@crapouillou.net>
References: <20191114163500.57384-1-paul@crapouillou.net>
Message-ID: <0f300a5f82b4cce76cdbdb5ba081d7ae@artur-rojek.eu>
X-Sender: contact@artur-rojek.eu
User-Agent: Roundcube Webmail/1.3.8
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paul.
Comments inline.

On 2019-11-14 17:35, Paul Cercueil wrote:
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
> ---
> 
> Notes:
>     v2: Rebased on v5.4-rc7
> 
>  drivers/power/supply/ingenic-battery.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/power/supply/ingenic-battery.c
> b/drivers/power/supply/ingenic-battery.c
> index 35816d4b3012..5a53057b4f64 100644
> --- a/drivers/power/supply/ingenic-battery.c
> +++ b/drivers/power/supply/ingenic-battery.c
> @@ -80,6 +80,10 @@ static int ingenic_battery_set_scale(struct
> ingenic_battery *bat)
>  	if (ret != IIO_AVAIL_LIST || scale_type != IIO_VAL_FRACTIONAL_LOG2)
>  		return -EINVAL;
> 
> +	/* Only one (fractional) entry - nothing to change */
> +	if (scale_len == 2)
> +		return 0;
> +

This function also serves to validate that the maximum voltage is in 
range of available scales.
Please move your code down a bit so that the check for max_mV is still 
being done.

Thanks,
Artur

>  	max_mV = bat->info.voltage_max_design_uv / 1000;
> 
>  	for (i = 0; i < scale_len; i += 2) {
