Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B773898A3
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 23:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhESVfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 17:35:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229808AbhESVfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 May 2021 17:35:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC8D061074;
        Wed, 19 May 2021 21:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621460041;
        bh=P4pBbb+gpfVC0LaXhR2HVFGTt4ylPWLlXS4sxpNN6/4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=pDctJk6zxPhASM4cufXgw00O0lh5OH4gCGCZiBDQbLlk9kurV3jpn+J/CAfwJv9yO
         DR34pZ3hhPPdiikP0zSP66uVuPqp89zCyMI18IIZOOXKFx61AzJqDoGPXtkyz4X4km
         5YfWBSfXOKytwRKJM87Nw7J7I6dYzDeIcXNv5PYP6CzZyaVm3P2RGodD1Gdyd6zzEj
         M+QRTWuORa1yKAcBW8chBJX83pFGbC1sEMF8NQ85ENKkHF3Nzii5oRdh2W+c8/05Rh
         DvNLYZ+iGsqinFVGBfZ8AqaoH3X4PHjvYG/BL2Up+aP46o9NMFdELMWxaOVxvtelTB
         B1eLXR6HLxCBg==
Date:   Wed, 19 May 2021 16:33:59 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Prike Liang <Prike.Liang@amd.com>
Cc:     linux-pci@vger.kernel.org, kbusch@kernel.org, axboe@fb.com,
        hch@lst.de, sagi@grimberg.me, linux-nvme@lists.infradead.org,
        Alexander.Deucher@amd.com, stable@vger.kernel.org,
        Shyam-sundar.S-k@amd.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org
Subject: Re: [PATCH v5 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
Message-ID: <20210519213359.GA256663@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621304675-17874-2-git-send-email-Prike.Liang@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[+cc Rafael (probably nothing of interest to you), linux-pm]

On Tue, May 18, 2021 at 10:24:34AM +0800, Prike Liang wrote:
> In the NVMe controller default suspend-resume seems only save/restore the
> NVMe link state by APST opt and the NVMe remains in D0 during this time.
> Then the NVMe device will be shutdown by SMU firmware in the s2idle entry
> and then will lost the NVMe power context during s2idle resume.Finally,
> the NVMe command queue request will be processed abnormally and result
> in access timeout.This issue can be settled by using PCIe power set with
> simple suspend-resume process path instead of APST get/set opt.

I can't parse the paragraph above, sorry.  I'm sure this means
something to NVMe developers, but since you're adding this to the PCI
core, not the NVMe core, it needs to be intelligible to ordinary PCI
folks.

For example, since you only use this flag in the NVMe driver, you
should explain why the PCI core needs to keep track of the flag for
you.  Normally I would assume the driver could figure this out in its
.probe() function.

Quirks are usually used to work around a defect in a device.  What's
the defect in this case?  Ideally we can point to a section of the
PCIe spec with a requirement that the device violates.

What does "opt" mean?

What is SMU firmware?  Why is it relevant?

Is this a problem only with s2idle?  Why or why not?

The quirk applies to [1022:1630].  An lspci I found on the web says
this is a "00:00.0 Host bridge: AMD Renoir Root Complex" device.  So
it looks like this will result in PCI_BUS_FLAGS_DISABLE_ON_S2I being
set for every PCI bus in the entire system.  But the description talks
about an issue specifically with NVMe.

Is there a defect in this AMD PCIe controller that affects all
devices?

> In this patch prepare a PCIe RC bus flag to identify the platform whether
> need the quirk.
> 
> Cc: <stable@vger.kernel.org> # 5.10+
> Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> [ck: split patches for nvme and pcie]
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> Suggested-by: Keith Busch <kbusch@kernel.org>
> Acked-by: Keith Busch <kbusch@kernel.org>
> ---
> Changes in v2:
> Fix the patch format and check chip root complex DID instead of PCIe RP
> to avoid the storage device plugged in internal PCIe RP by USB adaptor.
> 
> Changes in v3:
> According to Christoph Hellwig do NVME PCIe related identify opt better in
> PCIe quirk driver rather than in NVME module.
> 
> Changes in v4:
> Split the fix to PCIe and NVMe part and then call the pci_dev_put() put
> the device reference count and finally refine the commit info.
> 
> Changes in v5:
> According to Christoph Hellwig and Keith Busch better use a passthrough device(bus)
> gloable flag to identify the NVMe shutdown opt rather than look up the device BDF.
> ---
>  drivers/pci/probe.c  | 5 ++++-
>  drivers/pci/quirks.c | 7 +++++++
>  include/linux/pci.h  | 2 ++
>  3 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 953f15a..34ba691e 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -558,10 +558,13 @@ static struct pci_bus *pci_alloc_bus(struct pci_bus *parent)
>  	INIT_LIST_HEAD(&b->resources);
>  	b->max_bus_speed = PCI_SPEED_UNKNOWN;
>  	b->cur_bus_speed = PCI_SPEED_UNKNOWN;
> +	if (parent) {
>  #ifdef CONFIG_PCI_DOMAINS_GENERIC
> -	if (parent)
>  		b->domain_nr = parent->domain_nr;
>  #endif
> +		if (parent->bus_flags & PCI_BUS_FLAGS_DISABLE_ON_S2I)
> +			b->bus_flags |= PCI_BUS_FLAGS_DISABLE_ON_S2I;
> +	}
>  	return b;
>  }
>  
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 653660e3..7c4bb8e 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -312,6 +312,13 @@ static void quirk_nopciamd(struct pci_dev *dev)
>  }
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_8151_0,	quirk_nopciamd);
>  
> +static void quirk_amd_s2i_fixup(struct pci_dev *dev)
> +{
> +	dev->bus->bus_flags |= PCI_BUS_FLAGS_DISABLE_ON_S2I;
> +	pci_info(dev, "AMD simple suspend opt enabled\n");
> +}
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x1630, quirk_amd_s2i_fixup);
> +
>  /* Triton requires workarounds to be used by the drivers */
>  static void quirk_triton(struct pci_dev *dev)
>  {
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 53f4904..dc65219 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -240,6 +240,8 @@ enum pci_bus_flags {
>  	PCI_BUS_FLAGS_NO_MMRBC	= (__force pci_bus_flags_t) 2,
>  	PCI_BUS_FLAGS_NO_AERSID	= (__force pci_bus_flags_t) 4,
>  	PCI_BUS_FLAGS_NO_EXTCFG	= (__force pci_bus_flags_t) 8,
> +	/* Driver must pci_disable_device() for suspend-to-idle */
> +	PCI_BUS_FLAGS_DISABLE_ON_S2I	= (__force pci_bus_flags_t) 16,
>  };
>  
>  /* Values from Link Status register, PCIe r3.1, sec 7.8.8 */
> -- 
> 2.7.4
> 
