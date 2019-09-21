Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2EDB9C48
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 06:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbfIUE1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 00:27:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbfIUE1M (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Sep 2019 00:27:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E629206B6;
        Sat, 21 Sep 2019 04:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569040031;
        bh=1Ksjx36GBjJCwLCAdp+LH3QplM5fI+1WyaHUTLuWShI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cZAXyGvgbpSA/qyVm4Cglo87zVDJDolW1DjzMUWr7Ip/KTHmZ6sa8bFDU9DbOMvXG
         YoD4mgZBHXzr3VgBsYyR4qg/oOiLgdMXJQdWCW1atrpGm/AM0gbHCDsC3wu0uypgnJ
         NUVGGi3C//o5nqIYJGUgRoRmW7Ua7U+9zlkcMSs0=
Date:   Sat, 21 Sep 2019 06:27:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     John S Gruber <johnsgruber@gmail.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86-ml <x86@kernel.org>
Subject: Re: [PATCH] x86/boot: v4.4 stable and v4.9 stable boot failure due
 to dropped patch line
Message-ID: <20190921042708.GA989495@kroah.com>
References: <20190731054627.5627-2-jhubbard@nvidia.com>
 <1569028015-15344-1-git-send-email-JohnSGruber@gmail.com>
 <6c0cf9d6-852e-aea2-6bde-a5f5068ea236@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c0cf9d6-852e-aea2-6bde-a5f5068ea236@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 20, 2019 at 06:38:23PM -0700, John Hubbard wrote:
> On 9/20/19 6:06 PM, John S Gruber wrote:
> > This regards upstream commit a90118c445cc ("x86/boot: Save fields
> > explicitly, zero out everything else") application to linux-stable.
> > 
> > Its corresponding commits to the stable 4.4 and 4.9 trees didn't apply
> > correctly, probably due to a field name change (e820_table had been named
> > e820_map before 4.10).
> > 
> > On my desktop I'm unable to boot a signed kernel due to these commits.
> > 
> > Add e820_map (to replace e820_table) to the preserved fields so that the
> > E820 memory regions in boot_params can be accessed by the kernel after
> > boot_params has been sanitized.
> > 
> > Signed-off-by: John S Gruber <JohnSGruber@gmail.com>
> > Fixes: 41664b97f46e ("x86/boot: Save fields explicitly, zero out everything else")
> > Fixes: 4e478cb2ccdd ("x86/boot: Save fields explicitly, zero out everything else")
> > Link: https://lore.kernel.org/lkml/20190731054627.5627-2-jhubbard@nvidia.com/
> > ---
> > 
> > I tested stable 4.14.145, 4.19.74, and 5.2.16 successfully under the same
> > circumstances. Only 4.4 and 4.9 are affected by this dropped line.
> > 
> >  arch/x86/include/asm/bootparam_utils.h | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/x86/include/asm/bootparam_utils.h b/arch/x86/include/asm/bootparam_utils.h
> > index 0232b5a..588d8fb 100644
> > --- a/arch/x86/include/asm/bootparam_utils.h
> > +++ b/arch/x86/include/asm/bootparam_utils.h
> > @@ -71,6 +71,7 @@ static void sanitize_boot_params(struct boot_params *boot_params)
> >  			BOOT_PARAM_PRESERVE(edd_mbr_sig_buf_entries),
> >  			BOOT_PARAM_PRESERVE(edd_mbr_sig_buffer),
> >  			BOOT_PARAM_PRESERVE(hdr),
> > +			BOOT_PARAM_PRESERVE(e820_map),
> >  			BOOT_PARAM_PRESERVE(eddbuf),
> >  		};
> >  
> > 
> 
> Reviewed-by: John Hubbard <jhubbard@nvidia.com>
> 
> Thanks for getting -stable figured out and fixed--this has not been smooth sailing!

This change is already in the 4.4.y-rc and 4.9.y-rc releases that went
out two days ago for review.  So this should be fixed in the next
release.  If not, please let me know.

thanks,

greg k-h
