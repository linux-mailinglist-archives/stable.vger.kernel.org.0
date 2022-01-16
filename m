Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A8E48FD0A
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 13:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235200AbiAPMwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jan 2022 07:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235028AbiAPMwI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jan 2022 07:52:08 -0500
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B890CC061574;
        Sun, 16 Jan 2022 04:52:07 -0800 (PST)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id CA353100D940F;
        Sun, 16 Jan 2022 13:52:05 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id A7CE14A85B; Sun, 16 Jan 2022 13:52:05 +0100 (CET)
Date:   Sun, 16 Jan 2022 13:52:05 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     patrice.chotard@foss.st.com
Cc:     Mark Brown <broonie@kernel.org>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        linux-spi@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        christophe.kerello@foss.st.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] spi: stm32-qspi: Update spi registering
Message-ID: <20220116125205.GA18267@wunner.de>
References: <20220112144424.5278-1-patrice.chotard@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220112144424.5278-1-patrice.chotard@foss.st.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 12, 2022 at 03:44:24PM +0100, patrice.chotard@foss.st.com wrote:
> diff --git a/drivers/spi/spi-stm32-qspi.c b/drivers/spi/spi-stm32-qspi.c
> index 514337c86d2c..09839a3dbb26 100644
> --- a/drivers/spi/spi-stm32-qspi.c
> +++ b/drivers/spi/spi-stm32-qspi.c
> @@ -688,7 +688,7 @@ static int stm32_qspi_probe(struct platform_device *pdev)
>  	struct resource *res;
>  	int ret, irq;
>  
> -	ctrl = spi_alloc_master(dev, sizeof(*qspi));
> +	ctrl = devm_spi_alloc_master(dev, sizeof(*qspi));
>  	if (!ctrl)
>  		return -ENOMEM;
>  
> @@ -784,7 +784,7 @@ static int stm32_qspi_probe(struct platform_device *pdev)
>  	pm_runtime_enable(dev);
>  	pm_runtime_get_noresume(dev);
>  
> -	ret = devm_spi_register_master(dev, ctrl);
> +	ret = spi_register_master(ctrl);
>  	if (ret)
>  		goto err_pm_runtime_free;
>

Unfortunately this patch is still not correct:  It introduces a
double free in the probe error path.

You need to remove this...

err_master_put:
	spi_master_put(qspi->ctrl);

...and replace all the gotos in stm32_qspi_probe() which jump
to the err_master_put label with a return statement.

Thanks,

Lukas
