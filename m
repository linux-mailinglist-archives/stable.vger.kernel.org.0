Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D319168CF9F
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 07:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjBGGmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 01:42:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjBGGmb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 01:42:31 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C525F4C1D;
        Mon,  6 Feb 2023 22:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675752148; x=1707288148;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1THSEr5oL6UyWmp1MZ/7OTIi8oyobqTFm9kIlDCpJsY=;
  b=U4uGQfw0UebZ+T4GYA5rVl5o1peocyna6NLqI8XCEMWiwkckQ5D15oGV
   RUUq9kN74+u56+lLN6SPVyrBoJTpsvxheDcPoJ97kDfLcEvt6cx18wDM7
   Z4zXacbmfkQ/MKu7r92/vr2uny6kPsIgb/YkBVPgWS4w9fYrpNZlzOjD2
   hVse6YmCBzHOW6ojCPTLyt3hrFrEmQ7RgteOi260pc0v3k11Voguq4gcI
   vCKqWMmfM/d5y/IGEFaxWaQ1kuaxF60slBL9Db5VrEqUd7ePD/D+QsI7F
   ARy1ymtomMF/yevsYIQ3v5eEyTjQLHrE8X7ITnRMqyD0M4eVX3uZsAm4g
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="328060877"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="328060877"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 22:42:11 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="755526126"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="755526126"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.209.26]) ([10.254.209.26])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 22:42:08 -0800
Message-ID: <8ab16dfb-8fd1-2035-c191-1b22f72eb30e@linux.intel.com>
Date:   Tue, 7 Feb 2023 14:42:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Cc:     baolu.lu@linux.intel.com, David Woodhouse <dwmw2@infradead.org>,
        Raj Ashok <ashok.raj@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        stable@vger.kernel.org, Sanjay Kumar <sanjay.k.kumar@intel.com>
Subject: Re: [PATCH] iommu/vt-d: Avoid superfluous IOTLB tracking in lazy mode
Content-Language: en-US
To:     Robin Murphy <robin.murphy@arm.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>
References: <20230203230417.1287325-1-jacob.jun.pan@linux.intel.com>
 <ef65f1cf-d04c-8c35-7144-d30504bf7a1c@linux.intel.com>
 <4d90da14-8c08-62e1-814f-ee14fab375f8@arm.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <4d90da14-8c08-62e1-814f-ee14fab375f8@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023/2/6 19:20, Robin Murphy wrote:
> On 2023-02-04 06:32, Baolu Lu wrote:
>> On 2023/2/4 7:04, Jacob Pan wrote:
>>> Intel IOMMU driver implements IOTLB flush queue with domain selective
>>> or PASID selective invalidations. In this case there's no need to track
>>> IOVA page range and sync IOTLBs, which may cause significant performance
>>> hit.
>>
>> [Add cc Robin]
>>
>> If I understand this patch correctly, this might be caused by below
>> helper:
>>
>> /**
>>   * iommu_iotlb_gather_add_page - Gather for page-based TLB invalidation
>>   * @domain: IOMMU domain to be invalidated
>>   * @gather: TLB gather data
>>   * @iova: start of page to invalidate
>>   * @size: size of page to invalidate
>>   *
>>   * Helper for IOMMU drivers to build invalidation commands based on 
>> individual
>>   * pages, or with page size/table level hints which cannot be 
>> gathered if they
>>   * differ.
>>   */
>> static inline void iommu_iotlb_gather_add_page(struct iommu_domain 
>> *domain,
>>                                                 struct 
>> iommu_iotlb_gather *gather,
>>                                                 unsigned long iova, 
>> size_t size)
>> {
>>          /*
>>           * If the new page is disjoint from the current range or is 
>> mapped at
>>           * a different granularity, then sync the TLB so that the gather
>>           * structure can be rewritten.
>>           */
>>          if ((gather->pgsize && gather->pgsize != size) ||
>>              iommu_iotlb_gather_is_disjoint(gather, iova, size))
>>                  iommu_iotlb_sync(domain, gather);
>>
>>          gather->pgsize = size;
>>          iommu_iotlb_gather_add_range(gather, iova, size);
>> }
>>
>> As the comments for iommu_iotlb_gather_is_disjoint() says,
>>
>> "...For many IOMMUs, flushing the IOMMU in this case is better
>>   than merging the two, which might lead to unnecessary invalidations.
>>   ..."
>>
>> So, perhaps the right fix for this performance issue is to add
>>
>>      if (!gather->queued)
>>
>> in iommu_iotlb_gather_add_page() or iommu_iotlb_gather_is_disjoint()?
>> It should benefit other arch's as well.
> 
> The iotlb_gather helpers are really just that - little tools to help 
> drivers with various common iotlb_gather accounting patterns. The 
> decision whether to bother with that accounting at all should really 
> come beforehand, and whether a driver supports flush queues is 
> orthogonal to whether it uses any particular gather helper(s) or not, so 
> I think the patch as-is is correct.

Okay, that's fine. Thanks for the explanation.

> 
>>> This patch adds a check to avoid IOVA gather page and IOTLB sync for
>>> the lazy path.
>>>
>>> The performance difference on Sapphire Rapids 100Gb NIC is improved by
>>> the following (as measured by iperf send):
>>
>> Which test case have you done? Post the real data if you have any.
>>
>>>
>>> w/o this fix~48 Gbits/s. with this fix ~54 Gbits/s
>>>
>>> Cc: <stable@vger.kernel.org>
>>
>> Again, add a Fixes tag so that people know how far this fix should be
>> back ported.
> 
> Note that the overall issue probably dates back to the initial iommu-dma 
> conversion, but if you think it's important enough to go back beyond 
> 5.15 when gather->queued was introduced, that'll need a different fix.

So perhaps

Cc: stable@vger.kernel.org # 5.15+

is enough?

Best regards,
baolu
