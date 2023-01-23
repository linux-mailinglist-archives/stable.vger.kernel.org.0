Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAFCD677E2D
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 15:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbjAWOhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 09:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbjAWOhO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 09:37:14 -0500
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366BB166E8
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 06:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1674484632; x=1706020632;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=rxHa7fX5EGT6y96h4hm1HrsVopIqXKimYGpsM4vJx7o=;
  b=tG8SMZDT91fT84lMorseWzcBvrysCcOMdSE7k5uOsQmoneeQ5+ukXJWi
   KhFhuFHiVmCzh1raZSt/y3B6tZ/tSNI3OQBXUDiuLqzS5vtZMWnSAIby4
   r8u5SirZHBPNTuuaVoRjsBxcgsfvo/BjCr3J0G5oZyHz9cnZRH3j1YgIV
   4=;
X-IronPort-AV: E=Sophos;i="5.97,239,1669075200"; 
   d="scan'208";a="257150820"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2023 14:37:06 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com (Postfix) with ESMTPS id ECB10C23DE;
        Mon, 23 Jan 2023 14:37:02 +0000 (UTC)
Received: from EX13D26UEB003.ant.amazon.com (10.43.60.42) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Mon, 23 Jan 2023 14:37:02 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D26UEB003.ant.amazon.com (10.43.60.42) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Mon, 23 Jan 2023 14:37:01 +0000
Received: from dev-dsk-ptyadav-1c-37607b33.eu-west-1.amazon.com (10.15.11.255)
 by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.45 via Frontend Transport; Mon, 23 Jan 2023 14:37:01 +0000
Received: by dev-dsk-ptyadav-1c-37607b33.eu-west-1.amazon.com (Postfix, from userid 23027615)
        id 3F2CD20D8B; Mon, 23 Jan 2023 15:37:00 +0100 (CET)
From:   Pratyush Yadav <ptyadav@amazon.de>
To:     Tudor Ambarus <tudor.ambarus@linaro.org>
CC:     <Takahiro.Kuwano@infineon.com>, <tkuw584924@gmail.com>,
        <linux-mtd@lists.infradead.org>, <pratyush@kernel.org>,
        <michael@walle.cc>, <miquel.raynal@bootlin.com>, <richard@nod.at>,
        <Bacem.Daassi@infineon.com>, Dhruva Gole <d-gole@ti.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] mtd: spi-nor: spansion: Consider reserved bits in
 CFR5 register
References: <493d9a10-aaf3-70f6-36c3-9a2cf39f0759@linaro.org>
        <20230110164703.83413-1-tudor.ambarus@linaro.org>
Date:   Mon, 23 Jan 2023 15:37:00 +0100
In-Reply-To: <20230110164703.83413-1-tudor.ambarus@linaro.org> (Tudor
        Ambarus's message of "Tue, 10 Jan 2023 18:47:02 +0200")
Message-ID: <mafs0v8kxb9mb.fsf_-_@amazon.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+Cc Dhruva

Hi Tudor,

On Tue, Jan 10 2023, Tudor Ambarus wrote:

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
>  drivers/mtd/spi-nor/spansion.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
> index b621cdfd506f..07fe0f6fdfe3 100644
> --- a/drivers/mtd/spi-nor/spansion.c
> +++ b/drivers/mtd/spi-nor/spansion.c
> @@ -21,8 +21,13 @@
>  #define SPINOR_REG_CYPRESS_CFR3V               0x00800004
>  #define SPINOR_REG_CYPRESS_CFR3V_PGSZ          BIT(4) /* Page size. */
>  #define SPINOR_REG_CYPRESS_CFR5V               0x00800006
> -#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_EN    0x3
> -#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_DS    0
> +#define SPINOR_REG_CYPRESS_CFR5_BIT6           BIT(6)

Perhaps comment here that this bit is reserved. Otherwise it is not
obvious what this does and why we are setting it without going through
git-blame. No need for a re-roll, I think it is fine if you add this
when applying.

> +#define SPINOR_REG_CYPRESS_CFR5_DDR            BIT(1)
> +#define SPINOR_REG_CYPRESS_CFR5_OPI            BIT(0)
> +#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_EN                            \
> +       (SPINOR_REG_CYPRESS_CFR5_BIT6 | SPINOR_REG_CYPRESS_CFR5_DDR |   \
> +        SPINOR_REG_CYPRESS_CFR5_OPI)
> +#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_DS    SPINOR_REG_CYPRESS_CFR5_BIT6

I would say don't fix what isn't broken. But if you do, test it. Do you
or Takahiro have a Cypress S28* flash to test this change on? If no,
then perhaps Dhruva can help here since TI uses this flash on a bunch of
their boards?

The change looks fine to me with the above comment added, I just would
like someone to test it once.

Reviewed-by: Pratyush Yadav <ptyadav@amazon.de>

>  #define SPINOR_OP_CYPRESS_RD_FAST              0xee
>
>  /* Cypress SPI NOR flash operations. */
> --
> 2.34.1
>
>

-- 
Regards,
Pratyush Yadav



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



