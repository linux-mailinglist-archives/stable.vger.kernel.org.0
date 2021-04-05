Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F8F353C68
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbhDEIcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:32:46 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:32778 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232240AbhDEIcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 04:32:46 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1358WBPV088117;
        Mon, 5 Apr 2021 03:32:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1617611532;
        bh=aIM1P+J+7+MCBa4886JZPt41jVqnVkokltalE8AxDjU=;
        h=Date:From:To:CC:Subject:References:In-Reply-To;
        b=tYybcERF6fnMaN1oa6vbJI7bdeI6hV/+Lg2fdz8Jw+2pSJ2lChkhQueB+bXY/XuXa
         xNCN5XkAMtsTE0RganrvTwxvW4j9ecoJ5WHBpJ5/r/oY/0SesHNOGmZNs/hB176EDn
         ZLU41RsHvTIHHTyg3H49QMYiZ6IBWaOhxPZJvVk8=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1358WBLS056298
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 5 Apr 2021 03:32:11 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 5 Apr
 2021 03:32:11 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Mon, 5 Apr 2021 03:32:11 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 1358WAoB003080;
        Mon, 5 Apr 2021 03:32:11 -0500
Date:   Mon, 5 Apr 2021 14:02:10 +0530
From:   Pratyush Yadav <p.yadav@ti.com>
To:     Tudor Ambarus <tudor.ambarus@microchip.com>
CC:     <michael@walle.cc>, <vigneshr@ti.com>, <masonccyang@mxic.com.tw>,
        <zhengxunli@mxic.com.tw>, <ycllin@mxic.com.tw>,
        <juliensu@mxic.com.tw>, <miquel.raynal@bootlin.com>,
        <richard@nod.at>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] Revert "mtd: spi-nor: macronix: Add support for
 mx25l51245g"
Message-ID: <20210405083208.qhdvpokoyr36awzf@ti.com>
References: <20210402082031.19055-1-tudor.ambarus@microchip.com>
 <20210402082031.19055-2-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210402082031.19055-2-tudor.ambarus@microchip.com>
User-Agent: NeoMutt/20171215
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/04/21 11:20AM, Tudor Ambarus wrote:
> This reverts commit 04b8edad262eec0d153005973dfbdd83423c0dcb.
> 
> mx25l51245g and mx66l51235l have the same flash ID. The flash
> detection returns the first entry in the flash_info array that
> matches the flash ID that was read, thus for the 0xc2201a ID,
> mx25l51245g was always hit, introducing a regression for
> mx66l51235l.
> 
> If one wants to differentiate the flash names, a better fix would be
> to differentiate between the two at run-time, depending on SFDP,
> and choose the correct name from a list of flash names, depending on
> the SFDP differentiator.
> 
> Fixes: 04b8edad262e ("mtd: spi-nor: macronix: Add support for mx25l51245g")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>

Acked-by: Pratyush Yadav <p.yadav@ti.com>

> ---
>  drivers/mtd/spi-nor/macronix.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/mtd/spi-nor/macronix.c b/drivers/mtd/spi-nor/macronix.c
> index 6c2680b4cdad..42c2cf31702e 100644
> --- a/drivers/mtd/spi-nor/macronix.c
> +++ b/drivers/mtd/spi-nor/macronix.c
> @@ -72,9 +72,6 @@ static const struct flash_info macronix_parts[] = {
>  			      SECT_4K | SPI_NOR_DUAL_READ |
>  			      SPI_NOR_QUAD_READ) },
>  	{ "mx25l25655e", INFO(0xc22619, 0, 64 * 1024, 512, 0) },
> -	{ "mx25l51245g", INFO(0xc2201a, 0, 64 * 1024, 1024,
> -			      SECT_4K | SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
> -			      SPI_NOR_4B_OPCODES) },
>  	{ "mx66l51235l", INFO(0xc2201a, 0, 64 * 1024, 1024,
>  			      SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
>  			      SPI_NOR_4B_OPCODES) },
> -- 
> 2.25.1
> 

-- 
Regards,
Pratyush Yadav
Texas Instruments Inc.
