Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610166654B7
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 07:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbjAKGis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 01:38:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235848AbjAKG2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 01:28:47 -0500
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE621017
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 22:28:45 -0800 (PST)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30B6S8dI101718;
        Wed, 11 Jan 2023 00:28:08 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1673418488;
        bh=WcW91YAyKjlIQrQcOurw8rgU0vjesNHRtsqviNUsCJg=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=F3uheWdbEuNcajueQIxrYCFRiNRc33jAfnjpiU0T75IiAshvvEV7JsqPgV416JgID
         hIeO+FGkMkFKSUPSfWfMyJiMFRVrtHnTxSZDLZ8t5tSN8ckWsAmxTUGlcfdVKyItJd
         rBnh6mHCd+oZKonE54jXMUpG6B8w1ay2fmoTxX60=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30B6S7vB115095
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Jan 2023 00:28:07 -0600
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 11
 Jan 2023 00:28:04 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 11 Jan 2023 00:28:04 -0600
Received: from [10.24.69.26] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30B6S1nq082604;
        Wed, 11 Jan 2023 00:28:01 -0600
Message-ID: <6314bf2f-9cc7-2766-bad0-bcec44a59a84@ti.com>
Date:   Wed, 11 Jan 2023 11:58:00 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 1/2] mtd: spi-nor: spansion: Consider reserved bits in
 CFR5 register
Content-Language: en-US
To:     Tudor Ambarus <tudor.ambarus@linaro.org>,
        <Takahiro.Kuwano@infineon.com>, <tkuw584924@gmail.com>
CC:     <linux-mtd@lists.infradead.org>, <pratyush@kernel.org>,
        <michael@walle.cc>, <miquel.raynal@bootlin.com>, <richard@nod.at>,
        <Bacem.Daassi@infineon.com>, <stable@vger.kernel.org>
References: <493d9a10-aaf3-70f6-36c3-9a2cf39f0759@linaro.org>
 <20230110164703.83413-1-tudor.ambarus@linaro.org>
From:   Dhruva Gole <d-gole@ti.com>
In-Reply-To: <20230110164703.83413-1-tudor.ambarus@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/01/23 22:17, Tudor Ambarus wrote:
> CFR5[6] is reserved bit and must be always 1. Set it to comply with flash
> requirements. While fixing SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_{EN, DS}
> definition, stop using magic numbers and describe the missing bit fields
> in CFR5 register. This is useful for both readability and future possible
> addition of Octal STR mode support.
> 
> Fixes: c3266af101f2 ("mtd: spi-nor: spansion: add support for Cypress Semper flash")
> Cc: stable@vger.kernel.org
> Reported-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
> Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
> ---

Reviewed-by: Dhruva Gole <d-gole@ti.com>

>   drivers/mtd/spi-nor/spansion.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
> index b621cdfd506f..07fe0f6fdfe3 100644
> --- a/drivers/mtd/spi-nor/spansion.c
> +++ b/drivers/mtd/spi-nor/spansion.c
> @@ -21,8 +21,13 @@
>   #define SPINOR_REG_CYPRESS_CFR3V		0x00800004
>   #define SPINOR_REG_CYPRESS_CFR3V_PGSZ		BIT(4) /* Page size. */
>   #define SPINOR_REG_CYPRESS_CFR5V		0x00800006
> -#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_EN	0x3
> -#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_DS	0
> +#define SPINOR_REG_CYPRESS_CFR5_BIT6		BIT(6)
> +#define SPINOR_REG_CYPRESS_CFR5_DDR		BIT(1)
> +#define SPINOR_REG_CYPRESS_CFR5_OPI		BIT(0)
> +#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_EN				\
> +	(SPINOR_REG_CYPRESS_CFR5_BIT6 |	SPINOR_REG_CYPRESS_CFR5_DDR |	\
> +	 SPINOR_REG_CYPRESS_CFR5_OPI)
> +#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_DS	SPINOR_REG_CYPRESS_CFR5_BIT6
>   #define SPINOR_OP_CYPRESS_RD_FAST		0xee
>   
>   /* Cypress SPI NOR flash operations. */

-- 
Thanks and Regards,
Dhruva Gole
