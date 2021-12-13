Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6420D472384
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbhLMJHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:07:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbhLMJHp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:07:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FF5C061574;
        Mon, 13 Dec 2021 01:07:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D58EB80DEF;
        Mon, 13 Dec 2021 09:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88299C341C8;
        Mon, 13 Dec 2021 09:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639386463;
        bh=agxAmAiq3HUClqu4ci3EeN3OoRKbc1J0u4nvdnWV7Do=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w3EcTbc9cuJx4NIFxP0gQ+tVsotYaQPVMJkvq226svrOyOHoc9dZOzvet5DtUq28F
         6OrpQZE+iZskewGy1NlLr6wB0BvyuBPdFo5HNvSXqBOnVpwTvmftEKdjk/EcNvdQOb
         CfFl21xcXvXLDFZWFoW+bO/zeH7xSfIFHTEoJO3o=
Date:   Mon, 13 Dec 2021 10:07:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Cc:     stable@vger.kernel.org, rppt@kernel.org, akpm@linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux@armlinux.org.uk, rppt@linux.ibm.com,
        tony@atomide.com, wangkefeng.wang@huawei.com,
        yj.chiang@mediatek.com
Subject: Re: [PATCH 5.4 0/5] memblock, arm: fixes for freeing of the memory
 map
Message-ID: <YbcNXBj+FIwuQd/8@kroah.com>
References: <20211213085710.28962-1-mark-pk.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213085710.28962-1-mark-pk.tsai@mediatek.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 04:57:05PM +0800, Mark-PK Tsai wrote:
> When linux memory is not aligned with page block size and have hole in zone,
> the 5.4-lts arm kernel might crash in move_freepages() as Kefen Wang reported in [1].
> Backport the upstream fix commits by Mike Rapoport [2] to 5.4 can fix this issue.
> 
> And free_unused_memmap() of arm and arm64 are moved to generic mm/memblock in
> the below upstream commit, so I applied the first two patches to free_unused_memmap()
> in arch/arm/mm/init.c.
> 
> (4f5b0c178996 arm, arm64: move free_unused_memmap() to generic mm)
> 
> [1] https://lore.kernel.org/lkml/2a1592ad-bc9d-4664-fd19-f7448a37edc0@huawei.com/
> [2] https://lore.kernel.org/lkml/20210630071211.21011-1-rppt@kernel.org/#t
> 
> Mike Rapoport (5):
>   memblock: free_unused_memmap: use pageblock units instead of MAX_ORDER
>   memblock: align freed memory map on pageblock boundaries with
>     SPARSEMEM
>   memblock: ensure there is no overflow in memblock_overlaps_region()
>   arm: extend pfn_valid to take into account freed memory map alignment
>   arm: ioremap: don't abuse pfn_valid() to check if pfn is in RAM
> 
>  arch/arm/mm/init.c    | 37 +++++++++++++++++++++++++------------
>  arch/arm/mm/ioremap.c |  4 +++-
>  mm/memblock.c         |  3 ++-
>  3 files changed, 30 insertions(+), 14 deletions(-)
> 
> -- 
> 2.18.0
> 

These look like they also are required in 5.10.y as well, right?  Please
also provide a backported series for that tree, we can not have users
moving to a newer kernel version and having regressions.

I can't take this series until then, sorry.

thanks,

greg k-h
