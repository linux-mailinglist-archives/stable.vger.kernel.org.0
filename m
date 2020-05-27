Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85BE31E3D29
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 11:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388364AbgE0JGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 05:06:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388268AbgE0JGW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 05:06:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEB5620787;
        Wed, 27 May 2020 09:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590570381;
        bh=FAvCknzoTGPImAY3eT0P2nnO/0J1mHHX86dLH7iV/1s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QDm8HrrC/9YB0B/oFjVIItGTyqhBTZraHt2UEFTqoRDF2OXZlnYtuMQ2/4Lj4PIVa
         Drio0vQjl5sCV6qqPHsS8jdpUkMXkg51jL1Wzof8P5xUu6EDWLCuLDdR11NI5u0kNI
         N4TmitUblhzBxyKwFqfpmdcTDDO0iyAPupBpvmS4=
Date:   Wed, 27 May 2020 11:06:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Dahl <post@lespocky.de>
Cc:     x86@kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Alan Jenkins <alan.christopher.jenkins@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Florian Wolters <florian@florian-wolters.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] dma: Fix max PFN arithmetic overflow on 32 bit systems
Message-ID: <20200527090618.GF179718@kroah.com>
References: <20200526175749.20742-1-post@lespocky.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200526175749.20742-1-post@lespocky.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 26, 2020 at 07:57:49PM +0200, Alexander Dahl wrote:
> The intermediate result of the old term (4UL * 1024 * 1024 * 1024) is
> 4 294 967 296 or 0x100000000 which is no problem on 64 bit systems.  The
> patch does not change the later overall result of 0x100000 for
> MAX_DMA32_PFN.  The new calculation yields the same result, but does not
> require 64 bit arithmetic.
> 
> On 32 bit systems the old calculation suffers from an arithmetic
> overflow in that intermediate term in braces: 4UL aka unsigned long int
> is 4 byte wide and an arithmetic overflow happens (the 0x100000000 does
> not fit in 4 bytes), the in braces result is truncated to zero, the
> following right shift does not alter that, so MAX_DMA32_PFN evaluates to
> 0 on 32 bit systems.
> 
> That wrong value is a problem in a comparision against MAX_DMA32_PFN in
> the init code for swiotlb in 'pci_swiotlb_detect_4gb()' to decide if
> swiotlb should be active.  That comparison yields the opposite result,
> when compiling on 32 bit systems.
> 
> This was not possible before 1b7e03ef7570 ("x86, NUMA: Enable emulation
> on 32bit too") when that MAX_DMA32_PFN was first made visible to x86_32
> (and which landed in v3.0).
> 
> In practice this wasn't a problem, unless you activated CONFIG_SWIOTLB
> on x86 (32 bit).
> 
> However for ARCH=x86 (32 bit) and if you have set CONFIG_IOMMU_INTEL,
> since c5a5dc4cbbf4 ("iommu/vt-d: Don't switch off swiotlb if bounce page
> is used") there's a dependency on CONFIG_SWIOTLB, which was not
> necessarily active before.  That landed in v5.4, where we noticed it in
> the fli4l Linux distribution.  We have CONFIG_IOMMU_INTEL active on both
> 32 and 64 bit kernel configs there (I could not find out why, so let's
> just say historical reasons).
> 
> The effect is at boot time 64 MiB (default size) were allocated for
> bounce buffers now, which is a noticeable amount of memory on small
> systems like pcengines ALIX 2D3 with 256 MiB memory, which are still
> frequently used as home routers.
> 
> We noticed this effect when migrating from kernel v4.19 (LTS) to v5.4
> (LTS) in fli4l and got that kernel messages for example:
> 
>   Linux version 5.4.22 (buildroot@buildroot) (gcc version 7.3.0 (Buildroot 2018.02.8)) #1 SMP Mon Nov 26 23:40:00 CET 2018
>   …
>   Memory: 183484K/261756K available (4594K kernel code, 393K rwdata, 1660K rodata, 536K init, 456K bss , 78272K reserved, 0K cma-reserved, 0K highmem)
>   …
>   PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
>   software IO TLB: mapped [mem 0x0bb78000-0x0fb78000] (64MB)
> 
> The initial analysis and the suggested fix was done by user 'sourcejedi'
> at stackoverflow and explicitly marked as GPLv2 for inclusion in the
> Linux kernel:
> 
>   https://unix.stackexchange.com/a/520525/50007
> 
> The new calculation, which does not suffer from that overflow, is the
> same as for arch/mips now as suggested by Robin Murphy.
> 
> The fix was tested by fli4l users on round about two dozen different
> systems, including both 32 and 64 bit archs, bare metal and virtualized
> machines.
> 
> Fixes: 1b7e03ef7570 ("x86, NUMA: Enable emulation on 32bit too")
> Fixes: https://web.nettworks.org/bugs/browse/FFL-2560
> Fixes: https://unix.stackexchange.com/q/520065/50007
> Reported-by: Alan Jenkins <alan.christopher.jenkins@gmail.com>
> Suggested-by: Robin Murphy <robin.murphy@arm.com>
> Signed-off-by: Alexander Dahl <post@lespocky.de>
> Cc: stable@vger.kernel.org

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
