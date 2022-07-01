Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFE8562998
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 05:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbiGADjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 23:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbiGADjE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 23:39:04 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB47B61D72;
        Thu, 30 Jun 2022 20:39:01 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2613cNaE066029;
        Thu, 30 Jun 2022 22:38:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1656646703;
        bh=PGgwm8tF6Er4XvcaubNSeDGlcC3sySQ4+pqb5AHynn0=;
        h=Date:From:To:CC:Subject:References:In-Reply-To;
        b=IhmZEdkbPvgMFyYOVifB5W/q2788cxRd9E3Vfl59jk0JZn9Q62SEKZhDmkSIxn6gZ
         iU32rYeGVldEgFUaQtNjrwKAdwo07P0nAcG3ABURfS4rwHUYES6ETplYgWa+Ee03jw
         x9UnYi1wtfLW9ku+pXcCjLiAkgFHz8i1ubyqAOvc=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2613cNVL096920
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 30 Jun 2022 22:38:23 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Thu, 30
 Jun 2022 22:38:23 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Thu, 30 Jun 2022 22:38:23 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2613cNkl020254;
        Thu, 30 Jun 2022 22:38:23 -0500
Date:   Thu, 30 Jun 2022 22:38:23 -0500
From:   Nishanth Menon <nm@ti.com>
To:     Javier Martinez Canillas <javier@osg.samsung.com>,
        Nuno =?iso-8859-1?Q?S=E1?= <nuno.sa@analog.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] iio: adc: ti-adc128s052: Fix number of channels when
 device tree is used
Message-ID: <20220701033823.gkp5hfowv7f3eemx@tinsel>
References: <20220630230107.13438-1-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220630230107.13438-1-nm@ti.com>
User-Agent: NeoMutt/20171215
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18:01-20220630, Nishanth Menon wrote:
[...]

> diff --git a/drivers/iio/adc/ti-adc128s052.c b/drivers/iio/adc/ti-adc128s052.c
> index 622fd384983c..21a7764cbb93 100644
> --- a/drivers/iio/adc/ti-adc128s052.c
> +++ b/drivers/iio/adc/ti-adc128s052.c
> @@ -181,13 +181,13 @@ static int adc128_probe(struct spi_device *spi)
>  }
>  
>  static const struct of_device_id adc128_of_match[] = {
> -	{ .compatible = "ti,adc128s052", },
> -	{ .compatible = "ti,adc122s021", },
> -	{ .compatible = "ti,adc122s051", },
> -	{ .compatible = "ti,adc122s101", },
> -	{ .compatible = "ti,adc124s021", },
> -	{ .compatible = "ti,adc124s051", },
> -	{ .compatible = "ti,adc124s101", },
> +	{ .compatible = "ti,adc128s052", .data = 0},

I should probably cast these as .data = (void *)0 thoughts?

[...]

-- 
Regards,
Nishanth Menon
Key (0xDDB5849D1736249D) / Fingerprint: F8A2 8693 54EB 8232 17A3  1A34 DDB5 849D 1736 249D
