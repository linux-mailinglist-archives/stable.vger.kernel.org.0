Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E90F6112E6C
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 16:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbfLDP3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 10:29:44 -0500
Received: from mga05.intel.com ([192.55.52.43]:33320 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728281AbfLDP3n (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 10:29:43 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Dec 2019 07:29:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,277,1571727600"; 
   d="scan'208";a="201434986"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 04 Dec 2019 07:29:43 -0800
Date:   Wed, 4 Dec 2019 07:29:42 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: use CPUID to locate host page table reserved
 bits
Message-ID: <20191204152942.GB6323@linux.intel.com>
References: <1575471060-55790-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1575471060-55790-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 04, 2019 at 03:51:00PM +0100, Paolo Bonzini wrote:
> The comment in kvm_get_shadow_phys_bits refers to MKTME, but the same is actually
> true of SME and SEV.  Just use CPUID[0x8000_0008].EAX[7:0] unconditionally, it is
> simplest and works even if memory is not encrypted.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6f92b40d798c..8b8edfbdbaef 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -538,15 +538,11 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
>  static u8 kvm_get_shadow_phys_bits(void)
>  {
>  	/*
> -	 * boot_cpu_data.x86_phys_bits is reduced when MKTME is detected
> -	 * in CPU detection code, but MKTME treats those reduced bits as
> -	 * 'keyID' thus they are not reserved bits. Therefore for MKTME
> -	 * we should still return physical address bits reported by CPUID.
> +	 * boot_cpu_data.x86_phys_bits is reduced when MKTME or SME are detected
> +	 * in CPU detection code, but the processor treats those reduced bits as
> +	 * 'keyID' thus they are not reserved bits. Therefore KVM needs to look at
> +	 * the physical address bits reported by CPUID.
>  	 */
> -	if (!boot_cpu_has(X86_FEATURE_TME) ||
> -	    WARN_ON_ONCE(boot_cpu_data.extended_cpuid_level < 0x80000008))
> -		return boot_cpu_data.x86_phys_bits;

Removing this entirely will break CPUs that don't support leaf 0x80000008.
From a VMX perspective, I'm pretty sure all Intel hardware that supports
VMX is guaranteed to support 0x80000008, but I've no idea about SVM or any
non-Intel CPU, and not supporting 0x80000008 in a virtual machine is
technically legal/possible.  We conditioned doing CPUID on TME because TME
would be reported as supported iff 0x80000008 existed.

The extra bit of paranoia doesn't cost much, so play it safe?  E.g.:

	if (unlikely(boot_cpu_data.extended_cpuid_level < 0x80000008)) {
		WARN_ON_ONCE(boot_cpu_has(X86_FEATURE_TME) || SME?);
		return boot_cpu_data.x86_phys_bits;
	}

	return cpuid_eax(0x80000008) & 0xff;

> -
>  	return cpuid_eax(0x80000008) & 0xff;
>  }
>  
> -- 
> 1.8.3.1
> 
