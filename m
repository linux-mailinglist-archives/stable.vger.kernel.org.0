Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D262360DBA3
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbiJZG7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiJZG7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:59:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A386975493;
        Tue, 25 Oct 2022 23:59:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49AB8B82115;
        Wed, 26 Oct 2022 06:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A42C433D6;
        Wed, 26 Oct 2022 06:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666767552;
        bh=o3PteaupfkQia0zeAvo4ds5YtLe/oXcMoM1XiCUq12c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=atlTzHF8NAQoZWFpoaxe98PiZEf4+3vzFcvl8T6pqHuLU3AZa0t+TmWOTjPPXL0YX
         NKD0I+pspYEUimuTX0A5dDm3U6JXcniY+1p9z7SGABg7sd278vNLa22+iZAO1BYkpc
         uBVHr8DPpAO1zHc7ZC2aUpCTrllGWjodb+X+qJ5w=
Date:   Wed, 26 Oct 2022 09:00:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Reka Norman <rekanorman@chromium.org>
Cc:     Mathias Nyman <mathias.nyman@intel.com>, linux-usb@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/4] xhci: Add quirk to reset host back to default state
 at shutdown
Message-ID: <Y1ja9cqkD32cEO0L@kroah.com>
References: <20221024142720.4122053-1-mathias.nyman@intel.com>
 <20221024142720.4122053-3-mathias.nyman@intel.com>
 <CAEmPcwsBDwFoXOcXKXkx1aebnq3CV036Ygz_oXOobcyKoQQNnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEmPcwsBDwFoXOcXKXkx1aebnq3CV036Ygz_oXOobcyKoQQNnQ@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 26, 2022 at 05:40:10PM +1100, Reka Norman wrote:
> On Wed, Oct 26, 2022 at 5:01 PM Mathias Nyman <mathias.nyman@intel.com> wrote:
> >
> > From: Mathias Nyman <mathias.nyman@linux.intel.com>
> >
> > Systems based on Alder Lake P see significant boot time delay if
> > boot firmware tries to control usb ports in unexpected link states.
> >
> > This is seen with self-powered usb devices that survive in U3 link
> > suspended state over S5.
> >
> > A more generic solution to power off ports at shutdown was attempted in
> > commit 83810f84ecf1 ("xhci: turn off port power in shutdown")
> > but it caused regression.
> >
> > Add host specific XHCI_RESET_TO_DEFAULT quirk which will reset host and
> > ports back to default state in shutdown.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> > ---
> >  drivers/usb/host/xhci-pci.c |  4 ++++
> >  drivers/usb/host/xhci.c     | 10 ++++++++--
> >  drivers/usb/host/xhci.h     |  1 +
> >  3 files changed, 13 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
> > index 6dd3102749b7..fbbd547ba12a 100644
> > --- a/drivers/usb/host/xhci-pci.c
> > +++ b/drivers/usb/host/xhci-pci.c
> > @@ -257,6 +257,10 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
> >              pdev->device == PCI_DEVICE_ID_INTEL_DNV_XHCI))
> >                 xhci->quirks |= XHCI_MISSING_CAS;
> >
> > +       if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
> > +           pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI)
> 
> We need this quirk for ADL-N too (device ID 0x54ed). Would you mind
> updating the patch? Or I can send a separate patch if you prefer.

A separate patch is required, please submit it.

thanks,

greg k-h
