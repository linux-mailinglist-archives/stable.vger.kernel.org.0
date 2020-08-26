Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41F2253382
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 17:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgHZPW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 11:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727902AbgHZPWM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 11:22:12 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A24C061756
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 08:22:11 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 17so1148018pfw.9
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 08:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vtJDwZCH/3FF1e3t+ULJa3AUehUyh5L1H4fEzIfmn4o=;
        b=GIGN8wX3pyjKhCF0wAkRfMN1el9RjJWFj8wzMB0EPBzLhBY51FePhM2oaxSjBktdec
         RDZDUzX5TFXl/ymZSVgMFbtiqSqjXdFJv0OmSwVPBuLjXNQaSaxW/gsV3N3KUXtHSpXZ
         MIPBqbugEmDk8K+4S4vugfFpV7QHbzMIaOO1g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vtJDwZCH/3FF1e3t+ULJa3AUehUyh5L1H4fEzIfmn4o=;
        b=QE3MoFiUQua4V2R/NMRziBAibUDJziqyGGnPPKUpl4skGHP8BCwe4NFsfuBnQI8aBE
         fU0T4cO7EwYL9V516aMFydx24noEZA/H/DvxVrvVjDFmkfqZRhaBGWj+tWJmsp4eUGdA
         Z2paAhgeNaCneGXXvW0tP/GXKsvB4OR+XXmOv3jyZbL3lJQUnwdKjeW3hUOdtv5IrQ95
         88B6xpFgdp69K8wkIkPD5/s9a7AUEnJ8g1oyn1xFgsjILi0Do4MU1GvB7K/sC54tPhUf
         t3A92doQTIYij6TIaisGjFf3nTX9eCcFcnONghYKnIoWTO681QlVnFUg5B+B4FbcTUJy
         YzkA==
X-Gm-Message-State: AOAM530DiXKFE9z/VSE4tBidP+UoSPerW5zhBTPyx3OzrFziXCurN4yS
        xCFH5urzp3VwdMJsIfcQVz2Inw==
X-Google-Smtp-Source: ABdhPJzLyHWcSj7Vm+MuzdkYBxrO9j5DgXJEwOBbTsbHaZtpPhDC5bH383FmCZxfzvk8bd4r7nwv+A==
X-Received: by 2002:a63:330c:: with SMTP id z12mr11048145pgz.46.1598455331205;
        Wed, 26 Aug 2020 08:22:11 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id ck3sm2319962pjb.20.2020.08.26.08.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 08:22:10 -0700 (PDT)
Date:   Wed, 26 Aug 2020 08:22:09 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org,
        Andy Lavr <andy.lavr@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Joe Perches <joe@perches.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sami Tolvanen <samitolvanen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Yury Norov <yury.norov@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] lib/string.c: implement stpcpy
Message-ID: <202008260821.CF6D817B36@keescook>
References: <20200825140001.2941001-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825140001.2941001-1-ndesaulniers@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 25, 2020 at 07:00:00AM -0700, Nick Desaulniers wrote:
> LLVM implemented a recent "libcall optimization" that lowers calls to
> `sprintf(dest, "%s", str)` where the return value is used to
> `stpcpy(dest, str) - dest`. This generally avoids the machinery involved
> in parsing format strings.  `stpcpy` is just like `strcpy` except it
> returns the pointer to the new tail of `dest`.  This optimization was
> introduced into clang-12.
> 
> Implement this so that we don't observe linkage failures due to missing
> symbol definitions for `stpcpy`.
> 
> Similar to last year's fire drill with:
> commit 5f074f3e192f ("lib/string.c: implement a basic bcmp")
> 
> The kernel is somewhere between a "freestanding" environment (no full libc)
> and "hosted" environment (many symbols from libc exist with the same
> type, function signature, and semantics).
> 
> As H. Peter Anvin notes, there's not really a great way to inform the
> compiler that you're targeting a freestanding environment but would like
> to opt-in to some libcall optimizations (see pr/47280 below), rather than
> opt-out.
> 
> Arvind notes, -fno-builtin-* behaves slightly differently between GCC
> and Clang, and Clang is missing many __builtin_* definitions, which I
> consider a bug in Clang and am working on fixing.
> 
> Masahiro summarizes the subtle distinction between compilers justly:
>   To prevent transformation from foo() into bar(), there are two ways in
>   Clang to do that; -fno-builtin-foo, and -fno-builtin-bar.  There is
>   only one in GCC; -fno-buitin-foo.
> 
> (Any difference in that behavior in Clang is likely a bug from a missing
> __builtin_* definition.)
> 
> Masahiro also notes:
>   We want to disable optimization from foo() to bar(),
>   but we may still benefit from the optimization from
>   foo() into something else. If GCC implements the same transform, we
>   would run into a problem because it is not -fno-builtin-bar, but
>   -fno-builtin-foo that disables that optimization.
> 
>   In this regard, -fno-builtin-foo would be more future-proof than
>   -fno-built-bar, but -fno-builtin-foo is still potentially overkill. We
>   may want to prevent calls from foo() being optimized into calls to
>   bar(), but we still may want other optimization on calls to foo().
> 
> It seems that compilers today don't quite provide the fine grain control
> over which libcall optimizations pseudo-freestanding environments would
> prefer.
> 
> Finally, Kees notes that this interface is unsafe, so we should not
> encourage its use.  As such, I've removed the declaration from any
> header, but it still needs to be exported to avoid linkage errors in
> modules.
> 
> Cc: stable@vger.kernel.org
> Link: https://bugs.llvm.org/show_bug.cgi?id=47162
> Link: https://bugs.llvm.org/show_bug.cgi?id=47280
> Link: https://github.com/ClangBuiltLinux/linux/issues/1126
> Link: https://man7.org/linux/man-pages/man3/stpcpy.3.html
> Link: https://pubs.opengroup.org/onlinepubs/9699919799/functions/stpcpy.html
> Link: https://reviews.llvm.org/D85963
> Suggested-by: Andy Lavr <andy.lavr@gmail.com>
> Suggested-by: Arvind Sankar <nivedita@alum.mit.edu>
> Suggested-by: Joe Perches <joe@perches.com>
> Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
> Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
