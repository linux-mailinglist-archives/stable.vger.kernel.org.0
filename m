Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C8B1941DD
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 15:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbgCZOrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 10:47:37 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44547 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727547AbgCZOrh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 10:47:37 -0400
Received: by mail-ot1-f66.google.com with SMTP id a49so6009707otc.11
        for <stable@vger.kernel.org>; Thu, 26 Mar 2020 07:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=21sA9g1ah5YLHz3mrqgNVqbfCXay7GQgiRwVQtiYC70=;
        b=gw0ozJAwXL7dWCwf+DZU8mnSeaOyUdVv20niwYUA5WCnzbqdtc998xkKcVgSPDw0vs
         roRmttCdqB5mhB+QSolV50Xi1p0VSEZwZ/H/6Ii/BOu2kwMaGzdkEv3ElYAmzwYRv1xv
         Ht6xpz0rRBLs2EkCbPmrc1fo6yla9ii5Ob1aE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=21sA9g1ah5YLHz3mrqgNVqbfCXay7GQgiRwVQtiYC70=;
        b=FKqenTRo++AAIH4sNyj5wElszJP5Jp/tdWIlVN8AsHqe47I1D3oGmVOIJOG5XHH1x2
         7PJgkL2Kx+W11OfyUqyNvDOO+1BR/xXjUBi10OoDyq4YTCXJJuDsFTF73xRD5tzJ5T++
         +ivHngU9uQI/AJd1tOtSbNPMxYrD2lcXloDJDpExhFMLtveOMSyC8HNMnccimK6VA5KH
         WbSe8oc4cV6j+eEDiRwKQ/SFOMEs3c/Jq8ssUIpNkDGlqpmMakaieGvHd7FNaUaIYOQV
         Tz3BsRY+p60hJ/0PkJWBVV0jY/LNu1cA2D2pdxD00bsgAnEdfCCUQvjT06qxWBwlrdQh
         YyWg==
X-Gm-Message-State: ANhLgQ2vY234y9JAqZ59eBMdDV/lBeZ9krMDcv90najh7uGffUQhQLep
        Yc4lRumhCCO+BF0EnTJSrrBKBFRqkPWccxaPeVy+xyc6N+o=
X-Google-Smtp-Source: ADFU+vtzF4d38kls+GUWIuw6zEGbhJbRvmvcdyHO0/worOdG+9qtq9Bde25mS0Iv7StNPomoMLwQndgwIGhL4x9M3H0=
X-Received: by 2002:a9d:2056:: with SMTP id n80mr6762206ota.281.1585234055848;
 Thu, 26 Mar 2020 07:47:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200325144310.36779-1-hdegoede@redhat.com> <20200326112959.GZ2363188@phenom.ffwll.local>
 <8b9d940d-b236-062d-4ac3-c7462090066f@redhat.com> <CAKMK7uHA+uefrWVR42wTss65mq_D4q5odfePm6uj399emkWx8w@mail.gmail.com>
 <8fbfde07-be1e-c8c8-2ff4-c7b64c3f150d@redhat.com>
In-Reply-To: <8fbfde07-be1e-c8c8-2ff4-c7b64c3f150d@redhat.com>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Thu, 26 Mar 2020 15:47:24 +0100
Message-ID: <CAKMK7uFk_o2PURDVGWdN+LPkg4bDunotEvvG=voF7ee-2cCq2w@mail.gmail.com>
Subject: Re: [PATCH] drm/vboxvideo: Add missing remove_conflicting_pci_framebuffers
 call
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        stable <stable@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 26, 2020 at 3:40 PM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Hi,
>
> On 3/26/20 2:39 PM, Daniel Vetter wrote:
> > On Thu, Mar 26, 2020 at 2:18 PM Hans de Goede <hdegoede@redhat.com> wrote:
> >>
> >> Hi,
> >>
> >> On 3/26/20 12:29 PM, Daniel Vetter wrote:
> >>> On Wed, Mar 25, 2020 at 03:43:10PM +0100, Hans de Goede wrote:
> >>>> The vboxvideo driver is missing a call to remove conflicting framebuffers.
> >>>>
> >>>> Surprisingly, when using legacy BIOS booting this does not really cause
> >>>> any issues. But when using UEFI to boot the VM then plymouth will draw
> >>>> on both the efifb /dev/fb0 and /dev/drm/card0 (which has registered
> >>>> /dev/fb1 as fbdev emulation).
> >>>>
> >>>> VirtualBox will actual display the output of both devices (I guess it is
> >>>> showing whatever was drawn last), this causes weird artifacts because of
> >>>> pitch issues in the efifb when the VM window is not sized at 1024x768
> >>>> (the window will resize to its last size once the vboxvideo driver loads,
> >>>> changing the pitch).
> >>>>
> >>>> Adding the missing drm_fb_helper_remove_conflicting_pci_framebuffers()
> >>>> call fixes this.
> >>>>
> >>>> Cc: stable@vger.kernel.org
> >>>> Fixes: 2695eae1f6d3 ("drm/vboxvideo: Switch to generic fbdev emulation")
> >>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> >>>> ---
> >>>>    drivers/gpu/drm/vboxvideo/vbox_drv.c | 4 ++++
> >>>>    1 file changed, 4 insertions(+)
> >>>>
> >>>> diff --git a/drivers/gpu/drm/vboxvideo/vbox_drv.c b/drivers/gpu/drm/vboxvideo/vbox_drv.c
> >>>> index 8512d970a09f..261255085918 100644
> >>>> --- a/drivers/gpu/drm/vboxvideo/vbox_drv.c
> >>>> +++ b/drivers/gpu/drm/vboxvideo/vbox_drv.c
> >>>> @@ -76,6 +76,10 @@ static int vbox_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> >>>>       if (ret)
> >>>>               goto err_mode_fini;
> >>>>
> >>>> +    ret = drm_fb_helper_remove_conflicting_pci_framebuffers(pdev, "vboxvideodrmfb");
> >>>> +    if (ret)
> >>>> +            goto err_irq_fini;
> >>>
> >>> To avoid transient issues this should be done as early as possible,
> >>> definitely before the drm driver starts to touch the "hw".>
> >>
> >> Ok will fix and then push this to drm-misc-next-fixes, thank you.
> >>
> >>> With that
> >>>
> >>> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> >>>
> >>> I do wonder though why the automatic removal of conflicting framebuffers
> >>> doesn't work, fbdev should already do that from register_framebuffer(),
> >>> which is called somewhere in drm_fbdev_generic_setup (after a few layers).
> >>>
> >>> Did you check why the two framebuffers don't conflict, and why the uefi
> >>> one doesn't get thrown out?
> >>
> >> I did not check, I was not aware that this check was already happening
> >> in register_framebuffer(). So I just checked and the reason why this
> >> is not working is because the fbdev emulation done by drm_fbdev_generic_setup
> >> does not fill in fb_info.apertures->ranges[0] .
> >>
> >> So fb_info.apertures->ranges[0].base is left as 0 which does not match
> >> with the registered efifb's aperture.
> >>
> >> We could try to fix this, but that is not entirely trivial, we would
> >> need to pass the pci_dev pointer down into drm_fb_helper_alloc_fbi()
> >> then and then like remove_conflicting_pci_framebuffers() does add
> >> apertures for all IORESOURCE_MEM PCI bars, but that would conflict
> >> with drivers which do rely on drm_fb_helper_alloc_fbi() currently
> >> allocating one empty aperture and then actually fill that itself...
> >
> > You don't need the pci device, because resources are attached to the
> > struct device directly. So you could just go through all
> > IORESOURCE_MEM ranges, and add them. And the struct device we always
> > have through drm_device->dev. This idea just crossed my mind since you
> > brought up IORESOURCE_MEM, might be good to try that out instead of
> > having to litter all drivers with explicit removal calls. The explicit
> > removal is really only for races (vga hw tends to blow up if 2 drivers
> > touch it, stuff like that), or when there's resources conflicts. Can
> > you try to look into that?
>
> Interesting idea, but I'm afraid that my plate is quite full with a lot of
> more urgent things atm, so I really do not have time for this, sorry.

Hm can you capture this idea in a todo then instead? I don't really
like the idea of everyone having to add bogus
remove_conflicting_framebuffer calls just because the generic fbdev
helper falls short of expectations. Kinda not happy to land the
vboxvideo patch since it's just a hack to work around a helper bug.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
