Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2026C1374
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 14:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbjCTNcu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 20 Mar 2023 09:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjCTNcs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 09:32:48 -0400
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5263358E;
        Mon, 20 Mar 2023 06:32:46 -0700 (PDT)
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.95)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1peFcv-002LMJ-Sn; Mon, 20 Mar 2023 14:32:41 +0100
Received: from p57bd9bc2.dip0.t-ipconnect.de ([87.189.155.194] helo=[192.168.178.81])
          by inpost2.zedat.fu-berlin.de (Exim 4.95)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1peFcv-000m1l-Kk; Mon, 20 Mar 2023 14:32:41 +0100
Message-ID: <c33548dd94ca23347a418743120aed4a552264a2.camel@physik.fu-berlin.de>
Subject: Re: [PATCH 7/7 v4] sh: mcount.S: fix build error when PRINTK is not
 enabled
From:   John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, stable@vger.kernel.org,
        linux-sh <linux-sh@vger.kernel.org>
Date:   Mon, 20 Mar 2023 14:32:40 +0100
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
X-Originating-IP: 87.189.155.194
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

Do you think you can send a patch for this change? I can then review and apply
it together with Randy's series in case everything works as expected.

Adrian

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
