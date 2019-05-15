Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44DC31F8D0
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 18:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfEOQmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 12:42:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbfEOQmS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 12:42:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 943F720881;
        Wed, 15 May 2019 16:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557938538;
        bh=XCMuehsqXD5hXI8GXAW5pMiN0xlhJr3/Luwp6WgYULw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BzDoaEWpO9VpZ07inczQvDAzK8GuQ4pGODVCgRO+J82My1abChqbf0MDwmj7Diq1a
         MocbdVCh/SBL38jo9deh/Itq5M+TxtBEo8ceRNU5M22GjEZnqb+VnPZogva+5Z3jns
         sbFD8SrHSjocyhsqEvyHA4fU41CG7jgW8bZ4gcD8=
Date:   Wed, 15 May 2019 18:42:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/115] 4.14.120-stable review
Message-ID: <20190515164215.GA6053@kroah.com>
References: <20190515090659.123121100@linuxfoundation.org>
 <20190515162638.GA25612@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515162638.GA25612@roeck-us.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 15, 2019 at 09:26:38AM -0700, Guenter Roeck wrote:
> On Wed, May 15, 2019 at 12:54:40PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.120 release.
> > There are 115 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 17 May 2019 09:04:39 AM UTC.
> > Anything received after that time might be too late.
> > 
> 
> There is a build error with s390 builds.
> 
> arch/s390/kernel/nospec-branch.c: In function 'nospec_auto_detect':
> arch/s390/kernel/nospec-branch.c:84:19: error:
> 	invalid storage class for function 'spectre_v2_setup_early'
> 
> arch/s390/kernel/nospec-branch.c:96:27: error:
> 	initializer element is not constant
> 
> and more. The file has merge damage in function nospec_auto_detect().
> Culprit is commit 91788fcb21d0 ("s390/speculation: Support 'mitigations='
> cmdline option"). That patch is in v4.14.119, so you'll have to patch
> it up manually. Example patch (compile tested) below.
> 
> Guenter
> 
> ---
> >From c4430ee29bf57cb1327d52b38acf3f616be9d7f5 Mon Sep 17 00:00:00 2001
> From: Guenter Roeck <linux@roeck-us.net>
> Date: Wed, 15 May 2019 09:22:31 -0700
> Subject: [PATCH] s390/speculation: Fix build error caused by bad backport
> 
> The backport of commit 0336e04a6520 ("s390/speculation: Support
> 'mitigations=' cmdline option") introduces a build error. Fix it up.
> 
> Fixes: 91788fcb21d0 ("s390/speculation: Support 'mitigations=' cmdline option")
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  arch/s390/kernel/nospec-branch.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/s390/kernel/nospec-branch.c b/arch/s390/kernel/nospec-branch.c
> index 83e597688562..6956902bba12 100644
> --- a/arch/s390/kernel/nospec-branch.c
> +++ b/arch/s390/kernel/nospec-branch.c
> @@ -66,6 +66,7 @@ void __init nospec_auto_detect(void)
>  		if (IS_ENABLED(CC_USING_EXPOLINE))
>  			nospec_disable = 1;
>  		__clear_facility(82, S390_lowcore.alt_stfle_fac_list);
> +	}
>  	if (IS_ENABLED(CC_USING_EXPOLINE)) {
>  		/*
>  		 * The kernel has been compiled with expolines.
> -- 
> 2.7.4
> 

Yes, that backport was broken, good catch.  Now queued up, thanks.

greg k-h
