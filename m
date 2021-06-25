Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4233B4170
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 12:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhFYKWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 06:22:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230082AbhFYKWQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Jun 2021 06:22:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02FCC61431;
        Fri, 25 Jun 2021 10:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624616395;
        bh=a2a1veiOGKp2laMSFdMlJEur+feJy9K0G00EltWwnL8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qDTWP1qeakO4qgYoNKsJ6busUIEiSF8tJbhblVtPnb6abzNbr+Rj9ZJHRUyoLknhb
         hCqzx719rAGZ4DbPrkxiKbyVWo0z8bivev9Z8x+J+2VBcf88F4zLvldH+HcZRUNfKD
         bRCB9UsqIxxJibeV0boueoHRi7G2cBvDeA8fAXk0=
Date:   Fri, 25 Jun 2021 12:19:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kefeng Wang <wangkefeng.wang@huawei.com>
Cc:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        catalin.marinas@arm.com, will@kernel.org,
        akpm@linux-foundation.org, guohanjun@huawei.com,
        sudeep.holla@arm.com, song.bao.hua@hisilicon.com, ardb@kernel.org,
        anshuman.khandual@arm.com, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Li Huafei <lihuafei1@huawei.com>
Subject: Re: [PATCH stable v5.10 0/7] arm64: Default to 32-bit wide ZONE_DMA
Message-ID: <YNWtyJaDY17829g9@kroah.com>
References: <827b317d7f5da6e048806922098291faacdb19f9.camel@suse.de>
 <YETwL6QGWFyJTAzk@kroah.com>
 <604597E3.5000605@huawei.com>
 <YEX1OcbVNSqwwusF@kroah.com>
 <31cd8432-2466-555d-7617-ae48cbcd4244@huawei.com>
 <8b0a4f25-0803-9341-f3a4-277d16802295@huawei.com>
 <YNLe4CGtOgVvTOMN@kroah.com>
 <e47df0fd-0ddd-408b-2972-1b6d0a786f00@huawei.com>
 <YNLkDJ8zHGRZ5iG8@kroah.com>
 <f692a6e5-9e07-8b96-b7d3-213e6e3d071b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f692a6e5-9e07-8b96-b7d3-213e6e3d071b@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 23, 2021 at 04:01:10PM +0800, Kefeng Wang wrote:
> 
> 
> On 2021/6/23 15:34, Greg KH wrote:
> > On Wed, Jun 23, 2021 at 03:25:10PM +0800, Kefeng Wang wrote:
> > > 
> > > 
> > > On 2021/6/23 15:12, Greg KH wrote:
> > > > On Wed, Jun 23, 2021 at 02:59:59PM +0800, Kefeng Wang wrote:
> > > > > Hi Greg,
> > > > > 
> > > > > There are two more patches about the ZONE_DMA[32] changes,
> > > > 
> > > > What ZONE_DMA changes?
> > > 
> > > See the subject, [PATCH stable v5.10 0/7] arm64: Default to 32-bit wide
> > > ZONE_DMA, We asked the ARM64 ZONE_DMA change backport before, link[1]
> 
> Let's inline the link:
> https://lore.kernel.org/lkml/20210303073319.2215839-1-jingxiangfeng@huawei.com/
> 
> The following 7 patches(we asked from link) has merged into lts5.10(tag:
> v5.10.22)
> 
>   4d7ed9a49b0c mm: Remove examples from enum zone_type comment
>   8eaef922e938 arm64: mm: Set ZONE_DMA size based on early IORT scan
>   35ec3d09ff6a arm64: mm: Set ZONE_DMA size based on devicetree's dma-ranges
>   a9861e7fa4f8 of: unittest: Add test for of_dma_get_max_cpu_address()
>   18bf6e998d08 of/address: Introduce of_dma_get_max_cpu_address()
>   3fbe62ffbb54 arm64: mm: Move zone_dma_bits initialization into
> zone_sizes_init()
>   407b173adfac arm64: mm: Move reserve_crashkernel() into mem_init()
> 
> but the patch "arm64: mm: Move reserve_crashkernel() into mem_init()"
> has some issue, see the following discussion from Catalin,
> 
> https://lore.kernel.org/linux-devicetree/e60d643e-4879-3fc3-737d-2c145332a6d7@arm.com/
> https://lore.kernel.org/linux-arm-kernel/20201119175556.18681-1-catalin.marinas@arm.com/
> 
> and yes, we met crash in lts5.10 when kexec boot due to "arm64: mm: Move
> reserve_crashkernel() into mem_init()" too, which could be fixed by
> commit 2687275a5843 "arm64: Force NO_BLOCK_MAPPINGS if crashkernel
> reservation is required", and the commit 791ab8b2e3db "arm64: Ignore any DMA
> offsets in the max_zone_phys() calculation" also about DMA set,
> So I only asked the two patches(both in v5.11) related ARM64 ZONE_DMA
> changes backported into lts5.10.

Thanks, all now queued up.

greg k-h
