Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126E847E649
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 17:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349168AbhLWQTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 11:19:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349149AbhLWQTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Dec 2021 11:19:13 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7641C061401;
        Thu, 23 Dec 2021 08:19:12 -0800 (PST)
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 982081EC050F;
        Thu, 23 Dec 2021 17:19:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1640276345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=xD7MPmC+2ErQI45EeQc4ikxUsZJzTJ2cRRbJueAos0k=;
        b=D4SwgyECbZXrWKJoUzQiCtm8/t6M2YEw709TpWDVw6NzzAgX4EPGOR68xs9k8TPlpgvFUg
        0uKLMAXKLMbEhbiTqiLG6iucLxuQIsb8Ige1whlicMVNanfochNf6LZ8yBcVMXCvLp/d3r
        XBe2nuP9Sbzq1wdLW4ZEtOY7iA2jc38=
Date:   Thu, 23 Dec 2021 17:19:06 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     linux-hardening@vger.kernel.org, x86@kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Ard Biesheuvel <ardb@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Bruce Schlobohm <bruce.schlobohm@intel.com>,
        Jessica Yu <jeyu@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Evgenii Shatokhin <eshatokhin@virtuozzo.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Marios Pomonis <pomonis@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        "H.J. Lu" <hjl.tools@gmail.com>, Nicolas Pitre <nico@fluxnic.net>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-arch@vger.kernel.org, live-patching@vger.kernel.org,
        llvm@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH v9 01/15] modpost: fix removing numeric suffixes
Message-ID: <YcShenJgaOeOdbIj@zn.tnic>
References: <20211223002209.1092165-1-alexandr.lobakin@intel.com>
 <20211223002209.1092165-2-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211223002209.1092165-2-alexandr.lobakin@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 23, 2021 at 01:21:55AM +0100, Alexander Lobakin wrote:
> For now, that condition from remove_dot():
> 
> if (m && (s[n + m] == '.' || s[n + m] == 0))
> 
> which was designed to test if it's a dot or a \0 after the suffix
> is never satisfied.
> This is due to that s[n + m] always points to the last digit of a
> numeric suffix, not on the symbol next to it:
> 
> param_set_uint.0, s[n + m] is '0', s[n + m + 1] is '\0'
> 
> So it's off by one and was like that since 2014.

What's the relevance of this? Looking at

  7d02b490e93c ("Kbuild, lto: Drop .number postfixes in modpost")

what you're fixing here is something LTO-related. How do you trigger
this?

For a Cc:stable patch, I'm missing a lot of context.

> `-z uniq-symbol` linker flag which we are planning to use to
				     ^^

Who's "we"?

> simplify livepatching brings numeric suffixes back, fix this.
> Otherwise:
> 
> ERROR: modpost: "param_set_uint.0" [vmlinux] is a static EXPORT_SYMBOL
> 
> Fixes: fcd38ed0ff26 ("scripts: modpost: fix compilation warning")
> Cc: stable@vger.kernel.org # 3.17+
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>

...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
