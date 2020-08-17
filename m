Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E49B247A86
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 00:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729943AbgHQWfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 18:35:01 -0400
Received: from terminus.zytor.com ([198.137.202.136]:39385 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729013AbgHQWe7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 18:34:59 -0400
Received: from hanvin-mobl2.amr.corp.intel.com (jfdmzpr03-ext.jf.intel.com [134.134.139.72])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id 07HMVRrV2411257
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Mon, 17 Aug 2020 15:31:28 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 07HMVRrV2411257
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020072401; t=1597703492;
        bh=LKtFMKVgtOY/6bgoWtqeglon0IHwcNuLxWmX3T+HkBY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=KUs7+/XBtVIJ5EhmCEDOIFwDAK8ODSK/P6kH2ED3Bu4rW+YQeCQqon9LYR0NK5LC+
         XgQOIWhLEolFJ4ch6EKj5UrDoPQs9dnlUSSb3yt6uJ40aafO46eEMZv1opQv90pbpP
         X9KOBLkOpUTVXo6wEbH4JKjlBcFoF08kR2S3yzmUJyqhkHsXIgoq+WX9dVAbrEUtC3
         U0epQC9hqP8YKAGWe165qUj94F1RyQGO1JO7/z3Wic08vA257p/1UsIhQrsDI+g7AY
         /8Tv2E9Fc3r1YaA1q23uEMeXe5d7q6TO5m2r4/4dTHFM/EMEvRdGv+JWghE9zqrJei
         XF/IHfC1GR7sA==
Subject: Re: [PATCH 1/4] Makefile: add -fno-builtin-stpcpy
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc:     Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
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
        Ard Biesheuvel <ardb@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Bruce Ashfield <bruce.ashfield@gmail.com>,
        Marco Elver <elver@google.com>,
        Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>,
        Andi Kleen <ak@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?B?RMOhdmlkIEJvbHZhbnNrw70=?= <david.bolvansky@gmail.com>,
        Eli Friedman <efriedma@quicinc.com>, stable@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
References: <20200817220212.338670-1-ndesaulniers@google.com>
 <20200817220212.338670-2-ndesaulniers@google.com>
From:   "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <82bbeff7-acc3-410c-9bca-3644b141dc1a@zytor.com>
Date:   Mon, 17 Aug 2020 15:31:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200817220212.338670-2-ndesaulniers@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-08-17 15:02, Nick Desaulniers wrote:
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

stpcpy() and (to a lesser degree) mempcpy() are fairly useful routines
in general. Perhaps we *should* provide them?

	-hpa

