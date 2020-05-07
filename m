Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0244D1C992D
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 20:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgEGSWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 14:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728198AbgEGSWb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 14:22:31 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1F5C05BD43;
        Thu,  7 May 2020 11:22:31 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jWl9z-0002qB-Ia; Thu, 07 May 2020 20:22:15 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id B9DAE102652; Thu,  7 May 2020 20:22:14 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Yu-cheng Yu <yu-cheng.yu@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Rik van Riel <riel@surriel.com>,
        "Ravi V. Shankar" <ravi.v.shankar@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Yu-cheng Yu <yu-cheng.yu@intel.com>, sam <sunhaoyl@outlook.com>,
        Kees Cook <keescook@chromium.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Jann Horn <jannh@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Potapenko <glider@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/fpu/xstate: Clear uninitialized xstate areas in core dump
In-Reply-To: <20200507164904.26927-1-yu-cheng.yu@intel.com>
References: <20200507164904.26927-1-yu-cheng.yu@intel.com>
Date:   Thu, 07 May 2020 20:22:14 +0200
Message-ID: <87lfm3ehbd.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Yu-cheng Yu <yu-cheng.yu@intel.com> writes:
> @@ -983,6 +983,7 @@ int copy_xstate_to_kernel(void *kbuf, struct xregs_state *xsave, unsigned int of
>  {
>  	unsigned int offset, size;
>  	struct xstate_header header;
> +	int last_off;
>  	int i;
>  
>  	/*
> @@ -1006,7 +1007,17 @@ int copy_xstate_to_kernel(void *kbuf, struct xregs_state *xsave, unsigned int of
>  
>  	__copy_xstate_to_kernel(kbuf, &header, offset, size, size_total);
>  
> +	last_off = 0;
> +
>  	for (i = 0; i < XFEATURE_MAX; i++) {
> +		/*
> +		 * Clear uninitialized area before XSAVE header.
> +		 */
> +		if (i == FIRST_EXTENDED_XFEATURE) {
> +			memset(kbuf + last_off, 0, XSAVE_HDR_OFFSET - last_off);
> +			last_off = XSAVE_HDR_OFFSET + XSAVE_HDR_SIZE;
> +		}
> +
>  		/*
>  		 * Copy only in-use xstates:
>  		 */
> @@ -1020,11 +1031,16 @@ int copy_xstate_to_kernel(void *kbuf, struct xregs_state *xsave, unsigned int of
>  			if (offset + size > size_total)
>  				break;
>  
> +			memset(kbuf + last_off, 0, offset - last_off);
> +			last_off = offset + size;
> +
>  			__copy_xstate_to_kernel(kbuf, src, offset, size, size_total);
>  		}
>  
>  	}
>  
> +	memset(kbuf + last_off, 0, size_total - last_off);

Why doing all this partial zeroing? There is absolutely no point.

Either the caller clears the buffer or this function clears it right at
the beginning with:

    memset(kbuf, 0, min(size_total, XSAVE_MAX_SIZE));

Thanks,

        tglx
