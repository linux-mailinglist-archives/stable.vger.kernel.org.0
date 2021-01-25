Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D20303221
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 03:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729677AbhAYOj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 09:39:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:56586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729417AbhAYOhl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 09:37:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D793E2311D;
        Mon, 25 Jan 2021 14:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611585249;
        bh=bxzG9qoPXd8t0Jl2EXPbV3luOXZ1glKR1qlcJC0Q3m0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WvFPQel7mDGtqBBgJMhHxxdr9hNZ0kcUPwoRA9anYtbLU4VaKbd5ntUtvSBJC/sa6
         XQudlVYUIwAoznG8x9nr46u13PX1F/JFMBHEdth6F2905Ahk7nJ/53e7b+24edB5ru
         wEkhCtUfZIb65a/C7shZtfVtQIs6xPz6AAdoz3hs=
Date:   Mon, 25 Jan 2021 15:33:50 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Will Deacon <will@kernel.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Florian Weimer <fweimer@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [STABLE BACKPORT v2 4.4.y, 4.9.y and 4.14.y] compiler.h: Raise
 minimum version of GCC to 5.1 for arm64
Message-ID: <YA7WztCb4OGA6m4S@kroah.com>
References: <20210125132425.28245-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125132425.28245-1-will@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 25, 2021 at 01:24:25PM +0000, Will Deacon wrote:
> commit dca5244d2f5b94f1809f0c02a549edf41ccd5493 upstream.
> 
> GCC versions >= 4.9 and < 5.1 have been shown to emit memory references
> beyond the stack pointer, resulting in memory corruption if an interrupt
> is taken after the stack pointer has been adjusted but before the
> reference has been executed. This leads to subtle, infrequent data
> corruption such as the EXT4 problems reported by Russell King at the
> link below.
> 
> Life is too short for buggy compilers, so raise the minimum GCC version
> required by arm64 to 5.1.
> 
> Reported-by: Russell King <linux@armlinux.org.uk>
> Suggested-by: Arnd Bergmann <arnd@kernel.org>
> Signed-off-by: Will Deacon <will@kernel.org>
> Tested-by: Nathan Chancellor <natechancellor@gmail.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: <stable@vger.kernel.org> # 4.4.y, 4.9.y and 4.14.y only
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Florian Weimer <fweimer@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Nathan Chancellor <natechancellor@gmail.com>
> Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
> Link: https://lore.kernel.org/r/20210105154726.GD1551@shell.armlinux.org.uk
> Link: https://lore.kernel.org/r/20210112224832.10980-1-will@kernel.org
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> [will: backport to 4.4.y/4.9.y/4.14.y; add __clang__ check]
> Link: https://lore.kernel.org/r/CA+G9fYuzE9WMSB7uGjV4gTzK510SHEdJb_UXQCzsQ5MqA=h9SA@mail.gmail.com
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  include/linux/compiler-gcc.h | 6 ++++++
>  1 file changed, 6 insertions(+)

Thanks, now queued up, let's try this again :)

greg k-h
