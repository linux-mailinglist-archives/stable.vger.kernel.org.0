Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21E3F68A898
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 07:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjBDGc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Feb 2023 01:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBDGc1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Feb 2023 01:32:27 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F051E8E4BF;
        Fri,  3 Feb 2023 22:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675492347; x=1707028347;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=c9MWOk417jgYAUtj8OibMlrNZDfXOevXrLxGBX6HBS4=;
  b=B2f2HCV8CzdTPSXBhFIzswsKR9Up5/zwh6akRe27ojYQzWQjV2kMxdx2
   dFmVZEcUyyKKIVZKfuSiFE2eqinFIVF6+7MIGieUBDS4Q/2pkm397ExBl
   yBEAtRFpL/CLgsbI0hjTZetaKQcx9N84xbNAhCyavW3lrE6atrckCVCVm
   ZHzUv+SEIxplpwagggHi5DNsqSKoqiCo/N60ZoYYl9JAzSmO1ehhuTtkv
   r25HdaafVwop30Ju/usu+KEDZfyCzOs3i/HC/lQsmZhydYSCtw6kP3WDP
   sW2r+IGF9HV/VYfbPjuLnNdwunY00R7YIETLGzhLumjbqRQXaB+TAZ8qW
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="330213904"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="330213904"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 22:32:26 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="734595531"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="734595531"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.210.69]) ([10.254.210.69])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 22:32:22 -0800
Message-ID: <ef65f1cf-d04c-8c35-7144-d30504bf7a1c@linux.intel.com>
Date:   Sat, 4 Feb 2023 14:32:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Cc:     baolu.lu@linux.intel.com, David Woodhouse <dwmw2@infradead.org>,
        Raj Ashok <ashok.raj@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        stable@vger.kernel.org, Sanjay Kumar <sanjay.k.kumar@intel.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH] iommu/vt-d: Avoid superfluous IOTLB tracking in lazy mode
Content-Language: en-US
To:     Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>
References: <20230203230417.1287325-1-jacob.jun.pan@linux.intel.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20230203230417.1287325-1-jacob.jun.pan@linux.intel.com>
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

On 2023/2/4 7:04, Jacob Pan wrote:
> Intel IOMMU driver implements IOTLB flush queue with domain selective
> or PASID selective invalidations. In this case there's no need to track
> IOVA page range and sync IOTLBs, which may cause significant performance
> hit.

[Add cc Robin]

If I understand this patch correctly, this might be caused by below
helper:

/**
  * iommu_iotlb_gather_add_page - Gather for page-based TLB invalidation
  * @domain: IOMMU domain to be invalidated
  * @gather: TLB gather data
  * @iova: start of page to invalidate
  * @size: size of page to invalidate
  *
  * Helper for IOMMU drivers to build invalidation commands based on 
individual
  * pages, or with page size/table level hints which cannot be gathered 
if they
  * differ.
  */
static inline void iommu_iotlb_gather_add_page(struct iommu_domain *domain,
                                                struct 
iommu_iotlb_gather *gather,
                                                unsigned long iova, 
size_t size)
{
         /*
          * If the new page is disjoint from the current range or is 
mapped at
          * a different granularity, then sync the TLB so that the gather
          * structure can be rewritten.
          */
         if ((gather->pgsize && gather->pgsize != size) ||
             iommu_iotlb_gather_is_disjoint(gather, iova, size))
                 iommu_iotlb_sync(domain, gather);

         gather->pgsize = size;
         iommu_iotlb_gather_add_range(gather, iova, size);
}

As the comments for iommu_iotlb_gather_is_disjoint() says,

"...For many IOMMUs, flushing the IOMMU in this case is better
  than merging the two, which might lead to unnecessary invalidations.
  ..."

So, perhaps the right fix for this performance issue is to add

	if (!gather->queued)

in iommu_iotlb_gather_add_page() or iommu_iotlb_gather_is_disjoint()?
It should benefit other arch's as well.

> 
> This patch adds a check to avoid IOVA gather page and IOTLB sync for
> the lazy path.
> 
> The performance difference on Sapphire Rapids 100Gb NIC is improved by
> the following (as measured by iperf send):

Which test case have you done? Post the real data if you have any.

> 
> w/o this fix~48 Gbits/s. with this fix ~54 Gbits/s
> 
> Cc: <stable@vger.kernel.org>

Again, add a Fixes tag so that people know how far this fix should be
back ported.

> Tested-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
> Signed-off-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

Best regards,
baolu

