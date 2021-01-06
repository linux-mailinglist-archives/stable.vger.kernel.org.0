Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE442EC4D9
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 21:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbhAFUYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 15:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727726AbhAFUYI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jan 2021 15:24:08 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67350C061575;
        Wed,  6 Jan 2021 12:23:27 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id 19so3677979qkm.8;
        Wed, 06 Jan 2021 12:23:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n0FNFDvwb/W22Ubf/RxG4tfxJHPjy9EIiD8+u6dtFfE=;
        b=ZncbjLkvLFilYXWFmzmCJeppDyeOlZKbib1KtsSY/qzrdqWfwWJiWjKl/FgaTRUaFM
         h9Y/5RKJX5P8RGwI60C6nzcjG4lu9pkkSDoAa+tMZqldfRkanJFpfPuR57gZ4ebR9QJB
         UYneV84XSPrHLYD8C2dZtzn+zetAqWFvWL4laOb3tgk/FFmbSBxFa8KjQuXEZ/fJbMAY
         ToUv96zMagQuhm5JGoHuM+tXRVSKbn20zGkAu8XbwRQdw+PNd78LQ8oqz9hnq3YLjEgg
         DlAPiVTH5RvEZZPjTU3F9y+pPYcVt0KOyO8YWh0iO8iEItRdGICQ/wZv8fatTUduDimd
         aF/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n0FNFDvwb/W22Ubf/RxG4tfxJHPjy9EIiD8+u6dtFfE=;
        b=oIvGizleChQipMBYKjuPyxWSy91ayGAGqyhCPuE0kMxepTLbfhk74x5EL60wPhJ4xV
         Yz87XOjH6uJqoioOUsI2bNiMA8CSPmzgR+J7kyCA8ccfgqa/7/jeTjtMmqHrPES+MXzd
         FqzlCZdNMaISLuVj2MgFKRvNnq7T2RptV+Gzefq+C1qp/xp9BwS4z5c/PiGMGmRVGT1a
         aK76L13pJO0U8+KHt8jmj1bOaysLbG45WeS5AnDDRInDUsiuF7LtL6VKVcChQKchEPim
         W8OCxq/pVgI3JcSbyk+gXJVabxHVJQ0tMjcUfCq22DborQd8QvROmlKKwrIqmObiy3Ph
         PKaQ==
X-Gm-Message-State: AOAM532cgwuo15G06tRq+bEhR2gCDrExF5zsDhEynkKpEbqhC3bUV+Pc
        QaNc/lRcIo7bjIla/EOa3pSFzBo8x38=
X-Google-Smtp-Source: ABdhPJztEfBHxE22JU3iwRx+0D7o2Yuupmw2E/yAXPraA6uEjebm/06wkk4groQ5EcAZfenTI8AoPA==
X-Received: by 2002:a37:b94:: with SMTP id 142mr6209944qkl.318.1609964606401;
        Wed, 06 Jan 2021 12:23:26 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id z78sm2097443qkb.0.2021.01.06.12.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 12:23:25 -0800 (PST)
Date:   Wed, 6 Jan 2021 13:23:24 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Kees Cook <keescook@chromium.org>,
        Fangrui Song <maskray@google.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Alex Smith <alex.smith@imgtec.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Markos Chandras <markos.chandras@imgtec.com>,
        linux-mips@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 mips-next 3/4] MIPS: vmlinux.lds.S: catch bad .got,
 .plt and .rel.dyn at link time
Message-ID: <20210106202324.GA2953310@ubuntu-m3-large-x86>
References: <20210106200713.31840-1-alobakin@pm.me>
 <20210106200801.31993-1-alobakin@pm.me>
 <20210106200801.31993-3-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106200801.31993-3-alobakin@pm.me>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 06, 2021 at 08:08:29PM +0000, Alexander Lobakin wrote:
> Catch any symbols placed in .got, .got.plt, .plt, .rel.dyn
> or .rela.dyn and check for these sections to be zero-sized
> at link time.
> 
> At least two of them were noticed in real builds:
> 
> mips-alpine-linux-musl-ld: warning: orphan section `.rel.dyn'
> from `init/main.o' being placed in section `.rel.dyn'
> 
> ld.lld: warning: <internal>:(.got) is being placed in '.got'
> 
> Adopted from x86/kernel/vmlinux.lds.S.
> 
> Reported-by: Nathan Chancellor <natechancellor@gmail.com> # .got
> Suggested-by: Fangrui Song <maskray@google.com> # .rel.dyn
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  arch/mips/kernel/vmlinux.lds.S | 35 ++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
> index 5d6563970ab2..05eda9d9a7d5 100644
> --- a/arch/mips/kernel/vmlinux.lds.S
> +++ b/arch/mips/kernel/vmlinux.lds.S
> @@ -227,4 +227,39 @@ SECTIONS
>  		*(.pdr)
>  		*(.reginfo)
>  	}
> +
> +	/*
> +	 * Sections that should stay zero sized, which is safer to
> +	 * explicitly check instead of blindly discarding.
> +	 */
> +
> +	.got : {
> +		*(.got)
> +		*(.igot.*)
> +	}
> +	ASSERT(SIZEOF(.got) == 0, "Unexpected GOT entries detected!")

This assertion does trigger now.

$ make -skj"$(nproc)" ARCH=mips CROSS_COMPILE=mipsel-linux-gnu- LLVM=1 \
       O=out/mipsel distclean malta_kvm_guest_defconfig all
...
ld.lld: error: Unexpected GOT entries detected!
ld.lld: error: Unexpected GOT entries detected!
...

> +	.got.plt (INFO) : {
> +		*(.got.plt)
> +	}
> +	ASSERT(SIZEOF(.got.plt) == 0, "Unexpected GOT/PLT entries detected!")
> +
> +	.plt : {
> +		*(.plt)
> +		*(.plt.*)
> +		*(.iplt)
> +	}
> +	ASSERT(SIZEOF(.plt) == 0, "Unexpected run-time procedure linkages detected!")
> +
> +	.rel.dyn : {
> +		*(.rel.*)
> +		*(.rel_*)
> +	}
> +	ASSERT(SIZEOF(.rel.dyn) == 0, "Unexpected run-time relocations (.rel) detected!")
> +
> +	.rela.dyn : {
> +		*(.rela.*)
> +		*(.rela_*)
> +	}
> +	ASSERT(SIZEOF(.rela.dyn) == 0, "Unexpected run-time relocations (.rela) detected!")
>  }
> -- 
> 2.30.0
> 
> 
