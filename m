Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C2D67F54F
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 07:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbjA1Gwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Jan 2023 01:52:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjA1Gwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Jan 2023 01:52:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E964442CE;
        Fri, 27 Jan 2023 22:52:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D211EB81219;
        Sat, 28 Jan 2023 06:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92FFC433EF;
        Sat, 28 Jan 2023 06:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674888762;
        bh=Eyw3TM22f7uHPwkn27sGLm+kU2D4W7Q7gbZtZXVwQOc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EFof1Ga/K4mJ5htNBvYZnKQ5pTh5YEoqa+/+x3s2Cfp8utUgTXwTeH0zxzwq+a68C
         p9zgJWydjsKVNa2LS1jGg91iqkISxrr9YG03PnjmQuwKzPv7NoaAXOPhq4B8JHD5u/
         Vq6jKytXMFkFyVWhGGJcl7cRQ5ltaUOPArHbhs54=
Date:   Sat, 28 Jan 2023 07:52:39 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 6.1 fix build id for arm64 5/5] sh: define
 RUNTIME_DISCARD_EXIT
Message-ID: <Y9TGN3ovx6qqvVa9@kroah.com>
References: <cover.1674876902.git.tom.saeger@oracle.com>
 <ffaafd3083a1738007a3043b698ec5ac6d8d83d6.1674876902.git.tom.saeger@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffaafd3083a1738007a3043b698ec5ac6d8d83d6.1674876902.git.tom.saeger@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 27, 2023 at 09:10:22PM -0700, Tom Saeger wrote:
> sh vmlinux fails to link with GNU ld < 2.40 (likely < 2.36) since
> commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv").
> 
> This is similar to fixes for powerpc and s390:
> commit 4b9880dbf3bd ("powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT").
> commit a494398bde27 ("s390: define RUNTIME_DISCARD_EXIT to fix link error
> with GNU ld < 2.36").
> 
>   $ sh4-linux-gnu-ld --version | head -n1
>   GNU ld (GNU Binutils for Debian) 2.35.2
> 
>   $ make ARCH=sh CROSS_COMPILE=sh4-linux-gnu- microdev_defconfig
>   $ make ARCH=sh CROSS_COMPILE=sh4-linux-gnu-
> 
>   `.exit.text' referenced in section `__bug_table' of crypto/algboss.o:
>   defined in discarded section `.exit.text' of crypto/algboss.o
>   `.exit.text' referenced in section `__bug_table' of
>   drivers/char/hw_random/core.o: defined in discarded section
>   `.exit.text' of drivers/char/hw_random/core.o
>   make[2]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
>   make[1]: *** [Makefile:1252: vmlinux] Error 2
> 
> arch/sh/kernel/vmlinux.lds.S keeps EXIT_TEXT:
> 
> 	/*
> 	 * .exit.text is discarded at runtime, not link time, to deal with
> 	 * references from __bug_table
> 	 */
> 	.exit.text : AT(ADDR(.exit.text)) { EXIT_TEXT }
> 
> However, EXIT_TEXT is thrown away by
> DISCARD(include/asm-generic/vmlinux.lds.h) because
> sh does not define RUNTIME_DISCARD_EXIT.
> 
> GNU ld 2.40 does not have this issue and builds fine.
> This corresponds with Masahiro's comments in a494398bde27:
> "Nathan [Chancellor] also found that binutils
> commit 21401fc7bf67 ("Duplicate output sections in scripts") cured this
> issue, so we cannot reproduce it with binutils 2.36+, but it is better
> to not rely on it."
> 
> Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
> Link: https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/
> Link: https://lore.kernel.org/all/20230123194218.47ssfzhrpnv3xfez@oracle.com/
> Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
> ---
>  arch/sh/kernel/vmlinux.lds.S | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
> index 3161b9ccd2a5..791c06b9a54a 100644
> --- a/arch/sh/kernel/vmlinux.lds.S
> +++ b/arch/sh/kernel/vmlinux.lds.S
> @@ -4,6 +4,8 @@
>   * Written by Niibe Yutaka and Paul Mundt
>   */
>  OUTPUT_ARCH(sh)
> +#define RUNTIME_DISCARD_EXIT
> +
>  #include <asm/thread_info.h>
>  #include <asm/cache.h>
>  #include <asm/vmlinux.lds.h>
> -- 
> 2.39.1
> 

As my bot said last time you sent this:

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

Sorry, we can not take ANY of this until it hits Linus's tree.  You know
this!

Please wait until then and then send the needed backports.  I'm dropping
all of these from you from my review queue.

greg k-h
