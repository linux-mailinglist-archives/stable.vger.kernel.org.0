Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4816C2244
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 21:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjCTUKw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 20 Mar 2023 16:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjCTUKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 16:10:51 -0400
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCA683F3;
        Mon, 20 Mar 2023 13:10:49 -0700 (PDT)
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.95)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1peLqA-0008E3-Qi; Mon, 20 Mar 2023 21:10:46 +0100
Received: from p57bd9952.dip0.t-ipconnect.de ([87.189.153.82] helo=[192.168.178.81])
          by inpost2.zedat.fu-berlin.de (Exim 4.95)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1peLqA-0035Z5-JM; Mon, 20 Mar 2023 21:10:46 +0100
Message-ID: <dc74919a4a0c683ce23666cdd09c2f7b78f902c7.camel@physik.fu-berlin.de>
Subject: Re: [PATCH 7/7 v4] sh: mcount.S: fix build error when PRINTK is not
 enabled
From:   John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, stable@vger.kernel.org
Date:   Mon, 20 Mar 2023 21:10:45 +0100
In-Reply-To: <CAMuHMdVR78EXTVd7ThUEv6rxL8aHSyAoC_5z8KyAPmiTyww85w@mail.gmail.com>
References: <20230306040037.20350-1-rdunlap@infradead.org>
         <20230306040037.20350-8-rdunlap@infradead.org>
         <056df6d548ad0e4f7f4ccb2782744b165ce20578.camel@physik.fu-berlin.de>
         <CAMuHMdU+tsKuONm9iPqqTFSnRT2zaV3zogYgc-+vCp6x-ruQ_w@mail.gmail.com>
         <01f84314b2499b6859a4826ecf7363635e66a4fc.camel@physik.fu-berlin.de>
         <CAMuHMdVR78EXTVd7ThUEv6rxL8aHSyAoC_5z8KyAPmiTyww85w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.46.4 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 87.189.153.82
X-ZEDAT-Hint: PO
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Geert!

On Mon, 2023-03-20 at 13:42 +0100, Geert Uytterhoeven wrote:
> Hi Adrian,
> 
> On Mon, Mar 20, 2023 at 10:13 AM John Paul Adrian Glaubitz
> <glaubitz@physik.fu-berlin.de> wrote:
> > On Mon, 2023-03-20 at 09:16 +0100, Geert Uytterhoeven wrote:
> > > On Sun, Mar 19, 2023 at 9:49 PM John Paul Adrian Glaubitz
> > > <glaubitz@physik.fu-berlin.de> wrote:
> > > > On Sun, 2023-03-05 at 20:00 -0800, Randy Dunlap wrote:
> > > > > Fix a build error in mcount.S when CONFIG_PRINTK is not enabled.
> > > > > Fixes this build error:
> > > > > 
> > > > > sh2-linux-ld: arch/sh/lib/mcount.o: in function `stack_panic':
> > > > > (.text+0xec): undefined reference to `dump_stack'
> > > > > 
> > > > > Fixes: e460ab27b6c3 ("sh: Fix up stack overflow check with ftrace disabled.")
> > > > > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > > > > Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> > > > > Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> > > > > Cc: Rich Felker <dalias@libc.org>
> > > > > Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > > > > Cc: stable@vger.kernel.org
> > > > > ---
> > > > > v2: add PRINTK to STACK_DEBUG dependency (thanks, Geert)
> > > > > v3: skipped
> > > > > v4: refresh & resend
> > > > > 
> > > > >  arch/sh/Kconfig.debug |    2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > 
> > > > > diff -- a/arch/sh/Kconfig.debug b/arch/sh/Kconfig.debug
> > > > > --- a/arch/sh/Kconfig.debug
> > > > > +++ b/arch/sh/Kconfig.debug
> > > > > @@ -15,7 +15,7 @@ config SH_STANDARD_BIOS
> > > > > 
> > > > >  config STACK_DEBUG
> > > > >       bool "Check for stack overflows"
> > > > > -     depends on DEBUG_KERNEL
> > > > > +     depends on DEBUG_KERNEL && PRINTK
> > > > >       help
> > > > >         This option will cause messages to be printed if free stack space
> > > > >         drops below a certain limit. Saying Y here will add overhead to
> > > > 
> > > > I can't really test this change as the moment I am enabling CONFIG_STACK_DEBUG,
> > > > the build fails with:
> > > > 
> > > >   CC      scripts/mod/devicetable-offsets.s
> > > > sh4-linux-gcc: error: -pg and -fomit-frame-pointer are incompatible
> > > > make[1]: *** [scripts/Makefile.build:252: scripts/mod/empty.o] Error 1
> > > > make[1]: *** Waiting for unfinished jobs....
> > > > sh4-linux-gcc: error: -pg and -fomit-frame-pointer are incompatible
> > > > make[1]: *** [scripts/Makefile.build:114: scripts/mod/devicetable-offsets.s] Error 1
> > > > make: *** [Makefile:1286: prepare0] Error 2
> > > > 
> > > > So, I assume we need to strip -fomit-frame-pointer from KBUILD_CFLAGS, correct?
> > > > 
> > > > I tried this change, but that doesn't fix it for me:
> > > > 
> > > > diff --git a/arch/sh/Makefile b/arch/sh/Makefile
> > > > index 5c8776482530..83f535b73835 100644
> > > > --- a/arch/sh/Makefile
> > > > +++ b/arch/sh/Makefile
> > > > @@ -173,6 +173,7 @@ KBUILD_AFLAGS               += $(cflags-y)
> > > > 
> > > >  ifeq ($(CONFIG_MCOUNT),y)
> > > >    KBUILD_CFLAGS += -pg
> > > > +  KBUILD_CFLAGS := $(subst -fomit-frame-pointer,,$(KBUILD_CFLAGS))
> > > >  endif
> > > > 
> > > >  ifeq ($(CONFIG_DWARF_UNWINDER),y)
> > > > 
> > > > Any ideas?
> > > 
> > > Please try with "+=" instead of ":=".
> > 
> > That doesn't work either. I tried the following, but that didn't strip -fomit-frame-pointer:
> 
> Oops, obviously all of that happened before my morning coffee ;-)
> 
> Makefile has:
> 
>     ifdef CONFIG_FRAME_POINTER
>     KBUILD_CFLAGS   += -fno-omit-frame-pointer -fno-optimize-sibling-calls
>     KBUILD_RUSTFLAGS += -Cforce-frame-pointers=y
>     else
>     # Some targets (ARM with Thumb2, for example), can't be built with frame
>     # pointers.  For those, we don't have FUNCTION_TRACER automatically
>     # select FRAME_POINTER.  However, FUNCTION_TRACER adds -pg, and this is
>     # incompatible with -fomit-frame-pointer with current GCC, so we don't use
>     # -fomit-frame-pointer with FUNCTION_TRACER.
>     # In the Rust target specification, "frame-pointer" is set explicitly
>     # to "may-omit".
>     ifndef CONFIG_FUNCTION_TRACER
>     KBUILD_CFLAGS   += -fomit-frame-pointer
>     endif
>     endif
> 
> Your config probably has CONFIG_FRAME_POINTER set?
> 
>     arch/sh/Kconfig.debug=config DWARF_UNWINDER
>     arch/sh/Kconfig.debug-  bool "Enable the DWARF unwinder for stacktraces"
>     arch/sh/Kconfig.debug-  depends on DEBUG_KERNEL
>     arch/sh/Kconfig.debug:  select FRAME_POINTER
> 
> You should make sure that cannot happen when CONFIG_FUNCTION_TRACER
> is enabled. I.e. make DWARF_UNWINDER depend on !FUNCTION_TRACER?
> 
> Other architectures do something similar:
> 
>     arch/sparc/Kconfig.debug:config FRAME_POINTER
>     arch/sparc/Kconfig.debug-       bool
>     arch/sparc/Kconfig.debug-       depends on MCOUNT
> 
>     arch/x86/Kconfig.debug:config FRAME_POINTER
>     arch/x86/Kconfig.debug- depends on !UNWINDER_ORC && !UNWINDER_GUESS
>     arch/x86/Kconfig.debug- bool
> 
> Probably you need to adjust the following, too:
> 
>     lib/Kconfig.debug:config FRAME_POINTER
>     lib/Kconfig.debug-      bool "Compile the kernel with frame pointers"
>     lib/Kconfig.debug-      depends on DEBUG_KERNEL && (M68K || UML ||
> SUPERH) || ARCH_WANT_FRAME_POINTERS
>     lib/Kconfig.debug-      default y if (DEBUG_INFO && UML) ||
> ARCH_WANT_FRAME_POINTERS
> 
> i.e. drop SUPERH from the list above, and select ARCH_WANT_FRAME_POINTERS
> if !FUNCTION_TRACER.

This change fixed it for me:

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 98e43a537826..04d310ee7384 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -55,6 +55,7 @@ config SUPERH
        select HAVE_SOFTIRQ_ON_OWN_STACK if IRQSTACKS
        select HAVE_STACKPROTECTOR
        select HAVE_SYSCALL_TRACEPOINTS
+       select ARCH_WANT_FRAME_POINTERS
        select IRQ_FORCED_THREADING
        select MODULES_USE_ELF_RELA
        select NEED_SG_DMA_LENGTH
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c8b379e2e9ad..3cf45d8edace 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -523,7 +523,7 @@ config ARCH_WANT_FRAME_POINTERS
 
 config FRAME_POINTER
        bool "Compile the kernel with frame pointers"
-       depends on DEBUG_KERNEL && (M68K || UML || SUPERH) || ARCH_WANT_FRAME_POINTERS
+       depends on DEBUG_KERNEL && (M68K || UML) || ARCH_WANT_FRAME_POINTERS
        default y if (DEBUG_INFO && UML) || ARCH_WANT_FRAME_POINTERS
        help
          If you say Y here the resulting kernel image will be slightly

It seems this is also what the other architectures do it seems.

Adrian

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
