Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C2368BB3F
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 12:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjBFLV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 06:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbjBFLVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 06:21:23 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9ACA722DE7;
        Mon,  6 Feb 2023 03:21:02 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 828E5C14;
        Mon,  6 Feb 2023 03:21:32 -0800 (PST)
Received: from [10.57.89.151] (unknown [10.57.89.151])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8AD653F8C6;
        Mon,  6 Feb 2023 03:20:48 -0800 (PST)
Message-ID: <4d90da14-8c08-62e1-814f-ee14fab375f8@arm.com>
Date:   Mon, 6 Feb 2023 11:20:44 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] iommu/vt-d: Avoid superfluous IOTLB tracking in lazy mode
Content-Language: en-GB
To:     Baolu Lu <baolu.lu@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Raj Ashok <ashok.raj@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        stable@vger.kernel.org, Sanjay Kumar <sanjay.k.kumar@intel.com>
References: <20230203230417.1287325-1-jacob.jun.pan@linux.intel.com>
 <ef65f1cf-d04c-8c35-7144-d30504bf7a1c@linux.intel.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <ef65f1cf-d04c-8c35-7144-d30504bf7a1c@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023-02-04 06:32, Baolu Lu wrote:
> On 2023/2/4 7:04, Jacob Pan wrote:
>> Intel IOMMU driver implements IOTLB flush queue with domain selective
>> or PASID selective invalidations. In this case there's no need to track
>> IOVA page range and sync IOTLBs, which may cause significant performance
>> hit.
> 
> [Add cc Robin]
> 
> If I understand this patch correctly, this might be caused by below
> helper:
> 
> /**
>   * iommu_iotlb_gather_add_page - Gather for page-based TLB invalidation
>   * @domain: IOMMU domain to be invalidated
>   * @gather: TLB gather data
>   * @iova: start of page to invalidate
>   * @size: size of page to invalidate
>   *
>   * Helper for IOMMU drivers to build invalidation commands based on 
> individual
>   * pages, or with page size/table level hints which cannot be gathered 
> if they
>   * differ.
>   */
> static inline void iommu_iotlb_gather_add_page(struct iommu_domain *domain,
>                                                 struct 
> iommu_iotlb_gather *gather,
>                                                 unsigned long iova, 
> size_t size)
> {
>          /*
>           * If the new page is disjoint from the current range or is 
> mapped at
>           * a different granularity, then sync the TLB so that the gather
>           * structure can be rewritten.
>           */
>          if ((gather->pgsize && gather->pgsize != size) ||
>              iommu_iotlb_gather_is_disjoint(gather, iova, size))
>                  iommu_iotlb_sync(domain, gather);
> 
>          gather->pgsize = size;
>          iommu_iotlb_gather_add_range(gather, iova, size);
> }
> 
> As the comments for iommu_iotlb_gather_is_disjoint() says,
> 
> "...For many IOMMUs, flushing the IOMMU in this case is better
>   than merging the two, which might lead to unnecessary invalidations.
>   ..."
> 
> So, perhaps the right fix for this performance issue is to add
> 
>      if (!gather->queued)
> 
> in iommu_iotlb_gather_add_page() or iommu_iotlb_gather_is_disjoint()?
> It should benefit other arch's as well.

The iotlb_gather helpers are really just that - little tools to help 
drivers with various common iotlb_gather accounting patterns. The 
decision whether to bother with that accounting at all should really 
come beforehand, and whether a driver supports flush queues is 
orthogonal to whether it uses any particular gather helper(s) or not, so 
I think the patch as-is is correct.

>> This patch adds a check to avoid IOVA gather page and IOTLB sync for
>> the lazy path.
>>
>> The performance difference on Sapphire Rapids 100Gb NIC is improved by
>> the following (as measured by iperf send):
> 
> Which test case have you done? Post the real data if you have any.
> 
>>
>> w/o this fix~48 Gbits/s. with this fix ~54 Gbits/s
>>
>> Cc: <stable@vger.kernel.org>
> 
> Again, add a Fixes tag so that people know how far this fix should be
> back ported.

Note that the overall issue probably dates back to the initial iommu-dma 
conversion, but if you think it's important enough to go back beyond 
5.15 when gather->queued was introduced, that'll need a different fix.

Cheers,
Robin.
