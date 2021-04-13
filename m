Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED01B35DB6F
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 11:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhDMJkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 05:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229849AbhDMJkj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Apr 2021 05:40:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8C2461222;
        Tue, 13 Apr 2021 09:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618306820;
        bh=13DkOHHCScjxNEkGRoItj/TETxYwomg0ZoTIvQMDWDo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WhxElW9IMpdzxvJizUFrC8sM0X7GOSwmORglck7KYGm/WaBBQubDC6yPD7CtBRtFm
         yrUrXtKFCDo7Sc62L9IGqbCii0RtCDWAFOEDfHBnv9E/PumUD4PFT4rFVExGjZblkB
         EPonzH6iwBv7X43PCCQlc7kUIUpIYe1UzaGiws9Q=
Date:   Tue, 13 Apr 2021 11:40:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Liang, Prike" <Prike.Liang@amd.com>
Cc:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "Chaitanya.Kulkarni@wdc.com" <Chaitanya.Kulkarni@wdc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>
Subject: Re: [PATCH] nvme: put some AMD PCIE downstream NVME device to simple
 suspend/resume path
Message-ID: <YHVnAdmL9yeN1Z0B@kroah.com>
References: <1618304441-12550-1-git-send-email-Prike.Liang@amd.com>
 <YHVgd+dOAGWIl3+m@kroah.com>
 <BYAPR12MB3238ECDDDE0239CF06249D4AFB4F9@BYAPR12MB3238.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR12MB3238ECDDDE0239CF06249D4AFB4F9@BYAPR12MB3238.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 13, 2021 at 09:30:13AM +0000, Liang, Prike wrote:
> [AMD Public Use]
> 
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Sent: Tuesday, April 13, 2021 5:12 PM
> > To: Liang, Prike <Prike.Liang@amd.com>
> > Cc: linux-nvme@lists.infradead.org; kbusch@kernel.org;
> > Chaitanya.Kulkarni@wdc.com; stable@vger.kernel.org; S-k, Shyam-sundar
> > <Shyam-sundar.S-k@amd.com>; Deucher, Alexander
> > <Alexander.Deucher@amd.com>
> > Subject: Re: [PATCH] nvme: put some AMD PCIE downstream NVME device to
> > simple suspend/resume path
> >
> > On Tue, Apr 13, 2021 at 05:00:41PM +0800, Prike Liang wrote:
> > > The NVME device pluged in some AMD PCIE root port will resume timeout
> > > from s2idle which caused by NVME power CFG lost in the SMU FW restore.
> > > This issue can be workaround by using PCIe power set with simple
> > > suspend/resume process path instead of APST. In the onwards ASIC will
> > > try do the NVME shutdown save and restore in the BIOS and still need
> > > PCIe power setting to resume from RTD3 for s2idle.
> > >
> > > Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> > > Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> > > Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> > > Cc: <stable@vger.kernel.org> # 5.11+
> > > ---
> > >  drivers/nvme/host/pci.c |  5 +++++
> > >  drivers/pci/quirks.c    | 10 ++++++++++
> > >  include/linux/pci.h     |  2 ++
> > >  include/linux/pci_ids.h |  1 +
> > >  4 files changed, 18 insertions(+)
> > >
> > > diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c index
> > > 6bad4d4..dd46d9e 100644
> > > --- a/drivers/nvme/host/pci.c
> > > +++ b/drivers/nvme/host/pci.c
> > > @@ -2832,6 +2832,7 @@ static bool nvme_acpi_storage_d3(struct pci_dev
> > > *dev)  {
> > >  struct acpi_device *adev;
> > >  struct pci_dev *root;
> > > +struct pci_dev *rdev;
> > >  acpi_handle handle;
> > >  acpi_status status;
> > >  u8 val;
> > > @@ -2845,6 +2846,10 @@ static bool nvme_acpi_storage_d3(struct
> > pci_dev *dev)
> > >  if (!root)
> > >  return false;
> > >
> > > +rdev = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0, 0));
> > > +if (rdev->dev_flags &
> > PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND)
> > > +return NVME_QUIRK_SIMPLE_SUSPEND;
> > > +
> > >  adev = ACPI_COMPANION(&root->dev);
> > >  if (!adev)
> > >  return false;
> > > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c index
> > > 653660e3..0b175ce 100644
> > > --- a/drivers/pci/quirks.c
> > > +++ b/drivers/pci/quirks.c
> > > @@ -312,6 +312,16 @@ static void quirk_nopciamd(struct pci_dev *dev)
> > > }
> > >  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,
> > PCI_DEVICE_ID_AMD_8151_0,quirk_nopciamd);
> > >
> > > +static void quirk_amd_nvme_fixup(struct pci_dev *dev) {
> > > +struct pci_dev *rdev;
> > > +
> > > +dev->dev_flags |= PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND;
> > > +pci_info(dev, "AMD simple suspend opt enabled\n");
> > > +
> > > +}
> > > +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,
> > PCI_DEVICE_ID_AMD_CZN_RP,
> > > +quirk_amd_nvme_fixup);
> > > +
> > >  /* Triton requires workarounds to be used by the drivers */  static
> > > void quirk_triton(struct pci_dev *dev)  { diff --git
> > > a/include/linux/pci.h b/include/linux/pci.h index 53f4904..a6e1b1b
> > > 100644
> > > --- a/include/linux/pci.h
> > > +++ b/include/linux/pci.h
> > > @@ -227,6 +227,8 @@ enum pci_dev_flags {
> > >  PCI_DEV_FLAGS_NO_FLR_RESET = (__force pci_dev_flags_t) (1 << 10),
> > >  /* Don't use Relaxed Ordering for TLPs directed at this device */
> > >  PCI_DEV_FLAGS_NO_RELAXED_ORDERING = (__force pci_dev_flags_t)
> > (1 <<
> > > 11),
> > > +/* AMD simple suspend opt quirk */
> > > +PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND = (__force
> > pci_dev_flags_t) (1
> > > +<< 12),
> > >  };
> > >
> > >  enum pci_irq_reroute_variant {
> > > diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h index
> > > d8156a5..a82443f 100644
> > > --- a/include/linux/pci_ids.h
> > > +++ b/include/linux/pci_ids.h
> > > @@ -602,6 +602,7 @@
> > >  #define PCI_DEVICE_ID_AMD_HUDSON2_SMBUS0x780b
> > >  #define PCI_DEVICE_ID_AMD_HUDSON2_IDE0x780c
> > >  #define PCI_DEVICE_ID_AMD_KERNCZ_SMBUS  0x790b
> > > +#define PCI_DEVICE_ID_AMD_CZN_RP0x1630
> >
> > Why add this here when it is not needed in this file?  Please read the top of
> > the file...
> >
> [Prike]  I'm sorry can't get you meaning before. Do you mean the pci_id header used only for the global PCI ID definition and in this case only need put the 0x1630 DID in the quirk entry directly?

Yes, it is not needed to be added to the pci_ids.h file unless it is
used in multiple .c files, which is not the case here.

thanks,

greg k-h
