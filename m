Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7879D554854
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 14:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357423AbiFVJL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 05:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357424AbiFVJLB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 05:11:01 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D808340FC;
        Wed, 22 Jun 2022 02:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655888978; x=1687424978;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YqWiE296DtyHyhO+yyiOrk24VL3NMTPdoeON0AXOges=;
  b=kCjJt+K7X9W1JcKdI9hYkiftr0yn3eEgyX/k4bNgelEqRk111jPj/yEO
   sE5zb3XFhgeNnGJOYtSsCzWDiZtav0Syrv/2CBagy173yPz59V/RVX5wX
   E3x7MI6IJnyTzUFKX9tEx+VfhVTh05JQtxAkB0itWozYG87UyMm4RQYzn
   CaA9OMiT39AbQKC/vae/4h5d7Hb0m11fD/e/ifXFdBqfZsqqW7/EQ/nX6
   xKstiHjdAvAGvYkxkdbta0D3qBnjDqQtydhRQGw684UC4NdXdHBeULSQc
   d4NNWa1hv996NL3UuYvyuLprdaz9ZHLaHamIh2bx0BjHYKbRZ41g8rR8Q
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="281094053"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="281094053"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 02:09:38 -0700
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="644091091"
Received: from zhaohaif-mobl1.ccr.corp.intel.com (HELO [10.254.210.186]) ([10.254.210.186])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 02:09:35 -0700
Message-ID: <b7834cb5-4836-fb2d-1570-a46440341bed@linux.intel.com>
Date:   Wed, 22 Jun 2022 17:09:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 1/1] iommu/vt-d: Fix RID2PASID setup failure
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        iommu@lists.linux-foundation.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220622044120.21813-1-baolu.lu@linux.intel.com>
From:   Ethan Zhao <haifeng.zhao@linux.intel.com>
In-Reply-To: <20220622044120.21813-1-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

在 2022/6/22 12:41, Lu Baolu 写道:
> The IOMMU driver shares the pasid table for PCI alias devices. When the
> RID2PASID entry of the shared pasid table has been filled by the first
> device, the subsequent devices will encounter the "DMAR: Setup RID2PASID
> failed" failure as the pasid entry has already been marked as present. As
> the result, the IOMMU probing process will be aborted.
>
> This fixes it by skipping RID2PASID setting if the pasid entry has been
> populated. This works because the IOMMU core ensures that only the same
> IOMMU domain can be attached to all PCI alias devices at the same time.
> Therefore the subsequent devices just try to setup the RID2PASID entry
> with the same domain, which is negligible. This also adds domain validity
> checks for more confidence anyway.
>
> Fixes: ef848b7e5a6a0 ("iommu/vt-d: Setup pasid entry for RID2PASID support")
> Reported-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>   drivers/iommu/intel/pasid.c | 22 ++++++++++++++++------
>   1 file changed, 16 insertions(+), 6 deletions(-)
>
> Change log:
> v2:
>   - Add domain validity check in RID2PASID entry setup.
>
> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
> index cb4c1d0cf25c..4f3525f3346f 100644
> --- a/drivers/iommu/intel/pasid.c
> +++ b/drivers/iommu/intel/pasid.c
> @@ -575,6 +575,19 @@ static inline int pasid_enable_wpe(struct pasid_entry *pte)
>   	return 0;
>   };
>   
> +/*
> + * Return true if @pasid is RID2PASID and the domain @did has already
> + * been setup to the @pte. Otherwise, return false. PCI alias devices
> + * probably share the single RID2PASID pasid entry in the shared pasid
> + * table. It's reasonable that those devices try to set a share domain
> + * in their probe paths.
> + */

I am thinking about the counter-part, the intel_pasid_tear_down_entry(),

Multi devices share the same PASID entry, then one was detached from the 
domain,

so the entry doesn't exist anymore, while another devices don't know 
about the change,

and they are using the mapping, is it possible case ？shared thing, no 
refer-counter,

am I missing something ?


Thanks，

Ethan


> +static inline bool
> +rid2pasid_domain_valid(struct pasid_entry *pte, u32 pasid, u16 did)
> +{
> +	return pasid == PASID_RID2PASID && pasid_get_domain_id(pte) == did;
> +}
> +
>   /*
>    * Set up the scalable mode pasid table entry for first only
>    * translation type.
> @@ -595,9 +608,8 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
>   	if (WARN_ON(!pte))
>   		return -EINVAL;
>   
> -	/* Caller must ensure PASID entry is not in use. */
>   	if (pasid_pte_is_present(pte))
> -		return -EBUSY;
> +		return rid2pasid_domain_valid(pte, pasid, did) ? 0 : -EBUSY;
>   
>   	pasid_clear_entry(pte);
>   
> @@ -698,9 +710,8 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
>   		return -ENODEV;
>   	}
>   
> -	/* Caller must ensure PASID entry is not in use. */
>   	if (pasid_pte_is_present(pte))
> -		return -EBUSY;
> +		return rid2pasid_domain_valid(pte, pasid, did) ? 0 : -EBUSY;
>   
>   	pasid_clear_entry(pte);
>   	pasid_set_domain_id(pte, did);
> @@ -738,9 +749,8 @@ int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
>   		return -ENODEV;
>   	}
>   
> -	/* Caller must ensure PASID entry is not in use. */
>   	if (pasid_pte_is_present(pte))
> -		return -EBUSY;
> +		return rid2pasid_domain_valid(pte, pasid, did) ? 0 : -EBUSY;
>   
>   	pasid_clear_entry(pte);
>   	pasid_set_domain_id(pte, did);

-- 
AFAIK = As Far As I Know
AKA = Also Known As
ASAP = As Soon As Possible

