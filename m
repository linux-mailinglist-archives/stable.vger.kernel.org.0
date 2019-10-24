Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4001EE35E8
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 16:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409472AbfJXOrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 10:47:01 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2764 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731758AbfJXOrB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 10:47:01 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5db1b96d0000>; Thu, 24 Oct 2019 07:47:09 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 24 Oct 2019 07:46:59 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 24 Oct 2019 07:46:59 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 24 Oct
 2019 14:46:59 +0000
Received: from [10.21.133.51] (172.20.13.39) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 24 Oct
 2019 14:46:56 +0000
Subject: Re: [PATCH] spi: Fix SPI_CS_HIGH setting when using native and GPIO
 CS
To:     Gregory CLEMENT <gregory.clement@bootlin.com>,
        Mark Brown <broonie@kernel.org>, <linux-spi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191018152929.3287-1-gregory.clement@bootlin.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <dfabf9eb-4f81-91e5-55dc-caea0cdabd2d@nvidia.com>
Date:   Thu, 24 Oct 2019 15:46:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191018152929.3287-1-gregory.clement@bootlin.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1571928429; bh=UR7GI6ra/3dXXR2Vtr481RK9pUnPbTyXrBLeSPlE+qc=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=A1JsITbDKX3hKjjkksWvBOCR6jsVUsrY3SwXGULRjCmMmmgBFv1VBTnC20aCd42lT
         FqrEsuOpDZA03Bo/dwlGRbFM0q8bk4kTLtyefVEf9sS2r8uOEl5QFaiaNpRrd3WF8f
         LIOwZYzCAUoALPEXqifc1eZnbrtmZRWBi8NVQWRsimT6wFWjf64xdc5uzliK0krU4k
         K5VbK0sjTdwScAr7n/UTd2ICy0iVDc7TjXD6uuWOj5pZhsyqDKjsXS08SU92LfAyOy
         cb6O6+R0O/BKx1Mwuor07vIW+/oaVAARobQE8gwnx/AS6QK7wgHCEDbJJQYVP8MFJJ
         +vb6D2p9q6Xjg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 18/10/2019 16:29, Gregory CLEMENT wrote:
> When improving the CS GPIO support at core level, the SPI_CS_HIGH
> has been enabled for all the CS lines used for a given SPI controller.
> 
> However, the SPI framework allows to have on the same controller native
> CS and GPIO CS. The native CS may not support the SPI_CS_HIGH, so they
> should not be setup automatically.
> 
> With this patch the setting is done only for the CS that will use a
> GPIO as CS
> 
> Fixes: f3186dd87669 ("spi: Optionally use GPIO descriptors for CS GPIOs")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
> ---
>  drivers/spi/spi.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 5414a10afd65..1b68acc28c8f 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -1880,15 +1880,7 @@ static int of_spi_parse_dt(struct spi_controller *ctlr, struct spi_device *spi,
>  		spi->mode |= SPI_3WIRE;
>  	if (of_property_read_bool(nc, "spi-lsb-first"))
>  		spi->mode |= SPI_LSB_FIRST;
> -
> -	/*
> -	 * For descriptors associated with the device, polarity inversion is
> -	 * handled in the gpiolib, so all chip selects are "active high" in
> -	 * the logical sense, the gpiolib will invert the line if need be.
> -	 */
> -	if (ctlr->use_gpio_descriptors)
> -		spi->mode |= SPI_CS_HIGH;
> -	else if (of_property_read_bool(nc, "spi-cs-high"))
> +	if (of_property_read_bool(nc, "spi-cs-high"))
>  		spi->mode |= SPI_CS_HIGH;
>  
>  	/* Device DUAL/QUAD mode */
> @@ -1952,6 +1944,14 @@ static int of_spi_parse_dt(struct spi_controller *ctlr, struct spi_device *spi,
>  	}
>  	spi->chip_select = value;
>  
> +	/*
> +	 * For descriptors associated with the device, polarity inversion is
> +	 * handled in the gpiolib, so all gpio chip selects are "active high"
> +	 * in the logical sense, the gpiolib will invert the line if need be.
> +	 */
> +	if ((ctlr->use_gpio_descriptors) && ctlr->cs_gpiods[spi->chip_select])
> +		spi->mode |= SPI_CS_HIGH;
> +

This patch is causing a boot regression on one of our Tegra boards. 
Bisect is pointing to this commit and reverting on top of today's -next
fixes the problem. 

This patch is causing the following NULL pointer crash which I assume is
because we have not checked if 'ctlr->cs_gpiods' is valid before
dereferencing ...

[    2.083593] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[    2.091800] pgd = (ptrval)
[    2.094513] [00000000] *pgd=00000000
[    2.098122] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
[    2.103436] Modules linked in:
[    2.106501] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.4.0-rc4-next-20191024-00013-gdda3f5db0962 #402
[    2.115808] Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
[    2.122084] PC is at spi_register_controller+0x870/0xac0
[    2.127409] LR is at of_find_property+0x44/0x4c
[    2.131943] pc : [<c0629b98>]    lr : [<c078b068>]    psr: 20000013
[    2.138210] sp : ee8cdda8  ip : 00000000  fp : 00000000
[    2.143436] r10: eefe88e8  r9 : 00000001  r8 : eefe8898
[    2.148662] r7 : ee2dac00  r6 : c0d2019c  r5 : c0d20190  r4 : ee2d8800
[    2.155190] r3 : 00000000  r2 : 00000000  r1 : ffffffff  r0 : 00000001
[    2.161719] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[    2.168857] Control: 10c5387d  Table: 8000406a  DAC: 00000051
[    2.174604] Process swapper/0 (pid: 1, stack limit = 0x(ptrval))
[    2.180613] Stack: (0xee8cdda8 to 0xee8ce000)
[    2.184976] dda0:                   00000000 00000044 c0629e0c 00000000 c1004e48 c0d202c8
[    2.193161] ddc0: 00000000 d20df1b4 c0628544 ee2d2040 ee2d8800 eea6c010 eea6c010 40000000
[    2.201344] dde0: 00000000 00000055 c0f8cd14 c0629e1c ee2d8800 ee2d8bc0 eea6c010 eea6c000
[    2.209528] de00: 40000000 c062db18 eea6b500 ee2d8bc0 eea6c010 00000000 c10807d4 00000000
[    2.217710] de20: c10807d4 00000000 00000000 c05b1050 c1110834 eea6c010 c1110838 c05af028
[    2.225893] de40: eea6c010 c10807d4 c10807d4 c1004e48 00000000 c0f0058c c0f71854 c05af2b8
[    2.234077] de60: c0f71854 c078be00 c0b91164 eea6c010 00000000 c10807d4 c1004e48 00000000
[    2.242259] de80: c0f0058c c0f71854 c0f8cd14 c05af568 00000000 c10807d4 eea6c010 c05af5f0
[    2.250442] dea0: 00000000 c10807d4 c05af570 c05ad39c c0f0058c ee90ea5c eea651b4 d20df1b4
[    2.258626] dec0: c1077590 c10807d4 ee2d2580 c1077590 00000000 c05ae390 c0d20a60 c10c73a0
[    2.266809] dee0: ffffe000 c10807d4 c10c73a0 ffffe000 c0f3b368 c05b0144 c1004e48 c10c73a0
[    2.274992] df00: ffffe000 c010306c 0000011e c01454b4 c0de9d70 c0d32c00 00000000 00000006
[    2.283175] df20: 00000006 c0cbf1b0 00000000 c1004e48 c0cd2680 c0cbf224 00000000 efffcc21
[    2.291358] df40: efffcc45 d20df1b4 00000000 c10d4e00 c10d4e00 d20df1b4 c10d4e00 c10d4e00
[    2.299541] df60: 00000007 c0f71834 0000011e c0f01040 00000006 00000006 00000000 c0f0058c
[    2.307723] df80: c0aad7c4 00000000 c0aad7c4 00000000 00000000 00000000 00000000 00000000
[    2.315906] dfa0: 00000000 c0aad7cc 00000000 c01010e8 00000000 00000000 00000000 00000000
[    2.324088] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    2.332271] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[    2.340463] [<c0629b98>] (spi_register_controller) from [<c0629e1c>] (devm_spi_register_controller+0x34/0x6c)
[    2.350389] [<c0629e1c>] (devm_spi_register_controller) from [<c062db18>] (tegra_spi_probe+0x33c/0x448)
[    2.359794] [<c062db18>] (tegra_spi_probe) from [<c05b1050>] (platform_drv_probe+0x48/0x98)
[    2.368155] [<c05b1050>] (platform_drv_probe) from [<c05af028>] (really_probe+0x234/0x34c)
[    2.376427] [<c05af028>] (really_probe) from [<c05af2b8>] (driver_probe_device+0x60/0x168)
[    2.384699] [<c05af2b8>] (driver_probe_device) from [<c05af568>] (device_driver_attach+0x58/0x60)
[    2.393578] [<c05af568>] (device_driver_attach) from [<c05af5f0>] (__driver_attach+0x80/0xbc)
[    2.402108] [<c05af5f0>] (__driver_attach) from [<c05ad39c>] (bus_for_each_dev+0x74/0xb4)
[    2.410292] [<c05ad39c>] (bus_for_each_dev) from [<c05ae390>] (bus_add_driver+0x164/0x1e8)
[    2.418563] [<c05ae390>] (bus_add_driver) from [<c05b0144>] (driver_register+0x7c/0x114)
[    2.426663] [<c05b0144>] (driver_register) from [<c010306c>] (do_one_initcall+0x54/0x2a8)
[    2.434851] [<c010306c>] (do_one_initcall) from [<c0f01040>] (kernel_init_freeable+0x14c/0x1e8)
[    2.443560] [<c0f01040>] (kernel_init_freeable) from [<c0aad7cc>] (kernel_init+0x8/0x10c)
[    2.451747] [<c0aad7cc>] (kernel_init) from [<c01010e8>] (ret_from_fork+0x14/0x2c)
[    2.459318] Exception stack(0xee8cdfb0 to 0xee8cdff8)
[    2.464374] dfa0:                                     00000000 00000000 00000000 00000000
[    2.472557] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    2.480740] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    2.487362] Code: e3520000 0a000006 e59422f8 e6ef3073 (e7923103) 
[    2.493510] ---[ end trace c189900877242550 ]---

Cheers
Jon

-- 
nvpublic
