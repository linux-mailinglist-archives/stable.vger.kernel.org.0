Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 341876C7DFD
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 13:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbjCXMYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 08:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbjCXMYn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 08:24:43 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D026224BC0
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 05:24:39 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id i5so7489725eda.0
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 05:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112; t=1679660678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=saiJWfiBJYUHFmmkpXKqAcWXgG16rIcjFJWmsrkcUI8=;
        b=EtKrFAIJqJ7YZIEm/FMGhq05IjhpUe6/Li67kSto0rxiCIL9ChSECmKLpZP8MICvTJ
         A4LHKUIBYl66xKKWghQbVhEdqlDgGPZEYd2HSUiblT6Vo1VXHrFQlUEOFe1OebHWzo7w
         rwO+LIZs1KftyqlJM2mcOpIUhnH/IyoXSWnuzw2kjpysVG6cQVYfE1q+fMorBZbWDwGd
         fADvXukNqjPLIZRBWs5TTZjekakGChj4gh1AUE06DWDCuGHFuJfzs+XJWGfh/Q282xjG
         p9zUmlLcgePiwXKo0ntqmBcx/pqwztc0KqarUUddIvb+7ACbF6J6uPnKdbi/ZQOTWWgG
         Snig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679660678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=saiJWfiBJYUHFmmkpXKqAcWXgG16rIcjFJWmsrkcUI8=;
        b=csNu+S0KBS6l1Jd0EtKn92OSg6G/NK1/J5N/RGEKA6KOdRX2T43GyvyylChGCA+90a
         ZY9phIyNGIK2mnemE+CMSpxkpCzkenjwja+NTyAUSrmTL/nCUGirgGegCp/9aLhjsFaO
         vJUlWbVsxK/4oSJ2gjYTeLeqLEf+5hmA/UzjU3itjUzdqi2is/VNfVdzk2jr91ZOD2ZJ
         UpXdD8IHNT9aXDA0G4fnoxxhZAbhDEeBM9xFJKltP4UewBDfh98J9FH1tu14zmzSs+CO
         Vku1JgoNSJ7Lv0dCSV5Kdx45Cye4iyO4Hn4MmxMrozDaQ82M5Gi2plo25lLrqFglZWJR
         Q1RQ==
X-Gm-Message-State: AO0yUKWYpO02FnGThWIIYHq4L8elKxFe06ilvQK/uq34Itk3xgMdvC/e
        XS7rd3WAitYWO/ajdiqAnKbuza9c3bWnwo2JMOVG6Q==
X-Google-Smtp-Source: AK7set9rky6P4VsXrUmz7PYgIM7cL0IKBL36K0jYa02+JzZXAjW8VAmeF9bBNJsOXuA+Z8/lRmfSNoLeRN5Gl/Db24Q=
X-Received: by 2002:a17:907:11c6:b0:930:310:abe3 with SMTP id
 va6-20020a17090711c600b009300310abe3mr5178745ejb.6.1679660678163; Fri, 24 Mar
 2023 05:24:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230317211106.1234484-1-dmatlack@google.com>
In-Reply-To: <20230317211106.1234484-1-dmatlack@google.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 24 Mar 2023 17:54:27 +0530
Message-ID: <CAAhSdy3RJvsCTTfr6mCJe+=on-B0QOM10dTchAR7rKq0tyVWEA@mail.gmail.com>
Subject: Re: [PATCH] KVM: RISC-V: Retry fault if vma_lookup() results become invalid
To:     David Matlack <dmatlack@google.com>
Cc:     Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <graf@amazon.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 18, 2023 at 2:41=E2=80=AFAM David Matlack <dmatlack@google.com>=
 wrote:
>
> Read mmu_invalidate_seq before dropping the mmap_lock so that KVM can
> detect if the results of vma_lookup() (e.g. vma_shift) become stale
> before it acquires kvm->mmu_lock. This fixes a theoretical bug where a
> VMA could be changed by userspace after vma_lookup() and before KVM
> reads the mmu_invalidate_seq, causing KVM to install page table entries
> based on a (possibly) no-longer-valid vma_shift.
>
> Re-order the MMU cache top-up to earlier in user_mem_abort() so that it
> is not done after KVM has read mmu_invalidate_seq (i.e. so as to avoid
> inducing spurious fault retries).
>
> It's unlikely that any sane userspace currently modifies VMAs in such a
> way as to trigger this race. And even with directed testing I was unable
> to reproduce it. But a sufficiently motivated host userspace might be
> able to exploit this race.
>
> Note KVM/ARM had the same bug and was fixed in a separate, near
> identical patch (see Link).
>
> Link: https://lore.kernel.org/kvm/20230313235454.2964067-1-dmatlack@googl=
e.com/
> Fixes: 9955371cc014 ("RISC-V: KVM: Implement MMU notifiers")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Matlack <dmatlack@google.com>

I have tested this patch for both QEMU RV64 and RV32 so,
Tested-by: Anup Patel <anup@brainfault.org>

Queued this patch as fixes for Linux-6.3

Thanks,
Anup

> ---
> Note: Compile-tested only.
>
>  arch/riscv/kvm/mmu.c | 25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 78211aed36fa..46d692995830 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -628,6 +628,13 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>                         !(memslot->flags & KVM_MEM_READONLY)) ? true : fa=
lse;
>         unsigned long vma_pagesize, mmu_seq;
>
> +       /* We need minimum second+third level pages */
> +       ret =3D kvm_mmu_topup_memory_cache(pcache, gstage_pgd_levels);
> +       if (ret) {
> +               kvm_err("Failed to topup G-stage cache\n");
> +               return ret;
> +       }
> +
>         mmap_read_lock(current->mm);
>
>         vma =3D vma_lookup(current->mm, hva);
> @@ -648,6 +655,15 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>         if (vma_pagesize =3D=3D PMD_SIZE || vma_pagesize =3D=3D PUD_SIZE)
>                 gfn =3D (gpa & huge_page_mask(hstate_vma(vma))) >> PAGE_S=
HIFT;
>
> +       /*
> +        * Read mmu_invalidate_seq so that KVM can detect if the results =
of
> +        * vma_lookup() or gfn_to_pfn_prot() become stale priort to acqui=
ring
> +        * kvm->mmu_lock.
> +        *
> +        * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pa=
irs
> +        * with the smp_wmb() in kvm_mmu_invalidate_end().
> +        */
> +       mmu_seq =3D kvm->mmu_invalidate_seq;
>         mmap_read_unlock(current->mm);
>
>         if (vma_pagesize !=3D PUD_SIZE &&
> @@ -657,15 +673,6 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>                 return -EFAULT;
>         }
>
> -       /* We need minimum second+third level pages */
> -       ret =3D kvm_mmu_topup_memory_cache(pcache, gstage_pgd_levels);
> -       if (ret) {
> -               kvm_err("Failed to topup G-stage cache\n");
> -               return ret;
> -       }
> -
> -       mmu_seq =3D kvm->mmu_invalidate_seq;
> -
>         hfn =3D gfn_to_pfn_prot(kvm, gfn, is_write, &writable);
>         if (hfn =3D=3D KVM_PFN_ERR_HWPOISON) {
>                 send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,
>
> base-commit: eeac8ede17557680855031c6f305ece2378af326
> --
> 2.40.0.rc2.332.ga46443480c-goog
>
