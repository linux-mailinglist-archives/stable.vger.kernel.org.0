Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEED6122B63
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 13:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbfLQMXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 07:23:35 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:47474 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfLQMXf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 07:23:35 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id CD68772CCD5;
        Tue, 17 Dec 2019 15:23:32 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id A87B74A4AEF;
        Tue, 17 Dec 2019 15:23:32 +0300 (MSK)
Date:   Tue, 17 Dec 2019 15:23:32 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Cc:     "Dmitry V . Levin" <ldv@altlinux.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] tools lib: Disable redundant-delcs error for strlcpy
Message-ID: <20191217122331.4g5atx7in6njjlw4@altlinux.org>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "Dmitry V . Levin" <ldv@altlinux.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>, stable@vger.kernel.org
References: <20191208214607.20679-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191208214607.20679-1-vt@altlinux.org>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Arnaldo,

Ping. Can you accept or comment on this patch? There is further
explanations of it:

1. It seems that people putting strlcpy() into the tools was already aware of
the problems it causes and tried to solve them. Probably, that's why they put
`__weak` attribute on it (so it would be linkable in the presence of another
strlcpy). Then `#ifndef __UCLIBC__`ed and later `#if defined(__GLIBC__) &&
!defined(__UCLIBC__)` its declaration. But, solution was incomplete and could
be improved to make kernel buildable on more systems (where libc contains
strlcpy).

There is not need to make `redundant redeclaration` warning an error in
this case.

2. `#pragma GCC diagnostic ignored` trick is already used multiple times
in the kernel:

  $ git grep  '#pragma GCC diagnostic ignored'
  arch/arm/lib/xor-neon.c:#pragma GCC diagnostic ignored "-Wunused-variable"
  tools/build/feature/test-gtk2-infobar.c:#pragma GCC diagnostic ignored "-Wstrict-prototypes"
  tools/build/feature/test-gtk2.c:#pragma GCC diagnostic ignored "-Wstrict-prototypes"
  tools/include/linux/string.h:#pragma GCC diagnostic ignored "-Wredundant-decls"
  tools/lib/bpf/libbpf.c:#pragma GCC diagnostic ignored "-Wformat-nonliteral"
  tools/perf/ui/gtk/gtk.h:#pragma GCC diagnostic ignored "-Wstrict-prototypes"
  tools/testing/selftests/kvm/lib/assert.c:#pragma GCC diagnostic ignored "-Wunused-result"
  tools/usb/ffs-test.c:#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

So the solution does not seem alien in the kernel and should be acceptable.

(I also send this to another of your emails in case I used wrong one before.)

Thanks,


On Mon, Dec 09, 2019 at 12:46:07AM +0300, Vitaly Chikunov wrote:
> Disable `redundant-decls' error for strlcpy declaration and solve build
> error allowing users to compile vanilla kernels.
> 
> When glibc have strlcpy (such as in ALT linux since 2004) objtool and
> perf build fails with something like:
> 
>   In file included from exec-cmd.c:3:
>   tools/include/linux/string.h:20:15: error: redundant redeclaration of ‘strlcpy’ [-Werror=redundant-decls]
>      20 | extern size_t strlcpy(char *dest, const char *src, size_t size);
> 	|               ^~~~~~~
> 
> It's very hard to produce a perfect fix for that since it is a header
> file indirectly pulled from many sources from different Makefile builds.
> 
> Fixes: ce99091 ("perf tools: Move strlcpy() from perf to tools/lib/string.c")
> Fixes: 0215d59 ("tools lib: Reinstate strlcpy() header guard with __UCLIBC__")
> Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> Cc: Dmitry V. Levin <ldv@altlinux.org>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>
> Cc: stable@vger.kernel.org
> ---
>  tools/include/linux/string.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/include/linux/string.h b/tools/include/linux/string.h
> index 980cb9266718..99ede7f5dfb8 100644
> --- a/tools/include/linux/string.h
> +++ b/tools/include/linux/string.h
> @@ -17,7 +17,10 @@ int strtobool(const char *s, bool *res);
>   * However uClibc headers also define __GLIBC__ hence the hack below
>   */
>  #if defined(__GLIBC__) && !defined(__UCLIBC__)
> +#pragma GCC diagnostic push
> +#pragma GCC diagnostic ignored "-Wredundant-decls"
>  extern size_t strlcpy(char *dest, const char *src, size_t size);
> +#pragma GCC diagnostic pop
>  #endif
>  
>  char *str_error_r(int errnum, char *buf, size_t buflen);
