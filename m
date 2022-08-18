Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8D03598212
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 13:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244323AbiHRLNV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 07:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244316AbiHRLNU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 07:13:20 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AC51132;
        Thu, 18 Aug 2022 04:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660821199; x=1692357199;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Q6bejHNbuks/D/XWIoTaxaxn4NjhAHgyJDnpMYChr3o=;
  b=U/tsV3EtIAGbvTShxtHg5ZXJRGLSMvS+841v9gqKsGNKfqB4AzU3+5N9
   hLCnvSy1MXvtl6px8tpuILftuZtdau1BEJ9FvrUOQCIIYxQRhLr4TwEdt
   orrM4AZG5ub35xnUcF7iHG4eCixOoxK6kxS7+xf4uO3auNi1bddOw3JUv
   /nWEw1BCPBFww/zVUWib8ebGx00m/qYew6/QAg4ZEox1xUUcb+AeW4Iyu
   raxWyvsOasEIY6n/me4q3ufr9GuTea6YWk7ke9IPBeCyOW8HCUn91k+gu
   E+egternAVIXmdpq/MghFHWweA0/NQvb9vdm4fY2SxHafEApM3si2VWSN
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="294007767"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="294007767"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 04:13:18 -0700
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="668061559"
Received: from gaoshunl-mobl.ccr.corp.intel.com (HELO [10.254.209.211]) ([10.254.209.211])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 04:13:15 -0700
Message-ID: <11e8ceac-97a5-c8ea-73c3-760929bca263@linux.intel.com>
Date:   Thu, 18 Aug 2022 19:13:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        "Jin, Wen" <wen.jin@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] iommu/vt-d: Fix kdump kernels boot failure with
 scalable mode
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
References: <20220817011035.3250131-1-baolu.lu@linux.intel.com>
 <BN9PR11MB5276364739832848F15932B68C6D9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB5276364739832848F15932B68C6D9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/8/18 16:32, Tian, Kevin wrote:
>> From: Lu Baolu <baolu.lu@linux.intel.com>
>> Sent: Wednesday, August 17, 2022 9:11 AM
>>
>> The translation table copying code for kdump kernels is currently based
>> on the extended root/context entry formats of ECS mode defined in older
>> VT-d v2.5, and doesn't handle the scalable mode formats. This causes
>> the kexec capture kernel boot failure with DMAR faults if the IOMMU was
>> enabled in scalable mode by the previous kernel.
>>
>> The ECS mode has already been deprecated by the VT-d spec since v3.0 and
>> Intel IOMMU driver doesn't support this mode as there's no real hardware
>> implementation. Hence this converts ECS checking in copying table code
>> into scalable mode.
>>
>> The existing copying code consumes a bit in the context entry as a mark
>> of copied entry. This marker needs to work for the old format as well as
>> for extended context entries. It's hard to find such a bit for both
> 
> The 2nd sentence "This marker..." is misleading. better removed.

Okay. I will make it like "It needs to work for ...".

> 
>> legacy and scalable mode context entries. This replaces it with a per-
>> IOMMU bitmap.
>>
>> Fixes: 7373a8cc38197 ("iommu/vt-d: Setup context and enable RID2PASID
>> support")
>> Cc: stable@vger.kernel.org
>> Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
>> Tested-by: Wen Jin <wen.jin@intel.com>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ...
>> @@ -2735,8 +2693,8 @@ static int copy_translation_tables(struct
>> intel_iommu *iommu)
>>   	bool new_ext, ext;
>>
>>   	rtaddr_reg = dmar_readq(iommu->reg + DMAR_RTADDR_REG);
>> -	ext        = !!(rtaddr_reg & DMA_RTADDR_RTT);
>> -	new_ext    = !!ecap_ecs(iommu->ecap);
>> +	ext        = !!(rtaddr_reg & DMA_RTADDR_SMT);
>> +	new_ext    = !!ecap_smts(iommu->ecap);
> 
> should be !!sm_supported()

Not really. The IOMMU was setup by the previous kernel. Here we just
check whether the scalable mode was enabled there.

> 
>>
>>   	/*
>>   	 * The RTT bit can only be changed when translation is disabled,
>> @@ -2747,6 +2705,10 @@ static int copy_translation_tables(struct
>> intel_iommu *iommu)
>>   	if (new_ext != ext)
>>   		return -EINVAL;
>>
>> +	iommu->copied_tables = bitmap_zalloc(BIT_ULL(16), GFP_KERNEL);
>> +	if (!iommu->copied_tables)
>> +		return -ENOMEM;
>> +
>>   	old_rt_phys = rtaddr_reg & VTD_PAGE_MASK;
>>   	if (!old_rt_phys)
>>   		return -EINVAL;
> 
> Out of curiosity. What is the rationale that we copy root table and
> context tables but not pasid tables?

We only copy the context table and reconstruct it when the default
domain is attached. Before that, there's no need to reconstruct the
pasid table, hence it's safe to use the previous pasid tables.

Best regards,
baolu
