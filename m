Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5512311A56B
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 08:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbfLKHwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 02:52:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:55696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726983AbfLKHwF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 02:52:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECD192077B;
        Wed, 11 Dec 2019 07:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576050724;
        bh=0paeYi5T7sFJPY0iTspixJuGiLmx9YdcmU5o/l4jz1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gd5BK7NRg5rMk3+kQjpCV+GlpPNH1KY91CWljHfomvBGzctP/BnFQhwtVSXcvauyP
         C1nzzd1I0Bdqosa0nOp6XpMgrzgouViUku0b2hXa+Jrkvyg7W/cwsWz3hr4rYbr72p
         dE0LM22ufWubfWgK/AIz1KNbz45icMEJq0BEB8nI=
Date:   Wed, 11 Dec 2019 08:52:01 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        devel@driverdev.osuosl.org, Matthew Wilcox <willy@infradead.org>,
        Paul Burton <paul.burton@mips.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH AUTOSEL 5.4 076/350] staging/octeon: Use stubs for MIPS
 && !CAVIUM_OCTEON_SOC
Message-ID: <20191211075201.GK398293@kroah.com>
References: <20191210210735.9077-1-sashal@kernel.org>
 <20191210210735.9077-37-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210210735.9077-37-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 10, 2019 at 04:03:01PM -0500, Sasha Levin wrote:
> From: Paul Burton <paul.burton@mips.com>
> 
> [ Upstream commit 17a29fea086ba18b000d28439bd5cb4f2b0a527b ]
> 
> When building for a non-Cavium MIPS system with COMPILE_TEST=y, the
> Octeon ethernet driver hits a number of issues due to use of macros
> provided only for CONFIG_CAVIUM_OCTEON_SOC=y configurations. For
> example:
> 
>   drivers/staging/octeon/ethernet-rx.c:190:6: error:
>     'CONFIG_CAVIUM_OCTEON_CVMSEG_SIZE' undeclared (first use in this function)
>   drivers/staging/octeon/ethernet-rx.c:472:25: error:
>     'OCTEON_IRQ_WORKQ0' undeclared (first use in this function)
> 
> These come from various asm/ headers that a non-Octeon build will be
> using a non-Octeon version of.
> 
> Fix this by using the octeon-stubs.h header for non-Cavium MIPS builds,
> and only using the real asm/octeon/ headers when building a Cavium
> Octeon kernel configuration.
> 
> This requires that octeon-stubs.h doesn't redefine XKPHYS_TO_PHYS, which
> is defined for MIPS by asm/addrspace.h which is pulled in by many other
> common asm/ headers.
> 
> Signed-off-by: Paul Burton <paul.burton@mips.com>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> URL: https://lore.kernel.org/linux-mips/CAMuHMdXvu+BppwzsU9imNWVKea_hoLcRt9N+a29Q-QsjW=ip2g@mail.gmail.com/
> Fixes: 171a9bae68c7 ("staging/octeon: Allow test build on !MIPS")
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: David S. Miller <davem@davemloft.net>
> 
> Link: https://lore.kernel.org/r/20191007231741.2012860-1-paul.burton@mips.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/staging/octeon/octeon-ethernet.h | 2 +-
>  drivers/staging/octeon/octeon-stubs.h    | 5 ++++-
>  2 files changed, 5 insertions(+), 2 deletions(-)

I think this broke the build for 5.5-rc1, so no, please do not include
this.  This driver is about to be deleted (see the discussion on the
staging mailing list for details), so this patch can be dropped.

thanks,

greg k-h
