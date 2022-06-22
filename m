Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56359554CF4
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 16:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355707AbiFVO1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 10:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356938AbiFVO1Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 10:27:16 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB9D3A19B;
        Wed, 22 Jun 2022 07:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655908035; x=1687444035;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vySRlmuNAAv4jlQBiztxT2Pq5CPlKHqWqSX5MtbK29c=;
  b=JctRdgxDB4LQNgp0SMzAXtyQ64cjOQu8SoP3Vk+ogUtkaEWLwaolzvV0
   OAzcgFLW7qw+2wvNINseo38fk6zhVODTRo9iuvPRwortfOX9QuO6BirO8
   yd7kpLPstzB0Zt0qEXg2H2xsjMlXoC7J4khwva/7gmOTfFFGHRC9HL+YV
   3Efasdw5X7ml5T23B8qU+MX3QAg8RZ2VoPei6PuBWke5zhFTo10t0qPte
   9z5RNSaSTRkDnsZVau1udLj1CIuQR2c0/qidq3mE+Vbb5OShA1bvzLr2X
   CPk2RjPvSYxGAfjHRnKXnGGH1aH6fjBsd87/FYz6fnE3uWXoplY4NMK9P
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="281504950"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="281504950"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 07:27:13 -0700
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="834137199"
Received: from xzhan99-mobl1.ccr.corp.intel.com (HELO [10.249.172.26]) ([10.249.172.26])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 07:27:10 -0700
Message-ID: <339eb9cc-e65d-eaf7-e4fa-44a99797e026@linux.intel.com>
Date:   Wed, 22 Jun 2022 22:27:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Cc:     baolu.lu@linux.intel.com, Chenyi Qiang <chenyi.qiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        iommu@lists.linux-foundation.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] iommu/vt-d: Fix RID2PASID setup failure
Content-Language: en-US
To:     Ethan Zhao <haifeng.zhao@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
References: <20220622044120.21813-1-baolu.lu@linux.intel.com>
 <b7834cb5-4836-fb2d-1570-a46440341bed@linux.intel.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <b7834cb5-4836-fb2d-1570-a46440341bed@linux.intel.com>
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

On 2022/6/22 17:09, Ethan Zhao wrote:
> 
> 在 2022/6/22 12:41, Lu Baolu 写道:
>> The IOMMU driver shares the pasid table for PCI alias devices. When the
>> RID2PASID entry of the shared pasid table has been filled by the first
>> device, the subsequent devices will encounter the "DMAR: Setup RID2PASID
>> failed" failure as the pasid entry has already been marked as present. As
>> the result, the IOMMU probing process will be aborted.
>>
>> This fixes it by skipping RID2PASID setting if the pasid entry has been
>> populated. This works because the IOMMU core ensures that only the same
>> IOMMU domain can be attached to all PCI alias devices at the same time.
>> Therefore the subsequent devices just try to setup the RID2PASID entry
>> with the same domain, which is negligible. This also adds domain validity
>> checks for more confidence anyway.
>>
>> Fixes: ef848b7e5a6a0 ("iommu/vt-d: Setup pasid entry for RID2PASID 
>> support")
>> Reported-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   drivers/iommu/intel/pasid.c | 22 ++++++++++++++++------
>>   1 file changed, 16 insertions(+), 6 deletions(-)
>>
>> Change log:
>> v2:
>>   - Add domain validity check in RID2PASID entry setup.
>>
>> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
>> index cb4c1d0cf25c..4f3525f3346f 100644
>> --- a/drivers/iommu/intel/pasid.c
>> +++ b/drivers/iommu/intel/pasid.c
>> @@ -575,6 +575,19 @@ static inline int pasid_enable_wpe(struct 
>> pasid_entry *pte)
>>       return 0;
>>   };
>> +/*
>> + * Return true if @pasid is RID2PASID and the domain @did has already
>> + * been setup to the @pte. Otherwise, return false. PCI alias devices
>> + * probably share the single RID2PASID pasid entry in the shared pasid
>> + * table. It's reasonable that those devices try to set a share domain
>> + * in their probe paths.
>> + */
> 
> I am thinking about the counter-part, the intel_pasid_tear_down_entry(),
> 
> Multi devices share the same PASID entry, then one was detached from the 
> domain,
> 
> so the entry doesn't exist anymore, while another devices don't know 
> about the change,
> 
> and they are using the mapping, is it possible case ？shared thing, no 
> refer-counter,
> 
> am I missing something ?

No. You are right. When any alias device is hot-removed from the system,
the shared RID2PASID will be cleared without any notification to other
devices. Hence any DMAs from those devices are blocked.

We still have a lot to do for sharing pasid table among alias devices.
Before we arrive there, let's remove it for now.

Best regards,
baolu
