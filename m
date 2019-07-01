Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73B915BB91
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 14:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbfGAMeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 08:34:15 -0400
Received: from outils.crapouillou.net ([89.234.176.41]:39072 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727239AbfGAMeP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 08:34:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1561984453; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GKdiybgHwDA7Rf/+crtL91g2jVq40fX1lbPYqcmDUIc=;
        b=E0sGXP6Rjt92eLRONxsaEYEjWc2c1tVfvUHUUzoBY6FQC+6ALxc5rGcxzDCOIzAYXfZHCV
        SXDwEiwzZdHvgXsDo2To51nqShAQpG+v5883uoYa4J2G4owqKydPZrgz1ErG/7ns3P7rdB
        MlrykTmEQYkZjnjuIry0PZWm4VDkF1Y=
Date:   Mon, 01 Jul 2019 14:34:07 +0200
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH] mtd: rawnand: ingenic: Fix ingenic_ecc dependency
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Richard Weinberger <richard@nod.at>, od@zcrc.me,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Hulk Robot <hulkci@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>, stable@vger.kernel.org
Message-Id: <1561984447.1999.0@crapouillou.net>
In-Reply-To: <20190701142847.1c1ac4b1@xps13>
References: <20190629012248.12447-1-paul@crapouillou.net>
        <20190701142847.1c1ac4b1@xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le lun. 1 juil. 2019 =E0 14:28, Miquel Raynal=20
<miquel.raynal@bootlin.com> a =E9crit :
> Hi Paul,
>=20
> One question below.
>=20
> Paul Cercueil <paul@crapouillou.net> wrote on Sat, 29 Jun 2019=20
> 03:22:48
> +0200:
>=20
>>  If MTD_NAND_JZ4780 is y and MTD_NAND_JZ4780_BCH is m,
>>  which select CONFIG_MTD_NAND_INGENIC_ECC to m, building fails:
>>=20
>>  drivers/mtd/nand/raw/ingenic/ingenic_nand.o: In function=20
>> `ingenic_nand_remove':
>>  ingenic_nand.c:(.text+0x177): undefined reference to=20
>> `ingenic_ecc_release'
>>  drivers/mtd/nand/raw/ingenic/ingenic_nand.o: In function=20
>> `ingenic_nand_ecc_correct':
>>  ingenic_nand.c:(.text+0x2ee): undefined reference to=20
>> `ingenic_ecc_correct'
>>=20
>>  To fix that, the ingenic_nand and ingenic_ecc modules have been=20
>> fused
>>  into one single module.
>>  - The ingenic_ecc.c code is now compiled in only if
>>    $(CONFIG_MTD_NAND_INGENIC_ECC) is set. This is now a boolean=20
>> instead
>>    of tristate.
>>  - To avoid changing the module name, the ingenic_nand.c file is=20
>> moved to
>>    ingenic_nand_drv.c. Then the module name is still ingenic_nand.
>>  - Since ingenic_ecc.c is no more a module, the module-specific=20
>> macros
>>    have been dropped, and the functions are no more exported for use=20
>> by
>>    the ingenic_nand driver.
>=20
> I am fine with this approach.
>=20
>>=20
>>  Fixes: 15de8c6efd0e ("mtd: rawnand: ingenic: Separate top-level and=20
>> SoC specific code")
>>  Signed-off-by: Paul Cercueil <paul@crapouillou.net>
>>  Reported-by: Arnd Bergmann <arnd@arndb.de>
>>  Reported-by: Hulk Robot <hulkci@huawei.com>
>>  Cc: YueHaibing <yuehaibing@huawei.com>
>>  Cc: stable@vger.kernel.org
>>  ---
>>   drivers/mtd/nand/raw/ingenic/Kconfig                     | 2 +-
>>   drivers/mtd/nand/raw/ingenic/Makefile                    | 4 +++-
>>   drivers/mtd/nand/raw/ingenic/ingenic_ecc.c               | 9=20
>> ---------
>>   .../raw/ingenic/{ingenic_nand.c =3D> ingenic_nand_drv.c}   | 0
>>   4 files changed, 4 insertions(+), 11 deletions(-)
>>   rename drivers/mtd/nand/raw/ingenic/{ingenic_nand.c =3D>=20
>> ingenic_nand_drv.c} (100%)
>>=20
>>  diff --git a/drivers/mtd/nand/raw/ingenic/Kconfig=20
>> b/drivers/mtd/nand/raw/ingenic/Kconfig
>>  index 19a96ce515c1..66b7cffdb0c2 100644
>>  --- a/drivers/mtd/nand/raw/ingenic/Kconfig
>>  +++ b/drivers/mtd/nand/raw/ingenic/Kconfig
>>  @@ -16,7 +16,7 @@ config MTD_NAND_JZ4780
>>   if MTD_NAND_JZ4780
>>=20
>>   config MTD_NAND_INGENIC_ECC
>>  -	tristate
>>  +	bool
>>=20
>>   config MTD_NAND_JZ4740_ECC
>>   	tristate "Hardware BCH support for JZ4740 SoC"
>>  diff --git a/drivers/mtd/nand/raw/ingenic/Makefile=20
>> b/drivers/mtd/nand/raw/ingenic/Makefile
>>  index 1ac4f455baea..b63d36889263 100644
>>  --- a/drivers/mtd/nand/raw/ingenic/Makefile
>>  +++ b/drivers/mtd/nand/raw/ingenic/Makefile
>>  @@ -2,7 +2,9 @@
>>   obj-$(CONFIG_MTD_NAND_JZ4740) +=3D jz4740_nand.o
>>   obj-$(CONFIG_MTD_NAND_JZ4780) +=3D ingenic_nand.o
>>=20
>>  -obj-$(CONFIG_MTD_NAND_INGENIC_ECC) +=3D ingenic_ecc.o
>>  +ingenic_nand-y +=3D ingenic_nand_drv.o
>>  +ingenic_nand-$(CONFIG_MTD_NAND_INGENIC_ECC) +=3D ingenic_ecc.o
>>  +
>>   obj-$(CONFIG_MTD_NAND_JZ4740_ECC) +=3D jz4740_ecc.o
>>   obj-$(CONFIG_MTD_NAND_JZ4725B_BCH) +=3D jz4725b_bch.o
>>   obj-$(CONFIG_MTD_NAND_JZ4780_BCH) +=3D jz4780_bch.o
>>  diff --git a/drivers/mtd/nand/raw/ingenic/ingenic_ecc.c=20
>> b/drivers/mtd/nand/raw/ingenic/ingenic_ecc.c
>>  index d3e085c5685a..c954189606f6 100644
>>  --- a/drivers/mtd/nand/raw/ingenic/ingenic_ecc.c
>>  +++ b/drivers/mtd/nand/raw/ingenic/ingenic_ecc.c
>>  @@ -30,7 +30,6 @@ int ingenic_ecc_calculate(struct ingenic_ecc *ecc,
>>   {
>>   	return ecc->ops->calculate(ecc, params, buf, ecc_code);
>>   }
>>  -EXPORT_SYMBOL(ingenic_ecc_calculate);
>>=20
>>   /**
>>    * ingenic_ecc_correct() - detect and correct bit errors
>>  @@ -51,7 +50,6 @@ int ingenic_ecc_correct(struct ingenic_ecc *ecc,
>>   {
>>   	return ecc->ops->correct(ecc, params, buf, ecc_code);
>>   }
>>  -EXPORT_SYMBOL(ingenic_ecc_correct);
>>=20
>>   /**
>>    * ingenic_ecc_get() - get the ECC controller device
>>  @@ -111,7 +109,6 @@ struct ingenic_ecc *of_ingenic_ecc_get(struct=20
>> device_node *of_node)
>>   	}
>>   	return ecc;
>>   }
>>  -EXPORT_SYMBOL(of_ingenic_ecc_get);
>>=20
>>   /**
>>    * ingenic_ecc_release() - release the ECC controller device
>>  @@ -122,7 +119,6 @@ void ingenic_ecc_release(struct ingenic_ecc=20
>> *ecc)
>>   	clk_disable_unprepare(ecc->clk);
>>   	put_device(ecc->dev);
>>   }
>>  -EXPORT_SYMBOL(ingenic_ecc_release);
>>=20
>>   int ingenic_ecc_probe(struct platform_device *pdev)
>>   {
>>  @@ -159,8 +155,3 @@ int ingenic_ecc_probe(struct platform_device=20
>> *pdev)
>>   	return 0;
>>   }
>>   EXPORT_SYMBOL(ingenic_ecc_probe);
>=20
> Any reason to keep this one?

This one is called from the three ECC drivers, which can be modules,
so it still needs to be exported.

-Paul

=

