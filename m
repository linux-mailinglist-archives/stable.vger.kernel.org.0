Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF60129F1
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 10:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfECIdV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 3 May 2019 04:33:21 -0400
Received: from securetransport.cubewerk.de ([188.68.39.254]:40496 "EHLO
        securetransport.cubewerk.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725789AbfECIdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 04:33:21 -0400
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 May 2019 04:33:20 EDT
Received: from DHPLMX01.DH-ELECTRONICS.ORG (unknown [188.193.158.174])
        (using TLSv1.2 with cipher DHE-RSA-CAMELLIA128-SHA256 (128/128 bits))
        (No client certificate requested)
        by securetransport.cubewerk.de (Postfix) with ESMTPSA id E4BEF5E987;
        Fri,  3 May 2019 10:23:47 +0200 (CEST)
Received: from DHPLMX01 (localhost [127.0.0.1])
        by DHPLMX01.DH-ELECTRONICS.ORG (Postfix) with ESMTP id 9A2A32140024;
        Fri,  3 May 2019 10:23:47 +0200 (CEST)
Received: by DHPLMX01 (kopano-spooler) with MAPI; Fri, 3 May 2019 10:23:47
 +0200
Subject: RE: [PATCH] ARM: imx: cpuidle-imx6sx: Restrict the SW2ISO increase
 to i.MX6SX [Klartext]
From:   =?utf-8?Q?Christoph_Niedermaier?= <cniedermaier@dh-electronics.com>
To:     =?utf-8?Q?Fabio_Estevam?= <festevam@gmail.com>,
        =?utf-8?Q?shawnguo=40k?= =?utf-8?Q?ernel=2Eorg?= 
        <shawnguo@kernel.org>
Cc:     =?utf-8?Q?kernel=40pengutronix=2Ede?= <kernel@pengutronix.de>,
        =?utf-8?Q?linux-imx=40nxp=2Ecom?= <linux-imx@nxp.com>,
        =?utf-8?Q?linux-arm-kernel=40lists=2Einfradead=2Eorg?= 
        <linux-arm-kernel@lists.infradead.org>,
        =?utf-8?Q?anson=2Ehuang=40nxp=2E?= =?utf-8?Q?com?= 
        <anson.huang@nxp.com>,
        =?utf-8?Q?stable=40vger=2Ekernel=2E?= =?utf-8?Q?org?= 
        <stable@vger.kernel.org>
Date:   Fri, 3 May 2019 08:23:47 +0000
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190502113020.8642-1-festevam@gmail.com>
References: <20190502113020.8642-1-festevam@gmail.com>
X-Priority: 3 (Normal)
X-Mailer: Kopano 8.6.8
Message-Id: <kcis.9E822BA1761B40BAB23F42EDD9B5F6A8@DHPLMX01>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>
Sent: Thursday 2nd May 2019 13:30
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
> Fixes: 1e434b703248 ("ARM: imx: update the cpu power up timing setting on
> i.mx6sx")
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
>  .safe_state_index = 0,
>  };
>  
> +#define SW2ISO_ORIGINAL 0x2
> +#define SW2ISO_IMX6SX 0xf
>  int __init imx6sx_cpuidle_init(void)
>  {
> + u32 sw2iso = SW2ISO_ORIGINAL;
> +
>  imx6_set_int_mem_clk_lpm(true);
>  imx6_enable_rbc(false);
>  imx_gpc_set_l2_mem_power_in_lpm(false);
> @@ -110,7 +115,9 @@ int __init imx6sx_cpuidle_init(void)
>  * except for power up sw2iso which need to be
>  * larger than LDO ramp up time.
>  */
> - imx_gpc_set_arm_power_up_timing(0xf, 1);
> + if (cpu_is_imx6sx())
> + sw2iso = SW2ISO_IMX6SX;
> + imx_gpc_set_arm_power_up_timing(sw2iso, 1);
>  imx_gpc_set_arm_power_down_timing(1, 1);
>  
>  return cpuidle_register(&imx6sx_cpuidle_driver, NULL);
>

Tested-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>

Best regards,
