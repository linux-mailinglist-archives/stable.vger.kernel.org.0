Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64826EA1AE
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 04:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbjDUCe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 22:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbjDUCe0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 22:34:26 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D031BCB;
        Thu, 20 Apr 2023 19:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682044465; x=1713580465;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uFOJc3bsJk3/iHF2tHOHfgAdOd2nm+oJEErrPnDpkbs=;
  b=jQduFjmqNNSFrFcQ0loq3SUOkr3+Qu0B3k25y8/g0rUskRLaK0YJ2pQo
   0rVqFuMRb8NVlSsrD0Q/5rcpGzIWUxZOIUcXIVRUP18B0JsCpPbHVZvWL
   LYLVB8LDRPLdi4luP4WkmxowWNS3v/XbJd1FOV9MIBv/rfy80qnwOGfh+
   GyCPHq1y1p1YrF361n1aiaQSzOhPzwOSIMVF98QLZY9BanFX7WKP/YWZf
   6PsMdshoz4ZYgJBxqiBL4EmEsuD6BphRiQnH8qczs7tOYmBlosTYkW37J
   F6UAQaqkjXy0ALSRpxncJwvrITZ4TVaE6VIiLHdkOHpoIi9Xc0oi8A+Gz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="373820768"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="373820768"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 19:34:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="642366620"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="642366620"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by orsmga003.jf.intel.com with ESMTP; 20 Apr 2023 19:34:21 -0700
Message-ID: <706b94c0-b0bd-4488-081f-6a955b99284a@linux.intel.com>
Date:   Fri, 21 Apr 2023 10:34:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Cc:     baolu.lu@linux.intel.com, Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Ghorai, Sukumar" <sukumar.ghorai@intel.com>
Subject: Re: [PATCH v3] iommu/vt-d: Fix PASID directory pointer coherency
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Joerg Roedel <joro@8bytes.org>
References: <20230405154447.2436308-1-jacob.jun.pan@linux.intel.com>
 <BN9PR11MB52762EABB8EF8E685291604A8C639@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB52762EABB8EF8E685291604A8C639@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/20/23 4:16 PM, Tian, Kevin wrote:
>> From: Jacob Pan <jacob.jun.pan@linux.intel.com>
>> Sent: Wednesday, April 5, 2023 11:45 PM
>>
>> On platforms that do not support IOMMU Extended capability bit 0
>> Page-walk Coherency, CPU caches are not snooped when IOMMU is
>> accessing
>> any translation structures. IOMMU access goes only directly to
>> memory. Intel IOMMU code was missing a flush for the PASID table
>> directory that resulted in the unrecoverable fault as shown below.
>>
>> This patch adds clflush calls whenever allocating and updating
>> a PASID table directory to ensure cache coherency.
>>
>> On the reverse direction, there's no need to clflush the PASID directory
>> pointer when we deactivate a context entry in that IOMMU hardware will
>> not see the old PASID directory pointer after we clear the context entry.
>> PASID directory entries are also never freed once allocated.
>>
>> [    0.555386] DMAR: DRHD: handling fault status reg 3
>> [    0.555805] DMAR: [DMA Read NO_PASID] Request device [00:0d.2] fault
>> addr 0x1026a4000 [fault reason 0x51] SM: Present bit in Directory Entry is
>> clear
>> [    0.556348] DMAR: Dump dmar1 table entries for IOVA 0x1026a4000
>> [    0.556348] DMAR: scalable mode root entry: hi 0x0000000102448001, low
>> 0x0000000101b3e001
>> [    0.556348] DMAR: context entry: hi 0x0000000000000000, low
>> 0x0000000101b4d401
>> [    0.556348] DMAR: pasid dir entry: 0x0000000101b4e001
>> [    0.556348] DMAR: pasid table entry[0]: 0x0000000000000109
>> [    0.556348] DMAR: pasid table entry[1]: 0x0000000000000001
>> [    0.556348] DMAR: pasid table entry[2]: 0x0000000000000000
>> [    0.556348] DMAR: pasid table entry[3]: 0x0000000000000000
>> [    0.556348] DMAR: pasid table entry[4]: 0x0000000000000000
>> [    0.556348] DMAR: pasid table entry[5]: 0x0000000000000000
>> [    0.556348] DMAR: pasid table entry[6]: 0x0000000000000000
>> [    0.556348] DMAR: pasid table entry[7]: 0x0000000000000000
>> [    0.556348] DMAR: PTE not present at level 4
>>
>> Cc: <stable@vger.kernel.org>
>> Fixes: 0bbeb01a4faf ("iommu/vt-d: Manage scalalble mode PASID tables")
>> Reported-by: Sukumar Ghorai <sukumar.ghorai@intel.com>
>> Signed-off-by: Ashok Raj <ashok.raj@intel.com>
>> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
>> ---
>> v3: Add clflush after PASID directory allocation to prevent malicious
>> device attack with unauthorized PASIDs. Also flush all the PASID entries
>> after directory updates. (Baolu)
>> v2: Add clflush to PASID directory update case (Baolu, Kevin review)
>> ---
>>   drivers/iommu/intel/iommu.c | 2 ++
>>   drivers/iommu/intel/pasid.c | 7 +++++++
>>   2 files changed, 9 insertions(+)
>>
>> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
>> index 59df7e42fd53..161342e7149d 100644
>> --- a/drivers/iommu/intel/iommu.c
>> +++ b/drivers/iommu/intel/iommu.c
>> @@ -1976,6 +1976,8 @@ static int domain_context_mapping_one(struct
>> dmar_domain *domain,
>>   		pds = context_get_sm_pds(table);
>>   		context->lo = (u64)virt_to_phys(table->table) |
>>   				context_pdts(pds);
>> +		if (!ecap_coherent(iommu->ecap))
>> +			clflush_cache_range(table->table, sizeof(u64));
> 
> v2 of this patch was already merged w/o this change.

The merged patch is v4.

https://lore.kernel.org/all/20230209212843.1788125-1-jacob.jun.pan@linux.intel.com/

> can you elaborate the purpose of v3? Here no flush is required as long
> as it's done in other two places below.

No above code in the merged patch.

Best regards,
baolu

> 
>>
>>   		/* Setup the RID_PASID field: */
>>   		context_set_sm_rid2pasid(context, PASID_RID2PASID);
>> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
>> index fb3c7020028d..979f796175b1 100644
>> --- a/drivers/iommu/intel/pasid.c
>> +++ b/drivers/iommu/intel/pasid.c
>> @@ -128,6 +128,9 @@ int intel_pasid_alloc_table(struct device *dev)
>>   	pasid_table->max_pasid = 1 << (order + PAGE_SHIFT + 3);
>>   	info->pasid_table = pasid_table;
>>
>> +	if (!ecap_coherent(info->iommu->ecap))
>> +		clflush_cache_range(pasid_table->table, size);
>> +
>>   	return 0;
>>   }
>>
>> @@ -215,6 +218,10 @@ static struct pasid_entry
>> *intel_pasid_get_entry(struct device *dev, u32 pasid)
>>   			free_pgtable_page(entries);
>>   			goto retry;
>>   		}
>> +		if (!ecap_coherent(info->iommu->ecap)) {
>> +			clflush_cache_range(entries, VTD_PAGE_SIZE);
>> +			clflush_cache_range(&dir[dir_index].val, sizeof(*dir));
>> +		}
>>   	}
>>
>>   	return &entries[index];
>> --
>> 2.25.1
> 
