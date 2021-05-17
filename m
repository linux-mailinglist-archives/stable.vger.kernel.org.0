Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC113822E1
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 04:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbhEQCvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 22:51:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229661AbhEQCvZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 16 May 2021 22:51:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EBAB61185;
        Mon, 17 May 2021 02:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621219809;
        bh=X5ngr4Uil22+BzVfrBo4TeLtOT8gxEtRZ54sQyy4Mm0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cVpJuIfZ67ZtRqeV5waou19NoOp3QzFmmCi87p8kkGFQ7g1/Id2iFmXqUmPJkjO7X
         Wx+DuUgPpwzBHGr438yjb/s9CPCYSaPxCSObPL9Ri+lc66kw1dhUzrtc+JPIapA/uE
         BsGv4Tpbgym1cPaY6Rj8bF5ipPXgILPTDKTN2JGFcWUujBQbCKoudvq7yI5Tu4FOAS
         13ry/UYgQGkPnawO6XpGe7HpEcYhVs+331fkXuDXVgOC5pv8ZtdLkKSiuV2gjeQm15
         0AyAh6mgt5pA6HLfkmJ51ij0CIc9m1ObrhPNvu0XJGz3ZlFJzNj3vUXUKg9z5ebVtu
         pH69lDz8c/yqw==
Date:   Sun, 16 May 2021 22:50:08 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Wolfgang =?iso-8859-1?Q?M=FCller?= <wolf@oriole.systems>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ashok Raj <ashok.raj@intel.com>, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 5.10 392/530] iommu/vt-d: Preset Access/Dirty bits for
 IOVA over FL
Message-ID: <YKHZ4AEUkXEqkFNW@sashalap>
References: <20210512144819.664462530@linuxfoundation.org>
 <20210512144832.660153884@linuxfoundation.org>
 <20210515132855.4bn7ve2ozvdhpnj4@nabokov.fritz.box>
 <5d9b2c1a-f2f4-a9db-a14b-b6a31da59f54@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5d9b2c1a-f2f4-a9db-a14b-b6a31da59f54@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17, 2021 at 10:38:42AM +0800, Lu Baolu wrote:
>Hi Wolfgang,
>
>On 5/15/21 9:28 PM, Wolfgang Müller wrote:
>>Hi!
>>
>>First of all, apologies if this is the wrong place to post a problem
>>report. I figured since I was going to reference a particular commit
>>anyway I might as well reply to the patch series that (seemed to have)
>>introduced the problem.
>>
>>>From: Lu Baolu <baolu.lu@linux.intel.com>
>>>
>>>[ Upstream commit a8ce9ebbecdfda3322bbcece6b3b25888217f8e3 ]
>>>
>>>The Access/Dirty bits in the first level page table entry will be set
>>>whenever a page table entry was used for address translation or write
>>>permission was successfully translated. This is always true when using
>>>the first-level page table for kernel IOVA. Instead of wasting hardware
>>>cycles to update the certain bits, it's better to set them up at the
>>>beginning.
>>
>>This commit seems to trigger a kernel panic very early in boot for me in
>>5.10.37 (36 is fine):
>
>It seems due to the back-ported patch:
>
>-	if (!sg) {
>-		sg_res = nr_pages;
>-		pteval = ((phys_addr_t)phys_pfn << VTD_PAGE_SHIFT) | attr;
>+		if (domain->domain.type == IOMMU_DOMAIN_DMA) {
>+			attr |= DMA_FL_PTE_ACCESS;
>+			if (prot & DMA_PTE_WRITE)
>+				attr |= DMA_FL_PTE_DIRTY;
>+		}
> 	}
>
>+	pteval = ((phys_addr_t)phys_pfn << VTD_PAGE_SHIFT) | attr;
>
>Greg, do you want me to rework this patch, or submit an incremental fix?

Could you send a reworked patch please?

-- 
Thanks,
Sasha
