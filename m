Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2421F112EE8
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 16:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbfLDPsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 10:48:07 -0500
Received: from mga12.intel.com ([192.55.52.136]:58121 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727878AbfLDPsH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 10:48:07 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Dec 2019 07:48:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,277,1571727600"; 
   d="scan'208";a="262988929"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Dec 2019 07:48:06 -0800
Date:   Wed, 4 Dec 2019 07:48:06 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        thomas.lendacky@amd.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: use CPUID to locate host page table
 reserved bits
Message-ID: <20191204154806.GC6323@linux.intel.com>
References: <1575474037-7903-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1575474037-7903-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 04, 2019 at 04:40:37PM +0100, Paolo Bonzini wrote:
> The comment in kvm_get_shadow_phys_bits refers to MKTME, but the same is actually
> true of SME and SEV.  Just use CPUID[0x8000_0008].EAX[7:0] unconditionally if
> available, it is simplest and works even if memory is not encrypted.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6f92b40d798c..1e4ee4f8de5f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -538,16 +538,20 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
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
> +	if (likely(boot_cpu_data.extended_cpuid_level >= 0x80000008))
> +		return cpuid_eax(0x80000008) & 0xff;
>  
> -	return cpuid_eax(0x80000008) & 0xff;
> +	/*
> +	 * Quite weird to have VMX or SVM but not MAXPHYADDR; probably a VM with
> +	 * custom CPUID.  Proceed with whatever the kernel found since these features
> +	 * aren't virtualizable (SME/SEV also require CPUIDs higher than 0x80000008).

No love for MKTME?  :-D

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

> +	 */
> +	return boot_cpu_data.x86_phys_bits;
>  }
>  
>  static void kvm_mmu_reset_all_pte_masks(void)
> -- 
> 1.8.3.1
> 
