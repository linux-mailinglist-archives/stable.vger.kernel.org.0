Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADCA14C9869
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 23:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238008AbiCAWgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 17:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233241AbiCAWgZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 17:36:25 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6C43D1EC
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 14:35:43 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 6391922239;
        Tue,  1 Mar 2022 23:35:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1646174138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=adTrpLZVJKnmmjxY3JrXYa+2AmXR5qdUoDqMVNFtUuU=;
        b=Jd/xtd1UuNOXUmRqReeRrjXcjtBpUf0cjIXRcZ9xxbzk7rgcwYDjkIJm+52OqB+ndQnG2U
        FGvFxe+9AKaD9ozFksPkuxt+/0aiw8r37Bzq6fDsGONkDOewzp5pKo5nlKE73IbcGnjAU8
        BkAJfAFzyRgW8q0NKB3P672++Zl2Fm0=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 01 Mar 2022 23:35:38 +0100
From:   Michael Walle <michael@walle.cc>
To:     Tudor Ambarus <tudor.ambarus@microchip.com>
Cc:     p.yadav@ti.com, miquel.raynal@bootlin.com, richard@nod.at,
        vigneshr@ti.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, nicolas.ferre@microchip.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] mtd: spi-nor: Skip erase logic when SPI_NOR_NO_ERASE is
 set
In-Reply-To: <20220228163334.277730-1-tudor.ambarus@microchip.com>
References: <20220228163334.277730-1-tudor.ambarus@microchip.com>
User-Agent: Roundcube Webmail/1.4.12
Message-ID: <b8eb5a09b0a716093299ad4e6a3f727e@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 2022-02-28 17:33, schrieb Tudor Ambarus:
> Even if SPI_NOR_NO_ERASE was set, one could still send erase opcodes
> to the flash. It is not recommended to send unsupported opcodes to
> flashes. Fix the logic and do not set mtd->_erase when SPI_NOR_NO_ERASE
> is specified. With this users will not be able to issue erase opcodes 
> to
> flashes and instead they will recive an -ENOTSUPP error.

But why is there an erase opcode and erase size set in the
first place? spi_nor_select_erase() should probably return
early if SPI_NOR_NO_ERASE is set. Not setting the erasesize
would also return -ENOTSUPP. I prefer this one for a fixes
patch, though. But spi_nor_select_erase() should also be
fixed.

Reviewed-by: Michael Walle <michael@walle.cc>

> 
> Cc: stable@vger.kernel.org
> Fixes: b199489d37b2 ("mtd: spi-nor: add the framework for SPI NOR")
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> ---
>  drivers/mtd/spi-nor/core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
> index 86a536c97c18..cd2d094ef837 100644
> --- a/drivers/mtd/spi-nor/core.c
> +++ b/drivers/mtd/spi-nor/core.c
> @@ -2969,10 +2969,11 @@ static void spi_nor_set_mtd_info(struct spi_nor 
> *nor)
>  	mtd->flags = MTD_CAP_NORFLASH;
>  	if (nor->info->flags & SPI_NOR_NO_ERASE)
>  		mtd->flags |= MTD_NO_ERASE;
> +	else
> +		mtd->_erase = spi_nor_erase;
>  	mtd->writesize = nor->params->writesize;
>  	mtd->writebufsize = nor->params->page_size;
>  	mtd->size = nor->params->size;
> -	mtd->_erase = spi_nor_erase;
>  	mtd->_read = spi_nor_read;
>  	/* Might be already set by some SST flashes. */
>  	if (!mtd->_write)
