Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281121E1B96
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 08:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgEZG4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 02:56:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727873AbgEZG4V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 02:56:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 929EB20776;
        Tue, 26 May 2020 06:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590476181;
        bh=nawe3MBL7YxVPoyFPa9J+pBh9x816z61tkOvrywTjF8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kirELv+kRS3LZp4kRekX2KxHQsvPM0Pg5Np/ECJASkjy5BEidyNh7gJQALZnn3FRE
         h23lhEzkP4YB7Kuz/ylMuKEFGWl7PbWwxORDj4/R+QGOEhq07HNUYQKAcA/sczEE1Q
         M0IjQada3t6JicUgfCLlFqyqrhpnC7LJgPUZq6ko=
Date:   Tue, 26 May 2020 08:56:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andi Kleen <andi@firstfloor.org>
Cc:     x86@kernel.org, keescook@chromium.org,
        linux-kernel@vger.kernel.org, sashal@kernel.org,
        Andi Kleen <ak@linux.intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1] x86: Pin cr4 FSGSBASE
Message-ID: <20200526065618.GC2580410@kroah.com>
References: <20200526052848.605423-1-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526052848.605423-1-andi@firstfloor.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 25, 2020 at 10:28:48PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Since there seem to be kernel modules floating around that set
> FSGSBASE incorrectly, prevent this in the CR4 pinning. Currently
> CR4 pinning just checks that bits are set, this also checks
> that the FSGSBASE bit is not set, and if it is clears it again.

So we are trying to "protect" ourselves from broken out-of-tree kernel
modules now?  Why stop with this type of check, why not just forbid them
entirely if we don't trust them?  :)

> Note this patch will need to be undone when the full FSGSBASE
> patches are merged. But it's a reasonable solution for v5.2+
> stable at least. Sadly the older kernels don't have the necessary
> infrastructure for this (although a simpler version of this
> could be added there too)
> 
> Cc: stable@vger.kernel.org # v5.2+
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/common.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index bed0cb83fe24..1f5b7871ae9a 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -385,6 +385,11 @@ void native_write_cr4(unsigned long val)
>  		/* Warn after we've set the missing bits. */
>  		WARN_ONCE(bits_missing, "CR4 bits went missing: %lx!?\n",
>  			  bits_missing);
> +		if (val & X86_CR4_FSGSBASE) {
> +			WARN_ONCE(1, "CR4 unexpectedly set FSGSBASE!?\n");

Like this will actually be noticed by anyone who calls this?  What is a
user supposed to do about this?

What about those systems that panic-on-warn?

> +			val &= ~X86_CR4_FSGSBASE;

So you just prevented them from setting this, thereby fixing up their
broken code that will never be fixed because you did this?  Why do this?

thanks,

greg k-h
