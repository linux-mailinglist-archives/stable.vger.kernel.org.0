Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5B31D94D4
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 13:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgESLAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 07:00:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40165 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727882AbgESLAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 07:00:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589886001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ig4SoG/WbpRUHpv0VDOp+3Mc+jUZUuv5700vzHNpJ6o=;
        b=HOj/Itv01iLVQJPV82f0LIZzEvTYDmG4hkkMNZ85ImM0G41BWvQtL38HFNohgeUzqq1wvZ
        viUZH6V3rk0zFj89ffBhQhDX3kXH3QScEOXQBXjygEJv+mz8ehFdQ9lQOkB/yTFLriQ7+7
        xBBcAjDG6Evw4OQ8a481QjahfMX/J0g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-qV51d03JPx6Crj0dpPuVuA-1; Tue, 19 May 2020 06:59:59 -0400
X-MC-Unique: qV51d03JPx6Crj0dpPuVuA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94758835B40;
        Tue, 19 May 2020 10:59:58 +0000 (UTC)
Received: from starship (unknown [10.35.207.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C66CB62A10;
        Tue, 19 May 2020 10:59:56 +0000 (UTC)
Message-ID: <adb8a844689f1569875b1e6574ce7db4962e611c.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: only do L1TF workaround on affected processors
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, stable@vger.kernel.org
Date:   Tue, 19 May 2020 13:59:55 +0300
In-Reply-To: <20200519095008.1212-1-pbonzini@redhat.com>
References: <20200519095008.1212-1-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-05-19 at 05:50 -0400, Paolo Bonzini wrote:
> KVM stores the gfn in MMIO SPTEs as a caching optimization.  These are split
> in two parts, as in "[high 11111 low]", to thwart any attempt to use these bits
> in an L1TF attack.  This works as long as there are 5 free bits between
> MAXPHYADDR and bit 50 (inclusive), leaving bit 51 free so that the MMIO
> access triggers a reserved-bit-set page fault.

Most of machines I used have MAXPHYADDR=39, however on larger server machines,
isn't MAXPHYADDR already something like 48, thus not allowing enought space for these bits?
This is the case for my machine as well.

In this case, if I understand correctly, the MAXPHYADDR value reported to the guest can
be reduced to accomodate for these bits, is that true?


> 
> The bit positions however were computed wrongly for AMD processors that have
> encryption support.  In this case, x86_phys_bits is reduced (for example
> from 48 to 43, to account for the C bit at position 47 and four bits used
> internally to store the SEV ASID and other stuff) while x86_cache_bits in
> would remain set to 48, and _all_ bits between the reduced MAXPHYADDR
> and bit 51 are set.  

If I understand correctly this is done by the host kernel. I haven't had memory encryption
enabled when I did these tests.


FYI, later on, I did some digging about SME and SEV on my machine (3970X), and found out that memory encryption (SME) does actually work,
except that it makes AMD's own amdgpu driver panic on boot and according to google this is a very well known issue.
This is why I always thought that it wasn't supported.

I tested this issue while SME is enabled with efifb and it seems that its state (enabled/disabled) doesn't affect this bug,
which suggest me that a buggy bios always reports that memory encrypiton is enabled in that msr, or something
like that. I haven't yet studied this area well enought to be sure.

SEV on the other hand is not active because the system doesn't seem to have PSP firmware loaded,
and only have CCP active (I added some printks to the ccp/psp driver and it shows that PSP reports 0 capability which indicates that it is not there)
It is reported as supported in CPUID (even SEV-ES).

I tested this patch and it works.

However note (not related to this patch) that running nested guest,
makes the L1 guest panic right in the very startup of the guest when npt=1.
I tested this with many guest/host combinations and even with fedora kernel 5.3 running
on both host and guest, this is the case.

Tested-by: Maxim Levitsky <mlevitsk@redhat.com>

Overall the patch makes sense to me, however I don't yet know this area well enought
for a review, but I think I'll dig into it today and once it all makes sense to me,
I'll review this patch as well.

Best regards,
	Maxim Levitsky

> Then low_phys_bits would also cover some of the
> bits that are set in the shadow_mmio_value, terribly confusing the gfn
> caching mechanism.
> 
> To fix this, avoid splitting gfns as long as the processor does not have
> the L1TF bug (which includes all AMD processors).  When there is no
> splitting, low_phys_bits can be set to the reduced MAXPHYADDR removing
> the overlap.  This fixes "npt=0" operation on EPYC processors.
> 
> Thanks to Maxim Levitsky for bisecting this bug.
> 
> Cc: stable@vger.kernel.org
> Fixes: 52918ed5fcf0 ("KVM: SVM: Override default MMIO mask if memory encryption is enabled")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 8071952e9cf2..86619631ff6a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -335,6 +335,8 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask, u64 mmio_value, u64 access_mask)
>  {
>  	BUG_ON((u64)(unsigned)access_mask != access_mask);
>  	BUG_ON((mmio_mask & mmio_value) != mmio_value);
> +	WARN_ON(mmio_value & (shadow_nonpresent_or_rsvd_mask << shadow_nonpresent_or_rsvd_mask_len));
> +	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
>  	shadow_mmio_value = mmio_value | SPTE_MMIO_MASK;
>  	shadow_mmio_mask = mmio_mask | SPTE_SPECIAL_MASK;
>  	shadow_mmio_access_mask = access_mask;
> @@ -583,16 +585,15 @@ static void kvm_mmu_reset_all_pte_masks(void)
>  	 * the most significant bits of legal physical address space.
>  	 */
>  	shadow_nonpresent_or_rsvd_mask = 0;
> -	low_phys_bits = boot_cpu_data.x86_cache_bits;
> -	if (boot_cpu_data.x86_cache_bits <
> -	    52 - shadow_nonpresent_or_rsvd_mask_len) {
> +	low_phys_bits = boot_cpu_data.x86_phys_bits;
> +	if (boot_cpu_has_bug(X86_BUG_L1TF) &&
> +	    !WARN_ON_ONCE(boot_cpu_data.x86_cache_bits >=
> +			  52 - shadow_nonpresent_or_rsvd_mask_len)) {
> +		low_phys_bits = boot_cpu_data.x86_cache_bits
> +			- shadow_nonpresent_or_rsvd_mask_len;
>  		shadow_nonpresent_or_rsvd_mask =
> -			rsvd_bits(boot_cpu_data.x86_cache_bits -
> -				  shadow_nonpresent_or_rsvd_mask_len,
> -				  boot_cpu_data.x86_cache_bits - 1);
> -		low_phys_bits -= shadow_nonpresent_or_rsvd_mask_len;
> -	} else
> -		WARN_ON_ONCE(boot_cpu_has_bug(X86_BUG_L1TF));
> +			rsvd_bits(low_phys_bits, boot_cpu_data.x86_cache_bits - 1);
> +	}
>  
>  	shadow_nonpresent_or_rsvd_lower_gfn_mask =
>  		GENMASK_ULL(low_phys_bits - 1, PAGE_SHIFT);


