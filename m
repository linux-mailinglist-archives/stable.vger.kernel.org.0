Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399674A8953
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 18:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352521AbiBCRJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 12:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236960AbiBCRJe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 12:09:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60E1C061714;
        Thu,  3 Feb 2022 09:09:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26099B8350E;
        Thu,  3 Feb 2022 17:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E18C340E8;
        Thu,  3 Feb 2022 17:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643908171;
        bh=lw506HOrYlGmJA6MjUljcsQtm/9VJ1py1ZAa57fuLK0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YxbDCrkX3gkzHafUpB2M8wBBLlWW9Hfml70NSQFstCd4V0iVKQO8QUW6OD6hewWV2
         fF2Kjx6y/nQGOLpNGqjpmrzNSS8SIva0qXLUsp28JLnxVew7Ikn1S2HKfaYRqG6Cno
         e0co+ToS2LMjS7b7hiR/Mo4r1LSA61cmxFhPzPjQTKiRWG7X5nUvDfb5EgD+82yUGm
         F1wbLg1Pr1kDy2BNHVmn/EEe1Y60yY+o+O67HjXmFV9QMAky5vMm27uA+aFzPQzvZq
         vbplvEoe7m1YjKhQwzMegw5NI3gXijKiKaFihG6Ynsg2ZnHaLn7M4DuvJwjh2UyhjW
         DAt2tauffj5NQ==
Date:   Thu, 3 Feb 2022 10:09:27 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Sekhar Nori <nsekhar@ti.com>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] ARM: davinci: da850-evm: Avoid NULL pointer dereference
Message-ID: <YfwMR5EigHpfIDa7@dev-arch.archlinux-ax161>
References: <20211223222141.1253092-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211223222141.1253092-1-nathan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 23, 2021 at 03:21:41PM -0700, Nathan Chancellor wrote:
> With newer versions of GCC, there is a panic in da850_evm_config_emac()
> when booting multi_v5_defconfig in QEMU under the palmetto-bmc machine:
> 
> Unable to handle kernel NULL pointer dereference at virtual address 00000020
> pgd = (ptrval)
> [00000020] *pgd=00000000
> Internal error: Oops: 5 [#1] PREEMPT ARM
> Modules linked in:
> CPU: 0 PID: 1 Comm: swapper Not tainted 5.15.0 #1
> Hardware name: Generic DT based system
> PC is at da850_evm_config_emac+0x1c/0x120
> LR is at do_one_initcall+0x50/0x1e0
> 
> The emac_pdata pointer in soc_info is NULL because davinci_soc_info only
> gets populated on davinci machines but da850_evm_config_emac() is called
> on all machines via device_initcall().
> 
> Move the rmii_en assignment below the machine check so that it is only
> dereferenced when running on a supported SoC.
> 
> Cc: stable@vger.kernel.org
> Fixes: bae105879f2f ("davinci: DA850/OMAP-L138 EVM: implement autodetect of RMII PHY")
> Link: https://lore.kernel.org/r/YcS4xVWs6bQlQSPC@archlinux-ax161/
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/arm/mach-davinci/board-da850-evm.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> index 428012687a80..7f7f6bae21c2 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
> @@ -1101,11 +1101,13 @@ static int __init da850_evm_config_emac(void)
>  	int ret;
>  	u32 val;
>  	struct davinci_soc_info *soc_info = &davinci_soc_info;
> -	u8 rmii_en = soc_info->emac_pdata->rmii_en;
> +	u8 rmii_en;
>  
>  	if (!machine_is_davinci_da850_evm())
>  		return 0;
>  
> +	rmii_en = soc_info->emac_pdata->rmii_en;
> +
>  	cfg_chip3_base = DA8XX_SYSCFG0_VIRT(DA8XX_CFGCHIP3_REG);
>  
>  	val = __raw_readl(cfg_chip3_base);
> 
> base-commit: a7904a538933c525096ca2ccde1e60d0ee62c08e
> -- 
> 2.34.1
> 
> 

Could someone pick this patch up? This is still broken on mainline and
-next.

Cheers,
Nathan
