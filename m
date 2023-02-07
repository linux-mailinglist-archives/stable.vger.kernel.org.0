Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB5068CFAF
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 07:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjBGGpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 01:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjBGGpn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 01:45:43 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533D11BE7;
        Mon,  6 Feb 2023 22:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675752342; x=1707288342;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=AaUf0zG3WU35FnYxi/A+oYi6a97oKHZ4rYfEtRF+/Vc=;
  b=EjbtUhxgPCXJ6j/vBKEij8VCF26PoEBNGWRXK5ZgvUa1ZsUvERHqjrI5
   aNCK+X58W4eMXIt19CG+uLXEGomACoQasiBf7v8amesPpKBg/V38TWJkx
   ZnaoOdhVJ9uB3DeDI1roPb0CTb+So2vXgjgZi8wgxTYmmyJUEcEpHeFW0
   LPdJjN5GmgnrlRKq+XQ5jMWCoUP49Hhrfsjqgi7ZWusyglSg84xwGPwR2
   hNslj7cVO2jWSUfu0ZXHGOzv9oH48xZAcDtw0CrEq/rjhYNZlcCD8VKBY
   mVXKNb+BWZpEzbYThcN8mdrToComhuAh5fcGf8gEJqkGJ70EW5FhA2YE4
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="329441402"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="329441402"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 22:45:42 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="668680659"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="668680659"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.209.26]) ([10.254.209.26])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 22:45:39 -0800
Message-ID: <b190ddb3-eb1d-cd72-ce03-1127af228bf0@linux.intel.com>
Date:   Tue, 7 Feb 2023 14:45:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Cc:     baolu.lu@linux.intel.com, David Woodhouse <dwmw2@infradead.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH] iommu/vt-d: Avoid superfluous IOTLB tracking in lazy mode
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Joerg Roedel <joro@8bytes.org>
References: <20230203230417.1287325-1-jacob.jun.pan@linux.intel.com>
 <ef65f1cf-d04c-8c35-7144-d30504bf7a1c@linux.intel.com>
 <BN9PR11MB52764498929E4978B3A8740D8CDA9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB52764498929E4978B3A8740D8CDA9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023/2/6 11:48, Tian, Kevin wrote:
>> From: Baolu Lu <baolu.lu@linux.intel.com>
>> Sent: Saturday, February 4, 2023 2:32 PM
>>
>> On 2023/2/4 7:04, Jacob Pan wrote:
>>> Intel IOMMU driver implements IOTLB flush queue with domain selective
>>> or PASID selective invalidations. In this case there's no need to track
>>> IOVA page range and sync IOTLBs, which may cause significant
>> performance
>>> hit.
>>
>> [Add cc Robin]
>>
>> If I understand this patch correctly, this might be caused by below
>> helper:
>>
>> /**
>>    * iommu_iotlb_gather_add_page - Gather for page-based TLB invalidation
>>    * @domain: IOMMU domain to be invalidated
>>    * @gather: TLB gather data
>>    * @iova: start of page to invalidate
>>    * @size: size of page to invalidate
>>    *
>>    * Helper for IOMMU drivers to build invalidation commands based on
>> individual
>>    * pages, or with page size/table level hints which cannot be gathered
>> if they
>>    * differ.
>>    */
>> static inline void iommu_iotlb_gather_add_page(struct iommu_domain
>> *domain,
>>                                                  struct
>> iommu_iotlb_gather *gather,
>>                                                  unsigned long iova,
>> size_t size)
>> {
>>           /*
>>            * If the new page is disjoint from the current range or is
>> mapped at
>>            * a different granularity, then sync the TLB so that the gather
>>            * structure can be rewritten.
>>            */
>>           if ((gather->pgsize && gather->pgsize != size) ||
>>               iommu_iotlb_gather_is_disjoint(gather, iova, size))
>>                   iommu_iotlb_sync(domain, gather);
>>
>>           gather->pgsize = size;
>>           iommu_iotlb_gather_add_range(gather, iova, size);
>> }
>>
>> As the comments for iommu_iotlb_gather_is_disjoint() says,
>>
>> "...For many IOMMUs, flushing the IOMMU in this case is better
>>    than merging the two, which might lead to unnecessary invalidations.
>>    ..."
>>
>> So, perhaps the right fix for this performance issue is to add
>>
>> 	if (!gather->queued)
>>
>> in iommu_iotlb_gather_add_page() or iommu_iotlb_gather_is_disjoint()?
>> It should benefit other arch's as well.
>>
> 
> There are only two callers of this helper: intel and arm-smmu-v3.
> 
> Looks other drivers just implements direct flush via io_pgtable_tlb_add_page().
> 
> and their unmap callback typically does:
> 
> if (!iommu_iotlb_gather_queued(gather))
> 	io_pgtable_tlb_add_page();
> 
> from this angle it's same policy as Jacob's does, i.e. if it's already
> queued then no need to further call optimization for direct flush.

Perhaps we can use iommu_iotlb_gather_queued() to replace direct
gather->queued check in this patch as well?

Best regards,
baolu
