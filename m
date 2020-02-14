Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE9DA15F556
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729969AbgBNScW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:32:22 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:41104 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729448AbgBNScW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 13:32:22 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01EIW6FW049974;
        Fri, 14 Feb 2020 12:32:06 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1581705126;
        bh=9JYMizinH2hk8xrhecX9Qq9awqbrX0eH4eIWvAG/GAQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=ts3RHCv3EO/ATymwAd98uW5uyntuDog7SsYKx5uEPyNs1b0fnEkKBYfXQ2CZn9TlK
         ClylWeKcMm2NfzE5/p//Vr+kpqnKeCxFT9ti3a1aoGrXBlSCqiMGnl7EZPPpvrAWl3
         oJ1o08keCcpZ4J05tMlILDN/GSPkR8XXORNZL+Mc=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01EIW6jl001763;
        Fri, 14 Feb 2020 12:32:06 -0600
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 14
 Feb 2020 12:32:05 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 14 Feb 2020 12:32:06 -0600
Received: from [128.247.58.153] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01EIW50q000848;
        Fri, 14 Feb 2020 12:32:05 -0600
Subject: Re: [PATCH AUTOSEL 5.4 191/459] ARM: OMAP2+: Add workaround for DRA7
 DSP MStandby errata i879
To:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
CC:     Tony Lindgren <tony@atomide.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
 <20200214160149.11681-191-sashal@kernel.org>
From:   Suman Anna <s-anna@ti.com>
Message-ID: <eccdc72d-759f-d3d8-0801-38e8d8cfd371@ti.com>
Date:   Fri, 14 Feb 2020 12:32:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20200214160149.11681-191-sashal@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On 2/14/20 9:57 AM, Sasha Levin wrote:
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

You can drop this from the 5.4-stable queue. Mainline doesn't yet boot
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

