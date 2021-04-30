Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372CA36FFFA
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 19:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhD3Rvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 13:51:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231422AbhD3Rvk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 13:51:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36CB061186;
        Fri, 30 Apr 2021 17:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619805051;
        bh=dsUAq9OHe+LM0RLcK+sEicotIP9gabDGvl8bPpPeIlM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=OzW4mTmJO77VGepm6/NAttAoxNHkTLpoVZixQpfcdMsdPP3azlHoo/EJvoUvoneZW
         /L5lVdGwtqPwY/J1mbp2FIF2QKF9Okvz+MfGJrcLm2ChPGzy+CiofIJdQfyPM9cRSX
         pnyudU0UVYLnDk6cN+bUDEU1WIRnxN7CZ2FwAdtK4GFNrI6IAwQ30E/eawC3EX71UW
         Z1ObRB3JqfMsktdGY5l6g9itAreyqG/KRPg/ibf9lKwa+AzwUMqxhPs9cbxWjNce0z
         H1rQy1kFCv7csLxG+xb1LQwAPLEDlcEruu+6BwEG7ht8FNADa9n1LF1EzKzkg1eFEO
         w2Rj32v92NXhg==
Date:   Fri, 30 Apr 2021 12:50:49 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Prike Liang <Prike.Liang@amd.com>
Cc:     linux-nvme@lists.infradead.org, Chaitanya.Kulkarni@wdc.com,
        gregkh@linuxfoundation.org, hch@infradead.org,
        stable@vger.kernel.org, Alexander.Deucher@amd.com,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        linux-pci@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v4 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
Message-ID: <20210430175049.GA664888@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1618458725-17164-1-git-send-email-Prike.Liang@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[+cc linux-pci, Rafael, thread at
https://lore.kernel.org/linux-nvme/1618458725-17164-1-git-send-email-Prike.Liang@amd.com/#t]

On Thu, Apr 15, 2021 at 11:52:04AM +0800, Prike Liang wrote:
> The NVME device pluged in some AMD PCIE root port will resume timeout
> from s2idle which caused by NVME power CFG lost in the SMU FW restore.
> This issue can be workaround by using PCIe power set with simple
> suspend/resume process path instead of APST. In the onwards ASIC will
> try do the NVME shutdown save and restore in the BIOS and still need PCIe
> power setting to resume from RTD3 for s2idle.
> 
> In this preparation patch add a PCIe quirk for the AMD.

This needs to be cc'd to linux-pci (I did it for you this time).

Sorry, I can't make any sense out of the commit log.  Is this a Root
Port defect or an NVMe device defect?

Patch 2/2 only uses PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND in the nvme
driver, so AFAICT there is no reason for the PCI core to keep track of
the flag for you.

I see below that Christoph suggests it needs to be in the PCI core,
but the reason needs to be explained in the commit log.

I have not acked this patch.  Please don't merge it before clearing
these things up.

> Cc: <stable@vger.kernel.org> # 5.11+
> Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> [ck: split patches for nvme and pcie]
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> 
> Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> ---
> Changes in v2:
> Fix the patch format and check chip root complex DID instead of PCIe RP
> to avoid the storage device plugged in internal PCIe RP by USB adaptor.
> 
> Changes in v3:
> According to Christoph Hellwig do NVME PCIe related identify opt better 
> in PCIe quirk driver rather than in NVME module.
> 
> Changes in v4:
> Split the fix to PCIe and NVMe part and then call the pci_dev_put() put 
> the device reference count and finally refine the commit info.
> ---
> drivers/pci/quirks.c | 10 ++++++++++
>  include/linux/pci.h  |  2 ++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 653660e3..f95c8b2 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -312,6 +312,16 @@ static void quirk_nopciamd(struct pci_dev *dev)
>  }
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_8151_0,	quirk_nopciamd);
>  
> +static void quirk_amd_nvme_fixup(struct pci_dev *dev)
> +{
> +	struct pci_dev *rdev;
> +
> +	dev->dev_flags |= PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND;
> +	pci_info(dev, "AMD simple suspend opt enabled\n");
> +
> +}
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x1630, quirk_amd_nvme_fixup);
> +
>  /* Triton requires workarounds to be used by the drivers */
>  static void quirk_triton(struct pci_dev *dev)
>  {
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 53f4904..a6e1b1b 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -227,6 +227,8 @@ enum pci_dev_flags {
>  	PCI_DEV_FLAGS_NO_FLR_RESET = (__force pci_dev_flags_t) (1 << 10),
>  	/* Don't use Relaxed Ordering for TLPs directed at this device */
>  	PCI_DEV_FLAGS_NO_RELAXED_ORDERING = (__force pci_dev_flags_t) (1 << 11),
> +	/* AMD simple suspend opt quirk */
> +	PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND = (__force pci_dev_flags_t) (1 << 12),
>  };
>  
>  enum pci_irq_reroute_variant {
> -- 
> 2.7.4
> 
> 
> _______________________________________________
> Linux-nvme mailing list
> Linux-nvme@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-nvme
