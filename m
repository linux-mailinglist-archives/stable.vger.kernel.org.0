Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA372215639
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 13:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbgGFLTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 07:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728578AbgGFLTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jul 2020 07:19:03 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E269EC061794;
        Mon,  6 Jul 2020 04:19:02 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id i25so39005232iog.0;
        Mon, 06 Jul 2020 04:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XBDJ3ik72+EzeQWMf1/QKd8Y/Fn6LaIHmILJwiRh6+E=;
        b=or4M9vcmro+UyndI3XdO3lSEq6xru9qniC1Z1GWXS7Q+0Ked8iZluQF/uSdBfOCqtp
         A1oZrC/ihcc7MNhryl5ByVACqnqf30yr/+xJRaxztj/q+qZjDFtmPqcjdPU04fiZUWV6
         dtTqVPHvwtKZ4YtCp8zEPxTqBFmP45cWAE80Chhox6At9U2eM3UV3RfBM545XkBpULoz
         89lWPX9BB9sK2/dimVvi4M298Z4S74DPdEKjNtVJNb28i6sNqnPFKFn7EHMk3lphpyFu
         D1JRHoFzWoBZ/R4QAPmIYlsjGpQ55pKbFQgYOJMOXaMENzzGMdnWSJTNR26NgFxCe2I5
         fAFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XBDJ3ik72+EzeQWMf1/QKd8Y/Fn6LaIHmILJwiRh6+E=;
        b=VdbEIL8FsbnRvZj2me6rKplvr1KnmWukKZHXo3Lyx5AViMYRb+B+Dm2St3nBXqJyJe
         7jw87/cnVsawp/2jHybUdx22lNOofdlFvyCkb6UmnWHB0lcqvJMLC5VPI2u30EkdLJwa
         +fka6DU7Yo3s+vZZ6ukURYg40yugQQPlSnxK7iq/eZBS7vH9p6iEZOcO7ABVcqIdDYih
         G5BUpznEU2t6KTdcvh7PrZxph7ZTZI8JGMFbVQ7d4CV0oEER219UYgSokaJkd+L8ppIY
         sgWZ3V9CtBuUBmuvUMfOMyCL3lBOL5vCCC7IDfPb54hF8c9mKvHyUCSB3kT6NJ01yqPS
         pIbA==
X-Gm-Message-State: AOAM531D5XQIJaqC+XBbr+cKDgF/NUTzaALJ/BVIoaGaCI1Me1B9ZTEM
        16xMT0UwkHL+eLMM1PiZi+jrIoxiaPG8SGSg3pk=
X-Google-Smtp-Source: ABdhPJyZMPISBjocSxAG9s4s40K4agAeJVqFKWBW1Ffd6KJnfjpCmMiFDvX1rSUqnu8cpiS/Kfad/9DfFzd5lPO+fQ0=
X-Received: by 2002:a6b:9242:: with SMTP id u63mr1166991iod.92.1594034342051;
 Mon, 06 Jul 2020 04:19:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200630182636.439015-1-aford173@gmail.com> <b9052a12-af5a-c1b9-5b86-907eac470cf8@ti.com>
 <20200703193648.GA373653@ravnborg.org> <bda1606f-b12c-3356-15ce-489fc2441737@ti.com>
In-Reply-To: <bda1606f-b12c-3356-15ce-489fc2441737@ti.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Mon, 6 Jul 2020 06:18:53 -0500
Message-ID: <CAHCN7xJdg8uUDaghFftze2K6t2pnyZg_JYpdmA=UU-shmk0Xgw@mail.gmail.com>
Subject: Re: [PATCH] omapfb: dss: Fix max fclk divider for omap36xx
To:     Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc:     Sam Ravnborg <sam@ravnborg.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-fbdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 6, 2020 at 1:02 AM Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
>
> Hi,
>
> On 03/07/2020 22:36, Sam Ravnborg wrote:
> > Hi Tomi.
> >
> > On Fri, Jul 03, 2020 at 10:17:29AM +0300, Tomi Valkeinen wrote:
> >> On 30/06/2020 21:26, Adam Ford wrote:
> >>> The drm/omap driver was fixed to correct an issue where using a
> >>> divider of 32 breaks the DSS despite the TRM stating 32 is a valid
> >>> number.  Through experimentation, it appears that 31 works, and
> >>> it is consistent with the value used by the drm/omap driver.
> >>>
> >>> This patch fixes the divider for fbdev driver instead of the drm.
> >>>
> >>> Fixes: f76ee892a99e ("omapfb: copy omapdss & displays for omapfb")
> >>>
> >>> Cc: <stable@vger.kernel.org> #4.9+
> >>> Signed-off-by: Adam Ford <aford173@gmail.com>
> >>> ---
> >>> Linux 4.4 will need a similar patch, but it doesn't apply cleanly.
> >>>
> >>> The DRM version of this same fix is:
> >>> e2c4ed148cf3 ("drm/omap: fix max fclk divider for omap36xx")
> >>>
> >>>
> >>> diff --git a/drivers/video/fbdev/omap2/omapfb/dss/dss.c b/drivers/video/fbdev/omap2/omapfb/dss/dss.c
> >>> index 7252d22dd117..bfc5c4c5a26a 100644
> >>> --- a/drivers/video/fbdev/omap2/omapfb/dss/dss.c
> >>> +++ b/drivers/video/fbdev/omap2/omapfb/dss/dss.c
> >>> @@ -833,7 +833,7 @@ static const struct dss_features omap34xx_dss_feats = {
> >>>    };
> >>>    static const struct dss_features omap3630_dss_feats = {
> >>> -   .fck_div_max            =       32,
> >>> +   .fck_div_max            =       31,
> >>>     .dss_fck_multiplier     =       1,
> >>>     .parent_clk_name        =       "dpll4_ck",
> >>>     .dpi_select_source      =       &dss_dpi_select_source_omap2_omap3,
> >>>
> >>
> >> Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > Will you apply to drm-misc?
>
> This is for fbdev, so I presume Bartlomiej will pick this one.
>
> > Note  following output from "dim fixes":
> > $ dim fixes f76ee892a99e
> > Fixes: f76ee892a99e ("omapfb: copy omapdss & displays for omapfb")
> > Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > Cc: Dave Airlie <airlied@gmail.com>
> > Cc: Rob Clark <robdclark@gmail.com>
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Cc: Sam Ravnborg <sam@ravnborg.org>
> > Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Cc: Jason Yan <yanaijie@huawei.com>
> > Cc: "Andrew F. Davis" <afd@ti.com>
> > Cc: YueHaibing <yuehaibing@huawei.com>
> > Cc: <stable@vger.kernel.org> # v4.5+
> >
> > Here it says the fix is valid from v4.5 onwards.
>
> Hmm... Adam, you marked the fix to apply to v4.9+, and then you said
> v4.4 needs a new patch (that's before the big copy/rename). Did you
> check the versions between 4.4 and 4.9? I would guess this one applies
> to v4.5+.

I only tried 4.9 because it's listed as an LTS kernel.  The stuff
between 4.4 and 4.9 were EOL, so I didn't go back further.    The 4.5+
is probably more accurate.  I would like to do the same thing for the
4.4 kernel, but I am not sure the proper way to do that.

adam
>
>   Tomi
>
> --
> Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
> Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
