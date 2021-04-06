Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7C0355F22
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 00:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbhDFW5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 18:57:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232387AbhDFW5q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Apr 2021 18:57:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 803AE613C4;
        Tue,  6 Apr 2021 22:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617749857;
        bh=SjJ5d6JSir3KtpES8w++YjnVbbqUThDjMgW4tKHIKgg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a/EfwR4pLFY4ty7GxIJAP6Xc/+SqnDPRqB/ShDHBkCUPXpr7+f1/kuxLV0ystssbY
         YpyR5o3Ta7UXZy04/CD6TkoVqBh9etqvoOLe7wTCCwtRx4v52E1kpirVw9Nq04h62O
         e3fiwdxamxsPU/MnNnZl6hexTi7iQNJbV+dqYRlnZCmnakfBVU/puSIUEvXTWlFSVl
         KVYX7txqmlpHGFZ7S5jRvWBg6Cb3MjnsDqKEp6znYlfKhfNs9gWjZ7g4zly2hwBHGX
         t2ROgQ+lL8fL8urcKBMSvOJczhVX1NWhf8sKv/ff+1FjQaY7MSNnJn03CZ0W0Xdsnf
         pbYbJInE9xYLQ==
Date:   Tue, 6 Apr 2021 18:57:36 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 5.10 096/126] KVM: x86/mmu: Use atomic ops to set SPTEs
 in TDP MMU map
Message-ID: <YGznYJ/eW+IySlgw@sashalap>
References: <20210405085031.040238881@linuxfoundation.org>
 <20210405085034.229578703@linuxfoundation.org>
 <98478382-23f8-57af-dc17-23c7d9899b9a@redhat.com>
 <YGxm+WISdIqfwqXD@sashalap>
 <fd2030f3-55ba-6088-733b-ac6a551e2170@redhat.com>
 <YGyiDC2iP4CmWgUJ@sashalap>
 <81059969-e146-6ed3-01b6-341cbcf1b3ae@redhat.com>
 <YGy6EVb+JeNu7EOs@sashalap>
 <b2b05936-f545-9272-714b-845d54fa78eb@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="XC4kXOdy3KNRTgVj"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b2b05936-f545-9272-714b-845d54fa78eb@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--XC4kXOdy3KNRTgVj
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Apr 06, 2021 at 10:43:52PM +0200, Paolo Bonzini wrote:
>On 06/04/21 21:44, Sasha Levin wrote:
>>On Tue, Apr 06, 2021 at 08:28:27PM +0200, Paolo Bonzini wrote:
>>>If a patch doesn't (more or less trivially) apply, the maintainer 
>>>should take action.  Distro maintainers can also jump in and post 
>>>the backport to subsystem mailing lists.  If the stable kernel 
>>>loses a patch because a maintainer doesn't have the time to do a 
>>>backport, it's not the end of the world.
>>
>>This quickly went from a "world class" to "fuck it".
>
>Known bugs are better than unknown bugs.  If something is reported on 
>4.19 and the stable@ backports were only done up to 5.4 because the 
>backport was a bit more messy, it's okay.  If a user comes up with a 
>weird bug that I've never seen and that it's caused by a botched 
>backport, it's much worse.
>
>In this specific case we're talking of 5.10; but in many cases users 
>of really old kernels, let's say 4.4-4.9 at this point, won't care 
>about having *all* bugfixes.  Some newer (and thus more buggy) 
>features may be so distant from the mainline in those kernels, or so 
>immature, that no one will consider them while staying on such an old 
>kernel.
>
>Again, kernel necrophilia pays my bills, so I have some experience there. :)

I'm with you on older kernels: if it's too complex users should just be
upgrading.

>>It's understandable that maintainers don't have all the time in the
>>world for this, but are you really asking not to backport fixes to
>>stable trees because you don't have the time for it and don't want
>>anyone else to do it instead?
>
>If a bug is serious I *will* do the backport; I literally did this 
>specific backport on the first working day after the failure report. 
>But not all bugs are created equal and neither are all stable@-worthy 
>bugs.  I try to use the "Fixes" tag correctly, but sometimes a bug 
>that *technically* is 10-years-old may not be worthwhile or even 
>possible to fix even in 5.4.

Agree here too: I'm not advocating to go overboard on backporting stuff
to really old kernels, but I do think it would be great to have most
fixes (even ones not necessarily tagged for stable) on recent kernels
that users should actually be using, and this is where my suggesting to
let more folks deal with the less important stuff comes from.

>That said... one thing that would be really, really awesome would be a 
>website where you navigate a Linux checkout and for each directory you 
>can choose to get a list of stable patches that were Cc-ed to stable@ 
>and failed to apply.  A pipedream maybe, but also a great internship 
>project. :)

I have scripts that do this audit, but sadly my web design skills are
not good enough to make it look pretty :)

I've attached a list for virt/kvm/ and arch/x86/kvm/ on all supported
LTS kernel as an example.

-- 
Thanks,
Sasha

--XC4kXOdy3KNRTgVj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="kvm_missing.txt"

5.11:
3c346c0c60ab ("KVM: SVM: ensure that EFER.SVME is set when running nested guest or on nested vmexit")
a58d9166a756 ("KVM: SVM: load control fields from VMCB12 before checking them")
048f49809c52 ("KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping")
f156abec725f ("KVM: x86: Set so called 'reserved CR3 bits in LM mask' at vCPU reset")
5.10:
3c346c0c60ab ("KVM: SVM: ensure that EFER.SVME is set when running nested guest or on nested vmexit")
a58d9166a756 ("KVM: SVM: load control fields from VMCB12 before checking them")
048f49809c52 ("KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping")
44ac5958a6c1 ("KVM: x86/mmu: Set SPTE_AD_WRPROT_ONLY_MASK if and only if PML is enabled")
4ae7dc97f726 ("entry/kvm: Explicitly flush pending rcuog wakeup before last rescheduling point")
5.4:
44ac5958a6c1 ("KVM: x86/mmu: Set SPTE_AD_WRPROT_ONLY_MASK if and only if PML is enabled")
4ae7dc97f726 ("entry/kvm: Explicitly flush pending rcuog wakeup before last rescheduling point")
7131636e7ea5 ("KVM: x86: Allow guests to see MSR_IA32_TSX_CTRL even if tsx=off")
9d4747d02376 ("KVM: SVM: Remove the call to sev_platform_status() during setup")
6e1d849fa329 ("KVM: x86: Intercept LA57 to inject #GP fault when it's reserved")
2ba4493a8b19 ("KVM: nVMX: Explicitly check for valid guest state for !unrestricted guest")
25bb2cf97139 ("KVM: nVMX: Morph notification vector IRQ on nested VM-Enter to pending PI")
830f01b089b1 ("KVM: SVM: Fix disable pause loop exit/pause filtering capability on SVM")
0abcc8f65cc2 ("KVM: VMX: enable X86_FEATURE_WAITPKG in KVM capabilities")
005ba37cb89b ("mm: thp: KVM: Explicitly check for THP when populating secondary MMU")
c926f2f7230b ("KVM: x86: Protect exit_reason from being used in Spectre-v1/L1TF attacks")
4.19:
4ae7dc97f726 ("entry/kvm: Explicitly flush pending rcuog wakeup before last rescheduling point")
a9545779ee9e ("KVM: Use kvm_pfn_t for local PFN variable in hva_to_pfn_remapped()")
bd2fae8da794 ("KVM: do not assume PTE is writable after follow_pfn")
7131636e7ea5 ("KVM: x86: Allow guests to see MSR_IA32_TSX_CTRL even if tsx=off")
e61ab2a320c3 ("KVM: x86/pmu: Fix UBSAN shift-out-of-bounds warning in intel_pmu_refresh()")
139bc8a6146d ("KVM: Forbid the use of tagged userspace addresses for memslots")
9d4747d02376 ("KVM: SVM: Remove the call to sev_platform_status() during setup")
6e1d849fa329 ("KVM: x86: Intercept LA57 to inject #GP fault when it's reserved")
2ba4493a8b19 ("KVM: nVMX: Explicitly check for valid guest state for !unrestricted guest")
fc387d8daf39 ("KVM: nVMX: Reset the segment cache when stuffing guest segs")
25bb2cf97139 ("KVM: nVMX: Morph notification vector IRQ on nested VM-Enter to pending PI")
830f01b089b1 ("KVM: SVM: Fix disable pause loop exit/pause filtering capability on SVM")
384dea1c9183 ("KVM: x86: respect singlestep when emulating instruction")
5c911beff20a ("KVM: nVMX: Skip IBPB when switching between vmcs01 and vmcs02")
37486135d3a7 ("KVM: x86: Fix pkru save/restore when guest CR4.PKE=0, move it to x86.c")
95fa10103dab ("KVM: nVMX: avoid NULL pointer dereference with incorrect EVMCS GPAs")
a4443267800a ("KVM: nVMX: clear PIN_BASED_POSTED_INTR from nested pinbased_ctls only when apicv is globally disabled")
005ba37cb89b ("mm: thp: KVM: Explicitly check for THP when populating secondary MMU")
7adacf5eb2d2 ("KVM: x86: use CPUID to locate host page table reserved bits")
6d674e28f642 ("KVM: arm/arm64: Properly handle faulting of device mappings")
24885d1d79e2 ("KVM: x86: Remove a spurious export of a static function")
7a5ee6edb42e ("KVM: X86: Fix initialization of MSR lists")
04f11ef45810 ("KVM: nVMX: Always write vmcs02.GUEST_CR3 during nested VM-Enter")
fdcf75621375 ("KVM: x86: Disable posted interrupts for non-standard IRQs delivery modes")
92da008fa210 ("Revert "KVM/MMU: Flush tlb directly in the kvm_zap_gfn_range()"")
de3ccd26fafc ("KVM: MMU: record maximum physical address width in kvm_mmu_extended_role")
4.14:
4ae7dc97f726 ("entry/kvm: Explicitly flush pending rcuog wakeup before last rescheduling point")
a9545779ee9e ("KVM: Use kvm_pfn_t for local PFN variable in hva_to_pfn_remapped()")
bd2fae8da794 ("KVM: do not assume PTE is writable after follow_pfn")
ccd85d90ce09 ("KVM: SVM: Treat SVM as unsupported when running as an SEV guest")
7131636e7ea5 ("KVM: x86: Allow guests to see MSR_IA32_TSX_CTRL even if tsx=off")
e61ab2a320c3 ("KVM: x86/pmu: Fix UBSAN shift-out-of-bounds warning in intel_pmu_refresh()")
139bc8a6146d ("KVM: Forbid the use of tagged userspace addresses for memslots")
9d4747d02376 ("KVM: SVM: Remove the call to sev_platform_status() during setup")
39485ed95d6b ("KVM: x86: reinstate vendor-agnostic check on SPEC_CTRL cpuid bits")
71cc849b7093 ("KVM: x86: Fix split-irqchip vs interrupt injection window request")
72c3bcdcda49 ("KVM: x86: handle !lapic_in_kernel case in kvm_cpu_*_extint")
6e1d849fa329 ("KVM: x86: Intercept LA57 to inject #GP fault when it's reserved")
fc387d8daf39 ("KVM: nVMX: Reset the segment cache when stuffing guest segs")
25bb2cf97139 ("KVM: nVMX: Morph notification vector IRQ on nested VM-Enter to pending PI")
fdfe7cbd5880 ("KVM: Pass MMU notifier range flags to kvm_unmap_hva_range()")
384dea1c9183 ("KVM: x86: respect singlestep when emulating instruction")
e649b3f0188f ("KVM: x86: Fix APIC page invalidation race")
5c911beff20a ("KVM: nVMX: Skip IBPB when switching between vmcs01 and vmcs02")
37486135d3a7 ("KVM: x86: Fix pkru save/restore when guest CR4.PKE=0, move it to x86.c")
0225fd5e0a6a ("KVM: arm64: Fix 32bit PC wrap-around")
95fa10103dab ("KVM: nVMX: avoid NULL pointer dereference with incorrect EVMCS GPAs")
a4443267800a ("KVM: nVMX: clear PIN_BASED_POSTED_INTR from nested pinbased_ctls only when apicv is globally disabled")
f6ab0107a494 ("KVM: x86/mmu: Fix struct guest_walker arrays for 5-level paging")
a6bd811f1209 ("x86/KVM: Clean up host's steal time structure")
b043138246a4 ("x86/KVM: Make sure KVM_VCPU_FLUSH_TLB flag is not missed")
917248144db5 ("x86/kvm: Cache gfn to pfn translation")
1eff70a9abd4 ("x86/kvm: Introduce kvm_(un)map_gfn()")
005ba37cb89b ("mm: thp: KVM: Explicitly check for THP when populating secondary MMU")
b11306b53b25 ("KVM: x86: Don't let userspace set host-reserved cr4 bits")
1cfbb484de15 ("KVM: arm/arm64: Correct AArch32 SPSR on exception entry")
3c2483f15499 ("KVM: arm/arm64: Correct CPSR on exception entry")
736c291c9f36 ("KVM: x86: Use gpa_t for cr2/gpa to fix TDP support on 32-bit KVM")
7adacf5eb2d2 ("KVM: x86: use CPUID to locate host page table reserved bits")
6d674e28f642 ("KVM: arm/arm64: Properly handle faulting of device mappings")
24885d1d79e2 ("KVM: x86: Remove a spurious export of a static function")
7a5ee6edb42e ("KVM: X86: Fix initialization of MSR lists")
04f11ef45810 ("KVM: nVMX: Always write vmcs02.GUEST_CR3 during nested VM-Enter")
567926cca99b ("KVM: nVMX: Fix consistency check on injected exception error code")
3ca94192278c ("KVM: X86: Fix userspace set invalid CR4")
fdcf75621375 ("KVM: x86: Disable posted interrupts for non-standard IRQs delivery modes")
4d763b168e9c ("KVM: VMX: check CPUID before allowing read/write of IA32_XSS")
d28f4290b53a ("KVM: VMX: Always signal #GP on WRMSR to MSR_IA32_CR_PAT with bad value")
beb8d93b3e42 ("KVM: VMX: Fix handling of #MC that occurs during VM-Entry")
654f1f13ea56 ("kvm: Check irqchip mode before assign irqfd")
b68f3cc7d978 ("KVM: x86: Always use 32-bit SMRAM save state for 32-bit kernels")
1811d979c716 ("x86/kvm: move kvm_load/put_guest_xcr0 into atomic context")
bc8a3d8925a8 ("kvm: mmu: Fix overflow on kvm mmu page limit calculation")
ede885ecb2cd ("kvm: svm: fix potential get_num_contig_pages overflow")
92da008fa210 ("Revert "KVM/MMU: Flush tlb directly in the kvm_zap_gfn_range()"")
de3ccd26fafc ("KVM: MMU: record maximum physical address width in kvm_mmu_extended_role")
511da98d207d ("kvm: x86: Return LA57 feature based on hardware capability")
6b1971c69497 ("x86/kvm/nVMX: read from MSR_IA32_VMX_PROCBASED_CTLS2 only when it is available")
0e0ab73c9a02 ("KVM: VMX: Zero out *all* general purpose registers after VM-Exit")
61c08aa9606d ("KVM: VMX: Compare only a single byte for VMCS' "launched" in vCPU-run")
dcbd3e49c2f0 ("KVM: X86: Fix NULL deref in vcpu_scan_ioapic")
bea2ef803ade ("KVM: arm/arm64: vgic: Cap SPIs to the VM-defined maximum")
2e2f6c3c0b08 ("KVM: arm/arm64: vgic: Do not cond_resched_lock() with IRQs disabled")
60c3ab30d8c2 ("KVM: arm/arm64: vgic-v2: Set active_source to 0 when restoring state")
a7c42bb6da6b ("x86/kvm/lapic: preserve gfn_to_hva_cache len on cache reinit")
2cf7ea9f40fa ("KVM: VMX: hide flexpriority from guest when disabled at the module level")
6c3dfeb6a48b ("KVM: x86: Do not re-{try,execute} after failed emulation in L2")
472faffacd90 ("KVM: x86: Default to not allowing emulation retry in kvm_mmu_page_fault")
384bf2218e96 ("KVM: x86: Merge EMULTYPE_RETRY and EMULTYPE_ALLOW_REEXECUTE")
8065dbd1ee0e ("KVM: x86: Invert emulation re-execute behavior to make it opt-in")
d806afa495e2 ("x86/kvm/vmx: Fix coding style in vmx_setup_l1d_flush()")
44883f01fe6a ("KVM: x86: ensure all MSRs can always be KVM_GET/SET_MSR'd")
3140c156e919 ("kvm: x86: fix a compile warning")
d60d8b64280c ("KVM: arm/arm64: Fix arch timers with userspace irqchips")
4.9:
4ae7dc97f726 ("entry/kvm: Explicitly flush pending rcuog wakeup before last rescheduling point")
a9545779ee9e ("KVM: Use kvm_pfn_t for local PFN variable in hva_to_pfn_remapped()")
bd2fae8da794 ("KVM: do not assume PTE is writable after follow_pfn")
ccd85d90ce09 ("KVM: SVM: Treat SVM as unsupported when running as an SEV guest")
7131636e7ea5 ("KVM: x86: Allow guests to see MSR_IA32_TSX_CTRL even if tsx=off")
e61ab2a320c3 ("KVM: x86/pmu: Fix UBSAN shift-out-of-bounds warning in intel_pmu_refresh()")
139bc8a6146d ("KVM: Forbid the use of tagged userspace addresses for memslots")
9d4747d02376 ("KVM: SVM: Remove the call to sev_platform_status() during setup")
39485ed95d6b ("KVM: x86: reinstate vendor-agnostic check on SPEC_CTRL cpuid bits")
71cc849b7093 ("KVM: x86: Fix split-irqchip vs interrupt injection window request")
72c3bcdcda49 ("KVM: x86: handle !lapic_in_kernel case in kvm_cpu_*_extint")
25bb2cf97139 ("KVM: nVMX: Morph notification vector IRQ on nested VM-Enter to pending PI")
fdfe7cbd5880 ("KVM: Pass MMU notifier range flags to kvm_unmap_hva_range()")
7c83d096aed0 ("KVM: x86: Mark CR4.TSD as being possibly owned by the guest")
384dea1c9183 ("KVM: x86: respect singlestep when emulating instruction")
e649b3f0188f ("KVM: x86: Fix APIC page invalidation race")
a3535be731c2 ("KVM: nSVM: fix condition for filtering async PF")
5c911beff20a ("KVM: nVMX: Skip IBPB when switching between vmcs01 and vmcs02")
37486135d3a7 ("KVM: x86: Fix pkru save/restore when guest CR4.PKE=0, move it to x86.c")
0225fd5e0a6a ("KVM: arm64: Fix 32bit PC wrap-around")
95fa10103dab ("KVM: nVMX: avoid NULL pointer dereference with incorrect EVMCS GPAs")
86f7e90ce840 ("KVM: VMX: check descriptor table exits on instruction emulation")
a4443267800a ("KVM: nVMX: clear PIN_BASED_POSTED_INTR from nested pinbased_ctls only when apicv is globally disabled")
91a5f413af59 ("KVM: nVMX: handle nested posted interrupts when apicv is disabled for L1")
a6bd811f1209 ("x86/KVM: Clean up host's steal time structure")
b043138246a4 ("x86/KVM: Make sure KVM_VCPU_FLUSH_TLB flag is not missed")
917248144db5 ("x86/kvm: Cache gfn to pfn translation")
1eff70a9abd4 ("x86/kvm: Introduce kvm_(un)map_gfn()")
8c6de56a42e0 ("x86/kvm: Be careful not to clear KVM_VCPU_FLUSH_TLB bit")
42cde48b2d39 ("KVM: Play nice with read-only memslots when querying host page size")
f9b84e19221e ("KVM: Use vcpu-specific gva->hva translation when querying host page size")
005ba37cb89b ("mm: thp: KVM: Explicitly check for THP when populating secondary MMU")
14e32321f360 ("KVM: x86: Refactor picdev_write() to prevent Spectre-v1/L1TF attacks")
b11306b53b25 ("KVM: x86: Don't let userspace set host-reserved cr4 bits")
1cfbb484de15 ("KVM: arm/arm64: Correct AArch32 SPSR on exception entry")
3c2483f15499 ("KVM: arm/arm64: Correct CPSR on exception entry")
b6ae256afd32 ("KVM: arm64: Only sign-extend MMIO up to register width")
736c291c9f36 ("KVM: x86: Use gpa_t for cr2/gpa to fix TDP support on 32-bit KVM")
7adacf5eb2d2 ("KVM: x86: use CPUID to locate host page table reserved bits")
6d674e28f642 ("KVM: arm/arm64: Properly handle faulting of device mappings")
24885d1d79e2 ("KVM: x86: Remove a spurious export of a static function")
7a5ee6edb42e ("KVM: X86: Fix initialization of MSR lists")
04f11ef45810 ("KVM: nVMX: Always write vmcs02.GUEST_CR3 during nested VM-Enter")
567926cca99b ("KVM: nVMX: Fix consistency check on injected exception error code")
3ca94192278c ("KVM: X86: Fix userspace set invalid CR4")
fdcf75621375 ("KVM: x86: Disable posted interrupts for non-standard IRQs delivery modes")
17e433b54393 ("KVM: Fix leak vCPU's VMCS value into other pCPU")
88dddc11a8d6 ("KVM: nVMX: do not use dangling shadow VMCS after guest reset")
4d763b168e9c ("KVM: VMX: check CPUID before allowing read/write of IA32_XSS")
d28f4290b53a ("KVM: VMX: Always signal #GP on WRMSR to MSR_IA32_CR_PAT with bad value")
a86cb413f4bf ("KVM: s390: Do not report unusabled IDs via KVM_CAP_MAX_VCPU_ID")
654f1f13ea56 ("kvm: Check irqchip mode before assign irqfd")
b68f3cc7d978 ("KVM: x86: Always use 32-bit SMRAM save state for 32-bit kernels")
1811d979c716 ("x86/kvm: move kvm_load/put_guest_xcr0 into atomic context")
99c221796a81 ("KVM: x86: svm: make sure NMI is injected after nmi_singlestep")
bc8a3d8925a8 ("kvm: mmu: Fix overflow on kvm mmu page limit calculation")
ede885ecb2cd ("kvm: svm: fix potential get_num_contig_pages overflow")
92da008fa210 ("Revert "KVM/MMU: Flush tlb directly in the kvm_zap_gfn_range()"")
de3ccd26fafc ("KVM: MMU: record maximum physical address width in kvm_mmu_extended_role")
511da98d207d ("kvm: x86: Return LA57 feature based on hardware capability")
ddfd1730fd82 ("KVM: x86/mmu: Do not cache MMIO accesses while memslots are in flux")
152482580a1b ("KVM: Call kvm_arch_memslots_updated() before updating memslots")
8570f9e881e3 ("KVM: nVMX: Apply addr size mask to effective address for VMX instructions")
6b1971c69497 ("x86/kvm/nVMX: read from MSR_IA32_VMX_PROCBASED_CTLS2 only when it is available")
0e0ab73c9a02 ("KVM: VMX: Zero out *all* general purpose registers after VM-Exit")
61c08aa9606d ("KVM: VMX: Compare only a single byte for VMCS' "launched" in vCPU-run")
b284909abad4 ("cpu/hotplug: Fix "SMT disabled by BIOS" detection for KVM")
107352a24900 ("arm/arm64: KVM: vgic: Force VM halt when changing the active state of GICv3 PPIs/SGIs")
0e1b869fff60 ("kvm: x86: Add AMD's EX_CFG to the list of ignored MSRs")
dcbd3e49c2f0 ("KVM: X86: Fix NULL deref in vcpu_scan_ioapic")
bea2ef803ade ("KVM: arm/arm64: vgic: Cap SPIs to the VM-defined maximum")
2e2f6c3c0b08 ("KVM: arm/arm64: vgic: Do not cond_resched_lock() with IRQs disabled")
60c3ab30d8c2 ("KVM: arm/arm64: vgic-v2: Set active_source to 0 when restoring state")
1b3ab5ad1b8a ("KVM: nVMX: Free the VMREAD/VMWRITE bitmaps if alloc_kvm_area() fails")
a7c42bb6da6b ("x86/kvm/lapic: preserve gfn_to_hva_cache len on cache reinit")
6c3dfeb6a48b ("KVM: x86: Do not re-{try,execute} after failed emulation in L2")
472faffacd90 ("KVM: x86: Default to not allowing emulation retry in kvm_mmu_page_fault")
384bf2218e96 ("KVM: x86: Merge EMULTYPE_RETRY and EMULTYPE_ALLOW_REEXECUTE")
8065dbd1ee0e ("KVM: x86: Invert emulation re-execute behavior to make it opt-in")
d806afa495e2 ("x86/kvm/vmx: Fix coding style in vmx_setup_l1d_flush()")
44883f01fe6a ("KVM: x86: ensure all MSRs can always be KVM_GET/SET_MSR'd")
ecf08dad723d ("KVM: x86: remove APIC Timer periodic/oneshot spikes")
f0cf47d939d0 ("KVM: arm/arm64: Close VMID generation race")
3140c156e919 ("kvm: x86: fix a compile warning")
27e91ad1e746 ("kvm: arm/arm64: vgic-v3: Tighten synchronization for guests using v2 on v3")
16ca6a607d84 ("KVM: arm/arm64: vgic: Don't populate multiple LRs with the same vintid")
76600428c367 ("KVM: arm/arm64: Reduce verbosity of KVM init log")
95e057e25892 ("KVM: X86: Fix SMRAM accessing even if VM is shutdown")
7839c672e58b ("KVM: arm/arm64: Fix HYP unmapping going off limits")
f775b13eedee ("x86,kvm: move qemu/guest FPU switching out to vcpu_run")
8c1a8a32438b ("KVM: arm64: its: Fix missing dynamic allocation check in scan_its_table")
a2b7861bb33b ("kvm/x86: Avoid async PF preempting the kernel incorrectly")
38cfd5e3df9c ("KVM, pkeys: do not use PKRU value in vcpu->arch.guest_fpu.state")
b9dd21e104bc ("KVM: x86: simplify handling of PKRU")
e323369b2e20 ("kvm-vfio: Decouple only when we match a group")
0c428a6a9256 ("kvm: arm/arm64: Fix use after free of stage2 page table")
63cb6d5f004c ("KVM: nVMX: Fix nested VPID vmx exec control")
4.4:
4ae7dc97f726 ("entry/kvm: Explicitly flush pending rcuog wakeup before last rescheduling point")
bd2fae8da794 ("KVM: do not assume PTE is writable after follow_pfn")
ccd85d90ce09 ("KVM: SVM: Treat SVM as unsupported when running as an SEV guest")
7131636e7ea5 ("KVM: x86: Allow guests to see MSR_IA32_TSX_CTRL even if tsx=off")
1f7becf1b7e2 ("KVM: x86: get smi pending status correctly")
e61ab2a320c3 ("KVM: x86/pmu: Fix UBSAN shift-out-of-bounds warning in intel_pmu_refresh()")
139bc8a6146d ("KVM: Forbid the use of tagged userspace addresses for memslots")
9d4747d02376 ("KVM: SVM: Remove the call to sev_platform_status() during setup")
39485ed95d6b ("KVM: x86: reinstate vendor-agnostic check on SPEC_CTRL cpuid bits")
71cc849b7093 ("KVM: x86: Fix split-irqchip vs interrupt injection window request")
72c3bcdcda49 ("KVM: x86: handle !lapic_in_kernel case in kvm_cpu_*_extint")
25bb2cf97139 ("KVM: nVMX: Morph notification vector IRQ on nested VM-Enter to pending PI")
fdfe7cbd5880 ("KVM: Pass MMU notifier range flags to kvm_unmap_hva_range()")
7c83d096aed0 ("KVM: x86: Mark CR4.TSD as being possibly owned by the guest")
384dea1c9183 ("KVM: x86: respect singlestep when emulating instruction")
a3535be731c2 ("KVM: nSVM: fix condition for filtering async PF")
5c911beff20a ("KVM: nVMX: Skip IBPB when switching between vmcs01 and vmcs02")
37486135d3a7 ("KVM: x86: Fix pkru save/restore when guest CR4.PKE=0, move it to x86.c")
0225fd5e0a6a ("KVM: arm64: Fix 32bit PC wrap-around")
31603d4fc2bb ("KVM: VMX: Always VMCLEAR in-use VMCSes during crash with kexec support")
95fa10103dab ("KVM: nVMX: avoid NULL pointer dereference with incorrect EVMCS GPAs")
86f7e90ce840 ("KVM: VMX: check descriptor table exits on instruction emulation")
a4443267800a ("KVM: nVMX: clear PIN_BASED_POSTED_INTR from nested pinbased_ctls only when apicv is globally disabled")
91a5f413af59 ("KVM: nVMX: handle nested posted interrupts when apicv is disabled for L1")
a6bd811f1209 ("x86/KVM: Clean up host's steal time structure")
b043138246a4 ("x86/KVM: Make sure KVM_VCPU_FLUSH_TLB flag is not missed")
917248144db5 ("x86/kvm: Cache gfn to pfn translation")
1eff70a9abd4 ("x86/kvm: Introduce kvm_(un)map_gfn()")
8c6de56a42e0 ("x86/kvm: Be careful not to clear KVM_VCPU_FLUSH_TLB bit")
42cde48b2d39 ("KVM: Play nice with read-only memslots when querying host page size")
f9b84e19221e ("KVM: Use vcpu-specific gva->hva translation when querying host page size")
005ba37cb89b ("mm: thp: KVM: Explicitly check for THP when populating secondary MMU")
b11306b53b25 ("KVM: x86: Don't let userspace set host-reserved cr4 bits")
1cfbb484de15 ("KVM: arm/arm64: Correct AArch32 SPSR on exception entry")
3c2483f15499 ("KVM: arm/arm64: Correct CPSR on exception entry")
b6ae256afd32 ("KVM: arm64: Only sign-extend MMIO up to register width")
736c291c9f36 ("KVM: x86: Use gpa_t for cr2/gpa to fix TDP support on 32-bit KVM")
7adacf5eb2d2 ("KVM: x86: use CPUID to locate host page table reserved bits")
6d674e28f642 ("KVM: arm/arm64: Properly handle faulting of device mappings")
24885d1d79e2 ("KVM: x86: Remove a spurious export of a static function")
7a5ee6edb42e ("KVM: X86: Fix initialization of MSR lists")
9167ab799362 ("KVM: vmx, svm: always run with EFER.NXE=1 when shadow paging is active")
04f11ef45810 ("KVM: nVMX: Always write vmcs02.GUEST_CR3 during nested VM-Enter")
567926cca99b ("KVM: nVMX: Fix consistency check on injected exception error code")
3ca94192278c ("KVM: X86: Fix userspace set invalid CR4")
fdcf75621375 ("KVM: x86: Disable posted interrupts for non-standard IRQs delivery modes")
17e433b54393 ("KVM: Fix leak vCPU's VMCS value into other pCPU")
88dddc11a8d6 ("KVM: nVMX: do not use dangling shadow VMCS after guest reset")
bb34e690e934 ("KVM: LAPIC: Fix pending interrupt in IRR blocked by software disable LAPIC")
4d763b168e9c ("KVM: VMX: check CPUID before allowing read/write of IA32_XSS")
d28f4290b53a ("KVM: VMX: Always signal #GP on WRMSR to MSR_IA32_CR_PAT with bad value")
a86cb413f4bf ("KVM: s390: Do not report unusabled IDs via KVM_CAP_MAX_VCPU_ID")
654f1f13ea56 ("kvm: Check irqchip mode before assign irqfd")
c9bcd3e3335d ("kvm: svm/avic: fix off-by-one in checking host APIC ID")
b68f3cc7d978 ("KVM: x86: Always use 32-bit SMRAM save state for 32-bit kernels")
1811d979c716 ("x86/kvm: move kvm_load/put_guest_xcr0 into atomic context")
99c221796a81 ("KVM: x86: svm: make sure NMI is injected after nmi_singlestep")
4a58038b9e42 ("Revert "svm: Fix AVIC incomplete IPI emulation"")
bc8a3d8925a8 ("kvm: mmu: Fix overflow on kvm mmu page limit calculation")
ede885ecb2cd ("kvm: svm: fix potential get_num_contig_pages overflow")
92da008fa210 ("Revert "KVM/MMU: Flush tlb directly in the kvm_zap_gfn_range()"")
de3ccd26fafc ("KVM: MMU: record maximum physical address width in kvm_mmu_extended_role")
511da98d207d ("kvm: x86: Return LA57 feature based on hardware capability")
ddfd1730fd82 ("KVM: x86/mmu: Do not cache MMIO accesses while memslots are in flux")
152482580a1b ("KVM: Call kvm_arch_memslots_updated() before updating memslots")
8570f9e881e3 ("KVM: nVMX: Apply addr size mask to effective address for VMX instructions")
6b1971c69497 ("x86/kvm/nVMX: read from MSR_IA32_VMX_PROCBASED_CTLS2 only when it is available")
0e0ab73c9a02 ("KVM: VMX: Zero out *all* general purpose registers after VM-Exit")
61c08aa9606d ("KVM: VMX: Compare only a single byte for VMCS' "launched" in vCPU-run")
107352a24900 ("arm/arm64: KVM: vgic: Force VM halt when changing the active state of GICv3 PPIs/SGIs")
0e1b869fff60 ("kvm: x86: Add AMD's EX_CFG to the list of ignored MSRs")
dcbd3e49c2f0 ("KVM: X86: Fix NULL deref in vcpu_scan_ioapic")
bea2ef803ade ("KVM: arm/arm64: vgic: Cap SPIs to the VM-defined maximum")
2e2f6c3c0b08 ("KVM: arm/arm64: vgic: Do not cond_resched_lock() with IRQs disabled")
60c3ab30d8c2 ("KVM: arm/arm64: vgic-v2: Set active_source to 0 when restoring state")
1b3ab5ad1b8a ("KVM: nVMX: Free the VMREAD/VMWRITE bitmaps if alloc_kvm_area() fails")
fd65d3142f73 ("kvm: svm: Ensure an IBPB on all affected CPUs when freeing a vmcb")
30510387a5e4 ("svm: Add mutex_lock to protect apic_access_page_done on AMD systems")
a7c42bb6da6b ("x86/kvm/lapic: preserve gfn_to_hva_cache len on cache reinit")
6c3dfeb6a48b ("KVM: x86: Do not re-{try,execute} after failed emulation in L2")
472faffacd90 ("KVM: x86: Default to not allowing emulation retry in kvm_mmu_page_fault")
384bf2218e96 ("KVM: x86: Merge EMULTYPE_RETRY and EMULTYPE_ALLOW_REEXECUTE")
8065dbd1ee0e ("KVM: x86: Invert emulation re-execute behavior to make it opt-in")
d806afa495e2 ("x86/kvm/vmx: Fix coding style in vmx_setup_l1d_flush()")
44883f01fe6a ("KVM: x86: ensure all MSRs can always be KVM_GET/SET_MSR'd")
d97e5e6160c0 ("kvm, mm: account shadow page tables to kmemcg")
c4d2188206ba ("KVM: x86: Update cpuid properly when CR4.OSXAVE or CR4.PKE is changed")
0aa48468d009 ("KVM/VMX: Expose SSBD properly to guests")
ecf08dad723d ("KVM: x86: remove APIC Timer periodic/oneshot spikes")
f0cf47d939d0 ("KVM: arm/arm64: Close VMID generation race")
3140c156e919 ("kvm: x86: fix a compile warning")
76600428c367 ("KVM: arm/arm64: Reduce verbosity of KVM init log")
95e057e25892 ("KVM: X86: Fix SMRAM accessing even if VM is shutdown")
946fbbc13dce ("KVM/VMX: Optimize vmx_vcpu_run() and svm_vcpu_run() by marking the RDMSR path as unlikely()")
7839c672e58b ("KVM: arm/arm64: Fix HYP unmapping going off limits")
b1394e745b94 ("KVM: x86: fix APIC page invalidation")
f775b13eedee ("x86,kvm: move qemu/guest FPU switching out to vcpu_run")
fc396e066318 ("KVM: arm/arm64: Fix broken GICH_ELRSR big endian conversion")
12806ba93738 ("KVM: lapic: Fixup LDR on load in x2apic")
e872fa94662d ("KVM: lapic: Split out x2apic ldr calculation")
8c1a8a32438b ("KVM: arm64: its: Fix missing dynamic allocation check in scan_its_table")
a2b7861bb33b ("kvm/x86: Avoid async PF preempting the kernel incorrectly")
31afb2ea2b10 ("KVM: VMX: simplify and fix vmx_vcpu_pi_load")
8b306e2f3c41 ("KVM: VMX: avoid double list add with VT-d posted interrupts")
cd39e1176d32 ("KVM: VMX: extract __pi_post_block")
e323369b2e20 ("kvm-vfio: Decouple only when we match a group")
e2c2206a1899 ("KVM: x86: Fix potential preemption when get the current kvmclock timestamp")
0c428a6a9256 ("kvm: arm/arm64: Fix use after free of stage2 page table")
63cb6d5f004c ("KVM: nVMX: Fix nested VPID vmx exec control")
370a0ec18199 ("KVM: arm/arm64: Let vcpu thread modify its own active state")
0bdbf3b07198 ("KVM: arm/arm64: vgic: Stop injecting the MSI occurrence twice")
1193e6aeecb3 ("KVM: arm/arm64: vgic: Fix deadlock on error handling")
112b0b8f8f6e ("KVM: arm/arm64: vgic: Prevent access to invalid SPIs")
6fe407f2d18a ("KVM: arm64: Require in-kernel irqchip for PMU support")
080fe0b790ad ("perf/x86/amd: Make HW_CACHE_REFERENCES and HW_CACHE_MISSES measure L2")
6a907cd0ad31 ("Revert "KVM: SVM: fix trashing of MSR_TSC_AUX"")
c43203cab1e2 ("KVM: x86: avoid simultaneous queueing of both IRQ and SMI")

--XC4kXOdy3KNRTgVj--
