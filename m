Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDAB3CDFAE
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344515AbhGSPLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343880AbhGSPKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 11:10:06 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B10AC00666A
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 08:05:54 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id h8so24580431eds.4
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 08:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MoJ3qq8q/idAx9bOHrmP9SfK/Oa7YrxiYtYS0zrlTPA=;
        b=iOTXZJ0SWidcccQuoZ4bVKQDMqg3fXBDavx11MQN5HK+++UR5O6S1dDw0SkusBMttg
         fhU39zT/5EGLkRsQx+AN0zmPQoJl8TH02jn0+Omk77NJMPoVvs/njS1Liwp5an8LehJ7
         7IgI25/UnFsPNbChj1KboOmwFl3fZSgj6Ave4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MoJ3qq8q/idAx9bOHrmP9SfK/Oa7YrxiYtYS0zrlTPA=;
        b=A3PMFm9AD0YnaDKk78ymFXtjMW6UGvYrICZWf4RRii3ZeZCg8qRx1XeJHKV1UvX5Qc
         iw3EPcBKUKTH4vZuGDibiKOBuPFUdIDHFYY6dUVMxP0OQBae6shY68XnmVADg/vJvVw/
         m8mNXiPVo0Oveybb7FUG5IoWEl17JymhMMfcY8RDN5cOTiNNPlOJOC7y+/0c7oS+JIry
         4GBvMlcTzrPU/zroEcM3j5IoMy33EViwWhRAfjSr/2hFW/GeuNH1XPQPyAFnGgJvh3/b
         g07VeQvY+JS+wg7FSm7W3QRig1+V4mX7vasvzncMsa77PSbGQCYL0nxj6wq8qRyN/4lw
         FtcA==
X-Gm-Message-State: AOAM5302UNU9SA4qzax99QdpcEnyFmOMRtQatXAbaHmJUTXrWnrWdR3Z
        dIe3a1yP+VTfsWMENX9TCW7DZBUUQTcbiUoQAWJrOA==
X-Google-Smtp-Source: ABdhPJzkHgzAzX6mqgNxzQLAsuAOEUo/GiGdoITemQq27T/JV0/C1gLGJbRqYpBUH7roxgVhmPjMEDvPrsctV8AIUOY=
X-Received: by 2002:a05:6402:c13:: with SMTP id co19mr34941490edb.64.1626708846512;
 Mon, 19 Jul 2021 08:34:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210712060912.995381202@linuxfoundation.org> <20210712060916.499546891@linuxfoundation.org>
 <CAFxkdApAJ2i_Bg6Ghd38Tw9Lz5s6FTKP=3-+pSWM-cDT427i2g@mail.gmail.com> <YPNavEl340mxcNVd@epycbox.lan>
In-Reply-To: <YPNavEl340mxcNVd@epycbox.lan>
From:   Justin Forbes <jmforbes@linuxtx.org>
Date:   Mon, 19 Jul 2021 10:33:55 -0500
Message-ID: <CAFxkdApGaw30O2HEkTA8r6g4_dLZEbykVjnnDnfTiX=3hVQwvw@mail.gmail.com>
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

On Sat, Jul 17, 2021 at 5:33 PM Moritz Fischer <mdf@kernel.org> wrote:
>
> Justin,
>
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
>
> This looks like it fails finding the actual firmware file (ENOENT). Any
> chance you could give this a whirl on top of the original patch?
>

Sure. test kernel building now, will let you know when the user reports back.

Justin

> diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
> index 18c2bbddf080..cde8f6f1ec5d 100644
> --- a/drivers/usb/host/xhci-pci.c
> +++ b/drivers/usb/host/xhci-pci.c
> @@ -379,7 +379,11 @@ static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
>         driver_data = (struct xhci_driver_data *)id->driver_data;
>         if (driver_data && driver_data->quirks & XHCI_RENESAS_FW_QUIRK) {
>                 retval = renesas_xhci_check_request_fw(dev, id);
> -               if (retval)
> +               /*
> +                * If firmware wasn't found there's still a chance this might work without
> +                * loading firmware on some systems, so let's try at least.
> +                */
> +               if (retval && retval != -ENOENT)
>                         return retval;
>         }
>
>
> Thanks,
> Moritz
