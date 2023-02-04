Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEC868A801
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 04:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbjBDDnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 22:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjBDDnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 22:43:13 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D088E1C7CC;
        Fri,  3 Feb 2023 19:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675482186; x=1707018186;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uMsa6W80lQBbzaUuhOxR/OchovtSZ5wheoHgf4HWRHM=;
  b=B2Naam2E9jwDgErtfPuY5Jj4+1z+rK3OnTNA14wwdQmDPYNqRriF3kSc
   tBN6i8926iJZeEsX7IokqJuZf3G1Gue8KB5NolQ6tGdZ7AdJcYEoHUDv3
   mCqfA2durKqcHn2CrJmqvuOH847WGbGorGqvF4rplY54my2Gud9BgULNr
   AAenP9bncCKjUqdrLmbf8oW2y2Nq5A0ka0L7HPUuSfj/PE0HCSKnmDgr/
   JEwqa5rcwJfpZTra0+ccBrDqJOmf22U1Kke0IGTQZZI4fGIDMrn+AZ5EF
   w+92NrF5WIIdz6rJx0GD0d0XNPTOpPPRmiEAxGhll84f80LU/dfhNdkDI
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="356258914"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="356258914"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 19:43:06 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="808552631"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="808552631"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.249.174.222]) ([10.249.174.222])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 19:43:04 -0800
Message-ID: <de4d0617-ceef-efca-69f1-a095ce91588e@linux.intel.com>
Date:   Sat, 4 Feb 2023 11:43:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Cc:     baolu.lu@linux.intel.com, David Woodhouse <dwmw2@infradead.org>,
        Raj Ashok <ashok.raj@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        stable@vger.kernel.org, Sukumar Ghorai <sukumar.ghorai@intel.com>
Subject: Re: [PATCH] iommu/vt-d: Fix PASID directory pointer coherency
Content-Language: en-US
To:     Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>
References: <20230203220714.1283383-1-jacob.jun.pan@linux.intel.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20230203220714.1283383-1-jacob.jun.pan@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023/2/4 6:07, Jacob Pan wrote:
> On platforms that do not support IOMMU Extended capability bit 0
> Page-walk Coherency, CPU caches are not snooped when IOMMU is accessing
> any translation structures. IOMMU access goes only directly to
> memory. Intel IOMMU code was missing a flush for the PASID table
> directory that resulted in the unrecoverable fault as shown below.

Thanks for the fix.

> This patch adds a clflush when activating a PASID table directory.
> There's no need to do clflush of the PASID directory pointer when we
> deactivate a context entry in that IOMMU hardware will not see the old
> PASID directory pointer after we clear the context entry.
> 
> [    0.555386] DMAR: DRHD: handling fault status reg 3
> [    0.555805] DMAR: [DMA Read NO_PASID] Request device [00:0d.2] fault addr 0x1026a4000 [fault reason 0x51] SM: Present bit in Directory Entry is clear
> [    0.556348] DMAR: Dump dmar1 table entries for IOVA 0x1026a4000
> [    0.556348] DMAR: scalable mode root entry: hi 0x0000000102448001, low 0x0000000101b3e001
> [    0.556348] DMAR: context entry: hi 0x0000000000000000, low 0x0000000101b4d401
> [    0.556348] DMAR: pasid dir entry: 0x0000000101b4e001
> [    0.556348] DMAR: pasid table entry[0]: 0x0000000000000109
> [    0.556348] DMAR: pasid table entry[1]: 0x0000000000000001
> [    0.556348] DMAR: pasid table entry[2]: 0x0000000000000000
> [    0.556348] DMAR: pasid table entry[3]: 0x0000000000000000
> [    0.556348] DMAR: pasid table entry[4]: 0x0000000000000000
> [    0.556348] DMAR: pasid table entry[5]: 0x0000000000000000
> [    0.556348] DMAR: pasid table entry[6]: 0x0000000000000000
> [    0.556348] DMAR: pasid table entry[7]: 0x0000000000000000
> [    0.556348] DMAR: PTE not present at level 4
> 
> Cc: <stable@vger.kernel.org>
> Reported-by: Sukumar Ghorai <sukumar.ghorai@intel.com>
> Signed-off-by: Ashok Raj <ashok.raj@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

Add a Fixes tag so that people know how far this fix should be back
ported.

> ---
>   drivers/iommu/intel/iommu.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 59df7e42fd53..b4878c7ac008 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -1976,6 +1976,12 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
>   		pds = context_get_sm_pds(table);
>   		context->lo = (u64)virt_to_phys(table->table) |
>   				context_pdts(pds);
> +		/*
> +		 * Scalable-mode PASID directory pointer is not snooped if the
> +		 * coherent bit is not set.
> +		 */
> +		if (!ecap_coherent(iommu->ecap))
> +			clflush_cache_range(table->table, sizeof(void *));

This isn't comprehensive. The clflush should be called whenever the
pasid directory table is allocated or updated.

>   
>   		/* Setup the RID_PASID field: */
>   		context_set_sm_rid2pasid(context, PASID_RID2PASID);

Best regards,
baolu
