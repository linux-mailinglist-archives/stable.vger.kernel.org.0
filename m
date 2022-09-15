Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8046F5BA241
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 23:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiIOVPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 17:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIOVPW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 17:15:22 -0400
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38FE1A059
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 14:15:19 -0700 (PDT)
Received: from [167.98.135.4] (helo=phil.localnet)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1oYwCY-0007Hx-Il; Thu, 15 Sep 2022 23:15:14 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     linux-riscv@lists.infradead.org
Cc:     Palmer Dabbelt <palmer@rivosinc.com>, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: Re: [PATCH] RISC-V: Avoid coupling the T-Head CMOs and Zicbom
Date:   Thu, 15 Sep 2022 23:15:13 +0200
Message-ID: <2123713.Mh6RI2rZIc@phil>
In-Reply-To: <20220915170900.22685-1-palmer@rivosinc.com>
References: <20220915170900.22685-1-palmer@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Donnerstag, 15. September 2022, 19:09:00 CEST schrieb Palmer Dabbelt:
> We could make the T-Head CMOs depend on a new-enough assembler to have
> Zicbom, but it's not strictly necessary because the T-Head CMOs
> circumvent the assembler.
> 
> Fixes: 8f7e001e0325 ("RISC-V: Clean up the Zicbom block size probing")
> Cc: stable@vger.kernel.org
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Conor Dooley <conor.dooley@microchip.com>
> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

Reviewed-by: Heiko Stuebner <heiko@sntech.de>

> ---
>  arch/riscv/include/asm/cacheflush.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/include/asm/cacheflush.h b/arch/riscv/include/asm/cacheflush.h
> index a89c005b4bbf..273ece6b622f 100644
> --- a/arch/riscv/include/asm/cacheflush.h
> +++ b/arch/riscv/include/asm/cacheflush.h
> @@ -42,8 +42,12 @@ void flush_icache_mm(struct mm_struct *mm, bool local);
>  
>  #endif /* CONFIG_SMP */
>  
> -#ifdef CONFIG_RISCV_ISA_ZICBOM
> +/*
> + * The T-Head CMO errata internally probe the CBOM block size, but otherwise
> + * don't depend on Zicbom.
> + */
>  extern unsigned int riscv_cbom_block_size;
> +#ifdef CONFIG_RISCV_ISA_ZICBOM
>  void riscv_init_cbom_blocksize(void);
>  #else
>  static inline void riscv_init_cbom_blocksize(void) { }
> 




