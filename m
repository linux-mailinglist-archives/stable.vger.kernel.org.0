Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9822304A4C
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbhAZFHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:07:46 -0500
Received: from cmyk.emenem.pl ([217.79.154.63]:56576 "EHLO smtp.emenem.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728990AbhAZDhb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 22:37:31 -0500
X-Greylist: delayed 692 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jan 2021 22:37:30 EST
X-Virus-Scanned: amavisd-new at emenem.pl
Received: from [192.168.1.10] (50-78-106-33-static.hfc.comcastbusiness.net [50.78.106.33])
        (authenticated bits=0)
        by cmyk.emenem.pl (8.16.1/8.16.1) with ESMTPSA id 10Q3Ow7V015842
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 26 Jan 2021 04:25:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ans.pl; s=20190507;
        t=1611631503; bh=KlyRjMaieKMZIvNAJ6yRy3OT2SlHWR2wfZFkABYRv1o=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Ac6s4HWzqqXycxFz+pqdmhlkvpwj5Y6E+ZRi/5YLiH6yzvc7M4NkHZ8TVXk8AG0cL
         b3eormt4U+KPDCe3oH46nG9Z0t2/WXV5TGMKiDfakF2NbBv1TP4uyfpe8gsQPaVJdL
         uydqxPkSg3yjjL8d61pUuj4s+0VGHGtHzBs1YnhQ=
Subject: Re: [PATCH 5.10 119/199] x86/mmx: Use KFPU_387 for MMX string
 operations
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
Cc:     stable@vger.kernel.org, Krzysztof Mazur <krzysiek@podlesie.net>,
        Borislav Petkov <bp@suse.de>
References: <20210125183216.245315437@linuxfoundation.org>
 <20210125183221.250497496@linuxfoundation.org>
From:   =?UTF-8?Q?Krzysztof_Ol=c4=99dzki?= <ole@ans.pl>
Message-ID: <82dfa5e7-286d-777a-b1aa-ebe5144e79db@ans.pl>
Date:   Mon, 25 Jan 2021 19:24:56 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210125183221.250497496@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I think for both 5.4-stable and 5.10-stable we also need 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e45122893a9870813f9bd7b4add4f613e6f29008 
- "x86/fpu: Add kernel_fpu_begin_mask() to selectively initialize state"

Without this, there is no kernel_fpu_begin_mask().

Thanks,
  Krzysztof


On 2021-01-25 at 10:39, Greg Kroah-Hartman wrote:
> From: Andy Lutomirski <luto@kernel.org>
> 
> commit 67de8dca50c027ca0fa3b62a488ee5035036a0da upstream.
> 
> The default kernel_fpu_begin() doesn't work on systems that support XMM but
> haven't yet enabled CR4.OSFXSR.  This causes crashes when _mmx_memcpy() is
> called too early because LDMXCSR generates #UD when the aforementioned bit
> is clear.
> 
> Fix it by using kernel_fpu_begin_mask(KFPU_387) explicitly.
> 
> Fixes: 7ad816762f9b ("x86/fpu: Reset MXCSR to default in kernel_fpu_begin()")
> Reported-by: Krzysztof Mazur <krzysiek@podlesie.net>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Tested-by: Krzysztof Piotr Olędzki <ole@ans.pl>
> Tested-by: Krzysztof Mazur <krzysiek@podlesie.net>
> Cc: <stable@vger.kernel.org>
> Link: https://lkml.kernel.org/r/e7bf21855fe99e5f3baa27446e32623358f69e8d.1611205691.git.luto@kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>   arch/x86/lib/mmx_32.c |   20 +++++++++++++++-----
>   1 file changed, 15 insertions(+), 5 deletions(-)
> 
> --- a/arch/x86/lib/mmx_32.c
> +++ b/arch/x86/lib/mmx_32.c
> @@ -26,6 +26,16 @@
>   #include <asm/fpu/api.h>
>   #include <asm/asm.h>
>   
> +/*
> + * Use KFPU_387.  MMX instructions are not affected by MXCSR,
> + * but both AMD and Intel documentation states that even integer MMX
> + * operations will result in #MF if an exception is pending in FCW.
> + *
> + * EMMS is not needed afterwards because, after calling kernel_fpu_end(),
> + * any subsequent user of the 387 stack will reinitialize it using
> + * KFPU_387.
> + */
> +
>   void *_mmx_memcpy(void *to, const void *from, size_t len)
>   {
>   	void *p;
> @@ -37,7 +47,7 @@ void *_mmx_memcpy(void *to, const void *
>   	p = to;
>   	i = len >> 6; /* len/64 */
>   
> -	kernel_fpu_begin();
> +	kernel_fpu_begin_mask(KFPU_387);
>   
>   	__asm__ __volatile__ (
>   		"1: prefetch (%0)\n"		/* This set is 28 bytes */
> @@ -127,7 +137,7 @@ static void fast_clear_page(void *page)
>   {
>   	int i;
>   
> -	kernel_fpu_begin();
> +	kernel_fpu_begin_mask(KFPU_387);
>   
>   	__asm__ __volatile__ (
>   		"  pxor %%mm0, %%mm0\n" : :
> @@ -160,7 +170,7 @@ static void fast_copy_page(void *to, voi
>   {
>   	int i;
>   
> -	kernel_fpu_begin();
> +	kernel_fpu_begin_mask(KFPU_387);
>   
>   	/*
>   	 * maybe the prefetch stuff can go before the expensive fnsave...
> @@ -247,7 +257,7 @@ static void fast_clear_page(void *page)
>   {
>   	int i;
>   
> -	kernel_fpu_begin();
> +	kernel_fpu_begin_mask(KFPU_387);
>   
>   	__asm__ __volatile__ (
>   		"  pxor %%mm0, %%mm0\n" : :
> @@ -282,7 +292,7 @@ static void fast_copy_page(void *to, voi
>   {
>   	int i;
>   
> -	kernel_fpu_begin();
> +	kernel_fpu_begin_mask(KFPU_387);
>   
>   	__asm__ __volatile__ (
>   		"1: prefetch (%0)\n"
> 
> 

