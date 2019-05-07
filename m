Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C881715B2E
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbfEGFwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:52:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728896AbfEGFwR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:52:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7D5B205ED;
        Tue,  7 May 2019 05:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557208336;
        bh=N26NT472AJl64Ye593vKGyraTKV6QYnsEVPtsPUDgS8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RjCEr5aCMT4Uk9yNqIWCCL//2hkpSqXtp7E46ssLuyMCdjwXaf/KlsSxWnBWpiGo8
         I95XOQDzgMx15QM+/qeZ93Wv+tITASZOVFMtU3sbNl+b+lCl1P9xO/fJtGOedFHaIe
         psw9yA4amrorbJPSVfl31q+MqIMeGMI+31IesEdc=
Date:   Tue, 7 May 2019 07:52:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexey Brodkin <alexey.brodkin@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Laight <David.Laight@aculab.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vineet Gupta <vgupta@synopsys.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: Re: [PATCH AUTOSEL 4.14 72/95] devres: Align data[] to
 ARCH_KMALLOC_MINALIGN
Message-ID: <20190507055214.GA17986@kroah.com>
References: <20190507053826.31622-1-sashal@kernel.org>
 <20190507053826.31622-72-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507053826.31622-72-sashal@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 01:38:01AM -0400, Sasha Levin wrote:
> From: Alexey Brodkin <alexey.brodkin@synopsys.com>
> 
> [ Upstream commit a66d972465d15b1d89281258805eb8b47d66bd36 ]
> 
> Initially we bumped into problem with 32-bit aligned atomic64_t
> on ARC, see [1]. And then during quite lengthly discussion Peter Z.
> mentioned ARCH_KMALLOC_MINALIGN which IMHO makes perfect sense.
> If allocation is done by plain kmalloc() obtained buffer will be
> ARCH_KMALLOC_MINALIGN aligned and then why buffer obtained via
> devm_kmalloc() should have any other alignment?
> 
> This way we at least get the same behavior for both types of
> allocation.
> 
> [1] http://lists.infradead.org/pipermail/linux-snps-arc/2018-July/004009.html
> [2] http://lists.infradead.org/pipermail/linux-snps-arc/2018-July/004036.html
> 
> Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: David Laight <David.Laight@ACULAB.COM>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vineet Gupta <vgupta@synopsys.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Greg KH <greg@kroah.com>
> Cc: <stable@vger.kernel.org> # 4.8+
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
> ---
>  drivers/base/devres.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/devres.c b/drivers/base/devres.c
> index 71d577025285..e43a04a495a3 100644
> --- a/drivers/base/devres.c
> +++ b/drivers/base/devres.c
> @@ -25,8 +25,14 @@ struct devres_node {
>  
>  struct devres {
>  	struct devres_node		node;
> -	/* -- 3 pointers */
> -	unsigned long long		data[];	/* guarantee ull alignment */
> +	/*
> +	 * Some archs want to perform DMA into kmalloc caches
> +	 * and need a guaranteed alignment larger than
> +	 * the alignment of a 64-bit integer.
> +	 * Thus we use ARCH_KMALLOC_MINALIGN here and get exactly the same
> +	 * buffer alignment as if it was allocated by plain kmalloc().
> +	 */
> +	u8 __aligned(ARCH_KMALLOC_MINALIGN) data[];
>  };
>  
>  struct devres_group {

This is not needed in any of the older kernels, despite what the stable@
line said, as it ends up taking a lot of memory up for all other arches.
That's why I only applied it to the one kernel version.  I'm betting
that it will be eventually reverted when people notice it as well :)

So can you please drop it from all of your trees?

thanks,

greg k-h
