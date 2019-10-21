Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 307B3DE6DC
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 10:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbfJUIom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 04:44:42 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:52918 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbfJUIom (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 04:44:42 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id x9L8idk3104173;
        Mon, 21 Oct 2019 03:44:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1571647479;
        bh=DDg3LWxscvyyXGbEjqescmT5LKMOD1f8SepEshmq+cA=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=FA9VVVwPSTPuaABZgQe4Mb6BH+VXBERCLxMx86uVX/1aF7u0i03jsnr6dpDFoB5Hi
         m2bi0C5uZ+xuNcHahE+2AIr69ylCWqKCmfCu/IRAw7d/G3gfmKBBelVFzmX6mRE1TU
         v2UPXlUnN0kzZ2Q2sY0c3rmJhDauiao+fzuU8Qos=
Received: from DLEE101.ent.ti.com (dlee101.ent.ti.com [157.170.170.31])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x9L8idio130326
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 21 Oct 2019 03:44:39 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Mon, 21
 Oct 2019 03:44:29 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Mon, 21 Oct 2019 03:44:29 -0500
Received: from [192.168.2.6] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9L8iLlk052375;
        Mon, 21 Oct 2019 03:44:22 -0500
Subject: Re: [PATCH] fbdev/omap: fix max fclk divider for omap36xx
To:     Adam Ford <aford173@gmail.com>, <linux-fbdev@vger.kernel.org>
CC:     <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <adam.ford@logicpd.com>, <stable@vger.kernel.org>
References: <20191018130507.29893-1-aford173@gmail.com>
From:   Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <712504cb-c0ad-2e3e-bc3b-5cc1b70dd005@ti.com>
Date:   Mon, 21 Oct 2019 11:44:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191018130507.29893-1-aford173@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/10/2019 16:05, Adam Ford wrote:
> The OMAP36xx and AM/DM37x TRMs say that the maximum divider for DSS fclk
> (in CM_CLKSEL_DSS) is 32. Experimentation shows that this is not
> correct, and using divider of 32 breaks DSS with a flood or underflows
> and sync losts. Dividers up to 31 seem to work fine.
> 
> There is another patch to the DT files to limit the divider correctly,
> but as the DSS driver also needs to know the maximum divider to be able
> to iteratively find good rates, we also need to do the fix in the DSS
> driver.
> 
> Signed-off-by: Adam Ford <aford173@gmail.com>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: stable@vger.kernel.org # linux-4.4.y only
> 
> diff --git a/drivers/video/fbdev/omap2/dss/dss.c b/drivers/video/fbdev/omap2/dss/dss.c
> index 9200a8668b49..a57c3a5f4bf8 100644
> --- a/drivers/video/fbdev/omap2/dss/dss.c
> +++ b/drivers/video/fbdev/omap2/dss/dss.c
> @@ -843,7 +843,7 @@ static const struct dss_features omap34xx_dss_feats = {
>   };
>   
>   static const struct dss_features omap3630_dss_feats = {
> -	.fck_div_max		=	32,
> +	.fck_div_max		=	31,
>   	.dss_fck_multiplier	=	1,
>   	.parent_clk_name	=	"dpll4_ck",
>   	.dpi_select_source	=	&dss_dpi_select_source_omap2_omap3,
> 

To clarify, this patch is only for the v4.4 stable, whereas the previous 
patch was for next merge window and v4.9+ stable. Right?

Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

  Tomi

-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
