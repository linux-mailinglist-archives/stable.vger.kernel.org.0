Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15D31575294
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 18:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234643AbiGNQPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 12:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiGNQPs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 12:15:48 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A8461B13
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 09:15:47 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id eq6so3056309edb.6
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 09:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=govIWRa7qaOV2WIczJDqmAkYPYMG/67BzPW5XLlKyvc=;
        b=wwHDSW/azHUQ/dXzI4ImC8W7hItZhAmo8R0SiTyuuX/fYrhKkvqv3mVUr49+xTpUby
         9gn1VHxei66XkaRiu+VGyDuu4+GSld5MF8susPqmvURu8hnhGCXdUo/BSMSg3Tn4mab0
         AKIfp2W1bZ2YyxjaxFIfgAd5n6K1A6LC7UBBV9i4Ugl4g4BRDBOaj0EhfiJZownauzkV
         D+G3ZVhCZ9g698PJnHdoBLJCRmrQ2gaHD6Xrnw+wNPHZ7OHRMzYFLtKfutecE6Ezemet
         ILPzTdfaIQqJnWCXVn8HJ1NVEnJ8gVhHdS4czxVUj2+zjzhKg/lV5mxsI1gQIL+KPwLY
         p/eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=govIWRa7qaOV2WIczJDqmAkYPYMG/67BzPW5XLlKyvc=;
        b=sHKjNLbEeedmq9cyF1VVMkJ3qo6Hhek5bdGbQB4KO3JaedcjYQkySO6k7Cg9OOALmC
         vrAaHooPyk4bPmLEpe9UvXEA1+WEGMwSVyrIs7jW+mcryhEALwSMopvBQg6Za8uFcDHV
         HWpJo2+4KM8kXOR8ZZGSBt9ten6mR7nS6fjNHdhHeBr84WrsXxne7VKeJDMElOFKw4Aj
         eQxsD03Y2804S6V5uEZY6/wlhY09phn2xO2TO4tv8MGX/glZUQaRAIi71XlOpkx7W4Fz
         xTAKeN6XFXeAJlecJ7QWAbegLk2tdB45CGhzoO70h8lXcPA8NdZuoQ1N/GH43MilqaUb
         xfVg==
X-Gm-Message-State: AJIora/lQtyKeOcvOTvGwmWLP97PNzI3DR0xVzAeR1sSvLU6c+p5kAVX
        uRu8JX5Fps2HLMYwh84kKSt3EnLdYtyXAAzuxJdLbg==
X-Google-Smtp-Source: AGRyM1uRlQZY0lm6PlIZv8ZWPALNPT1WMYOIzlf7AeIvGx0GX2B+25LAtwrQYAbWLB7amc6FGJVkRbDm5tkd3xZByjE=
X-Received: by 2002:aa7:d5d7:0:b0:43a:6eda:464a with SMTP id
 d23-20020aa7d5d7000000b0043a6eda464amr13313083eds.193.1657815345955; Thu, 14
 Jul 2022 09:15:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220713171241.184026-1-cascardo@canonical.com>
 <Ys/ncSnSFEST4fgL@worktop.programming.kicks-ass.net> <976510d2-c7ad-2108-27e0-4c3b82c210f1@redhat.com>
In-Reply-To: <976510d2-c7ad-2108-27e0-4c3b82c210f1@redhat.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 14 Jul 2022 21:45:34 +0530
Message-ID: <CA+G9fYvxR8+4cajcCBbPRuhR1tnuBmrLxosSOMzPg7CjxQU35w@mail.gmail.com>
Subject: Re: [PATCH] x86/kvm: fix FASTOP_SIZE when return thunks are enabled
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Linux Kernel Functional Testing <lkft@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paolo,

On Thu, 14 Jul 2022 at 17:06, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 7/14/22 11:52, Peter Zijlstra wrote:
> > On Wed, Jul 13, 2022 at 02:12:41PM -0300, Thadeu Lima de Souza Cascardo wrote:
> >> The return thunk call makes the fastop functions larger, just like IBT
> >> does. Consider a 16-byte FASTOP_SIZE when CONFIG_RETHUNK is enabled.
> >>
> >> Otherwise, functions will be incorrectly aligned and when computing their
> >> position for differently sized operators, they will executed in the middle
> >> or end of a function, which may as well be an int3, leading to a crash
> >> like:
> >
> > Bah.. I did the SETcc stuff, but then forgot about the FASTOP :/
> >
> >    af2e140f3420 ("x86/kvm: Fix SETcc emulation for return thunks")
> >
> >> Fixes: aa3d480315ba ("x86: Use return-thunk in asm code")
> >> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> >> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> >> Cc: Borislav Petkov <bp@suse.de>
> >> Cc: Josh Poimboeuf <jpoimboe@kernel.org>
> >> Cc: Paolo Bonzini <pbonzini@redhat.com>
> >> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

> >> ---
> >>   arch/x86/kvm/emulate.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> >> index db96bf7d1122..d779eea1052e 100644
> >> --- a/arch/x86/kvm/emulate.c
> >> +++ b/arch/x86/kvm/emulate.c
> >> @@ -190,7 +190,7 @@
> >>   #define X16(x...) X8(x), X8(x)
> >>
> >>   #define NR_FASTOP (ilog2(sizeof(ulong)) + 1)
> >> -#define FASTOP_SIZE (8 * (1 + HAS_KERNEL_IBT))
> >> +#define FASTOP_SIZE (8 * (1 + (HAS_KERNEL_IBT | IS_ENABLED(CONFIG_RETHUNK))))
> >
> > Would it make sense to do something like this instead?
>
> Yes, definitely.  Applied with a small tweak to make FASTOP_LENGTH
> more similar to SETCC_LENGTH:
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index db96bf7d1122..0a15b0fec6d9 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -189,8 +189,12 @@
>   #define X8(x...) X4(x), X4(x)
>   #define X16(x...) X8(x), X8(x)
>
> -#define NR_FASTOP (ilog2(sizeof(ulong)) + 1)
> -#define FASTOP_SIZE (8 * (1 + HAS_KERNEL_IBT))
> +#define NR_FASTOP      (ilog2(sizeof(ulong)) + 1)
> +#define RET_LENGTH     (1 + (4 * IS_ENABLED(CONFIG_RETHUNK)) + \
> +                        IS_ENABLED(CONFIG_SLS))
> +#define FASTOP_LENGTH  (ENDBR_INSN_SIZE + 7 + RET_LENGTH)
> +#define FASTOP_SIZE    (8 << ((FASTOP_LENGTH > 8) & 1) << ((FASTOP_LENGTH > 16) & 1))
> +static_assert(FASTOP_LENGTH <= FASTOP_SIZE);
>
>   struct opcode {
>         u64 flags;
> @@ -442,8 +446,6 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
>    * RET | JMP __x86_return_thunk       [1,5 bytes; CONFIG_RETHUNK]
>    * INT3                               [1 byte; CONFIG_SLS]
>    */
> -#define RET_LENGTH     (1 + (4 * IS_ENABLED(CONFIG_RETHUNK)) + \
> -                        IS_ENABLED(CONFIG_SLS))
>   #define SETCC_LENGTH  (ENDBR_INSN_SIZE + 3 + RET_LENGTH)
>   #define SETCC_ALIGN   (4 << ((SETCC_LENGTH > 4) & 1) << ((SETCC_LENGTH > 8) & 1))
>   static_assert(SETCC_LENGTH <= SETCC_ALIGN);
>
>
> Paolo

Applied your patch and tested on top of the mainline kernel and
tested kvm-unit-tests and reported kernel panic fixed.

https://lkft.validation.linaro.org/scheduler/job/5284626

- Naresh
