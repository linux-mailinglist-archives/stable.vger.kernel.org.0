Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79D6B193FE9
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 14:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgCZNjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 09:39:15 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:40150 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgCZNjP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 09:39:15 -0400
Received: by mail-ot1-f68.google.com with SMTP id e19so5789999otj.7
        for <stable@vger.kernel.org>; Thu, 26 Mar 2020 06:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4wFukWW15LjhcYxnyyQgEVJMiluS1D1UebU3PqciR6c=;
        b=Z9bOoga5Dsf9B7qM+H9BYluIYS9CJlkJidwW66pTirx8dImcAZnujcY18qnMs5QESk
         EMUdZvvpqatKOBCqVfo+Dmk1+HgTfa4uJdTF2gs3pSl0qrF+VNRPp5A6cd2ro1qrUqeb
         6klegKIlgdYuooORzPro8zsCjwJnPm2bzuWZ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4wFukWW15LjhcYxnyyQgEVJMiluS1D1UebU3PqciR6c=;
        b=YilLKYZpvCrouyo0BaWtW3JfOUqcrT5E2MxwgUbUiWppWnyCYL9NmoX2FtbSH61y5I
         NsIEBzUmu9iF0uttC1UawKy7jEDAiYXinWEWvZOIvdiCJ/HFmPAJcSYuU4JzQQJ+OkCi
         9DLIale22t2BTuHjDBkbwapTKzrVkhajwdGqEKIh6O/Qns4P2HFoNOulUSpeZ8Yt/Ypp
         PlsmOmQYAxla2JE/EgnhX+oHzM/vJOrAzbB+mnJOBdmOEU8TGZ2XwTobhxn9lrc1GI3J
         B8gV3TPBrcdFoiSbkeneMWPtH+ySdoSNex6B4aSPoKUv4O5na78pd6SXdU/JJJdbghbU
         MwSA==
X-Gm-Message-State: ANhLgQ2UQuLtYePmJ9amkak23GBWKrf251vdq5mTuhZnuzjQ5N8HOJTG
        Vvr/tFp9+KRAaCfyY4+1q5SrMg58bpCccP6XAwBpag==
X-Google-Smtp-Source: ADFU+vu2s+1yMhU4GRNQWJZu0otaBAkns9ncxkcB7AdTHzNGwa+65xqc9vvC9AsqVjVakENzquklJG5zu1FXEHDe2/o=
X-Received: by 2002:a9d:554d:: with SMTP id h13mr6198795oti.303.1585229954600;
 Thu, 26 Mar 2020 06:39:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200325144310.36779-1-hdegoede@redhat.com> <20200326112959.GZ2363188@phenom.ffwll.local>
 <8b9d940d-b236-062d-4ac3-c7462090066f@redhat.com>
In-Reply-To: <8b9d940d-b236-062d-4ac3-c7462090066f@redhat.com>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Thu, 26 Mar 2020 14:39:03 +0100
Message-ID: <CAKMK7uHA+uefrWVR42wTss65mq_D4q5odfePm6uj399emkWx8w@mail.gmail.com>
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

On Thu, Mar 26, 2020 at 2:18 PM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Hi,
>
> On 3/26/20 12:29 PM, Daniel Vetter wrote:
> > On Wed, Mar 25, 2020 at 03:43:10PM +0100, Hans de Goede wrote:
> >> The vboxvideo driver is missing a call to remove conflicting framebuffers.
> >>
> >> Surprisingly, when using legacy BIOS booting this does not really cause
> >> any issues. But when using UEFI to boot the VM then plymouth will draw
> >> on both the efifb /dev/fb0 and /dev/drm/card0 (which has registered
> >> /dev/fb1 as fbdev emulation).
> >>
> >> VirtualBox will actual display the output of both devices (I guess it is
> >> showing whatever was drawn last), this causes weird artifacts because of
> >> pitch issues in the efifb when the VM window is not sized at 1024x768
> >> (the window will resize to its last size once the vboxvideo driver loads,
> >> changing the pitch).
> >>
> >> Adding the missing drm_fb_helper_remove_conflicting_pci_framebuffers()
> >> call fixes this.
> >>
> >> Cc: stable@vger.kernel.org
> >> Fixes: 2695eae1f6d3 ("drm/vboxvideo: Switch to generic fbdev emulation")
> >> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> >> ---
> >>   drivers/gpu/drm/vboxvideo/vbox_drv.c | 4 ++++
> >>   1 file changed, 4 insertions(+)
> >>
> >> diff --git a/drivers/gpu/drm/vboxvideo/vbox_drv.c b/drivers/gpu/drm/vboxvideo/vbox_drv.c
> >> index 8512d970a09f..261255085918 100644
> >> --- a/drivers/gpu/drm/vboxvideo/vbox_drv.c
> >> +++ b/drivers/gpu/drm/vboxvideo/vbox_drv.c
> >> @@ -76,6 +76,10 @@ static int vbox_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> >>      if (ret)
> >>              goto err_mode_fini;
> >>
> >> +    ret = drm_fb_helper_remove_conflicting_pci_framebuffers(pdev, "vboxvideodrmfb");
> >> +    if (ret)
> >> +            goto err_irq_fini;
> >
> > To avoid transient issues this should be done as early as possible,
> > definitely before the drm driver starts to touch the "hw".>
>
> Ok will fix and then push this to drm-misc-next-fixes, thank you.
>
> > With that
> >
> > Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> >
> > I do wonder though why the automatic removal of conflicting framebuffers
> > doesn't work, fbdev should already do that from register_framebuffer(),
> > which is called somewhere in drm_fbdev_generic_setup (after a few layers).
> >
> > Did you check why the two framebuffers don't conflict, and why the uefi
> > one doesn't get thrown out?
>
> I did not check, I was not aware that this check was already happening
> in register_framebuffer(). So I just checked and the reason why this
> is not working is because the fbdev emulation done by drm_fbdev_generic_setup
> does not fill in fb_info.apertures->ranges[0] .
>
> So fb_info.apertures->ranges[0].base is left as 0 which does not match
> with the registered efifb's aperture.
>
> We could try to fix this, but that is not entirely trivial, we would
> need to pass the pci_dev pointer down into drm_fb_helper_alloc_fbi()
> then and then like remove_conflicting_pci_framebuffers() does add
> apertures for all IORESOURCE_MEM PCI bars, but that would conflict
> with drivers which do rely on drm_fb_helper_alloc_fbi() currently
> allocating one empty aperture and then actually fill that itself...

You don't need the pci device, because resources are attached to the
struct device directly. So you could just go through all
IORESOURCE_MEM ranges, and add them. And the struct device we always
have through drm_device->dev. This idea just crossed my mind since you
brought up IORESOURCE_MEM, might be good to try that out instead of
having to litter all drivers with explicit removal calls. The explicit
removal is really only for races (vga hw tends to blow up if 2 drivers
touch it, stuff like that), or when there's resources conflicts. Can
you try to look into that?

This generic solution will still not be enough for shmem/cma based
drivers on SoC, but at least it should take care of anything that puts
the framebuffer into some kind of bar or stolen memory region. What
drivers do explicitly for those is just put in the framebuffer base
address. But iirc fbdev core does that already unconditionally.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
