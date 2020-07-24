Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B2422BC0B
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 04:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgGXCg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 22:36:58 -0400
Received: from mga07.intel.com ([134.134.136.100]:34637 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbgGXCg6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jul 2020 22:36:58 -0400
IronPort-SDR: R+s0XC6zSojE1MozXgKd3VQEVsws9zfsw+eApFuSgjjMBteAMt+RFjjA57hBrhKlZWYa2tkOiP
 qVT6Cfjd+dNA==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="215241481"
X-IronPort-AV: E=Sophos;i="5.75,389,1589266800"; 
   d="scan'208";a="215241481"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 19:36:57 -0700
IronPort-SDR: VumJ4VEkWa/OzC1HjafHWG3PZMIWizMVXVztoxDHSS7WiXFyCR8JaetnBle565Tqk0tmfQOWpW
 8+Qiz+zmCQBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,389,1589266800"; 
   d="scan'208";a="393186436"
Received: from allen-box.sh.intel.com (HELO [10.239.159.139]) ([10.239.159.139])
  by fmsmga001.fm.intel.com with ESMTP; 23 Jul 2020 19:36:55 -0700
Cc:     baolu.lu@linux.intel.com, iommu@lists.linux-foundation.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] PCI/ATS: Check PRI supported on the PF device when
 SRIOV is enabled
To:     Ashok Raj <ashok.raj@intel.com>, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Joerg Roedel <joro@8bytes.org>, Lu Baolu <baolu.lu@intel.com>
References: <1595543849-19692-1-git-send-email-ashok.raj@intel.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <4e14f3b7-fdd7-8710-5051-440597ea198d@linux.intel.com>
Date:   Fri, 24 Jul 2020 10:32:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1595543849-19692-1-git-send-email-ashok.raj@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/24/20 6:37 AM, Ashok Raj wrote:
> PASID and PRI capabilities are only enumerated in PF devices. VF devices
> do not enumerate these capabilites. IOMMU drivers also need to enumerate
> them before enabling features in the IOMMU. Extending the same support as
> PASID feature discovery (pci_pasid_features) for PRI.
> 
> Fixes: b16d0cb9e2fc ("iommu/vt-d: Always enable PASID/PRI PCI capabilities before ATS")
> Signed-off-by: Ashok Raj <ashok.raj@intel.com>
> 
> To: Bjorn Helgaas <bhelgaas@google.com>
> To: Joerg Roedel <joro@8bytes.com>
> To: Lu Baolu <baolu.lu@intel.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Best regards,
baolu

> Cc: stable@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Ashok Raj <ashok.raj@intel.com>
> Cc: iommu@lists.linux-foundation.org
> ---
> v3: Added Fixes tag
> v2: Fixed build failure reported from lkp when CONFIG_PRI=n
> 
>   drivers/iommu/intel/iommu.c |  2 +-
>   drivers/pci/ats.c           | 13 +++++++++++++
>   include/linux/pci-ats.h     |  4 ++++
>   3 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index d759e7234e98..276452f5e6a7 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -2560,7 +2560,7 @@ static struct dmar_domain *dmar_insert_one_dev_info(struct intel_iommu *iommu,
>   			}
>   
>   			if (info->ats_supported && ecap_prs(iommu->ecap) &&
> -			    pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_PRI))
> +			    pci_pri_supported(pdev))
>   				info->pri_supported = 1;
>   		}
>   	}
> diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
> index b761c1f72f67..2e6cf0c700f7 100644
> --- a/drivers/pci/ats.c
> +++ b/drivers/pci/ats.c
> @@ -325,6 +325,19 @@ int pci_prg_resp_pasid_required(struct pci_dev *pdev)
>   
>   	return pdev->pasid_required;
>   }
> +
> +/**
> + * pci_pri_supported - Check if PRI is supported.
> + * @pdev: PCI device structure
> + *
> + * Returns true if PRI capability is present, false otherwise.
> + */
> +bool pci_pri_supported(struct pci_dev *pdev)
> +{
> +	/* VFs share the PF PRI configuration */
> +	return !!(pci_physfn(pdev)->pri_cap);
> +}
> +EXPORT_SYMBOL_GPL(pci_pri_supported);
>   #endif /* CONFIG_PCI_PRI */
>   
>   #ifdef CONFIG_PCI_PASID
> diff --git a/include/linux/pci-ats.h b/include/linux/pci-ats.h
> index f75c307f346d..df54cd5b15db 100644
> --- a/include/linux/pci-ats.h
> +++ b/include/linux/pci-ats.h
> @@ -28,6 +28,10 @@ int pci_enable_pri(struct pci_dev *pdev, u32 reqs);
>   void pci_disable_pri(struct pci_dev *pdev);
>   int pci_reset_pri(struct pci_dev *pdev);
>   int pci_prg_resp_pasid_required(struct pci_dev *pdev);
> +bool pci_pri_supported(struct pci_dev *pdev);
> +#else
> +static inline bool pci_pri_supported(struct pci_dev *pdev)
> +{ return false; }
>   #endif /* CONFIG_PCI_PRI */
>   
>   #ifdef CONFIG_PCI_PASID
> 
