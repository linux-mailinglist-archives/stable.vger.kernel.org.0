Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFCB35EEBD
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 09:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbhDNHtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 03:49:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229963AbhDNHtT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 03:49:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E23C3613C4;
        Wed, 14 Apr 2021 07:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618386538;
        bh=vmUTkhJhcxKjbTntrU4ig4GdlaiPtJChHqBeU5k4FXc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PKE3q0Zva8vUkp86YISfX7vX2j/0NfZ7BaapfRbsUtgkiH61urmyP6A1exCr9cKWS
         Z/UaNexlWkrhmQK9uayvGFFS/9464v9tb8xwW7t8mcS3BZzIIImY8kGN/DI1Kirvrj
         agG/kyL1yuZEcUDIM0WbSpxOQALQnS+oHBbKZ9Tk=
Date:   Wed, 14 Apr 2021 09:48:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Liang, Prike" <Prike.Liang@amd.com>
Cc:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "Chaitanya.Kulkarni@wdc.com" <Chaitanya.Kulkarni@wdc.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "# 5 . 11+" <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] nvme-pci: add AMD PCIe quirk for suspend/resume
Message-ID: <YHaeZ/auMUYGSy1K@kroah.com>
References: <1618381200-14856-1-git-send-email-Prike.Liang@amd.com>
 <1618381200-14856-2-git-send-email-Prike.Liang@amd.com>
 <YHaOJDm3GCZ8baAV@kroah.com>
 <BYAPR12MB3238544752DD86202469CA1EFB4E9@BYAPR12MB3238.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR12MB3238544752DD86202469CA1EFB4E9@BYAPR12MB3238.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 14, 2021 at 07:13:15AM +0000, Liang, Prike wrote:
> [AMD Public Use]
> 
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Sent: Wednesday, April 14, 2021 2:40 PM
> > To: Liang, Prike <Prike.Liang@amd.com>
> > Cc: linux-nvme@lists.infradead.org; kbusch@kernel.org;
> > Chaitanya.Kulkarni@wdc.com; hch@infradead.org; S-k, Shyam-sundar
> > <Shyam-sundar.S-k@amd.com>; Deucher, Alexander
> > <Alexander.Deucher@amd.com>; # 5 . 11+ <stable@vger.kernel.org>
> > Subject: Re: [PATCH 2/2] nvme-pci: add AMD PCIe quirk for suspend/resume
> >
> > On Wed, Apr 14, 2021 at 02:20:00PM +0800, Prike Liang wrote:
> > > The NVME device pluged in some AMD PCIE root port will resume timeout
> > > from s2idle which caused by NVME power CFG lost in the SMU FW restore.
> > > This issue can be workaround by using PCIe power set with simple
> > > suspend/resume process path instead of APST. In the onwards ASIC will
> > > try do the NVME shutdown save and restore in the BIOS and still need
> > > PCIe power setting to resume from RTD3 for s2idle.
> > >
> > > Update the nvme_acpi_storage_d3() _with previously added quirk.
> > >
> > > Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> > > [ck: split patches for nvme and pcie]
> > > Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> > > Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> > > Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> > > Cc: <stable@vger.kernel.org> # 5.11+
> > > ---
> > >  drivers/nvme/host/pci.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c index
> > > 6bad4d4..5a9a192 100644
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
> > > +if (rdev && (rdev->dev_flags &
> > PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND))
> > > +return NVME_QUIRK_SIMPLE_SUSPEND;
> > > +
> > >  adev = ACPI_COMPANION(&root->dev);
> > >  if (!adev)
> > >  return false;
> > > --
> > > 2.7.4
> > >
> >
> > This is still broken, why resend it?
> Sorry can't get how come the reference count leaked, could you help give more detail about this.

Please read the documentation for the call you are making here.  For
once, it is actually written down what needs to be done :)

