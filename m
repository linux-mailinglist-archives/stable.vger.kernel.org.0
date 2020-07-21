Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8432282DC
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 16:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgGUOyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 10:54:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727941AbgGUOyE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jul 2020 10:54:04 -0400
Received: from localhost (mobile-166-175-191-139.mycingular.net [166.175.191.139])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4B2A20717;
        Tue, 21 Jul 2020 14:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595343243;
        bh=LGjn1NQByMAtiMquXEdKNSg+VZngPld+GQLBIyWGQFA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=gAurnN/EAgwhJYBOP3FVWZ8Q1zkaIbD9GyL/qucE1v0WOfPMfD1E/SruAJUQUtCD2
         eKB082UD1rxcMa4I2M21vXYK/6rPiwMWBp72swxptXHA8FF2J5+wUiH2aOXG2E+mLf
         +jHmuqyjPBGrCSjJIVSKSoqd/zQwOeif5EIzkaqQ=
Date:   Tue, 21 Jul 2020 09:54:01 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Ashok Raj <ashok.raj@intel.com>
Cc:     linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Joerg Roedel <joro@8bytes.org>, Lu Baolu <baolu.lu@intel.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org
Subject: Re: [PATCH] PCI/ATS: PASID and PRI are only enumerated in PF devices.
Message-ID: <20200721145401.GA1117318@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1595263380-209956-1-git-send-email-ashok.raj@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 20, 2020 at 09:43:00AM -0700, Ashok Raj wrote:
> PASID and PRI capabilities are only enumerated in PF devices. VF devices
> do not enumerate these capabilites. IOMMU drivers also need to enumerate
> them before enabling features in the IOMMU. Extending the same support as
> PASID feature discovery (pci_pasid_features) for PRI.
> 
> Signed-off-by: Ashok Raj <ashok.raj@intel.com>

Hi Ashok,

When you update this for the 0-day implicit declaration thing, can you
update the subject to say what the patch *does*, as opposed to what it
is solving?  Also, no need for a period at the end.

Does this fix a regression?  Is it associated with a commit that we
could add as a "Fixes:" tag so we know how far back to try to apply
to stable kernels?

> To: Bjorn Helgaas <bhelgaas@google.com>
> To: Joerg Roedel <joro@8bytes.com>
> To: Lu Baolu <baolu.lu@intel.com>
> Cc: stable@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Ashok Raj <ashok.raj@intel.com>
> Cc: iommu@lists.linux-foundation.org
> ---
>  drivers/iommu/intel/iommu.c |  2 +-
>  drivers/pci/ats.c           | 14 ++++++++++++++
>  include/linux/pci-ats.h     |  1 +
>  3 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index d759e7234e98..276452f5e6a7 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -2560,7 +2560,7 @@ static struct dmar_domain *dmar_insert_one_dev_info(struct intel_iommu *iommu,
>  			}
>  
>  			if (info->ats_supported && ecap_prs(iommu->ecap) &&
> -			    pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_PRI))
> +			    pci_pri_supported(pdev))
>  				info->pri_supported = 1;
>  		}
>  	}
> diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
> index b761c1f72f67..ffb4de8c5a77 100644
> --- a/drivers/pci/ats.c
> +++ b/drivers/pci/ats.c
> @@ -461,6 +461,20 @@ int pci_pasid_features(struct pci_dev *pdev)
>  }
>  EXPORT_SYMBOL_GPL(pci_pasid_features);
>  
> +/**
> + * pci_pri_supported - Check if PRI is supported.
> + * @pdev: PCI device structure
> + *
> + * Returns false when no PRI capability is present.
> + * Returns true if PRI feature is supported and enabled
> + */
> +bool pci_pri_supported(struct pci_dev *pdev)
> +{
> +	/* VFs share the PF PRI configuration */
> +	return !!(pci_physfn(pdev)->pri_cap);
> +}
> +EXPORT_SYMBOL_GPL(pci_pri_supported);
> +
>  #define PASID_NUMBER_SHIFT	8
>  #define PASID_NUMBER_MASK	(0x1f << PASID_NUMBER_SHIFT)
>  /**
> diff --git a/include/linux/pci-ats.h b/include/linux/pci-ats.h
> index f75c307f346d..073d57292445 100644
> --- a/include/linux/pci-ats.h
> +++ b/include/linux/pci-ats.h
> @@ -28,6 +28,7 @@ int pci_enable_pri(struct pci_dev *pdev, u32 reqs);
>  void pci_disable_pri(struct pci_dev *pdev);
>  int pci_reset_pri(struct pci_dev *pdev);
>  int pci_prg_resp_pasid_required(struct pci_dev *pdev);
> +bool pci_pri_supported(struct pci_dev *pdev);
>  #endif /* CONFIG_PCI_PRI */
>  
>  #ifdef CONFIG_PCI_PASID
> -- 
> 2.7.4
> 
