Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4D96C0538
	for <lists+stable@lfdr.de>; Sun, 19 Mar 2023 22:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjCSVGm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 19 Mar 2023 17:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjCSVGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 17:06:40 -0400
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D29015896;
        Sun, 19 Mar 2023 14:06:38 -0700 (PDT)
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.95)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1pe0Ed-002QJo-U4; Sun, 19 Mar 2023 22:06:35 +0100
Received: from p57bd9bc2.dip0.t-ipconnect.de ([87.189.155.194] helo=[192.168.178.81])
          by inpost2.zedat.fu-berlin.de (Exim 4.95)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1pe0Ed-003H0e-Jv; Sun, 19 Mar 2023 22:06:35 +0100
Message-ID: <056df6d548ad0e4f7f4ccb2782744b165ce20578.camel@physik.fu-berlin.de>
Subject: Re: [PATCH 7/7 v4] sh: mcount.S: fix build error when PRINTK is
 not enabled
From:   John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        stable@vger.kernel.org
Date:   Sun, 19 Mar 2023 21:49:06 +0100
In-Reply-To: <20230306040037.20350-8-rdunlap@infradead.org>
References: <20230306040037.20350-1-rdunlap@infradead.org>
         <20230306040037.20350-8-rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.46.4 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 87.189.155.194
X-ZEDAT-Hint: PO
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2023-03-05 at 20:00 -0800, Randy Dunlap wrote:
> Fix a build error in mcount.S when CONFIG_PRINTK is not enabled.
> Fixes this build error:
> 
> sh2-linux-ld: arch/sh/lib/mcount.o: in function `stack_panic':
> (.text+0xec): undefined reference to `dump_stack'
> 
> Fixes: e460ab27b6c3 ("sh: Fix up stack overflow check with ftrace disabled.")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Cc: Rich Felker <dalias@libc.org>
> Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: stable@vger.kernel.org
> ---
> v2: add PRINTK to STACK_DEBUG dependency (thanks, Geert)
> v3: skipped
> v4: refresh & resend
> 
>  arch/sh/Kconfig.debug |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -- a/arch/sh/Kconfig.debug b/arch/sh/Kconfig.debug
> --- a/arch/sh/Kconfig.debug
> +++ b/arch/sh/Kconfig.debug
> @@ -15,7 +15,7 @@ config SH_STANDARD_BIOS
>  
>  config STACK_DEBUG
>  	bool "Check for stack overflows"
> -	depends on DEBUG_KERNEL
> +	depends on DEBUG_KERNEL && PRINTK
>  	help
>  	  This option will cause messages to be printed if free stack space
>  	  drops below a certain limit. Saying Y here will add overhead to

I can't really test this change as the moment I am enabling CONFIG_STACK_DEBUG,
the build fails with:

  CC      scripts/mod/devicetable-offsets.s
sh4-linux-gcc: error: -pg and -fomit-frame-pointer are incompatible
make[1]: *** [scripts/Makefile.build:252: scripts/mod/empty.o] Error 1
make[1]: *** Waiting for unfinished jobs....
sh4-linux-gcc: error: -pg and -fomit-frame-pointer are incompatible
make[1]: *** [scripts/Makefile.build:114: scripts/mod/devicetable-offsets.s] Error 1
make: *** [Makefile:1286: prepare0] Error 2

So, I assume we need to strip -fomit-frame-pointer from KBUILD_CFLAGS, correct?

I tried this change, but that doesn't fix it for me:

diff --git a/arch/sh/Makefile b/arch/sh/Makefile
index 5c8776482530..83f535b73835 100644
--- a/arch/sh/Makefile
+++ b/arch/sh/Makefile
@@ -173,6 +173,7 @@ KBUILD_AFLAGS               += $(cflags-y)
 
 ifeq ($(CONFIG_MCOUNT),y)
   KBUILD_CFLAGS += -pg
+  KBUILD_CFLAGS := $(subst -fomit-frame-pointer,,$(KBUILD_CFLAGS))
 endif
 
 ifeq ($(CONFIG_DWARF_UNWINDER),y)

Any ideas?

Adrian

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
