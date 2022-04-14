Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE3C501ED3
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 01:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347421AbiDNXIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 19:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235624AbiDNXIW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 19:08:22 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB408CCDB
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 16:05:56 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id o5so6419999pjr.0
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 16:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t/xzl4CC6q3fF8ZREHk6T5s/dNCqsFXU8yyibaCwPAI=;
        b=hUoc9BC3+lrQPcBPwwRPuykgAGUg5NNx/VXvF0dsxuwVD4+Z61j7QrENS8wPhwyKoy
         x0/11k/Z8KfZdx4Ub0Z++QG3KUcEtYe0dWfETRX1894Yke991afqwysx7Xdo6hRrffUs
         HO3q++A49sWT/YGk/J+BfRrU4GDdvqYR37xFU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t/xzl4CC6q3fF8ZREHk6T5s/dNCqsFXU8yyibaCwPAI=;
        b=3I0EKEzdOAOo+qBowYO1xg8JA8n5YVVHAn3V8OJaLzWGHTFiZWBuqtLrY/NWfc9itq
         NenGcxqjo9s0Hez6BZvc/5m0AqseJTn74Lbm/EQh7nUhzqw9XqxZUyNrIa3l93Brzt7f
         j4M7bagZtKDgqB+hJzVv0yS8a2yO/tTeArDtIsRMhq8EMF/3OxR9h5NoO5xWuwW14aw+
         s4lRwva+Jy5IuLVGeI80OGZpPJCU4jWmDrYp+RFQVsLTTED1JTEtimpIgLlzcHtnYVgT
         bqMJGbzT8RkTHzHFobKDA7uoYxsYipuWsDpwjY6h20Dm1ZeZhy0VWSQwyxmTVVSsYLf8
         q7Qg==
X-Gm-Message-State: AOAM531cloj2Iy3DqtBL39t+MbnZGAUtja+LrDs0YauHV37lPkLjug+a
        7XFRtRtkzwWk5AscKSlJkd6z/g==
X-Google-Smtp-Source: ABdhPJxLI/UcvHhesCPMUZJk9mn1rjPfjc/tnLUhgF8BCBG8VuRuoATUUin7bDXQ4ks1YJNA2Zcnug==
X-Received: by 2002:a17:902:f652:b0:156:701b:9a2a with SMTP id m18-20020a170902f65200b00156701b9a2amr49324926plg.14.1649977555864;
        Thu, 14 Apr 2022 16:05:55 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id l18-20020a056a00141200b004f75395b2cesm856359pfu.150.2022.04.14.16.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 16:05:55 -0700 (PDT)
Date:   Thu, 14 Apr 2022 16:05:54 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Niklas Cassel <niklas.cassel@wdc.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Biederman <ebiederm@xmission.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        stable@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v2] binfmt_flat: do not stop relocating GOT entries
 prematurely on riscv
Message-ID: <202204141559.B2A0EB4F7@keescook>
References: <20220414091018.896737-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414091018.896737-1-niklas.cassel@wdc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 14, 2022 at 11:10:18AM +0200, Niklas Cassel wrote:
> bFLT binaries are usually created using elf2flt.
> 
> The linker script used by elf2flt has defined the .data section like the
> following for the last 19 years:
> 
> .data : {
> 	_sdata = . ;
> 	__data_start = . ;
> 	data_start = . ;
> 	*(.got.plt)
> 	*(.got)
> 	FILL(0) ;
> 	. = ALIGN(0x20) ;
> 	LONG(-1)
> 	. = ALIGN(0x20) ;
> 	...
> }
> 
> It places the .got.plt input section before the .got input section.
> The same is true for the default linker script (ld --verbose) on most
> architectures except x86/x86-64.
> 
> The binfmt_flat loader should relocate all GOT entries until it encounters
> a -1 (the LONG(-1) in the linker script).
> 
> The problem is that the .got.plt input section starts with a GOTPLT header
> (which has size 16 bytes on elf64-riscv and 8 bytes on elf32-riscv), where
> the first word is set to -1. See the binutils implementation for riscv [1].
> 
> This causes the binfmt_flat loader to stop relocating GOT entries
> prematurely and thus causes the application to crash when running.
> 
> Fix this by skipping the whole GOTPLT header, since the whole GOTPLT header
> is reserved for the dynamic linker.
> 
> The GOTPLT header will only be skipped for bFLT binaries with flag
> FLAT_FLAG_GOTPIC set. This flag is unconditionally set by elf2flt if the
> supplied ELF binary has the symbol _GLOBAL_OFFSET_TABLE_ defined.
> ELF binaries without a .got input section should thus remain unaffected.
> 
> Tested on RISC-V Canaan Kendryte K210 and RISC-V QEMU nommu_virt_defconfig.
> 
> [1] https://sourceware.org/git/?p=binutils-gdb.git;a=blob;f=bfd/elfnn-riscv.c;hb=binutils-2_38#l3275
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
> Changes since v1:
> -Incorporated review comments from Eric Biederman.

Thanks! nit: please include a link to the archive so it's easier for
people (and b4) to track earlier versions. i.e.:
https://lore.kernel.org/linux-mm/20220412100338.437308-1-niklas.cassel@wdc.com/

> RISC-V elf2flt patches are still not merged, they can be found here:
> https://github.com/floatious/elf2flt/tree/riscv
> 
> buildroot branch for k210 nommu (including this patch and elf2flt patches):
> https://github.com/floatious/buildroot/tree/k210-v14
> 
>  fs/binfmt_flat.c | 27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
> index 626898150011..e5e2a03b39c1 100644
> --- a/fs/binfmt_flat.c
> +++ b/fs/binfmt_flat.c
> @@ -440,6 +440,30 @@ static void old_reloc(unsigned long rl)
>  
>  /****************************************************************************/
>  
> +static inline u32 __user *skip_got_header(u32 __user *rp)
> +{
> +	if (IS_ENABLED(CONFIG_RISCV)) {
> +		/*
> +		 * RISC-V has a 16 byte GOT PLT header for elf64-riscv
> +		 * and 8 byte GOT PLT header for elf32-riscv.
> +		 * Skip the whole GOT PLT header, since it is reserved
> +		 * for the dynamic linker (ld.so).
> +		 */
> +		u32 rp_val0, rp_val1;
> +
> +		if (get_user(rp_val0, rp))
> +			return rp;
> +		if (get_user(rp_val1, rp + 1))
> +			return rp;
> +
> +		if (rp_val0 == 0xffffffff && rp_val1 == 0xffffffff)
> +			rp += 4;
> +		else if (rp_val0 == 0xffffffff)
> +			rp += 2;

Just so I understand; due to the FILL(0) and the ALIGN, val1 will be 0
(or more specifically, not -1) in all other cases, yes?

I probably would have written this as:

		if (rp_val0 == 0xffffffff)
			rp += 2;
		if (rp_val1 == 0xffffffff)
			rp += 2;

But no need to change it. I expect the compiler would optimize it in the
same thing anyway. :)

> +	}
> +	return rp;
> +}
> +
>  static int load_flat_file(struct linux_binprm *bprm,
>  		struct lib_info *libinfo, int id, unsigned long *extra_stack)
>  {
> @@ -789,7 +813,8 @@ static int load_flat_file(struct linux_binprm *bprm,
>  	 * image.
>  	 */
>  	if (flags & FLAT_FLAG_GOTPIC) {
> -		for (rp = (u32 __user *)datapos; ; rp++) {
> +		rp = skip_got_header((u32 * __user) datapos);
> +		for (; ; rp++) {
>  			u32 addr, rp_val;
>  			if (get_user(rp_val, rp))
>  				return -EFAULT;
> -- 
> 2.35.1
> 

Eric and Damien, does this look good to you? I'll take this into the
execve tree unless you'd like to see further changes.

Thanks!

-Kees

-- 
Kees Cook
