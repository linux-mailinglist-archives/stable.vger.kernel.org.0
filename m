Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61E0305499
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 08:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbhA0H0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 02:26:49 -0500
Received: from mga18.intel.com ([134.134.136.126]:44355 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S316653AbhA0AjQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 19:39:16 -0500
IronPort-SDR: +/bW+LTKZvJtasLZ+RjQeoan3L70K9ZbTdZik44Xg+ArDanJ0gwPUP4pR0Php5RxzDTJvp5XdU
 xp5/X8mfa9YA==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="167666945"
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="167666945"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 16:37:55 -0800
IronPort-SDR: izRmj+LflD4/Gvd2EAT8bbLibLT/SFc47kq861oWBkgRC5tGr/L+pX9eK9mxfSYa2GZC00ZBBD
 CYNC5ut8RrcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="402923270"
Received: from allen-box.sh.intel.com (HELO [10.239.159.128]) ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 26 Jan 2021 16:37:53 -0800
Cc:     baolu.lu@linux.intel.com, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@vmware.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] iommu/vt-d: do not use flush-queue when caching-mode is
 on
To:     Nadav Amit <nadav.amit@gmail.com>, iommu@lists.linux-foundation.org
References: <20210126203856.1544088-1-namit@vmware.com>
 <cf693fca-4f5a-a6a6-cc58-3f4e3cd882b6@linux.intel.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <72cab17b-7b2f-1e4d-3bd5-3041b7edc724@linux.intel.com>
Date:   Wed, 27 Jan 2021 08:29:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cf693fca-4f5a-a6a6-cc58-3f4e3cd882b6@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/27/21 8:26 AM, Lu Baolu wrote:
>> +{
>> +    struct dmar_domain *dmar_domain = to_dmar_domain(domain);
>> +    struct intel_iommu *iommu = domain_get_iommu(dmar_domain);
>> +
>> +    if (intel_iommu_strict)
>> +        return 0;
>> +
>> +    /*
>> +     * The flush queue implementation does not perform page-selective
>> +     * invalidations that are required for efficient TLB flushes in 
>> virtual
>> +     * environments. The benefit of batching is likely to be much 
>> lower than
>> +     * the overhead of synchronizing the virtual and physical IOMMU
>> +     * page-tables.
>> +     */
>> +    if (iommu && cap_caching_mode(iommu->cap)) {
>> +        pr_warn_once("IOMMU batching is partially disabled due to 
>> virtualization");
>> +        return 0;
>> +    }
> 
> domain_get_iommu() only returns the first iommu, and could return NULL
> when this is called before domain attaching to any device. A better
> choice could be check caching mode globally and return false if caching
> mode is supported on any iommu.
> 
>         struct dmar_drhd_unit *drhd;
>         struct intel_iommu *iommu;
> 
>         rcu_read_lock();
>         for_each_active_iommu(iommu, drhd) {
>                  if (cap_caching_mode(iommu->cap))
>                          return false;

We should unlock rcu before return here. Sorry!

>          }
>          rcu_read_unlock();

Best regards,
baolu
