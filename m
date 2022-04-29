Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A0F514237
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 08:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbiD2GR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 02:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbiD2GR4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 02:17:56 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527A92BB1D;
        Thu, 28 Apr 2022 23:14:39 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 23T6EUd9077933;
        Fri, 29 Apr 2022 01:14:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1651212870;
        bh=xXkrQ3q3z0PdAf/m6HeYDXI5BYXEer6eG+MZS/t7BHQ=;
        h=Date:From:To:CC:Subject:References:In-Reply-To;
        b=CJlYJhERM3SB4xjH5NOuMbeuATBA2za+toHXAeMzbcojYcENz/qtleUQO0v8bOWnL
         s+KFbenpw0YTQcC7AI/176jA6yf0fiywucv3y/TE1ClpcoU8/3NTNT8m1y8MspAlki
         TLlwN5d4LDNoTNxHVzhXTh7TBmOdLC77HDl6Ma60=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 23T6EUiC123358
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 29 Apr 2022 01:14:30 -0500
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Fri, 29
 Apr 2022 01:14:30 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Fri, 29 Apr 2022 01:14:29 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 23T6ETeq027808;
        Fri, 29 Apr 2022 01:14:29 -0500
Date:   Fri, 29 Apr 2022 11:44:28 +0530
From:   Pratyush Yadav <p.yadav@ti.com>
To:     Tudor Ambarus <tudor.ambarus@microchip.com>
CC:     <michael@walle.cc>, <miquel.raynal@bootlin.com>, <richard@nod.at>,
        <vigneshr@ti.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v2] mtd: spi-nor: core: Skip setting erase types when
 SPI_NOR_NO_ERASE is set
Message-ID: <20220429061428.uouoycktw2i3qamb@ti.com>
References: <20220308091135.88615-1-tudor.ambarus@microchip.com>
 <20220401200556.d6amfxdvyf66npyj@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220401200556.d6amfxdvyf66npyj@ti.com>
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/04/22 01:35AM, Pratyush Yadav wrote:
> On 08/03/22 11:11AM, Tudor Ambarus wrote:
> > Even if SPI_NOR_NO_ERASE was specified at flash declaration, the erase
> > type of size nor->info->sector_size was incorrectly set as supported.
> > Don't set erase types when SPI_NOR_NO_ERASE is set.
> 
> Does this have any practical implications? Since we set MTD_NO_ERASE, 
> erase should never be called for this flash anyway, right?
> 
> > 
> > Fixes: b199489d37b2 ("mtd: spi-nor: add the framework for SPI NOR")
> > Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> > Cc: stable@vger.kernel.org
> > ---
> > v2:
> > - add comment, update commit message, split change in individual commit
> > - add fixes tag and cc to stable.
> > 
> >  drivers/mtd/spi-nor/core.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
> > index b4f141ad9c9c..64cf7b9df621 100644
> > --- a/drivers/mtd/spi-nor/core.c
> > +++ b/drivers/mtd/spi-nor/core.c
> > @@ -2392,6 +2392,10 @@ static void spi_nor_no_sfdp_init_params(struct spi_nor *nor)
> >  					SPINOR_OP_PP, SNOR_PROTO_8_8_8_DTR);
> >  	}
> >  
> > +	/* Skip setting erase types when SPI_NOR_NO_ERASE is set. */
> > +	if (nor->info->flags & SPI_NOR_NO_ERASE)
> > +		return;

Can you instead do

	if (!(nor->info->flags & SPI_NOR_NO_ERASE)) {
		...
	}

This way when someone adds code to the bottom of this function that sets 
something other than erase types it will execute for flashes with 
SPI_NOR_NO_ERASE as well.

> > +
> >  	/*
> >  	 * Sector Erase settings. Sort Erase Types in ascending order, with the
> >  	 * smallest erase size starting at BIT(0).
> > -- 
> > 2.25.1
> > 
> 
> -- 
> Regards,
> Pratyush Yadav
> Texas Instruments Inc.
> 
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/

-- 
Regards,
Pratyush Yadav
Texas Instruments Inc.
