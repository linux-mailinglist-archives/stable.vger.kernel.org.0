Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7710F9FE7
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 02:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfKMBKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:10:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbfKMBKy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:10:54 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B7BC21A49;
        Wed, 13 Nov 2019 01:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573607452;
        bh=UHojKoHJkSEXKX2pCIHTRX25I6EJIfI6hK+0Q8psVrY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DzoCk/LEjfy/7ut5nKnxEQq7QeB7s//h6mMkiYHXigi2Qe+mtvTPQlKD/xYiEjoA+
         kcbKq3J2tjphzECfvFU/8c6aBJN1YRBe4nTWHWPvXcTWAkFRfQdQmulqsmTMKeC7Ww
         KKujlcFDotf3FJEAXhmL4esuTG/xQ0GE8CzblrAg=
Date:   Tue, 12 Nov 2019 20:10:51 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.19 STABLE] KVM: x86: introduce is_pae_paging
Message-ID: <20191113011051.GJ8496@sasha-vm>
References: <20191111225423.29309-1-sean.j.christopherson@intel.com>
 <aecfcc9e-dcab-2b52-ebdb-373a416a4951@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aecfcc9e-dcab-2b52-ebdb-373a416a4951@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 12, 2019 at 12:05:44AM +0100, Paolo Bonzini wrote:
>On 11/11/19 23:54, Sean Christopherson wrote:
>> From: Paolo Bonzini <pbonzini@redhat.com>
>>
>> Upstream commit bf03d4f9334728bf7c8ffc7de787df48abd6340e.
>>
>> Checking for 32-bit PAE is quite common around code that fiddles with
>> the PDPTRs.  Add a function to compress all checks into a single
>> invocation.
>>
>> Moving to the common helper also fixes a subtle bug in kvm_set_cr3()
>> where it fails to check is_long_mode() and results in KVM incorrectly
>> attempting to load PDPTRs for a 64-bit guest.
>>
>> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> [sean: backport to 4.x; handle vmx.c split in 5.x, call out the bugfix]
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> ---
>>  arch/x86/kvm/vmx.c | 7 +++----
>>  arch/x86/kvm/x86.c | 8 ++++----
>>  arch/x86/kvm/x86.h | 5 +++++
>>  3 files changed, 12 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>> index 6f7b3acdab26..83acaed244ba 100644
>> --- a/arch/x86/kvm/vmx.c
>> +++ b/arch/x86/kvm/vmx.c
>> @@ -5181,7 +5181,7 @@ static void ept_load_pdptrs(struct kvm_vcpu *vcpu)
>>  		      (unsigned long *)&vcpu->arch.regs_dirty))
>>  		return;
>>
>> -	if (is_paging(vcpu) && is_pae(vcpu) && !is_long_mode(vcpu)) {
>> +	if (is_pae_paging(vcpu)) {
>>  		vmcs_write64(GUEST_PDPTR0, mmu->pdptrs[0]);
>>  		vmcs_write64(GUEST_PDPTR1, mmu->pdptrs[1]);
>>  		vmcs_write64(GUEST_PDPTR2, mmu->pdptrs[2]);
>> @@ -5193,7 +5193,7 @@ static void ept_save_pdptrs(struct kvm_vcpu *vcpu)
>>  {
>>  	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
>>
>> -	if (is_paging(vcpu) && is_pae(vcpu) && !is_long_mode(vcpu)) {
>> +	if (is_pae_paging(vcpu)) {
>>  		mmu->pdptrs[0] = vmcs_read64(GUEST_PDPTR0);
>>  		mmu->pdptrs[1] = vmcs_read64(GUEST_PDPTR1);
>>  		mmu->pdptrs[2] = vmcs_read64(GUEST_PDPTR2);
>> @@ -12021,8 +12021,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
>>  		 * If PAE paging and EPT are both on, CR3 is not used by the CPU and
>>  		 * must not be dereferenced.
>>  		 */
>> -		if (!is_long_mode(vcpu) && is_pae(vcpu) && is_paging(vcpu) &&
>> -		    !nested_ept) {
>> +		if (is_pae_paging(vcpu) && !nested_ept) {
>>  			if (!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3)) {
>>  				*entry_failure_code = ENTRY_FAIL_PDPTE;
>>  				return 1;
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 6ae8a013af31..b9b87fb75ac0 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -633,7 +633,7 @@ bool pdptrs_changed(struct kvm_vcpu *vcpu)
>>  	gfn_t gfn;
>>  	int r;
>>
>> -	if (is_long_mode(vcpu) || !is_pae(vcpu) || !is_paging(vcpu))
>> +	if (!is_pae_paging(vcpu))
>>  		return false;
>>
>>  	if (!test_bit(VCPU_EXREG_PDPTR,
>> @@ -884,8 +884,8 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>>  	if (is_long_mode(vcpu) &&
>>  	    (cr3 & rsvd_bits(cpuid_maxphyaddr(vcpu), 63)))
>>  		return 1;
>> -	else if (is_pae(vcpu) && is_paging(vcpu) &&
>> -		   !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
>> +	else if (is_pae_paging(vcpu) &&
>> +		 !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
>>  		return 1;
>>
>>  	kvm_mmu_new_cr3(vcpu, cr3, skip_tlb_flush);
>> @@ -8312,7 +8312,7 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
>>  		kvm_update_cpuid(vcpu);
>>
>>  	idx = srcu_read_lock(&vcpu->kvm->srcu);
>> -	if (!is_long_mode(vcpu) && is_pae(vcpu) && is_paging(vcpu)) {
>> +	if (is_pae_paging(vcpu)) {
>>  		load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu));
>>  		mmu_reset_needed = 1;
>>  	}
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index 3a91ea760f07..608e5f8c5d0a 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -139,6 +139,11 @@ static inline int is_paging(struct kvm_vcpu *vcpu)
>>  	return likely(kvm_read_cr0_bits(vcpu, X86_CR0_PG));
>>  }
>>
>> +static inline bool is_pae_paging(struct kvm_vcpu *vcpu)
>> +{
>> +	return !is_long_mode(vcpu) && is_pae(vcpu) && is_paging(vcpu);
>> +}
>> +
>>  static inline u32 bit(int bitno)
>>  {
>>  	return 1 << (bitno & 31);
>>
>
>Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Queued up for 4.19, thank you.

-- 
Thanks,
Sasha
