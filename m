Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05BB215250
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 08:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbgGFGDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 02:03:00 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:40476 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728794AbgGFGDA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jul 2020 02:03:00 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06662lNM055242;
        Mon, 6 Jul 2020 01:02:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1594015367;
        bh=KjZlw1a/nmq4Ty3eASb8JP7sn5EXruzwzsBkpSaPwlA=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=lzkYPfA2BlXCMLdKkajDaZaQOHaW1L4TEMzcjeFuh5jLE+LVVJAKtfRRzx5JBobFJ
         hQDznclQillFZwhtKJQt8F6UW1/890lKHLRCgPjc//GVKs5UX0vvu7MUzG+plS8HAK
         g363haOP5I08lS4FEaxB7Yxx1WWaqI8pLmSjmpXw=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06662lV9094314
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 6 Jul 2020 01:02:47 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 6 Jul
 2020 01:02:47 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 6 Jul 2020 01:02:47 -0500
Received: from [10.250.217.39] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06662i1W034768;
        Mon, 6 Jul 2020 01:02:45 -0500
Subject: Re: [PATCH] omapfb: dss: Fix max fclk divider for omap36xx
To:     Sam Ravnborg <sam@ravnborg.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC:     Adam Ford <aford173@gmail.com>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <stable@vger.kernel.org>, <linux-omap@vger.kernel.org>
References: <20200630182636.439015-1-aford173@gmail.com>
 <b9052a12-af5a-c1b9-5b86-907eac470cf8@ti.com>
 <20200703193648.GA373653@ravnborg.org>
From:   Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <bda1606f-b12c-3356-15ce-489fc2441737@ti.com>
Date:   Mon, 6 Jul 2020 09:02:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200703193648.GA373653@ravnborg.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 03/07/2020 22:36, Sam Ravnborg wrote:
> Hi Tomi.
> 
> On Fri, Jul 03, 2020 at 10:17:29AM +0300, Tomi Valkeinen wrote:
>> On 30/06/2020 21:26, Adam Ford wrote:
>>> The drm/omap driver was fixed to correct an issue where using a
>>> divider of 32 breaks the DSS despite the TRM stating 32 is a valid
>>> number.  Through experimentation, it appears that 31 works, and
>>> it is consistent with the value used by the drm/omap driver.
>>>
>>> This patch fixes the divider for fbdev driver instead of the drm.
>>>
>>> Fixes: f76ee892a99e ("omapfb: copy omapdss & displays for omapfb")
>>>
>>> Cc: <stable@vger.kernel.org> #4.9+
>>> Signed-off-by: Adam Ford <aford173@gmail.com>
>>> ---
>>> Linux 4.4 will need a similar patch, but it doesn't apply cleanly.
>>>
>>> The DRM version of this same fix is:
>>> e2c4ed148cf3 ("drm/omap: fix max fclk divider for omap36xx")
>>>
>>>
>>> diff --git a/drivers/video/fbdev/omap2/omapfb/dss/dss.c b/drivers/video/fbdev/omap2/omapfb/dss/dss.c
>>> index 7252d22dd117..bfc5c4c5a26a 100644
>>> --- a/drivers/video/fbdev/omap2/omapfb/dss/dss.c
>>> +++ b/drivers/video/fbdev/omap2/omapfb/dss/dss.c
>>> @@ -833,7 +833,7 @@ static const struct dss_features omap34xx_dss_feats = {
>>>    };
>>>    static const struct dss_features omap3630_dss_feats = {
>>> -	.fck_div_max		=	32,
>>> +	.fck_div_max		=	31,
>>>    	.dss_fck_multiplier	=	1,
>>>    	.parent_clk_name	=	"dpll4_ck",
>>>    	.dpi_select_source	=	&dss_dpi_select_source_omap2_omap3,
>>>
>>
>> Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Will you apply to drm-misc?

This is for fbdev, so I presume Bartlomiej will pick this one.

> Note  following output from "dim fixes":
> $ dim fixes f76ee892a99e
> Fixes: f76ee892a99e ("omapfb: copy omapdss & displays for omapfb")
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: Dave Airlie <airlied@gmail.com>
> Cc: Rob Clark <robdclark@gmail.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Cc: Jason Yan <yanaijie@huawei.com>
> Cc: "Andrew F. Davis" <afd@ti.com>
> Cc: YueHaibing <yuehaibing@huawei.com>
> Cc: <stable@vger.kernel.org> # v4.5+
> 
> Here it says the fix is valid from v4.5 onwards.

Hmm... Adam, you marked the fix to apply to v4.9+, and then you said 
v4.4 needs a new patch (that's before the big copy/rename). Did you 
check the versions between 4.4 and 4.9? I would guess this one applies 
to v4.5+.

  Tomi

-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
