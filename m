Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57CADEF27D
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 02:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbfKEBQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 20:16:54 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:38504 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728602AbfKEBQy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 20:16:54 -0500
Received: by mail-oi1-f195.google.com with SMTP id v186so16017186oie.5
        for <stable@vger.kernel.org>; Mon, 04 Nov 2019 17:16:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kBeY4f2OvdQA5xTLMkQLC0YdOsAuWNMqH+SmmFAXcgs=;
        b=bCx9UYoyZMXoeo3o8cc0y22tALdHKfscWqvoj5CIoH+KXchcEQ8N7GY26Iwj1HHWTh
         5GSaNGSgUqrYUKv7WUsQ7VZ8NG1PbBsppoGug8I4DEIbcfXGqC0bBkIOpIu08X0E09Oa
         +Q7gxj/Yt6IeVVLtXM9nayAGqADYROl6IGC0yU3xXkXsMETPoxZu8rO7BNigtGQDc6R3
         wJxxMCtvIsRuLF3Vy68ozP0dHrE9SBhxzydlWOwbK3lh/VlIstUu5NM8wA+MD4UVe3cM
         8l4JpJApDFg8NUoFqJTvwgdKwbht27ZViljR1/4cz8SPOJYxT8l0J2rQpVm4XlvsUcdl
         bKaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kBeY4f2OvdQA5xTLMkQLC0YdOsAuWNMqH+SmmFAXcgs=;
        b=pf1Ab6a8rB5U2HXrts81SgH85qATgQsp2IUKCAqItJ5suAFHuiAEeBaN87A4HxyCrO
         AFtq7Ko3BIZTEK9DdgTZ/ymAUKvDzbfpoPYBaL90jlE6TeiUvwRZLoldJI+BhmWg+QyF
         Lo1x3uUKN5dfkgwStZD047N438pzFc2qidzfYLYU57JqINZMacts2OBw3o+5ZNnBMLql
         /AUUlWObn+VaREKUIXAogIC8u8/cw9OGFY2N/N/5PjAL0FxUksGs4o9cNb+Osb8G2TmB
         5SutpiPQpQ8e+YL8dhjn4yCY7dPI0LGAe8M4F8euHIRo9wkZApuvCL/JyC//rrzcPiwS
         fOJw==
X-Gm-Message-State: APjAAAWFMblNLcxRHjs2cBSpYRfVTfn+Y7HGhzvq/dplxMbi7+KWXiw4
        F2e0Bk5xAJek2cyG7pvgjsfxlpmvm3uY5HK8TZztPw==
X-Google-Smtp-Source: APXvYqyf7IeMKspg6JW7fJbbf2hW11JVdVyOHNLOnfin4tyCvuxMjfE67fC863wVdT3V1oGIhBhfkC4oLJhg/ULtgGA=
X-Received: by 2002:a05:6808:113:: with SMTP id b19mr1571484oie.169.1572916613450;
 Mon, 04 Nov 2019 17:16:53 -0800 (PST)
MIME-Version: 1.0
References: <20191029153051.24367-1-catalin.marinas@arm.com>
In-Reply-To: <20191029153051.24367-1-catalin.marinas@arm.com>
From:   John Stultz <john.stultz@linaro.org>
Date:   Mon, 4 Nov 2019 17:16:42 -0800
Message-ID: <CALAqxLXuxZVg0kqNQXF_dH17NzH9m14-Ci_rzruHzmms0V7pvg@mail.gmail.com>
Subject: Re: [PATCH] arm64: Ensure VM_WRITE|VM_SHARED ptes are clean by default
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will@kernel.org>, stable <stable@vger.kernel.org>,
        Alistair Delva <adelva@google.com>,
        Sandeep Patil <sspatil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 29, 2019 at 8:31 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> Shared and writable mappings (__S.1.) should be clean (!dirty) initially
> and made dirty on a subsequent write either through the hardware DBM
> (dirty bit management) mechanism or through a write page fault. A clean
> pte for the arm64 kernel is one that has PTE_RDONLY set and PTE_DIRTY
> clear.
>
> The PAGE_SHARED{,_EXEC} attributes have PTE_WRITE set (PTE_DBM) and
> PTE_DIRTY clear. Prior to commit 73e86cb03cf2 ("arm64: Move PTE_RDONLY
> bit handling out of set_pte_at()"), it was the responsibility of
> set_pte_at() to set the PTE_RDONLY bit and mark the pte clean if the
> software PTE_DIRTY bit was not set. However, the above commit removed
> the pte_sw_dirty() check and the subsequent setting of PTE_RDONLY in
> set_pte_at() while leaving the PAGE_SHARED{,_EXEC} definitions
> unchanged. The result is that shared+writable mappings are now dirty by
> default
>
> Fix the above by explicitly setting PTE_RDONLY in PAGE_SHARED{,_EXEC}.
> In addition, remove the superfluous PTE_DIRTY bit from the kernel PROT_*
> attributes.
>
> Fixes: 73e86cb03cf2 ("arm64: Move PTE_RDONLY bit handling out of set_pte_at()")
> Cc: <stable@vger.kernel.org> # 4.14.x-
> Cc: Will Deacon <will@kernel.org>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

Hey,
  So I'm not yet sure why, but I've just validated that this patch is
causing trouble with booting AOSP on HiKey960 with 5.4-rc6 (-rc5 works
fine).
Its odd, because the system does boot and is alive, but seems to stall
out at the boot animation, and userland never finishes coming up to
the home screen. It just sits there without a useful error message
that I can find so far.  Reverting just this patch seems to solve it
and it boots all the way.

I'll try to dig further to see what might be going on (the mali driver
is a prime suspect here), but I wanted to raise the flag since we're
at the end of the -rc cycle.

thanks
-john
