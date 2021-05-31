Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD13396865
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 21:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhEaTjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 15:39:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231144AbhEaTjk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 15:39:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D9716135C;
        Mon, 31 May 2021 19:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622489880;
        bh=DxmToG3L31wIR+9AdgK9OhgVLZyRMZ/xTbCfSGTuyhQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QBl6dcmn1Rx7zOlV2n2Nl+2g6JAtjkgqPcHvclhsLlHustjWEFdadRTHjjlkqK4qs
         +M3oZt+zsuDljk+HeIXVQJEnHucadsgqqhkWNgG2qgZjxfautiQTmjDPUv80T0lG5v
         Sw1owFkPyCbIyUm99iqkdEEA6vaz4J8WT49k3k5IC5sMAN1GUJEgXyFXSdrHRJ0h1Z
         Q7AsdsrxL5OXBH2I6b/kFwevlUu1upQVPfZ3jmof8zEdjFv/x6zGEh7t4NuEp3SNsM
         EuBD7uOZyXO0LDJcnF/LNhm/mU4kutwi0vpzUKB/ZI/Do3GIuteNLPXUg1rcVFxH7R
         AgIgYEy/jzx3w==
Received: by mail-ot1-f54.google.com with SMTP id i23-20020a9d68d70000b02902dc19ed4c15so12049102oto.0;
        Mon, 31 May 2021 12:38:00 -0700 (PDT)
X-Gm-Message-State: AOAM531BSksz8cNSHRD2+QDz3ong4/7uykjHW+M4RKHh0PmCOLEeAyn9
        BwhUZDejimT4zrt0FN7Q3dgM8XnYIUrMMwiveu0=
X-Google-Smtp-Source: ABdhPJxPwjDBqtCO2vVdoCZIFP8PKpzd7N2ZxjbZBqdZTvAj4/TEDt5tvoyFrMZSG6HJFmhLRxOFwg7krnBvo9m5Hkg=
X-Received: by 2002:a9d:69c5:: with SMTP id v5mr17902553oto.108.1622489879945;
 Mon, 31 May 2021 12:37:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210531095720.77469-1-maz@kernel.org> <20210531095720.77469-2-maz@kernel.org>
In-Reply-To: <20210531095720.77469-2-maz@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 31 May 2021 21:37:49 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFNUAtXPzO+EbMzZQPxgst4BMEUuYbrWwYer3P9trYdLQ@mail.gmail.com>
Message-ID: <CAMj1kXFNUAtXPzO+EbMzZQPxgst4BMEUuYbrWwYer3P9trYdLQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] arm64: kexec_file: Forbid non-crash kernels
To:     Marc Zyngier <maz@kernel.org>
Cc:     kexec@lists.infradead.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Bhupesh SHARMA <bhupesh.sharma@linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Dave Young <dyoung@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Moritz Fischer <mdf@kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 31 May 2021 at 11:57, Marc Zyngier <maz@kernel.org> wrote:
>
> It has been reported that kexec_file doesn't really work on arm64.
> It completely ignores any of the existing reservations, which results
> in the secondary kernel being loaded where the GICv3 LPI tables live,
> or even corrupting the ACPI tables.
>
> Since only crash kernels are imune to this as they use a reserved
> memory region, disable the non-crash kernel use case. Further
> patches will try and restore the functionality.
>
> Reported-by: Moritz Fischer <mdf@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org # 5.10

Acked-by: Ard Biesheuvel <ardb@kernel.org>

... but do we really only need this in 5.10 and not earlier?

> ---
>  arch/arm64/kernel/kexec_image.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/arch/arm64/kernel/kexec_image.c b/arch/arm64/kernel/kexec_image.c
> index 9ec34690e255..acf9cd251307 100644
> --- a/arch/arm64/kernel/kexec_image.c
> +++ b/arch/arm64/kernel/kexec_image.c
> @@ -145,3 +145,23 @@ const struct kexec_file_ops kexec_image_ops = {
>         .verify_sig = image_verify_sig,
>  #endif
>  };
> +
> +/**
> + * arch_kexec_locate_mem_hole - Find free memory to place the segments.
> + * @kbuf:                       Parameters for the memory search.
> + *
> + * On success, kbuf->mem will have the start address of the memory region found.
> + *
> + * Return: 0 on success, negative errno on error.
> + */
> +int arch_kexec_locate_mem_hole(struct kexec_buf *kbuf)
> +{
> +       /*
> +        * For the time being, kexec_file_load isn't reliable except
> +        * for crash kernel. Say sorry to the user.
> +        */
> +       if (kbuf->image->type != KEXEC_TYPE_CRASH)
> +               return -EADDRNOTAVAIL;
> +
> +       return kexec_locate_mem_hole(kbuf);
> +}
> --
> 2.30.2
>
