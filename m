Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80548DE6CC
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 10:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfJUImj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 04:42:39 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:52332 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfJUImj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 04:42:39 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id x9L8gXFZ103191;
        Mon, 21 Oct 2019 03:42:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1571647353;
        bh=7DTT/sWjsBy8Zjjf2rheZYVPaNOCPJxVzbIedIsgc3k=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Cyl+M2vHKoMAzP0Yr9PD+bCDJH+Lq/Z2N/y8ygRGEqZuOUe7BAZ64xq2UiUBUL5ea
         gCzGkOgLZMvLTT26srTdKXzZ1Y0Aj7MHEC1dQwcOj1eQieA4iVDlDSIVw+eMg1YUQ2
         JNOip6Af1kZlyPTRdGltB8gYeYoVscxxiL8rmbvY=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x9L8gIQx124808
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 21 Oct 2019 03:42:18 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Mon, 21
 Oct 2019 03:42:09 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Mon, 21 Oct 2019 03:42:09 -0500
Received: from [192.168.2.6] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9L8gGr6046523;
        Mon, 21 Oct 2019 03:42:17 -0500
Subject: Re: [PATCH] fbdev/omap: fix max fclk divider for omap36xx
To:     Adam Ford <aford173@gmail.com>, <linux-fbdev@vger.kernel.org>
CC:     <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <adam.ford@logicpd.com>, <stable@vger.kernel.org>
References: <20191018124938.29313-1-aford173@gmail.com>
From:   Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <7b8b6eba-2cb3-9b25-66e2-e128cc09ceb4@ti.com>
Date:   Mon, 21 Oct 2019 11:42:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191018124938.29313-1-aford173@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/10/2019 15:49, Adam Ford wrote:
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
> Cc: stable@vger.kernel.org #linux-4.9.y+
> 
> diff --git a/drivers/video/fbdev/omap2/omapfb/dss/dss.c b/drivers/video/fbdev/omap2/omapfb/dss/dss.c
> index 48c6500c24e1..4429ad37b64c 100644
> --- a/drivers/video/fbdev/omap2/omapfb/dss/dss.c
> +++ b/drivers/video/fbdev/omap2/omapfb/dss/dss.c
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

Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

  Tomi

-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
