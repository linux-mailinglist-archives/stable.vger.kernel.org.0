Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69BE2134C7
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 09:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgGCHRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 03:17:38 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:59178 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgGCHRi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jul 2020 03:17:38 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0637HWoL115147;
        Fri, 3 Jul 2020 02:17:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593760652;
        bh=tpCp46YgYhG/QrH4ChjpFQLXP5Ol+QOmEFujaXnFEPI=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=JFeFvps/w2XpkSxRKOeoGYS+r9rHLogTZ3ryq3TPoNHlrFsoSe73PrTb/r1LNGu1e
         MoALpJE2Yvc8JCUNQ26yAkS3aRQ5Qaqb5I8S/egTIQBrt/xU2z1SB9+r9GsxG+REy4
         eVNfNSyPqlsZR1ZlGZ0K0s9P3a0o0dhMru/IqdyU=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0637HWPh031794
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 3 Jul 2020 02:17:32 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 3 Jul
 2020 02:17:31 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 3 Jul 2020 02:17:31 -0500
Received: from [192.168.2.6] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0637HTNE007840;
        Fri, 3 Jul 2020 02:17:30 -0500
Subject: Re: [PATCH] omapfb: dss: Fix max fclk divider for omap36xx
To:     Adam Ford <aford173@gmail.com>, <linux-fbdev@vger.kernel.org>
CC:     <stable@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Dave Airlie <airlied@gmail.com>,
        Rob Clark <robdclark@gmail.com>, <linux-omap@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
References: <20200630182636.439015-1-aford173@gmail.com>
From:   Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <b9052a12-af5a-c1b9-5b86-907eac470cf8@ti.com>
Date:   Fri, 3 Jul 2020 10:17:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200630182636.439015-1-aford173@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30/06/2020 21:26, Adam Ford wrote:
> The drm/omap driver was fixed to correct an issue where using a
> divider of 32 breaks the DSS despite the TRM stating 32 is a valid
> number.  Through experimentation, it appears that 31 works, and
> it is consistent with the value used by the drm/omap driver.
> 
> This patch fixes the divider for fbdev driver instead of the drm.
> 
> Fixes: f76ee892a99e ("omapfb: copy omapdss & displays for omapfb")
> 
> Cc: <stable@vger.kernel.org> #4.9+
> Signed-off-by: Adam Ford <aford173@gmail.com>
> ---
> Linux 4.4 will need a similar patch, but it doesn't apply cleanly.
> 
> The DRM version of this same fix is:
> e2c4ed148cf3 ("drm/omap: fix max fclk divider for omap36xx")
> 
> 
> diff --git a/drivers/video/fbdev/omap2/omapfb/dss/dss.c b/drivers/video/fbdev/omap2/omapfb/dss/dss.c
> index 7252d22dd117..bfc5c4c5a26a 100644
> --- a/drivers/video/fbdev/omap2/omapfb/dss/dss.c
> +++ b/drivers/video/fbdev/omap2/omapfb/dss/dss.c
> @@ -833,7 +833,7 @@ static const struct dss_features omap34xx_dss_feats = {
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
