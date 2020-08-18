Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE852248E92
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 21:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgHRTXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 15:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbgHRTXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 15:23:42 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2CBC061389
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 12:23:42 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id u10so9675690plr.7
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 12:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=JbanDd8Mxq4lbXlNdeQohXIPU4n8ZqVRR0ESmcSwiL8=;
        b=Wqndhtkrnd61rB/hMfZkaQ2A3n+gkOkwbcWohmFe2cNDZkMxP15AhTl8J7Vblkdp4H
         Fm7HiyBatOXOZYbybVyPyJKNkf8uufkL6PzqDdT0s0AIjRBLIo/o7c3X8Vzk+d22sISi
         3hinjWJe+PY2CMwGsrHeT1pzEq4r5EUdMK64I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=JbanDd8Mxq4lbXlNdeQohXIPU4n8ZqVRR0ESmcSwiL8=;
        b=iUujizI5yixV5x6iaTOQi1Gkfu38cGyw9/vdBMCm1x8CQ4qxuCF611cVRPeUh5ziGy
         3BYnVjn2HOxQA+Ho9uzdHp0HmeLQS7Z1M+Roxb7rPSVTXh6omh9ZYS1J47df1POaslSS
         O3ZSn67INTQEPfdUD1A6YcjtOgWNDY31SSucF/WMF7+OaRcmKWA+IW6toHeiinki63E2
         KBGELWVjvpEpndBN6KeIGv4uxLbK+OkXiJm1DBBzrdC2f44qT4UWCLSzNDN01zvzn03b
         vHJpPYEuQnrZS7FslJVfHVK0r24FaR724c9apV86D0fRSoXjyf0g58zzVxIqmI9Hpnmf
         b0KQ==
X-Gm-Message-State: AOAM531SEE4rY3QhmuLuEO5OkHGr13wQp+069ljHQmunvzX77N8QjC+A
        BiL4/dJ/8Cs5jlUtb/bh5eV+ag==
X-Google-Smtp-Source: ABdhPJxA7O9Q2PgEpaK/Vztq5tD7+BGEffskIGsHzKeRf0yRsj8mixcHcpIroPuaxxM9Xx/SmHV/AA==
X-Received: by 2002:a17:90a:fc86:: with SMTP id ci6mr1166370pjb.160.1597778621992;
        Tue, 18 Aug 2020 12:23:41 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 30sm630465pjz.24.2020.08.18.12.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 12:23:40 -0700 (PDT)
Date:   Tue, 18 Aug 2020 12:23:39 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Joe Perches <joe@perches.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Daniel Axtens <dja@axtens.net>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Yury Norov <yury.norov@gmail.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Bruce Ashfield <bruce.ashfield@gmail.com>,
        Marco Elver <elver@google.com>,
        Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>,
        Andi Kleen <ak@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?iso-8859-1?Q?D=E1vid_Bolvansk=FD?= <david.bolvansky@gmail.com>,
        Eli Friedman <efriedma@quicinc.com>, stable@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH 1/4] Makefile: add -fno-builtin-stpcpy
Message-ID: <202008181223.4412CAA5@keescook>
References: <20200817220212.338670-1-ndesaulniers@google.com>
 <20200817220212.338670-2-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200817220212.338670-2-ndesaulniers@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 03:02:09PM -0700, Nick Desaulniers wrote:
> LLVM implemented a recent "libcall optimization" that lowers calls to
> `sprintf(dest, "%s", str)` where the return value is used to
> `stpcpy(dest, str) - dest`. This generally avoids the machinery involved
> in parsing format strings. This optimization was introduced into
> clang-12. Because the kernel does not provide an implementation of
> stpcpy, we observe linkage failures for almost all targets when building
> with ToT clang.
> 
> The interface is unsafe as it does not perform any bounds checking.
> Disable this "libcall optimization" via `-fno-builtin-stpcpy`.
> 
> Unlike
> commit 5f074f3e192f ("lib/string.c: implement a basic bcmp")
> which cited failures with `-fno-builtin-*` flags being retained in LLVM
> LTO, that bug seems to have been fixed by
> https://reviews.llvm.org/D71193, so the above sha can now be reverted in
> favor of `-fno-builtin-bcmp`.
> 
> Cc: stable@vger.kernel.org # 4.4
> Link: https://bugs.llvm.org/show_bug.cgi?id=47162
> Link: https://github.com/ClangBuiltLinux/linux/issues/1126
> Link: https://reviews.llvm.org/D85963
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Suggested-by: Dávid Bolvanský <david.bolvansky@gmail.com>
> Suggested-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
