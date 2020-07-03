Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E43214011
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 21:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgGCTgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 15:36:55 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:51528 "EHLO
        asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgGCTgz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jul 2020 15:36:55 -0400
Received: from ravnborg.org (unknown [188.228.123.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk4.altibox.net (Postfix) with ESMTPS id 016FA804F9;
        Fri,  3 Jul 2020 21:36:49 +0200 (CEST)
Date:   Fri, 3 Jul 2020 21:36:48 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc:     Adam Ford <aford173@gmail.com>, linux-fbdev@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] omapfb: dss: Fix max fclk divider for omap36xx
Message-ID: <20200703193648.GA373653@ravnborg.org>
References: <20200630182636.439015-1-aford173@gmail.com>
 <b9052a12-af5a-c1b9-5b86-907eac470cf8@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9052a12-af5a-c1b9-5b86-907eac470cf8@ti.com>
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=aP3eV41m c=1 sm=1 tr=0
        a=S6zTFyMACwkrwXSdXUNehg==:117 a=S6zTFyMACwkrwXSdXUNehg==:17
        a=kj9zAlcOel0A:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=sozttTNsAAAA:8
        a=P1BnusSwAAAA:8 a=7gkXJVJtAAAA:8 a=hD80L64hAAAA:8 a=i0EeH86SAAAA:8
        a=e5mUnYsNAAAA:8 a=0HEiEkm5zgkht_cWyOUA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=aeg5Gbbo78KNqacMgKqU:22
        a=D0XLA9XvdZm18NrgonBM:22 a=E9Po1WZjFZOl8hwRPBS3:22
        a=Vxmtnl_E_bksehYqCbjh:22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tomi.

On Fri, Jul 03, 2020 at 10:17:29AM +0300, Tomi Valkeinen wrote:
> On 30/06/2020 21:26, Adam Ford wrote:
> > The drm/omap driver was fixed to correct an issue where using a
> > divider of 32 breaks the DSS despite the TRM stating 32 is a valid
> > number.  Through experimentation, it appears that 31 works, and
> > it is consistent with the value used by the drm/omap driver.
> > 
> > This patch fixes the divider for fbdev driver instead of the drm.
> > 
> > Fixes: f76ee892a99e ("omapfb: copy omapdss & displays for omapfb")
> > 
> > Cc: <stable@vger.kernel.org> #4.9+
> > Signed-off-by: Adam Ford <aford173@gmail.com>
> > ---
> > Linux 4.4 will need a similar patch, but it doesn't apply cleanly.
> > 
> > The DRM version of this same fix is:
> > e2c4ed148cf3 ("drm/omap: fix max fclk divider for omap36xx")
> > 
> > 
> > diff --git a/drivers/video/fbdev/omap2/omapfb/dss/dss.c b/drivers/video/fbdev/omap2/omapfb/dss/dss.c
> > index 7252d22dd117..bfc5c4c5a26a 100644
> > --- a/drivers/video/fbdev/omap2/omapfb/dss/dss.c
> > +++ b/drivers/video/fbdev/omap2/omapfb/dss/dss.c
> > @@ -833,7 +833,7 @@ static const struct dss_features omap34xx_dss_feats = {
> >   };
> >   static const struct dss_features omap3630_dss_feats = {
> > -	.fck_div_max		=	32,
> > +	.fck_div_max		=	31,
> >   	.dss_fck_multiplier	=	1,
> >   	.parent_clk_name	=	"dpll4_ck",
> >   	.dpi_select_source	=	&dss_dpi_select_source_omap2_omap3,
> > 
> 
> Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Will you apply to drm-misc?

Note  following output from "dim fixes":
$ dim fixes f76ee892a99e
Fixes: f76ee892a99e ("omapfb: copy omapdss & displays for omapfb")
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Jason Yan <yanaijie@huawei.com>
Cc: "Andrew F. Davis" <afd@ti.com>
Cc: YueHaibing <yuehaibing@huawei.com>
Cc: <stable@vger.kernel.org> # v4.5+

Here it says the fix is valid from v4.5 onwards.

	Sam
> 
>  Tomi
> 
> -- 
> Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
> Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
