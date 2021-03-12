Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C137C339983
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 23:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235506AbhCLWN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 17:13:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:51196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235515AbhCLWNP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 17:13:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15E7964F29;
        Fri, 12 Mar 2021 22:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615587195;
        bh=Nvw3iIumAKVNU+iGCXI9SbvQkjQr0AFRAf4higcMOEw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UVT0V14xkHdol443H9g22gFldOK0zPvS37wYHYZ1Hh+0aAQHGjJe/UwAJ1PUpTu4m
         JufMuT9outYElg7HBo46A1EhRuCvvlo+d+LW6Zr5e540Ax/92ueFqkAFeVqJBMNtwk
         t/I2x88L7wcx4pmieEPVFSpI+1Yw8AqoV+GBq0B2SX1//sZ47G4JMByZ+fatna0mIa
         rmO5V9zVwoDDr/XLgppLRdYCjqpQkP+y/gXck9vuLudh6YS6nTQCyBYv/+k0gzTbuR
         4XVV0//CghhrcqWTaDNiWDQsSFINXsnreryJ6qiAQM9GRKLiCVoeC1IeRpyKLA8ViM
         vPypirL48ifpQ==
Date:   Fri, 12 Mar 2021 17:13:14 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Andreas Larsson <andreas@gaisler.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mike Rapoport <rppt@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.14 06/13] sparc32: Limit memblock allocation to
 low memory
Message-ID: <YEvnenzIKNE1a0FL@sashalap>
References: <20210302115903.63458-1-sashal@kernel.org>
 <20210302115903.63458-6-sashal@kernel.org>
 <ad613de2-6fd4-f7a3-25b1-61f3a093c811@gaisler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ad613de2-6fd4-f7a3-25b1-61f3a093c811@gaisler.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 03, 2021 at 09:19:38AM +0100, Andreas Larsson wrote:
>On 2021-03-02 12:58, Sasha Levin wrote:
>>From: Andreas Larsson <andreas@gaisler.com>
>>
>>[ Upstream commit bda166930c37604ffa93f2425426af6921ec575a ]
>>
>>Commit cca079ef8ac29a7c02192d2bad2ffe4c0c5ffdd0 changed sparc32 to use
>>memblocks instead of bootmem, but also made high memory available via
>>memblock allocation which does not work together with e.g. phys_to_virt
>>and can lead to kernel panic.
>>
>>This changes back to only low memory being allocatable in the early
>>stages, now using memblock allocation.
>>
>>Signed-off-by: Andreas Larsson <andreas@gaisler.com>
>>Acked-by: Mike Rapoport <rppt@linux.ibm.com>
>>Signed-off-by: David S. Miller <davem@davemloft.net>
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>>---
>>  arch/sparc/mm/init_32.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>>diff --git a/arch/sparc/mm/init_32.c b/arch/sparc/mm/init_32.c
>>index 95fe4f081ba3..372a4f08ddf8 100644
>>--- a/arch/sparc/mm/init_32.c
>>+++ b/arch/sparc/mm/init_32.c
>>@@ -230,6 +230,9 @@ unsigned long __init bootmem_init(unsigned long *pages_avail)
>>  	reserve_bootmem((bootmap_pfn << PAGE_SHIFT), size, BOOTMEM_DEFAULT);
>>  	*pages_avail -= PAGE_ALIGN(size) >> PAGE_SHIFT;
>>+	/* Only allow low memory to be allocated via memblock allocation */
>>+	memblock_set_current_limit(max_low_pfn << PAGE_SHIFT);
>>+
>>  	return max_pfn;
>>  }
>>
>
>This is not needed for 4.14, and will not compile, as the problem it
>fixes was introduced in 4.19.

I'll drop it, thanks!

-- 
Thanks,
Sasha
