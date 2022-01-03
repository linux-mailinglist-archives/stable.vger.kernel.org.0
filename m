Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25701483143
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 14:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbiACNHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 08:07:44 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:34772 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbiACNHn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 08:07:43 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 071151F38B;
        Mon,  3 Jan 2022 13:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1641215262; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CfKcPwGIyGJQW9aOLx/cbEJU5MrKtxa4IusWdY1IjT8=;
        b=kHsrzV4/4xin7AyT/KKNZ9IKDWP/nEuJibfeGEN/Lx8s1B+YD6fZ/WK0aMxNuH+YY8tVGw
        btB3pQuF9/4ccMpNf2s9DJeOKScQY3zkQugypgxKHgJ04QPlVNeCoFLASJNFxai3PANL4A
        /1Rl/LRYWAhIjA7y41GMr3ydSsr+6lA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1641215262;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CfKcPwGIyGJQW9aOLx/cbEJU5MrKtxa4IusWdY1IjT8=;
        b=764CjpdSZETDyv26UB+aYKt/k+Ywf8zz4aec6DveZDIPbdM04KHQimgi1Z0vZsDCN3AyhL
        Kjax9zQsJrqvYfCg==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 4422DA3B81;
        Mon,  3 Jan 2022 13:07:40 +0000 (UTC)
Date:   Mon, 3 Jan 2022 14:07:40 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
cc:     linux-hardening@vger.kernel.org, x86@kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Ard Biesheuvel <ardb@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Bruce Schlobohm <bruce.schlobohm@intel.com>,
        Jessica Yu <jeyu@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Evgenii Shatokhin <eshatokhin@virtuozzo.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
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
In-Reply-To: <20211223002209.1092165-2-alexandr.lobakin@intel.com>
Message-ID: <alpine.LSU.2.21.2201031407240.15051@pobox.suse.cz>
References: <20211223002209.1092165-1-alexandr.lobakin@intel.com> <20211223002209.1092165-2-alexandr.lobakin@intel.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 23 Dec 2021, Alexander Lobakin wrote:

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
> 
> `-z uniq-symbol` linker flag which we are planning to use to

`-z unique-symbol`

Miroslav
