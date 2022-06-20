Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB3CB551387
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 10:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239573AbiFTI6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 04:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239295AbiFTI6I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 04:58:08 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3685B223;
        Mon, 20 Jun 2022 01:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655715475; x=1687251475;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=27Tz/dNkwLMoj/0Mc6AnPbKP/6tdnuKXsgwtLD/28Fk=;
  b=PWDF40cFVfW8eH8ywitl8lI0j3iRzW7cWjWJGxqzyspSKRyRXBhNg3TU
   DTc8W+EGNcs6cuMRrY8H6ConFVTnesKLwUwnnTZ0OaV5UcGx7k90L9Udm
   HMvOsSYhqGzSX8pn7nJG4b+3xs33AadcYxgnufAYKTRRRclWPDTeBn8rp
   arR2EdduyJGErpku+vQ4mEKB0UBHkBKlp4tsrjipOn/3JJbxAsqYVxyYX
   p88Qrqiuc/aqYPve6ruNuZ69gVMly6q/kXhSAt4ilyjire3qw1lIVfxML
   vJsgyKMoRwwrEAxJdPaOutAxzGxw0yc6yxd3Uasy0W/7Ja0G5bG5aavxU
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="260275239"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="260275239"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 01:57:55 -0700
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="643019952"
Received: from lgao7-mobl2.ccr.corp.intel.com (HELO [10.255.31.74]) ([10.255.31.74])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 01:57:52 -0700
Message-ID: <868f515e-a4ea-8c34-7317-5aba18f8d5f0@linux.intel.com>
Date:   Mon, 20 Jun 2022 16:57:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Cc:     baolu.lu@linux.intel.com, Chenyi Qiang <chenyi.qiang@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] iommu/vt-d: Fix RID2PASID setup failure
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
References: <20220620081729.4610-1-baolu.lu@linux.intel.com>
 <03e70268-aadc-7ad2-276b-bf029487a5de@intel.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <03e70268-aadc-7ad2-276b-bf029487a5de@intel.com>
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

On 2022/6/20 16:31, Yi Liu wrote:
> Hi Baolu,
> 
> On 2022/6/20 16:17, Lu Baolu wrote:
>> The IOMMU driver shares the pasid table for PCI alias devices. When the
>> RID2PASID entry of the shared pasid table has been filled by the first
>> device, the subsequent devices will encounter the "DMAR: Setup RID2PASID
>> failed" failure as the pasid entry has already been marke as present. As
> 
> s/marke/marked/

Updated. Thanks!

>> the result, the IOMMU probing process will be aborted.
>>
>> This fixes it by skipping RID2PASID setting if the pasid entry has been
>> populated. This works because the IOMMU core ensures that only the same
>> IOMMU domain can be attached to all PCI alias devices at the same time.
> 
> nit. this sentence is a little bit to interpret. :-) I guess what you want
> to describe is the PCI alias devices should be attached to the same domain
> instead of different domain. right?

Yes.

> 
> also, does it apply to all domain types? e.g. the SVA domains introduced 
> in "iommu: SVA and IOPF refactoring"

No. Only about the RID2PASID.

> 
>> Therefore the subsequent devices just try to setup the RID2PASID entry
>> with the same domain, which is negligible.
>>
>> Fixes: ef848b7e5a6a0 ("iommu/vt-d: Setup pasid entry for RID2PASID 
>> support")
>> Reported-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   drivers/iommu/intel/iommu.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
>> index 44016594831d..b9966c01a2a2 100644
>> --- a/drivers/iommu/intel/iommu.c
>> +++ b/drivers/iommu/intel/iommu.c
>> @@ -2564,7 +2564,7 @@ static int domain_add_dev_info(struct 
>> dmar_domain *domain, struct device *dev)
>>               ret = intel_pasid_setup_second_level(iommu, domain,
>>                       dev, PASID_RID2PASID);
>>           spin_unlock_irqrestore(&iommu->lock, flags);
>> -        if (ret) {
>> +        if (ret && ret != -EBUSY) {
>>               dev_err(dev, "Setup RID2PASID failed\n");
>>               dmar_remove_one_dev_info(dev);
>>               return ret;
> 

--
Best regards,
baolu
