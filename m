Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2C93CDF11
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345007AbhGSPHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345877AbhGSPFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 11:05:05 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23242C08EBB3
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 08:00:32 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id v1so24502167edt.6
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 08:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SFohRrC/J6yvJekNzc8d5a/rCXsepe2YSJfKC79IXAc=;
        b=EGWPO34lxZS/UR7cBQkRiPuptCLTxX4xTeh/NVtC5Cxjcy+Klfi83m4iS1j46P8n5q
         GwnV27ibn8k6pIReRaX6tvQzUZ7XKvPDuzgS5P5i8yTvXTMvkl/BW/UzKWQI+/tiAtIq
         PUG6SfjmAOu9Fttb60JW3fmvDY/mYtiY6xn9o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SFohRrC/J6yvJekNzc8d5a/rCXsepe2YSJfKC79IXAc=;
        b=qXQKNcJm8N54ZODriHpeKjKhZ5baUMdC5qHoKDiwUvozL7yWcOFAlcfHTQMiD2w4Wc
         6b9svdUy6t5/Ez5Dwu1yuBfJv4YyLwK/2cvrG6o/0KHSlJOKUSShpx8KEqzYdw0uVmAg
         y5azUPcPHgeGR+AQwvFQZ6BXaC0LkYp+068wiYNsHhq7Xh0SSbEmxaZNIgmC7qS5C5Xf
         jXQEy0zqMNuAWe2/hTSqjZdcRBb7xQ6Gi7vd51xabGEvme6/FBvXUpJF6wxaiFoikO66
         sui/R0KgJJAz4uUegnMimnMhHmXTcOGnpcGPmbbXQQOWgB3cyKnkT2wFwPkp7oStbaBm
         ERiw==
X-Gm-Message-State: AOAM532Zyp24y5vhYkmTIvfXgv52d5iWDvGOTPJmw3NSlegFZANI3qQ+
        ZaZVVL6Ex7K20Q82mxXyyFYtoYCTCJnu1QeXKRY0Og==
X-Google-Smtp-Source: ABdhPJzFxSo/D4kyepQRqCtyMUtqcVwoO2Cj10WkZ1Hg9vbFtTWR5fcQDRuQ6zqRqtBTD2CrJEYx/HZEMQtnmXc72jE=
X-Received: by 2002:a50:9b06:: with SMTP id o6mr35753968edi.284.1626708549000;
 Mon, 19 Jul 2021 08:29:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210712060912.995381202@linuxfoundation.org> <20210712060916.499546891@linuxfoundation.org>
 <CAFxkdApAJ2i_Bg6Ghd38Tw9Lz5s6FTKP=3-+pSWM-cDT427i2g@mail.gmail.com>
 <YPMUu+kNu0GZeQQ1@kroah.com> <YPM0IE8U7oDSVbvd@epycbox.lan>
In-Reply-To: <YPM0IE8U7oDSVbvd@epycbox.lan>
From:   Justin Forbes <jmforbes@linuxtx.org>
Date:   Mon, 19 Jul 2021 10:28:57 -0500
Message-ID: <CAFxkdAr7KHgx3etpia8_OdFySP-1HQVW=2LL6Vu=UO4Jh1dW5w@mail.gmail.com>
Subject: Re: [PATCH 5.13 024/800] usb: renesas-xhci: Fix handling of unknown
 ROM state
To:     Moritz Fischer <mdf@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Vinod Koul <vkoul@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 17, 2021 at 2:48 PM Moritz Fischer <mdf@kernel.org> wrote:
>
> On Sat, Jul 17, 2021 at 07:34:51PM +0200, Greg Kroah-Hartman wrote:
> > On Sat, Jul 17, 2021 at 08:39:19AM -0500, Justin Forbes wrote:
> > > On Mon, Jul 12, 2021 at 2:31 AM Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > From: Moritz Fischer <mdf@kernel.org>
> > > >
> > > > commit d143825baf15f204dac60acdf95e428182aa3374 upstream.
> > > >
> > > > The ROM load sometimes seems to return an unknown status
> > > > (RENESAS_ROM_STATUS_NO_RESULT) instead of success / fail.
> > > >
> > > > If the ROM load indeed failed this leads to failures when trying to
> > > > communicate with the controller later on.
> > > >
> > > > Attempt to load firmware using RAM load in those cases.
> > > >
> > > > Fixes: 2478be82de44 ("usb: renesas-xhci: Add ROM loader for uPD720201")
> > > > Cc: stable@vger.kernel.org
> > > > Cc: Mathias Nyman <mathias.nyman@intel.com>
> > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Cc: Vinod Koul <vkoul@kernel.org>
> > > > Tested-by: Vinod Koul <vkoul@kernel.org>
> > > > Reviewed-by: Vinod Koul <vkoul@kernel.org>
> > > > Signed-off-by: Moritz Fischer <mdf@kernel.org>
> > > > Link: https://lore.kernel.org/r/20210615153758.253572-1-mdf@kernel.org
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > >
> > >
> > > After sending out 5.12.17 for testing, we had a user complain that all
> > > of their USB devices disappeared with the error:
> > >
> > > Jul 15 23:18:53 kernel: xhci_hcd 0000:04:00.0: Direct firmware load
> > > for renesas_usb_fw.mem failed with error -2
> > > Jul 15 23:18:53 kernel: xhci_hcd 0000:04:00.0: request_firmware failed: -2
> > > Jul 15 23:18:53 kernel: xhci_hcd: probe of 0000:04:00.0 failed with error -2
> > >
> > > After first assuming that something was missing in the backport to
> > > 5.12, I had the user try 5.13.2, and then 5.14-rc1. Both of those
> > > failed in the same way, so it is not working in the current Linus tree
> > > either.  Reverting this patch fixed the issue.
> >
> > Can you send a revert for this so I can get that into Linus's tree and
> > then all stable releases as well?
> >
> > thanks,
> >
> > greg k-h
>
> Me or Justin? I can do it. This is annoying my system doesn't work
> without this :-(
>
> Back to the drawing board I guess ...
>
> Justin, any idea if your customer had the eeprom populated and
> programmed or not, just as additional datapoint.

I am not sure, but I did have another user chime in on the bug saying
the test kernel with the revert fixed their system as well. It was a
T14s AMD
Generation_1. The original reporter had a ASUS System Product
Name/PRIME H370M-PLUS, BIOS 2801 04/13/2021.

Justin

> - Moritz
