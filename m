Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF428CD88
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 10:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725280AbfHNIEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 04:04:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725265AbfHNIEm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 04:04:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B23B3205C9;
        Wed, 14 Aug 2019 08:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565769882;
        bh=/fDJPsiW3NnVLN7d9MDDwbovOT8MAjMF3WI3RCZF5uk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dUKLRHUei6GfP1s/XGsqp+wFzuf6u5+x6i0Rd77wxe6VGIGnD5KCD+i2CCcTgczKc
         bDf75B7z/+cOVlJ2TQ69nEiP3tfRygNQBcFo7cOldW7atvOI/buy3OwExj93y+TSBr
         BT6vJy5D/S7CSmu5RZKwCbAtxTbN3GtlS9kYXpNk=
Date:   Wed, 14 Aug 2019 10:04:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     adelva@google.com, manojgupta@google.com, tglx@linutronix.de,
        vaibhavrustagi@google.com, stable@vger.kernel.org
Subject: Re: [4.19 PATCH] x86/purgatory: Do not use __builtin_memcpy and
 __builtin_memset
Message-ID: <20190814080439.GA28460@kroah.com>
References: <1565721608151140@kroah.com>
 <20190813211930.42094-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813211930.42094-1-ndesaulniers@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 13, 2019 at 02:19:30PM -0700, Nick Desaulniers wrote:
> commit 4ce97317f41d38584fb93578e922fcd19e535f5b upstream.
> 
> Implementing memcpy and memset in terms of __builtin_memcpy and
> __builtin_memset is problematic.
> 
> GCC at -O2 will replace calls to the builtins with calls to memcpy and
> memset (but will generate an inline implementation at -Os).  Clang will
> replace the builtins with these calls regardless of optimization level.
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
> Instead, reuse an implementation from arch/x86/boot/compressed/string.c.
> This requires to implement a stub function for warn(). Also, Clang may
> lower memcmp's that compare against 0 to bcmp's, so add a small definition,
> too. See also: commit 5f074f3e192f ("lib/string.c: implement a basic bcmp")
> 
> Fixes: 8fc5b4d4121c ("purgatory: core purgatory functionality")
> Reported-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> Debugged-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> Debugged-by: Manoj Gupta <manojgupta@google.com>
> Suggested-by: Alistair Delva <adelva@google.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Tested-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> Cc: stable@vger.kernel.org
> Link: https://bugs.chromium.org/p/chromium/issues/detail?id=984056
> Link: https://lkml.kernel.org/r/20190807221539.94583-1-ndesaulniers@google.com
> ---
> This failed to cherry-pick back cleanly due to the SPDX license
> identifier not existing in arch/x86/purgatory/string.c in 4.19. `git rm`
> it anyway.

Now queued up, thanks.

So the Fixes: tag does not mean this should be backported to anything
older?  It implies this bug has been in the kernel since the 3.17
release.

thanks,

greg k-h
