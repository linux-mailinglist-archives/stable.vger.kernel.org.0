Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0112350C7
	for <lists+stable@lfdr.de>; Sat,  1 Aug 2020 08:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgHAGSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Aug 2020 02:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbgHAGSF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Aug 2020 02:18:05 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D281C061757
        for <stable@vger.kernel.org>; Fri, 31 Jul 2020 23:18:05 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p3so17123468pgh.3
        for <stable@vger.kernel.org>; Fri, 31 Jul 2020 23:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=0Z19kOEJIEx9Zh1BTPeu+eub/GMK1VCMfldmZLSebVY=;
        b=KxKgPZ44MDuEzDzKcjvBPoOvvk6mFI7inQltWTO8STKjk+OTuM4IBFfbBTfcRxrBx9
         Hv5LeqEqioFXqlilO6cmcV/9iIS7fSnVqceIhVcwVpR5Sc2SSjnksftHrADfcD5rwVsk
         B8Kq5NsEciksAOV8kLa0BY0Jpr9pgfCEQ46cY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=0Z19kOEJIEx9Zh1BTPeu+eub/GMK1VCMfldmZLSebVY=;
        b=Tj0iKoBx4f60CzAsom0cuNoaWYVi5sGlAwG/hBY15uzautSI3yCltynUa8oyfmBnHw
         +sjK+ghC6YVmZcv6A2Dfv3bjWbdOYWgFTA9hGdLSjdehz4tr0IKCRYUrEHJF3ANMaze+
         shgClOrTrgpX9moU6P40t/i/xl9l/c4/mAVv1LiIzFDzWv+yv+t1rSoGwp8x9AAaRVjV
         Ny5N+EPzDehjb9DWcxnZ3wWY7yQZGsRC5CPzckd0HZT7qSYO8ifDeJgbg/SH+hl7+x8b
         Rtx72a5bmC/bPpNb77BVsstGVFtZa6Zgy8TENwrDDxxWl46qxS3Iov1xNvh5q1BtagPQ
         eqig==
X-Gm-Message-State: AOAM530xjdzxW5GcooybubLeTv2oRysk72GFVomEWUfE17nLZSnsrC0V
        vhD5j2Ls+dMD+TuQvWQE+bM8pw==
X-Google-Smtp-Source: ABdhPJx5AY+53D/D5aAfJwgIaGzvtgD0uJizQHS7B/hV1cIUoOKvZS+VpnFwSKDmIBEMYUOWOrqC8A==
X-Received: by 2002:aa7:94bd:: with SMTP id a29mr6882406pfl.280.1596262684343;
        Fri, 31 Jul 2020 23:18:04 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 7sm12129236pgw.85.2020.07.31.23.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 23:18:03 -0700 (PDT)
Date:   Fri, 31 Jul 2020 23:18:02 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jian Cai <jiancai@google.com>,
        =?utf-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>,
        Luis Lozano <llozano@google.com>,
        Manoj Gupta <manojgupta@google.com>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        James Morse <james.morse@arm.com>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
        clang-built-linux@googlegroups.com, linux-arch@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: Re: [PATCH v5 13/36] vmlinux.lds.h: add PGO and AutoFDO input
 sections
Message-ID: <202007312237.4F385EB3@keescook>
References: <20200731230820.1742553-1-keescook@chromium.org>
 <20200731230820.1742553-14-keescook@chromium.org>
 <20200801035128.GB2800311@rani.riverdale.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200801035128.GB2800311@rani.riverdale.lan>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 31, 2020 at 11:51:28PM -0400, Arvind Sankar wrote:
> On Fri, Jul 31, 2020 at 04:07:57PM -0700, Kees Cook wrote:
> > From: Nick Desaulniers <ndesaulniers@google.com>
> > 
> > Basically, consider .text.{hot|unlikely|unknown}.* part of .text, too.
> > 
> > When compiling with profiling information (collected via PGO
> > instrumentations or AutoFDO sampling), Clang will separate code into
> > .text.hot, .text.unlikely, or .text.unknown sections based on profiling
> > information. After D79600 (clang-11), these sections will have a
> > trailing `.` suffix, ie.  .text.hot., .text.unlikely., .text.unknown..
> > 
> > When using -ffunction-sections together with profiling infomation,
> > either explicitly (FGKASLR) or implicitly (LTO), code may be placed in
> > sections following the convention:
> > .text.hot.<foo>, .text.unlikely.<bar>, .text.unknown.<baz>
> > where <foo>, <bar>, and <baz> are functions.  (This produces one section
> > per function; we generally try to merge these all back via linker script
> > so that we don't have 50k sections).
> > 
> > For the above cases, we need to teach our linker scripts that such
> > sections might exist and that we'd explicitly like them grouped
> > together, otherwise we can wind up with code outside of the
> > _stext/_etext boundaries that might not be mapped properly for some
> > architectures, resulting in boot failures.
> > 
> > If the linker script is not told about possible input sections, then
> > where the section is placed as output is a heuristic-laiden mess that's
> > non-portable between linkers (ie. BFD and LLD), and has resulted in many
> > hard to debug bugs.  Kees Cook is working on cleaning this up by adding
> > --orphan-handling=warn linker flag used in ARCH=powerpc to additional
> > architectures. In the case of linker scripts, borrowing from the Zen of
> > Python: explicit is better than implicit.
> > 
> > Also, ld.bfd's internal linker script considers .text.hot AND
> > .text.hot.* to be part of .text, as well as .text.unlikely and
> > .text.unlikely.*. I didn't see support for .text.unknown.*, and didn't
> > see Clang producing such code in our kernel builds, but I see code in
> > LLVM that can produce such section names if profiling information is
> > missing. That may point to a larger issue with generating or collecting
> > profiles, but I would much rather be safe and explicit than have to
> > debug yet another issue related to orphan section placement.
> > 
> > Reported-by: Jian Cai <jiancai@google.com>
> > Suggested-by: Fāng-ruì Sòng <maskray@google.com>
> > Tested-by: Luis Lozano <llozano@google.com>
> > Tested-by: Manoj Gupta <manojgupta@google.com>
> > Acked-by: Kees Cook <keescook@chromium.org>
> > Cc: stable@vger.kernel.org
> > Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commitdiff;h=add44f8d5c5c05e08b11e033127a744d61c26aee
> > Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commitdiff;h=1de778ed23ce7492c523d5850c6c6dbb34152655
> > Link: https://reviews.llvm.org/D79600
> > Link: https://bugs.chromium.org/p/chromium/issues/detail?id=1084760
> > Debugged-by: Luis Lozano <llozano@google.com>
> > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >  include/asm-generic/vmlinux.lds.h | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> > index 2593957f6e8b..af5211ca857c 100644
> > --- a/include/asm-generic/vmlinux.lds.h
> > +++ b/include/asm-generic/vmlinux.lds.h
> > @@ -561,7 +561,10 @@
> >   */
> >  #define TEXT_TEXT							\
> >  		ALIGN_FUNCTION();					\
> > -		*(.text.hot TEXT_MAIN .text.fixup .text.unlikely)	\
> > +		*(.text.hot .text.hot.*)				\
> > +		*(TEXT_MAIN .text.fixup)				\
> > +		*(.text.unlikely .text.unlikely.*)			\
> > +		*(.text.unknown .text.unknown.*)			\
> >  		NOINSTR_TEXT						\
> >  		*(.text..refcount)					\
> >  		*(.ref.text)						\
> > -- 
> > 2.25.1
> > 
> 
> This also changes the ordering to place all hot resp unlikely sections separate
> from other text, while currently it places the hot/unlikely bits of each file
> together with the rest of the code in that file. That seems like a reasonable

Oh, hmm, yes, we aren't explicitly using SORT() here. Does that mean the
input sections were entirely be ordered in compilation unit link order,
even in the case of orphan sections? (And I think either way, the answer
isn't the same between bfd and lld.) I actually thought the like-named
input sections were collected together first with lld, but bfd strictly
appended to the output section. I guess it's time for me to stare at -M
output from ld...

Regardless, this patch is attempting to fix the problem where bfd and lld
lay out the orphans differently (as mentioned above, lld seems to sort
them in a way that is not strictly appended, and bfd seems to sort them
strictly appended). In the case of being appended to the .text output
section, this would cause boot failures due to _etext not covering the
resulting sections (which this[1] also encountered and fixed to be more
robust for such appended collection -- that series actually _depends_ on
orphan handling doing the appending, because there is no current way
to map wildcard input sections to their own separate output sections).

> change and should be mentioned in the commit message.
> 
> However, the history of their being together comes from
> 
>   9bebe9e5b0f3 ("kbuild: Fix .text.unlikely placement")
> 
> which seems to indicate there was some problem with having them separated out,
> although I don't quite understand what the issue was from the commit message.

Looking at this again, I actually wonder if we have bigger issues here
with dead code elimination:

#ifdef CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
#define TEXT_MAIN .text .text.[0-9a-zA-Z_]*
...

that would catch: .text.hot .text.fixup .text.unlikely and .text.unknown
but not .text.hot.*, etc (i.e. the third dot isn't matched, which is,
I assume, why Clang switched to adding a trailing dot). However, this
patch lists .text.hot .text.hot.* first, so they'd get pulled to the
front correctly, but the trailing ones (with 2 dots) would not, since
they'd match the TEXT_MAIN wildcard first. (This problem actually existed
before this patch too, and is not the fault of 9bebe9e5b0f3, but rather
the addition of TEXT_MAIN, which could potentially match .text.unlikely
and .text.fixup)

Unless I'm totally wrong and the bfd docs don't match the behavior? e.g.
if I have a link order of ".foo.before", ".foo.after", and ".foo.middle",
and this rule:

.foo : { *(.foo.before .foo.* .foo.after) }

do I get this (first match):

	.foo.before
	.foo.after
	.foo.middle

or (most specific match):

	.foo.before
	.foo.middle
	.foo.after

?

As I said, now that I'm able to better articulate these questions, I'll
go get answers from -M output. :)

Perhaps we need to fix TEXT_MAIN not TEXT_TEXT? TEXT_TEXT is for
collecting .text, .text.[^\.]* and *.text, where, effectively,
.text and .text[^\.]* are defined by TEXT_MAIN. i.e. adding 3-dot "text"
input sections needs to likely be included in TEXT_MAIN

Anyway, I'll keep looking at this...

(In the meantime, perhaps we can take Arvind's series, and the earlier
portions of the orphan series where asm-generic/vmlinux.lds.h and other
things are cleaned up...)

-Kees

[1] https://lore.kernel.org/lkml/20200717170008.5949-6-kristen@linux.intel.com/

-- 
Kees Cook
