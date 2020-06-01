Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9F21EAD22
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgFASm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731504AbgFASmn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 14:42:43 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB23C08C5C9
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 11:23:24 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id c3so757481wru.12
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 11:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7ORKuPDr81ZTRpp39aYW+4mCM6zzq+FYt0tOhd8RtB8=;
        b=V03H8YHXT0J3zKfEHNyuFSM+8VZyYqjgKZmFQoD7IoWAdl5ue3WkPABR4A2m1qnxIv
         TEi0T0Bs71krCQoC2Hz1kmVhqKEsfEYxAaUXego6pB3dMnsl4fgP28IxSqNy3yfo1KY6
         JtB21X3S69XND6s4AR5BKc65vUpNJV77q9Ptw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7ORKuPDr81ZTRpp39aYW+4mCM6zzq+FYt0tOhd8RtB8=;
        b=TzLdgOZO+Ce0DgL/0Q1uAumyiId28kEVRGRsFKLLBlO0G8eu/x1LgP4QVSQaqPA2l5
         nuB31aRfQqNUmRwPPNlY5Cv0MRHrwUeAwwjxwufYv/HVYMwecQwpHjP6bdFLRnPPoFW2
         JsVaiWk9KTLuM8hIq2dNRtpP8YAK4dPxHV7PgijJ8pEF0Gv+vZ4HY/t9hqzCXImY2HMy
         csAyJq7RC7n7mZkBquTZR0swp5xvt3EKC1NNStCPyPOWammll6H98LZqodsPobJXBAVv
         7MfuuQ7VjmtZK6c/0yfzaWEloPWv7KmuUssRE3+oOj0yECErZpEyMw3pW1HOIeqSBbas
         DLTQ==
X-Gm-Message-State: AOAM531almWduNuZp0pmwDX4l8KROFLtO7M/AmL7fYV+VIlt6Eic9LiS
        qoFOTNxDIwjuAazpd13ObRhCrFZYjWyK7iSjYXae
X-Google-Smtp-Source: ABdhPJzUqjNllZMEEg1nn6d/J5AuzWmQPqp4dOddQX+lLHvzFb+TTwXYz/WenpZhHpRJLxBXZKmb6pusTzpc3hUhqhk=
X-Received: by 2002:adf:edc8:: with SMTP id v8mr22011928wro.176.1591035802832;
 Mon, 01 Jun 2020 11:23:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200601050656.826296-1-anup.patel@wdc.com>
In-Reply-To: <20200601050656.826296-1-anup.patel@wdc.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Mon, 1 Jun 2020 11:23:11 -0700
Message-ID: <CAOnJCUKT_DT-F9g21q5kvYfYgHC3PQ9dJLrqbQ4z87ULpBiyBQ@mail.gmail.com>
Subject: Re: [PATCH v2] RISC-V: Don't mark init section as non-executable
To:     Anup Patel <anup.patel@wdc.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 31, 2020 at 10:07 PM Anup Patel <anup.patel@wdc.com> wrote:
>
> The head text section (i.e. _start, secondary_start_sbi, etc) and the
> init section fall under same page table level-1 mapping.
>
> Currently, the runtime CPU hotplug is broken because we are marking
> init section as non-executable which in-turn marks head text section
> as non-executable.
>
> Further investigating other architectures, it seems marking the init
> section as non-executable is redundant because the init section pages
> are anyway poisoned and freed.
>
> To fix broken runtime CPU hotplug, we simply remove the code marking
> the init section as non-executable.
>
> Fixes: d27c3c90817e ("riscv: add STRICT_KERNEL_RWX support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> ---
> Changes since v1:
>  - Updated free_initmem() is same as generic free_initmem() defined in
>    init/main.c so we completely remove free_initmem() from arch/riscv
> ---
>  arch/riscv/mm/init.c | 11 -----------
>  1 file changed, 11 deletions(-)
>
> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
> index 736de6c8739f..fdc772f57edc 100644
> --- a/arch/riscv/mm/init.c
> +++ b/arch/riscv/mm/init.c
> @@ -479,17 +479,6 @@ static void __init setup_vm_final(void)
>         csr_write(CSR_SATP, PFN_DOWN(__pa_symbol(swapper_pg_dir)) | SATP_MODE);
>         local_flush_tlb_all();
>  }
> -
> -void free_initmem(void)
> -{
> -       unsigned long init_begin = (unsigned long)__init_begin;
> -       unsigned long init_end = (unsigned long)__init_end;
> -
> -       /* Make the region as non-execuatble. */
> -       set_memory_nx(init_begin, (init_end - init_begin) >> PAGE_SHIFT);
> -       free_initmem_default(POISON_FREE_INITMEM);
> -}
> -
>  #else
>  asmlinkage void __init setup_vm(uintptr_t dtb_pa)
>  {
> --
> 2.25.1
>
>

Reviewed-by: Atish Patra <atish.patra@wdc.com>
-- 
Regards,
Atish
