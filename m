Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E2A21BB42
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 18:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgGJQqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 12:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbgGJQqJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 12:46:09 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CA4C08C5DD
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 09:46:09 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p3so2777152pgh.3
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 09:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BEJ4O5IRtxDaBgCbgZ/Q408W88KkDEGUZbbV6ihxQP4=;
        b=m8jqouEai9bWz+XEvv1yWqI+GZ0fpiFnMhVhotCGhobHSsVF0OzprD/Pu+8bIz883f
         wn2NMRgiZgQhyXD3guMQPXhE7b0qa30Goqz+Maq/Af+u2SmZzvdmH8XHzIeOQyuAQ2LE
         pWucWqF61fm5PbBH1RVdMIpsLsNikV8VlUloYdHkTVWbHEfryUU7JVSwYr32AG54tSTK
         wSqPgq/K/NXtYGP/ELB7Hi1ciGgWF6CYUVsDCosZD2CrdAQvo5yQFVmNEK1r5YcMzBsz
         uf06YTRPOXqdexRP7lNgmTxtXk+LEJkUpqA9iOnQ/EKmeNgnEzTrjp6KfXn77H6ptzjJ
         nqMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BEJ4O5IRtxDaBgCbgZ/Q408W88KkDEGUZbbV6ihxQP4=;
        b=kyzE6EFnN3HuFJCRu4Q3zd5xiSU/tiomcrpq2NN/4jm2vtsbjlg0lfSngquApN9zJg
         VLxhBcHWJtx6tOJygxoCONsM0xj5YbtjjgAPsGlKhp066V/EHYneYSAY3HTA5xsqdO3q
         qBLS6P3gne2nRfhceNSv8/qETrgydZMyaTnYehSk0Wk4KwsllErbRt4vEMQk1AuP6qzU
         rLQgzOlPcKOGNH54Des4ITHWgKrbf4sBqlLaomYUXSDi/DFR401as+iAPThd8BoqcrUP
         y7aWYPUPxrm05nO0+9VXZuSRPhIwjWG7Wqg7kCl0veRsldMptz0F1Kmh2hJkVojOMsDD
         AM5Q==
X-Gm-Message-State: AOAM533l6zrWGpaxB1Zxj4tqim94OrTND+SrFl9GsmuooRde9mTWRc0Z
        8S78pikQ4XKD8j+9Ky7cLL4xALdsMd5CdE3okl2+Nw==
X-Google-Smtp-Source: ABdhPJy8cHwcMXMhJq9cSqCnrxYD9RfJGdZHhE8eWmzDboeqXj7ICfFj6ZLURk23deguvCVvRehqxZsJwzcI+YvF9Ws=
X-Received: by 2002:a05:6a00:15ca:: with SMTP id o10mr64641771pfu.169.1594399568391;
 Fri, 10 Jul 2020 09:46:08 -0700 (PDT)
MIME-Version: 1.0
References: <1592531704.23014.1.camel@mtkswgap22> <20200706182713.3693762-1-nhuck@google.com>
In-Reply-To: <20200706182713.3693762-1-nhuck@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 10 Jul 2020 09:45:55 -0700
Message-ID: <CAKwvOdmAsNsAMxAQdKdNHujDFhM_STdHj7d+q+2W=Q0N_spNrQ@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: stacktrace: Fix unwind_frame for clang-built kernels
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Miles Chen <miles.chen@mediatek.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Nathan,
Would you please submit this to Russell's patch tracking system:
https://www.arm.linux.org.uk/developer/patches/
login -> add new patch.

On Mon, Jul 6, 2020 at 11:27 AM Nathan Huckleberry <nhuck@google.com> wrote:
>
> Since clang does not push pc and sp in function prologues, the current
> implementation of unwind_frame does not work. By using the previous
> frame's lr/fp instead of saved pc/sp we get valid unwinds on clang-built
> kernels.
>
> The bounds check on next frame pointer must be changed as well since
> there are 8 less bytes between frames.
>
> This fixes /proc/<pid>/stack.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/912
> Reported-by: Miles Chen <miles.chen@mediatek.com>
> Tested-by: Miles Chen <miles.chen@mediatek.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> ---
>  arch/arm/kernel/stacktrace.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
> index cc726afea023..76ea4178a55c 100644
> --- a/arch/arm/kernel/stacktrace.c
> +++ b/arch/arm/kernel/stacktrace.c
> @@ -22,6 +22,19 @@
>   * A simple function epilogue looks like this:
>   *     ldm     sp, {fp, sp, pc}
>   *
> + * When compiled with clang, pc and sp are not pushed. A simple function
> + * prologue looks like this when built with clang:
> + *
> + *     stmdb   {..., fp, lr}
> + *     add     fp, sp, #x
> + *     sub     sp, sp, #y
> + *
> + * A simple function epilogue looks like this when built with clang:
> + *
> + *     sub     sp, fp, #x
> + *     ldm     {..., fp, pc}
> + *
> + *
>   * Note that with framepointer enabled, even the leaf functions have the same
>   * prologue and epilogue, therefore we can ignore the LR value in this case.
>   */
> @@ -34,6 +47,16 @@ int notrace unwind_frame(struct stackframe *frame)
>         low = frame->sp;
>         high = ALIGN(low, THREAD_SIZE);
>
> +#ifdef CONFIG_CC_IS_CLANG
> +       /* check current frame pointer is within bounds */
> +       if (fp < low + 4 || fp > high - 4)
> +               return -EINVAL;
> +
> +       frame->sp = frame->fp;
> +       frame->fp = *(unsigned long *)(fp);
> +       frame->pc = frame->lr;
> +       frame->lr = *(unsigned long *)(fp + 4);
> +#else
>         /* check current frame pointer is within bounds */
>         if (fp < low + 12 || fp > high - 4)
>                 return -EINVAL;
> @@ -42,6 +65,7 @@ int notrace unwind_frame(struct stackframe *frame)
>         frame->fp = *(unsigned long *)(fp - 12);
>         frame->sp = *(unsigned long *)(fp - 8);
>         frame->pc = *(unsigned long *)(fp - 4);
> +#endif
>
>         return 0;
>  }
> --
> 2.27.0.212.ge8ba1cc988-goog
>


-- 
Thanks,
~Nick Desaulniers
