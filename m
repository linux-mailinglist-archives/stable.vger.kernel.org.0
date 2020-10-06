Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D148C284EB4
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 17:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgJFPSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 11:18:22 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:39066 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgJFPSW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 11:18:22 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 096FI90q075440;
        Tue, 6 Oct 2020 10:18:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1601997489;
        bh=cEvQkTPb5D58O6vqHt0d3zXE2tCjsask8K4wj8gkurE=;
        h=Date:From:To:CC:Subject:References:In-Reply-To;
        b=RtTlsAu1TxRWSNrU3qD3A0ybovtKnGgzsRpKzxClmi4V/3v24A5c69ZfofbDDRemx
         5cgWZBGzjtk7bzNhJ+XiX7jpBhmwe1LqErkMhL0l+rRQ7idzQQ4OokpsbjugK2ieuJ
         ASnYHpUJMsfiHiDvuyCjcW/7VasZ+i6wiHdQdFVQ=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 096FI9An078136
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 6 Oct 2020 10:18:09 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 6 Oct
 2020 10:18:09 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 6 Oct 2020 10:18:09 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 096FI8wx005857;
        Tue, 6 Oct 2020 10:18:08 -0500
Date:   Tue, 6 Oct 2020 20:48:07 +0530
From:   Pratyush Yadav <p.yadav@ti.com>
To:     Bert Vermeulen <bert@biot.com>
CC:     <tudor.ambarus@microchip.com>, <miquel.raynal@bootlin.com>,
        <richard@nod.at>, <vigneshr@ti.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [RESEND PATCH v2] mtd: spi-nor: Fix address width on flash chips
 > 16MB
Message-ID: <20201006151807.2pckm7ncply7uomc@ti.com>
References: <20201006132346.12652-1-bert@biot.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201006132346.12652-1-bert@biot.com>
User-Agent: NeoMutt/20171215
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/10/20 03:23PM, Bert Vermeulen wrote:
> If a flash chip has more than 16MB capacity but its BFPT reports
> BFPT_DWORD1_ADDRESS_BYTES_3_OR_4, the spi-nor framework defaults to 3.
> 
> The check in spi_nor_set_addr_width() doesn't catch it because addr_width
> did get set. This fixes that check.
> 
> Fixes: f9acd7fa80be ("mtd: spi-nor: sfdp: default to addr_width of 3 for configurable widths")
> Signed-off-by: Bert Vermeulen <bert@biot.com>
> Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> ---
>  drivers/mtd/spi-nor/core.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
> index 0369d98b2d12..a2c35ad9645c 100644
> --- a/drivers/mtd/spi-nor/core.c
> +++ b/drivers/mtd/spi-nor/core.c
> @@ -3009,13 +3009,15 @@ static int spi_nor_set_addr_width(struct spi_nor *nor)
>  		/* already configured from SFDP */
>  	} else if (nor->info->addr_width) {
>  		nor->addr_width = nor->info->addr_width;
> -	} else if (nor->mtd.size > 0x1000000) {
> -		/* enable 4-byte addressing if the device exceeds 16MiB */
> -		nor->addr_width = 4;
>  	} else {
>  		nor->addr_width = 3;
>  	}
>  
> +	if (nor->addr_width == 3 && nor->mtd.size > 0x1000000) {
Nitpick:    ^^^^^^^^^^^^^^^^^^^^^^^^ you can drop this part. But its 
fine either way.

Reviewed-by: Pratyush Yadav <p.yadav@ti.com>

> +		/* enable 4-byte addressing if the device exceeds 16MiB */
> +		nor->addr_width = 4;
> +	}
> +
>  	if (nor->addr_width > SPI_NOR_MAX_ADDR_WIDTH) {
>  		dev_dbg(nor->dev, "address width is too large: %u\n",
>  			nor->addr_width);

-- 
Regards,
Pratyush Yadav
Texas Instruments India
