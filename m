Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4C81D0C59
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgEMJfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:35:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726532AbgEMJfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:35:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9136A206B8;
        Wed, 13 May 2020 09:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589362539;
        bh=z+UaaMB5VzpWkOt8a/KvmOlBDXVoE4oL6si/ZDEQVI0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xtkjCoga62rvSeA2kb6piiWiMP8BRFpOSXZ3IynOwz78sYNUpEhLALoKNMqw8yXnY
         PYEl6pwerhZJWj6JPGaxqzTNyWfiEfY4K7pT1gOoNEvh0V5V8lncs1kXUopa00mi9h
         K9mxRMIy1ptuzs5CZN5OLrZx8Bjg7G5dyQEewxvk=
Date:   Wed, 13 May 2020 11:35:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org,
        Alexey Brodkin <alexey.brodkin@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Laight <David.Laight@aculab.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vineet Gupta <vgupta@synopsys.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 4.4 03/16] devres: Align data[] to ARCH_KMALLOC_MINALIGN
Message-ID: <20200513093536.GB830571@kroah.com>
References: <20200423204014.784944-1-lee.jones@linaro.org>
 <20200423204014.784944-4-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423204014.784944-4-lee.jones@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 23, 2020 at 09:40:01PM +0100, Lee Jones wrote:
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
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/base/devres.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/devres.c b/drivers/base/devres.c
> index 8fc654f0807bf..9763325a9c944 100644
> --- a/drivers/base/devres.c
> +++ b/drivers/base/devres.c
> @@ -24,8 +24,14 @@ struct devres_node {
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
> -- 
> 2.25.1
> 

I don't want to apply this to older kernels as it could cause extra
memory usage for no good reason.  I have no idea why a non ARC system
would want it :(

greg k-h
