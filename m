Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2D284EFAB1
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 22:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347583AbiDAUIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 16:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236538AbiDAUII (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 16:08:08 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B191100E25;
        Fri,  1 Apr 2022 13:06:08 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 231K5wGL060226;
        Fri, 1 Apr 2022 15:05:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1648843558;
        bh=/Fa41M7WpEnzzkUG/Dcr3RaYCMlEH4p6C+CVR6sjCcw=;
        h=Date:From:To:CC:Subject:References:In-Reply-To;
        b=VZNgr+tMOy10A9z0lsvbaF5WM/Yiemppa3ydri0lXiu0jRzEWkijc9JkXqQylqu1t
         8XncyDuG0Bidp2aWGYTPiwgW9Y6hc1o9uRSF18+GCAhlPEk8uaZXplElKYsKCZv85p
         PDYcyUEGLhGlwGIkTc2aYy2tqF1Zcl+Dk71DhTEA=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 231K5wSj050036
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 1 Apr 2022 15:05:58 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Fri, 1
 Apr 2022 15:05:57 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Fri, 1 Apr 2022 15:05:57 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 231K5uiQ001449;
        Fri, 1 Apr 2022 15:05:57 -0500
Date:   Sat, 2 Apr 2022 01:35:56 +0530
From:   Pratyush Yadav <p.yadav@ti.com>
To:     Tudor Ambarus <tudor.ambarus@microchip.com>
CC:     <michael@walle.cc>, <miquel.raynal@bootlin.com>, <richard@nod.at>,
        <vigneshr@ti.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v2] mtd: spi-nor: core: Skip setting erase types when
 SPI_NOR_NO_ERASE is set
Message-ID: <20220401200556.d6amfxdvyf66npyj@ti.com>
References: <20220308091135.88615-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220308091135.88615-1-tudor.ambarus@microchip.com>
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/03/22 11:11AM, Tudor Ambarus wrote:
> Even if SPI_NOR_NO_ERASE was specified at flash declaration, the erase
> type of size nor->info->sector_size was incorrectly set as supported.
> Don't set erase types when SPI_NOR_NO_ERASE is set.

Does this have any practical implications? Since we set MTD_NO_ERASE, 
erase should never be called for this flash anyway, right?

> 
> Fixes: b199489d37b2 ("mtd: spi-nor: add the framework for SPI NOR")
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> Cc: stable@vger.kernel.org
> ---
> v2:
> - add comment, update commit message, split change in individual commit
> - add fixes tag and cc to stable.
> 
>  drivers/mtd/spi-nor/core.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
> index b4f141ad9c9c..64cf7b9df621 100644
> --- a/drivers/mtd/spi-nor/core.c
> +++ b/drivers/mtd/spi-nor/core.c
> @@ -2392,6 +2392,10 @@ static void spi_nor_no_sfdp_init_params(struct spi_nor *nor)
>  					SPINOR_OP_PP, SNOR_PROTO_8_8_8_DTR);
>  	}
>  
> +	/* Skip setting erase types when SPI_NOR_NO_ERASE is set. */
> +	if (nor->info->flags & SPI_NOR_NO_ERASE)
> +		return;
> +
>  	/*
>  	 * Sector Erase settings. Sort Erase Types in ascending order, with the
>  	 * smallest erase size starting at BIT(0).
> -- 
> 2.25.1
> 

-- 
Regards,
Pratyush Yadav
Texas Instruments Inc.
