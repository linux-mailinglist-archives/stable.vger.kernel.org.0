Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5AA648033C
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 19:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhL0SYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 13:24:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:17765 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229499AbhL0SYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Dec 2021 13:24:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640629474; x=1672165474;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C+oHdzLPkEGQP3y/+XFIUPLmI6lwlv3Q34bwmNyrap0=;
  b=Bti2dIM159+jnGedGs39yvdLHWV85qLfm6BV69C9e7Nw8ryFL4VhHSUT
   YmN0Ncq73CHMQpxBJretjFurRm6V49Asw3FDfv8pCLWb/Dm1e3z5w44W6
   lcE+oeftX/HDXNd47XN8G9pEqXKA8bnwYQokKSziNIWCXYwCCHFriQPL0
   HJMCnYNp4HKrs540WWiNRPjCyLmd9r2RsKGUv1S/MqeBO2xNqQVuqbg0C
   LtmAgW6p391IKgasn2/rMmycvI+ZTRRfXnF9f2ikcH/SPqa9PYey0tuGp
   3ZgpzbAL3dahxA74x9wd5RqMFimNk0sQiAPiniS9r0iBRRDZcoFt+zdm7
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10210"; a="241058128"
X-IronPort-AV: E=Sophos;i="5.88,240,1635231600"; 
   d="scan'208";a="241058128"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2021 10:24:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,240,1635231600"; 
   d="scan'208";a="609115399"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Dec 2021 10:24:25 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1BRIONTP032398;
        Mon, 27 Dec 2021 18:24:23 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        linux-hardening@vger.kernel.org, x86@kernel.org,
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
Date:   Mon, 27 Dec 2021 19:22:46 +0100
Message-Id: <20211227182246.1447062-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <YcShenJgaOeOdbIj@zn.tnic>
References: <20211223002209.1092165-1-alexandr.lobakin@intel.com> <20211223002209.1092165-2-alexandr.lobakin@intel.com> <YcShenJgaOeOdbIj@zn.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>
Date: Thu, 23 Dec 2021 17:19:06 +0100

> On Thu, Dec 23, 2021 at 01:21:55AM +0100, Alexander Lobakin wrote:
> > For now, that condition from remove_dot():
> > 
> > if (m && (s[n + m] == '.' || s[n + m] == 0))
> > 
> > which was designed to test if it's a dot or a \0 after the suffix
> > is never satisfied.
> > This is due to that s[n + m] always points to the last digit of a
> > numeric suffix, not on the symbol next to it:
> > 
> > param_set_uint.0, s[n + m] is '0', s[n + m + 1] is '\0'
> > 
> > So it's off by one and was like that since 2014.
> 
> What's the relevance of this? Looking at
> 
>   7d02b490e93c ("Kbuild, lto: Drop .number postfixes in modpost")
> 
> what you're fixing here is something LTO-related. How do you trigger
> this?

It's just a couple lines below. I trigger this using `-z uniq-symbol`
which uses numeric suffixes for globals as well.

> 
> For a Cc:stable patch, I'm missing a lot of context.

It fixes a commit dated 2014, thus Cc:stable. Although the
remove_dot() might've been introduced for neverlanded GCC LTO, but
in fact numeric suffixes are used a lot by the toolchains in regular
builds as well. Just not for globals, that's why it's "well hidden".

> 
> > `-z uniq-symbol` linker flag which we are planning to use to
> 				     ^^
> 
> Who's "we"?

I thought it's a common saying in commit messages, isn't it?

> 
> > simplify livepatching brings numeric suffixes back, fix this.
> > Otherwise:
> > 
> > ERROR: modpost: "param_set_uint.0" [vmlinux] is a static EXPORT_SYMBOL
> > 
> > Fixes: fcd38ed0ff26 ("scripts: modpost: fix compilation warning")
> > Cc: stable@vger.kernel.org # 3.17+
> > Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> 
> ...
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

Thanks,
Al
