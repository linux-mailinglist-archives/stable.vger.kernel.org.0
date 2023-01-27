Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D06767DE84
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 08:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232707AbjA0H32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 02:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbjA0H31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 02:29:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B887F19F01;
        Thu, 26 Jan 2023 23:29:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5442F61967;
        Fri, 27 Jan 2023 07:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D207C433D2;
        Fri, 27 Jan 2023 07:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674804565;
        bh=6u+lhVskdLBAwbqSPNZ9BKXMXFr+RRug5VEV1zZyGVs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DUeuMJK3E67FHh5QWB6qsimOR3Ftyk+DA5wco8X0zsfifyRafmFIY2hOwBNiWdDuD
         OptDnJeAd1tnnnZ7FHYTcIhf4On2bX/cyEz7cF+HYNvUT8haj5LxV5xxmL5bDAcBd5
         KDS4w/BSRWmLXW18UoL/ixpb/r/ivBfW5v+47jrA=
Date:   Fri, 27 Jan 2023 08:29:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 5.4 fix build id for arm64 6/6] sh: define
 RUNTIME_DISCARD_EXIT
Message-ID: <Y9N9Ux4asZRE25zC@kroah.com>
References: <cover.1674588616.git.tom.saeger@oracle.com>
 <7301d95edaf5bd0926bc93a67cb0cc1256549c95.1674588616.git.tom.saeger@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7301d95edaf5bd0926bc93a67cb0cc1256549c95.1674588616.git.tom.saeger@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 24, 2023 at 02:14:23PM -0700, Tom Saeger wrote:
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
>  arch/sh/kernel/vmlinux.lds.S | 1 +
>  1 file changed, 1 insertion(+)

No upstream git id?

:(
