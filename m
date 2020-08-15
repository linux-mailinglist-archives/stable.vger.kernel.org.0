Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1EF42451E8
	for <lists+stable@lfdr.de>; Sat, 15 Aug 2020 23:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbgHOVbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Aug 2020 17:31:42 -0400
Received: from smtprelay0085.hostedemail.com ([216.40.44.85]:39398 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725616AbgHOVbm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Aug 2020 17:31:42 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 56CA3182CED28;
        Sat, 15 Aug 2020 21:31:39 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:334:355:368:369:379:599:800:960:967:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1605:1711:1730:1747:1777:1792:1981:2194:2199:2393:2525:2553:2561:2564:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6117:6119:6691:6742:7875:7903:9025:10004:10400:10848:11232:11658:11914:12043:12296:12297:12555:12663:12698:12737:12740:12760:12895:13160:13229:13439:14093:14096:14097:14157:14181:14659:14721:21080:21324:21524:21627:21990:30054:30070:30089:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: verse54_5301f6f27008
X-Filterd-Recvd-Size: 4558
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Sat, 15 Aug 2020 21:31:36 +0000 (UTC)
Message-ID: <ccacb2a860151fdd6ce95371f1e0cd7658a308d1.camel@perches.com>
Subject: Re: [PATCH v2] lib/string.c: implement stpcpy
From:   Joe Perches <joe@perches.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?ISO-8859-1?Q?D=E1vid_Bolvansk=FD?= <david.bolvansky@gmail.com>,
        Eli Friedman <efriedma@quicinc.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Sami Tolvanen <samitolvanen@google.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Daniel Axtens <dja@axtens.net>, Ingo Molnar <mingo@kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date:   Sat, 15 Aug 2020 14:31:35 -0700
In-Reply-To: <CAKwvOdk4PRi45MXCtg4kmeN6c1AK5w9EJ1XFBJ5GyUjwEtRj1g@mail.gmail.com>
References: <20200815014006.GB99152@rani.riverdale.lan>
         <20200815020946.1538085-1-ndesaulniers@google.com>
         <202008150921.B70721A359@keescook>
         <CAKwvOdnyHfx6ayqEoOr3pb_ibKBAG9vj31LuKE+f712W=7LFKA@mail.gmail.com>
         <457a91183581509abfa00575d0392be543acbe07.camel@perches.com>
         <CAKwvOdk4PRi45MXCtg4kmeN6c1AK5w9EJ1XFBJ5GyUjwEtRj1g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 2020-08-15 at 14:28 -0700, Nick Desaulniers wrote:
> On Sat, Aug 15, 2020 at 2:24 PM Joe Perches <joe@perches.com> wrote:
> > On Sat, 2020-08-15 at 13:47 -0700, Nick Desaulniers wrote:
> > > On Sat, Aug 15, 2020 at 9:34 AM Kees Cook <keescook@chromium.org> wrote:
> > > > On Fri, Aug 14, 2020 at 07:09:44PM -0700, Nick Desaulniers wrote:
> > > > > LLVM implemented a recent "libcall optimization" that lowers calls to
> > > > > `sprintf(dest, "%s", str)` where the return value is used to
> > > > > `stpcpy(dest, str) - dest`. This generally avoids the machinery involved
> > > > > in parsing format strings.  Calling `sprintf` with overlapping arguments
> > > > > was clarified in ISO C99 and POSIX.1-2001 to be undefined behavior.
> > > > > 
> > > > > `stpcpy` is just like `strcpy` except it returns the pointer to the new
> > > > > tail of `dest`. This allows you to chain multiple calls to `stpcpy` in
> > > > > one statement.
> > > > 
> > > > O_O What?
> > > > 
> > > > No; this is a _terrible_ API: there is no bounds checking, there are no
> > > > buffer sizes. Anything using the example sprintf() pattern is _already_
> > > > wrong and must be removed from the kernel. (Yes, I realize that the
> > > > kernel is *filled* with this bad assumption that "I'll never write more
> > > > than PAGE_SIZE bytes to this buffer", but that's both theoretically
> > > > wrong ("640k is enough for anybody") and has been known to be wrong in
> > > > practice too (e.g. when suddenly your writing routine is reachable by
> > > > splice(2) and you may not have a PAGE_SIZE buffer).
> > > > 
> > > > But we cannot _add_ another dangerous string API. We're already in a
> > > > terrible mess trying to remove strcpy[1], strlcpy[2], and strncpy[3]. This
> > > > needs to be addressed up by removing the unbounded sprintf() uses. (And
> > > > to do so without introducing bugs related to using snprintf() when
> > > > scnprintf() is expected[4].)
> > > 
> > > Well, everything (-next, mainline, stable) is broken right now (with
> > > ToT Clang) without providing this symbol.  I'm not going to go clean
> > > the entire kernel's use of sprintf to get our CI back to being green.
> > 
> > Maybe this should get place in compiler-clang.h so it isn't
> > generic and public.
> 
> https://bugs.llvm.org/show_bug.cgi?id=47162#c7 and
> https://bugs.llvm.org/show_bug.cgi?id=47144
> Seem to imply that Clang is not the only compiler that can lower a
> sequence of libcalls to stpcpy.  Do we want to wait until we have a
> fire drill w/ GCC to move such an implementation from
> include/linux/compiler-clang.h back in to lib/string.c?

My guess is yes, wait until gcc, if ever, needs it.


