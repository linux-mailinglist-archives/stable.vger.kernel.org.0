Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26857535639
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 00:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236928AbiEZW4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 18:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235650AbiEZW4q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 18:56:46 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31932F3AB
        for <stable@vger.kernel.org>; Thu, 26 May 2022 15:56:45 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id x137so5218322ybg.5
        for <stable@vger.kernel.org>; Thu, 26 May 2022 15:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vKYNDqC9qWTlcvuwdXl4ysmwh+YcbKwkfLj+t7mZ4iw=;
        b=K4dMTaMxYQKW9sKocetoR2WRTdDWY7vZPBKIYSFx2XGnx99IONWdnQKt1XDaFoXVoC
         cC4kRN05mz8zTfCSiHIxzanymip691LiyHFfIhv1Qpc6/FSxJoQGB2TnMsHDzMJnKpFU
         BAt+bjgjVqGqSOZrCnbSmAPCwlAuIQOmL9yKw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vKYNDqC9qWTlcvuwdXl4ysmwh+YcbKwkfLj+t7mZ4iw=;
        b=KIpzr7tSyu/Yp7avT8Uz58Zh3ca4201mBR72fhq7AD2KkglKnwbe+dzAeAi8ZXef8N
         Qf/3bvb1Y8PuQ9yxmF6lHd2bUfV38kzcBBgtcK1VFZBXVW4LQ14A6mKjVNvPQT33amrx
         ybEL1UZ2r+cvV8528V+89KJO+/wm5IChGH+9JO3mDdBRr2mHs+7g7MhoO2eylfcQO62i
         FY+o35lTlcf27HHyyIEABnRxO90D/YIx+VnVs4sw/wG1UrrY0TkbbKm5sP0fh93evcAU
         goGaoOOXJcSD0o4FIXMOTVRPcKwWq6LUzCXGKlpLs8kK2VoV/2PrtQ8eIyIiv1B4CDDJ
         8bgg==
X-Gm-Message-State: AOAM531qMFA9QQ7yvCiq1Fk8oB+V7hFJqQd1H3qG/u9VO+ZxTLhz+Wlj
        xro0DT/GGIqnXgE92TeIvyBujSlblQtFEADkrkup
X-Google-Smtp-Source: ABdhPJx/k9rpN/zIvs2TbHiEfM32NHM3fIQ9BswQdZnVHjx3E3n4/Depq0LAf9Vecr/BjxkODsjSubzrM9NeLTq/Y8M=
X-Received: by 2002:a25:c0d2:0:b0:657:952e:e4a6 with SMTP id
 c201-20020a25c0d2000000b00657952ee4a6mr3344832ybf.143.1653605805035; Thu, 26
 May 2022 15:56:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220526101131.2340729-1-sunilvl@ventanamicro.com> <20220526101131.2340729-3-sunilvl@ventanamicro.com>
In-Reply-To: <20220526101131.2340729-3-sunilvl@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Thu, 26 May 2022 15:56:34 -0700
Message-ID: <CAOnJCUK5i0HpU-=h41Z9PcOHWwndB7iX6ePb2kyuEf1qaSKytA@mail.gmail.com>
Subject: Re: [PATCH V2 2/5] riscv: spinwait: Fix hartid variable type
To:     Sunil V L <sunilvl@ventanamicro.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Atish Patra <atishp@rivosinc.com>,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        Anup Patel <apatel@ventanamicro.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        Sunil V L <sunil.vl@gmail.com>, stable@vger.kernel.org
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

On Thu, May 26, 2022 at 3:12 AM Sunil V L <sunilvl@ventanamicro.com> wrote:
>
> The hartid variable is of type int but compared with
> ULONG_MAX(INVALID_HARTID). This issue is fixed by changing
> the hartid variable type to unsigned long.
>
> Fixes: c78f94f35cf6 ("RISC-V: Use __cpu_up_stack/task_pointer only for spinwait method")
> Cc: stable@vger.kernel.org
>
> Signed-off-by: Sunil V L <sunilvl@ventanamicro.com>
> ---
>  arch/riscv/kernel/cpu_ops_spinwait.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kernel/cpu_ops_spinwait.c b/arch/riscv/kernel/cpu_ops_spinwait.c
> index 346847f6c41c..3ade9152a3c7 100644
> --- a/arch/riscv/kernel/cpu_ops_spinwait.c
> +++ b/arch/riscv/kernel/cpu_ops_spinwait.c
> @@ -18,7 +18,7 @@ void *__cpu_spinwait_task_pointer[NR_CPUS] __section(".data");
>  static void cpu_update_secondary_bootdata(unsigned int cpuid,
>                                    struct task_struct *tidle)
>  {
> -       int hartid = cpuid_to_hartid_map(cpuid);
> +       unsigned long hartid = cpuid_to_hartid_map(cpuid);
>
>         /*
>          * The hartid must be less than NR_CPUS to avoid out-of-bound access
> @@ -27,7 +27,7 @@ static void cpu_update_secondary_bootdata(unsigned int cpuid,
>          * spinwait booting is not the recommended approach for any platforms
>          * booting Linux in S-mode and can be disabled in the future.
>          */
> -       if (hartid == INVALID_HARTID || hartid >= NR_CPUS)
> +       if (hartid == INVALID_HARTID || hartid >= (unsigned long) NR_CPUS)
>                 return;
>
>         /* Make sure tidle is updated */
> --
> 2.25.1
>

Reviewed-by: Atish Patra <atishp@rivosinc.com>

-- 
Regards,
Atish
