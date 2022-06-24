Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB4AC5592B6
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 08:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiFXGCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 02:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiFXGCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 02:02:40 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1D069246;
        Thu, 23 Jun 2022 23:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656050559; x=1687586559;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=M28AR2+gE5PYG7d0gC02iP64d6sCJq6k2gkhyc/RX8s=;
  b=C3Ml6LcGHp1DAq/psiX9EmS6/ttFaZ8SovvPE84Qu2BSJhn3lU1u/3fr
   JOyiMDAC4tfWzi04KYMCTMiDPceG3RfskWWGo6N5l8matCdXU81GZby10
   c4snVrCIIDk5N8ubezk+FE8024qjRcsP1ggUEhlS4liK0KpVlYVBjHmHo
   AKQ+u/SWInrborIXi3Po+WthamNlywxgNaZwQWq7wOE4tImq5SvKUFZjU
   hNJzeYDE0Za8nDmeA2e3Wka14pCVmpXS3qoWuQOv9VnpRNFxzi6LMI4iJ
   cujauhPBzyxGRe2rIqeurV0PGMddHIu5KA89Iz5nrFCjIkVCLZx2VE3M3
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="279697025"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="279697025"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 23:02:39 -0700
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="593076850"
Received: from zhaohaif-mobl1.ccr.corp.intel.com (HELO [10.254.209.161]) ([10.254.209.161])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 23:02:36 -0700
Message-ID: <eb2257b1-1213-1001-74bd-085af5d50dad@linux.intel.com>
Date:   Fri, 24 Jun 2022 14:02:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 1/1] iommu/vt-d: Fix RID2PASID setup/teardown failure
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        iommu@lists.linux-foundation.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220623065720.727849-1-baolu.lu@linux.intel.com>
From:   Ethan Zhao <haifeng.zhao@linux.intel.com>
In-Reply-To: <20220623065720.727849-1-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi，

在 2022/6/23 14:57, Lu Baolu 写道:
> The IOMMU driver shares the pasid table for PCI alias devices. When the
> RID2PASID entry of the shared pasid table has been filled by the first
> device, the subsequent device will encounter the "DMAR: Setup RID2PASID
> failed" failure as the pasid entry has already been marked as present.
> As the result, the IOMMU probing process will be aborted.
>
> On the contrary, when any alias device is hot-removed from the system,
> for example, by writing to /sys/bus/pci/devices/.../remove, the shared
> RID2PASID will be cleared without any notifications to other devices.
> As the result, any DMAs from those rest devices are blocked.
>
> Sharing pasid table among PCI alias devices could save two memory pages
> for devices underneath the PCIe-to-PCI bridges. Anyway, considering that
> those devices are rare on modern platforms that support VT-d in scalable
> mode and the saved memory is negligible, it's reasonable to remove this
> part of immature code to make the driver feasible and stable.
In my understanding, thus cleanning will make the pasid table become
per-dev datastructure whatever the dev is pci-alias or not, and the
pasid_pte_is_present(pte)will only check against every pci-alias' own
private pasid table,the setup stagewouldn't break, so does the
detach/release path, and little value to code otherreference counter
like complex implenmataion, looks good to me !


Thanks,

Ethan

> Fixes: ef848b7e5a6a0 ("iommu/vt-d: Setup pasid entry for RID2PASID support")
> Reported-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Reported-by: Ethan Zhao <haifeng.zhao@linux.intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>   include/linux/intel-iommu.h |  3 --
>   drivers/iommu/intel/pasid.h |  1 -
>   drivers/iommu/intel/iommu.c | 24 -------------
>   drivers/iommu/intel/pasid.c | 69 ++-----------------------------------
>   4 files changed, 3 insertions(+), 94 deletions(-)
>
> Change log:
> v3:
>   - Ethan pointed out that there's also problem in the device release
>     path. Let's remove this part of immature code for now.
>
> v2:
>   - Add domain validity check in RID2PASID entry setup.
>
> diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
> index 4f29139bbfc3..5fcf89faa31a 100644
> --- a/include/linux/intel-iommu.h
> +++ b/include/linux/intel-iommu.h
> @@ -612,7 +612,6 @@ struct intel_iommu {
>   struct device_domain_info {
>   	struct list_head link;	/* link to domain siblings */
>   	struct list_head global; /* link to global list */
> -	struct list_head table;	/* link to pasid table */
>   	u32 segment;		/* PCI segment number */
>   	u8 bus;			/* PCI bus number */
>   	u8 devfn;		/* PCI devfn number */
> @@ -729,8 +728,6 @@ extern int dmar_ir_support(void);
>   void *alloc_pgtable_page(int node);
>   void free_pgtable_page(void *vaddr);
>   struct intel_iommu *domain_get_iommu(struct dmar_domain *domain);
> -int for_each_device_domain(int (*fn)(struct device_domain_info *info,
> -				     void *data), void *data);
>   void iommu_flush_write_buffer(struct intel_iommu *iommu);
>   int intel_iommu_enable_pasid(struct intel_iommu *iommu, struct device *dev);
>   struct intel_iommu *device_to_iommu(struct device *dev, u8 *bus, u8 *devfn);
> diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
> index 583ea67fc783..bf5b937848b4 100644
> --- a/drivers/iommu/intel/pasid.h
> +++ b/drivers/iommu/intel/pasid.h
> @@ -74,7 +74,6 @@ struct pasid_table {
>   	void			*table;		/* pasid table pointer */
>   	int			order;		/* page order of pasid table */
>   	u32			max_pasid;	/* max pasid */
> -	struct list_head	dev;		/* device list */
>   };
>   
>   /* Get PRESENT bit of a PASID directory entry. */
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 44016594831d..5c0dce78586a 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -320,30 +320,6 @@ EXPORT_SYMBOL_GPL(intel_iommu_gfx_mapped);
>   DEFINE_SPINLOCK(device_domain_lock);
>   static LIST_HEAD(device_domain_list);
>   
> -/*
> - * Iterate over elements in device_domain_list and call the specified
> - * callback @fn against each element.
> - */
> -int for_each_device_domain(int (*fn)(struct device_domain_info *info,
> -				     void *data), void *data)
> -{
> -	int ret = 0;
> -	unsigned long flags;
> -	struct device_domain_info *info;
> -
> -	spin_lock_irqsave(&device_domain_lock, flags);
> -	list_for_each_entry(info, &device_domain_list, global) {
> -		ret = fn(info, data);
> -		if (ret) {
> -			spin_unlock_irqrestore(&device_domain_lock, flags);
> -			return ret;
> -		}
> -	}
> -	spin_unlock_irqrestore(&device_domain_lock, flags);
> -
> -	return 0;
> -}
> -
>   const struct iommu_ops intel_iommu_ops;
>   
>   static bool translation_pre_enabled(struct intel_iommu *iommu)
> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
> index cb4c1d0cf25c..17cad7c1f62d 100644
> --- a/drivers/iommu/intel/pasid.c
> +++ b/drivers/iommu/intel/pasid.c
> @@ -86,54 +86,6 @@ void vcmd_free_pasid(struct intel_iommu *iommu, u32 pasid)
>   /*
>    * Per device pasid table management:
>    */
> -static inline void
> -device_attach_pasid_table(struct device_domain_info *info,
> -			  struct pasid_table *pasid_table)
> -{
> -	info->pasid_table = pasid_table;
> -	list_add(&info->table, &pasid_table->dev);
> -}
> -
> -static inline void
> -device_detach_pasid_table(struct device_domain_info *info,
> -			  struct pasid_table *pasid_table)
> -{
> -	info->pasid_table = NULL;
> -	list_del(&info->table);
> -}
> -
> -struct pasid_table_opaque {
> -	struct pasid_table	**pasid_table;
> -	int			segment;
> -	int			bus;
> -	int			devfn;
> -};
> -
> -static int search_pasid_table(struct device_domain_info *info, void *opaque)
> -{
> -	struct pasid_table_opaque *data = opaque;
> -
> -	if (info->iommu->segment == data->segment &&
> -	    info->bus == data->bus &&
> -	    info->devfn == data->devfn &&
> -	    info->pasid_table) {
> -		*data->pasid_table = info->pasid_table;
> -		return 1;
> -	}
> -
> -	return 0;
> -}
> -
> -static int get_alias_pasid_table(struct pci_dev *pdev, u16 alias, void *opaque)
> -{
> -	struct pasid_table_opaque *data = opaque;
> -
> -	data->segment = pci_domain_nr(pdev->bus);
> -	data->bus = PCI_BUS_NUM(alias);
> -	data->devfn = alias & 0xff;
> -
> -	return for_each_device_domain(&search_pasid_table, data);
> -}
>   
>   /*
>    * Allocate a pasid table for @dev. It should be called in a
> @@ -143,28 +95,18 @@ int intel_pasid_alloc_table(struct device *dev)
>   {
>   	struct device_domain_info *info;
>   	struct pasid_table *pasid_table;
> -	struct pasid_table_opaque data;
>   	struct page *pages;
>   	u32 max_pasid = 0;
> -	int ret, order;
> -	int size;
> +	int order, size;
>   
>   	might_sleep();
>   	info = dev_iommu_priv_get(dev);
>   	if (WARN_ON(!info || !dev_is_pci(dev) || info->pasid_table))
>   		return -EINVAL;
>   
> -	/* DMA alias device already has a pasid table, use it: */
> -	data.pasid_table = &pasid_table;
> -	ret = pci_for_each_dma_alias(to_pci_dev(dev),
> -				     &get_alias_pasid_table, &data);
> -	if (ret)
> -		goto attach_out;
> -
>   	pasid_table = kzalloc(sizeof(*pasid_table), GFP_KERNEL);
>   	if (!pasid_table)
>   		return -ENOMEM;
> -	INIT_LIST_HEAD(&pasid_table->dev);
>   
>   	if (info->pasid_supported)
>   		max_pasid = min_t(u32, pci_max_pasids(to_pci_dev(dev)),
> @@ -182,9 +124,7 @@ int intel_pasid_alloc_table(struct device *dev)
>   	pasid_table->table = page_address(pages);
>   	pasid_table->order = order;
>   	pasid_table->max_pasid = 1 << (order + PAGE_SHIFT + 3);
> -
> -attach_out:
> -	device_attach_pasid_table(info, pasid_table);
> +	info->pasid_table = pasid_table;
>   
>   	return 0;
>   }
> @@ -202,10 +142,7 @@ void intel_pasid_free_table(struct device *dev)
>   		return;
>   
>   	pasid_table = info->pasid_table;
> -	device_detach_pasid_table(info, pasid_table);
> -
> -	if (!list_empty(&pasid_table->dev))
> -		return;
> +	info->pasid_table = NULL;
>   
>   	/* Free scalable mode PASID directory tables: */
>   	dir = pasid_table->table;

-- 
"firm, enduring, strong, and long-lived"

