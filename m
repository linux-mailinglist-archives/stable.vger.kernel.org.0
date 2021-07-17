Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1FC63CC6A9
	for <lists+stable@lfdr.de>; Sun, 18 Jul 2021 00:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhGQWgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 18:36:31 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:34530 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhGQWgb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Jul 2021 18:36:31 -0400
Received: by mail-pf1-f174.google.com with SMTP id o201so12643242pfd.1;
        Sat, 17 Jul 2021 15:33:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=leiLcAGlRO9EctZ5GZcN4ZTz5wyDhsmWRqazNx7hX4U=;
        b=JzxdoTYFFD1sr7dGnniqB26DzsYqPGCwU0GZ25XNr/uL/+6J6Q3rINGYnKq8AdFQoa
         xfTnFv3CmDZMIm64DapYADdTyP8fNL0TLwFX8Xqrwu/Ifg2x+OSl4nvjxcTAE9QhGIrK
         EbTgllJ5VvyOHHwDnJ6zzxLeNXPK/9XYi8E+WDWS2njvG+A6TMzv8+DN1UxbZbYiMoco
         1PMeVSbk4O4AdH+QrclDIXN6ilOdlFwbuWDXhBW4pAtMArJXME68jRikll3kar/FzG0D
         gZ66LQ2BdK5ouvdM2t1uhofRJ0k5Xfwnk+GNujrGU66+05tS+Yd7tI3bp8r4XTLr/fRh
         9+1A==
X-Gm-Message-State: AOAM531o0vzmwo5EqJIUcpMDt9Ohhva8IGJO44dLxFZwM1dR5bUTgwsA
        Qhlc2Vc0oPQYO0gKd3boMkI=
X-Google-Smtp-Source: ABdhPJxbzuBLAjmXziU93pXHGW+ZR8OBrTOPyaFL8kbMl15cfbNWYEWLNkRW8AtVYWzywHQ59BLUiQ==
X-Received: by 2002:aa7:98c6:0:b029:32e:608b:7e86 with SMTP id e6-20020aa798c60000b029032e608b7e86mr17212940pfm.68.1626561213778;
        Sat, 17 Jul 2021 15:33:33 -0700 (PDT)
Received: from localhost ([24.4.24.239])
        by smtp.gmail.com with ESMTPSA id x14sm11475306pjc.4.2021.07.17.15.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 15:33:33 -0700 (PDT)
Date:   Sat, 17 Jul 2021 15:33:32 -0700
From:   Moritz Fischer <mdf@kernel.org>
To:     Justin Forbes <jmforbes@linuxtx.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Moritz Fischer <mdf@kernel.org>
Subject: Re: [PATCH 5.13 024/800] usb: renesas-xhci: Fix handling of unknown
 ROM state
Message-ID: <YPNavEl340mxcNVd@epycbox.lan>
References: <20210712060912.995381202@linuxfoundation.org>
 <20210712060916.499546891@linuxfoundation.org>
 <CAFxkdApAJ2i_Bg6Ghd38Tw9Lz5s6FTKP=3-+pSWM-cDT427i2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFxkdApAJ2i_Bg6Ghd38Tw9Lz5s6FTKP=3-+pSWM-cDT427i2g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Justin,

On Sat, Jul 17, 2021 at 08:39:19AM -0500, Justin Forbes wrote:
> On Mon, Jul 12, 2021 at 2:31 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Moritz Fischer <mdf@kernel.org>
> >
> > commit d143825baf15f204dac60acdf95e428182aa3374 upstream.
> >
> > The ROM load sometimes seems to return an unknown status
> > (RENESAS_ROM_STATUS_NO_RESULT) instead of success / fail.
> >
> > If the ROM load indeed failed this leads to failures when trying to
> > communicate with the controller later on.
> >
> > Attempt to load firmware using RAM load in those cases.
> >
> > Fixes: 2478be82de44 ("usb: renesas-xhci: Add ROM loader for uPD720201")
> > Cc: stable@vger.kernel.org
> > Cc: Mathias Nyman <mathias.nyman@intel.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Vinod Koul <vkoul@kernel.org>
> > Tested-by: Vinod Koul <vkoul@kernel.org>
> > Reviewed-by: Vinod Koul <vkoul@kernel.org>
> > Signed-off-by: Moritz Fischer <mdf@kernel.org>
> > Link: https://lore.kernel.org/r/20210615153758.253572-1-mdf@kernel.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> 
> After sending out 5.12.17 for testing, we had a user complain that all
> of their USB devices disappeared with the error:
> 
> Jul 15 23:18:53 kernel: xhci_hcd 0000:04:00.0: Direct firmware load
> for renesas_usb_fw.mem failed with error -2
> Jul 15 23:18:53 kernel: xhci_hcd 0000:04:00.0: request_firmware failed: -2
> Jul 15 23:18:53 kernel: xhci_hcd: probe of 0000:04:00.0 failed with error -2

This looks like it fails finding the actual firmware file (ENOENT). Any
chance you could give this a whirl on top of the original patch?

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 18c2bbddf080..cde8f6f1ec5d 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -379,7 +379,11 @@ static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
        driver_data = (struct xhci_driver_data *)id->driver_data;
        if (driver_data && driver_data->quirks & XHCI_RENESAS_FW_QUIRK) {
                retval = renesas_xhci_check_request_fw(dev, id);
-               if (retval)
+               /*
+                * If firmware wasn't found there's still a chance this might work without
+                * loading firmware on some systems, so let's try at least.
+                */
+               if (retval && retval != -ENOENT)
                        return retval;
        }


Thanks,
Moritz
