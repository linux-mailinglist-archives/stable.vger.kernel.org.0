Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9115840CEF8
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 23:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhIOVqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 17:46:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232127AbhIOVqg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 17:46:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27BFD60FDA;
        Wed, 15 Sep 2021 21:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631742317;
        bh=0tlvgoU75wbHpOdojhqsdvJcxuTlS5gMsH/qYcOFBq0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=kY03ZoBxxSpUsIKaI9UwnmWshfkjKVFQWGCPqfkrQz7+cZHS4wEMN5M+rGpfVTZOd
         9BhG2gPoZbPaxK6FVDWyOkxxpx32H/OmuGe0eaL7L+jvcaSsLBv1/Tymw70vn0Jg5w
         PxccFC/cHIoPMkUUH1UIRSLpS1VMIepxDLrKf8OfBpBf5t13BMiAqWZqMh2Wtehxp2
         EllO6vmeOCXeB3PcfkMORSS/5vJxSflYVThEHy/pLE6cEHyI0G+p5rK3Skw16vN7Go
         WZlVuszb3vhONfblUlMTKogeYmCnIS1d1CctTNuVuk8turuaROErOC4iNPQGMm8mr7
         0C5sj/+nUAygg==
Date:   Wed, 15 Sep 2021 16:45:15 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc:     "Quan, Evan" <Evan.Quan@amd.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] PCI: Create device links for AMD integrated USB xHCI and
 UCSI controllers
Message-ID: <20210915214515.GA1541334@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB51440CACA2F90377687A1C12F7DB9@BL1PR12MB5144.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 15, 2021 at 04:39:36PM +0000, Deucher, Alexander wrote:
> [Public]
> 
> > -----Original Message-----
> > From: Bjorn Helgaas <helgaas@kernel.org>
> > Sent: Tuesday, September 14, 2021 11:29 AM
> > To: Quan, Evan <Evan.Quan@amd.com>
> > Cc: linux-pci@vger.kernel.org; bhelgaas@google.com; Deucher, Alexander
> > <Alexander.Deucher@amd.com>; stable@vger.kernel.org
> > Subject: Re: [PATCH] PCI: Create device links for AMD integrated USB xHCI
> > and UCSI controllers
> > 
> > On Fri, Sep 03, 2021 at 02:33:11PM +0800, Evan Quan wrote:
> > > Latest AMD GPUs have built-in USB xHCI and UCSI controllers. Add
> > > device link support for them.
> > >
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Evan Quan <evan.quan@amd.com>
> > 
> > Applied to pci/pm for v5.16, thanks!
> 
> Any chance we can get this applied for 5.15/stable?  This fixes
> runtime pm problems on GPU boards with integrated USB.
> https://gitlab.freedesktop.org/drm/amd/-/issues/1704

Thanks for the link.  It's always nice to have a clue about what
problems a quirk fixes.

I added the link to the commit log and moved the whole thing to
for-linus for v5.15.

> Thanks,
> 
> Alex
> 
> > 
> > > ---
> > >  drivers/pci/quirks.c | 9 +++++++--
> > >  1 file changed, 7 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c index
> > > dea10d62d5b9..f0c5dd3406a1 100644
> > > --- a/drivers/pci/quirks.c
> > > +++ b/drivers/pci/quirks.c
> > > @@ -5338,7 +5338,7 @@
> > DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
> > >  			      PCI_CLASS_MULTIMEDIA_HD_AUDIO, 8,
> > quirk_gpu_hda);
> > >
> > >  /*
> > > - * Create device link for NVIDIA GPU with integrated USB xHCI Host
> > > + * Create device link for GPUs with integrated USB xHCI Host
> > >   * controller to VGA.
> > >   */
> > >  static void quirk_gpu_usb(struct pci_dev *usb) @@ -5347,9 +5347,11 @@
> > > static void quirk_gpu_usb(struct pci_dev *usb)  }
> > > DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_NVIDIA,
> > PCI_ANY_ID,
> > >  			      PCI_CLASS_SERIAL_USB, 8, quirk_gpu_usb);
> > > +DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_ATI, PCI_ANY_ID,
> > > +			      PCI_CLASS_SERIAL_USB, 8, quirk_gpu_usb);
> > >
> > >  /*
> > > - * Create device link for NVIDIA GPU with integrated Type-C UCSI
> > > controller
> > > + * Create device link for GPUs with integrated Type-C UCSI controller
> > >   * to VGA. Currently there is no class code defined for UCSI device over PCI
> > >   * so using UNKNOWN class for now and it will be updated when UCSI
> > >   * over PCI gets a class code.
> > > @@ -5362,6 +5364,9 @@ static void quirk_gpu_usb_typec_ucsi(struct
> > > pci_dev *ucsi)
> > DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
> > >  			      PCI_CLASS_SERIAL_UNKNOWN, 8,
> > >  			      quirk_gpu_usb_typec_ucsi);
> > > +DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_ATI, PCI_ANY_ID,
> > > +			      PCI_CLASS_SERIAL_UNKNOWN, 8,
> > > +			      quirk_gpu_usb_typec_ucsi);
> > >
> > >  /*
> > >   * Enable the NVIDIA GPU integrated HDA controller if the BIOS left
> > > it
> > > --
> > > 2.29.0
> > >
