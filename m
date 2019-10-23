Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96766E1294
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 09:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389579AbfJWHA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 03:00:26 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46971 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389575AbfJWHA0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 03:00:26 -0400
Received: by mail-pf1-f193.google.com with SMTP id q5so12294813pfg.13
        for <stable@vger.kernel.org>; Wed, 23 Oct 2019 00:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wFl3lHHYnwgRzX2lIo0BhR/5ojXMGfqA+VIAnVaC/kA=;
        b=080ERBcFaKqoQqZwemeRRnAtF4EZl7I/ZUwxZMivIIehabyW5dS0VYCneaNA0oaklT
         H4K3+Ob4mAG93ewad8jYO5i6R812zOE6WozObXiwlxZUvBOMrwPnaRA3J7NTWA3/7DpS
         q7RKVY7ZNkAZp9EcApc7JrDOi5zO9WjVyiIRHkaZrQ5rXulP+/wHvU59yCIy9bhMMEWy
         J8q0CasyYaOV3dHedDzUKuIse+PfLCfvyZTRmSBUs3JD2vw/7xCfJjf7GfNKOvafUayp
         Br0RsD92ow+4F0zN1+wZwX09BPbavAg7/L407DS4yoAMwqeXhgf9YN3nWVoUbpJ6SYT8
         3G2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=wFl3lHHYnwgRzX2lIo0BhR/5ojXMGfqA+VIAnVaC/kA=;
        b=PsnPRa4ZKoJ5C5Sv4xgfAR0nnsf1V4+YMOD1FyCnS7M9uVocCpqRrUZ4LPXzYylEmX
         ugQ0GL1PWziQnsDtKkhUd7gFPzDDLkGoGyEoFMviLP1FOrWPHOsyVkrpnmgb936zbM8w
         xQebqke1b1kwlRg83LTF0K93ckUaA4povgJoaBQzhMgmnEyKek3uROWolLv7GRmxNHwX
         78PT1EtLRKQyZhB7BBjKXy+jgv50GuixluQB8m+n8xh1BaKMDfJcB+6B7uf+6y7+GWtu
         FkrYYqLvBs4KeK+6HmjlhG7EhYUo/vpkUDoS9of3JyNOiEgWnZu8zdt8H/CsaasqvlQZ
         ufVQ==
X-Gm-Message-State: APjAAAXZ/i7vBwncmSRMU8urOnXV4LUeZ4rBX/d6yo0RurIWSkPaGVow
        BrPvA6AnJ9E42/ZqOzQkMI9M6j6neYU=
X-Google-Smtp-Source: APXvYqz75CnBsWnzA7VAkqCJGGuI818zMAOUGXqmu/3TtuLc93OPCdK/nA3EH8L90DYUs+Va3tsP1A==
X-Received: by 2002:a17:90a:246e:: with SMTP id h101mr9584437pje.133.1571814025140;
        Wed, 23 Oct 2019 00:00:25 -0700 (PDT)
Received: from [10.61.2.175] ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id a11sm22616042pfg.94.2019.10.23.00.00.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Oct 2019 00:00:24 -0700 (PDT)
Subject: Re: [PATCH] powerpc/boot: Fix the initrd being overwritten under qemu
To:     Oliver O'Halloran <oohall@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc:     stable@vger.kernel.org
References: <20191023013635.2512-1-oohall@gmail.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
Autocrypt: addr=aik@ozlabs.ru; keydata=
 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
Message-ID: <85c45efb-4ee6-6f01-80b3-d8a65d7526a3@ozlabs.ru>
Date:   Wed, 23 Oct 2019 18:00:21 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191023013635.2512-1-oohall@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 23/10/2019 12:36, Oliver O'Halloran wrote:
> When booting under OF the zImage expects the initrd address and size to be
> passed to it using registers r3 and r4. SLOF (guest firmware used by QEMU)
> currently doesn't do this so the zImage is not aware of the initrd
> location.  This can result in initrd corruption either though the zImage
> extracting the vmlinux over the initrd, or by the vmlinux overwriting the
> initrd when relocating itself.
> 
> QEMU does put the linux,initrd-start and linux,initrd-end properties into
> the devicetree to vmlinux to find the initrd. We can work around the SLOF
> bug by also looking those properties in the zImage.

This does not boot zImage for me anyway:

Trying to unpack rootfs image as initramfs...
rootfs image is not initramfs (invalid magic at start of compressed archive); looks like an initrd



> 
> Cc: stable@vger.kernel.org
> Cc: Alexey Kardashevskiy <aik@ozlabs.ru>
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> ---
> First noticed here: https://unix.stackexchange.com/questions/547023/linux-kernel-on-ppc64le-vmlinux-equivalent-in-arch-powerpc-boot
> ---
>  arch/powerpc/boot/devtree.c | 21 +++++++++++++++++++++
>  arch/powerpc/boot/main.c    |  7 +++++++
>  arch/powerpc/boot/of.h      | 16 ----------------
>  arch/powerpc/boot/ops.h     |  1 +
>  arch/powerpc/boot/swab.h    | 17 +++++++++++++++++
>  5 files changed, 46 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/powerpc/boot/devtree.c b/arch/powerpc/boot/devtree.c
> index 5d91036..ac5c26b 100644
> --- a/arch/powerpc/boot/devtree.c
> +++ b/arch/powerpc/boot/devtree.c
> @@ -13,6 +13,7 @@
>  #include "string.h"
>  #include "stdio.h"
>  #include "ops.h"
> +#include "swab.h"
>  
>  void dt_fixup_memory(u64 start, u64 size)
>  {
> @@ -318,6 +319,26 @@ int dt_xlate_reg(void *node, int res, unsigned long *addr, unsigned long *size)
>  	return dt_xlate(node, res, reglen, addr, size);
>  }
>  
> +int dt_read_addr(void *node, const char *prop, unsigned long *out_addr)
> +{
> +	int reglen;
> +
> +	*out_addr = 0;
> +
> +	reglen = getprop(node, prop, prop_buf, sizeof(prop_buf)) / 4;
> +	if (reglen == 2) {
> +		u64 v0 = be32_to_cpu(prop_buf[0]);
> +		u64 v1 = be32_to_cpu(prop_buf[1]);
> +		*out_addr = (v0 << 32) | v1;
> +	} else if (reglen == 1) {
> +		*out_addr = be32_to_cpu(prop_buf[0]);
> +	} else {
> +		return 0;
> +	}
> +
> +	return 1;
> +}
> +
>  int dt_xlate_addr(void *node, u32 *buf, int buflen, unsigned long *xlated_addr)
>  {
>  
> diff --git a/arch/powerpc/boot/main.c b/arch/powerpc/boot/main.c
> index a9d2091..518af24 100644
> --- a/arch/powerpc/boot/main.c
> +++ b/arch/powerpc/boot/main.c
> @@ -112,6 +112,13 @@ static struct addr_range prep_initrd(struct addr_range vmlinux, void *chosen,
>  	} else if (initrd_size > 0) {
>  		printf("Using loader supplied ramdisk at 0x%lx-0x%lx\n\r",
>  		       initrd_addr, initrd_addr + initrd_size);
> +	} else if (chosen) {
> +		unsigned long initrd_end;
> +
> +		dt_read_addr(chosen, "linux,initrd-start", &initrd_addr);
> +		dt_read_addr(chosen, "linux,initrd-end", &initrd_end);
> +
> +		initrd_size = initrd_end - initrd_addr;
>  	}
>  
>  	/* If there's no initrd at all, we're done */
> diff --git a/arch/powerpc/boot/of.h b/arch/powerpc/boot/of.h
> index 31b2f5d..dc24770 100644
> --- a/arch/powerpc/boot/of.h
> +++ b/arch/powerpc/boot/of.h
> @@ -26,22 +26,6 @@ typedef u16			__be16;
>  typedef u32			__be32;
>  typedef u64			__be64;
>  
> -#ifdef __LITTLE_ENDIAN__
> -#define cpu_to_be16(x) swab16(x)
> -#define be16_to_cpu(x) swab16(x)
> -#define cpu_to_be32(x) swab32(x)
> -#define be32_to_cpu(x) swab32(x)
> -#define cpu_to_be64(x) swab64(x)
> -#define be64_to_cpu(x) swab64(x)
> -#else
> -#define cpu_to_be16(x) (x)
> -#define be16_to_cpu(x) (x)
> -#define cpu_to_be32(x) (x)
> -#define be32_to_cpu(x) (x)
> -#define cpu_to_be64(x) (x)
> -#define be64_to_cpu(x) (x)
> -#endif
> -
>  #define PROM_ERROR (-1u)
>  
>  #endif /* _PPC_BOOT_OF_H_ */
> diff --git a/arch/powerpc/boot/ops.h b/arch/powerpc/boot/ops.h
> index e060676..5100dd7 100644
> --- a/arch/powerpc/boot/ops.h
> +++ b/arch/powerpc/boot/ops.h
> @@ -95,6 +95,7 @@ void *simple_alloc_init(char *base, unsigned long heap_size,
>  extern void flush_cache(void *, unsigned long);
>  int dt_xlate_reg(void *node, int res, unsigned long *addr, unsigned long *size);
>  int dt_xlate_addr(void *node, u32 *buf, int buflen, unsigned long *xlated_addr);
> +int dt_read_addr(void *node, const char *prop, unsigned long *out);
>  int dt_is_compatible(void *node, const char *compat);
>  void dt_get_reg_format(void *node, u32 *naddr, u32 *nsize);
>  int dt_get_virtual_reg(void *node, void **addr, int nres);
> diff --git a/arch/powerpc/boot/swab.h b/arch/powerpc/boot/swab.h
> index 11d2069..82db2c1 100644
> --- a/arch/powerpc/boot/swab.h
> +++ b/arch/powerpc/boot/swab.h
> @@ -27,4 +27,21 @@ static inline u64 swab64(u64 x)
>  		(u64)((x & (u64)0x00ff000000000000ULL) >> 40) |
>  		(u64)((x & (u64)0xff00000000000000ULL) >> 56);
>  }
> +
> +#ifdef __LITTLE_ENDIAN__
> +#define cpu_to_be16(x) swab16(x)
> +#define be16_to_cpu(x) swab16(x)
> +#define cpu_to_be32(x) swab32(x)
> +#define be32_to_cpu(x) swab32(x)
> +#define cpu_to_be64(x) swab64(x)
> +#define be64_to_cpu(x) swab64(x)
> +#else
> +#define cpu_to_be16(x) (x)
> +#define be16_to_cpu(x) (x)
> +#define cpu_to_be32(x) (x)
> +#define be32_to_cpu(x) (x)
> +#define cpu_to_be64(x) (x)
> +#define be64_to_cpu(x) (x)
> +#endif
> +
>  #endif /* _PPC_BOOT_SWAB_H_ */
> 

-- 
Alexey
