Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC47E11A8B1
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 11:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbfLKKNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 05:13:44 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:49892 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbfLKKNn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 05:13:43 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id xBBAClIp046366;
        Wed, 11 Dec 2019 04:12:47 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1576059167;
        bh=8BGngI7zTQTQPw9XUjrusxMSY5BvpVVhXIk8XhaPkjg=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=YiKbE+m9ONDUBibMhEJdcGxQyJbj1sRfl1YT6JRXtuvy//mNi2fF5xWv/r4d9qpMp
         +FNI9copTvKFG2tPdEynVITozZ9Xi7XcO4PuWSi+kkJAkOrx7dbrjR4UgwL3qFRcvF
         9hEJ22o6XS44u9rvUxJs6MXpXolbkGIf1WK5AZBM=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xBBACl57080780
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Dec 2019 04:12:47 -0600
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 11
 Dec 2019 04:12:46 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 11 Dec 2019 04:12:46 -0600
Received: from [10.24.69.35] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id xBBAChGZ119576;
        Wed, 11 Dec 2019 04:12:43 -0600
Subject: Re: [PATCH] ARM: davinci: select CONFIG_RESET_CONTROLLER
To:     Arnd Bergmann <arnd@arndb.de>
CC:     <stable@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        David Lechner <david@lechnology.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
References: <20191210195202.622734-1-arnd@arndb.de>
From:   Sekhar Nori <nsekhar@ti.com>
Message-ID: <ba94531d-1f16-b985-5638-c226bab28d5b@ti.com>
Date:   Wed, 11 Dec 2019 15:42:42 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191210195202.622734-1-arnd@arndb.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Arnd,

On 11/12/19 1:21 AM, Arnd Bergmann wrote:
> Selecting RESET_CONTROLLER is actually required, otherwise we
> can get a link failure in the clock driver:
> 
> drivers/clk/davinci/psc.o: In function `__davinci_psc_register_clocks':
> psc.c:(.text+0x9a0): undefined reference to `devm_reset_controller_register'
> drivers/clk/davinci/psc-da850.o: In function `da850_psc0_init':
> psc-da850.c:(.text+0x24): undefined reference to `reset_controller_add_lookup'
> 
> Fixes: f962396ce292 ("ARM: davinci: support multiplatform build for ARM v5")
> Cc: <stable@vger.kernel.org> # v5.4
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Assuming you are going to apply directly to ARM-SoC,

Acked-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar

> ---
>  arch/arm/mach-davinci/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
> index dd427bd2768c..02b180ad7245 100644
> --- a/arch/arm/mach-davinci/Kconfig
> +++ b/arch/arm/mach-davinci/Kconfig
> @@ -9,6 +9,7 @@ menuconfig ARCH_DAVINCI
>  	select PM_GENERIC_DOMAINS if PM
>  	select PM_GENERIC_DOMAINS_OF if PM && OF
>  	select REGMAP_MMIO
> +	select RESET_CONTROLLER
>  	select HAVE_IDE
>  	select PINCTRL_SINGLE
>  
> -- 
> 2.20.0
> 

