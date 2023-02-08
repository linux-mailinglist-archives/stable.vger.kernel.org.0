Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B57F68E6CE
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 04:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbjBHDrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 22:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjBHDqt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 22:46:49 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B12D43922;
        Tue,  7 Feb 2023 19:46:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675828007; x=1707364007;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EXcEy3+NTVqbXxmCTNcpox9WrJ2qnr4ZecV4ken6AWQ=;
  b=jM1qCzvG0NT9rsZysCs0zq93irUrjWI2awY+ChWi9D2fGoLHgd3lFDUb
   YPsKqBD6VWD18iU8rhjQ9z5wWUWcn2HRTVTcf6sW9nFJ7c9U7ZuekK7Qo
   b3IUAbAssIC5nIjSTWJrChZcUhayn554uhHk8ifWHQMffgZF8o31vZ0Mo
   j1/53PjHRjb7cfwy5onchsyg7oW1FAIdgy9PIAe13yHSLlYSYI837q7NB
   CwBdnOLWexAr2zmXtW25toOWcOVYOC1a2zT42KjgynS7BT7YsZHWcHZV5
   7MjsXoF/hxbB8QrQgyXo4CYWxP42xEKGclH8JdVnjC9vTDXFrf2pPATVr
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="310049800"
X-IronPort-AV: E=Sophos;i="5.97,279,1669104000"; 
   d="scan'208";a="310049800"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 19:46:44 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="735779962"
X-IronPort-AV: E=Sophos;i="5.97,279,1669104000"; 
   d="scan'208";a="735779962"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.255.28.52]) ([10.255.28.52])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 19:46:40 -0800
Message-ID: <18bbd442-c892-1f17-bf6c-b6d797379deb@linux.intel.com>
Date:   Wed, 8 Feb 2023 11:46:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Cc:     baolu.lu@linux.intel.com, Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Raj Ashok <ashok.raj@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        stable@vger.kernel.org, Sukumar Ghorai <sukumar.ghorai@intel.com>
Subject: Re: [PATCH v2] iommu/vt-d: Fix PASID directory pointer coherency
Content-Language: en-US
To:     Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>
References: <20230208000938.1527079-1-jacob.jun.pan@linux.intel.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20230208000938.1527079-1-jacob.jun.pan@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023/2/8 8:09, Jacob Pan wrote:
> On platforms that do not support IOMMU Extended capability bit 0
> Page-walk Coherency, CPU caches are not snooped when IOMMU is accessing
> any translation structures. IOMMU access goes only directly to
> memory. Intel IOMMU code was missing a flush for the PASID table
> directory that resulted in the unrecoverable fault as shown below.
> 
> This patch adds clflush calls whenever activating and updating
> a PASID table directory to ensure cache coherency.
> 
> On the reverse direction, there's no need to clflush the PASID directory
> pointer when we deactivate a context entry in that IOMMU hardware will
> not see the old PASID directory pointer after we clear the context entry.
> PASID directory entries are also never freed once allocated.
> 
> [    0.555386] DMAR: DRHD: handling fault status reg 3
> [    0.555805] DMAR: [DMA Read NO_PASID] Request device [00:0d.2] fault addr 0x1026a4000 [fault reason 0x51] SM: Present bit in Directory Entry is clear
> [    0.556348] DMAR: Dump dmar1 table entries for IOVA 0x1026a4000
> [    0.556348] DMAR: scalable mode root entry: hi 0x0000000102448001, low 0x0000000101b3e001
> [    0.556348] DMAR: context entry: hi 0x0000000000000000, low 0x0000000101b4d401
> [    0.556348] DMAR: pasid dir entry: 0x0000000101b4e001
> [    0.556348] DMAR: pasid table entry[0]: 0x0000000000000109
> [    0.556348] DMAR: pasid table entry[1]: 0x0000000000000001
> [    0.556348] DMAR: pasid table entry[2]: 0x0000000000000000
> [    0.556348] DMAR: pasid table entry[3]: 0x0000000000000000
> [    0.556348] DMAR: pasid table entry[4]: 0x0000000000000000
> [    0.556348] DMAR: pasid table entry[5]: 0x0000000000000000
> [    0.556348] DMAR: pasid table entry[6]: 0x0000000000000000
> [    0.556348] DMAR: pasid table entry[7]: 0x0000000000000000
> [    0.556348] DMAR: PTE not present at level 4
> 
> Cc:<stable@vger.kernel.org>
> Fixes: 0bbeb01a4faf ("iommu/vt-d: Manage scalalble mode PASID tables")
> Reported-by: Sukumar Ghorai<sukumar.ghorai@intel.com>
> Signed-off-by: Ashok Raj<ashok.raj@intel.com>
> Signed-off-by: Jacob Pan<jacob.jun.pan@linux.intel.com>
> ---
> v2: Add clflush to PASID directory update case (Baolu, Kevin review)
> ---
>   drivers/iommu/intel/iommu.c | 2 ++
>   drivers/iommu/intel/pasid.c | 2 ++
>   2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 59df7e42fd53..161342e7149d 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -1976,6 +1976,8 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
>   		pds = context_get_sm_pds(table);
>   		context->lo = (u64)virt_to_phys(table->table) |
>   				context_pdts(pds);
> +		if (!ecap_coherent(iommu->ecap))
> +			clflush_cache_range(table->table, sizeof(u64));

This leaves other pasid dir entries not clflush'ed. It is possible that
IOMMU hardware sees different value from what CPU has set. This may
leave security holes for malicious devices. It's same to the pasid entry
table.

How about below change? It does clflush whenever CPU changes the pasid
dir/entry tables.

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index fb3c7020028d..aeb0517826a2 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -128,6 +128,9 @@ int intel_pasid_alloc_table(struct device *dev)
         pasid_table->max_pasid = 1 << (order + PAGE_SHIFT + 3);
         info->pasid_table = pasid_table;

+       if (!ecap_coherent(info->iommu->ecap))
+               clflush_cache_range(pasid_table->table, size);
+
         return 0;
  }

@@ -215,6 +218,11 @@ static struct pasid_entry 
*intel_pasid_get_entry(struct device *dev, u32 pasid)
                         free_pgtable_page(entries);
                         goto retry;
                 }
+
+               if (!ecap_coherent(info->iommu->ecap)) {
+                       clflush_cache_range(entries, VTD_PAGE_SIZE);
+                       clflush_cache_range(&dir[dir_index].val, 
sizeof(*dir));
+               }
         }

         return &entries[index];

Best regards,
baolu
