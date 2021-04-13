Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6533A35D86E
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 09:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236520AbhDMHB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 03:01:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236937AbhDMHBY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Apr 2021 03:01:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D580661278;
        Tue, 13 Apr 2021 07:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618297263;
        bh=Yg3OibJmyp93nMd8VQ9jxRe/MSMoNOEUXL9EhUBJod0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x6gV9yxXzw3kRWNV0aM/+4zhR/wywqcNXBqp0dFwNblqZLn5W+rNwbrRdsU8t/h4Z
         C7KMZ75IpjbIjgUXm9hua4kfujwMBt9wKTPrA5rU/x6evtdKO1w7VOj5GOAI0Bk9Wn
         /hAuz4U5+StEapvua+6L67u4CM1meYNtggBrD3vI=
Date:   Tue, 13 Apr 2021 09:00:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Liang, Prike" <Prike.Liang@amd.com>
Cc:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>
Subject: Re: [PATCH] nvme: put some AMD PCIE downstream NVME device to simple
 suspend/resume path
Message-ID: <YHVBq9VxHkQt18Gy@kroah.com>
References: <1618294221-11528-1-git-send-email-Prike.Liang@amd.com>
 <YHU7M7ThQiAsOCSG@kroah.com>
 <BYAPR12MB3238FAD129CF0E7F0DAAF205FB4F9@BYAPR12MB3238.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR12MB3238FAD129CF0E7F0DAAF205FB4F9@BYAPR12MB3238.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 13, 2021 at 06:44:08AM +0000, Liang, Prike wrote:
> [AMD Public Use]
> 
> >
> > On Tue, Apr 13, 2021 at 02:10:21PM +0800, Prike Liang wrote:
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
> > >  drivers/pci/quirks.c    | 11 +++++++++++
> > >  include/linux/pci.h     |  2 ++
> > >  include/linux/pci_ids.h |  2 ++
> > >  4 files changed, 20 insertions(+)
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
> > > 653660e3..b7e19bb 100644
> > > --- a/drivers/pci/quirks.c
> > > +++ b/drivers/pci/quirks.c
> > > @@ -312,6 +312,17 @@ static void quirk_nopciamd(struct pci_dev *dev)
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
> > DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,
> > > +PCI_DEVICE_ID_AMD_RN_RP, quirk_amd_nvme_fixup);
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
> > > d8156a5..7f6340c 100644
> > > --- a/include/linux/pci_ids.h
> > > +++ b/include/linux/pci_ids.h
> > > @@ -602,6 +602,8 @@
> > >  #define PCI_DEVICE_ID_AMD_HUDSON2_SMBUS0x780b
> > >  #define PCI_DEVICE_ID_AMD_HUDSON2_IDE0x780c
> > >  #define PCI_DEVICE_ID_AMD_KERNCZ_SMBUS  0x790b
> > > +#define PCI_DEVICE_ID_AMD_CZN_RP0x1630
> > > +#define PCI_DEVICE_ID_AMD_RN_RP
> > PCI_DEVICE_ID_AMD_CZN_RP
> >
> > If the pci ids are identical, why do you need different entries for it?
> > Haven't you above just listed the same thing twice in the quirk entry?
> >
> > thanks,
> >
> > greg k-h
> [Prike] Use the different entries for identifying the RN/CZN respectively and that will clearly imply which ASIC need this quirk. Anyway we can use the one DID for RN/CZN to avoid the PCI ID retrieved twice.

But look at this patch, you list the same device ids in a quirk entry
twice, why???

PCI device ids should be unique per-device, and not shared with
different names like this.  Also, why even add them to the .h file, you
did read the top of it, right?

thanks,

greg k-h
