Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCDCF286564
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 19:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgJGRDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 13:03:14 -0400
Received: from mail.skyhub.de ([5.9.137.197]:48632 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbgJGRDO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Oct 2020 13:03:14 -0400
Received: from zn.tnic (p200300ec2f09100045b18ec36a87abe5.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:1000:45b1:8ec3:6a87:abe5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9263B1EC0494;
        Wed,  7 Oct 2020 19:03:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1602090192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=R3Po/kkKVbylxU/+V5a34kAqvHVuTy9mr1Zd0GX+8yc=;
        b=kyK/SZw9k7BaHn7A/zsZjWgY8RMedt8ddMKE0qyiXLTwhxRx/Eq8+QZpHQc25UEB+jz65U
        AM/cY7enxcSCIG4ExzZAFfdQVWDXxIIMUmV3CvsfJMqVVhVrLZpPYpbC+EwJNi404sByWW
        OCLsdzgGwEQYD0mPC6pSbTGFmn4UTwU=
Date:   Wed, 7 Oct 2020 19:03:05 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-tip-commits@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [tip: ras/core] x86, powerpc: Rename memcpy_mcsafe() to
 copy_mc_to_{user, kernel}()
Message-ID: <20201007170305.GK5607@zn.tnic>
References: <CAHk-=wjSqtXAqfUJxFtWNwmguFASTgB0dz1dT3V-78Quiezqbg@mail.gmail.com>
 <160197822988.7002.13716982099938468868.tip-bot2@tip-bot2>
 <20201007111447.GA23257@zn.tnic>
 <20201007164536.GJ5607@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201007164536.GJ5607@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 07, 2020 at 06:45:36PM +0200, Borislav Petkov wrote:
> It doesn't look like it is toolchain-specific and in both cases,
> copy_mc_fragile's checksum is 0.
> 
> SUSE Leap 15.1:
> 
> Name           : binutils                                        
> Version        : 2.32-lp151.3.6.1
> 
> $ grep -E "(copy_mc_fragile|copy_user_generic_unrolled)" Module.symvers
> 0x00000000      copy_mc_fragile vmlinux EXPORT_SYMBOL_GPL
> 0xecdcabd2      copy_user_generic_unrolled      vmlinux EXPORT_SYMBOL
> 
> debian testing:
> 
> Package: binutils
> Version: 2.35-2
> 
> $ grep -E "(copy_mc_fragile|copy_user_generic_unrolled)" Module.symvers 
> 0x00000000      copy_mc_fragile vmlinux EXPORT_SYMBOL_GPL
> 0xecdcabd2      copy_user_generic_unrolled      vmlinux EXPORT_SYMBOL

Ok, I think I have it:

---
From: Borislav Petkov <bp@suse.de>
Date: Wed, 7 Oct 2020 18:55:35 +0200
Subject: [PATCH] x86/mce: Allow for copy_mc_fragile symbol checksum to be generated

Add asm/mce.h to asm/asm-prototypes.h so that that asm symbol's checksum
can be generated in order to support CONFIG_MODVERSIONS with it and fix:

  WARNING: modpost: EXPORT symbol "copy_mc_fragile" [vmlinux] version \
	  generation failed, symbol will not be versioned.

For reference see:

  4efca4ed05cb ("kbuild: modversions for EXPORT_SYMBOL() for asm")
  334bb7738764 ("x86/kbuild: enable modversions for symbols exported from asm")

Fixes: ec6347bb4339 ("x86, powerpc: Rename memcpy_mcsafe() to copy_mc_to_{user, kernel}()")
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/asm-prototypes.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/asm-prototypes.h b/arch/x86/include/asm/asm-prototypes.h
index 5a42f9206138..51e2bf27cc9b 100644
--- a/arch/x86/include/asm/asm-prototypes.h
+++ b/arch/x86/include/asm/asm-prototypes.h
@@ -5,6 +5,7 @@
 #include <asm/string.h>
 #include <asm/page.h>
 #include <asm/checksum.h>
+#include <asm/mce.h>
 
 #include <asm-generic/asm-prototypes.h>
 
-- 
2.21.0

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
