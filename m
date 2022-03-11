Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E674D5D5E
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 09:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiCKIeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 03:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiCKIeV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 03:34:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E161D156782;
        Fri, 11 Mar 2022 00:33:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91BECB82AE0;
        Fri, 11 Mar 2022 08:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6094C340E9;
        Fri, 11 Mar 2022 08:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646987595;
        bh=8yi/gBKvn2hysq/NDB+BPOageoED0Lco5/XptInDSdE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=soevJ+BjZXgd9oGRITgk/fGYWLwFTbdWn2zci24Xmsn3m2Y/wB2HtkRRIhZhdw0qr
         RYFa64Kr+Z7aPtNph/VmiJXK3KVCEdVDyZP+GmEVDkszdMUWzuejZ1flQIUbQTP3fx
         QdnCFr3HJNAJDlAHyuLsi9O4y11ctg5pXqbSx2A4=
Date:   Fri, 11 Mar 2022 09:33:12 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     z00314508 <zhengzucheng@huawei.com>
Cc:     rafael@kernel.org, viresh.kumar@linaro.org, tglx@linutronix.de,
        len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] cpufreq: fix cpufreq_get() can't get correct CPU
 frequency
Message-ID: <YisJSKZ5RvswarnW@kroah.com>
References: <20220311081111.159639-1-zhengzucheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220311081111.159639-1-zhengzucheng@huawei.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 11, 2022 at 04:11:11PM +0800, z00314508 wrote:
> From: Zucheng Zheng <zhengzucheng@huawei.com>
> 
> On some specific platforms, the cpufreq driver does not define
> cpufreq_driver.get() routine (eg:x86 intel_pstate driver), as a
> result, the cpufreq_get() can't get the correct CPU frequency.
> 
> Modern x86 processors include the hardware needed to accurately
> calculate frequency over an interval -- APERF, MPERF and the TSC.
> Here we use arch_freq_get_on_cpu() in preference to any driver
> driver-specific cpufreq_driver.get() routine to get CPU frequency.
> 
> Fixes: f8475cef9008 ("x86: use common aperfmperf_khz_on_cpu() to calculate KHz using APERF/MPERF")
> Signed-off-by: Zucheng Zheng <zhengzucheng@huawei.com>
> ---
>  drivers/cpufreq/cpufreq.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 80f535cc8a75..d777257b4454 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1806,10 +1806,14 @@ unsigned int cpufreq_get(unsigned int cpu)
>  {
>  	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
>  	unsigned int ret_freq = 0;
> +	unsigned int freq;
>  
>  	if (policy) {
>  		down_read(&policy->rwsem);
> -		if (cpufreq_driver->get)
> +		freq = arch_freq_get_on_cpu(policy->cpu);
> +		if (freq)
> +			ret_freq = freq;
> +		else if (cpufreq_driver->get)
>  			ret_freq = __cpufreq_get(policy);
>  		up_read(&policy->rwsem);
>  
> -- 
> 2.18.0.huawei.25
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
