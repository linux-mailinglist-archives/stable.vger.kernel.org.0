Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDC738CD7D
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 20:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbhEUSdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 14:33:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232583AbhEUSdX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 May 2021 14:33:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACD8961163;
        Fri, 21 May 2021 18:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621621919;
        bh=W8ZFnZ6K3bOgQrFcSo55/C7NzWOnuNznfcybWALo6YU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WceCxk/9f5UBFse+HmJ7rgt0dcvUYp13RTHjPUudWyPk7YCNBXcPuhATDVj5Z7gRI
         iV7hmQftGvAjw0NVlzLYCyfhqMzH6lUJnFwvZ8UMHCnAx2AP3iPK0NvHzO7H+fH6cw
         0PVz87hSFDKk91MYFK7ivhB3VXgi0ETkvpLRbV7udGegis+a5pXvfgbIOR8FDNamMP
         6kVCT8Eny4Ty5cLaSWlUMcGNLx0uzG3pMvq3CsRCCQDUB4qu27NLyjuntc/vj0+BjK
         00UqqRpuJtUUh8qkCaDg1QLBoWQa+r35pB0XPe8LMiHQMl9IjLhzVXcYbgcp2dO8fU
         HjTen3/t6nMRQ==
Date:   Fri, 21 May 2021 11:31:54 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     x86@kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        clang-built-linux@googlegroups.com,
        Anthony Ruhier <aruhier@mailbox.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Fix location of '-plugin-opt=' flags
Message-ID: <YKf8mvg4diHLSJDt@archlinux-ax161>
References: <20210518190106.60935-1-nathan@kernel.org>
 <162161994470.2028902.331062863146834934.b4-ty@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162161994470.2028902.331062863146834934.b4-ty@chromium.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 21, 2021 at 10:59:10AM -0700, Kees Cook wrote:
> On Tue, 18 May 2021 12:01:06 -0700, Nathan Chancellor wrote:
> > Commit b33fff07e3e3 ("x86, build: allow LTO to be selected") added a
> > couple of '-plugin-opt=' flags to KBUILD_LDFLAGS because the code model
> > and stack alignment are not stored in LLVM bitcode. However, these flags
> > were added to KBUILD_LDFLAGS prior to the emulation flag assignment,
> > which uses ':=', so they were overwritten and never added to $(LD)
> > invocations. The absence of these flags caused misalignment issues in
> > the AMDGPU driver when compiling with CONFIG_LTO_CLANG, resulting in
> > general protection faults.
> > 
> > [...]
> 
> (I've slightly adjusted the title.)
> 
> Applied to for-next/clang/features, thanks!
> 
> [1/1] x86: lto: Fix location of '-plugin-opt=' flags
>       https://git.kernel.org/kees/c/5d6c8592ee5f
> 

Ingo picked this up in x86/urgent so you should not need to carry it.

https://git.kernel.org/tip/0024430e920f2900654ad83cd081cf52e02a3ef5

Cheers,
Nathan
