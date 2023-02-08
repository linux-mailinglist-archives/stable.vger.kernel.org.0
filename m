Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D0868F32D
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 17:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjBHQcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 11:32:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjBHQcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 11:32:01 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002A92CFD9;
        Wed,  8 Feb 2023 08:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675873919; x=1707409919;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DrxyrS9fcF2Z7IFnOpdeLdaLWCYGNwXwVIJ5fncGZPM=;
  b=iOOn9u8fC+iboDpmFbFHtLUjech+tjFG24ba9O1OdZ9mEL7A3K61vhao
   pgFLgYHbcRkpIGZZTbBqVkYU8g8fW+F/YqeR8e76rQS7N7MGv6RbTfKcl
   otKYGXx9nHQh3mcC40jJtlq2GMm4jaQPXnXmrDxHbSI0If5jZcRdJZMEo
   8IidqUoH5yXKXazRJP9VDVN8Of546G9oxCPuMtP82jS64ie++DQoWK+wN
   ytEaMH9yIBHYpP3qXceejpf8IaTPpbds1w6XnEObWHEK0OEQiwAwCC0S/
   GIAumIp8APgUcETrjaVd5cNw+b+fV7eO6iaUA+QhfXaLuIA5yr7Cvennf
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="329873842"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="329873842"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 08:31:59 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="617251555"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="617251555"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.24.100.114])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 08:31:59 -0800
Date:   Wed, 8 Feb 2023 08:35:36 -0800
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Raj Ashok <ashok.raj@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        stable@vger.kernel.org, Sukumar Ghorai <sukumar.ghorai@intel.com>,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v2] iommu/vt-d: Fix PASID directory pointer coherency
Message-ID: <20230208083536.3d8f5f7a@jacob-builder>
In-Reply-To: <18bbd442-c892-1f17-bf6c-b6d797379deb@linux.intel.com>
References: <20230208000938.1527079-1-jacob.jun.pan@linux.intel.com>
        <18bbd442-c892-1f17-bf6c-b6d797379deb@linux.intel.com>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Baolu,

On Wed, 8 Feb 2023 11:46:37 +0800, Baolu Lu <baolu.lu@linux.intel.com>
wrote:

> On 2023/2/8 8:09, Jacob Pan wrote:
> > On platforms that do not support IOMMU Extended capability bit 0
> > Page-walk Coherency, CPU caches are not snooped when IOMMU is accessing
> > any translation structures. IOMMU access goes only directly to
> > memory. Intel IOMMU code was missing a flush for the PASID table
> > directory that resulted in the unrecoverable fault as shown below.
> > 
> > This patch adds clflush calls whenever activating and updating
> > a PASID table directory to ensure cache coherency.
> > 
> > On the reverse direction, there's no need to clflush the PASID directory
> > pointer when we deactivate a context entry in that IOMMU hardware will
> > not see the old PASID directory pointer after we clear the context
> > entry. PASID directory entries are also never freed once allocated.
> > 
> > [    0.555386] DMAR: DRHD: handling fault status reg 3
> > [    0.555805] DMAR: [DMA Read NO_PASID] Request device [00:0d.2] fault
> > addr 0x1026a4000 [fault reason 0x51] SM: Present bit in Directory Entry
> > is clear [    0.556348] DMAR: Dump dmar1 table entries for IOVA
> > 0x1026a4000 [    0.556348] DMAR: scalable mode root entry: hi
> > 0x0000000102448001, low 0x0000000101b3e001 [    0.556348] DMAR: context
> > entry: hi 0x0000000000000000, low 0x0000000101b4d401 [    0.556348]
> > DMAR: pasid dir entry: 0x0000000101b4e001 [    0.556348] DMAR: pasid
> > table entry[0]: 0x0000000000000109 [    0.556348] DMAR: pasid table
> > entry[1]: 0x0000000000000001 [    0.556348] DMAR: pasid table entry[2]:
> > 0x0000000000000000 [    0.556348] DMAR: pasid table entry[3]:
> > 0x0000000000000000 [    0.556348] DMAR: pasid table entry[4]:
> > 0x0000000000000000 [    0.556348] DMAR: pasid table entry[5]:
> > 0x0000000000000000 [    0.556348] DMAR: pasid table entry[6]:
> > 0x0000000000000000 [    0.556348] DMAR: pasid table entry[7]:
> > 0x0000000000000000 [    0.556348] DMAR: PTE not present at level 4
> > 
> > Cc:<stable@vger.kernel.org>
> > Fixes: 0bbeb01a4faf ("iommu/vt-d: Manage scalalble mode PASID tables")
> > Reported-by: Sukumar Ghorai<sukumar.ghorai@intel.com>
> > Signed-off-by: Ashok Raj<ashok.raj@intel.com>
> > Signed-off-by: Jacob Pan<jacob.jun.pan@linux.intel.com>
> > ---
> > v2: Add clflush to PASID directory update case (Baolu, Kevin review)
> > ---
> >   drivers/iommu/intel/iommu.c | 2 ++
> >   drivers/iommu/intel/pasid.c | 2 ++
> >   2 files changed, 4 insertions(+)
> > 
> > diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> > index 59df7e42fd53..161342e7149d 100644
> > --- a/drivers/iommu/intel/iommu.c
> > +++ b/drivers/iommu/intel/iommu.c
> > @@ -1976,6 +1976,8 @@ static int domain_context_mapping_one(struct
> > dmar_domain *domain, pds = context_get_sm_pds(table);
> >   		context->lo = (u64)virt_to_phys(table->table) |
> >   				context_pdts(pds);
> > +		if (!ecap_coherent(iommu->ecap))
> > +			clflush_cache_range(table->table,
> > sizeof(u64));  
> 
> This leaves other pasid dir entries not clflush'ed. It is possible that
> IOMMU hardware sees different value from what CPU has set. This may
> leave security holes for malicious devices. It's same to the pasid entry
> table.
agreed, we need to address security and functional aspects. good point.

thanks

Jacob

> How about below change? It does clflush whenever CPU changes the pasid
> dir/entry tables.
> 
> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
> index fb3c7020028d..aeb0517826a2 100644
> --- a/drivers/iommu/intel/pasid.c
> +++ b/drivers/iommu/intel/pasid.c
> @@ -128,6 +128,9 @@ int intel_pasid_alloc_table(struct device *dev)
>          pasid_table->max_pasid = 1 << (order + PAGE_SHIFT + 3);
>          info->pasid_table = pasid_table;
> 
> +       if (!ecap_coherent(info->iommu->ecap))
> +               clflush_cache_range(pasid_table->table, size);
> +
>          return 0;
>   }
> 
> @@ -215,6 +218,11 @@ static struct pasid_entry 
> *intel_pasid_get_entry(struct device *dev, u32 pasid)
>                          free_pgtable_page(entries);
>                          goto retry;
>                  }
> +
> +               if (!ecap_coherent(info->iommu->ecap)) {
> +                       clflush_cache_range(entries, VTD_PAGE_SIZE);
> +                       clflush_cache_range(&dir[dir_index].val, 
> sizeof(*dir));
> +               }
>          }
> 
>          return &entries[index];
> 
> Best regards,
> baolu


Thanks,

Jacob
