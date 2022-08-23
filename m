Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7F759D07D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 07:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240019AbiHWFdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 01:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238558AbiHWFdq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 01:33:46 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A93192AF;
        Mon, 22 Aug 2022 22:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661232825; x=1692768825;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6i2RpXaeSR7jqoTd/Rc9CeF8XiQpcxD4PplfZTVczFs=;
  b=CistSN1Y2ss4zj6CKxKJvwXxh+wylw8NpYjdEoMDzFXK1fAf7GS11YV4
   ZP2MCs0PYXpT6VpV14eZI8p8KTP1VJvOXW2IQRGqG5j62d2RmZbMNL35J
   0Pt7OyqMIaTH2D+6o/FZ+s3b/u5srBOwe9377IrFuYGPCSI9X/xZtqWaJ
   qQqY3rVjUKK0620sDndqldqkEF9mBNwaE8+izFRglVWsR+7b0Z2ngTsAR
   LJ4lQiMgF29XSPKbszy0VJtBlIg5edtctJu9dyOrtX1Px0pmplZv7We5h
   9dbu2TFr9skqgdXYZEu0JcBkrW7Ozhej11tfza67TU7PgQHV4/9I2xCiw
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="293593899"
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="293593899"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 22:33:44 -0700
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="642310659"
Received: from xujinlon-mobl.ccr.corp.intel.com (HELO [10.254.211.102]) ([10.254.211.102])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 22:33:42 -0700
Message-ID: <dce4044b-071a-263d-9bf5-fccc06a5619a@linux.intel.com>
Date:   Tue, 23 Aug 2022 13:33:40 +0800
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
 <11e8ceac-97a5-c8ea-73c3-760929bca263@linux.intel.com>
 <BN9PR11MB52763F4F7641AEA6D942E88A8C719@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB52763F4F7641AEA6D942E88A8C719@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/8/22 12:42, Tian, Kevin wrote:
>> From: Baolu Lu <baolu.lu@linux.intel.com>
>> Sent: Thursday, August 18, 2022 7:13 PM
>>>>    	rtaddr_reg = dmar_readq(iommu->reg + DMAR_RTADDR_REG);
>>>> -	ext        = !!(rtaddr_reg & DMA_RTADDR_RTT);
>>>> -	new_ext    = !!ecap_ecs(iommu->ecap);
>>>> +	ext        = !!(rtaddr_reg & DMA_RTADDR_SMT);
>>>> +	new_ext    = !!ecap_smts(iommu->ecap);
>>>
>>> should be !!sm_supported()
>>
>> Not really. The IOMMU was setup by the previous kernel. Here we just
>> check whether the scalable mode was enabled there.
> 
> You want to compare whether old kernel and new kernel enable
> the same mode. ecap_smts is only about the capability. only
> sm_supported() can tell the mode which is actually used by the
> new kernel.

Oh, yes! You are right. I will update this.

> 
>>
>>>
>>>>
>>>>    	/*
>>>>    	 * The RTT bit can only be changed when translation is disabled,
>>>> @@ -2747,6 +2705,10 @@ static int copy_translation_tables(struct
>>>> intel_iommu *iommu)
>>>>    	if (new_ext != ext)
>>>>    		return -EINVAL;
>>>>
>>>> +	iommu->copied_tables = bitmap_zalloc(BIT_ULL(16), GFP_KERNEL);
>>>> +	if (!iommu->copied_tables)
>>>> +		return -ENOMEM;
>>>> +
>>>>    	old_rt_phys = rtaddr_reg & VTD_PAGE_MASK;
>>>>    	if (!old_rt_phys)
>>>>    		return -EINVAL;
>>>
>>> Out of curiosity. What is the rationale that we copy root table and
>>> context tables but not pasid tables?
>>
>> We only copy the context table and reconstruct it when the default
>> domain is attached. Before that, there's no need to reconstruct the
>> pasid table, hence it's safe to use the previous pasid tables.
>>
> 
> I still didn't get why context table must be reconstructed but not
> pasid table...

The pasid table is also reconstructed. The context table entry and the
pasid tables are reconstructed together, hence there's no need to copy
the pasid table.

Best regards,
baolu
