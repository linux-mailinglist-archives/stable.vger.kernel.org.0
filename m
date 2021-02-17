Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B1031DEDF
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 19:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbhBQSKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 13:10:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233175AbhBQSKs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Feb 2021 13:10:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF80664E42;
        Wed, 17 Feb 2021 18:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613585407;
        bh=0Z0WorCxaD7BP56hnkNMqdSiCglGFGlqAwsbSLCh6m8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DomK4OPIHSzryzMWD5lTcExqL1chGXqVrXzu9LoLydAPrkFf74FsawJICKWnt1zWI
         q/KJDAtzBK0+DcQxYKC8mRmCTx/OdNROykkMOmkda4Pt0NX1x+J4uz4QfbMAFIyyyt
         /ldV/cm2fyYDcojGz4m2mitcaJknMpOXR66i4TBDaY+7hCMayTqa5tFicFYdsPRaEx
         aaCqO/zycLaUsiMFLcteS6hyBTRyZxwgfuFCkTPLbkT6yTcVSbT6aPeZ+t1fCxghBV
         HbpBcx4xDe+WnFP9gd2WEcFUm9g39+iVELWLsCMO1fDXQd6efesRCk7BD3IHzsE5W0
         rtbd55DCpwibA==
Date:   Wed, 17 Feb 2021 18:10:02 +0000
From:   Will Deacon <will@kernel.org>
To:     Andrey Ryabinin <arbn@yandex-team.com>
Cc:     Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>,
        valesini@yandex-team.ru, stable@vger.kernel.org
Subject: Re: [PATCH] iommu/amd: Fix sleeping in atomic in
 increase_address_space()
Message-ID: <20210217181002.GC4304@willie-the-truck>
References: <20210217143004.19165-1-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210217143004.19165-1-arbn@yandex-team.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 17, 2021 at 05:30:04PM +0300, Andrey Ryabinin wrote:
> increase_address_space() calls get_zeroed_page(gfp) under spin_lock with
> disabled interrupts. gfp flags passed to increase_address_space() may allow
> sleeping, so it comes to this:
> 
>  BUG: sleeping function called from invalid context at mm/page_alloc.c:4342
>  in_atomic(): 1, irqs_disabled(): 1, pid: 21555, name: epdcbbf1qnhbsd8
> 
>  Call Trace:
>   dump_stack+0x66/0x8b
>   ___might_sleep+0xec/0x110
>   __alloc_pages_nodemask+0x104/0x300
>   get_zeroed_page+0x15/0x40
>   iommu_map_page+0xdd/0x3e0
>   amd_iommu_map+0x50/0x70
>   iommu_map+0x106/0x220
>   vfio_iommu_type1_ioctl+0x76e/0x950 [vfio_iommu_type1]
>   do_vfs_ioctl+0xa3/0x6f0
>   ksys_ioctl+0x66/0x70
>   __x64_sys_ioctl+0x16/0x20
>   do_syscall_64+0x4e/0x100
>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Fix this by moving get_zeroed_page() out of spin_lock/unlock section.
> 
> Fixes: 754265bcab ("iommu/amd: Fix race in increase_address_space()")
> Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/iommu/amd/iommu.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
