Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90A9640719
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 13:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbiLBMsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 07:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233586AbiLBMsL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 07:48:11 -0500
Received: from mail1.systemli.org (mail1.systemli.org [93.190.126.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF8527DF6
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 04:48:09 -0800 (PST)
Message-ID: <b525cb57-7f21-fb23-1b15-9560f4685cdd@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1669985274;
        bh=6o9KP6kk5p2qtH3EKpvc3oXBWluqaPokZJCRc6pucdk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Sav1K2dr+Fe+ZJblCqzRzKIAxb7Z9mQbTT+C9VM8f4VilNbSjT7cpqWNHz6TZpI72
         c91l7HUr4aFLJyV3Rz1BSq+HppZ1xelUfeOBtz8Zx+Pt8NTiRJYHHb8Wo0yGixTF1H
         jm2XnE+PxTD3fj8VajoWqZNCWFxmNGXbIh0DywvVfsZBim3y2jgjUdnzxEXSPkr02m
         NicVaWEvgZHjqimlrOT1OTwpSbFn3Bat449Ot79AK9Z8ycHBKkQ6siE9wxVSWb+BIj
         9Br/TadK9URtjB6gPfoqAQbOnZpixt8YZTeLt/Yn/5NUmrXg7hgAJunrKyRLsuQO1I
         vUfrTH7ndOung==
Date:   Fri, 2 Dec 2022 13:47:51 +0100
MIME-Version: 1.0
Subject: Re: [PATCH] Revert "cpufreq: mediatek: Refine
 mtk_cpufreq_voltage_tracking()"
Content-Language: en-US
To:     Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     linux-pm@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        regressions@leemhuis.info, daniel@makrotopia.org,
        thomas.huehn@hs-nordhausen.de, "v5 . 19+" <stable@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <930778a1-5e8b-6df6-3276-42dcdadaf682@systemli.org>
 <18947e09733a17935af9a123ccf9b6e92faeaf9b.1669958641.git.viresh.kumar@linaro.org>
From:   Nick <vincent@systemli.org>
In-Reply-To: <18947e09733a17935af9a123ccf9b6e92faeaf9b.1669958641.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I tested this again on linux/master on the Banana Pi R64 (mt7622). Seems 
to work fine:
https://gist.githubusercontent.com/PolynomialDivision/5022dec1874a1c411ece6c9dabec59b5/raw/7ac62b38d10e41a56ff1db3142571117ee6f4c26/mt7622-cpufreq-revert.log

So if you want you can add:
Reported-by: Nick Hainke <vincent@systemli.org>
Tested-by: Nick Hainke <vincent@systemli.org>

Bests
Nick

On 12/2/22 06:26, Viresh Kumar wrote:
> This reverts commit 6a17b3876bc8303612d7ad59ecf7cbc0db418bcd.
>
> This commit caused regression on Banana Pi R64 (MT7622), revert until
> the problem is identified and fixed properly.
>
> Link: https://lore.kernel.org/all/930778a1-5e8b-6df6-3276-42dcdadaf682@systemli.org/
> Cc: v5.19+ <stable@vger.kernel.org> # v5.19+
> Reported-by: Nick <vincent@systemli.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>   drivers/cpufreq/mediatek-cpufreq.c | 147 +++++++++++++++++++----------
>   1 file changed, 96 insertions(+), 51 deletions(-)
>
> diff --git a/drivers/cpufreq/mediatek-cpufreq.c b/drivers/cpufreq/mediatek-cpufreq.c
> index 7f2680bc9a0f..4466d0c91a6a 100644
> --- a/drivers/cpufreq/mediatek-cpufreq.c
> +++ b/drivers/cpufreq/mediatek-cpufreq.c
> @@ -8,7 +8,6 @@
>   #include <linux/cpu.h>
>   #include <linux/cpufreq.h>
>   #include <linux/cpumask.h>
> -#include <linux/minmax.h>
>   #include <linux/module.h>
>   #include <linux/of.h>
>   #include <linux/of_platform.h>
> @@ -16,6 +15,8 @@
>   #include <linux/pm_opp.h>
>   #include <linux/regulator/consumer.h>
>   
> +#define VOLT_TOL		(10000)
> +
>   struct mtk_cpufreq_platform_data {
>   	int min_volt_shift;
>   	int max_volt_shift;
> @@ -55,7 +56,6 @@ struct mtk_cpu_dvfs_info {
>   	unsigned int opp_cpu;
>   	unsigned long current_freq;
>   	const struct mtk_cpufreq_platform_data *soc_data;
> -	int vtrack_max;
>   	bool ccifreq_bound;
>   };
>   
> @@ -82,7 +82,6 @@ static int mtk_cpufreq_voltage_tracking(struct mtk_cpu_dvfs_info *info,
>   	struct regulator *proc_reg = info->proc_reg;
>   	struct regulator *sram_reg = info->sram_reg;
>   	int pre_vproc, pre_vsram, new_vsram, vsram, vproc, ret;
> -	int retry = info->vtrack_max;
>   
>   	pre_vproc = regulator_get_voltage(proc_reg);
>   	if (pre_vproc < 0) {
> @@ -90,44 +89,91 @@ static int mtk_cpufreq_voltage_tracking(struct mtk_cpu_dvfs_info *info,
>   			"invalid Vproc value: %d\n", pre_vproc);
>   		return pre_vproc;
>   	}
> +	/* Vsram should not exceed the maximum allowed voltage of SoC. */
> +	new_vsram = min(new_vproc + soc_data->min_volt_shift,
> +			soc_data->sram_max_volt);
> +
> +	if (pre_vproc < new_vproc) {
> +		/*
> +		 * When scaling up voltages, Vsram and Vproc scale up step
> +		 * by step. At each step, set Vsram to (Vproc + 200mV) first,
> +		 * then set Vproc to (Vsram - 100mV).
> +		 * Keep doing it until Vsram and Vproc hit target voltages.
> +		 */
> +		do {
> +			pre_vsram = regulator_get_voltage(sram_reg);
> +			if (pre_vsram < 0) {
> +				dev_err(info->cpu_dev,
> +					"invalid Vsram value: %d\n", pre_vsram);
> +				return pre_vsram;
> +			}
> +			pre_vproc = regulator_get_voltage(proc_reg);
> +			if (pre_vproc < 0) {
> +				dev_err(info->cpu_dev,
> +					"invalid Vproc value: %d\n", pre_vproc);
> +				return pre_vproc;
> +			}
>   
> -	pre_vsram = regulator_get_voltage(sram_reg);
> -	if (pre_vsram < 0) {
> -		dev_err(info->cpu_dev, "invalid Vsram value: %d\n", pre_vsram);
> -		return pre_vsram;
> -	}
> +			vsram = min(new_vsram,
> +				    pre_vproc + soc_data->min_volt_shift);
>   
> -	new_vsram = clamp(new_vproc + soc_data->min_volt_shift,
> -			  soc_data->sram_min_volt, soc_data->sram_max_volt);
> +			if (vsram + VOLT_TOL >= soc_data->sram_max_volt) {
> +				vsram = soc_data->sram_max_volt;
>   
> -	do {
> -		if (pre_vproc <= new_vproc) {
> -			vsram = clamp(pre_vproc + soc_data->max_volt_shift,
> -				      soc_data->sram_min_volt, new_vsram);
> -			ret = regulator_set_voltage(sram_reg, vsram,
> -						    soc_data->sram_max_volt);
> +				/*
> +				 * If the target Vsram hits the maximum voltage,
> +				 * try to set the exact voltage value first.
> +				 */
> +				ret = regulator_set_voltage(sram_reg, vsram,
> +							    vsram);
> +				if (ret)
> +					ret = regulator_set_voltage(sram_reg,
> +							vsram - VOLT_TOL,
> +							vsram);
>   
> -			if (ret)
> -				return ret;
> -
> -			if (vsram == soc_data->sram_max_volt ||
> -			    new_vsram == soc_data->sram_min_volt)
>   				vproc = new_vproc;
> -			else
> +			} else {
> +				ret = regulator_set_voltage(sram_reg, vsram,
> +							    vsram + VOLT_TOL);
> +
>   				vproc = vsram - soc_data->min_volt_shift;
> +			}
> +			if (ret)
> +				return ret;
>   
>   			ret = regulator_set_voltage(proc_reg, vproc,
> -						    soc_data->proc_max_volt);
> +						    vproc + VOLT_TOL);
>   			if (ret) {
>   				regulator_set_voltage(sram_reg, pre_vsram,
> -						      soc_data->sram_max_volt);
> +						      pre_vsram);
>   				return ret;
>   			}
> -		} else if (pre_vproc > new_vproc) {
> +		} while (vproc < new_vproc || vsram < new_vsram);
> +	} else if (pre_vproc > new_vproc) {
> +		/*
> +		 * When scaling down voltages, Vsram and Vproc scale down step
> +		 * by step. At each step, set Vproc to (Vsram - 200mV) first,
> +		 * then set Vproc to (Vproc + 100mV).
> +		 * Keep doing it until Vsram and Vproc hit target voltages.
> +		 */
> +		do {
> +			pre_vproc = regulator_get_voltage(proc_reg);
> +			if (pre_vproc < 0) {
> +				dev_err(info->cpu_dev,
> +					"invalid Vproc value: %d\n", pre_vproc);
> +				return pre_vproc;
> +			}
> +			pre_vsram = regulator_get_voltage(sram_reg);
> +			if (pre_vsram < 0) {
> +				dev_err(info->cpu_dev,
> +					"invalid Vsram value: %d\n", pre_vsram);
> +				return pre_vsram;
> +			}
> +
>   			vproc = max(new_vproc,
>   				    pre_vsram - soc_data->max_volt_shift);
>   			ret = regulator_set_voltage(proc_reg, vproc,
> -						    soc_data->proc_max_volt);
> +						    vproc + VOLT_TOL);
>   			if (ret)
>   				return ret;
>   
> @@ -137,24 +183,32 @@ static int mtk_cpufreq_voltage_tracking(struct mtk_cpu_dvfs_info *info,
>   				vsram = max(new_vsram,
>   					    vproc + soc_data->min_volt_shift);
>   
> -			ret = regulator_set_voltage(sram_reg, vsram,
> -						    soc_data->sram_max_volt);
> +			if (vsram + VOLT_TOL >= soc_data->sram_max_volt) {
> +				vsram = soc_data->sram_max_volt;
> +
> +				/*
> +				 * If the target Vsram hits the maximum voltage,
> +				 * try to set the exact voltage value first.
> +				 */
> +				ret = regulator_set_voltage(sram_reg, vsram,
> +							    vsram);
> +				if (ret)
> +					ret = regulator_set_voltage(sram_reg,
> +							vsram - VOLT_TOL,
> +							vsram);
> +			} else {
> +				ret = regulator_set_voltage(sram_reg, vsram,
> +							    vsram + VOLT_TOL);
> +			}
> +
>   			if (ret) {
>   				regulator_set_voltage(proc_reg, pre_vproc,
> -						      soc_data->proc_max_volt);
> +						      pre_vproc);
>   				return ret;
>   			}
> -		}
> -
> -		pre_vproc = vproc;
> -		pre_vsram = vsram;
> -
> -		if (--retry < 0) {
> -			dev_err(info->cpu_dev,
> -				"over loop count, failed to set voltage\n");
> -			return -EINVAL;
> -		}
> -	} while (vproc != new_vproc || vsram != new_vsram);
> +		} while (vproc > new_vproc + VOLT_TOL ||
> +			 vsram > new_vsram + VOLT_TOL);
> +	}
>   
>   	return 0;
>   }
> @@ -250,8 +304,8 @@ static int mtk_cpufreq_set_target(struct cpufreq_policy *policy,
>   	 * If the new voltage or the intermediate voltage is higher than the
>   	 * current voltage, scale up voltage first.
>   	 */
> -	target_vproc = max(inter_vproc, vproc);
> -	if (pre_vproc <= target_vproc) {
> +	target_vproc = (inter_vproc > vproc) ? inter_vproc : vproc;
> +	if (pre_vproc < target_vproc) {
>   		ret = mtk_cpufreq_set_voltage(info, target_vproc);
>   		if (ret) {
>   			dev_err(cpu_dev,
> @@ -513,15 +567,6 @@ static int mtk_cpu_dvfs_info_init(struct mtk_cpu_dvfs_info *info, int cpu)
>   	 */
>   	info->need_voltage_tracking = (info->sram_reg != NULL);
>   
> -	/*
> -	 * We assume min voltage is 0 and tracking target voltage using
> -	 * min_volt_shift for each iteration.
> -	 * The vtrack_max is 3 times of expeted iteration count.
> -	 */
> -	info->vtrack_max = 3 * DIV_ROUND_UP(max(info->soc_data->sram_max_volt,
> -						info->soc_data->proc_max_volt),
> -					    info->soc_data->min_volt_shift);
> -
>   	return 0;
>   
>   out_disable_inter_clock:
