Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 638EADEA61
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 13:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbfJULHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 07:07:15 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38808 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbfJULHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 07:07:15 -0400
Received: by mail-io1-f67.google.com with SMTP id u8so15350746iom.5;
        Mon, 21 Oct 2019 04:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n1+aLy128QQ7U6cUlqcBOvUp4FNAoRlJ7X0gYCNLLqs=;
        b=Lx5prVpIW3WfSNwmK/1yUOg1NwGefIdVmw3AMLk1OwAkh0F/Ikkmu1hdJyTYRrSKZx
         ZTVAx6+TyKBcHZFYf7xIFZJLBHGK19Z/bgfCXkq3XmVO5MG1pHaDMVsRDYLutXPktMCt
         w5AN5ehKujfzQsE2PS/X4JBX/m5Ne4o8nxKGwnYa7LEupj7z8DjRN4x0aLlmG4RBZZBh
         HFCm62rSxEjdVHFiWJeVbt+lqtOXM8k3qfGeyW39MG5OH1VZQNXwAC00dAeM7gr8FiUb
         Qj2H2AaR85J8y+kHc47VPO3vOwdUgEqaqHfI8NlKxLR+lf85LJAuVfm2xycDH8h9WZBt
         GMnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n1+aLy128QQ7U6cUlqcBOvUp4FNAoRlJ7X0gYCNLLqs=;
        b=BBLciaVSihQ3OeGZLFHcDgid4Z4O4ehahL2C2DLnYugDl5kuUJoplnVy1SXNM496s3
         l/4tNmT8y/8DN5QVzSSutR5ltZzywDWCwtS/Trc0ZbFZamyues5b2je6D9bjlDc7H+wx
         oQP1PvG18sFa91LgtoHzB20wY2WDjJFrpmecz0eTukOz856uscqBidJzeILGoq9uk4yP
         7VIUseukqKGqkpik5unLMCW9VxWaUputWN+wljnv57NNMSVz3SX2NawFCBTivXv8cKs2
         pKmankDtR+Q0hGdiWP0w85zGjVuSOl4gT8yRFI1L+J/F/AIcSAeGpjhFnmdjtwlyO7Y/
         ULsQ==
X-Gm-Message-State: APjAAAXF/95U8mOv7RIjOESAmnLOYC/8kkTA4Ejo+IY0xpVSudfB0nSc
        DoX7UQFowKE2/WP+zy9iFiovtbtTOXhzIaP5Gxk=
X-Google-Smtp-Source: APXvYqxJS0FbQFfzoUfhz3RR8Z3vT75zJ5yamE9bYEK37eDUtbpG03UFr6Kz06usvzDFHokXueWoF3QYO1bPcztKW4Q=
X-Received: by 2002:a5d:9952:: with SMTP id v18mr20134179ios.58.1571656032438;
 Mon, 21 Oct 2019 04:07:12 -0700 (PDT)
MIME-Version: 1.0
References: <20191018130507.29893-1-aford173@gmail.com> <712504cb-c0ad-2e3e-bc3b-5cc1b70dd005@ti.com>
In-Reply-To: <712504cb-c0ad-2e3e-bc3b-5cc1b70dd005@ti.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Mon, 21 Oct 2019 06:07:01 -0500
Message-ID: <CAHCN7xLBY4bCkzEWEgcrdY0SrvMJv4Y2fSzVHO86P9+hUoZi0Q@mail.gmail.com>
Subject: Re: [PATCH] fbdev/omap: fix max fclk divider for omap36xx
To:     Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc:     linux-fbdev@vger.kernel.org,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Adam Ford <adam.ford@logicpd.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 21, 2019 at 3:44 AM Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
>
> On 18/10/2019 16:05, Adam Ford wrote:
> > The OMAP36xx and AM/DM37x TRMs say that the maximum divider for DSS fclk
> > (in CM_CLKSEL_DSS) is 32. Experimentation shows that this is not
> > correct, and using divider of 32 breaks DSS with a flood or underflows
> > and sync losts. Dividers up to 31 seem to work fine.
> >
> > There is another patch to the DT files to limit the divider correctly,
> > but as the DSS driver also needs to know the maximum divider to be able
> > to iteratively find good rates, we also need to do the fix in the DSS
> > driver.
> >
> > Signed-off-by: Adam Ford <aford173@gmail.com>
> > Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > Cc: stable@vger.kernel.org # linux-4.4.y only
> >
> > diff --git a/drivers/video/fbdev/omap2/dss/dss.c b/drivers/video/fbdev/omap2/dss/dss.c
> > index 9200a8668b49..a57c3a5f4bf8 100644
> > --- a/drivers/video/fbdev/omap2/dss/dss.c
> > +++ b/drivers/video/fbdev/omap2/dss/dss.c
> > @@ -843,7 +843,7 @@ static const struct dss_features omap34xx_dss_feats = {
> >   };
> >
> >   static const struct dss_features omap3630_dss_feats = {
> > -     .fck_div_max            =       32,
> > +     .fck_div_max            =       31,
> >       .dss_fck_multiplier     =       1,
> >       .parent_clk_name        =       "dpll4_ck",
> >       .dpi_select_source      =       &dss_dpi_select_source_omap2_omap3,
> >
>
> To clarify, this patch is only for the v4.4 stable, whereas the previous
> patch was for next merge window and v4.9+ stable. Right?

That is correct.  The patch I did for 4.9+ didn't apply cleanly on
4.4, so I had to do a separate patch for 4.4.

adam
>
> Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
>
>   Tomi
>
> --
> Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
> Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
