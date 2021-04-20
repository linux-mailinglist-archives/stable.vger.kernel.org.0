Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492C8365E9C
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 19:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbhDTRbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 13:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233281AbhDTRbV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Apr 2021 13:31:21 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01B4C06138B
        for <stable@vger.kernel.org>; Tue, 20 Apr 2021 10:30:49 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id b8so3306001vsu.8
        for <stable@vger.kernel.org>; Tue, 20 Apr 2021 10:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G58TS9A9yYeMoSb17LgKAY3Blh89gTINhGV0E3IpGQE=;
        b=et2aicPqhBqREOY0dNhnVIpeKAqBqwCzKXvIfzgrBt6P66Jgo/2+oQEWI+6gyewphg
         VbhS+bw5RzxtJErHdYEL/G5C3BA7I4UJ6eL5VYd1XnMcLFOCvxA4QaOg5G/PfVgj9nY0
         lHTQOuBQKTK9gNs7yf2oHGIdtU/z3Wkt5iEJk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G58TS9A9yYeMoSb17LgKAY3Blh89gTINhGV0E3IpGQE=;
        b=L/HjIejkT7kX3D+sYkI76PMFTbRGchhbiJ2jhQR4aJKB4TNBXQnNxAryDi4lVH9UN6
         okVBKDREBLt/kY4LkfBYKugn67xDKbLZWLsZnGhIVmqT0n/BcIjhKd3fTctzctzR+UHo
         FuhACpPpE6kI3cucRay+SCbzVYI6xRuzG/6HqJl2A74ZGD0aA/8Kh5DT2I0m6VYJdO7S
         wUiCtqUmaaNFFox3wkRrWeRxrHYuAEuZ4QbZkSEIdd94wl2+LKrhTK+1tREcpCjtEnYU
         EBBD9+zQbnnLWlo2TSU9kvBP7sJMIIyNFUe22n3ig3d+O7dtSvavh/VExghZr9uyz5ci
         rrAw==
X-Gm-Message-State: AOAM531x3FxQ7rdLIyzXfwlHomGUendh9yuKSyTpdOrLPXMUdxDLVLIw
        XZ0DmwFqROq/kPeX3LPY1HKmcySUGPS+CLPfmi7R9w==
X-Google-Smtp-Source: ABdhPJwXS7FiUTSlDWt0dHxHZ5655bX8hkIGHT1fDhHkNqF1vZ+XhhN+pVaz/0zkCxHB6ILJZd90Q4uuCj/sRoEmvgk=
X-Received: by 2002:a67:c98b:: with SMTP id y11mr21793715vsk.2.1618939848572;
 Tue, 20 Apr 2021 10:30:48 -0700 (PDT)
MIME-Version: 1.0
References: <1618886913-6594-1-git-send-email-bingbu.cao@intel.com> <20210420091309.GH3@paasikivi.fi.intel.com>
In-Reply-To: <20210420091309.GH3@paasikivi.fi.intel.com>
From:   Grant Grundler <grundler@chromium.org>
Date:   Tue, 20 Apr 2021 17:30:37 +0000
Message-ID: <CANEJEGunDJ-Q3vP5ABVgtQqg2vmNye6g+i7arZKxZOUdJOJaQQ@mail.gmail.com>
Subject: Re: [RESEND v2] iommu/vt-d: Use passthrough mode for the Intel IPUs
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Bingbu Cao <bingbu.cao@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        will@kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Rajat Jain <rajatja@google.com>,
        Grant Grundler <grundler@chromium.org>, tfiga@chromium.org,
        senozhatsky@chromium.org, andriy.shevchenko@linux.intel.com,
        bingbu.cao@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 20, 2021 at 11:02 AM Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
>
> Hi Bingbu,
>
> Thanks for the patch.
>
> On Tue, Apr 20, 2021 at 10:48:33AM +0800, Bingbu Cao wrote:
> > Intel IPU(Image Processing Unit) has its own (IO)MMU hardware,
> > The IPU driver allocates its own page table that is not mapped
> > via the DMA, and thus the Intel IOMMU driver blocks access giving
> > this error:
>
> The page table should be mapped to the possible IOMMU using the DMA API.

I've made the same "observation": this patch is intentionally enables
using "intel_iommu=on" (IIRC) to strictly enforce "all" DMA
transactions (except the ones we explicitly allow to identity map).

The question is: Is the security of IPU MMU the same as the system
IOMMU for the few devices behind the IPU MMU?

If not, then we (Chrome OS) require child devices to be "mapped"
twice: once in IPU MMU and again in the system IOMMU. I believe
dma_ops can be nested though I can't confidently point at examples
(IDE drivers maybe?)  This adds some latency to each DMA transaction -
decades ago I've measured roughly 5% on Itanium and PA-RISC systems
from HP. Perhaps Intel can measure this penatly on current HW they are
shipping.

If yes, then I think the IPU driver just needs to be consistent about
it's use of DMA API for it's own house keeping: Either use DMA API for
all IPU DMA operations or use it for none. This is the current plan
for Chrome OS (I didn't make this decision and wasn't party to the
discussion).

The IPU driver requires it's child devices to use DMA API and provides
the dma_ops table for those devices - this use of dma_ops is seperate
from IPU page tables and other host memory transactions to manage the
IPU MMU page tables.

CAVEAT: I'm not an expert in IPU driver - I've been reviewing Intel
IPU code for chromium.org inclusion here:
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/2787723
I have no illusions that I'm going to be an expert after staring at
28k lines of code less than 10h.

> > DMAR: DRHD: handling fault status reg 3
> > DMAR: [DMA Read] Request device [00:05.0] PASID ffffffff
> >       fault addr 76406000 [fault reason 06] PTE Read access is not set
> >
> > As IPU is not an external facing device which is not risky, so use
> > IOMMU passthrough mode for Intel IPUs.
>
> I think a factor here is that the page tables aren't accessible by the IPU
> firmware.

Correct. At least not accessible through the system IOMMU. This is why
Intel prefers the IPU to bypass the system IOMMU.

cheers,
grant

>
> >
> > Fixes: 26f5689592e2 ("media: staging/intel-ipu3: mmu: Implement driver")
> > Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
> > ---
> >  drivers/iommu/intel/iommu.c | 29 +++++++++++++++++++++++++++++
> >  1 file changed, 29 insertions(+)
> >
> > diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> > index ee0932307d64..7e2fbdae467e 100644
> > --- a/drivers/iommu/intel/iommu.c
> > +++ b/drivers/iommu/intel/iommu.c
> > @@ -55,6 +55,12 @@
> >  #define IS_GFX_DEVICE(pdev) ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY)
> >  #define IS_USB_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_SERIAL_USB)
> >  #define IS_ISA_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_BRIDGE_ISA)
> > +#define IS_INTEL_IPU(pdev) ((pdev)->vendor == PCI_VENDOR_ID_INTEL && \
> > +                         ((pdev)->device == 0x9a19 ||                \
> > +                          (pdev)->device == 0x9a39 ||                \
> > +                          (pdev)->device == 0x4e19 ||                \
> > +                          (pdev)->device == 0x465d ||                \
> > +                          (pdev)->device == 0x1919))
> >  #define IS_AZALIA(pdev) ((pdev)->vendor == 0x8086 && (pdev)->device == 0x3a3e)
> >
> >  #define IOAPIC_RANGE_START   (0xfee00000)
> > @@ -360,6 +366,7 @@ int intel_iommu_enabled = 0;
> >  EXPORT_SYMBOL_GPL(intel_iommu_enabled);
> >
> >  static int dmar_map_gfx = 1;
> > +static int dmar_map_ipu = 1;
>
> This works as long as there's only one IPU. Same for graphics. But I guess
> this can be reworked in the future if the presumption changes.
>
> >  static int dmar_forcedac;
> >  static int intel_iommu_strict;
> >  static int intel_iommu_superpage = 1;
> > @@ -368,6 +375,7 @@ static int iommu_skip_te_disable;
> >
> >  #define IDENTMAP_GFX         2
> >  #define IDENTMAP_AZALIA              4
> > +#define IDENTMAP_IPU         8
> >
> >  int intel_iommu_gfx_mapped;
> >  EXPORT_SYMBOL_GPL(intel_iommu_gfx_mapped);
> > @@ -2839,6 +2847,9 @@ static int device_def_domain_type(struct device *dev)
> >
> >               if ((iommu_identity_mapping & IDENTMAP_GFX) && IS_GFX_DEVICE(pdev))
> >                       return IOMMU_DOMAIN_IDENTITY;
> > +
> > +             if ((iommu_identity_mapping & IDENTMAP_IPU) && IS_INTEL_IPU(pdev))
> > +                     return IOMMU_DOMAIN_IDENTITY;
> >       }
> >
> >       return 0;
> > @@ -3278,6 +3289,9 @@ static int __init init_dmars(void)
> >       if (!dmar_map_gfx)
> >               iommu_identity_mapping |= IDENTMAP_GFX;
> >
> > +     if (!dmar_map_ipu)
> > +             iommu_identity_mapping |= IDENTMAP_IPU;
> > +
> >       check_tylersburg_isoch();
> >
> >       ret = si_domain_init(hw_pass_through);
> > @@ -5622,6 +5636,18 @@ static void quirk_iommu_igfx(struct pci_dev *dev)
> >       dmar_map_gfx = 0;
> >  }
> >
> > +static void quirk_iommu_ipu(struct pci_dev *dev)
> > +{
> > +     if (!IS_INTEL_IPU(dev))
> > +             return;
> > +
> > +     if (risky_device(dev))
> > +             return;
> > +
> > +     pci_info(dev, "Passthrough IOMMU for integrated Intel IPU\n");
> > +     dmar_map_ipu = 0;
> > +}
> > +
> >  /* G4x/GM45 integrated gfx dmar support is totally busted. */
> >  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2a40, quirk_iommu_igfx);
> >  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e00, quirk_iommu_igfx);
> > @@ -5657,6 +5683,9 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x1632, quirk_iommu_igfx);
> >  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x163A, quirk_iommu_igfx);
> >  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x163D, quirk_iommu_igfx);
> >
> > +/* disable IPU dmar support */
> > +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_ANY_ID, quirk_iommu_ipu);
> > +
> >  static void quirk_iommu_rwbf(struct pci_dev *dev)
> >  {
> >       if (risky_device(dev))
>
> --
> Kind regards,
>
> Sakari Ailus
