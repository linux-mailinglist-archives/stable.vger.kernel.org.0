Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFC9611DD54
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 06:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725785AbfLMFCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 00:02:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:15489 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbfLMFCS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Dec 2019 00:02:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Dec 2019 21:02:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,308,1571727600"; 
   d="scan'208";a="226175771"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 12 Dec 2019 21:02:15 -0800
Cc:     baolu.lu@linux.intel.com
Subject: Re: [PATCH 1/1] iommu/vt-d: Fix dmar pte read access not set error
To:     Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>, ashok.raj@intel.com,
        jacob.jun.pan@intel.com, kevin.tian@intel.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20191211014015.7898-1-baolu.lu@linux.intel.com>
 <20191212014952.vlrmxrk2cebwxjnp@cantor>
 <6f3bcad9-b9b3-b349-fdad-ce53a79a665b@linux.intel.com>
 <20191213003013.gc3zg3fpzpjntnzg@cantor>
 <7d58da5b-3f55-72b2-0638-ae561446d207@linux.intel.com>
 <20191213025159.kwf6f6zjmcjecamp@cantor>
 <20191213031633.zxccz5t5yyillxsb@cantor>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <0492b96f-6f57-b4f4-3862-07d9c23fdef9@linux.intel.com>
Date:   Fri, 13 Dec 2019 13:01:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191213031633.zxccz5t5yyillxsb@cantor>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 12/13/19 11:16 AM, Jerry Snitselaar wrote:
> On Thu Dec 12 19, Jerry Snitselaar wrote:
>> On Fri Dec 13 19, Lu Baolu wrote:
>>> Hi,
>>>
>>> On 12/13/19 8:30 AM, Jerry Snitselaar wrote:
>>>> On Thu Dec 12 19, Lu Baolu wrote:
>>>>> Hi,
>>>>>
>>>>> On 12/12/19 9:49 AM, Jerry Snitselaar wrote:
>>>>>> On Wed Dec 11 19, Lu Baolu wrote:
>>>>>>> If the default DMA domain of a group doesn't fit a device, it
>>>>>>> will still sit in the group but use a private identity domain.
>>>>>>> When map/unmap/iova_to_phys come through iommu API, the driver
>>>>>>> should still serve them, otherwise, other devices in the same
>>>>>>> group will be impacted. Since identity domain has been mapped
>>>>>>> with the whole available memory space and RMRRs, we don't need
>>>>>>> to worry about the impact on it.
>>>>>>>
>>>>>>> Link: https://www.spinics.net/lists/iommu/msg40416.html
>>>>>>> Cc: Jerry Snitselaar <jsnitsel@redhat.com>
>>>>>>> Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
>>>>>>> Fixes: 942067f1b6b97 ("iommu/vt-d: Identify default domains 
>>>>>>> replaced with private")
>>>>>>> Cc: stable@vger.kernel.org # v5.3+
>>>>>>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>>>>>>
>>>>>> Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
>>>>>
>>>>> Can you please try this fix and check whether it can fix your problem?
>>>>> If it helps, do you mind adding a Tested-by?
>>>>>
>>>>> Best regards,
>>>>> baolu
>>>>>
>>>>
>>>> I'm testing with this patch, my patch that moves the direct mapping 
>>>> call,
>>>> and Alex's patch for the ISA bridge. It solved the 2 iommu mapping 
>>>> errors
>>>> I was seeing with default passthrough, I no longer see all the dmar pte
>>>> read access errors, and the system boots allowing me to login. I'm 
>>>> tracking
>>>> down 2 issues at the moment. With passthrough I see a problem with 
>>>> 01:00.4
>>>> that I mentioned in the earlier email:
>>>>
>>>> [   78.978573] uhci_hcd: USB Universal Host Controller Interface driver
>>>> [   78.980842] uhci_hcd 0000:01:00.4: UHCI Host Controller
>>>> [   78.982738] uhci_hcd 0000:01:00.4: new USB bus registered, 
>>>> assigned bus number 3
>>>> [   78.985222] uhci_hcd 0000:01:00.4: detected 8 ports
>>>> [   78.986907] uhci_hcd 0000:01:00.4: port count misdetected? 
>>>> forcing to 2 ports
>>>> [   78.989316] uhci_hcd 0000:01:00.4: irq 16, io base 0x00003c00
>>>> [   78.994634] uhci_hcd 0000:01:00.4: DMAR: 32bit DMA uses 
>>>> non-identity mapping
>>>> [   7 0000:01:00.4: unable to allocate consistent memory for frame list
>>>> [   79.499891] uhci_hcd 0000:01:00.4: startup error -16
>>>> [   79.501588] uhci_hcd 0000:01:00.4: USB bus 3 deregistered
>>>> [   79.503494] uhci_hcd 0000:01:00.4: init 0000:01:00.4 fail, -16
>>>> [   79.505497] uhci_hcd: probe of 0000:01:00.4 failed with error -16
>>>>
>>>> If I boot the system with iommu=nopt I see an iommu map failure due to
>>>> the prot check in __domain_mapping:
>>>>
>>>> [   40.940589] pci 0000:00:1f.0: iommu_group_add_device: calling 
>>>> iommu_group_create_direct_mappings
>>>> [   40.943558] pci 0000:00:1f.0: iommu_group_create_direct_mappings: 
>>>> iterating through mappings
>>>> [   40.946402] pci 0000:00:1f.0: iommu_group_create_direct_mappings: 
>>>> calling apply_resv_region
>>>> [   40.949184] pci 0000:00:1f.0: iommu_group_create_direct_mappings: 
>>>> entry type is direct
>>>> [   40.951819] DMAR: intel_iommu_map: enter
>>>> [   40.953128] DMAR: __domain_mapping: prot & 
>>>> (DMA_PTE_READ|DMA_PTE_WRITE) == 0
>>>> [   40.955486] DMAR: domain_mapping: __domain_mapping failed
>>>> [   40.957348] DMAR: intel_iommu_map: domain_pfn_mapping returned -22
>>>> [   40.959466] DMAR: intel_iommu_map: leave
>>>> [   40.959468] iommu: iommu_map: ops->map failed iova 0x0 pa 
>>>> 0x0000000000000000 pgsize 0x1000
>>>> [   40.963511] pci 0000:00:1f.0: iommu_group_create_direct_mappings: 
>>>> iommu_map failed
>>>> [   40.966026] pci 0000:00:1f.0: iommu_group_create_direct_mappings: 
>>>> leaving func
>>>> [   40.968487] pci 0000:00:1f.0: iommu_group_add_device: calling 
>>>> __iommu_attach_device
>>>> [   40.971016] pci 0000:00:1f.0: Adding to iommu group 19
>>>> [   40.972731] pci 0000:00:1f.0: DMAR: domain->type is dma
>>>>
>>>> /sys/kernel/iommu_groups/19
>>>> [root@hp-dl388g8-07 19]# cat reserved_regions 0x0000000000000000 
>>>> 0x0000000000ffffff direct
>>>> 0x00000000bdf6e000 0x00000000bdf84fff direct
>>>> 0x00000000fee00000 0x00000000feefffff msi
>>>>
>>>> 00:1f.0 ISA bridge: Intel Corporation C600/X79 series chipset LPC 
>>>> Controller
>>>
>>> This seems to be another issue?
>>>
>>> Best regards,
>>> baolu
>>
>> In intel_iommu_get_resv_regions this iommu_alloc_resv_region is called
>> with prot set to 0:
>>
>>                if ((pdev->class >> 8) == PCI_CLASS_BRIDGE_ISA) {
>>                        reg = iommu_alloc_resv_region(0, 1UL << 24, 0,
>>                                                      
>> IOMMU_RESV_DIRECT_RELAXABLE);
>>                        if (reg)
>>
> 
> Looking at the older code for the ISA bridge it looks like it called
> iommu_prepare_identity_map -> domain_prepare_identity_map ->
> iommu_domain_identity_map -> and finally __domain_mapping with 
> DMA_PTE_READ|DMA_PTE_WRITE?

Yes. Returning a reserved region without any access permission makes no
sense. Can you please post a fix for this?

Best regards,
baolu
