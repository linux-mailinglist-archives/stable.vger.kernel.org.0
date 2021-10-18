Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7CB43174D
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 13:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhJRLap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 07:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhJRLao (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 07:30:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8DAC06161C
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 04:28:33 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mcQoX-00007x-Fr; Mon, 18 Oct 2021 13:28:21 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mcQoW-0000Cm-4w; Mon, 18 Oct 2021 13:28:20 +0200
Date:   Mon, 18 Oct 2021 13:28:20 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Michal =?utf-8?B?Vm9rw6HEjQ==?= <michal.vokac@ysoft.com>
Cc:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        linux-pm@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Amit Kucheria <amitk@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Petr =?utf-8?B?QmVuZcWh?= <petr.benes@ysoft.com>,
        petrben@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH] thermal: imx: Fix temperature measurements on i.MX6
 after alarm
Message-ID: <20211018112820.qkebjt2gk2w53lp5@pengutronix.de>
References: <20211008081137.1948848-1-michal.vokac@ysoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211008081137.1948848-1-michal.vokac@ysoft.com>
User-Agent: NeoMutt/20180716
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Michal,

I hope you have seen this patch:
https://lore.kernel.org/all/20210924115032.29684-1-o.rempel@pengutronix.de/

Are there any reason why this was ignored?

On Fri, Oct 08, 2021 at 10:11:37AM +0200, Michal Vokáč wrote:
> From: Petr Beneš <petr.benes@ysoft.com>
> 
> SoC temperature readout may not work after thermal alarm fires interrupt.
> This harms userspace as well as CPU cooling device.
> 
> Two issues with the logic involved. First, there is no protection against
> concurent measurements, hence one can switch the sensor off while
> the other one tries to read temperature later. Second, the interrupt path
> usually fails. At the end the sensor is powered off and thermal IRQ is
> disabled. One has to reenable the thermal zone by the sysfs interface.
> 
> Most of troubles come from commit d92ed2c9d3ff ("thermal: imx: Use
> driver's local data to decide whether to run a measurement")
> 
> It uses data->irq_enabled as the "local data". Indeed, its value is
> related to the state of the sensor loosely under normal operation and,
> frankly, gets unleashed when the thermal interrupt arrives.
> 
> Current patch adds the "local data" (new member sensor_on in
> imx_thermal_data) and sets its value in controlled manner.
> 
> Fixes: d92ed2c9d3ff ("thermal: imx: Use driver's local data to decide whether to run a measurement")
> Cc: petrben@gmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Petr Beneš <petr.benes@ysoft.com>
> Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>
> ---
>  drivers/thermal/imx_thermal.c | 30 ++++++++++++++++++++++++++----
>  1 file changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
> index 2c7473d86a59..df5658e21828 100644
> --- a/drivers/thermal/imx_thermal.c
> +++ b/drivers/thermal/imx_thermal.c
> @@ -209,6 +209,8 @@ struct imx_thermal_data {
>  	struct clk *thermal_clk;
>  	const struct thermal_soc_data *socdata;
>  	const char *temp_grade;
> +	struct mutex sensor_lock;
> +	bool sensor_on;
>  };
>  
>  static void imx_set_panic_temp(struct imx_thermal_data *data,
> @@ -252,11 +254,12 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
>  	const struct thermal_soc_data *soc_data = data->socdata;
>  	struct regmap *map = data->tempmon;
>  	unsigned int n_meas;
> -	bool wait, run_measurement;
> +	bool wait;
>  	u32 val;
>  
> -	run_measurement = !data->irq_enabled;
> -	if (!run_measurement) {
> +	mutex_lock(&data->sensor_lock);
> +
> +	if (data->sensor_on) {
>  		/* Check if a measurement is currently in progress */
>  		regmap_read(map, soc_data->temp_data, &val);
>  		wait = !(val & soc_data->temp_valid_mask);
> @@ -283,13 +286,15 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
>  
>  	regmap_read(map, soc_data->temp_data, &val);
>  
> -	if (run_measurement) {
> +	if (!data->sensor_on) {
>  		regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
>  			     soc_data->measure_temp_mask);
>  		regmap_write(map, soc_data->sensor_ctrl + REG_SET,
>  			     soc_data->power_down_mask);
>  	}
>  
> +	mutex_unlock(&data->sensor_lock);
> +
>  	if ((val & soc_data->temp_valid_mask) == 0) {
>  		dev_dbg(&tz->device, "temp measurement never finished\n");
>  		return -EAGAIN;
> @@ -339,20 +344,26 @@ static int imx_change_mode(struct thermal_zone_device *tz,
>  	const struct thermal_soc_data *soc_data = data->socdata;
>  
>  	if (mode == THERMAL_DEVICE_ENABLED) {
> +		mutex_lock(&data->sensor_lock);
>  		regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
>  			     soc_data->power_down_mask);
>  		regmap_write(map, soc_data->sensor_ctrl + REG_SET,
>  			     soc_data->measure_temp_mask);
> +		data->sensor_on = true;
> +		mutex_unlock(&data->sensor_lock);
>  
>  		if (!data->irq_enabled) {
>  			data->irq_enabled = true;
>  			enable_irq(data->irq);
>  		}
>  	} else {
> +		mutex_lock(&data->sensor_lock);
>  		regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
>  			     soc_data->measure_temp_mask);
>  		regmap_write(map, soc_data->sensor_ctrl + REG_SET,
>  			     soc_data->power_down_mask);
> +		data->sensor_on = false;
> +		mutex_unlock(&data->sensor_lock);
>  
>  		if (data->irq_enabled) {
>  			disable_irq(data->irq);
> @@ -728,6 +739,8 @@ static int imx_thermal_probe(struct platform_device *pdev)
>  	}
>  
>  	/* Make sure sensor is in known good state for measurements */
> +	mutex_init(&data->sensor_lock);
> +	mutex_lock(&data->sensor_lock);
>  	regmap_write(map, data->socdata->sensor_ctrl + REG_CLR,
>  		     data->socdata->power_down_mask);
>  	regmap_write(map, data->socdata->sensor_ctrl + REG_CLR,
> @@ -739,6 +752,8 @@ static int imx_thermal_probe(struct platform_device *pdev)
>  			IMX6_MISC0_REFTOP_SELBIASOFF);
>  	regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
>  		     data->socdata->power_down_mask);
> +	data->sensor_on = false;
> +	mutex_unlock(&data->sensor_lock);
>  
>  	ret = imx_thermal_register_legacy_cooling(data);
>  	if (ret)
> @@ -796,10 +811,13 @@ static int imx_thermal_probe(struct platform_device *pdev)
>  	if (data->socdata->version == TEMPMON_IMX6SX)
>  		imx_set_panic_temp(data, data->temp_critical);
>  
> +	mutex_lock(&data->sensor_lock);
>  	regmap_write(map, data->socdata->sensor_ctrl + REG_CLR,
>  		     data->socdata->power_down_mask);
>  	regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
>  		     data->socdata->measure_temp_mask);
> +	data->sensor_on = true;
> +	mutex_unlock(&data->sensor_lock);
>  
>  	data->irq_enabled = true;
>  	ret = thermal_zone_device_enable(data->tz);
> @@ -832,8 +850,12 @@ static int imx_thermal_remove(struct platform_device *pdev)
>  	struct regmap *map = data->tempmon;
>  
>  	/* Disable measurements */
> +	mutex_lock(&data->sensor_lock);
>  	regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
>  		     data->socdata->power_down_mask);
> +	data->sensor_on = false;
> +	mutex_unlock(&data->sensor_lock);
> +
>  	if (!IS_ERR(data->thermal_clk))
>  		clk_disable_unprepare(data->thermal_clk);
>  
> -- 
> 2.25.1
> 
