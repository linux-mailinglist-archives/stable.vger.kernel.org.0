Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA233C887B
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 18:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbhGNQSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 12:18:14 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:40061 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230427AbhGNQSO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 12:18:14 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R331e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UfnjiFQ_1626279319;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0UfnjiFQ_1626279319)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 15 Jul 2021 00:15:21 +0800
Date:   Thu, 15 Jul 2021 00:15:19 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH 5.4.y stable only] MIPS: fix "mipsel-linux-ld:
 decompress.c:undefined reference to `memmove'"
Message-ID: <YO8Nl11tgbQ0Sm59@B-P7TQMD6M-0146.local>
References: <YOglcE85xuwfD7It@kroah.com>
 <20210709132408.174206-1-hsiangkao@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210709132408.174206-1-hsiangkao@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, Jul 09, 2021 at 09:24:08PM +0800, Gao Xiang wrote:
> commit a510b616131f85215ba156ed67e5ed1c0701f80f upstream.
> 
> kernel test robot reported a 5.4.y build issue found by randconfig [1]
> after backporting commit 89b158635ad7 ("lib/lz4: explicitly support
> in-place decompression""). This isn't a problem for v5.10+ since
> commit a510b616131f ("MIPS: Add support for ZSTD-compressed kernels")
> which wasn't included in v5.4, but included in v5.10.y, so only v5.4.y
> is effected.
> 
> This partially cherry-picks the memmove part of commit a510b616131f
> to fix the reported build issue for v5.4.y stable only. Hopefully
> kernelci could also double check this.
> 
> [1] https://lore.kernel.org/r/202107070120.6dOj1kB7-lkp@intel.com/
> Fixes: defcc2b5e54a ("lib/lz4: explicitly support in-place decompression") # 5.4.y
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> ---
> not sure if the stable-only patch format is like this, it partially
> cherry-picks the useful memmove part of commit a510b616131f to fix
> the build issue found by randconfig fuzz only.

ping.. are there more things I can do for this?

Thanks,
Gao Xiang

> 
>  arch/mips/boot/compressed/string.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/arch/mips/boot/compressed/string.c b/arch/mips/boot/compressed/string.c
> index 43beecc3587c..e9ab7ea592ba 100644
> --- a/arch/mips/boot/compressed/string.c
> +++ b/arch/mips/boot/compressed/string.c
> @@ -27,3 +27,19 @@ void *memset(void *s, int c, size_t n)
>  		ss[i] = c;
>  	return s;
>  }
> +
> +void * __weak memmove(void *dest, const void *src, size_t n)
> +{
> +	unsigned int i;
> +	const char *s = src;
> +	char *d = dest;
> +
> +	if ((uintptr_t)dest < (uintptr_t)src) {
> +		for (i = 0; i < n; i++)
> +			d[i] = s[i];
> +	} else {
> +		for (i = n; i > 0; i--)
> +			d[i - 1] = s[i - 1];
> +	}
> +	return dest;
> +}
> -- 
> 2.24.4
