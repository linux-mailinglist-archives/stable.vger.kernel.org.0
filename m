Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1463CF40B
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 07:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238152AbhGTE6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 00:58:06 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:44773 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237648AbhGTE6D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 00:58:03 -0400
Received: by mail-pj1-f41.google.com with SMTP id p4-20020a17090a9304b029016f3020d867so1816275pjo.3;
        Mon, 19 Jul 2021 22:38:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H6FMY36ifoVcSW+eRrx8urOcqQvcESIiNUaCo0mYNkk=;
        b=rgAJmyzEzCvy4zhFESu3jOuAc3d6SMFB0kJnSvNpgG1QV6jacx/9WlePrBh2berJcC
         EPyvXEWG+rbXGlsSmi7CvsaS5RbALvgVQEWfacbvdgWwwZGqIIP9SIdr+fhIL5OTOBCi
         fhbbBkWAhNlAKRt+bAVwU0fcLbQKLeStQ3k/SoJ94LGe6S9Xk2QHwYPHPQEX8xbdvXf7
         iTG0MRbHro2uk5x+3VZSw6IrCoVdLLUlhqG29aKt7N+HHzB4ewagVtqP3/vr/+f0PlCJ
         RnuMX7WE65HP9BJraDWQnznFtp/D4k59X7BO1uBOideEUCVW5t26n5JrmLTjPZxh8/xz
         uX7w==
X-Gm-Message-State: AOAM531gn1Fujbct7iumTJEgUrZpW19fzbF257vWA91JIV+gpdn/Khdl
        wH4mM8SYEq7waQnmryC7DIc=
X-Google-Smtp-Source: ABdhPJwYgAyPPkoCWeF1bvYsckKE51nqjFwi21AE8/C4xiCNJZLa2ylcJzslBc4P4xyB78pVapKS/g==
X-Received: by 2002:a17:902:684a:b029:12b:8d3e:68dc with SMTP id f10-20020a170902684ab029012b8d3e68dcmr6177240pln.79.1626759521913;
        Mon, 19 Jul 2021 22:38:41 -0700 (PDT)
Received: from localhost ([2601:647:5b00:6f70:be34:681b:b1e9:776f])
        by smtp.gmail.com with ESMTPSA id b9sm20591709pfm.124.2021.07.19.22.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 22:38:41 -0700 (PDT)
Date:   Mon, 19 Jul 2021 22:38:40 -0700
From:   Moritz Fischer <mdf@kernel.org>
To:     Justin Forbes <jmforbes@linuxtx.org>
Cc:     Moritz Fischer <mdf@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH 5.13 024/800] usb: renesas-xhci: Fix handling of unknown
 ROM state
Message-ID: <YPZhYAbzdQvZqfV+@epycbox.lan>
References: <20210712060912.995381202@linuxfoundation.org>
 <20210712060916.499546891@linuxfoundation.org>
 <CAFxkdApAJ2i_Bg6Ghd38Tw9Lz5s6FTKP=3-+pSWM-cDT427i2g@mail.gmail.com>
 <YPNavEl340mxcNVd@epycbox.lan>
 <CAFxkdApGaw30O2HEkTA8r6g4_dLZEbykVjnnDnfTiX=3hVQwvw@mail.gmail.com>
 <CAFxkdAqd69oXdhUBEmMRvmfuk2YpWS7qsDKLjUEAEg8rhQkTyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFxkdAqd69oXdhUBEmMRvmfuk2YpWS7qsDKLjUEAEg8rhQkTyQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 19, 2021 at 09:57:00PM -0500, Justin Forbes wrote:
> On Mon, Jul 19, 2021 at 10:33 AM Justin Forbes <jmforbes@linuxtx.org> wrote:
> >
> > On Sat, Jul 17, 2021 at 5:33 PM Moritz Fischer <mdf@kernel.org> wrote:
> > >
> > > Justin,
> > >
> > > On Sat, Jul 17, 2021 at 08:39:19AM -0500, Justin Forbes wrote:
> > > > On Mon, Jul 12, 2021 at 2:31 AM Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > From: Moritz Fischer <mdf@kernel.org>
> > > > >
> > > > > commit d143825baf15f204dac60acdf95e428182aa3374 upstream.
> > > > >
> > > > > The ROM load sometimes seems to return an unknown status
> > > > > (RENESAS_ROM_STATUS_NO_RESULT) instead of success / fail.
> > > > >
> > > > > If the ROM load indeed failed this leads to failures when trying to
> > > > > communicate with the controller later on.
> > > > >
> > > > > Attempt to load firmware using RAM load in those cases.
> > > > >
> > > > > Fixes: 2478be82de44 ("usb: renesas-xhci: Add ROM loader for uPD720201")
> > > > > Cc: stable@vger.kernel.org
> > > > > Cc: Mathias Nyman <mathias.nyman@intel.com>
> > > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > Cc: Vinod Koul <vkoul@kernel.org>
> > > > > Tested-by: Vinod Koul <vkoul@kernel.org>
> > > > > Reviewed-by: Vinod Koul <vkoul@kernel.org>
> > > > > Signed-off-by: Moritz Fischer <mdf@kernel.org>
> > > > > Link: https://lore.kernel.org/r/20210615153758.253572-1-mdf@kernel.org
> > > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > >
> > > >
> > > > After sending out 5.12.17 for testing, we had a user complain that all
> > > > of their USB devices disappeared with the error:
> > > >
> > > > Jul 15 23:18:53 kernel: xhci_hcd 0000:04:00.0: Direct firmware load
> > > > for renesas_usb_fw.mem failed with error -2
> > > > Jul 15 23:18:53 kernel: xhci_hcd 0000:04:00.0: request_firmware failed: -2
> > > > Jul 15 23:18:53 kernel: xhci_hcd: probe of 0000:04:00.0 failed with error -2
> > >
> > > This looks like it fails finding the actual firmware file (ENOENT). Any
> > > chance you could give this a whirl on top of the original patch?
> > >
> >
> > Sure. test kernel building now, will let you know when the user reports back.
> 
> The original user reports success with this patch on top of the original patch.

That's good news I guess.

After reading through the datasheet once more I'm even more convinced
that the original code with the early return in
renesas_check_fw_running() is *very* shady.

There are three statuses to be investigated
- FW load status (fw_state)
- ROM download status (rom_status)
- Firmware version as reported by chip

Currently there the code takes an early return if the latter says the
external ROM is there and the 'write firmware to external ROM'
worked out, which I think shouldn't be happening, since it doesn't tell
us anything about the firmware state at all. In fact I think the early
return should not exist at all (a path that the original patch made more
likely to happen).

The FW load status indicates whether firmware has been runtime loaded
and returns 'No result yet' in your case, too I suspect, which *might*
happen if the chip configured itself from external ROM?

So the part that is unclear to me somewhat is should we use either of
them at all in trying to determine whether we should load firmware?

Maybe what we should do is:
- Attempt to request_firmware()
- If fail -> proceed and hope for the best
- If success
  - Compare the firmware file version with the version reported by the
    controller
  - If they don't match, load firmware, otherwise leave it alone?

- Moritz


> 
> Justin
> 
> >
> > Justin
> >
> > > diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
> > > index 18c2bbddf080..cde8f6f1ec5d 100644
> > > --- a/drivers/usb/host/xhci-pci.c
> > > +++ b/drivers/usb/host/xhci-pci.c
> > > @@ -379,7 +379,11 @@ static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
> > >         driver_data = (struct xhci_driver_data *)id->driver_data;
> > >         if (driver_data && driver_data->quirks & XHCI_RENESAS_FW_QUIRK) {
> > >                 retval = renesas_xhci_check_request_fw(dev, id);
> > > -               if (retval)
> > > +               /*
> > > +                * If firmware wasn't found there's still a chance this might work without
> > > +                * loading firmware on some systems, so let's try at least.
> > > +                */
> > > +               if (retval && retval != -ENOENT)
> > >                         return retval;
> > >         }
> > >
> > >
> > > Thanks,
> > > Moritz
