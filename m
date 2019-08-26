Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D87AE9D47A
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 18:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731578AbfHZQuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 12:50:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729338AbfHZQuY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 12:50:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8115420850;
        Mon, 26 Aug 2019 16:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566838224;
        bh=/JWCSqfQ4tLkHWbblH7A3gEnEXo0rRv/7eaJXLeukvg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cch9Lkn060b3M5FmvtgVjdEu4sANIukuEaOsZW26nUjq2HQapBYq+Lq5Gz3ePW+yE
         R11lIuSM3MdvIDMwXgn1YKD38sgh5DhwgH/GD8aReh8qV2Jq3RFmW0FSslu6OJEGuv
         V1w9lMprNWO+JqHsnsGBcFfzYceoq0Fo4Qpnw5Jo=
Date:   Mon, 26 Aug 2019 18:50:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alastair D'Silva <alastair@au1.ibm.com>
Cc:     alastair@d-silva.org, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] powerpc: Allow flush_(inval_)dcache_range to work
 across ranges >4GB
Message-ID: <20190826165021.GB9305@kroah.com>
References: <20190821001929.4253-1-alastair@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821001929.4253-1-alastair@au1.ibm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 21, 2019 at 10:19:27AM +1000, Alastair D'Silva wrote:
> From: Alastair D'Silva <alastair@d-silva.org>
> 
> The upstream commit:
> 22e9c88d486a ("powerpc/64: reuse PPC32 static inline flush_dcache_range()")
> has a similar effect, but since it is a rewrite of the assembler to C, is
> too invasive for stable. This patch is a minimal fix to address the issue in
> assembler.
> 
> This patch applies cleanly to v5.2, v4.19 & v4.14.
> 
> When calling flush_(inval_)dcache_range with a size >4GB, we were masking
> off the upper 32 bits, so we would incorrectly flush a range smaller
> than intended.
> 
> This patch replaces the 32 bit shifts with 64 bit ones, so that
> the full size is accounted for.
> 
> Changelog:
> v2
>   - Add related upstream commit
> 
> Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> ---
>  arch/powerpc/kernel/misc_64.S | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/misc_64.S b/arch/powerpc/kernel/misc_64.S
> index 1ad4089dd110..d4d096f80f4b 100644
> --- a/arch/powerpc/kernel/misc_64.S
> +++ b/arch/powerpc/kernel/misc_64.S
> @@ -130,7 +130,7 @@ _GLOBAL_TOC(flush_dcache_range)
>  	subf	r8,r6,r4		/* compute length */
>  	add	r8,r8,r5		/* ensure we get enough */
>  	lwz	r9,DCACHEL1LOGBLOCKSIZE(r10)	/* Get log-2 of dcache block size */
> -	srw.	r8,r8,r9		/* compute line count */
> +	srd.	r8,r8,r9		/* compute line count */
>  	beqlr				/* nothing to do? */
>  	mtctr	r8
>  0:	dcbst	0,r6
> @@ -148,7 +148,7 @@ _GLOBAL(flush_inval_dcache_range)
>  	subf	r8,r6,r4		/* compute length */
>  	add	r8,r8,r5		/* ensure we get enough */
>  	lwz	r9,DCACHEL1LOGBLOCKSIZE(r10)/* Get log-2 of dcache block size */
> -	srw.	r8,r8,r9		/* compute line count */
> +	srd.	r8,r8,r9		/* compute line count */
>  	beqlr				/* nothing to do? */
>  	sync
>  	isync

I need an ack from the powerpc maintainer(s) before I can take this.

thanks,

greg k-h
