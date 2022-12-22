Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41634654175
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 14:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235346AbiLVNCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 08:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235386AbiLVNCM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 08:02:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D9C2793D;
        Thu, 22 Dec 2022 05:02:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1896B81D11;
        Thu, 22 Dec 2022 13:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD1FC43392;
        Thu, 22 Dec 2022 13:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671714128;
        bh=+il+SxtPaF4c4xhIERSlV2b3ebbMTBDe+tDbOlWavI0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LjgSe3GSP0mW8adQgzLeMLPnwVygpphDdWa+BPcD1ECfJRmzzdQJjvMPGXRjo9Udq
         8yC8XbmXvUuAjZyXWQt1cDBVqNrCk8WX8GP+xSa96IS49fN/H9ezA/DTkcBx4BWAHS
         u+SkG8R7qYRHRwXJ0j/L8lq6qVVnBUetpboBeWYbQ6eNlBnWZcT9BrcJKJKEfOrEoN
         67gMnoIyBGXwnc6x0TVUrg+4KWDVsbQag6/LVhpsuks5bQqbBHaGZGs4bF+XwciDqB
         wcskYfV+uiM4ggb7efsnRqFMETthrIyjUj8AoO7eIlbFZaRLh8wi5E8D0a58vfJJyv
         2s4JEZ0af1Y0A==
Received: by mail-lf1-f52.google.com with SMTP id b3so2649612lfv.2;
        Thu, 22 Dec 2022 05:02:08 -0800 (PST)
X-Gm-Message-State: AFqh2kpeltGF4sH3pX66moV/qJM4WSna7++XnxxDmLBm+r7VorD39Dsa
        ZVuOHT9CxNBYqnn4YbLnBncGzcH8crTUdZ1f4/Y=
X-Google-Smtp-Source: AMrXdXs/FbXEMKkikcQh2g0G6KKTqaNtxuHVOptoJqHyWe59cAaGZyR/wktYEyC/Z4h8imqHqegrkCH7cW9DCXyG+z0=
X-Received: by 2002:ac2:5d4e:0:b0:4b5:964d:49a4 with SMTP id
 w14-20020ac25d4e000000b004b5964d49a4mr572665lfd.637.1671714126548; Thu, 22
 Dec 2022 05:02:06 -0800 (PST)
MIME-Version: 1.0
References: <20221220200923.1532710-1-maz@kernel.org> <20221220200923.1532710-2-maz@kernel.org>
In-Reply-To: <20221220200923.1532710-2-maz@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 22 Dec 2022 14:01:55 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE57xTzkmdhQzxOBSePVzUCS5GW7PAVvx+iF+3UHv0OrA@mail.gmail.com>
Message-ID: <CAMj1kXE57xTzkmdhQzxOBSePVzUCS5GW7PAVvx+iF+3UHv0OrA@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Fix S1PTW handling on RO memslots
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 20 Dec 2022 at 21:09, Marc Zyngier <maz@kernel.org> wrote:
>
> A recent development on the EFI front has resulted in guests having
> their page tables baked in the firmware binary, and mapped into
> the IPA space as part as a read-only memslot.
>
> Not only this is legitimate, but it also results in added security,
> so thumbs up. However, this clashes mildly with our handling of a S1PTW
> as a write to correctly handle AF/DB updates to the S1 PTs, and results
> in the guest taking an abort it won't recover from (the PTs mapping the
> vectors will suffer freom the same problem...).
>
> So clearly our handling is... wrong.
>
> Instead, switch to a two-pronged approach:
>
> - On S1PTW translation fault, handle the fault as a read
>
> - On S1PTW permission fault, handle the fault as a write
>
> This is of no consequence to SW that *writes* to its PTs (the write
> will trigger a non-S1PTW fault), and SW that uses RO PTs will not
> use AF/DB anyway, as that'd be wrong.
>
> Only in the case described in c4ad98e4b72c ("KVM: arm64: Assume write
> fault on S1PTW permission fault on instruction fetch") do we end-up
> with two back-to-back faults (page being evicted and faulted back).
> I don't think this is a case worth optimising for.
>
> Fixes: c4ad98e4b72c ("KVM: arm64: Assume write fault on S1PTW permission fault on instruction fetch")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

I have tested this patch on my TX2 with one of the EFI builds in
question, and everything works as before (I never observed the issue
itself)

Regression-tested-by: Ard Biesheuvel <ardb@kernel.org>

For the record, the EFI build in question targets QEMU/mach-virt and
switches to a set of read-only page tables in emulated NOR flash
straight out of reset, so it can create and populate the real page
tables with MMU and caches enabled. EFI does not use virtual memory or
paging so managing access flags or dirty bits in hardware is unlikely
to add any value, and it is not being used at the moment. And given
that this is emulated NOR flash, any ordinary write to it tears down
the r/o memslot altogether, and kicks the NOR flash emulation in QEMU
into programming mode, which is fully based on MMIO emulation and does
not use a memslot at all. IOW, even if we could figure out what store
the PTW was attempting to do, it is always going to be rejected since
the r/o page tables can only be modified by 'programming' the NOR
flash sector.


> ---
>  arch/arm64/include/asm/kvm_emulate.h | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 9bdba47f7e14..fd6ad8b21f85 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -373,8 +373,26 @@ static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
>
>  static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
>  {
> -       if (kvm_vcpu_abt_iss1tw(vcpu))
> -               return true;
> +       if (kvm_vcpu_abt_iss1tw(vcpu)) {
> +               /*
> +                * Only a permission fault on a S1PTW should be
> +                * considered as a write. Otherwise, page tables baked
> +                * in a read-only memslot will result in an exception
> +                * being delivered in the guest.
> +                *
> +                * The drawback is that we end-up fauling twice if the
> +                * guest is using any of HW AF/DB: a translation fault
> +                * to map the page containing the PT (read only at
> +                * first), then a permission fault to allow the flags
> +                * to be set.
> +                */
> +               switch (kvm_vcpu_trap_get_fault_type(vcpu)) {
> +               case ESR_ELx_FSC_PERM:
> +                       return true;
> +               default:
> +                       return false;
> +               }
> +       }
>
>         if (kvm_vcpu_trap_is_iabt(vcpu))
>                 return false;
> --
> 2.34.1
>
