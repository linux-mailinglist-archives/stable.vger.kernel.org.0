Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED183822D3
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 04:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbhEQCkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 22:40:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:34015 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233524AbhEQCkw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 16 May 2021 22:40:52 -0400
IronPort-SDR: m1N9fxitMZAxCQQVig5l420jkQSoCAmA2DcNmuzOq7iaw7KbHlMUbKN6A2Zu+6fjievAUNXKqL
 gJJIss17ixTg==
X-IronPort-AV: E=McAfee;i="6200,9189,9986"; a="187495306"
X-IronPort-AV: E=Sophos;i="5.82,306,1613462400"; 
   d="scan'208";a="187495306"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2021 19:39:36 -0700
IronPort-SDR: AZemN1N+C9Rz0wCLcGxfq2qNnmL2gA/lD5poLSS9/b7+cIqc846WgRqzFxixF3dqotq2JGhpJw
 Li+Tp5ttk4/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,306,1613462400"; 
   d="scan'208";a="626267587"
Received: from allen-box.sh.intel.com (HELO [10.239.159.128]) ([10.239.159.128])
  by fmsmga006.fm.intel.com with ESMTP; 16 May 2021 19:39:34 -0700
Cc:     baolu.lu@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Ashok Raj <ashok.raj@intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 392/530] iommu/vt-d: Preset Access/Dirty bits for
 IOVA over FL
To:     =?UTF-8?Q?Wolfgang_M=c3=bcller?= <wolf@oriole.systems>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
 <20210512144832.660153884@linuxfoundation.org>
 <20210515132855.4bn7ve2ozvdhpnj4@nabokov.fritz.box>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <5d9b2c1a-f2f4-a9db-a14b-b6a31da59f54@linux.intel.com>
Date:   Mon, 17 May 2021 10:38:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210515132855.4bn7ve2ozvdhpnj4@nabokov.fritz.box>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Wolfgang,

On 5/15/21 9:28 PM, Wolfgang Müller wrote:
> Hi!
> 
> First of all, apologies if this is the wrong place to post a problem
> report. I figured since I was going to reference a particular commit
> anyway I might as well reply to the patch series that (seemed to have)
> introduced the problem.
> 
>> From: Lu Baolu <baolu.lu@linux.intel.com>
>>
>> [ Upstream commit a8ce9ebbecdfda3322bbcece6b3b25888217f8e3 ]
>>
>> The Access/Dirty bits in the first level page table entry will be set
>> whenever a page table entry was used for address translation or write
>> permission was successfully translated. This is always true when using
>> the first-level page table for kernel IOVA. Instead of wasting hardware
>> cycles to update the certain bits, it's better to set them up at the
>> beginning.
> 
> This commit seems to trigger a kernel panic very early in boot for me in
> 5.10.37 (36 is fine):

It seems due to the back-ported patch:

-	if (!sg) {
-		sg_res = nr_pages;
-		pteval = ((phys_addr_t)phys_pfn << VTD_PAGE_SHIFT) | attr;
+		if (domain->domain.type == IOMMU_DOMAIN_DMA) {
+			attr |= DMA_FL_PTE_ACCESS;
+			if (prot & DMA_PTE_WRITE)
+				attr |= DMA_FL_PTE_DIRTY;
+		}
  	}

+	pteval = ((phys_addr_t)phys_pfn << VTD_PAGE_SHIFT) | attr;

Greg, do you want me to rework this patch, or submit an incremental fix?

Best regards,
baolu
