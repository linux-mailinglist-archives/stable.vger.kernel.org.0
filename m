Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84EE06C3DE
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 02:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbfGRArT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 20:47:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727557AbfGRArS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 20:47:18 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D5B4217F4;
        Thu, 18 Jul 2019 00:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563410837;
        bh=xdUPLnhzHIdZRYZi8AUKI9yOcgq9hjqy1SmitBqoN1k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=moALQlLXZ2zUwy7M4eJ872ZP8pni0uVTPRs5iRtREQbZLbfB6Junpc+piQ0kFklt/
         x/Rhw75/MByDS0k0J4Zb1HEinxnFXFscat18Bve55q5AwQRk0q1cnFZNm4T52Ezd8/
         HPAsizUyafk7GSk5dYymd2CQ2YIaBn14f2lk+gbY=
Date:   Thu, 18 Jul 2019 09:47:15 +0900
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vaibhav Rustagi <vaibhavrustagi@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org, Manoj Gupta <manojgupta@google.com>,
        Alistair Delva <adelva@google.com>
Subject: Re: [PATCH 2/2] x86/purgatory: do not use __builtin_memcpy and
 __builtin_memset.
Message-ID: <20190718004715.GB31085@kroah.com>
References: <20190718000206.121392-1-vaibhavrustagi@google.com>
 <20190718000206.121392-3-vaibhavrustagi@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718000206.121392-3-vaibhavrustagi@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 17, 2019 at 05:02:06PM -0700, Vaibhav Rustagi wrote:
> From: Nick Desaulniers <ndesaulniers@google.com>
> 
> Implementing memcpy and memset in terms of __builtin_memcpy and
> __builtin_memset is problematic.
> 
> GCC at -O2 will replace calls to the builtins with calls to memcpy and
> memset (but will generate an inline implementation at -Os).  Clang will
> replace the builtins with these calls regardless of optimization level.
> 
> $ llvm-objdump -dr arch/x86/purgatory/string.o | tail
> 
> 0000000000000339 memcpy:
>      339: 48 b8 00 00 00 00 00 00 00 00 movabsq $0, %rax
>                 000000000000033b:  R_X86_64_64  memcpy
>      343: ff e0                         jmpq    *%rax
> 
> 0000000000000345 memset:
>      345: 48 b8 00 00 00 00 00 00 00 00 movabsq $0, %rax
>                 0000000000000347:  R_X86_64_64  memset
>      34f: ff e0
> 
> Such code results in infinite recursion at runtime. This is observed
> when doing kexec.
> 
> Instead, reuse an implementation from arch/x86/boot/compressed/string.c
> if we define warn as a symbol.
> 
> Link: https://bugs.chromium.org/p/chromium/issues/detail?id=984056
> Reported-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> Tested-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> Debugged-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> Debugged-by: Manoj Gupta <manojgupta@google.com>
> Suggested-by: Alistair Delva <adelva@google.com>
> Signed-off-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  arch/x86/purgatory/Makefile    |  3 +++
>  arch/x86/purgatory/purgatory.c |  6 ++++++
>  arch/x86/purgatory/string.c    | 23 -----------------------
>  3 files changed, 9 insertions(+), 23 deletions(-)
>  delete mode 100644 arch/x86/purgatory/string.c

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
