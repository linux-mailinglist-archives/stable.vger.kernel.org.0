Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B173E47DBC0
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 01:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345506AbhLWAXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 19:23:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:24264 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345581AbhLWAXU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Dec 2021 19:23:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640219000; x=1671755000;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S5S+dp45/rAFDGsVnGP9Us6qzcGYuMHcD0Pjh70Tu7U=;
  b=mzw9MKhh+K6C0mmiti2qZlgXDecPGIADlFhQfk2wGRk5qt7WbEDK5W5y
   YpXQwVLKA4ztTosoSI2/2sTuPKbrsJvEleBacWCvBwpkMFEPeksrInojZ
   prQoSrMj/DRUjoy2hhyXCdlHQhEoRaR6CYmp1lRDuaP270aIzPBXY2TYU
   Yeey3Q1Pib25re5DPDlCkb0ta1Rz8/3bGDoaXIfFtt5U+xp4ec4WbAJBZ
   bozjHuQe/BqoOZKfrivoH02TUfJWeBH8vKwq5PpcqGGyiwfdaag+biBZV
   NmlvyByGVwXgbtZXN1v0dGu1u/gsFNx1V69gUIJXJEHG1KSt1Yx65Zytf
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="238264168"
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="238264168"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 16:23:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="758828846"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga005.fm.intel.com with ESMTP; 22 Dec 2021 16:23:12 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1BN0N796032467;
        Thu, 23 Dec 2021 00:23:09 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     linux-hardening@vger.kernel.org, x86@kernel.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
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
Subject: [PATCH v9 01/15] modpost: fix removing numeric suffixes
Date:   Thu, 23 Dec 2021 01:21:55 +0100
Message-Id: <20211223002209.1092165-2-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211223002209.1092165-1-alexandr.lobakin@intel.com>
References: <20211223002209.1092165-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For now, that condition from remove_dot():

if (m && (s[n + m] == '.' || s[n + m] == 0))

which was designed to test if it's a dot or a \0 after the suffix
is never satisfied.
This is due to that s[n + m] always points to the last digit of a
numeric suffix, not on the symbol next to it:

param_set_uint.0, s[n + m] is '0', s[n + m + 1] is '\0'

So it's off by one and was like that since 2014.

`-z uniq-symbol` linker flag which we are planning to use to
simplify livepatching brings numeric suffixes back, fix this.
Otherwise:

ERROR: modpost: "param_set_uint.0" [vmlinux] is a static EXPORT_SYMBOL

Fixes: fcd38ed0ff26 ("scripts: modpost: fix compilation warning")
Cc: stable@vger.kernel.org # 3.17+
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 scripts/mod/modpost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index cb8ab7d91d30..ccc6d35580f2 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1971,7 +1971,7 @@ static char *remove_dot(char *s)
 
 	if (n && s[n]) {
 		size_t m = strspn(s + n + 1, "0123456789");
-		if (m && (s[n + m] == '.' || s[n + m] == 0))
+		if (m && (s[n + m + 1] == '.' || s[n + m + 1] == 0))
 			s[n] = 0;
 
 		/* strip trailing .lto */
-- 
2.33.1

