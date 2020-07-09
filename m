Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B226E21983E
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 08:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgGIGKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 02:10:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgGIGKw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jul 2020 02:10:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CE31206A5;
        Thu,  9 Jul 2020 06:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594275051;
        bh=HkO5Yg136PYC2vLtfeUtNDLTItu1WXaILkpHkgJ+kI4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sLttGrpufPQVt+u3fxp4mi2R6RDJR5DtBMws794b2hTptjRsjf3gvPM6cHsHLyer/
         4aCxkZcuxRYvYRNWvwW4jK2ffF9PGak4YXAha7EpFiRHa9YYxN05Y1expxSNzhowwP
         nbMdXzYy7IGI8I2JB2brCvvvvLZoeDrRxClxYyt4=
Date:   Thu, 9 Jul 2020 08:10:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Adam Ford <aford173@gmail.com>
Cc:     Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-fbdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] omapfb: dss: Fix max fclk divider for omap36xx
Message-ID: <20200709061048.GA129902@kroah.com>
References: <20200630182636.439015-1-aford173@gmail.com>
 <b9052a12-af5a-c1b9-5b86-907eac470cf8@ti.com>
 <20200703193648.GA373653@ravnborg.org>
 <bda1606f-b12c-3356-15ce-489fc2441737@ti.com>
 <CAHCN7xJdg8uUDaghFftze2K6t2pnyZg_JYpdmA=UU-shmk0Xgw@mail.gmail.com>
 <CAHCN7xLGAWEO5CPDOsHoy4B0FjD+1GHhHYgihmVg=mhjUFjSTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHCN7xLGAWEO5CPDOsHoy4B0FjD+1GHhHYgihmVg=mhjUFjSTQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 08, 2020 at 06:37:51PM -0500, Adam Ford wrote:
> On Mon, Jul 6, 2020 at 6:18 AM Adam Ford <aford173@gmail.com> wrote:
> >
> > On Mon, Jul 6, 2020 at 1:02 AM Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> > >
> > > Hi,
> > >
> > > On 03/07/2020 22:36, Sam Ravnborg wrote:
> > > > Hi Tomi.
> > > >
> > > > On Fri, Jul 03, 2020 at 10:17:29AM +0300, Tomi Valkeinen wrote:
> > > >> On 30/06/2020 21:26, Adam Ford wrote:
> > > >>> The drm/omap driver was fixed to correct an issue where using a
> > > >>> divider of 32 breaks the DSS despite the TRM stating 32 is a valid
> > > >>> number.  Through experimentation, it appears that 31 works, and
> > > >>> it is consistent with the value used by the drm/omap driver.
> > > >>>
> > > >>> This patch fixes the divider for fbdev driver instead of the drm.
> > > >>>
> > > >>> Fixes: f76ee892a99e ("omapfb: copy omapdss & displays for omapfb")
> > > >>>
> > > >>> Cc: <stable@vger.kernel.org> #4.9+
> > > >>> Signed-off-by: Adam Ford <aford173@gmail.com>
> > > >>> ---
> > > >>> Linux 4.4 will need a similar patch, but it doesn't apply cleanly.
> > > >>>
> > > >>> The DRM version of this same fix is:
> > > >>> e2c4ed148cf3 ("drm/omap: fix max fclk divider for omap36xx")
> > > >>>
> > > >>>
> > > >>> diff --git a/drivers/video/fbdev/omap2/omapfb/dss/dss.c b/drivers/video/fbdev/omap2/omapfb/dss/dss.c
> > > >>> index 7252d22dd117..bfc5c4c5a26a 100644
> > > >>> --- a/drivers/video/fbdev/omap2/omapfb/dss/dss.c
> > > >>> +++ b/drivers/video/fbdev/omap2/omapfb/dss/dss.c
> > > >>> @@ -833,7 +833,7 @@ static const struct dss_features omap34xx_dss_feats = {
> > > >>>    };
> > > >>>    static const struct dss_features omap3630_dss_feats = {
> > > >>> -   .fck_div_max            =       32,
> > > >>> +   .fck_div_max            =       31,
> > > >>>     .dss_fck_multiplier     =       1,
> > > >>>     .parent_clk_name        =       "dpll4_ck",
> > > >>>     .dpi_select_source      =       &dss_dpi_select_source_omap2_omap3,
> > > >>>
> > > >>
> > > >> Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > > > Will you apply to drm-misc?
> > >
> > > This is for fbdev, so I presume Bartlomiej will pick this one.
> > >
> > > > Note  following output from "dim fixes":
> > > > $ dim fixes f76ee892a99e
> > > > Fixes: f76ee892a99e ("omapfb: copy omapdss & displays for omapfb")
> > > > Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > > > Cc: Dave Airlie <airlied@gmail.com>
> > > > Cc: Rob Clark <robdclark@gmail.com>
> > > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > Cc: Sam Ravnborg <sam@ravnborg.org>
> > > > Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > > > Cc: Jason Yan <yanaijie@huawei.com>
> > > > Cc: "Andrew F. Davis" <afd@ti.com>
> > > > Cc: YueHaibing <yuehaibing@huawei.com>
> > > > Cc: <stable@vger.kernel.org> # v4.5+
> > > >
> > > > Here it says the fix is valid from v4.5 onwards.
> > >
> > > Hmm... Adam, you marked the fix to apply to v4.9+, and then you said
> > > v4.4 needs a new patch (that's before the big copy/rename). Did you
> > > check the versions between 4.4 and 4.9? I would guess this one applies
> > > to v4.5+.
> >
> > I only tried 4.9 because it's listed as an LTS kernel.  The stuff
> > between 4.4 and 4.9 were EOL, so I didn't go back further.    The 4.5+
> > is probably more accurate.  I would like to do the same thing for the
> > 4.4 kernel, but I am not sure the proper way to do that.
> 
> What is the correct protocol for patching 4.4?  I'd like to do that,
> but the patch would be unique to the 4.4.  Should I just submit the
> patch directly to stable and cc Tomi?

Yes, and document the heck out of why this is a 4.4-only patch, and why
we can't take whatever happened in newer kernels instead.

thanks,

greg k-h
