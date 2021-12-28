Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230F7480BC7
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 18:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236437AbhL1RFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 12:05:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:23840 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233280AbhL1RFF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Dec 2021 12:05:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640711105; x=1672247105;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KHhXdEfIwTp7IIrrW70KmlJrU5+AcMwf8sgzb0u1BTQ=;
  b=BQDV12zufIn3y7kViZ5Jpt3ulVBzf1xgHYmdvpui4sYL++yBRhMLLgZl
   +In54oVBpemChMdhPSSao9SBGGuQnw129cutz7Qf/nNUzRCAFu7YWz9R2
   GxD3zZn3E64NTF62bjny9/LAO6irwQAZcUtaMYwEa2FUmSNP83yXJQxHU
   0Z9wgDM+bnvLBFseQ3FQ4ne1jZh4VKaDmMBeEuEKGlgQCkglp0egUZOAw
   Uc7z7Dlj7IfP9sX+k+2BvvismjYilXtXFrvVgBSma1hHoodEN3fhtyl1j
   cgprRmSQTooX90qS62YE/hsf/m7imZoI75H3rmwRsPJBt8R2BRSmon1qS
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10211"; a="241195850"
X-IronPort-AV: E=Sophos;i="5.88,242,1635231600"; 
   d="scan'208";a="241195850"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2021 09:05:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,242,1635231600"; 
   d="scan'208";a="572369723"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga008.fm.intel.com with ESMTP; 28 Dec 2021 09:04:56 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1BSH4sNa000463;
        Tue, 28 Dec 2021 17:04:54 GMT
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
Date:   Tue, 28 Dec 2021 18:03:08 +0100
Message-Id: <20211228170308.1454063-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <YcovajZkEd0WY8p4@zn.tnic>
References: <20211223002209.1092165-1-alexandr.lobakin@intel.com> <20211223002209.1092165-2-alexandr.lobakin@intel.com> <YcShenJgaOeOdbIj@zn.tnic> <20211227182246.1447062-1-alexandr.lobakin@intel.com> <YcovajZkEd0WY8p4@zn.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>
Date: Mon, 27 Dec 2021 22:26:02 +0100

> On Mon, Dec 27, 2021 at 07:22:46PM +0100, Alexander Lobakin wrote:
> > It's just a couple lines below. I trigger this using `-z uniq-symbol`
> > which uses numeric suffixes for globals as well.
> 
> Aha, so that's for the fgkaslr purposes now.

Well, linking using unique names is meant to be used always
when available and livepatching is enabled, at least I hope so.

> 
> > It fixes a commit dated 2014, thus Cc:stable. Although the
> > remove_dot() might've been introduced for neverlanded GCC LTO, but
> > in fact numeric suffixes are used a lot by the toolchains in regular
> > builds as well. Just not for globals, that's why it's "well hidden".
> 
> Does "well hidden" warrant a stable backport then? Because if no
> toolchain is using numeric suffixes for globals, then no need for the
> stable tag, I'd say.

Hmm, makes sense. The fact that I haven't seen any similar reports
or issues (even on LTO builds) sorta says there are no benefits from
backporting this.
Ok, I'll drop the tag. It's never too late anyway to port this in
case someone will face it.

> 
> > I thought it's a common saying in commit messages, isn't it?
> 
> Lemme give you my canned and a lot more eloquent explanation for that:
> 
> "Please use passive voice in your commit message: no "we" or "I", etc,
> and describe your changes in imperative mood.
> 
> Also, pls read section "2) Describe your changes" in
> Documentation/process/submitting-patches.rst for more details.
> 
> Also, see section "Changelog" in
> Documentation/process/maintainer-tip.rst
> 
> Bottom line is: personal pronouns are ambiguous in text, especially with
> so many parties/companies/etc developing the kernel so let's avoid them
> please."
> 
> Thx.

Ah, you're right. "Common used" doesn't mean "correct". I'll fix it
in the next spin being published after accumulating a bunch more
comments.
Thanks!

> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

Al
