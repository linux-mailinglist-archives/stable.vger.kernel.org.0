Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2FA31BA8B
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 14:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbhBONuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 08:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbhBONug (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Feb 2021 08:50:36 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D45C061574
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 05:39:16 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id p21so10133661lfu.11
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 05:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6BYM7OU0X4+Ts4eFgjt8GD7MgdkB7+S8N/2hO3q/EQk=;
        b=B5NjPd3fxq3T05A6xMJSvu95blwBsJCgv/FK+EcPVE7msEJw9Teo/OH48R/uXfz2vx
         UYTz9zIGv7XY8oxe1FFJfKZsb9VaydeUz++xLCGZJYtG3f7V1idY00kBc1a/SpxDX2Pr
         08BEfxmjMcp3dHUMIkTC/a6/X6LGxs1aNfOEaLd5PEfnfQ8nTkdriIonq/gRQVlx9LOM
         WbzAeqpZ3BkWNE3Ajb3ME8al+UQLE3iI18UDHwkOMB+V/tbU192cMC21jukw4k3u5g0m
         epInkQyukKGGrns69s+ojLAHHeBJWduXAfLjxcPpdHmCkTRgKTs56mTtFfJd7G/JrWxH
         rn7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6BYM7OU0X4+Ts4eFgjt8GD7MgdkB7+S8N/2hO3q/EQk=;
        b=G+cl71jsYBEE+X7cdQzLF94yJmck+0rRtllHC/xA6Ro6nF2D6MYnVtATW3I2z7sGJN
         d6vxe4eNGTMPYVNBcqhukwQMC1mEAYZ40EqdI0Nh02jGWyJghIEJt4M9H7AT+DYBlTL4
         AfxkjUYgtNDUuIIr6tAlYHV0OmXjTXWjXHRmCAvkwr+NWgNY36IUEGEGYBN/LUlClrAQ
         5JI2LR/JwVWVe4RqoFC3JeeqGIEIeel/7BFDAwr/k5sRCvTIXEDRkz0VK4JIxD63pAxL
         0MZry0MZnjV4+WtX8aPPPVbeQj+tZKIoMPQCrFDaMpqCoBwt+FW9qmTz/vdKC4otYwP8
         Si7A==
X-Gm-Message-State: AOAM531/ikuTzzV+ay+ckGrePFi/VMkNlgagrNxQrAuSiAwpzrsWmr/0
        bOTgTaQ61j3LqV9aLMn07obW7T0AUMfrHaPC7lk=
X-Google-Smtp-Source: ABdhPJwE/WKjc/fkUcHrXwy8je/n46qRIabOn4VzngTagIEsxA1RmF1H9YMQNFX0DAzZOTryZx7raOM0Z6HcGRWrBT4=
X-Received: by 2002:a05:6512:10c5:: with SMTP id k5mr8526324lfg.583.1613396355133;
 Mon, 15 Feb 2021 05:39:15 -0800 (PST)
MIME-Version: 1.0
References: <20210119231341.2498036-1-festevam@gmail.com> <CAOMZO5AekLMhN6+itpaROqOdmE3mV-Z8yKoCRcyNxPoW7tqPuw@mail.gmail.com>
In-Reply-To: <CAOMZO5AekLMhN6+itpaROqOdmE3mV-Z8yKoCRcyNxPoW7tqPuw@mail.gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Mon, 15 Feb 2021 10:39:03 -0300
Message-ID: <CAOMZO5C8a4cj+zZixjMYArgnki0DzAJdyZ3yh9rHW8abx8Dx=A@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] drm/msm: Call shutdown conditionally
To:     Rob Clark <robdclark@gmail.com>
Cc:     Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Krishna Manikandan <mkrishn@codeaurora.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Marek <jonathan@marek.ca>, kalyan_t@codeaurora.org,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Gentle ping...

On Fri, Jan 29, 2021 at 8:09 AM Fabio Estevam <festevam@gmail.com> wrote:
>
> Hi Rob,
>
> Any comments on this series, please?
>
> On Tue, Jan 19, 2021 at 8:15 PM Fabio Estevam <festevam@gmail.com> wrote:
> >
> > Issuing a 'reboot' command in i.MX5 leads to the following flow:
> >
> > [   24.557742] [<c0769b78>] (msm_atomic_commit_tail) from [<c06db0b4>]
> > (commit_tail+0xa4/0x1b0)
> > [   24.566349] [<c06db0b4>] (commit_tail) from [<c06dbed0>]
> > (drm_atomic_helper_commit+0x154/0x188)
> > [   24.575193] [<c06dbed0>] (drm_atomic_helper_commit) from
> > [<c06db604>] (drm_atomic_helper_disable_all+0x154/0x1c0)
> > [   24.585599] [<c06db604>] (drm_atomic_helper_disable_all) from
> > [<c06db704>] (drm_atomic_helper_shutdown+0x94/0x12c)
> > [   24.596094] [<c06db704>] (drm_atomic_helper_shutdown) from
> >
> > In the i.MX5 case, priv->kms is not populated (as i.MX5 does not use any
> > of the Qualcomm display controllers), causing a NULL pointer
> > dereference in msm_atomic_commit_tail():
> >
> > [   24.268964] 8<--- cut here ---
> > [   24.274602] Unable to handle kernel NULL pointer dereference at
> > virtual address 00000000
> > [   24.283434] pgd = (ptrval)
> > [   24.286387] [00000000] *pgd=ca212831
> > [   24.290788] Internal error: Oops: 17 [#1] SMP ARM
> > [   24.295609] Modules linked in:
> > [   24.298777] CPU: 0 PID: 197 Comm: init Not tainted 5.11.0-rc2-next-20210111 #333
> > [   24.306276] Hardware name: Freescale i.MX53 (Device Tree Support)
> > [   24.312442] PC is at msm_atomic_commit_tail+0x54/0xb9c
> > [   24.317743] LR is at commit_tail+0xa4/0x1b0
> >
> > Fix the problem by calling drm_atomic_helper_shutdown() conditionally.
> >
> > Cc: <stable@vger.kernel.org>
> > Fixes: 9d5cbf5fe46e ("drm/msm: add shutdown support for display platform_driver")
> > Suggested-by: Rob Clark <robdclark@gmail.com>
> > Signed-off-by: Fabio Estevam <festevam@gmail.com>
> > ---
> > Changes since v1:
> > - Explain in the commit log that the problem happens after a 'reboot' command.
> >
> >  drivers/gpu/drm/msm/msm_drv.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
> > index 108c405e03dd..c082b72b9e3b 100644
> > --- a/drivers/gpu/drm/msm/msm_drv.c
> > +++ b/drivers/gpu/drm/msm/msm_drv.c
> > @@ -1311,7 +1311,8 @@ static void msm_pdev_shutdown(struct platform_device *pdev)
> >  {
> >         struct drm_device *drm = platform_get_drvdata(pdev);
> >
> > -       drm_atomic_helper_shutdown(drm);
> > +       if (get_mdp_ver(pdev))
> > +               drm_atomic_helper_shutdown(drm);
> >  }
> >
> >  static const struct of_device_id dt_match[] = {
> > --
> > 2.25.1
> >
