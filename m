Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5CDA2625FD
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 05:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgIIDxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 23:53:37 -0400
Received: from mo-csw-fb1114.securemx.jp ([210.130.202.173]:36110 "EHLO
        mo-csw-fb.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgIIDxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 23:53:37 -0400
X-Greylist: delayed 1791 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Sep 2020 23:53:35 EDT
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1114) id 0893NguN008293; Wed, 9 Sep 2020 12:23:44 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1115) id 0893NC1k019288; Wed, 9 Sep 2020 12:23:12 +0900
X-Iguazu-Qid: 2wGqu78fjgdqsiLAfO
X-Iguazu-QSIG: v=2; s=0; t=1599621791; q=2wGqu78fjgdqsiLAfO; m=DYT0UINKyeExPjuDuIYDWKRawt8iW+J/bc7NgKefQbM=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1110) id 0893N9Bd019173;
        Wed, 9 Sep 2020 12:23:09 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 0893N9Ae003824;
        Wed, 9 Sep 2020 12:23:09 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 0893N8um023841;
        Wed, 9 Sep 2020 12:23:08 +0900
From:   Punit Agrawal <punit1.agrawal@toshiba.co.jp>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Steven Price <steven.price@arm.com>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 7/9] KVM: arm64: Do not try to map PUDs when they are folded into PMD
References: <20200904104530.1082676-1-maz@kernel.org>
        <20200904104530.1082676-8-maz@kernel.org>
Date:   Wed, 09 Sep 2020 12:23:07 +0900
In-Reply-To: <20200904104530.1082676-8-maz@kernel.org> (Marc Zyngier's message
        of "Fri, 4 Sep 2020 11:45:28 +0100")
X-TSB-HOP: ON
Message-ID: <874ko7prac.fsf@kokedama.swc.toshiba.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc,

Noticed this patch while catching up with the lists.

Marc Zyngier <maz@kernel.org> writes:

> For the obscure cases where PMD and PUD are the same size
> (64kB pages with 42bit VA, for example, which results in only
> two levels of page tables), we can't map anything as a PUD,
> because there is... erm... no PUD to speak of. Everything is
> either a PMD or a PTE.
>
> So let's only try and map a PUD when its size is different from
> that of a PMD.
>
> Cc: stable@vger.kernel.org
> Fixes: b8e0ba7c8bea ("KVM: arm64: Add support for creating PUD hugepages at stage 2")
> Reported-by: Gavin Shan <gshan@redhat.com>
> Reported-by: Eric Auger <eric.auger@redhat.com>
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Eric Auger <eric.auger@redhat.com>
> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/mmu.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 0121ef2c7c8d..16b8660ddbcc 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1964,7 +1964,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		(fault_status == FSC_PERM &&
>  		 stage2_is_exec(mmu, fault_ipa, vma_pagesize));
>  
> -	if (vma_pagesize == PUD_SIZE) {
> +	/*
> +	 * If PUD_SIZE == PMD_SIZE, there is no real PUD level, and
> +	 * all we have is a 2-level page table. Trying to map a PUD in
> +	 * this case would be fatally wrong.
> +	 */
> +	if (PUD_SIZE != PMD_SIZE && vma_pagesize == PUD_SIZE) {
>  		pud_t new_pud = kvm_pfn_pud(pfn, mem_type);
>  
>  		new_pud = kvm_pud_mkhuge(new_pud);

Good catch!
Missed the 64kb / 42b VA case while adding the initial support.

Thanks for fixing it.

Punit
