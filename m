Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51621E204C
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 13:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388728AbgEZLAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 07:00:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:32966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388726AbgEZLAY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 07:00:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11BA12084C;
        Tue, 26 May 2020 11:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590490824;
        bh=W+yADIr6cx+w8qOoQumX4ZVB1TVjc19ruDQ1PWLl28I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vt5WbMWzXjehA4waBQOmrw7WLh+CtEoSxwGAAUyXopo0qVpcSqNLY8no2gOSz6N+R
         AnkU44LcCC0h+PEDfKOk6lAJOo4P7UmrBJVkcrxt/yl5knBJ28pmjqCXH26MePMXfW
         fuI/PUq54l4wosco1j7MtzMuGpYFPTAkxpgT1IEc=
Date:   Tue, 26 May 2020 13:00:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Santosh Sivaraj <santosh@fossix.org>
Cc:     stable@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 3/6] asm-generic/tlb, arch: Invert
 CONFIG_HAVE_RCU_TABLE_INVALIDATE
Message-ID: <20200526110022.GB2838783@kroah.com>
References: <20200520083025.229011-1-santosh@fossix.org>
 <20200520083025.229011-4-santosh@fossix.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520083025.229011-4-santosh@fossix.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 20, 2020 at 02:00:22PM +0530, Santosh Sivaraj wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> commit 96bc9567cbe112e9320250f01b9c060c882e8619 upstream
> 
> Make issuing a TLB invalidate for page-table pages the normal case.
> 
> The reason is twofold:
> 
>  - too many invalidates is safer than too few,
>  - most architectures use the linux page-tables natively
>    and would thus require this.
> 
> Make it an opt-out, instead of an opt-in.
> 
> No change in behavior intended.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: <stable@vger.kernel.org> # 4.19
> Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
> [santosh: prerequisite for upcoming tlbflush backports]
> ---
>  arch/Kconfig         | 2 +-
>  arch/powerpc/Kconfig | 1 +
>  arch/sparc/Kconfig   | 1 +
>  arch/x86/Kconfig     | 1 -
>  mm/memory.c          | 2 +-
>  5 files changed, 4 insertions(+), 3 deletions(-)

Why did you not also change arch/arm64/Kconfig and
include/asm-generic/tlb.h like the original patch changed?

Why can those files be ignored/left out?  You need to explain that in
the backport section, all you said was "prerequisite..." and did not say
why you changed this patch.

Please fix up, and make sure you do the same for all of the other
patches in this series for when you resend it.

thanks,

greg k-h
