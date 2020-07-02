Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA292128E8
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 18:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgGBQEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 12:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgGBQEX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jul 2020 12:04:23 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7060BC08C5C1;
        Thu,  2 Jul 2020 09:04:23 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id t6so13695919pgq.1;
        Thu, 02 Jul 2020 09:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tB1I6hCmjUM6u8j9mi/+rkvT9TH6Tm0pVRYPr44Mqew=;
        b=vQyntSiaHHgWainLXItD2mKTmRXRY82MXoTz2fHFKNuxhTVPXAAhi1DRVu4KOw0W+z
         hNQJuy3fbjYNPM3wKw/E2aP9NyXhBBMAUvRst09hRQlef/EcoZRpY5obD1j0ZGr2iS4n
         wLPlrDjSlplM6uBCmriOa+DRt10aJRlLN0weqMtxo124T8gaqX8x7p2/uUSi9pqD+7I4
         zU6L8NWSMWwcUrlwFliwM5LHvCAsAWvSWC9PkCQcryLNIGdmEn+DT+6QFkmdUfYdbqIr
         ZUl2N4EQXn26Kd5x2F4C+gJVkSQRDt64pSoT3w7y6TFRZjbwE6+pYMBxyEaauwznaQ8F
         uMKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tB1I6hCmjUM6u8j9mi/+rkvT9TH6Tm0pVRYPr44Mqew=;
        b=LHpsFJ4vBuIODMt80SpmntBae0IOEJeuq3LbXsX66n1UMLD4bS26Ip+DS/YN6MNFOY
         /aCVxACef1FSfa9731T6Jz1m52zkoQYO34mM5tEUONAqGs/9X2DVJAB4/E8MlW2SLZVr
         MP2sL+66qt3ekpiYh+wq+29bNhg7APFCmVg+rEYBaZ19tEbWey6YsnnHhCo9FwsIz/U7
         fwCM/5A4pMrM0r3F8SBa5/jGaHj66tZeIf4oCdjRvUOIGjOet8ePwYExVBC+kKuJeHmw
         8CxoFSJZ7LP/E3FtaSs/tDUorijHASgw/ycnDuFPMRoyFHuCW4qhBl/+58vp85BEBi17
         Apvw==
X-Gm-Message-State: AOAM531FCCZZ1ZIIGItdCf7g3OFl5IQwj3H3/de/4XRThy5kaNrXPbul
        F3kLEZ1HO1gHJ1SCrcAfqCE=
X-Google-Smtp-Source: ABdhPJwxjdORMaGl+GNi41w9cvk8sl/0aeXV+pCgi/zmB3n6CCmy6FzpSK8UqQRyRcDckD+xy3WA/g==
X-Received: by 2002:a05:6a00:2294:: with SMTP id f20mr29643338pfe.126.1593705862827;
        Thu, 02 Jul 2020 09:04:22 -0700 (PDT)
Received: from ubuntu-s3-xlarge-x86 ([2604:1380:1000:7a00::1])
        by smtp.gmail.com with ESMTPSA id j16sm9183608pgb.33.2020.07.02.09.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 09:04:22 -0700 (PDT)
Date:   Thu, 2 Jul 2020 09:04:20 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Danny Lin <danny@kdrag0n.dev>, Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Fangrui Song <maskray@google.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] vmlinux.lds.h: Coalesce transient LLVM dead code
 elimination sections
Message-ID: <20200702160420.GA3512364@ubuntu-s3-xlarge-x86>
References: <20200702085400.2643527-1-danny@kdrag0n.dev>
 <202007020853.5F15B5DDD@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202007020853.5F15B5DDD@keescook>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 02, 2020 at 08:54:53AM -0700, Kees Cook wrote:
> On Thu, Jul 02, 2020 at 01:54:00AM -0700, Danny Lin wrote:
> > A recent LLVM 11 commit [1] made LLD stop implicitly coalescing some
> > temporary LLVM sections, namely .{data,bss}..compoundliteral.XXX:
> > 
> >   [30] .data..compoundli PROGBITS         ffffffff9ac9a000  19e9a000
> >        000000000000cea0  0000000000000000  WA       0     0     32
> >   [31] .rela.data..compo RELA             0000000000000000  40965440
> >        0000000000001d88  0000000000000018   I      2238    30     8
> >   [32] .data..compoundli PROGBITS         ffffffff9aca6ea0  19ea6ea0
> >        00000000000033c0  0000000000000000  WA       0     0     32
> >   [33] .rela.data..compo RELA             0000000000000000  409671c8
> >        0000000000000948  0000000000000018   I      2238    32     8
> >   [...]
> >   [2213] .bss..compoundlit NOBITS           ffffffffa3000000  1d85c000
> >        00000000000000a0  0000000000000000  WA       0     0     32
> >   [2214] .bss..compoundlit NOBITS           ffffffffa30000a0  1d85c000
> >        0000000000000040  0000000000000000  WA       0     0     32
> >   [...]
> > 
> > While these extra sections don't typically cause any breakage, they do
> > inflate the vmlinux size due to the overhead of storing metadata for
> > thousands of extra sections.
> > 
> > It's also worth noting that for some reason, some downstream Android
> > kernels can't boot at all if these sections aren't coalesced.
> > 
> > This issue isn't limited to any specific architecture; it affects arm64
> > and x86 if CONFIG_LD_DEAD_CODE_DATA_ELIMINATION is forced on.

It might be worth noting that this happens explicitly because of
-fdata-sections, which is currently only used with
CONFIG_LD_DEAD_CODE_DATA_ELIMINATION but there are other features such
as LTO that will enable this and make this relevant in the future.

https://android-review.googlesource.com/c/kernel/common/+/1329278/6#message-81b191e92ef4e98e017fa9ded5ef63ef6e60db3a

It is also worth noting that those commits add .bss..L* and .data..L*
and rodata variants. Do you know if those are relevant here?

> > Example on x86 allyesconfig:
> >     Before: 2241 sections, 1170972 KiB
> >     After:    56 sections, 1171169 KiB

Am I reading this right that coalescing those sections increases the
image size? Kind of interesting.

> > [1] https://github.com/llvm/llvm-project/commit/9e33c096476ab5e02ab1c8442cc3cb4e32e29f17
> > 
> > Link: https://github.com/ClangBuiltLinux/linux/issues/958
> > Cc: stable@vger.kernel.org # v4.4+
> > Suggested-by: Fangrui Song <maskray@google.com>
> > Signed-off-by: Danny Lin <danny@kdrag0n.dev>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> > ---
> >  include/asm-generic/vmlinux.lds.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> > index db600ef218d7..18968cba87c7 100644
> > --- a/include/asm-generic/vmlinux.lds.h
> > +++ b/include/asm-generic/vmlinux.lds.h
> > @@ -94,10 +94,10 @@
> >   */
> >  #ifdef CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
> >  #define TEXT_MAIN .text .text.[0-9a-zA-Z_]*
> > -#define DATA_MAIN .data .data.[0-9a-zA-Z_]* .data..LPBX*
> > +#define DATA_MAIN .data .data.[0-9a-zA-Z_]* .data..LPBX* .data..compoundliteral*

I am fairly certain this will fix a PowerPC warning that we had
recently so good!

https://lore.kernel.org/lkml/202006180904.TVUXCf6H%25lkp@intel.com/

Unfortunately, I forgot to reply to that thread...

> >  #define SDATA_MAIN .sdata .sdata.[0-9a-zA-Z_]*
> >  #define RODATA_MAIN .rodata .rodata.[0-9a-zA-Z_]*
> > -#define BSS_MAIN .bss .bss.[0-9a-zA-Z_]*
> > +#define BSS_MAIN .bss .bss.[0-9a-zA-Z_]* .bss..compoundliteral*
> 
> Are there .data.. and .bss.. sections we do NOT want to collect? i.e.
> why not include .data..* and .bss..* ?

At one point Android was doing that for modules but stopped:

https://android-review.googlesource.com/c/kernel/common/+/1266787

I wonder if that is a problem for the main kernel image.

Cheers,
Nathan
