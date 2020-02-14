Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6CA15F562
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729575AbgBNSe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:34:26 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:54580 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728239AbgBNSeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 13:34:25 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01EIYK6o044803;
        Fri, 14 Feb 2020 12:34:20 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1581705260;
        bh=Ic5BPF5pM7v5o6kmGXHhNPp+FzOKQxQ+zryeKiVXHes=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=rwOT9uqRbzH5Nwg3u7adTAnUaaFMABx9AVg2Q9J+Ke1oXyJF+uR/bA1j352exJKUW
         8XqwNxnuzGg0bidv3D0NypT5mPFZNma18k1xOokuqDJYeB4Aqr9abkUtsCo0Xx9PgV
         mMQ7LmPmcc62lg+Xlp9L8fq5DEUABl0HyB3BSRy8=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01EIYKqO068154
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 14 Feb 2020 12:34:20 -0600
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 14
 Feb 2020 12:34:19 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 14 Feb 2020 12:34:19 -0600
Received: from [128.247.58.153] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01EIYJlD004493;
        Fri, 14 Feb 2020 12:34:19 -0600
Subject: Re: [PATCH AUTOSEL 5.5 218/542] ARM: OMAP2+: Add workaround for DRA7
 DSP MStandby errata i879
To:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
CC:     Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-218-sashal@kernel.org>
From:   Suman Anna <s-anna@ti.com>
Message-ID: <1ea1b9d3-ce1e-83ca-e2a4-dfb67b12754d@ti.com>
Date:   Fri, 14 Feb 2020 12:34:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20200214154854.6746-218-sashal@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On 2/14/20 9:43 AM, Sasha Levin wrote:
> From: Suman Anna <s-anna@ti.com>
> 
> [ Upstream commit 2f14101a1d760db72393910d481fbf7768c44530 ]
> 
> Errata Title:
> i879: DSP MStandby requires CD_EMU in SW_WKUP
> 
> Description:
> The DSP requires the internal emulation clock to be actively toggling
> in order to successfully enter a low power mode via execution of the
> IDLE instruction and PRCM MStandby/Idle handshake. This assumes that
> other prerequisites and software sequence are followed.
> 
> Workaround:
> The emulation clock to the DSP is free-running anytime CCS is connected
> via JTAG debugger to the DSP subsystem or when the CD_EMU clock domain
> is set in SW_WKUP mode. The CD_EMU domain can be set in SW_WKUP mode
> via the CM_EMU_CLKSTCTRL [1:0]CLKTRCTRL field.
> 
> Implementation:
> This patch implements this workaround by denying the HW_AUTO mode
> for the EMU clockdomain during the power-up of any DSP processor
> and re-enabling the HW_AUTO mode during the shutdown of the last
> DSP processor (actually done during the enabling and disabling of
> the respective DSP MDMA MMUs). Reference counting has to be used to
> manage the independent sequencing between the multiple DSP processors.
> 
> This switching is done at runtime rather than a static clockdomain
> flags value to meet the target power domain state for the EMU power
> domain during suspend.
> 
> Note that the DSP MStandby behavior is not consistent across all
> boards prior to this fix. Please see commit 45f871eec6c0 ("ARM:
> OMAP2+: Extend DRA7 IPU1 MMU pdata quirks to DSP MDMA MMUs") for
> details.
> 
> Signed-off-by: Suman Anna <s-anna@ti.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

You can drop this from the 5.5-stable queue. Mainline doesn't yet boot
the processors, so this is not needed for stable queue.

regards
Suman

> ---
>  arch/arm/mach-omap2/omap-iommu.c | 43 +++++++++++++++++++++++++++++---
>  1 file changed, 40 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/omap-iommu.c b/arch/arm/mach-omap2/omap-iommu.c
> index f1a6ece8108e4..78247e6f4a720 100644
> --- a/arch/arm/mach-omap2/omap-iommu.c
> +++ b/arch/arm/mach-omap2/omap-iommu.c
> @@ -11,14 +11,43 @@
>  
>  #include "omap_hwmod.h"
>  #include "omap_device.h"
> +#include "clockdomain.h"
>  #include "powerdomain.h"
>  
> +static void omap_iommu_dra7_emu_swsup_config(struct platform_device *pdev,
> +					     bool enable)
> +{
> +	static struct clockdomain *emu_clkdm;
> +	static DEFINE_SPINLOCK(emu_lock);
> +	static atomic_t count;
> +	struct device_node *np = pdev->dev.of_node;
> +
> +	if (!of_device_is_compatible(np, "ti,dra7-dsp-iommu"))
> +		return;
> +
> +	if (!emu_clkdm) {
> +		emu_clkdm = clkdm_lookup("emu_clkdm");
> +		if (WARN_ON_ONCE(!emu_clkdm))
> +			return;
> +	}
> +
> +	spin_lock(&emu_lock);
> +
> +	if (enable && (atomic_inc_return(&count) == 1))
> +		clkdm_deny_idle(emu_clkdm);
> +	else if (!enable && (atomic_dec_return(&count) == 0))
> +		clkdm_allow_idle(emu_clkdm);
> +
> +	spin_unlock(&emu_lock);
> +}
> +
>  int omap_iommu_set_pwrdm_constraint(struct platform_device *pdev, bool request,
>  				    u8 *pwrst)
>  {
>  	struct powerdomain *pwrdm;
>  	struct omap_device *od;
>  	u8 next_pwrst;
> +	int ret = 0;
>  
>  	od = to_omap_device(pdev);
>  	if (!od)
> @@ -31,13 +60,21 @@ int omap_iommu_set_pwrdm_constraint(struct platform_device *pdev, bool request,
>  	if (!pwrdm)
>  		return -EINVAL;
>  
> -	if (request)
> +	if (request) {
>  		*pwrst = pwrdm_read_next_pwrst(pwrdm);
> +		omap_iommu_dra7_emu_swsup_config(pdev, true);
> +	}
>  
>  	if (*pwrst > PWRDM_POWER_RET)
> -		return 0;
> +		goto out;
>  
>  	next_pwrst = request ? PWRDM_POWER_ON : *pwrst;
>  
> -	return pwrdm_set_next_pwrst(pwrdm, next_pwrst);
> +	ret = pwrdm_set_next_pwrst(pwrdm, next_pwrst);
> +
> +out:
> +	if (!request)
> +		omap_iommu_dra7_emu_swsup_config(pdev, false);
> +
> +	return ret;
>  }
> 

