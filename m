Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3AD18060E
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 19:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgCJSTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 14:19:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:49185 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgCJSTy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 14:19:54 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Mar 2020 11:19:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,537,1574150400"; 
   d="scan'208";a="236024744"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 10 Mar 2020 11:19:52 -0700
Date:   Tue, 10 Mar 2020 11:19:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 4.14 057/126] KVM: SVM: Override default MMIO mask if
 memory encryption is enabled
Message-ID: <20200310181952.GF9305@linux.intel.com>
References: <20200310124203.704193207@linuxfoundation.org>
 <20200310124207.819562318@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310124207.819562318@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Has this been tested on the stable kernels?  There's a recent bug report[*]
that suggests the 4.19 backport of this patch may be causing issues.

[*] https://bugzilla.kernel.org/show_bug.cgi?id=206795


On Tue, Mar 10, 2020 at 01:41:18PM +0100, Greg Kroah-Hartman wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> commit 52918ed5fcf05d97d257f4131e19479da18f5d16 upstream.
> 
> The KVM MMIO support uses bit 51 as the reserved bit to cause nested page
> faults when a guest performs MMIO. The AMD memory encryption support uses
> a CPUID function to define the encryption bit position. Given this, it is
> possible that these bits can conflict.
> 
> Use svm_hardware_setup() to override the MMIO mask if memory encryption
> support is enabled. Various checks are performed to ensure that the mask
> is properly defined and rsvd_bits() is used to generate the new mask (as
> was done prior to the change that necessitated this patch).
> 
> Fixes: 28a1f3ac1d0c ("kvm: x86: Set highest physical address bits in non-present/reserved SPTEs")
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  arch/x86/kvm/svm.c |   43 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
> 
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1088,6 +1088,47 @@ static int avic_ga_log_notifier(u32 ga_t
>  	return 0;
>  }
>  
> +/*
> + * The default MMIO mask is a single bit (excluding the present bit),
> + * which could conflict with the memory encryption bit. Check for
> + * memory encryption support and override the default MMIO mask if
> + * memory encryption is enabled.
> + */
> +static __init void svm_adjust_mmio_mask(void)
> +{
> +	unsigned int enc_bit, mask_bit;
> +	u64 msr, mask;
> +
> +	/* If there is no memory encryption support, use existing mask */
> +	if (cpuid_eax(0x80000000) < 0x8000001f)
> +		return;
> +
> +	/* If memory encryption is not enabled, use existing mask */
> +	rdmsrl(MSR_K8_SYSCFG, msr);
> +	if (!(msr & MSR_K8_SYSCFG_MEM_ENCRYPT))
> +		return;
> +
> +	enc_bit = cpuid_ebx(0x8000001f) & 0x3f;
> +	mask_bit = boot_cpu_data.x86_phys_bits;
> +
> +	/* Increment the mask bit if it is the same as the encryption bit */
> +	if (enc_bit == mask_bit)
> +		mask_bit++;
> +
> +	/*
> +	 * If the mask bit location is below 52, then some bits above the
> +	 * physical addressing limit will always be reserved, so use the
> +	 * rsvd_bits() function to generate the mask. This mask, along with
> +	 * the present bit, will be used to generate a page fault with
> +	 * PFER.RSV = 1.
> +	 *
> +	 * If the mask bit location is 52 (or above), then clear the mask.
> +	 */
> +	mask = (mask_bit < 52) ? rsvd_bits(mask_bit, 51) | PT_PRESENT_MASK : 0;
> +
> +	kvm_mmu_set_mmio_spte_mask(mask, PT_WRITABLE_MASK | PT_USER_MASK);
> +}
> +
>  static __init int svm_hardware_setup(void)
>  {
>  	int cpu;
> @@ -1123,6 +1164,8 @@ static __init int svm_hardware_setup(voi
>  		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
>  	}
>  
> +	svm_adjust_mmio_mask();
> +
>  	for_each_possible_cpu(cpu) {
>  		r = svm_cpu_init(cpu);
>  		if (r)
> 
> 
