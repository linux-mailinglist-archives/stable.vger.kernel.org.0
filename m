Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0A52432D3
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 05:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgHMDdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 23:33:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726609AbgHMDdc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Aug 2020 23:33:32 -0400
Received: from [10.44.0.192] (unknown [103.48.210.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37DAC20715;
        Thu, 13 Aug 2020 03:33:29 +0000 (UTC)
Subject: Re: [PATCH] binfmt_flat: revert "binfmt_flat: don't offset the data
 start"
To:     Max Filippov <jcmvbkbc@gmail.com>, linux-xtensa@linux-xtensa.org
Cc:     Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
References: <20200808183713.12425-1-jcmvbkbc@gmail.com>
From:   Greg Ungerer <gerg@linux-m68k.org>
Message-ID: <ae459859-4ee1-6826-68e0-183ca005f740@linux-m68k.org>
Date:   Thu, 13 Aug 2020 13:33:26 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200808183713.12425-1-jcmvbkbc@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Max,

On 9/8/20 4:37 am, Max Filippov wrote:
> binfmt_flat loader uses the gap between text and data to store data
> segment pointers for the libraries. Even in the absence of shared
> libraries it stores at least one pointer to the executable's own data
> segment. Text and data can go back to back in the flat binary image and
> without offsetting data segment last few instructions in the text
> segment may get corrupted by the data segment pointer.

Yep, your right, it does.

I will push this into the m68knommu git tree next week (once the merge
window is closed), and make sure it gets to Linus for rc series soon
after that.

Thanks
Greg


> Fix it by reverting commit a2357223c50a ("binfmt_flat: don't offset the
> data start").
> 
> Cc: stable@vger.kernel.org
> Fixes: a2357223c50a ("binfmt_flat: don't offset the data start")
> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
> ---
>   fs/binfmt_flat.c | 20 ++++++++++++--------
>   1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
> index f2f9086ebe98..b9c658e0548e 100644
> --- a/fs/binfmt_flat.c
> +++ b/fs/binfmt_flat.c
> @@ -576,7 +576,7 @@ static int load_flat_file(struct linux_binprm *bprm,
>   			goto err;
>   		}
>   
> -		len = data_len + extra;
> +		len = data_len + extra + MAX_SHARED_LIBS * sizeof(unsigned long);
>   		len = PAGE_ALIGN(len);
>   		realdatastart = vm_mmap(NULL, 0, len,
>   			PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE, 0);
> @@ -590,7 +590,9 @@ static int load_flat_file(struct linux_binprm *bprm,
>   			vm_munmap(textpos, text_len);
>   			goto err;
>   		}
> -		datapos = ALIGN(realdatastart, FLAT_DATA_ALIGN);
> +		datapos = ALIGN(realdatastart +
> +				MAX_SHARED_LIBS * sizeof(unsigned long),
> +				FLAT_DATA_ALIGN);
>   
>   		pr_debug("Allocated data+bss+stack (%u bytes): %lx\n",
>   			 data_len + bss_len + stack_len, datapos);
> @@ -620,7 +622,7 @@ static int load_flat_file(struct linux_binprm *bprm,
>   		memp_size = len;
>   	} else {
>   
> -		len = text_len + data_len + extra;
> +		len = text_len + data_len + extra + MAX_SHARED_LIBS * sizeof(u32);
>   		len = PAGE_ALIGN(len);
>   		textpos = vm_mmap(NULL, 0, len,
>   			PROT_READ | PROT_EXEC | PROT_WRITE, MAP_PRIVATE, 0);
> @@ -635,7 +637,9 @@ static int load_flat_file(struct linux_binprm *bprm,
>   		}
>   
>   		realdatastart = textpos + ntohl(hdr->data_start);
> -		datapos = ALIGN(realdatastart, FLAT_DATA_ALIGN);
> +		datapos = ALIGN(realdatastart +
> +				MAX_SHARED_LIBS * sizeof(u32),
> +				FLAT_DATA_ALIGN);
>   
>   		reloc = (__be32 __user *)
>   			(datapos + (ntohl(hdr->reloc_start) - text_len));
> @@ -652,9 +656,8 @@ static int load_flat_file(struct linux_binprm *bprm,
>   					 (text_len + full_data
>   						  - sizeof(struct flat_hdr)),
>   					 0);
> -			if (datapos != realdatastart)
> -				memmove((void *)datapos, (void *)realdatastart,
> -						full_data);
> +			memmove((void *) datapos, (void *) realdatastart,
> +					full_data);
>   #else
>   			/*
>   			 * This is used on MMU systems mainly for testing.
> @@ -710,7 +713,8 @@ static int load_flat_file(struct linux_binprm *bprm,
>   		if (IS_ERR_VALUE(result)) {
>   			ret = result;
>   			pr_err("Unable to read code+data+bss, errno %d\n", ret);
> -			vm_munmap(textpos, text_len + data_len + extra);
> +			vm_munmap(textpos, text_len + data_len + extra +
> +				MAX_SHARED_LIBS * sizeof(u32));
>   			goto err;
>   		}
>   	}
> 
