Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D1C2C99EF
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 09:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbgLAItL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbgLAItL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 03:49:11 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9530CC0613CF;
        Tue,  1 Dec 2020 00:48:30 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id t22so1631123ljk.0;
        Tue, 01 Dec 2020 00:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jwVJjrYf4EoWNF76bT56Jg1fGwktaIknwNyVbZNutqw=;
        b=HaiUwxLt5+T+f1NTruadDqbIVPhFVqULfYguIx1bQ97AjHJThL8pLuOihN/dPt4YMT
         6sodWnZ2zOQtaYanlnp3CoNYB8F8kFSfiKO5ZiaNKslWdztFum4pKTBW34DlqubIXR/H
         /we/2VHRVjrEJ342lYx4yyC8E4DNZMXCYwUEyBVxT33X51UfFcoN1MbJECGF5RdVQ/Tk
         gqOAfAt2rgg0vYWiQ/btho/110knlP77x/Sf+tLUMkYCA16m2nhrmZHrP7NT/xG9TrdA
         UWtbbC0jbADNTLORGtd0qvlfiMiNX0LaWeC8T1dAuU27xc+nstKVO6wXT+Jn48UDO69p
         6ilg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jwVJjrYf4EoWNF76bT56Jg1fGwktaIknwNyVbZNutqw=;
        b=X/EDk19MvP3JBq1HiWCGPFUUIt6W7UVjaLfUfSA609XNrDaMMDw/OydCUwXPgJwth/
         0KMe07HL1PmiWWcNGQcsF5W6fWYqPdFnXPYdjbKxGAh/cdeqEeXoBXVNM7/YsZCtjbdz
         diW/sIb+6YpglDn7IH4dcWneg7ZZZYn/FDH2ry/FEkT4sUOHw48/lY9AAX1pksdX3js1
         hsbnliZH/VhfcsW+jadMAX+acVEEf/LHN3btzemnS7GmXR/oRc+X/ZovzofPSeBZlHSA
         YaWLGMtYG3VOxuIXZZutan2X+hXA2j7iDGYdBIOsOxrSxwwWNxYvDV37OdmFpCr+sWcT
         CNWA==
X-Gm-Message-State: AOAM530PjuYprUGqg3g2UfN1rjhmlhfFCk9TyTikrAQX5tiS8s2l/PPP
        N9cdklCsgPMlC1RVvQv8B6n2YxKAS+n+/kFngQMdBcxfgs7Utg==
X-Google-Smtp-Source: ABdhPJypa/vi3ZkUTSCLWl6B7ybinXq71oQyq4tahZaKghY6IJrRSSxA6gpJTNF8lMYOAmryhItYJOScJNvcqaSZDSs=
X-Received: by 2002:a2e:a202:: with SMTP id h2mr849114ljm.346.1606812509148;
 Tue, 01 Dec 2020 00:48:29 -0800 (PST)
MIME-Version: 1.0
References: <20201127140559.381351-1-gregkh@linuxfoundation.org> <20201127140559.381351-2-gregkh@linuxfoundation.org>
In-Reply-To: <20201127140559.381351-2-gregkh@linuxfoundation.org>
From:   Peter Chen <hzpeterchen@gmail.com>
Date:   Tue, 1 Dec 2020 16:48:17 +0800
Message-ID: <CAL411-poRr1Mz5O6_9H8c9GmjF1UQN+2x9-EASfv7CcPzHvCVQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] USB: gadget: f_rndis: fix bitrate for SuperSpeed
 and above
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     balbi@kernel.org, peter.chen@nxp.com, willmcvicker@google.com,
        USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, EJ Hsu <ejh@nvidia.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>
> From: Will McVicker <willmcvicker@google.com>
>

Reviewed-by: Peter Chen <peter.chen@nxp.com>

Peter
> Align the SuperSpeed Plus bitrate for f_rndis to match f_ncm's ncm_bitrate
> defined by commit 1650113888fe ("usb: gadget: f_ncm: add SuperSpeed descriptors
> for CDC NCM").
>
> Cc: Felipe Balbi <balbi@kernel.org>
> Cc: EJ Hsu <ejh@nvidia.com>
> Cc: Peter Chen <peter.chen@nxp.com>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Will McVicker <willmcvicker@google.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/usb/gadget/function/f_rndis.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/usb/gadget/function/f_rndis.c b/drivers/usb/gadget/function/f_rndis.c
> index 9534c8ab62a8..0739b05a0ef7 100644
> --- a/drivers/usb/gadget/function/f_rndis.c
> +++ b/drivers/usb/gadget/function/f_rndis.c
> @@ -87,8 +87,10 @@ static inline struct f_rndis *func_to_rndis(struct usb_function *f)
>  /* peak (theoretical) bulk transfer rate in bits-per-second */
>  static unsigned int bitrate(struct usb_gadget *g)
>  {
> +       if (gadget_is_superspeed(g) && g->speed >= USB_SPEED_SUPER_PLUS)
> +               return 4250000000U;
>         if (gadget_is_superspeed(g) && g->speed == USB_SPEED_SUPER)
> -               return 13 * 1024 * 8 * 1000 * 8;
> +               return 3750000000U;
>         else if (gadget_is_dualspeed(g) && g->speed == USB_SPEED_HIGH)
>                 return 13 * 512 * 8 * 1000 * 8;
>         else
> --
> 2.29.2
>
