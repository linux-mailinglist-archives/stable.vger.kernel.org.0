Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B843CC5F0
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 21:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234719AbhGQTvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 15:51:51 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:34669 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234296AbhGQTvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Jul 2021 15:51:50 -0400
Received: by mail-pf1-f175.google.com with SMTP id o201so12354698pfd.1;
        Sat, 17 Jul 2021 12:48:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XzqBX+hros9NGU/wG4gITs49J7cStdDidaUInx9C9QA=;
        b=X+GjG4y468SyHYR1GU39g3wCulnk7J2SFTZNiosDGWcxWOTO0MYwpCobrc8VCTn11/
         JcImSOVoBLmJOzsatnf44vB2ZtrpNab/njzWHopgkqoLRN+0tPfHv/30CNYjFL+SQ8gN
         uA16kJwYxJ3bnGB1cio7sifkqaY/qImJxsMX0skKRmJsgIaw//kK+MqvzHhVrAV4xL33
         8jwWY5aOpFpXPs6CohGWhwRzSgfspM5Wa4r9ciBabSGKNUXRIH64Jp2MXJxwdnZ8UYw3
         k5n1YFBq+jiTFEuwHuNh2ualPfWgFNbuGSED/B80kNa4+WGDvwtMAVWXzfUeCyM98ssO
         z/7A==
X-Gm-Message-State: AOAM531CwBT8i6U/7qSn72AueWYb6k0OLMCI9/Ajix0RnhRQGsqz1/XG
        6FlkuZQYPxfwMeumNUWXDvY=
X-Google-Smtp-Source: ABdhPJybPMeS0UYdluDgqim9MHVrNXhvjV6ol0mK8qMV0fxClAyA+iqrKL8tfIPt2uGqzKjQe+beYA==
X-Received: by 2002:a63:4f62:: with SMTP id p34mr16507883pgl.283.1626551332853;
        Sat, 17 Jul 2021 12:48:52 -0700 (PDT)
Received: from localhost ([24.4.24.239])
        by smtp.gmail.com with ESMTPSA id w123sm14290136pfb.109.2021.07.17.12.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 12:48:51 -0700 (PDT)
Date:   Sat, 17 Jul 2021 12:48:48 -0700
From:   Moritz Fischer <mdf@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Justin Forbes <jmforbes@linuxtx.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Moritz Fischer <mdf@kernel.org>
Subject: Re: [PATCH 5.13 024/800] usb: renesas-xhci: Fix handling of unknown
 ROM state
Message-ID: <YPM0IE8U7oDSVbvd@epycbox.lan>
References: <20210712060912.995381202@linuxfoundation.org>
 <20210712060916.499546891@linuxfoundation.org>
 <CAFxkdApAJ2i_Bg6Ghd38Tw9Lz5s6FTKP=3-+pSWM-cDT427i2g@mail.gmail.com>
 <YPMUu+kNu0GZeQQ1@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPMUu+kNu0GZeQQ1@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 17, 2021 at 07:34:51PM +0200, Greg Kroah-Hartman wrote:
> On Sat, Jul 17, 2021 at 08:39:19AM -0500, Justin Forbes wrote:
> > On Mon, Jul 12, 2021 at 2:31 AM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > From: Moritz Fischer <mdf@kernel.org>
> > >
> > > commit d143825baf15f204dac60acdf95e428182aa3374 upstream.
> > >
> > > The ROM load sometimes seems to return an unknown status
> > > (RENESAS_ROM_STATUS_NO_RESULT) instead of success / fail.
> > >
> > > If the ROM load indeed failed this leads to failures when trying to
> > > communicate with the controller later on.
> > >
> > > Attempt to load firmware using RAM load in those cases.
> > >
> > > Fixes: 2478be82de44 ("usb: renesas-xhci: Add ROM loader for uPD720201")
> > > Cc: stable@vger.kernel.org
> > > Cc: Mathias Nyman <mathias.nyman@intel.com>
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Cc: Vinod Koul <vkoul@kernel.org>
> > > Tested-by: Vinod Koul <vkoul@kernel.org>
> > > Reviewed-by: Vinod Koul <vkoul@kernel.org>
> > > Signed-off-by: Moritz Fischer <mdf@kernel.org>
> > > Link: https://lore.kernel.org/r/20210615153758.253572-1-mdf@kernel.org
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >
> > 
> > After sending out 5.12.17 for testing, we had a user complain that all
> > of their USB devices disappeared with the error:
> > 
> > Jul 15 23:18:53 kernel: xhci_hcd 0000:04:00.0: Direct firmware load
> > for renesas_usb_fw.mem failed with error -2
> > Jul 15 23:18:53 kernel: xhci_hcd 0000:04:00.0: request_firmware failed: -2
> > Jul 15 23:18:53 kernel: xhci_hcd: probe of 0000:04:00.0 failed with error -2
> > 
> > After first assuming that something was missing in the backport to
> > 5.12, I had the user try 5.13.2, and then 5.14-rc1. Both of those
> > failed in the same way, so it is not working in the current Linus tree
> > either.  Reverting this patch fixed the issue.
> 
> Can you send a revert for this so I can get that into Linus's tree and
> then all stable releases as well?
> 
> thanks,
> 
> greg k-h

Me or Justin? I can do it. This is annoying my system doesn't work
without this :-(

Back to the drawing board I guess ...

Justin, any idea if your customer had the eeprom populated and
programmed or not, just as additional datapoint.

- Moritz
