Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008984F0DCC
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 05:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356124AbiDDDxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 23:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349282AbiDDDxe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 23:53:34 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1164B31218
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 20:51:38 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id h4so12448849wrc.13
        for <stable@vger.kernel.org>; Sun, 03 Apr 2022 20:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r5K6b0sc6oOdX9PQxMtrYXV8USG1YlONAxoBoZNU3l4=;
        b=KK3qDVtl6tM1RC0vWJnjyjAOaBy9HeE8/J3cKTugiWs6TNndA8Vg82MGSJiu79ETZ9
         X+G314yykqvPYI2h4vxy4qqe0E8bDEu6Pk23l8xjJMUNi4sSsIUwyXUPZb3codKUinnS
         7eLz56OFMh+1h+AdCdVcpMxwkT0tCike5pComkqD4oMYKXMz8k3wGwwT7UrbveBFjtRV
         Ql3xXEdAWWyf/cRgLKSfwCvFdjvS0exmaL4XX1iOCKrs/N84Me5KcmEyAJsWdb4YGTs4
         8yDSipiD22wqji5E7+BXbjOGj1jhfghTr1RjRNbedQ0BdvxbxVt2GRKJULuUKAon/jNy
         T/Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r5K6b0sc6oOdX9PQxMtrYXV8USG1YlONAxoBoZNU3l4=;
        b=xoTAteabPsPm1rXs68fBwJsZmXr2DCSZGVPKkA1dtN8j7P9CVkX2VgSBz0+5//RqU8
         TQPvjRHCEO2MR/PJap++vygKniMGrqWLJdljNZp3SrsEeiS9MRs67SVf+nrwfU5BcCeP
         Jv2INlDhtbP5tGFm2l9wxmNq3nm8ouSMUa8gKgjjeCw62FZyY/YL9NoIeyRTpyfC1JUx
         fiOL7tYcIwivV9tJoGyE5WG2rdQ1F9m7ofVRfrtd/EDk8YjIPU+5Cdvv8nEydNgsdf3e
         /TWzioavH16PQBOt2XyJWq9A6aIItDgptsAnMLUK4pFEVnqDJCixYfT6RSkIeCr5w/aM
         /nRg==
X-Gm-Message-State: AOAM533FhTfZ3diayMhoqPodF6QZLRftGDZKyU6Yag5cROdtq8YzboBo
        h4Zx1SO4cLfzH98+S4PBPOGaMrp2Qj6nm+wrBJYp8w==
X-Google-Smtp-Source: ABdhPJy03E7/LbI9hh3U5hDa7d5BQW5aEeRI/tPy/1Eq7sLg6T5XYwIswOiGCVJ6FybEoaUugQyf7PY6NWQ6q5tyzFU=
X-Received: by 2002:a5d:6c6b:0:b0:1ea:77ea:dde8 with SMTP id
 r11-20020a5d6c6b000000b001ea77eadde8mr15660633wrz.690.1649044297423; Sun, 03
 Apr 2022 20:51:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220317035521.272486-1-apatel@ventanamicro.com>
In-Reply-To: <20220317035521.272486-1-apatel@ventanamicro.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 4 Apr 2022 09:20:27 +0530
Message-ID: <CAAhSdy35a5PrdSzonK6EeH0nynFxvvUzScaYRPeA=CmG5yuz+Q@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Don't clear hgatp CSR in kvm_arch_vcpu_put()
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 17, 2022 at 9:25 AM Anup Patel <apatel@ventanamicro.com> wrote:
>
> We might have RISC-V systems (such as QEMU) where VMID is not part
> of the TLB entry tag so these systems will have to flush all TLB
> entries upon any change in hgatp.VMID.
>
> Currently, we zero-out hgatp CSR in kvm_arch_vcpu_put() and we
> re-program hgatp CSR in kvm_arch_vcpu_load(). For above described
> systems, this will flush all TLB entries whenever VCPU exits to
> user-space hence reducing performance.
>
> This patch fixes above described performance issue by not clearing
> hgatp CSR in kvm_arch_vcpu_put().
>
> Fixes: 34bde9d8b9e6 ("RISC-V: KVM: Implement VCPU world-switch")
> Cc: stable@vger.kernel.org
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>

I have queued this patch for RC fixes.

Thanks,
Anup

> ---
>  arch/riscv/kvm/vcpu.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 624166004e36..6785aef4cbd4 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -653,8 +653,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>                                      vcpu->arch.isa);
>         kvm_riscv_vcpu_host_fp_restore(&vcpu->arch.host_context);
>
> -       csr_write(CSR_HGATP, 0);
> -
>         csr->vsstatus = csr_read(CSR_VSSTATUS);
>         csr->vsie = csr_read(CSR_VSIE);
>         csr->vstvec = csr_read(CSR_VSTVEC);
> --
> 2.25.1
>
