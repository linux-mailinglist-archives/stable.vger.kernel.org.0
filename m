Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E948120C3
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 19:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbfEBRC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 13:02:58 -0400
Received: from 7.mo173.mail-out.ovh.net ([46.105.44.159]:46829 "EHLO
        7.mo173.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfEBRC5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 13:02:57 -0400
X-Greylist: delayed 4200 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 May 2019 13:02:56 EDT
Received: from player738.ha.ovh.net (unknown [10.108.57.150])
        by mo173.mail-out.ovh.net (Postfix) with ESMTP id 8BC0DFCEEA
        for <stable@vger.kernel.org>; Thu,  2 May 2019 14:13:08 +0200 (CEST)
Received: from armadeus.com (lfbn-1-7591-179.w90-126.abo.wanadoo.fr [90.126.248.179])
        (Authenticated sender: sebastien.szymanski@armadeus.com)
        by player738.ha.ovh.net (Postfix) with ESMTPSA id 5EE455742B83;
        Thu,  2 May 2019 12:12:59 +0000 (UTC)
Subject: Re: [PATCH] ARM: imx: cpuidle-imx6sx: Restrict the SW2ISO increase to
 i.MX6SX
To:     Fabio Estevam <festevam@gmail.com>, shawnguo@kernel.org
Cc:     cniedermaier@dh-electronics.com, anson.huang@nxp.com,
        stable@vger.kernel.org, linux-imx@nxp.com, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
References: <20190502113020.8642-1-festevam@gmail.com>
From:   =?UTF-8?Q?S=c3=a9bastien_Szymanski?= 
        <sebastien.szymanski@armadeus.com>
Openpgp: preference=signencrypt
Message-ID: <0a76bd74-6d9e-05e1-5928-f62eaf059e0b@armadeus.com>
Date:   Thu, 2 May 2019 14:13:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190502113020.8642-1-festevam@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 16056458574684181756
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrieelgdehudcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/2/19 1:30 PM, Fabio Estevam wrote:
> Since commit 1e434b703248 ("ARM: imx: update the cpu power up timing
> setting on i.mx6sx") some characters loss is noticed on i.MX6ULL UART
> as reported by Christoph Niedermaier.
> 
> The intention of such commit was to increase the SW2ISO field for i.MX6SX
> only, but since cpuidle-imx6sx is also used on i.MX6UL/i.MX6ULL this caused
> unintended side effects on other SoCs.
> 
> Fix this problem by keeping the original SW2ISO value for i.MX6UL/i.MX6ULL
> and only increase SW2ISO in the i.MX6SX case.
> 
> Cc: stable@vger.kernel.org
> Fixes: 1e434b703248 ("ARM: imx: update the cpu power up timing setting on i.mx6sx")
> Reported-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> ---
>  arch/arm/mach-imx/cpuidle-imx6sx.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-imx/cpuidle-imx6sx.c b/arch/arm/mach-imx/cpuidle-imx6sx.c
> index fd0053e47a15..57cb9c763222 100644
> --- a/arch/arm/mach-imx/cpuidle-imx6sx.c
> +++ b/arch/arm/mach-imx/cpuidle-imx6sx.c
> @@ -15,6 +15,7 @@
>  
>  #include "common.h"
>  #include "cpuidle.h"
> +#include "hardware.h"
>  
>  static int imx6sx_idle_finish(unsigned long val)
>  {
> @@ -99,8 +100,12 @@ static struct cpuidle_driver imx6sx_cpuidle_driver = {
>  	.safe_state_index = 0,
>  };
>  
> +#define SW2ISO_ORIGINAL		0x2
> +#define SW2ISO_IMX6SX		0xf
>  int __init imx6sx_cpuidle_init(void)
>  {
> +	u32 sw2iso = SW2ISO_ORIGINAL;
> +
>  	imx6_set_int_mem_clk_lpm(true);
>  	imx6_enable_rbc(false);
>  	imx_gpc_set_l2_mem_power_in_lpm(false);
> @@ -110,7 +115,9 @@ int __init imx6sx_cpuidle_init(void)
>  	 * except for power up sw2iso which need to be
>  	 * larger than LDO ramp up time.
>  	 */
> -	imx_gpc_set_arm_power_up_timing(0xf, 1);
> +	if (cpu_is_imx6sx())
> +		sw2iso = SW2ISO_IMX6SX;
> +	imx_gpc_set_arm_power_up_timing(sw2iso, 1);
>  	imx_gpc_set_arm_power_down_timing(1, 1);
>  
>  	return cpuidle_register(&imx6sx_cpuidle_driver, NULL);
> 

Tested-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>

Regards,

-- 
Sébastien Szymanski
Software engineer, Armadeus Systems
Tel: +33 (0)9 72 29 41 44
Fax: +33 (0)9 72 28 79 26
