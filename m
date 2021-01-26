Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A943044E8
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 18:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388820AbhAZRRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 12:17:44 -0500
Received: from cmyk.emenem.pl ([217.79.154.63]:33666 "EHLO smtp.emenem.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389301AbhAZHEZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 02:04:25 -0500
X-Virus-Scanned: amavisd-new at emenem.pl
Received: from [192.168.1.10] (50-78-106-33-static.hfc.comcastbusiness.net [50.78.106.33])
        (authenticated bits=0)
        by cmyk.emenem.pl (8.16.1/8.16.1) with ESMTPSA id 10Q73KTY004535
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 26 Jan 2021 08:03:22 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ans.pl; s=20190507;
        t=1611644604; bh=TrMD3FOf+kYV4iVemjpv9uv2g6NIByAxM4bdy2QXUcg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=JRknTEvF/LG/fVhbNvod3UxDwkueT+HBJHzM9aScl+Jm6/rr3cOgLC2SHoBZHny7l
         HXj6uI35w9kIi+fZZJg4rv1tyDt1yW26h4BTWz3WYfS8I1uOTcRsqQgz6NVoHmun0b
         xTDw4fR7Jhpyh5vjw2TKxyKBXFmAHpjoahkuFNy0=
Subject: Re: [PATCH 5.4 55/86] x86/mmx: Use KFPU_387 for MMX string operations
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
Cc:     stable@vger.kernel.org, Krzysztof Mazur <krzysiek@podlesie.net>,
        Borislav Petkov <bp@suse.de>
References: <20210125183201.024962206@linuxfoundation.org>
 <20210125183203.376765980@linuxfoundation.org>
From:   =?UTF-8?Q?Krzysztof_Ol=c4=99dzki?= <ole@ans.pl>
Message-ID: <e2877c91-bd08-ad07-6f5c-4da59acbf2d6@ans.pl>
Date:   Mon, 25 Jan 2021 23:03:18 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210125183203.376765980@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Similar to 5.10.11, we also need 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e45122893a9870813f9bd7b4add4f613e6f29008 
in 5.4.93:

Otherwise, the kernel will fail to compile if CONFIG_X86_USE_3DNOW=y

arch/x86/lib/mmx_32.c: In function '_mmx_memcpy':
arch/x86/lib/mmx_32.c:50:2: error: implicit declaration of function 
'kernel_fpu_begin_mask'; did you mean 'kernel_fpu_begin'? 
[-Werror=implicit-function-declaration]
    50 |  kernel_fpu_begin_mask(KFPU_387);
       |  ^~~~~~~~~~~~~~~~~~~~~
       |  kernel_fpu_begin
arch/x86/lib/mmx_32.c:50:24: error: 'KFPU_387' undeclared (first use in 
this function)
    50 |  kernel_fpu_begin_mask(KFPU_387);
       |                        ^~~~~~~~
arch/x86/lib/mmx_32.c:50:24: note: each undeclared identifier is 
reported only once for each function it appears in
arch/x86/lib/mmx_32.c: In function 'fast_clear_page':
arch/x86/lib/mmx_32.c:140:24: error: 'KFPU_387' undeclared (first use in 
this function)
   140 |  kernel_fpu_begin_mask(KFPU_387);
       |                        ^~~~~~~~
arch/x86/lib/mmx_32.c: In function 'fast_copy_page':
arch/x86/lib/mmx_32.c:173:24: error: 'KFPU_387' undeclared (first use in 
this function)
   173 |  kernel_fpu_begin_mask(KFPU_387);
       |                        ^~~~~~~~

Thanks,
  Krzysztof

