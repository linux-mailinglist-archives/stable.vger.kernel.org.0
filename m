Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0832A5B83
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 02:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730242AbgKDBIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 20:08:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:23720 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730224AbgKDBIQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 20:08:16 -0500
IronPort-SDR: hmZyPRz1wrZ4Y2z8UBVk3cl+zjS0tb0gKi/un7n8KPyDKa4si1/UErAGG4XZx8GO58xHgzcszJ
 HMG4UXIUUKYg==
X-IronPort-AV: E=McAfee;i="6000,8403,9794"; a="156138385"
X-IronPort-AV: E=Sophos;i="5.77,449,1596524400"; 
   d="scan'208";a="156138385"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2020 17:08:15 -0800
IronPort-SDR: 6BDOhAxZNbTJaLs1zswBH9VvB33E9mCxyRQnmqn8lJanXDeBq9qh2Xzq/St4ALkLm6+iLLBUHE
 /gffL0gGUCwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,449,1596524400"; 
   d="scan'208";a="426518233"
Received: from allen-box.sh.intel.com (HELO [10.239.159.139]) ([10.239.159.139])
  by fmsmga001.fm.intel.com with ESMTP; 03 Nov 2020 17:08:14 -0800
Cc:     baolu.lu@linux.intel.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] iommu: Fix deferred domain attachment in
 iommu_probe_device()
To:     Joerg Roedel <joro@8bytes.org>
References: <20201026063008.24849-1-baolu.lu@linux.intel.com>
 <20201103132358.GG22888@8bytes.org>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <399fbf3e-e940-d2a3-e0e7-20f4da988184@linux.intel.com>
Date:   Wed, 4 Nov 2020 09:01:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201103132358.GG22888@8bytes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Joerg,

On 11/3/20 9:23 PM, Joerg Roedel wrote:
> Hi Baolu,
> 
> On Mon, Oct 26, 2020 at 02:30:08PM +0800, Lu Baolu wrote:
>> @@ -264,7 +266,8 @@ int iommu_probe_device(struct device *dev)
>>   	 */
>>   	iommu_alloc_default_domain(group, dev);
>>   
>> -	if (group->default_domain)
>> +	if (group->default_domain &&
>> +	    !iommu_is_attach_deferred(group->default_domain, dev))
>>   		ret = __iommu_attach_device(group->default_domain, dev);
> 
> This is the hotplug path, not used for boot-initialization. Have you
> seen failures from the missing check here?

I haven't seen any failure. Just wondered why deferred attaching was not
checked here. It's fine to me if it's only for hotplug path.

Please ignore this change.

Best regards,
baolu
