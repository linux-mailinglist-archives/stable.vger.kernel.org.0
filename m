Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9336C0486
	for <lists+stable@lfdr.de>; Sun, 19 Mar 2023 20:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjCSTsq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 19 Mar 2023 15:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjCSTsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 15:48:42 -0400
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CE116ACE;
        Sun, 19 Mar 2023 12:48:39 -0700 (PDT)
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.95)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1pdz1A-002Ftj-V8; Sun, 19 Mar 2023 20:48:36 +0100
Received: from p57bd9bc2.dip0.t-ipconnect.de ([87.189.155.194] helo=[192.168.178.81])
          by inpost2.zedat.fu-berlin.de (Exim 4.95)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1pdz1A-002vAw-Nj; Sun, 19 Mar 2023 20:48:36 +0100
Message-ID: <8e15ccf2fe80445095b6653210f5cea081f6ffee.camel@physik.fu-berlin.de>
Subject: Re: [PATCH 3/7 v4] sh: init: use OF_EARLY_FLATTREE for early init
From:   John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        devicetree@vger.kernel.org, Rich Felker <dalias@libc.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-sh@vger.kernel.org, stable@vger.kernel.org
Date:   Sun, 19 Mar 2023 20:48:35 +0100
In-Reply-To: <20230306040037.20350-4-rdunlap@infradead.org>
References: <20230306040037.20350-1-rdunlap@infradead.org>
         <20230306040037.20350-4-rdunlap@infradead.org>
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

On Sun, 2023-03-05 at 20:00 -0800, Randy Dunlap wrote:
> When CONFIG_OF_EARLY_FLATTREE and CONFIG_SH_DEVICE_TREE are not set,
> SH3 build fails with a call to early_init_dt_scan(), so in
> arch/sh/kernel/setup.c and arch/sh/kernel/head_32.S, use
> CONFIG_OF_EARLY_FLATTREE instead of CONFIG_OF_FLATTREE.
> 
> Fixes this build error:
> ../arch/sh/kernel/setup.c: In function 'sh_fdt_init':
> ../arch/sh/kernel/setup.c:262:26: error: implicit declaration of function 'early_init_dt_scan' [-Werror=implicit-function-declaration]
>   262 |         if (!dt_virt || !early_init_dt_scan(dt_virt)) {
> 
> Fixes: 03767daa1387 ("sh: fix build regression with CONFIG_OF && !CONFIG_OF_FLATTREE")
> Fixes: eb6b6930a70f ("sh: fix memory corruption of unflattened device tree")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Suggested-by: Rob Herring <robh+dt@kernel.org>
> Cc: Frank Rowand <frowand.list@gmail.com>
> Cc: devicetree@vger.kernel.org
> Cc: Rich Felker <dalias@libc.org>
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Cc: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Cc: linux-sh@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
> v2: use Suggested-by: for Rob.
>     add more Cc's.
> v3: skipped
> v4: update Cc's, refresh & resend
> 
>  arch/sh/kernel/head_32.S |    6 +++---
>  arch/sh/kernel/setup.c   |    4 ++--
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff arch/sh/kernel/setup.c arch/sh/kernel/setup.c
> diff -- a/arch/sh/kernel/setup.c b/arch/sh/kernel/setup.c
> --- a/arch/sh/kernel/setup.c
> +++ b/arch/sh/kernel/setup.c
> @@ -244,7 +244,7 @@ void __init __weak plat_early_device_set
>  {
>  }
>  
> -#ifdef CONFIG_OF_FLATTREE
> +#ifdef CONFIG_OF_EARLY_FLATTREE
>  void __ref sh_fdt_init(phys_addr_t dt_phys)
>  {
>  	static int done = 0;
> @@ -326,7 +326,7 @@ void __init setup_arch(char **cmdline_p)
>  	/* Let earlyprintk output early console messages */
>  	sh_early_platform_driver_probe("earlyprintk", 1, 1);
>  
> -#ifdef CONFIG_OF_FLATTREE
> +#ifdef CONFIG_OF_EARLY_FLATTREE
>  #ifdef CONFIG_USE_BUILTIN_DTB
>  	unflatten_and_copy_device_tree();
>  #else
> diff -- a/arch/sh/kernel/head_32.S b/arch/sh/kernel/head_32.S
> --- a/arch/sh/kernel/head_32.S
> +++ b/arch/sh/kernel/head_32.S
> @@ -64,7 +64,7 @@ ENTRY(_stext)
>  	ldc	r0, r6_bank
>  #endif
>  
> -#ifdef CONFIG_OF_FLATTREE
> +#ifdef CONFIG_OF_EARLY_FLATTREE
>  	mov	r4, r12		! Store device tree blob pointer in r12
>  #endif
>  	
> @@ -315,7 +315,7 @@ ENTRY(_stext)
>  10:		
>  #endif
>  
> -#ifdef CONFIG_OF_FLATTREE
> +#ifdef CONFIG_OF_EARLY_FLATTREE
>  	mov.l	8f, r0		! Make flat device tree available early.
>  	jsr	@r0
>  	 mov	r12, r4
> @@ -346,7 +346,7 @@ ENTRY(stack_start)
>  5:	.long	start_kernel
>  6:	.long	cpu_init
>  7:	.long	init_thread_union
> -#if defined(CONFIG_OF_FLATTREE)
> +#if defined(CONFIG_OF_EARLY_FLATTREE)
>  8:	.long	sh_fdt_init
>  #endif
>  

Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
