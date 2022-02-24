Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012B94C2BED
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 13:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234426AbiBXMj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 07:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbiBXMjz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 07:39:55 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9322804DB;
        Thu, 24 Feb 2022 04:39:24 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4K4CCD07MVz4xdl;
        Thu, 24 Feb 2022 23:39:19 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1645706360;
        bh=8EGa3eVWgTEde2gYL1wkBviDfIH/E8ovFgLPoK3d+ZA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Z7jT6vn3oi7dj7yRyZFUSJ33xHIOjzEkBxgWvQED7rbUeElVkn5TZSjvGL1xgTjTU
         03oa7LTrNlJnR5xoPnkT2cPYIWZpWl+0VkAnpTkpKUzASb9zNA+jtrRcjMyLU+9KZh
         QoeXdMDJ//OWfvhkt8lZwRbVAbA6nh5BeatTk1bKLM1SQdJNQzkH+sgatR9dJx1wOu
         iwe7fQ9bU3sa9rcDzhO6w27FgQDYgyKwNMg6TEh0pL9qBhm1hNdJ6EEjzpzFBMlosz
         8ybLHAXvgTLwGIQZ05zC+27evp33N91vl97MnWqYxfKWVV+3agjufpv1hUNGqdNlTL
         Xx1LzKpeo8xoQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/3] powerpc: fix build errors
In-Reply-To: <20220223135820.2252470-2-anders.roxell@linaro.org>
References: <20220223135820.2252470-1-anders.roxell@linaro.org>
 <20220223135820.2252470-2-anders.roxell@linaro.org>
Date:   Thu, 24 Feb 2022 23:39:16 +1100
Message-ID: <871qzsphfv.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Anders,

Thanks for these, just a few comments below ...

Anders Roxell <anders.roxell@linaro.org> writes:
> Building tinyconfig with gcc (Debian 11.2.0-16) and assembler (Debian
> 2.37.90.20220207) the following build error shows up:
>
>  {standard input}: Assembler messages:
>  {standard input}:1190: Error: unrecognized opcode: `stbcix'
>  {standard input}:1433: Error: unrecognized opcode: `lwzcix'
>  {standard input}:1453: Error: unrecognized opcode: `stbcix'
>  {standard input}:1460: Error: unrecognized opcode: `stwcix'
>  {standard input}:1596: Error: unrecognized opcode: `stbcix'
>  ...
>
> Rework to add assembler directives [1] around the instruction. Going
> through the them one by one shows that the changes should be safe.  Like
> __get_user_atomic_128_aligned() is only called in p9_hmi_special_emu(),
> which according to the name is specific to power9.  And __raw_rm_read*()
> are only called in things that are powernv or book3s_hv specific.
>
> [1] https://sourceware.org/binutils/docs/as/PowerPC_002dPseudo.html#PowerPC_002dPseudo
>
> Cc: <stable@vger.kernel.org>
> Co-developed-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> ---
>  arch/powerpc/include/asm/io.h        | 46 +++++++++++++++++++++++-----
>  arch/powerpc/include/asm/uaccess.h   |  3 ++
>  arch/powerpc/platforms/powernv/rng.c |  6 +++-
>  3 files changed, 46 insertions(+), 9 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.h
> index beba4979bff9..5ff6dec489f8 100644
> --- a/arch/powerpc/include/asm/io.h
> +++ b/arch/powerpc/include/asm/io.h
> @@ -359,25 +359,37 @@ static inline void __raw_writeq_be(unsigned long v, volatile void __iomem *addr)
>   */
>  static inline void __raw_rm_writeb(u8 val, volatile void __iomem *paddr)
>  {
> -	__asm__ __volatile__("stbcix %0,0,%1"
> +	__asm__ __volatile__(".machine \"push\"\n"
> +			     ".machine \"power6\"\n"
> +			     "stbcix %0,0,%1\n"
> +			     ".machine \"pop\"\n"
>  		: : "r" (val), "r" (paddr) : "memory");

As Segher said it'd be cleaner without the embedded quotes.

> @@ -441,7 +465,10 @@ static inline unsigned int name(unsigned int port)	\
>  	unsigned int x;					\
>  	__asm__ __volatile__(				\
>  		"sync\n"				\
> +		".machine \"push\"\n"			\
> +		".machine \"power6\"\n"			\
>  		"0:"	op "	%0,0,%1\n"		\
> +		".machine \"pop\"\n"			\
>  		"1:	twi	0,%0,0\n"		\
>  		"2:	isync\n"			\
>  		"3:	nop\n"				\
> @@ -465,7 +492,10 @@ static inline void name(unsigned int val, unsigned int port) \
>  {							\
>  	__asm__ __volatile__(				\
>  		"sync\n"				\
> +		".machine \"push\"\n"			\
> +		".machine \"power6\"\n"			\
>  		"0:" op " %0,0,%1\n"			\
> +		".machine \"pop\"\n"			\
>  		"1:	sync\n"				\
>  		"2:\n"					\
>  		EX_TABLE(0b, 2b)			\

It's not visible from the diff, but the above two are __do_in_asm and
__do_out_asm and are inside an ifdef CONFIG_PPC32.

AFAICS they're only used for:

__do_in_asm(_rec_inb, "lbzx")
__do_in_asm(_rec_inw, "lhbrx")
__do_in_asm(_rec_inl, "lwbrx")
__do_out_asm(_rec_outb, "stbx")
__do_out_asm(_rec_outw, "sthbrx")
__do_out_asm(_rec_outl, "stwbrx")

Which are all old instructions, so I don't think we need the machine
power6 for those two macros?

> diff --git a/arch/powerpc/platforms/powernv/rng.c b/arch/powerpc/platforms/powernv/rng.c
> index b4386714494a..5bf30ef6d928 100644
> --- a/arch/powerpc/platforms/powernv/rng.c
> +++ b/arch/powerpc/platforms/powernv/rng.c
> @@ -43,7 +43,11 @@ static unsigned long rng_whiten(struct powernv_rng *rng, unsigned long val)
>  	unsigned long parity;
>  
>  	/* Calculate the parity of the value */
> -	asm ("popcntd %0,%1" : "=r" (parity) : "r" (val));
> +	asm (".machine \"push\"\n"
> +	     ".machine \"power7\"\n"
> +	     "popcntd %0,%1\n"
> +	     ".machine \"pop\"\n"
> +	     : "=r" (parity) : "r" (val));

This was actually present in an older CPU, but it doesn't really matter,
this is fine.

cheers
