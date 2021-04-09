Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00FF33594D7
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 07:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbhDIFm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 01:42:28 -0400
Received: from mga17.intel.com ([192.55.52.151]:46277 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233309AbhDIFmX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 01:42:23 -0400
IronPort-SDR: vaLw78A+pycWZh8dExVRLGbvsBeiTYJQgCCCrvKukctAL6l+hUoy2U6fFrS+br0x3K/ixn/qj1
 GZD8TSu7652Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="173778980"
X-IronPort-AV: E=Sophos;i="5.82,208,1613462400"; 
   d="scan'208";a="173778980"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 22:40:47 -0700
IronPort-SDR: /X6XxwF8QUIcsBf4ySsyhcfciHB1Uv1U61kGpXcX8CUDFZ2ZVSmnxfj/uBBpNQtWXkyJDzfS16
 4gUHPQ9qA0+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,208,1613462400"; 
   d="scan'208";a="442028760"
Received: from allen-box.sh.intel.com (HELO [10.239.159.128]) ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 08 Apr 2021 22:40:44 -0700
Cc:     baolu.lu@linux.intel.com, David Woodhouse <dwmw2@infradead.org>,
        Nadav Amit <nadav.amit@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] iommu/vt-d: Force to flush iotlb before creating
 superpage
To:     "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210401071834.1639-1-longpeng2@huawei.com>
 <9c368419-6e45-6b27-0f34-26b581589fa7@linux.intel.com>
 <611cb5849c9a497b8289004dddb71150@huawei.com>
 <808394ea-9ff0-7a6d-72e7-f037e5cd3110@linux.intel.com>
 <54ec81edcf074533867c18f0d86b837b@huawei.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <c3b8c8da-2c05-d051-3403-1f3f4f2cb36b@linux.intel.com>
Date:   Fri, 9 Apr 2021 13:31:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <54ec81edcf074533867c18f0d86b837b@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Longpeng,

On 4/8/21 3:37 PM, Longpeng (Mike, Cloud Infrastructure Service Product 
Dept.) wrote:
> Hi Baolu,
> 
>> -----Original Message-----
>> From: Lu Baolu [mailto:baolu.lu@linux.intel.com]
>> Sent: Thursday, April 8, 2021 12:32 PM
>> To: Longpeng (Mike, Cloud Infrastructure Service Product Dept.)
>> <longpeng2@huawei.com>; iommu@lists.linux-foundation.org;
>> linux-kernel@vger.kernel.org
>> Cc: baolu.lu@linux.intel.com; David Woodhouse <dwmw2@infradead.org>; Nadav
>> Amit <nadav.amit@gmail.com>; Alex Williamson <alex.williamson@redhat.com>;
>> Kevin Tian <kevin.tian@intel.com>; Gonglei (Arei) <arei.gonglei@huawei.com>;
>> stable@vger.kernel.org
>> Subject: Re: [PATCH] iommu/vt-d: Force to flush iotlb before creating superpage
>>
>> Hi Longpeng,
>>
>> On 4/7/21 2:35 PM, Longpeng (Mike, Cloud Infrastructure Service Product
>> Dept.) wrote:
>>> Hi Baolu,
>>>
>>>> -----Original Message-----
>>>> From: Lu Baolu [mailto:baolu.lu@linux.intel.com]
>>>> Sent: Friday, April 2, 2021 12:44 PM
>>>> To: Longpeng (Mike, Cloud Infrastructure Service Product Dept.)
>>>> <longpeng2@huawei.com>; iommu@lists.linux-foundation.org;
>>>> linux-kernel@vger.kernel.org
>>>> Cc: baolu.lu@linux.intel.com; David Woodhouse <dwmw2@infradead.org>;
>>>> Nadav Amit <nadav.amit@gmail.com>; Alex Williamson
>>>> <alex.williamson@redhat.com>; Kevin Tian <kevin.tian@intel.com>;
>>>> Gonglei (Arei) <arei.gonglei@huawei.com>; stable@vger.kernel.org
>>>> Subject: Re: [PATCH] iommu/vt-d: Force to flush iotlb before creating
>>>> superpage
>>>>
>>>> Hi Longpeng,
>>>>
>>>> On 4/1/21 3:18 PM, Longpeng(Mike) wrote:
>>>>> diff --git a/drivers/iommu/intel/iommu.c
>>>>> b/drivers/iommu/intel/iommu.c index ee09323..cbcb434 100644
>>>>> --- a/drivers/iommu/intel/iommu.c
>>>>> +++ b/drivers/iommu/intel/iommu.c
>>>>> @@ -2342,9 +2342,20 @@ static inline int
>>>>> hardware_largepage_caps(struct
>>>> dmar_domain *domain,
>>>>>     				 * removed to make room for superpage(s).
>>>>>     				 * We're adding new large pages, so make sure
>>>>>     				 * we don't remove their parent tables.
>>>>> +				 *
>>>>> +				 * We also need to flush the iotlb before creating
>>>>> +				 * superpage to ensure it does not perserves any
>>>>> +				 * obsolete info.
>>>>>     				 */
>>>>> -				dma_pte_free_pagetable(domain, iov_pfn, end_pfn,
>>>>> -						       largepage_lvl + 1);
>>>>> +				if (dma_pte_present(pte)) {
>>>>
>>>> The dma_pte_free_pagetable() clears a batch of PTEs. So checking
>>>> current PTE is insufficient. How about removing this check and always
>>>> performing cache invalidation?
>>>>
>>>
>>> Um...the PTE here may be present( e.g. 4K mapping --> superpage mapping )
>> orNOT-present ( e.g. create a totally new superpage mapping ), but we only need to
>> call free_pagetable and flush_iotlb in the former case, right ?
>>
>> But this code covers multiple PTEs and perhaps crosses the page boundary.
>>
>> How about moving this code into a separated function and check PTE presence
>> there. A sample code could look like below: [compiled but not tested!]
>>
>> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c index
>> d334f5b4e382..0e04d450c38a 100644
>> --- a/drivers/iommu/intel/iommu.c
>> +++ b/drivers/iommu/intel/iommu.c
>> @@ -2300,6 +2300,41 @@ static inline int hardware_largepage_caps(struct
>> dmar_domain *domain,
>>           return level;
>>    }
>>
>> +/*
>> + * Ensure that old small page tables are removed to make room for
>> superpage(s).
>> + * We're going to add new large pages, so make sure we don't remove
>> their parent
>> + * tables. The IOTLB/devTLBs should be flushed if any PDE/PTEs are cleared.
>> + */
>> +static void switch_to_super_page(struct dmar_domain *domain,
>> +                                unsigned long start_pfn,
>> +                                unsigned long end_pfn, int level) {
> 
> Maybe "swith_to" will lead people to think "remove old and then setup new", so how about something like "remove_room_for_super_page" or "prepare_for_super_page" ?

I named it like this because we also want to have a opposite operation
split_from_super_page() which switch a PDE or PDPE from super page
setting up to small pages, which is needed to optimize dirty bit
tracking during VM live migration.

> 
>> +       unsigned long lvl_pages = lvl_to_nr_pages(level);
>> +       struct dma_pte *pte = NULL;
>> +       int i;
>> +
>> +       while (start_pfn <= end_pfn) {
> 
> start_pfn < end_pfn ?

end_pfn is inclusive.

> 
>> +               if (!pte)
>> +                       pte = pfn_to_dma_pte(domain, start_pfn, &level);
>> +
>> +               if (dma_pte_present(pte)) {
>> +                       dma_pte_free_pagetable(domain, start_pfn,
>> +                                              start_pfn + lvl_pages - 1,
>> +                                              level + 1);
>> +
>> +                       for_each_domain_iommu(i, domain)
>> +                               iommu_flush_iotlb_psi(g_iommus[i],
>> domain,
>> +                                                     start_pfn,
>> lvl_pages,
>> +                                                     0, 0);
>> +               }
>> +
>> +               pte++;
>> +               start_pfn += lvl_pages;
>> +               if (first_pte_in_page(pte))
>> +                       pte = NULL;
>> +       }
>> +}
>> +
>>    static int
>>    __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
>>                    unsigned long phys_pfn, unsigned long nr_pages, int prot)
>> @@ -2341,22 +2376,11 @@ __domain_mapping(struct dmar_domain *domain,
>> unsigned long iov_pfn,
>>                                   return -ENOMEM;
>>                           /* It is large page*/
>>                           if (largepage_lvl > 1) {
>> -                               unsigned long nr_superpages, end_pfn;
>> +                               unsigned long end_pfn;
>>
>>                                   pteval |= DMA_PTE_LARGE_PAGE;
>> -                               lvl_pages = lvl_to_nr_pages(largepage_lvl);
>> -
>> -                               nr_superpages = nr_pages / lvl_pages;
>> -                               end_pfn = iov_pfn + nr_superpages *
>> lvl_pages - 1;
>> -
>> -                               /*
>> -                                * Ensure that old small page tables are
>> -                                * removed to make room for superpage(s).
>> -                                * We're adding new large pages, so make
>> sure
>> -                                * we don't remove their parent tables.
>> -                                */
>> -                               dma_pte_free_pagetable(domain, iov_pfn,
>> end_pfn,
>> -                                                      largepage_lvl +
>> 1);
>> +                               end_pfn = ((iov_pfn + nr_pages) &
>> level_mask(largepage_lvl)) - 1;
>> +                               switch_to_super_page(domain, iov_pfn,
>> end_pfn, largepage_lvl);
>>                           } else {
>>                                   pteval &=
>> ~(uint64_t)DMA_PTE_LARGE_PAGE;
>>                           }
>>
>> I will send you the diff patch off list. Any thoughts?
>>
> 
> The solution looks good to me.
> 
> It's free for you to send this patch if you want, I'll send V2 if you have no plan to send it :)

Please go ahead with a new version. Thank you for catching this and
managing to fix it.

Best regards,
baolu

> 
>> Best regards,
>> baolu
>>
>>>
>>>>> +					int i;
>>>>> +
>>>>> +					dma_pte_free_pagetable(domain, iov_pfn, end_pfn,
>>>>> +							       largepage_lvl + 1);
>>>>> +					for_each_domain_iommu(i, domain)
>>>>> +						iommu_flush_iotlb_psi(g_iommus[i], domain,
>>>>> +								      iov_pfn, nr_pages, 0, 0);
>>>>> +
>>>>
>>>> Best regards,
>>>> baolu
