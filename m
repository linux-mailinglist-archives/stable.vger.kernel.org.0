Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1378E4558D4
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 11:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243508AbhKRKUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 05:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244762AbhKRKTP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 05:19:15 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFBF8C061200;
        Thu, 18 Nov 2021 02:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PLFdZ7dTTvBZHONBWUV9JxsnvnbG0+9H32oC94T6RB8=; b=VgJYFTdCxhDoCm1ftVqf2hHxVS
        2dPSPKdP3jt9ch5X0jg3UM+yfTVVB2wQz/H9kjxKKB2kKAGg7JlpHSW5dqj3B9I1PI70u6PT7vpgp
        Yhl5jWngxiUevxgMStLD6+GJjebzoSGNVjj3W++bOUslSdnPz37PM2hNda5oVbQj3PdKgH98bU7wP
        thfQetVfXGPPLbWvCVvJ8oyRPYY+/IRcp1rD9AhAJagXChl357YxkzhYtqQNw7LeV60KyrXOZomeH
        MbS59mFJd3eeJ7rokAq9HQ/sNGFzOtOIH68RjVsess461Pm6TVYr2EAKsEHoFgd/uL9GPKIQS1j+y
        9/Qt6XHw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnePY-00GfiA-1s; Thu, 18 Nov 2021 10:12:56 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id BE2173001FD;
        Thu, 18 Nov 2021 11:12:54 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id AD35D2CFFA120; Thu, 18 Nov 2021 11:12:54 +0100 (CET)
Date:   Thu, 18 Nov 2021 11:12:54 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        stable <stable@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH 5.15 000/923] 5.15.3-rc3 review
Message-ID: <YZYnJi0GcxOH16eF@hirez.programming.kicks-ass.net>
References: <20211117101657.463560063@linuxfoundation.org>
 <YZV02RCRVHIa144u@fedora64.linuxtx.org>
 <55c7b316-e03d-9e91-d74c-fea63c469b3b@applied-asynchrony.com>
 <CAHk-=wjHbKfck1Ws4Y0pUZ7bxdjU9eh2WK0EFsv65utfeVkT9Q@mail.gmail.com>
 <20211118080627.GH174703@worktop.programming.kicks-ass.net>
 <20211118081852.GM174730@worktop.programming.kicks-ass.net>
 <YZYfYOcqNqOyZ8Yo@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZYfYOcqNqOyZ8Yo@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 18, 2021 at 10:39:44AM +0100, Peter Zijlstra wrote:
> @@ -396,22 +416,27 @@ static bool deref_stack_iret_regs(struct unwind_state *state, unsigned long addr
>  static bool get_reg(struct unwind_state *state, unsigned int reg_off,
>  		    unsigned long *val)
>  {
> -	unsigned int reg = reg_off/8;
> -
>  	if (!state->regs)
>  		return false;
>  
> +	pagefault_disable();
>  	if (state->full_regs) {
> -		*val = READ_ONCE_NOCHECK(((unsigned long *)state->regs)[reg]);
> +		__get_kernel_nofault(val, (void *)state->regs + reg_off, unsigned long, Efault);
> +		pagefault_enable();
>  		return true;
>  	}
>  
>  	if (state->prev_regs) {
> -		*val = READ_ONCE_NOCHECK(((unsigned long *)state->prev_regs)[reg]);
> +		__get_kernel_nofault(val, (void *)state->regs + reg_off, unsigned long, Efault);
							^^^ prev_regs
> +		pagefault_enable();
>  		return true;
>  	}
>  
>  	return false;
> +
> +Efault:
> +	pagefault_enable();
> +	return false;
>  }
