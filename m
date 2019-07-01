Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCCC5BB7D
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 14:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbfGAM2z convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 1 Jul 2019 08:28:55 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:45207 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728081AbfGAM2z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 08:28:55 -0400
X-Originating-IP: 86.250.200.211
Received: from xps13 (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id C27BC24001A;
        Mon,  1 Jul 2019 12:28:48 +0000 (UTC)
Date:   Mon, 1 Jul 2019 14:28:47 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Richard Weinberger <richard@nod.at>, od@zcrc.me,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Hulk Robot <hulkci@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mtd: rawnand: ingenic: Fix ingenic_ecc dependency
Message-ID: <20190701142847.1c1ac4b1@xps13>
In-Reply-To: <20190629012248.12447-1-paul@crapouillou.net>
References: <20190629012248.12447-1-paul@crapouillou.net>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paul,

One question below.

Paul Cercueil <paul@crapouillou.net> wrote on Sat, 29 Jun 2019 03:22:48
+0200:

> If MTD_NAND_JZ4780 is y and MTD_NAND_JZ4780_BCH is m,
> which select CONFIG_MTD_NAND_INGENIC_ECC to m, building fails:
> 
> drivers/mtd/nand/raw/ingenic/ingenic_nand.o: In function `ingenic_nand_remove':
> ingenic_nand.c:(.text+0x177): undefined reference to `ingenic_ecc_release'
> drivers/mtd/nand/raw/ingenic/ingenic_nand.o: In function `ingenic_nand_ecc_correct':
> ingenic_nand.c:(.text+0x2ee): undefined reference to `ingenic_ecc_correct'
> 
> To fix that, the ingenic_nand and ingenic_ecc modules have been fused
> into one single module.
> - The ingenic_ecc.c code is now compiled in only if
>   $(CONFIG_MTD_NAND_INGENIC_ECC) is set. This is now a boolean instead
>   of tristate.
> - To avoid changing the module name, the ingenic_nand.c file is moved to
>   ingenic_nand_drv.c. Then the module name is still ingenic_nand.
> - Since ingenic_ecc.c is no more a module, the module-specific macros
>   have been dropped, and the functions are no more exported for use by
>   the ingenic_nand driver.

I am fine with this approach.

> 
> Fixes: 15de8c6efd0e ("mtd: rawnand: ingenic: Separate top-level and SoC specific code")
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Cc: YueHaibing <yuehaibing@huawei.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/mtd/nand/raw/ingenic/Kconfig                     | 2 +-
>  drivers/mtd/nand/raw/ingenic/Makefile                    | 4 +++-
>  drivers/mtd/nand/raw/ingenic/ingenic_ecc.c               | 9 ---------
>  .../raw/ingenic/{ingenic_nand.c => ingenic_nand_drv.c}   | 0
>  4 files changed, 4 insertions(+), 11 deletions(-)
>  rename drivers/mtd/nand/raw/ingenic/{ingenic_nand.c => ingenic_nand_drv.c} (100%)
> 
> diff --git a/drivers/mtd/nand/raw/ingenic/Kconfig b/drivers/mtd/nand/raw/ingenic/Kconfig
> index 19a96ce515c1..66b7cffdb0c2 100644
> --- a/drivers/mtd/nand/raw/ingenic/Kconfig
> +++ b/drivers/mtd/nand/raw/ingenic/Kconfig
> @@ -16,7 +16,7 @@ config MTD_NAND_JZ4780
>  if MTD_NAND_JZ4780
>  
>  config MTD_NAND_INGENIC_ECC
> -	tristate
> +	bool
>  
>  config MTD_NAND_JZ4740_ECC
>  	tristate "Hardware BCH support for JZ4740 SoC"
> diff --git a/drivers/mtd/nand/raw/ingenic/Makefile b/drivers/mtd/nand/raw/ingenic/Makefile
> index 1ac4f455baea..b63d36889263 100644
> --- a/drivers/mtd/nand/raw/ingenic/Makefile
> +++ b/drivers/mtd/nand/raw/ingenic/Makefile
> @@ -2,7 +2,9 @@
>  obj-$(CONFIG_MTD_NAND_JZ4740) += jz4740_nand.o
>  obj-$(CONFIG_MTD_NAND_JZ4780) += ingenic_nand.o
>  
> -obj-$(CONFIG_MTD_NAND_INGENIC_ECC) += ingenic_ecc.o
> +ingenic_nand-y += ingenic_nand_drv.o
> +ingenic_nand-$(CONFIG_MTD_NAND_INGENIC_ECC) += ingenic_ecc.o
> +
>  obj-$(CONFIG_MTD_NAND_JZ4740_ECC) += jz4740_ecc.o
>  obj-$(CONFIG_MTD_NAND_JZ4725B_BCH) += jz4725b_bch.o
>  obj-$(CONFIG_MTD_NAND_JZ4780_BCH) += jz4780_bch.o
> diff --git a/drivers/mtd/nand/raw/ingenic/ingenic_ecc.c b/drivers/mtd/nand/raw/ingenic/ingenic_ecc.c
> index d3e085c5685a..c954189606f6 100644
> --- a/drivers/mtd/nand/raw/ingenic/ingenic_ecc.c
> +++ b/drivers/mtd/nand/raw/ingenic/ingenic_ecc.c
> @@ -30,7 +30,6 @@ int ingenic_ecc_calculate(struct ingenic_ecc *ecc,
>  {
>  	return ecc->ops->calculate(ecc, params, buf, ecc_code);
>  }
> -EXPORT_SYMBOL(ingenic_ecc_calculate);
>  
>  /**
>   * ingenic_ecc_correct() - detect and correct bit errors
> @@ -51,7 +50,6 @@ int ingenic_ecc_correct(struct ingenic_ecc *ecc,
>  {
>  	return ecc->ops->correct(ecc, params, buf, ecc_code);
>  }
> -EXPORT_SYMBOL(ingenic_ecc_correct);
>  
>  /**
>   * ingenic_ecc_get() - get the ECC controller device
> @@ -111,7 +109,6 @@ struct ingenic_ecc *of_ingenic_ecc_get(struct device_node *of_node)
>  	}
>  	return ecc;
>  }
> -EXPORT_SYMBOL(of_ingenic_ecc_get);
>  
>  /**
>   * ingenic_ecc_release() - release the ECC controller device
> @@ -122,7 +119,6 @@ void ingenic_ecc_release(struct ingenic_ecc *ecc)
>  	clk_disable_unprepare(ecc->clk);
>  	put_device(ecc->dev);
>  }
> -EXPORT_SYMBOL(ingenic_ecc_release);
>  
>  int ingenic_ecc_probe(struct platform_device *pdev)
>  {
> @@ -159,8 +155,3 @@ int ingenic_ecc_probe(struct platform_device *pdev)
>  	return 0;
>  }
>  EXPORT_SYMBOL(ingenic_ecc_probe);

Any reason to keep this one?

Thanks,
Miquèl
